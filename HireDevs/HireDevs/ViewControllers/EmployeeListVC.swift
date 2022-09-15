//
//  EmployeeListVC.swift
//  HireDevs
//
//  Created by Darren Asamov on 09/01/2022.
//

import UIKit

class EmployeeCell: UITableViewCell {
    
    @IBOutlet weak var nameLabelInCell: UILabel!
    @IBOutlet weak var surnameLabelInCell: UILabel!
    @IBOutlet weak var statusLabelInCell: UILabel!
}

class EmployeeListVC: UIViewController {

    @IBOutlet weak var employeeTable: UITableView!
    
    var employees: [Employee] = [Employee]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = getRandomColor()
        employees = Employee.getAllEmployees()!
        employeeTable.delegate = self
        employeeTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        employees = Employee.getAllEmployees()!
        employeeTable.reloadData()
    }
    @IBAction func didTapBack(_ sender: UIButton) {
        returnToPreviousScreen()
    }
}

extension EmployeeListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EmployeeListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeCell
        cell.nameLabelInCell.text = employees[indexPath.row].name
        cell.surnameLabelInCell.text = employees[indexPath.row].surname
        cell.statusLabelInCell.text = employees[indexPath.row].status
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completionHandler) in
            completionHandler(true)
            Employee.deleteEmployee(employees[indexPath.row])
            employees.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
        }
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red
        
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { [self] (aciton, view, completionHandler) in
            goToNextScreen(identifier: "editEmployeeVC")
            completionHandler(true)
        }
        edit.image = UIImage(systemName: "pencil")
        edit.backgroundColor = .blue
        
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipe
    }
}
