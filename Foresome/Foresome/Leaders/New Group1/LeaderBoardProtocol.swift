//
//  LeaderBoardProtocol.swift
//  Foresome
//
//  Created by Deepanshu on 08/06/23.
//

import Foundation
import UIKit

protocol LeaderBoardViewProtocol {
    var presenter: LeaderBoardPresenterProtocol? { get set }
    func fetchPresenterLeaderBoard(leaderBoardData:[LeaderBoardDataModel])
}

protocol LeaderBoardPresenterProtocol {
    var view: LeaderBoardViewProtocol? { get set }
    func fetchPresenterViewLeaderBoard(leaderBoardData:[LeaderBoardDataModel])
    
    func fetchPresenterViewLeaderBoard(isFromRefresh: Bool)
    
}


