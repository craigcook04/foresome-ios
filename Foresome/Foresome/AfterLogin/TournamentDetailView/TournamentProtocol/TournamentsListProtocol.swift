//
//  TournamentsListProtocol.swift
//  Foresome
//
//  Created by Deepanshu on 10/04/23.
//

import Foundation
import UIKit

protocol TournamenstsListViewProtocol {
    var presenter: TournamentsListPresenterProtocol? {get set}
}

protocol TournamentsListPresenterProtocol {
    
    var view: TournamenstsListViewProtocol? {get set}
    func passlistDatatoDetails(data:TournamentModel, tournamentsImage: UIImage)
}

