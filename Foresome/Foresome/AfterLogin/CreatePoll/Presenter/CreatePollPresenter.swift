//
//  CreatePollPresenter.swift
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

class CreatePollPresenter: CreatePollPresenterProtocol {
    
    var view: CreatePollViewProtocol?
    
    static func createPollModule() -> CreatePollViewController {
        let view = CreatePollViewController()
        var presenter: CreatePollPresenterProtocol = CreatePollPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func createNewPoll(questioName: String, optionsArray: [AdditionalOption]) {
        //MARK: code for create poll using firebase ---
        let db = Firestore.firestore()
        let documentsId =  UUID().uuidString
        var pollOptinsArray = [String]()
        
        var pollAnswersCountArray = [Int]()
        var selectedAnserArray = [Int]()
        
        for i in 0..<optionsArray.count {
            pollOptinsArray.append(optionsArray[i].optionAdd.text ?? "")
            pollAnswersCountArray.append(0)
            selectedAnserArray.append(0)
        }
        
        for i in 0..<(pollOptinsArray.count - 1) {
            if pollOptinsArray[i] == pollOptinsArray[i + 1] {
                Singleton.shared.showMessage(message: Messages.optionsNotSame, isError: .error)
                return
            }
        }
        ActivityIndicator.sharedInstance.showActivityIndicator()
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        let createdDate = Date().miliseconds()
        db.collection("posts").document(documentsId).setData(["author":"\(strings?["name"] ?? "")", "createdAt":"\(Date().miliseconds())", "description":"", "id": "\(documentsId)", "image":"", "photoURL":"", "profile":"\(strings?["user_profile_pic"] ?? "")", "uid":"\(strings?["uid"] ?? "")", "updatedAt":"", "comments":[""], "post_type":"poll", "poll_title":"\(questioName)","poll_options": pollOptinsArray, "selectedAnswerCount":pollAnswersCountArray, "selectedAnswer":selectedAnserArray, "ispollEnded": false, "likedUserList": [String](), "voted_user_list": [String](), "selectedAnserIndex": 0], merge: true) { err in
            if err == nil {
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                Singleton.shared.showMessage(message: Messages.pollCreatedMsg, isError: .success)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdatePollData"), object: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    if let view = self.view as? CreatePollViewController {
                        view.popToRootViewController(false)
                    }
                })
            } else {
                Singleton.shared.showMessage(message: err?.localizedDescription ?? "", isError: .error)
                return
            }
        }
    }
}
