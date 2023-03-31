//
//  LoginPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 31/03/23.
//

import Foundation

class LoginPresenter: LoginViewPresenter {
    var view: LoginViewProtocol?

    static func createSignUpModule()->SignUpViewController{
        let view = SignUpViewController()
        var presenter: SignUpViewPresenter = SignUpPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    func jsonToVerifyProfile (email: String, password: String)-> JSON {
        var json = JSON()
        json["email"] = email
        json["password"] = password
        return json
    }

    func validateField (email: String, password: String) -> Bool {
        guard email != "" else {
            Singleton.shared.showErrorMessage(error: "Please Enter a Email", isError: .error)
            return false
        }
        guard Validator.validatePassword(password: password).0 else {
            Singleton.shared.showErrorMessage(error: Validator.validatePassword(password: password).1, isError: .error)
            return false
        }
        let isValidEmail = Validator.validateEmail(candidate: email)
        if isValidEmail == true {
            return isValidEmail
        }else {
            Singleton.shared.showErrorMessage(error: "Please Enter Valid Email", isError: .error)
            return false
        }

    }
}
