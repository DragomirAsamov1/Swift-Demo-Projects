//
//  DataViewController.swift
//  DoggoApplication
//
//  Created by Darren Asamov on 06/10/2021.
//

import RealmSwift
import UIKit

class PeopleVC: UIViewController{
    
    @IBOutlet weak var firstName: UITextField!
    
    var dogList: [Dog] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        dogList = [Dog]()
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        if !firstName.text!.isEmpty {
            let human = People(name: firstName.text!, dogs: dogList)
            for dog in dogList {
                Dog.createDog(dog: dog)
            }
            People.create(person: human)
        }
        backToMainVC()
    }
    @IBAction func didTapBack(_ sender: UIButton) {
        backToMainVC()
    }
    @IBAction func AddDogButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "dogvc") as! DogVC
        vc.objectDelegate = self
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: false, completion: nil)
    }
    func backToMainVC() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    func deleteAloneDogs (doglist: [Dog]) {
        for dog in dogList {
            Dog.deleteDog(dog: dog)
        }
    }
}

extension PeopleVC: DogObjectDelegate {
    func didFillProperty(dog: Dog) {
        dogList.append(dog)
        print(dogList)
    }
}
