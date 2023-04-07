//
//  OrderSummryPresenter.swift
//  Foresome
//
//  Created by Deepanshu on 05/04/23.
//

import Foundation

class OrderSummryPresenter: OrderSummryPresenterProtocol {
   
    var view: OrderSummryViewProtocol?

    static func createOrderSummryModule() -> OrderSummaryViewController {
        let view = OrderSummaryViewController()
        var presenter : OrderSummryPresenterProtocol = OrderSummryPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func getPaymenstDetails() {
        print("payments details from firestore----")
        
        
    }
}

