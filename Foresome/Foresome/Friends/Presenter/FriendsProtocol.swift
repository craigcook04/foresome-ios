//
//  FriendsProtocol.swift
//  Foresome
//
//  Created by Deepanshu on 08/06/23.
//

import Foundation
import UIKit

protocol FriendsViewProtocol {
    var presenter: FriendsPresenterProtocol? {get set}
    func fetchUsersListData(data:[UserListModel])
}

protocol FriendsPresenterProtocol {
    var view: FriendsViewProtocol? {get set}
}

 

