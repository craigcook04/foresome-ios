//
//  TournamentPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 29/03/23.
//

import Foundation

class TournamentPresenter: TournamentDetailPresenter {
   
    var view: TournamentDetailViewProtocol?
    
    static func createTournamentModule()->TournamentDetailViewController{
        let view = TournamentDetailViewController()
        var presenter: TournamentDetailPresenter = TournamentPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
