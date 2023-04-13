//
//  EditProfilePresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 13/04/23.
//

import Foundation

class EditProfilePresenter: EditProfilePresenterProtocol {
    var view: EditProfileViewProtocol?
    
    static func createEditProfileModule() -> EditProfileViewController {
        let view = EditProfileViewController()
        var presenter: EditProfilePresenterProtocol = EditProfilePresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
