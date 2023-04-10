//
//  TournamentsListPresenter.swift
//  Foresome
//
//  Created by Deepanshu on 10/04/23.
//

import Foundation
import UIKit

class TournamentsListPresenter: TournamentsListPresenterProtocol {
    var view :  TournamenstsListViewProtocol?
    
    static func createTournamentsListModules() -> TournamentViewController {
        let view = TournamentViewController()
        var presenter: TournamentsListPresenterProtocol = TournamentsListPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func passlistDatatoDetails(data: TournamentModel, tournamentsImage: UIImage) {
        if let tournamentsVc = self.view as? TournamentViewController {
            let detailsVc = TournamentPresenter.createTournamentsDetailsModule(data: data, tournamentsImage: tournamentsImage )
            detailsVc.hidesBottomBarWhenPushed = true
            tournamentsVc.pushViewController(detailsVc, true)
        }
    }
}
