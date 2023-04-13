//
//  ForgotPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 31/03/23.
//

import Foundation

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
            return isValidEmail
            
        }else{
            Singleton.shared.showErrorMessage(error: "Please Enter Valid Email", isError: .error)
            return false
        }
    }
}
