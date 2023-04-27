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
    
    let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
    
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
        self.uploadImageStorageRafrence()
        return
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
                                    Singleton.shared.showMessage(message: "Profile updated successfully.", isError: .success)
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
                        Singleton.shared.showMessage(message: "Old password not matched.", isError: .error)
                    }
                })
            } else {
                print("update only bio")
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                Singleton.shared.showMessage(message: "password details are not matched.", isError: .error)
            }
        } else if (bioTextView.text.count > 0) && ((OldPasswordField.text?.count ?? 0) == 0 && (newPasswordField.text?.count ?? 0) == 0 && (confirmNewPasswordField.text?.count ?? 0) == 0) {
            //MARK: update bio only------
            if let data = strings {
                if data["bio"] != nil {
                    if self.bioTextView.text ==  data["bio"] as? String ?? "" {
                        Singleton.shared.showMessage(message: "Please fill all details.", isError: .error)
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
                                    Singleton.shared.showMessage(message: "Profile updated successfully.", isError: .success)
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
                                    Singleton.shared.showMessage(message: "Profile updated successfully.", isError: .success)
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
                        Singleton.shared.showMessage(message: "Old password not matched.", isError: .error)
                    }
                })
            } else {
                print("update only bio")
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                Singleton.shared.showMessage(message: "password details are not matched.", isError: .error)
            }
        } else {
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            Singleton.shared.showMessage(message: "please fill above details.", isError: .error)
        }
    }
    
    //MARK: code for create post or upload image using storage refrence -----
    func uploadImageStorageRafrence() {
        let storageRef = Storage.storage().reference()
        let data = Data()
        let riversRef = storageRef.child("images/hello.png")
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("failure cases.")
                print("returned error incase put data is \(error)")
                return
            }
            let size = metadata.size
            
            riversRef.downloadURL { (url,error) in
                guard let downloadUrl = url else  {
                    print("unable to download")
                    print("returned error incase download url is --== \(error)")
                    return
                }
                print("downloaded url is -===\(downloadUrl)")
            }
        }
        
        uploadTask.observe(.progress) { data in
            print("upload data progress is ---=\(data.progress.debugDescription)")
            print(data.progress?.fileCompletedCount)
            print(data.progress?.completedUnitCount)
            print(data.progress?.fractionCompleted)
        }
    }
    
    //MARK: function for update bio
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
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        if  textField == newPasswordField || textField == confirmNewPasswordField {
    //            if (OldPasswordField.text?.count ?? 0) == 0 {
    //                Singleton.shared.showMessage(message: "Please fill old password.", isError: .error)
    //                return
    //            }
    //        }
    //    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  textField == newPasswordField || textField == confirmNewPasswordField {
            if (OldPasswordField.text?.count ?? 0) == 0 {
                Singleton.shared.showMessage(message: "Please fill old password.", isError: .error)
                return false
            }
        }
        return true
    }
}


