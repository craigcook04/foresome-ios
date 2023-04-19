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
    
    func createNewPoll() {
        print("create poll action called.")
    }
    
    func createNewPoll(questioName: String, optionsArray: [AdditionalOption]) {
        print("questions name---\(questioName)")
        print("options count is -==\(optionsArray.count)")
        if optionsArray.count == 3 {
            print("number of options are three.")
        } else if optionsArray.count == 4 {
            print("number of options are four.")
        }
        //MARK: code for create poll using firebase ---
        //MARK: json required for create post---
        //author name
//        author profile pic
//        created poll date
//        questions name
//        options name 1
//        options name 2
//        options name 3
//        options name 4
        
        
        
    }
}
