//
//  Extensions.swift
//  HireDevs
//
//  Created by Darren Asamov on 20/12/2021.
//

import UIKit

extension String {
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    var isValidPassword: Bool {
        let regularExpressionForPassword = "(?=^.{9,23}$)(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#\\\\/'.,])(?!.*\\s).*$"
        let passTest = NSPredicate(format: "SELF MATCHES %@", regularExpressionForPassword)
        return passTest.evaluate(with: self)
    }
}

func changeBorderToRed(textField: UITextField) {
    textField.layer.borderWidth = 1.0
    textField.layer.borderColor = UIColor.red.cgColor
}

func checkForEmpty(_ textField: UITextField) {
    if textField.text!.isEmpty {
        changeBorderToRed(textField: textField)
    }
}

func getRandomFrom0to1() -> CGFloat {
    let randomInt = arc4random()
    return CGFloat(randomInt)/CGFloat(UInt32.max)
}

var randomColor = UIColor()
func getRandomColor() -> UIColor{
    randomColor = UIColor(red: getRandomFrom0to1(), green: getRandomFrom0to1(), blue: getRandomFrom0to1(), alpha: 1)
    return randomColor
}

extension UITableView {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.tableFooterView = UIView()
    }
}

extension UIViewController {
    
    func goToNextScreen(identifier: String) {
        let vc = self.storyboard?.instantiateViewController(identifier: identifier)
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!,animated: false, completion: nil)
    }
    
    func returnToPreviousScreen() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.layer.borderWidth = 0.0
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            changeBorderToRed(textField: textField)
        }
    }
}

