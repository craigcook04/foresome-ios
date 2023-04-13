//
//  CreatePollProtocol.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
//

import Foundation

protocol CreatePollViewProtocol {
    var presenter: CreatePollPresenterProtocol? {get set}
}
protocol CreatePollPresenterProtocol {
    var view: CreatePollViewProtocol? {get set}
}
