//
//  ViewController.swift
//  HireDevs
//
//  Created by Darren Asamov on 20/12/2021.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var SV: UIScrollView!
    
    var employees = [Employee]()
    let HREmployee = Employee()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passTF.delegate = self
        spinner.isHidden = true
        
        employees = Employee.getAllEmployees()!
        fillMainHRTeamAccount()
        if employees.isEmpty {
            Employee.createEmployee(employee: HREmployee)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true {
            let vc = self.storyboard?.instantiateViewController(identifier: "candidateListVC") as! CandidateListVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc,animated: false)
        }
        view.backgroundColor = getRandomColor()
        initializeHideKeyboard()
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        emailTF.endEditing(true)
        passTF.endEditing(true)
        loginButton.isEnabled = false
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(enableButton), userInfo: nil, repeats: false)
        
        if emailTF.text!.isValidEmail && passTF.text!.isValidPassword {
            
            let employee = Employee()
            employee.email = emailTF.text!
            employee.password = passTF.text!
            
            let currentStatus = Employee.lookingForEmployee(employee: employee)
            if currentStatus == "HR" {
                confirmationLogIN()
                
            } else {
                wrongAccount(status: currentStatus)
            }
        } else {
            if !emailTF.text!.isValidEmail {
                changeBorderToRed(textField: emailTF)
            }
            if !passTF.text!.isValidPassword {
                changeBorderToRed(textField: passTF)
            }
        }
    }
    
    func fillMainHRTeamAccount(){
        HREmployee.name = "HRTeam"
        HREmployee.surname = "edynamix"
        HREmployee.email = "HRTeam@edynamix.com"
        HREmployee.password = "Edynamix1!"
        HREmployee.status = "HR"
    }
    
    func wrongAccount(status: String) {
        let dialog = UIAlertController(title: "This account has status \(status)", message: "Please select an HR account to log in!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        dialog.addAction(ok)
        self.present(dialog, animated: true, completion: nil)
    }
    var checkmarkFromDialogWasTapped = false
    func confirmationLogIN() {
        //MARK: With dialog
        
//        let popup = self.storyboard?.instantiateViewController(identifier: "customDialogVC") as! CustomDialogVC
//        popup.dialogTitle = "Are you sure you want to log in?"
//        popup.delegate = self
//        self.present(popup, animated: true)
//        if checkmarkFromDialogWasTapped {
//            loginButton.isHidden = true
//            spinner.isHidden = false
//            spinner.startAnimating()
//            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(goToCandidateListVC), userInfo: nil, repeats: false)
//        }
        
        //MARK: With AlertController
        let checkMark = UIImage(systemName: "checkmark")
        let crossMark = UIImage(systemName: "xmark")
        let alert = UIAlertController(title: "Log in", message: "Are you sure you want to log in?", preferredStyle: .alert)
        let tick = UIAlertAction(title: "Yes", style: .default, handler: { [self](action) -> Void in
            loginButton.isHidden = true
            spinner.isHidden = false
            spinner.startAnimating()
            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(goToCandidateListVC), userInfo: nil, repeats: false)
        })
        tick.setValue(checkMark, forKey: "image")
        let cross = UIAlertAction(title: "No", style: .cancel, handler: nil)
        cross.setValue(crossMark, forKey: "image")
        alert.addAction(tick)
        alert.addAction(cross)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func enableButton() {
        loginButton.isEnabled = true
    }
    
    func stopSpinner() {
        loginButton.isHidden = false
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
    }
    
    @objc func goToCandidateListVC() {
        stopSpinner()
        goToNextScreen(identifier: "candidateListVC")
        emailTF.text = ""
        passTF.text = ""
        UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
    }
}

extension LoginVC: PopupDelegate {
    func popupValueSelected(value: Bool) {
        checkmarkFromDialogWasTapped = value
    }
}
