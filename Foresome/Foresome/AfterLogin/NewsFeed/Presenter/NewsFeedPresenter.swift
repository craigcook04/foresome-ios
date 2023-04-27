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
    
    func createPost(json: JSON) {
        print("create post json called")
    }
    
    func creatNewPost(selectedimage: String) {
        //MARK: code for create post single image post from both camera and gallery------

        
//        ActivityIndicator.sharedInstance.showActivityIndicator()
//        let db = Firestore.firestore()
//        let documentsId =  UUID().uuidString
//        let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
//        print("name is from strings is  -==\(strings?["name"] ?? "")")
//        let createdDate = Date().miliseconds()
//        print("created date---=\(createdDate)")
////        print("user profile picture----\(strings?["user_profile_pic"] ?? "")")
//        print("user name of created poll----= \(strings?["name"] ?? "")")
//        print("user uid is ----\(strings?["uid"] ?? "")")
//        print("documents id is---==\(documentsId)")
//        db.collection("posts").document(documentsId).setData(["author":"\(strings?["name"] ?? "")", "createdAt":"\(Date().miliseconds())", "description":"", "id": "\(documentsId)", "image":[selectedimage], "photoURL":"", "profile":"\(strings?["user_profile_pic"] ?? "")", "uid":"\(strings?["uid"] ?? "")", "updatedAt":"", "comments":[""], "post_type":"feed"], merge: true)
//        ActivityIndicator.sharedInstance.hideActivityIndicator()
    }
    
    func uploadimage(image: UIImage) {
        if let view = view as? NewsFeedViewController {
            let vc = CreatePostPresenter.createPostModule(delegate: self, selectedImage: [image])
            vc.hidesBottomBarWhenPushed = true
            view.pushViewController(vc, false)
        }
        
//        let storageRef = Storage.storage().reference()
//        var data = Data()
//        data = image.pngData() ?? Data()
//        let date = Date()
//        print("image name is -==\(date.miliseconds().toInt).png")
//        let riversRef = storageRef.child("images/IMG\(date.miliseconds().toInt).png")
//        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else {
//                print("failure cases.")
//                print("returned error incase put data is \(error)")
//                return
//            }
//            let size = metadata.size
//            riversRef.downloadURL { (url,error) in
//                guard let downloadUrl = url else  {
//                    print("unable to download")
//                    print("returned error incase download url is --== \(error)")
//                    return
//                }
//                print("downloaded url is -===\(downloadUrl)")
//            }
//        }
//
//        uploadTask.observe(.progress) { data in
//            print("upload data progress is ---=\(data.progress.debugDescription)")
//            print(data.progress?.fileCompletedCount)
//            print(data.progress?.completedUnitCount)
//            print(data.progress?.fractionCompleted)
//        }
    }
    
    func saveCreatUserData() {
        let db = Firestore.firestore()
//        let currentLogedUserId  = Auth.auth().currentUser?.uid ?? ""
        let currentUserId = UserDefaults.standard.value(forKey: "user_uid") as? String ?? ""
        db.collection("users").document(currentUserId ?? "").getDocument { (snapData, error) in
            if let data = snapData?.data() {
                UserDefaults.standard.set(data, forKey: "myUserData")
            }
        }
    }
    
    func uploadProgress(data: CreatePostModel) {
         
    }
    
}


