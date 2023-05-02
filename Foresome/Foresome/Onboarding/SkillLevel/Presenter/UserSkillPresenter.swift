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
        ActivityIndicator.sharedInstance.showActivityIndicator()
        let db = Firestore.firestore()
        let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
        db.collection("users").document(documentsId).setData(["user_skill_level" : "\(skillType)"], merge: true) { err in
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            if err == nil {
                let db = Firestore.firestore()
                let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
                let currentLogedUserId  = Auth.auth().currentUser?.uid ?? ""
                db.collection("users").document(currentLogedUserId).getDocument { (snapData, error) in
                    if let data = snapData?.data() {
                        UserDefaults.standard.set(data, forKey: "myUserData")
                    }
                }
                if let view = self.view as? SkillLevelViewController {
                    if view.isFromEditSkill == true  {
                        view.popVC()
                    } else {
                        Singleton.shared.setHomeScreenView()
                    }
                }
            } else {
                if let error = err {
                    Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                }
            }
        }
    }
}

