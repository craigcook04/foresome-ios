//
//  ProfilePresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 31/03/23.
//

import Foundation
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

class ProfilePresenter: ProfilePicturePresenter {
    
    var view: ProfilePictureViewProtocol?
    static func createProfileModule() -> ProfilePictureViewController {
        let view = ProfilePictureViewController()
        var presenter: ProfilePicturePresenter = ProfilePresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func updateUserProfileData(porfilePicName: String) {
        print("country name for update user location---\(porfilePicName)")
         let db = Firestore.firestore()
         db.collection("users").addDocument(data:["user_profile_pic":"\(porfilePicName)", "uid": UserDefaults.standard.value(forKey: "user_uid") ?? ""]) { (Error) in
             if Error != nil {
                 print("user profile updatation issue---\(Error as Any)")
             } else {
                 print("user profile updated successfully.")
                 if let signupVc = self.view as? ProfilePictureViewController {
                     let locationVc = UserSkillPresenter.createUserSkillModule()
                     signupVc.pushViewController(locationVc, true)
                 }
             }
         }
    }
}




