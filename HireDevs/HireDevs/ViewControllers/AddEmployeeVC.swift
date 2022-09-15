//
//  AddEmployeeVC.swift
//  HireDevs
//
//  Created by Darren Asamov on 01/01/2022.
//

import UIKit
import iOSDropDown

class AddEmployeeVC: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var status: DropDown!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passTF.delegate = self
        nameTF.delegate = self
        surnameTF.delegate = self
        status.delegate = self
        status.optionArray = ["Administrator", "HR", "Developer", "Manager", "Support"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = getRandomColor()
        initializeHideKeyboard()
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        returnToPreviousScreen()
    }
    @IBAction func didTapComplete(_ sender: UIButton) {
        if !emailTF.text!.isEmpty && !passTF.text!.isEmpty && !nameTF.text!.isEmpty && !surnameTF.text!.isEmpty && !status.text!.isEmpty {
            if emailTF.text!.isValidEmail && passTF.text!.isValidPassword {
                let employee = Employee(email: emailTF.text!, password: passTF.text!, name: nameTF.text!, surname: surnameTF.text!, status: status.text!)
                Employee.createEmployee(employee: employee)
                returnToPreviousScreen()
            } else {
                let dialog = UIAlertController(title: "Invalid format!", message: "The email or password doesn't meet the requirements!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                dialog.addAction(ok)
                self.present(dialog, animated: true, completion: nil)
            }
        } else {
            missedFieldDialog()
            checkForEmpty(emailTF)
            checkForEmpty(passTF)
            checkForEmpty(nameTF)
            checkForEmpty(surnameTF)
            checkForEmpty(status)
        }
    }
    
    @IBAction func didTapShowEmployees(_ sender: UIButton) {
        goToNextScreen(identifier: "employeeListVC")
    }
    
    func missedFieldDialog() {
        let dialog = UIAlertController(title: "You have missed a field!", message: "Please fill all required fields!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        dialog.addAction(ok)
        self.present(dialog, animated: true, completion: nil)
    }
}
