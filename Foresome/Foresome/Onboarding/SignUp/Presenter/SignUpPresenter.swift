//
//  SignUpPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 31/03/23.
//

import Foundation

class SignUpPresenter: SignUpViewPresenter {

    var view: SignUpViewProtocol?

    static func createSignUpModule()->SignUpViewController{
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
        }else{
            Singleton.shared.showErrorMessage(error: "Please Enter Valid Email", isError: .error)
            return false
        }
  
    }
}
