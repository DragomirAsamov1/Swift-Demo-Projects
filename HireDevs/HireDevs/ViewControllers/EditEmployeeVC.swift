//
//  EditEmployeeVC.swift
//  HireDevs
//
//  Created by Darren Asamov on 12/01/2022.
//

import UIKit
import iOSDropDown

class EditEmployeeVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var statusDropDown: DropDown!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passTF.delegate = self
        nameTF.delegate = self
        surnameTF.delegate = self
        statusDropDown.delegate = self
        view.backgroundColor = getRandomColor()
        statusDropDown.optionArray = ["Administrator", "HR", "Developer", "Manager", "Support"]
        initializeHideKeyboard()
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        returnToPreviousScreen()
    }
    
    //MARK: Missing Logic
    @IBAction func didTapSave(_ sender: UIButton) {
        if !emailTF.text!.isEmpty && !passTF.text!.isEmpty && !nameTF.text!.isEmpty && !surnameTF.text!.isEmpty && !statusDropDown.text!.isEmpty {
            
            // TODO: Edit Employee object in Realm
            
            returnToPreviousScreen()
        } else {
            checkForEmpty(emailTF)
            checkForEmpty(passTF)
            checkForEmpty(nameTF)
            checkForEmpty(surnameTF)
            checkForEmpty(statusDropDown)
        }
        
    }
}
