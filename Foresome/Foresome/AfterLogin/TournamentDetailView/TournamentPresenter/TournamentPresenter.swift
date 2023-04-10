//
//  TournamentPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 29/03/23.
//

import Foundation
import UIKit

class TournamentPresenter: TournamentDetailPresenterProtocol {
   
    var view: TournamentDetailViewProtocol?
    
    static func createTournamentsDetailsModule(data:TournamentModel, tournamentsImage: UIImage)-> TournamentDetailViewController {
        let view = TournamentDetailViewController()
        view.tournamentData = data
        view.tournamentsDetailsImage = tournamentsImage
        var presenter: TournamentDetailPresenterProtocol = TournamentPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
