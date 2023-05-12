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
import FirebaseStorage

class NewsFeedPresenter: NewsFeedPresenterProtocol, CreatePostUploadDelegate {
    
    var view: NewsFeedViewProtocol?
    
    static func createNewsFeedModule()->NewsFeedViewController {
        let view = NewsFeedViewController()
        var presenter: NewsFeedPresenterProtocol = NewsFeedPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func createPost() {
        print("create post function called.")
    }
    
    func uploadimage(image: UIImage) {
        if let view = view as? NewsFeedViewController {
            let vc = CreatePostPresenter.createPostModule(delegate: self, selectedImage: [image], data: nil, isEditPost: false)
            vc.hidesBottomBarWhenPushed = true
            view.pushViewController(vc, false)
        }
    }
    
    func saveCreatUserData() {
        let db = Firestore.firestore()
        let currentUserId = UserDefaults.standard.value(forKey: "user_uid") as? String ?? ""
        db.collection("users").document(currentUserId).getDocument { (snapData, error) in
            if let data = snapData?.data() {
                UserDefaults.standard.set(data, forKey: AppStrings.userDatas)
            }
        }
    }
    
    func uploadProgress(data: CreatePostModel) {
         
    }
}


