//
//  TournamentPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 29/03/23.
//

import Foundation

class TournamentPresenter: TournamentDetailPresenterProtocol {
   
    var view: TournamentDetailViewProtocol?
    
    static func createTournamentsDetailsModule(data:TournamentModel)-> TournamentDetailViewController {
        let view = TournamentDetailViewController()
        view.tournamentData = data
        var presenter: TournamentDetailPresenterProtocol = TournamentPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
