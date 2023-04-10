//
//  OrderSummryPresenter.swift
//  Foresome
//
//  Created by Deepanshu on 05/04/23.
//

import Foundation

class OrderSummryPresenter: OrderSummryPresenterProtocol {
    
    var view: OrderSummryViewProtocol?

    static func createOrderSummryModule(tournamenDetailstData: TournamentModel, variations: String?, quantity: Int?) -> OrderSummaryViewController {
        let view = OrderSummaryViewController()
        var presenter : OrderSummryPresenterProtocol = OrderSummryPresenter()
        view.tournamenDetailstData = tournamenDetailstData
        view.variations = variations
        view.quantity = quantity
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func getPaymenstDetails() {
        print("payments details from firestore----")
    }
    
    func paymentsDetails(tournamenDetailstData: TournamentModel, variations: String?, quantity: Int?) {
         
    }
}

