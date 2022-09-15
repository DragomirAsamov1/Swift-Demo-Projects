//
//  AddCandidateVC.swift
//  HireDevs
//
//  Created by Darren Asamov on 23/12/2021.
//

import UIKit

class AddCandidateVC: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var positionTF: UITextField!
    @IBOutlet weak var interviewDate: UITextField!
    @IBOutlet weak var professionalSkills: UITextView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var activeTextField: UITextField?
    var activeTextView: UITextView?
    var datePicker: UIDatePicker!
    let candidateID = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.delegate = self
        surnameTF.delegate = self
        phoneNumberTF.delegate = self
        positionTF.delegate = self
        interviewDate.delegate = self
        addRedAsterisk(textField: nameTF)
        addRedAsterisk(textField: surnameTF)
        addRedAsterisk(textField: phoneNumberTF)
        addRedAsterisk(textField: positionTF)
        addRedAsterisk(textField: interviewDate)
        professionalSkills.delegate = self
        setupDatePicker()
        professionalSkills.text = "Profesional skills:"
        professionalSkills.textColor = UIColor.systemGray3
        professionalSkills.font = UIFont(name: "verdana", size: 14.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = getRandomColor()
        initializeHideKeyboard()
    }
    
    @IBAction func didTapContinue(_ sender: UIButton) {
        if !nameTF.text!.isEmpty && !surnameTF.text!.isEmpty && !phoneNumberTF.text!.isEmpty && !positionTF.text!.isEmpty && !interviewDate.text!.isEmpty {
            if professionalSkills.text == "Profesional skills:" {
                professionalSkills.text = ""
            }
                saveCandidate()
        } else {
            checkForEmpty(nameTF)
            checkForEmpty(surnameTF)
            checkForEmpty(phoneNumberTF)
            checkForEmpty(positionTF)
            checkForEmpty(interviewDate)
        }
    }
    @IBAction func didTapBack(_ sender: UIButton) {
        returnToPreviousScreen()
    }
    
    func addRedAsterisk(textField: UITextField) {
        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.red
        attributes[NSAttributedString.Key.font] = UIFont(name: "verdana", size: 18)
        let attributedString = NSMutableAttributedString(string: textField.placeholder!)
        let asterisk = NSAttributedString(string: "*", attributes: attributes)
        attributedString.append(asterisk)
        textField.attributedPlaceholder = attributedString
    }
    
    func saveCandidate() {
        let person = Candidate()
        if let candidateName = nameTF.text,
           let candidateSurname = surnameTF.text,
           let candidateNumber = phoneNumberTF.text,
           let candidateJobPosition = positionTF.text,
           let candidateDateOfInterview = interviewDate.text,
           let candidateProfSkills = professionalSkills?.text {
            person.id = candidateID
            person.name = candidateName
            person.surname = candidateSurname
            person.phoneNumber = candidateNumber
            person.jobPosition = candidateJobPosition
            person.dateOfInterview = candidateDateOfInterview
            person.professionalSkills = candidateProfSkills
            
        }
        Candidate.createCandidate(candidate: person)
        returnToPreviousScreen()
        
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
    }
    
    @objc func dateChanged() {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy HH:mm"
        interviewDate.text = dateFormat.string(from: datePicker!.date)
    }
}

extension AddCandidateVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Profesional skills:" {
                    textView.text = ""
                    textView.textColor = UIColor.black
                    textView.font = UIFont(name: "verdana", size: 14.0)
                }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Profesional skills:"
            textView.textColor = UIColor.systemGray3
        }
    }
}

