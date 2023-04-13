//
//  EditProfileProtocol.swift
//  Foresome
//
//  Created by Piyush Kumar on 13/04/23.
//

import Foundation

protocol EditProfileViewProtocol {
    var presenter: EditProfilePresenterProtocol? {get set}
}

protocol EditProfilePresenterProtocol {
    var view: EditProfileViewProtocol? {get set}
}
