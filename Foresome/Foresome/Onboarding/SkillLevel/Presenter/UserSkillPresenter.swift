//
//  UserSkillPresenter.swift
//  Foresome
//
//  Created by Deepanshu on 04/04/23.
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

class UserSkillPresenter : UserSkillPresenterProtocol {
    
    var view: UserSkillViewProtocol?
    
    static func createUserSkillModule() -> SkillLevelViewController {
        let view = SkillLevelViewController()
        var presenter: UserSkillPresenterProtocol = UserSkillPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func updateUserSkillToFirestore(skillType: String) {
        print("user skill update methods called.")
        print("selected skill for data base updation is -----\(skillType)")
        let db = Firestore.firestore()
        let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
        db.collection("users").document(documentsId ?? "").setData(["user_skill_level" : "\(skillType)"], merge: true)
        //db.collection("users").document(documentsId ?? "").setData(["user_skill_level" : "\(skillType)"])
        Singleton.shared.setHomeScreenView()
//        db.collection("users").addDocument(data:["user_skill_level":"\(skillType)", "uid": UserDefaults.standard.value(forKey: "user_uid") ?? ""]) { (Error) in
//            if Error != nil {
//                print("user profile updatation issue---\(Error as Any)")
//            } else {
//                print("user profile updated successfully.")
////                if let signupVc = self.view as? ProfilePictureViewController {
////                    let locationVc = UserSkillPresenter.createUserSkillModule()
////                    signupVc.pushViewController(locationVc, true)
////                }
//                Singleton.shared.setHomeScreenView()
//            }
//        }
    }
}

