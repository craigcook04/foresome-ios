//
//  ForgotProtocol.swift
//  Foresome
//
//  Created by Piyush Kumar on 31/03/23.
//

import Foundation

protocol ForgotPasswordViewProtocol {
    var presenter: ForgotPasswordPresenter? {get set}
}
protocol ForgotPasswordPresenter {
    var view: ForgotPasswordViewProtocol? {get set}
    func validateField(email: String) -> Bool
}
