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
}

protocol LeaderBoardPresenterProtocol {
    var view: LeaderBoardViewProtocol? { get set }
}



