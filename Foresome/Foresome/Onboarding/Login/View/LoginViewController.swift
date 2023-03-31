//
//  LoginViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 21/03/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    @IBOutlet weak var passwordShowBtn: UIButton!
    var presenter: LoginViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        Singleton.shared.setHomeScreenView()
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {

        let vc = SignUpPresenter.createSignUpModule()
        self.pushViewController(vc, true)
        
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func passwordShowAction(_ sender: UIButton) {
        self.passwordShowBtn.isSelected = !sender.isSelected
        self.loginPasswordField.isSecureTextEntry = self.passwordShowBtn.isSelected
        
    }
    
    @IBAction func googleAction(_ sender: UIButton) {
        
    }
    
    @IBAction func facebookAction(_ sender: UIButton) {
        
    }
    
    @IBAction func appleAction(_ sender: UIButton) {
        
    }
    
}

extension LoginViewController: LoginViewProtocol {
    
}
