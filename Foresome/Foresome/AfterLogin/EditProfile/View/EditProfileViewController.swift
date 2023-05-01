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
import FirebaseStorage

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
    
    let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newPasswordField.delegate = self
        self.confirmNewPasswordField.delegate = self
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
            Singleton.shared.showMessage(message: Messages.confirmPassMatch, isError: .error)
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
        if (bioTextView.text.count > 0) && ((OldPasswordField.text?.count ?? 0) > 0 || (newPasswordField.text?.count ?? 0) > 0 || (confirmNewPasswordField.text?.count ?? 0) > 0) {
            //MARK: update bio with password ---
            updateBio()
            if (OldPasswordField.text?.count ?? 0) > 0 && (newPasswordField.text == confirmNewPasswordField.text) {
                let user = Auth.auth().currentUser
                let credential = EmailAuthProvider.credential(withEmail: "\(emailField.text ?? "")", password: "\(OldPasswordField.text ?? "")")
                user?.reauthenticate(with: credential, completion: { (authResut, error)  in
                    if error == nil {
                        if self.validatePassField(newPass: self.newPasswordField.text ?? "", conformPass: self.confirmNewPasswordField.text ?? "") == nil {
                            return
                        } else {
                            let pass = self.validatePassField(newPass: self.newPasswordField.text ?? "", conformPass: self.confirmNewPasswordField.text ?? "")
                            ActivityIndicator.sharedInstance.showActivityIndicator()
                            Auth.auth().currentUser?.updatePassword(to: pass ?? "", completion: { err in
                                if err == nil {
                                    self.updateBio()
                                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                                    Singleton.shared.showMessage(message: AppStrings.profileUpdated, isError: .success)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                        self.popVC()
                                    })
                                } else {
                                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                                    Singleton.shared.showMessage(message: err?.localizedDescription ?? "", isError: .error)
                                }
                            })
                        }
                    } else {
                        ActivityIndicator.sharedInstance.hideActivityIndicator()
                        Singleton.shared.showMessage(message: Messages.oldPasswordError, isError: .error)
                    }
                })
            } else {
                print("update only bio")
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                Singleton.shared.showMessage(message: Messages.passWordFieldError, isError: .error)
            }
        } else if (bioTextView.text.count > 0) && ((OldPasswordField.text?.count ?? 0) == 0 && (newPasswordField.text?.count ?? 0) == 0 && (confirmNewPasswordField.text?.count ?? 0) == 0) {
            //MARK: update bio only------
            if let data = strings {
                if data["bio"] != nil {
                    if self.bioTextView.text ==  data["bio"] as? String ?? "" {
                        Singleton.shared.showMessage(message: Messages.fillAllDetails, isError: .error)
                        return
                    } else {
                        ActivityIndicator.sharedInstance.showActivityIndicator()
                        let db = Firestore.firestore()
                        do {
                            let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
                            db.collection("users").document(documentsId).setData(["bio": "\(bioTextView.text ?? "")"], merge: true) { err in
                                if err == nil {
                                    self.updateBio()
                                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                                    Singleton.shared.showMessage(message: AppStrings.profileUpdated, isError: .success)
                                    self.popVC()
                                } else {
                                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                                    Singleton.shared.showMessage(message: "\(err?.localizedDescription ?? "")", isError: .error)
                                }
                            }
                        }
                    }
                }
            }
        } else if (bioTextView.text.count == 0) && ((OldPasswordField.text?.count ?? 0) > 0 || (newPasswordField.text?.count ?? 0) > 0 || (confirmNewPasswordField.text?.count ?? 0) > 0) {
            //MARK: update password only---
            if (OldPasswordField.text?.count ?? 0) > 0 && (newPasswordField.text == confirmNewPasswordField.text) {
                let user = Auth.auth().currentUser
                let credential = EmailAuthProvider.credential(withEmail: "\(emailField.text ?? "")", password: "\(OldPasswordField.text ?? "")")
                user?.reauthenticate(with: credential, completion: { (authResut, error)  in
                    if error == nil {
                        if self.validatePassField(newPass: self.newPasswordField.text ?? "", conformPass: self.confirmNewPasswordField.text ?? "") == nil {
                            return
                        } else {
                            let pass = self.validatePassField(newPass: self.newPasswordField.text ?? "", conformPass: self.confirmNewPasswordField.text ?? "")
                            ActivityIndicator.sharedInstance.showActivityIndicator()
                            Auth.auth().currentUser?.updatePassword(to: pass ?? "", completion: { err in
                                if err == nil {
                                    self.updateBio()
                                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                                    Singleton.shared.showMessage(message: AppStrings.profileUpdated, isError: .success)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                        self.popVC()
                                    })
                                } else {
                                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                                    Singleton.shared.showMessage(message: err?.localizedDescription ?? "", isError: .error)
                                }
                            })
                        }
                    } else {
                        ActivityIndicator.sharedInstance.hideActivityIndicator()
                        Singleton.shared.showMessage(message: Messages.oldPasswordError, isError: .error)
                    }
                })
            } else {
                print("update only bio")
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                Singleton.shared.showMessage(message: Messages.passWordFieldError, isError: .error)
            }
        } else {
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            Singleton.shared.showMessage(message: Messages.fillAboveDetails, isError: .error)
        }
    }
    
    //MARK: code for create post or upload image using storage refrence -----

    func updateBio() {
        let db = Firestore.firestore()
        do {
            let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
            db.collection("users").document(documentsId).setData(["bio": "\(bioTextView.text ?? "")"], merge: true) { err in
                if err == nil {
                    // Singleton.shared.showMessage(message: "updated successfully.", isError: .success)
                } else {
                    // Singleton.shared.showMessage(message: "\(err?.localizedDescription ?? "")", isError: .error)
                }
            }
        }
    }
}

extension EditProfileViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  textField == newPasswordField || textField == confirmNewPasswordField {
            if (OldPasswordField.text?.count ?? 0) == 0 {
                Singleton.shared.showMessage(message: Messages.oldPassRequired, isError: .error)
                return false
            }
        }
        return true
    }
}


