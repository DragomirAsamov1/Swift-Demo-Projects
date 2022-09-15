//
//  Dog View ControllerViewController.swift
//  DoggoApplication
//
//  Created by Darren Asamov on 13/10/2021.
//

import UIKit

protocol DogObjectDelegate {
    func didFillProperty(dog: Dog)
}

class DogVC: UIViewController, UITextFieldDelegate {
    
    var objectDelegate: DogObjectDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogNameField.delegate = self
        dogAgeField.delegate = self
    }
    @IBOutlet weak var dogNameField: UITextField!
    @IBOutlet weak var dogAgeField: UITextField!
    let dogID = UUID().uuidString
    @IBAction func didTapSave(_ sender: UIButton) {
        if !dogNameField.text!.isEmpty && !dogAgeField.text!.isEmpty {
            let puppy = Dog()
            if let dogName = dogNameField.text, let dogAge = dogAgeField.text {
                puppy.name = dogName
                puppy.age = Int(dogAge)!
                puppy.dogID = dogID
            }
            objectDelegate.didFillProperty(dog: puppy)
        }
        backToPeopleVC()
    }
    @IBAction func didTapBack(_ sender: UIButton) {
        backToPeopleVC()
    }
    func backToPeopleVC() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case dogNameField:
            let newLength: Int = textField.text!.count + string.count - range.length
                return newLength <= 10
        case dogAgeField:
            let newLength: Int = textField.text!.count + string.count - range.length
                        let numberOnly = NSCharacterSet.init(charactersIn: "0123456789").inverted
                        let strValid = string.rangeOfCharacter(from: numberOnly) == nil
                        return (strValid && (newLength <= 2))
        default:
            return true
        }
    }
}
