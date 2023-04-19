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
        ActivityIndicator.sharedInstance.showActivityIndicator()
        print("selected image from image picker---\(selectedimage.debugDescription)")
        print("selected image from image picker---\(selectedimage)")
        let db = Firestore.firestore()
        let documentsId =  UUID().uuidString
        let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
        print("name is from strings is  -==\(strings?["name"] ?? "")")
        let createdDate = Date().miliseconds()
        print("created date---=\(createdDate)")
        print("user profile picture----\(strings?["user_profile_pic"] ?? "")")
        print("user name of created poll----= \(strings?["name"] ?? "")")
        print("user uid is ----\(strings?["uid"] ?? "")")
        print("documents id is---==\(documentsId)")
        //db.collection("posts").document(documentsId).setData(["author":"\(strings?["name"] ?? "")", "createdAt":"\(Date().miliseconds())", "description":"", "id": "\(documentsId)", "image":"", "photoURL":"", "profile":"\(strings?["user_profile_pic"] ?? "")", "uid":"\(strings?["uid"] ?? "")", "updatedAt":"", "comments":[""], "post_type":"feed"], merge: true)
        ActivityIndicator.sharedInstance.hideActivityIndicator()
    }
}
