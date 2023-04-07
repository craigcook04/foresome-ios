//
//  LoginProtocol.swift
//  Foresome
//
//  Created by Piyush Kumar on 31/03/23.
//

import Foundation

protocol LoginViewProtocol {
    var presenter: LoginPresenterProtocol? {get set}
}

protocol LoginPresenterProtocol {
    var view: LoginViewProtocol? {get set}
    func validateField (email: String, password: String) -> Bool
    func userLogin(email: String, password: String)
}
