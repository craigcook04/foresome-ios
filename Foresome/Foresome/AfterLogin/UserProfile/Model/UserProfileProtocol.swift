//
//  UserProfileProtocol.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
//

import Foundation
import UIKit

protocol UserProfileViewProtocol {
    var presenter: UserProfilePresenterProtocol? {get set}
}

protocol UserProfilePresenterProtocol {
    var view: UserProfileViewProtocol? {get set}
    func updateUserProfile(profilePicName: String)
    func updateProfilePic(profileImage: UIImage)
}
