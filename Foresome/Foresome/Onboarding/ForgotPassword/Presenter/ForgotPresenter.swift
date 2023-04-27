//
//  ForgotPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 31/03/23.
//

import Foundation
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

class ForgotPresenter: ForgotPasswordPresenter {
    
    var view: ForgotPasswordViewProtocol?
    
    static func createForgotPasswordModule()->ForgotPasswordViewController{
        let view = ForgotPasswordViewController()
        var presenter: ForgotPasswordPresenter = ForgotPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func jsonToForgotPassword(email: String) -> JSON{
        var json = JSON()
        json["email"] = email
        return json
    }
    
    func validateField(email: String) -> Bool {
        guard email != "" else {
            Singleton.shared.showErrorMessage(error: "Please enter email", isError: .error)
            return false
        }
        let isValidEmail = Validator.validateEmail(candidate: email)
        if isValidEmail == true {
            ActivityIndicator.sharedInstance.showActivityIndicator()
            Auth.auth().sendPasswordReset(withEmail: "\(email)") { err in
                if err == nil {
                    Singleton.shared.showMessage(message: "Password reset link send successfully.", isError: .success)
                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        if let view = self.view as? ForgotPasswordViewController {
                            view.popVC()
                        }
                    })
                } else {
                    Singleton.shared.showMessage(message: err?.localizedDescription ?? "", isError: .error)
                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                }
            }
            return isValidEmail
        }else {
            Singleton.shared.showErrorMessage(error: "Please Enter Valid Email", isError: .error)
            return false
        }
    }
}
