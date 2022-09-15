//
//  TableVC.swift
//  ExamTask
//
//  Created by Darren Asamov on 28/10/2021.
//

import UIKit
import RealmSwift

class TableVC: UIViewController {
    
    var bookingObjectsArray: [Bookings] = [Bookings]()
    
    @IBOutlet weak var vehicleRegTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        vehicleRegTableView.delegate = self
        vehicleRegTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        vehicleRegTableView.delegate = self
//        vehicleRegTableView.dataSource = self
        bookingObjectsArray = Bookings.getAllBookings()!
        for bookingObject in bookingObjectsArray {
            if bookingObject.VehicleReg.isEmpty {
                Bookings.deleteBooking(booking: bookingObject)
            }
        }
        bookingObjectsArray.removeAll(where: {book in book.VehicleReg == ""})
    }
    @IBAction func didTapLogOut(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        logOut()
    }

    func getRandomFrom0to1() -> CGFloat {
        let randomInt = arc4random()
        return CGFloat(randomInt)/CGFloat(UInt32.max)
    }
    var vehicleRegLetterColor = UIColor.black
    func getRandomColor() -> UIColor{
        vehicleRegLetterColor = UIColor(red: getRandomFrom0to1(), green: getRandomFrom0to1(), blue: getRandomFrom0to1(), alpha: 1)
        return vehicleRegLetterColor
    }
    @IBAction func ChangeColor(_ sender: UIButton){
        getRandomColor()
        vehicleRegTableView.reloadData()
    }
    func logOut() {
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
}

extension TableVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension TableVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingObjectsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = bookingObjectsArray[indexPath.row].VehicleReg
        cell.textLabel?.textColor = getRandomColor()
        return cell
    }
}
