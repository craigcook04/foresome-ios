//
//  TournamentProtocol.swift
//  Foresome
//
//  Created by Piyush Kumar on 29/03/23.
//

import Foundation

protocol TournamentDetailViewProtocol{
    var presenter:TournamentDetailPresenter? {get set}
   
}

protocol TournamentDetailPresenter{
    var view:TournamentDetailViewProtocol? {get set}
   
}
