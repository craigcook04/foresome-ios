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
        let db = Firestore.firestore()
        let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
        db.collection("users").document(documentsId).setData(["user_skill_level" : "\(skillType)"], merge: true) { err in
            if err == nil {
                Singleton.shared.setHomeScreenView()
            } else {
                if let error = err {
                    Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                }
            }
        }
    }
}

