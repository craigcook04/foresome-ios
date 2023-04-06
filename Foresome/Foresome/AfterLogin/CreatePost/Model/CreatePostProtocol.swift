//
//  CreatePostProtocol.swift
//  Foresome
//
//  Created by Piyush Kumar on 05/04/23.
//

import Foundation

protocol CreatePostViewProtocol {
    var presenter: CreatePostPresenterProtocol? {get set}
    func receiveResult()
    func cameraReceiveResult()
}
protocol CreatePostPresenterProtocol {
    var view: CreatePostViewProtocol? {get set}
    func photoButtonAction()
    func cameraButtonAction()
}
