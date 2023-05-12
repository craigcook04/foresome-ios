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

class LogoutViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var yesIAmSureBtn: UIButton!
    @IBOutlet weak var logoutDismissView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapToDismiss()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.logoutDismissView.transform = CGAffineTransform.identity
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
            self.logoutDismissView.transform = CGAffineTransform(translationX: 0, y: self.logoutDismissView.frame.height)
        } completion: { isSucceed in
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func yesIamSureAction(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "user_uid")
            if Auth.auth().currentUser?.uid == nil {
                Singleton.shared.showMessage(message: Messages.logoutSuccess, isError: .success)
                UserDefaults.standard.removeObject(forKey: AppStrings.userDatas)
                Singleton.shared.gotoLogin()
            }
            print("logout successfullyy")
        } catch {
            print("Error while signing out!")
            Singleton.shared.showMessage(message: Messages.logoutError, isError: .error)
        }
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
