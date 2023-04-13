//
//  UserProfilePresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
//

import Foundation

class UserProfilePresenter: UserProfilePresenterProtocol {
    
    var view: UserProfileViewProtocol?
    
    static func createUserProfileModule()->ProfileVC{
        let view = ProfileVC()
        var presenter: UserProfilePresenterProtocol = UserProfilePresenter()
        presenter.view = view
        view.presenter = presenter
        return view
        
    }
}
