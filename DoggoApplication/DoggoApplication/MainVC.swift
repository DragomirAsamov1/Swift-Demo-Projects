//
//  ViewController.swift
//  DoggoApplication
//
//  Created by Darren Asamov on 06/10/2021.
//

import RealmSwift
import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var peopleTableView: UITableView!
    var humans: [People] = [People]()
    var dogList: [Dog] = [Dog]()
    var tableFooterView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        humans = People.getAllPeople()!
        dogList = Dog.getAllDogs()!
        
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        humans = People.getAllPeople()!
        dogList.removeAll()
        self.peopleTableView.reloadData()
        
    }
    @IBAction func didTapButton(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(identifier: "peoplevc") as! PeopleVC
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: false, completion: nil)
        }
    }

extension MainVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dogsOwner = humans[indexPath.row].dogs
        for dog in dogsOwner {
            dogList.append(dog)
        }
        performSegue(withIdentifier: "showdogs", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showdogs" {
            let vc = storyboard?.instantiateViewController(identifier: "dogTableVC") as! DogTableVC
            vc.dogList = self.dogList
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            vc.modalPresentationStyle = .fullScreen
            present(vc,animated: false, completion: nil)
        }
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return humans.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = humans[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            for dog in humans[indexPath.row].dogs {
                Dog.deleteDog(dog: dog)
            }
            People.deletePerson(person: humans[indexPath.row])
            humans.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension MainVC: DogObjectDelegate {
    func didFillProperty(dog: Dog) {
        dogList.append(dog)
    }
}

extension UITableView {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.tableFooterView = UIView()
    }
}
