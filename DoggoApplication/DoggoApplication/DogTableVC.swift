//
//  DogTableVC.swift
//  DoggoApplication
//
//  Created by Darren Asamov on 25/10/2021.
//

import UIKit
import RealmSwift

class DogTableVC: UIViewController {
    @IBOutlet weak var dogTableView: UITableView!
    
    var dogList: [Dog] = [Dog]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dogTableView.dataSource = self
    }
    @IBAction func didTapBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
}

extension DogTableVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dogCell", for: indexPath)
        cell.textLabel?.text = dogList[indexPath.row].name
        return cell
    }
}
