//
//  LeaderBoardPresenter.swift
//  Foresome
//
//  Created by Deepanshu on 08/06/23.
//

import Foundation
import UIKit

class LeaderBoardPresenter : LeaderBoardPresenterProtocol {
    
    var view : LeaderBoardViewProtocol?
    
   static func createLeaderBoardModule() -> LeadersViewController {
        let view = LeadersViewController()
        var presenter: LeaderBoardPresenterProtocol = LeaderBoardPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
}
