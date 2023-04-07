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
        Auth.auth().signIn(withEmail: "\(email)", password: "\(password)") { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            print("login successfully")
            print("\(authResult)")
            print("\(authResult?.user)")
            print("\(authResult?.user.uid)")
            print("\(authResult?.user.displayName)")
            if error == nil {
                UserDefaultsCustom.setValue(value: (authResult?.user.uid as? NSString) ?? "", forKey: "user_uid")
                Singleton.shared.setHomeScreenView()
            } else {
                Singleton.shared.showMessage(message: "Invalid email and password", isError: .error)
            }
        }
    }
}
