//
//  EditProfileViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 13/04/23.
//

import UIKit
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

class EditProfileViewController: UIViewController, EditProfileViewProtocol {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var bioTextView: GrowingTextView!
    @IBOutlet weak var OldPasswordField: UITextField!
    @IBOutlet weak var showOldPasswordBtn: UIButton!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var showNewPasswordBtn: UIButton!
    @IBOutlet weak var confirmNewPasswordField: UITextField!
    @IBOutlet weak var showConfirmPasswordBtn: UIButton!
    
    var presenter: EditProfilePresenterProtocol?
    let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
    
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
        if let data = strings {
            self.nameField.text = data["name"] as? String ?? ""
            self.emailField.text = data["email"] as? String ?? ""
            if data["bio"] != nil {
                self.bioTextView.text = data["bio"] as? String ?? ""
            }
        }
    }
    
    func validatePassField(newPass: String, conformPass: String) -> String? {
        if newPass == conformPass {
            return conformPass
        } else {
            Singleton.shared.showMessage(message: "Conform pass not same", isError: .error)
            return nil
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
    
    @IBAction func confirmPasswordShowAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            confirmNewPasswordField.isSecureTextEntry = false
        } else {
            confirmNewPasswordField.isSecureTextEntry = true
        }
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        print("save button action called.")
        if bioTextView.text.count > 0 {
            print("helllo")
            let db = Firestore.firestore()
            do {
                let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
                db.collection("users").document(documentsId).setData(["bio": "\(bioTextView.text ?? "")"], merge: true)
                Singleton.shared.showMessage(message: "updated successfully.", isError: .success)
            } catch let error {
                Singleton.shared.showMessage(message: "\(error.localizedDescription)", isError: .error)
            }
        } else {
            print("on working when bio is filled.")
        }
        
        if (OldPasswordField.text?.count ?? 0) > 0 && (newPasswordField.text == confirmNewPasswordField.text) {
            let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: "\(emailField.text ?? "")", password: "\(OldPasswordField.text ?? "")")
            user?.reauthenticate(with: credential, completion: { (authResut, error)  in
                if error == nil {
                    if self.validatePassField(newPass: self.newPasswordField.text ?? "", conformPass: self.confirmNewPasswordField.text ?? "") == nil {
                        return
                    } else {
                        let pass = self.validatePassField(newPass: self.newPasswordField.text ?? "", conformPass: self.confirmNewPasswordField.text ?? "")
                        Auth.auth().currentUser?.updatePassword(to: pass ?? "")
                        self.popVC()
                    }
                } else {
                    Singleton.shared.showMessage(message: "Old password not matched.", isError: .error)
                }
            })
        } else {
            print("update only bio")
        }
    }
}

