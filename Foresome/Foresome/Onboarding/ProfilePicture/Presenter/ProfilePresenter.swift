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
        let db = Firestore.firestore()
        let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
        db.collection("users").document(documentsId).setData(["user_profile_pic" : "\(porfilePicName)"], merge: true) { error in
            if error == nil {
                if let signupVc = self.view as? ProfilePictureViewController {
                    let locationVc = UserSkillPresenter.createUserSkillModule()
                    signupVc.pushViewController(locationVc, true)
                }
            } else {
                if let error = error {
                    Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                }
            }
        }
    }
}




