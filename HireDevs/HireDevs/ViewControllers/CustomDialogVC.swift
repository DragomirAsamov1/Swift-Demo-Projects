//
//  CustomDialogVC.swift
//  HireDevs
//
//  Created by Darren Asamov on 18/01/2022.
//

import UIKit

class CustomDialogVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickButton: UIButton!
    var dialogTitle = ""
    var wasTickButtonClicked = false
    var delegate: PopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = dialogTitle
    }
    @IBAction func didTapTickButton(_ sender: UIButton) {
        delegate?.popupValueSelected(value: true)
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapCrossButton(_ sender: UIButton) {
        delegate?.popupValueSelected(value: false)
        self.dismiss(animated: true)
    }
}

