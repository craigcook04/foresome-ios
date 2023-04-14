//
//  EditProfileViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 13/04/23.
//

import UIKit

class EditProfileViewController: UIViewController, EditProfileViewProtocol {
    
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
        setUserProfileData()
    }
    
    func setUserProfileData() {
        OldPasswordField.isSecureTextEntry = true
        newPasswordField.isSecureTextEntry = true
        confirmNewPasswordField.isSecureTextEntry = true
        nameField.isUserInteractionEnabled = false
        emailField.isUserInteractionEnabled = false
        let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
        if let data = strings {
            self.nameField.text = data["name"] as? String ?? ""
            self.emailField.text = data["email"] as? String ?? ""
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func showOldPasswordAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            OldPasswordField.isSecureTextEntry = false
        } else {
            OldPasswordField.isSecureTextEntry = true
        }
    }
    
    @IBAction func showNewPasswordAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            newPasswordField.isSecureTextEntry = false
        } else {
            newPasswordField.isSecureTextEntry = true
        }
    }
}

