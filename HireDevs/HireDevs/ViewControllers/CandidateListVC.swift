//
//  CandidateListVC.swift
//  HireDevs
//
//  Created by Darren Asamov on 22/12/2021.
//

import UIKit
protocol CandidateObjectDelegate {
    func didFillCandidateObject(name: String, surname: String, number: String, jobApplication: String, date: String)
}

class TableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabelInCell: UILabel!
    @IBOutlet weak var surnameLabelInCell: UILabel!
    @IBOutlet weak var numberLabelInCell: UILabel!
    @IBOutlet weak var applicationLabelInCell: UILabel!
    @IBOutlet weak var dateLabelInCell: UILabel!
}
class CandidateListVC: UIViewController {
    
    @IBOutlet weak var addEmployeeButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var addCandidateButton: UIButton!
    @IBOutlet weak var candidateTV: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var applicationLabel: UILabel!
    @IBOutlet weak var interviewDateLabel: UILabel!
    
    var objectDelegate: CandidateObjectDelegate!
    
    var candidates: [Candidate] = [Candidate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        candidates = Candidate.getAllCandidates()!
        candidateTV.delegate = self
        candidateTV.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        candidates = Candidate.getAllCandidates()!
        self.candidateTV.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = getRandomColor()
        addEmployeeButton.setAttributedTitle(colorString(input: addEmployeeButton.title(for: .normal)!), for: .normal)
        logOutButton.setAttributedTitle(colorString(input: logOutButton.title(for: .normal)!), for: .normal)
        addCandidateButton.setAttributedTitle(colorString(input: addCandidateButton.title(for: .normal)!), for: .normal)
        nameLabel.attributedText = colorString(input: nameLabel.text!)
        surnameLabel.attributedText = colorString(input: surnameLabel.text!)
        phoneNumberLabel.attributedText = colorString(input: phoneNumberLabel.text!)
        applicationLabel.attributedText = colorString(input: applicationLabel.text!)
        interviewDateLabel.attributedText = colorString(input: interviewDateLabel.text!)
    }
    @IBAction func didTapAddCandidate(_ sender: UIButton) {
        goToNextScreen(identifier: "addCandidateVC")
    }
    @IBAction func didTapAddEmployee(_ sender: UIButton) {
        goToNextScreen(identifier: "аddEmployeeVC")
    }
    @IBAction func didTapLogout(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
        returnToPreviousScreen()
    }
    
    func currentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    func colorString(input: String) -> NSAttributedString {
        var coloredString = NSMutableAttributedString()
        coloredString = NSMutableAttributedString(string: input)
        var i = 0
        for _ in input {
            coloredString.addAttribute(NSAttributedString.Key.foregroundColor, value: getRandomColor(), range: NSRange(location: i,length: 1))
            i += 1
        }
        return coloredString
    }
}

extension CandidateListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var title = ""
        var message = ""
            var currentDialog = UIAlertController()
            if candidates[indexPath.row].professionalSkills!.isEmpty {
                title = "No professional skills have been added!"
                message = "Do you want to enter professional skills?"
                currentDialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                    // Add Logic
                })
                let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
                currentDialog.addAction(yes)
                currentDialog.addAction(no)
            } else {
                title = "Professional skills:"
                message = candidates[indexPath.row].professionalSkills!
                currentDialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                currentDialog.addAction(ok)
            }
        self.present(currentDialog, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension CandidateListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell
        
        cell.nameLabelInCell.attributedText = colorString(input: candidates[indexPath.row].name)
        cell.surnameLabelInCell.attributedText = colorString(input: candidates[indexPath.row].surname)
        cell.numberLabelInCell.attributedText = colorString(input: candidates[indexPath.row].phoneNumber)
        cell.applicationLabelInCell.attributedText = colorString(input: candidates[indexPath.row].jobPosition)
        cell.dateLabelInCell.attributedText = colorString(input: candidates[indexPath.row].dateOfInterview)
        
        if cell.dateLabelInCell.text! < currentDate() {
            Candidate.deleteCandidate(candidates[indexPath.row])
            candidates.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completionHandler) in
            completionHandler(true)
            Candidate.deleteCandidate(candidates[indexPath.row])
            candidates.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
        }
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red
        
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { [self] (aciton, view, completionHandler) in
            goToNextScreen(identifier: "editCandidateVC")
            completionHandler(true)
        }
        edit.image = UIImage(systemName: "pencil")
        edit.backgroundColor = .blue
        
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipe
    }
}
