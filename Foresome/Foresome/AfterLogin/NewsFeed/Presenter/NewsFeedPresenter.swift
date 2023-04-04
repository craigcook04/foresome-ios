//
//  NewsFeedPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 04/04/23.
//

import Foundation
import UIKit

class NewsFeedPresenter: NewsFeedPresenterProtocol {
    
    var view: NewsFeedViewProtocol?
    
    static func createNewsFeedModule()->NewsFeedViewController{
        let view = NewsFeedViewController()
        var presenter: NewsFeedPresenterProtocol = NewsFeedPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
