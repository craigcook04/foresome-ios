//
//  SignUpViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 22/03/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var termsAndPrivacyPolicy: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
 //   var presenter: SignUpViewPresenter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelColor()
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        let vc = LoginViewController()
        self.popVC()
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
    }
    
    @IBAction func passwordShowAction(_ sender: UIButton) {
    }
    
    @IBAction func confirmShowAction(_ sender: UIButton) {
    }
    
    func setLabelColor(){
        termsAndPrivacyPolicy.attributedTextWithMultipleRange(str: AppStrings.termAndPrivacy, color1: UIColor.appColor(.blackMain) , font1: UIFont(.poppinsMedium, 13),color2: UIColor(named: "Blue_main") , font2: UIFont(.poppinsMedium, 13), highlightedWords: [AppStrings.termsOfService,AppStrings.privacyPolicy],alignment: .left, isUnderLine: true)
        
    }
}
//extension SignUpViewController: SignUpViewProtocol {
//
//}
