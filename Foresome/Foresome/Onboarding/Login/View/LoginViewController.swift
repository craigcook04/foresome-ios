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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        let vc = LocationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func passwordShowAction(_ sender: UIButton) {
    }
    
    @IBAction func googleAction(_ sender: UIButton) {
    }
    
    @IBAction func facebookAction(_ sender: UIButton) {
    }
    
    @IBAction func appleAction(_ sender: UIButton) {
    }
    
    
}
