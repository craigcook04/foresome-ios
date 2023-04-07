//
//  LocationProtocole.swift
//  Foresome
//
//  Created by Deepanshu on 04/04/23.
//

import Foundation

protocol LocationViewProtocol {
    var presenter : LocationPresenterProtocol? { get set}
}

protocol LocationPresenterProtocol {
    var view : LocationViewProtocol? { get set}
    func updateUserLocation(countryName: String)
}

