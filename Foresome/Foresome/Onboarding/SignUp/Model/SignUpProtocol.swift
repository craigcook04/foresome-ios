//
//  SignUpProtocol.swift
//  Foresome
//
//  Created by Piyush Kumar on 31/03/23.
//

import Foundation

protocol SignUpViewProtocol {
    var presenter: SignUpViewPresenter? {get set}
}
protocol SignUpViewPresenter {
    var view: SignUpViewProtocol? {get set}
    func validateFields(fullName: String, email: String, password: String, confirmPassword: String) -> Bool
}
