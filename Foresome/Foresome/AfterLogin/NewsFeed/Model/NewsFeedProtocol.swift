//
//  NewsFeedProtocol.swift
//  Foresome
//
//  Created by Piyush Kumar on 04/04/23.
//

import Foundation
import UIKit

protocol NewsFeedViewProtocol {
    var presenter: NewsFeedPresenterProtocol? {get set}
    
    func fetchAllPostData(data:[PostListDataModel])
    
    
}

protocol NewsFeedPresenterProtocol {
    var  view: NewsFeedViewProtocol? {get set}
    func createPost()
    func saveCreatUserData()
    func uploadimage(image: UIImage)
    func fetchPostData(data:[PostListDataModel])
    func fetchPostData()
}
