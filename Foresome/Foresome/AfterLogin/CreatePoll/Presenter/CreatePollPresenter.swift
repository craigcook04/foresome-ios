//
//  CreatePollPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
//

import Foundation

class CreatePollPresenter: CreatePollPresenterProtocol {
    var view: CreatePollViewProtocol?
    
    static func createPollModule() -> CreatePollViewController {
        let view = CreatePollViewController()
        var presenter: CreatePollPresenterProtocol = CreatePollPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
        
    }
}
