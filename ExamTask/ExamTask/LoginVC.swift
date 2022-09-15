//
//  ViewController.swift
//  ExamTask
//
//  Created by Darren Asamov on 28/10/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

var isLoggedIn: Bool?

protocol BookingObjectDelegate {
    func didFillProperty(booking: Bookings)
}

class LoginVC: UIViewController {
    var searching = false
    var emailSuggestions: [String] = []
    var passwordSuggestions: [String] = []
    var serNumSuggestions: [String] = []
    
    var filteredSuggestions = [String]()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var serialNumberTextField: UITextField!
    @IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var backgroundSV: UIScrollView!

    @IBOutlet weak var emailSuggestionTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passTextField.delegate = self
        serialNumberTextField.delegate = self
        
        emailSuggestionTable.delegate = self
        emailSuggestionTable.dataSource = self

        emailTextField.tag = 1
        passTextField.tag = 2
        serialNumberTextField.tag = 3
        
        emailTextField.addTarget(self, action: #selector(searchRecord), for: .editingChanged)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))
        initializeHideKeyboard()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotification()
    }
    
    @IBAction func LoginButton(_ sender: UIButton) {
        emailFieldValidation(textField: emailTextField)
        passwordFieldValidation(textField: passTextField)
        serialNumberFieldValidation(textField: serialNumberTextField)
        
        
        if isTextFieldValid(textField: emailTextField) && isTextFieldValid(textField: passTextField) && isTextFieldValid(textField: serialNumberTextField) == true {
            APILoginQuery()
        } else {
            myButton.isEnabled = false
        }
    }
    
    @objc func searchRecord(sender: UITextField) {
        self.filteredSuggestions.removeAll()
        let searchData: Int = emailTextField.text!.count
        if searchData != 0 {
            searching = true
            for email in emailSuggestions {
                if let emailToSearch = emailTextField.text {
                    let range = email.lowercased().range(of: emailToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil {
                        self.filteredSuggestions.append(email)
                    }
                }
            }
        } else {
            filteredSuggestions = emailSuggestions
            searching = false
        }
        emailSuggestionTable.reloadData()
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func APILoginQuery () {
        let requestDict: [String: String] = ["email": emailTextField.text!, "password": passTextField.text!, "serialNumber": serialNumberTextField.text!]
        AF.request("https://api.autopointlockers.com/api/Login/Authenticate", method: .post, parameters: requestDict, encoding: URLEncoding.default).responseJSON {[self] response in
            let statusCode = response.response!.statusCode
            switch response.result {
            case .success(let value):
                if statusCode >= 200 && statusCode < 300 {
                    if !emailSuggestions.contains(emailTextField.text!) {
                        emailSuggestions.insert(emailTextField.text!, at: 0)
                        passwordSuggestions.insert(passTextField.text!, at: 0)
                        serNumSuggestions.insert(serialNumberTextField.text!, at: 0)
                    }
                    UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
                    UserDefaults.standard.synchronize()
                    let json = JSON(value)
                    let token = json["Token"].stringValue
                    self.APIBookingObject(token: token)
                    print("Token:", token)
                } else {
                    self.displayAlertIncorrectLoginData()
                    return
                }
            case .failure:
                return
            }
        }
    }
    
    func APIBookingObject (token: String) {
        
        Bookings.deleteAllBookings()
        
        let requestDict: [String: String] = [" ":" "]
        let bookingUrl = "https://api.autopointlockers.com/api/Locker/Heartbeat"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        AF.request(bookingUrl, method: .post, parameters: requestDict, encoding: URLEncoding.default, headers: headers).responseJSON {response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                
                let vc = self.storyboard?.instantiateViewController(identifier: "bookingTable") as! TableVC
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
                self.view.window!.layer.add(transition, forKey: kCATransition)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: false, completion: nil)
                self.willEmptyTextFields()
                do {
                    let bookingObjects = json["Bookings"].rawString()
                    let bookingData = bookingObjects!.data(using: .utf8)!
                    let items: [Bookings] = try JSONDecoder().decode(Array<Bookings>.self, from: bookingData)
                    for object in items {
                        Bookings.createBooking(booking: object)
                    }
                } catch {
                    print(error)
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func emailFieldValidation(textField: UITextField) {
        if emailTextField.text!.isValidEmail && !emailTextField.text!.isEmpty {
            emailTextField.layer.borderWidth = 0.0
        } else {
            changeBorderToRed(textField: emailTextField)
        }
    }
    func passwordFieldValidation(textField: UITextField) {
        if passTextField.text!.isEmpty {
            changeBorderToRed(textField: passTextField)
        } else {
            passTextField.layer.borderWidth = 0.0
        }
    }
    func serialNumberFieldValidation(textField: UITextField) {
        if serialNumberTextField.text!.isEmpty {
            changeBorderToRed(textField: serialNumberTextField)
        } else {
            serialNumberTextField.layer.borderWidth = 0.0
        }
    }
    
    func changeBorderToRed(textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.red.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case passTextField:
            let newLength: Int = textField.text!.count + string.count - range.length
            return newLength <= 20
        case serialNumberTextField:
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: "0123456789").inverted
            let strValid = string.rangeOfCharacter(from: numberOnly) == nil
            return (strValid && (newLength <= 10))
        default:
            return true
        }
    }
    
    func isTextFieldValid(textField: UITextField) -> Bool {
        if textField.layer.borderWidth == 0.0 && !textField.text!.isEmpty {
            return true
        }
        return false
    }
    
    func displayAlertIncorrectLoginData() {
        let alert = UIAlertController(title: "Access denied", message: "Incorrect email address, password or serial number!", preferredStyle: .alert)
        let ok  = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func willEmptyTextFields() {
        emailTextField.text = nil
        passTextField.text = nil
        serialNumberTextField.text = nil
    }
}

extension String {
   var isValidEmail: Bool {
      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
      return testEmail.evaluate(with: self)
   }
}
extension LoginVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailFieldValidation(textField: emailTextField)
            emailSuggestionTable.isHidden = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        myButton.isEnabled = true
        if textField == emailTextField {
            emailSuggestionTable.isHidden = false
        }
//        else {emailSuggestionTable.isHidden = true }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

extension LoginVC {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

extension LoginVC {
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        if
            let scrollView = backgroundSV, let userInfo = notification.userInfo,
            let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey],
            let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey],
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
            
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            scrollView.contentInset.bottom = keyboardOverlap
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardOverlap
            scrollView.horizontalScrollIndicatorInsets.bottom = keyboardOverlap
            
            let duration = (durationValue as AnyObject).doubleValue
            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
extension LoginVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        emailTextField.text = emailSuggestions[indexPath.row]
        passTextField.text = passwordSuggestions[indexPath.row]
        serialNumberTextField.text = serNumSuggestions[indexPath.row]
        tableView.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LoginVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if emailSuggestions.isEmpty {
            emailSuggestionTable.isHidden = true
        }
        while emailSuggestions.count > 3 {
            emailSuggestions.removeLast()
            passwordSuggestions.removeLast()
            serNumSuggestions.removeAll()
        }
        if searching {
            return filteredSuggestions.count
        } else {
            return emailSuggestions.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if searching {
            cell.textLabel?.text = filteredSuggestions[indexPath.row]
        } else {
            cell.textLabel?.text = emailSuggestions[indexPath.row]
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .blue
        }
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

