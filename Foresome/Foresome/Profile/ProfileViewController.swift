//
//  ProfileViewController.swift
//  Foresome
//
//  Created by Deepanshu on 29/03/23.
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

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        self.userLogout()
    }
    
    func getProfileData() {
        let db = Firestore.firestore()
        let currentUserId = UserDefaults.standard.value(forKey: "user_uid") ?? ""
        let currentLogedUserId  = Auth.auth().currentUser?.uid ?? ""
        db.collection("users").document(currentLogedUserId).getDocument { (snapData, error) in
            print("fetched current user data----\(snapData?.data()?["name"])")
        }
    }
    
    func getUserDetails() {
        let db  = Firestore.firestore()
        db.collection("users").getDocuments { (abc, err) in
            abc?.documents.forEach({ data in
                print("fetched data is ---\(data.data()["email"])")
            })
        }
        let currentUserId = UserDefaults.standard.value(forKey: "user_uid") ?? ""
        let currentLogedUserId  = Auth.auth().currentUser?.uid ?? ""
        db.collection("users").document(currentLogedUserId).getDocument { (snapData, error) in
            print("fetched current user data----\(snapData?.data()?["name"])")
        }
        
        db.collection("users").document(currentLogedUserId).getDocument(source: .server) { (data, error)  in
            print("fetched data is-==\(data?.data())")
        }
    }
    
    //MARK: code for logout user from firebase -------
    func userLogout() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "user_uid")
            if Auth.auth().currentUser?.uid == nil {
                Singleton.shared.gotoLogin()
            }
            print("logout successfullyy")
        } catch {
            print("Error while signing out!")
        }
    }
    
    @IBAction func updateEmailAction(_ sender: UIButton) {
        print("update emial action called.")
        UserDefaultsCustom.getUserData()?.name
        UserDefaultsCustom.getUserData()?.email
        UserDefaultsCustom.getUserData()?.createdDate
        
        
       let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
        
        
        
        //getProfileData()
//        getParticularDocData()
    }
    
    func getParticularDocData() {
        let currentUserId = UserDefaults.standard.value(forKey: "user_uid") ?? ""
        let currentLogedUserId  = Auth.auth().currentUser?.uid ?? ""
        let db  = Firestore.firestore()
        let docRef = db.collection("users").document(currentLogedUserId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let property = document.get("name")
                print("Document data: \(property)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func updatePasswordAction(_ sender: UIButton) {
        print("update password action called.")
        getUserDetails()
//        do {
//            try Auth.auth().currentUser?.updatePassword(to: "Text@123")
//        } catch {
//            print("error in update password is -==\(error.localizedDescription)")
//        }
    }
    
    @IBAction func forgotPassAction(_ sender: UIButton) {
        print("forgot pass action called.")
        Auth.auth().sendPasswordReset(withEmail: "deepanshustackgeeks@gmail.com") { (error) in
            if error == nil {
                Singleton.shared.showMessage(message: "link send succes.", isError: .success)
            } else {
                Singleton.shared.showMessage(message: "error in send link", isError: .error)
            }
        }
        Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail:"deepanshustackgeeks@gmail.com")
    }
}
