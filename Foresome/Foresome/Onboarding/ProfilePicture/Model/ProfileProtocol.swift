//
//  ProfileProtocol.swift
//  Foresome
//
//  Created by Piyush Kumar on 31/03/23.
//

import Foundation

protocol ProfilePictureViewProtocol {
    
    var presenter: ProfilePicturePresenter? {get set}
}
protocol ProfilePicturePresenter {
    
    var view: ProfilePictureViewProtocol? {get set}
    
}
