//
//  UserProfilePresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
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

class UserProfilePresenter: UserProfilePresenterProtocol {
    
    var view: UserProfileViewProtocol?
    
    static func createUserProfileModule()->ProfileVC {
        let view = ProfileVC()
        var presenter: UserProfilePresenterProtocol = UserProfilePresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func updateUserProfile(profilePicName: String) {
        print("hello upload pic from here")
        let db = Firestore.firestore()
        let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
        db.collection("users").document(documentsId).setData(["user_profile_pic" : "\(profilePicName)"], merge: true)
      
    }
    
    func updateProfilePic(profileImage: UIImage) {
        print("hello upload pic from here---\(profileImage)")
    }
}
