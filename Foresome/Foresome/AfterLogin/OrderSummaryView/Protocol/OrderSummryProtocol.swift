//
//  OrderSummryProtocol.swift
//  Foresome
//
//  Created by Deepanshu on 05/04/23.
//

import Foundation

protocol OrderSummryViewProtocol {
    var presenter:OrderSummryPresenterProtocol? {get set}
}

protocol OrderSummryPresenterProtocol {
    var view:OrderSummryViewProtocol? {get set}
    func getPaymenstDetails()
    func paymentsDetails(tournamenDetailstData:TournamentModel, variations: String?, quantity: Int?)
}

