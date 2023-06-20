//
//  UnFriendViewController.swift
//  Foresome
//
//  Created by Deepanshu on 08/06/23.
//

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

protocol UnFriendViewControllerDelegate {
    func updateFriendsData(friendsListData : [String])
}

class UnFriendViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var unfriendDescription: UILabel!
    @IBOutlet weak var dismissView: UIView!
    
    var userToMakeUnfriends =  UserListModel()
    var usersFriendsList: [String] = []
    let firebaseDb = Firestore.firestore()
    var delegate: UnFriendViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapToDismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userName = "\(userToMakeUnfriends.name ?? "")"
        let textString = "Are you sure you want to unfriend \(userName)? We won’t  tell them they were removed by you."
        unfriendDescription.attributedTextWithMultipleRange(str: textString, color1: UIColor(hexString: "#222831"), font1: UIFont.setCustom(FONT_NAME.poppinsRegular, 15.0), color2: UIColor(hexString: "#222831"), font2: UIFont.setCustom(FONT_NAME.poppinsSemiBold, 15.0), highlightedWords: [userName], alignment: .left, isUnderLine: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.dismissView.transform = CGAffineTransform.identity
        }
    }
    //MARK: code for add atp guesture for dismiss view on tap any part of top view-------
    func tapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissController))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    //MARK: code for dismiss view on tap any part of top view-------
    @objc func dismissController() {
        UIView.animate(withDuration: 0.3) {
            self.dismissView.transform = CGAffineTransform(translationX: 0, y: self.dismissView.frame.height)
        } completion: { isSucceed in
            self.dismiss(animated: false)
        }
    }
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        print("make unfriend request.")
        //        Singleton.shared.showMessage(message: "unfriended succesfully.", isError: .success)
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        var usersFriendsList = strings?["friends"] ?? []
        self.usersFriendsList = usersFriendsList as? [String] ?? []
        let userToMakeUnfriend = userToMakeUnfriends.uid
        self.usersFriendsList.remove(element: userToMakeUnfriend ?? "")
        print("user id to want to remove from friend list ---\(userToMakeUnfriends.uid ?? "")")
        print("data for added to friends list is ---\(self.usersFriendsList)")
        //MARK: code for add friends in users friends listing---
        let currentUserId = UserDefaultsCustom.currentUserId
        print("current login user id ---\(currentUserId)")
        ActivityIndicator.sharedInstance.showActivityIndicator()
        firebaseDb.collection("users").document(currentUserId).setData(["friends":self.usersFriendsList], merge: true) { error  in
            if error == nil {
                Singleton.shared.showMessage(message: "Unfriend successfully.", isError: .success)
                //MARK: code for dismiss view after successfully make unfriends----
                UIView.animate(withDuration: 0.3) {
                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                    self.dismissView.transform = CGAffineTransform(translationX: 0, y: self.dismissView.frame.height)
                } completion: { isSucceed in
                    self.dismiss(animated: false, completion: {
                        if let delegate = self.delegate {
                            delegate.updateFriendsData(friendsListData: self.usersFriendsList)
                        }
                    })
                }
            } else {
                if let error = error {
                    Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                }
            }
        }
    }
}


