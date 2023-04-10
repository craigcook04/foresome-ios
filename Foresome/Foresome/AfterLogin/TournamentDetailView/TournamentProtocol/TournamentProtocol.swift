//
//  TournamentProtocol.swift
//  Foresome
//
//  Created by Piyush Kumar on 29/03/23.
//

import Foundation

protocol TournamentDetailViewProtocol{
    var presenter:TournamentDetailPresenterProtocol? {get set}
}

protocol TournamentDetailPresenterProtocol {
    var view:TournamentDetailViewProtocol? {get set}
    
}

