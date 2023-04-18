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
    
    func createPost() {
        print("create post called.")
//    author: "Craig Cook"
//    createdAt: 1665423589828
//    description:
//    id: "kv06YiHVCkMicgikqofeX"
//    image: base64
    }
    
    func createPost(json: JSON) {
         
    }
    
    func creatNewPost(selectedimage: String) {
        print("selected image from image picker---\(selectedimage.debugDescription)")
        print("selected image from image picker---\(selectedimage)")
    }
}
