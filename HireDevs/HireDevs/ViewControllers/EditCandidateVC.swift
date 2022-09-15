//
//  EditCandidateVC.swift
//  HireDevs
//
//  Created by Darren Asamov on 14/01/2022.
//

import UIKit

class EditCandidateVC: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var positionTF: UITextField!
    @IBOutlet weak var interviewDate: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.delegate = self
        surnameTF.delegate = self
        phoneNumberTF.delegate = self
        positionTF.delegate = self
        interviewDate.delegate = self
        view.backgroundColor = getRandomColor()
        doneToolbarButton(textField: phoneNumberTF)
        setupDatePicker()
        initializeHideKeyboard()
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        returnToPreviousScreen()
    }
    @IBAction func didTapSave(_ sender: UIButton) {
        if !nameTF.text!.isEmpty && !surnameTF.text!.isEmpty && !phoneNumberTF.text!.isEmpty && !positionTF.text!.isEmpty && !interviewDate.text!.isEmpty {
//                saveCandidate()
            returnToPreviousScreen()
        } else {
            checkForEmpty(nameTF)
            checkForEmpty(surnameTF)
            checkForEmpty(phoneNumberTF)
            checkForEmpty(positionTF)
            checkForEmpty(interviewDate)
        }
    }
    
    func setupDatePicker() {
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 72))
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        interviewDate.inputView = datePicker
        
        doneToolbarButton(textField: interviewDate)
    }
    
    @objc func dateChanged() {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy HH:mm"
        interviewDate.text = dateFormat.string(from: datePicker!.date)
    }
    
    func doneToolbarButton(textField: UITextField) {
        let toolbar: UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 26))
        toolbar.sizeToFit()
        let spaceButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButtom: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.tapOnDoneButton))
        toolbar.setItems([spaceButton, doneButtom], animated: true)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func tapOnDoneButton() {
        if interviewDate.isEditing {
            interviewDate.resignFirstResponder()
        } else if phoneNumberTF.isEditing {
            phoneNumberTF.resignFirstResponder()
            positionTF.becomeFirstResponder()
        }
    }
}

extension EditCandidateVC: CandidateObjectDelegate {
    func didFillCandidateObject(name: String, surname: String, number: String, jobApplication: String, date: String) {
        nameTF.text = name
        surnameTF.text = surname
        phoneNumberTF.text = number
        positionTF.text = jobApplication
        interviewDate.text = date
    }
    
//    func didFillCandidateObject(candidate: Candidate) {
//        nameTF.text = candidate.name
//        surnameTF.text = candidate.surname
//        phoneNumberTF.text = candidate.phoneNumber
//        positionTF.text = candidate.jobPosition
//        interviewDate.text = candidate.dateOfInterview
//    }
}
