//
//  EditProfileViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 13/04/23.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var bioTextView: GrowingTextView!
    @IBOutlet weak var OldPasswordField: UITextField!
    @IBOutlet weak var showOldPasswordBtn: UIButton!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var showNewPasswordBtn: UIButton!
    @IBOutlet weak var confirmNewPasswordField: UITextField!
    var presenter: EditProfilePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    @IBAction func showOldPasswordAction(_ sender: UIButton) {
    }
    
    @IBAction func showNewPasswordAction(_ sender: UIButton) {
    }
}
extension EditProfileViewController: EditProfileViewProtocol {
    
}
