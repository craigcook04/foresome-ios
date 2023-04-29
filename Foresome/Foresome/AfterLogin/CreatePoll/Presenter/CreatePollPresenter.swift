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
        print("questions name---\(questioName)")
        print("options count is -==\(optionsArray.count)")
        if optionsArray.count == 3 {
            print("number of options are three.")
        } else if optionsArray.count == 4 {
            print("number of options are four.")
        }
        //MARK: code for create poll using firebase ---
        let db = Firestore.firestore()
        let documentsId =  UUID().uuidString
        var pollOptinsArray = [String]()
        for i in 0..<optionsArray.count {
            pollOptinsArray.append(optionsArray[i].optionAdd.text ?? "")
        }
        
        for i in 0..<(pollOptinsArray.count - 1)  {
            if pollOptinsArray[i] == pollOptinsArray[i + 1] {
                Singleton.shared.showMessage(message: "Answer not be same.", isError: .error)
                return 
            }
        }
        ActivityIndicator.sharedInstance.showActivityIndicator()
        print("all posible options count ---\(pollOptinsArray.count)")
        for i in 0..<pollOptinsArray.count {
            print("all possible questions is --- option \(i)---\(pollOptinsArray[i])")
        }
        let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
        print("name is from strings is  -==\(strings?["name"])")
        if let data = strings {
               print("name is from data is -- -==\(data["name"])")
        }
        let createdDate = Date().miliseconds()
        print("created date---=\(createdDate)")
        print("user profile picture----\(strings?["user_profile_pic"] ?? "")")
        print("user name of created poll----= \(strings?["name"] ?? "")")
        print("user uid is ----\(strings?["uid"] ?? "")")
        print("documents id is---==\(documentsId)")
        db.collection("posts").document(documentsId).setData(["author":"\(strings?["name"] ?? "")", "createdAt":"\(Date().miliseconds())", "description":"", "id": "\(documentsId)", "image":"", "photoURL":"", "profile":"\(strings?["user_profile_pic"] ?? "")", "uid":"\(strings?["uid"] ?? "")", "updatedAt":"", "comments":[""], "post_type":"poll", "poll_title":"\(questioName)","poll_options": pollOptinsArray], merge: true) { err in
            if err == nil {
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                Singleton.shared.showMessage(message: "poll created successfully.", isError: .success)
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
