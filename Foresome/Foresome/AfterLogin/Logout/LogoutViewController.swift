//
//  LogoutViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 14/04/23.
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

class LogoutViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var yesIAmSureBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func yesIamSureAction(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "user_uid")
            if Auth.auth().currentUser?.uid == nil {
                Singleton.shared.showMessage(message: "logout successfully.", isError: .success)
                Singleton.shared.gotoLogin()
            }
            print("logout successfullyy")
        } catch {
            print("Error while signing out!")
            Singleton.shared.showMessage(message: "Unable to logout.", isError: .error)
        }
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
