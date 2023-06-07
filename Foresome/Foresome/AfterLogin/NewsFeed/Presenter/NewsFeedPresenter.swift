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
    func uploadProgress(data: CreatePostModel, isEditProfile: Bool) {
         
    }
    
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
    
    
    func fetchPostData(data: [PostListDataModel]) {
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (querySnapshot, err) in
             ActivityIndicator.sharedInstance.hideActivityIndicator()
            if err == nil {
                querySnapshot?.documents.enumerated().forEach({ (index, posts) in
                    let postsData =  posts.data()
                    print("post id is ---\(posts.documentID)")
//                    print("total post is --===\(postsData.count)")
//                    let allPostData = PostListDataModel(json: data)
//                    self.listPostData.append(allPostData)
//                    print("self.listpostdata---\(self.listPostData.count)")
                })
            } else {
                if let error = err?.localizedDescription {
                    print("error is ---\(error)")
                    Singleton.shared.showMessage(message: error, isError: .error)
                }
            }
        }
    }
    
    func fetchPostData() {
        ActivityIndicator.sharedInstance.showActivityIndicator()
        var listPostData = [PostListDataModel]()
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (querySnapshot, err) in
             ActivityIndicator.sharedInstance.hideActivityIndicator()
            if err == nil {
                querySnapshot?.documents.enumerated().forEach({ (index, posts) in
                    let postsData = posts.data()
                    let allPostData = PostListDataModel(json: postsData)
                    listPostData.append(allPostData)
                    self.view?.presenter?.view?.fetchAllPostData(data: listPostData)
                })
            } else {
                if let error = err?.localizedDescription {
                    Singleton.shared.showMessage(message: error, isError: .error)
                }
            }
        }
    }
    
    
    
    func fetchPostData(isFromRefresh: Bool) {
        if isFromRefresh == true {
            ActivityIndicator.sharedInstance.hideActivityIndicator()
        } else {
            ActivityIndicator.sharedInstance.showActivityIndicator()
        }
        var listPostData = [PostListDataModel]()
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (querySnapshot, err) in
             ActivityIndicator.sharedInstance.hideActivityIndicator()
            if err == nil {
                querySnapshot?.documents.enumerated().forEach({ (index, posts) in
                    let postsData = posts.data()
                    let allPostData = PostListDataModel(json: postsData)
                    listPostData.append(allPostData)
                    self.view?.presenter?.view?.fetchAllPostData(data: listPostData)
                })
            } else {
                if let error = err?.localizedDescription {
                    if error == "Missing or insufficient permissions." {
                        Singleton.shared.showMessage(message: error, isError: .error)
                        Singleton.shared.logoutFromDevice()
                    }
                        
                    
                }
            }
        }
    }
    
}




