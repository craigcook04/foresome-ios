//
//  LoginViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 21/03/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        let vc = LocationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func signUpAction(_ sender: Any) {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
}
