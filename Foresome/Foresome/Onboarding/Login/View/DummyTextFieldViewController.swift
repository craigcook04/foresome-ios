//
//  DummyTextFieldViewController.swift
//  Foresome
//
//  Created by Deepanshu on 21/04/23.
//

import UIKit

class DummyTextFieldViewController: UIViewController {

    
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var confirmPass: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passField.isSecureTextEntry = true
        confirmPass.isSecureTextEntry = true
    }
    
    @IBAction func passAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func confirmPassAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        confirmPass.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
}
