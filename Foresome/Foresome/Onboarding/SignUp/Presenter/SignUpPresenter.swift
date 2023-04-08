//
//  SignUpPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 31/03/23.
//

import Foundation
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

class SignUpPresenter: SignUpViewPresenter {
    
    var view: SignUpViewProtocol?
    
    static func createSignUpModule() -> SignUpViewController {
        let view = SignUpViewController()
        var presenter: SignUpViewPresenter = SignUpPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func jsonToVerifyProfile (fullName: String, email: String, password: String, confirmPassword: String)-> JSON {
        var json = JSON()
        json["fullName"] = fullName
        json["email"] = email
        json["password"] = password
        json["confirmPassword"] = confirmPassword
        return json
    }
    
    func validateFields(fullName: String, email: String, password: String, confirmPassword: String) -> Bool {
        guard fullName != "" else {
            Singleton.shared.showErrorMessage(error: "Please Enter FullName", isError: .error)
            return false
        }
        
        guard email != "" else {
            Singleton.shared.showErrorMessage(error: "Please Enter Email", isError: .error)
            return false
        }
        
        guard Validator.validatePassword(password: password).0  else {
            Singleton.shared.showErrorMessage(error: Validator.validatePassword(password: password).1, isError: .error)
            return false
        }
        
        let isValidEmail = Validator.validateEmail(candidate: email)
        if isValidEmail == true {
            return isValidEmail
        } else {
            Singleton.shared.showErrorMessage(error: "Please Enter Valid Email", isError: .error)
            return false
        }
    }
    //MARK: code for create new user on firebase ------
    func createNewUser(fullName: String, email: String, password: String, confirmPassword: String) {
        print("code for sign up for new user----")
        ActivityIndicator.sharedInstance.showActivityIndicator()
        Auth.auth().createUser(withEmail: "\(email)", password: "\(password)", completion: { (result, error) -> Void in
            if (error == nil) {
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                print("created user uid----\(result!.user.uid)")
                let db = Firestore.firestore()
                db.collection("users").document(result!.user.uid).setData(["name":"\(fullName)", "email":"\(email)", "createdDate:":"\(String(describing: Date().localToUtc))", "uid": result!.user.uid, "user_location":"", "user_profile_pic":"", "user_skill_level":""])
                UserDefaultsCustom.setValue(value: result!.user.uid, forKey: "user_uid")
                if let signupVc = self.view as? SignUpViewController {
                    let locationVc = LocationPresenter.createLocationModule()
                    signupVc.pushViewController(locationVc, true)
                }
                
               // db.collection("users").document(result!.user.uid).setData(<#T##documentData: [String : Any]##[String : Any]#>)
                
//                db.collection("users").addDocument(data:["name":"\(fullName)", "email":"\(email)", "createdDate:":"\(String(describing: Date().localToUtc))", "uid": result!.user.uid, "user_location":"", "user_profile_pic":"", "user_skill_level":""])
//                { (Error) in
//                    if Error != nil {
//                        print("Cannot saving user data-\(Error as Any)")
//                    } else {
//
//
//                        print("user data saved successfully.")
//                        UserDefaultsCustom.setValue(value: result!.user.uid, forKey: "user_uid")
//                        if let signupVc = self.view as? SignUpViewController {
//                            let locationVc = LocationPresenter.createLocationModule()
//                            signupVc.pushViewController(locationVc, true)
//                        }
//                    }
//                }
            } else {
                print("error in case of create new user\(error  as Any)")
            }
        })
    }
}
