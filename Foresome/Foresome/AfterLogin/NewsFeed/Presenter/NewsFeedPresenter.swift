//
//  NewsFeedPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 04/04/23.
//

import Foundation
import UIKit
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

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
    }
    
    func createPost(json: JSON) {
         
    }
    
    func creatNewPost(selectedimage: String) {
        print("selected image from image picker---\(selectedimage.debugDescription)")
        print("selected image from image picker---\(selectedimage)")
        ActivityIndicator.sharedInstance.showActivityIndicator()
        let db = Firestore.firestore()
        let documentsId =  UUID().uuidString
        db.collection("posts").document(documentsId).setData(["author":"", "createdAt":"", "description":"", "id":"", "image":"", "photoURL":"", "profile":"", "uid":"", "updatedAt":"", "comments":[""], "image":"", "post_type":""])
        ActivityIndicator.sharedInstance.hideActivityIndicator()
    }
}
