//
//  FriendsPresenter.swift
//  Foresome
//
//  Created by Deepanshu on 08/06/23.
//

import Foundation
import UIKit

class MembersAndFriendsPresenter: FriendsPresenterProtocol {
    
    var view: FriendsViewProtocol?
    
    static func createMembersModules() -> FriendsViewController {
        let view = FriendsViewController()
        var presenter: FriendsPresenterProtocol = MembersAndFriendsPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
}

