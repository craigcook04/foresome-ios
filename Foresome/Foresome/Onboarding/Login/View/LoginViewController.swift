//
//  LoginViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 21/03/23.
//

import UIKit
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController, LoginViewProtocol {
    
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    @IBOutlet weak var passwordShowBtn: UIButton!
    
    var isValidData: Bool = false
    var presenter: LoginPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginPasswordField.isSecureTextEntry = true
    }
    @IBAction func signInAction(_ sender: UIButton) {
        self.isValidData = self.presenter?.validateField(email:"\(self.loginEmailField.text ?? "")", password:"\(self.loginPasswordField.text ?? "")") ?? false
        if self.isValidData == true {
            self.presenter?.userLogin(email: "\(self.loginEmailField.text ?? "")", password: "\(self.loginPasswordField.text ?? "")")
        } else {
            return
        }
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let vc = SignUpPresenter.createSignUpModule()
        self.pushViewController(vc, true)
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        let forgotPassVC = ForgotPresenter.createForgotPasswordModule()
        self.pushViewController(forgotPassVC, false)
    }
    
    @IBAction func passwordShowAction(_ sender: UIButton) {
        self.passwordShowBtn.isSelected = !sender.isSelected
        self.loginPasswordField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func googleAction(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
       // print("config----\(config)")
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
           else {
                return
            }
         let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in

              // At this point, our user is signed in
            }
        }
        
    }
    
    @IBAction func facebookAction(_ sender: UIButton) {
        
    }
    
    @IBAction func appleAction(_ sender: UIButton) {
        
    }
}

