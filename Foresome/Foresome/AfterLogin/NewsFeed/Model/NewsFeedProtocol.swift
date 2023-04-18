//
//  NewsFeedProtocol.swift
//  Foresome
//
//  Created by Piyush Kumar on 04/04/23.
//

import Foundation

protocol NewsFeedViewProtocol {
    var presenter: NewsFeedPresenterProtocol? {get set}
    
}
protocol NewsFeedPresenterProtocol {
    var view: NewsFeedViewProtocol? {get set}
    func createPost(json: JSON)
    func creatNewPost(selectedimage:String)
}
