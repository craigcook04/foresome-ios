//
//  LoginPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 31/03/23.
//

import Foundation
import UIKit
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginPresenter: LoginPresenterProtocol {
    
    var view: LoginViewProtocol?

    static func createLoginModule() -> LoginViewController {
        let view = LoginViewController()
        var presenter: LoginPresenterProtocol = LoginPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func jsonToVerifyProfile(email: String, password: String)-> JSON {
        var json = JSON()
        json["email"] = email
        json["password"] = password
        return json
    }

    func validateField(email: String, password: String) -> Bool {
        guard email != "" else {
            Singleton.shared.showMessage(message: "Please enter an email", isError: .error)
            return false
        }
        guard Validator.validatePassword(password: password).0 else {
            Singleton.shared.showErrorMessage(error: Validator.validatePassword(password: password).1, isError: .error)
            return false
        }
        let isValidEmail = Validator.validateEmail(candidate: email)
        if isValidEmail == true {
            return isValidEmail
        } else {
            Singleton.shared.showMessage(message: "Please enter valid email", isError: .error)
            return false
        }
    }
    
    //MARK: function for passcontroller data in presenter and make logical part here-----
    func userLogin(email: String, password: String) {
        ActivityIndicator.sharedInstance.showActivityIndicator()
        Auth.auth().signIn(withEmail: "\(email)", password: "\(password)") { [weak self] authResult, error in
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            print("login successfully")
            //MARK: code for get logged in user informations ----
            if error == nil {
                let db = Firestore.firestore()
                let currentUserId = UserDefaults.standard.value(forKey: "user_uid") ?? ""
                let currentLogedUserId  = Auth.auth().currentUser?.uid ?? ""
                db.collection("users").document(currentLogedUserId).getDocument { (snapData, error) in
                    print("fetched current user data----\(snapData?.data()?["name"])")
                    if let data = snapData?.data() {
                        let userdata = ReturnUserData()
                        UserDefaults.standard.set(data, forKey: "myUserData")
                    }
                }
                UserDefaultsCustom.setValue(value: (authResult?.user.uid as? NSString) ?? "", forKey: "user_uid")
                Singleton.shared.setHomeScreenView()
            } else {
                Singleton.shared.showMessage(message: "Invalid email and password", isError: .error)
            }
        }
    }
}
