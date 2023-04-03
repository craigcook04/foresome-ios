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
    @IBOutlet var confirmPasswordShowBtn: UIButton!
    @IBOutlet var passwordShowBtn: UIButton!
    
    var presenter: SignUpViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLabelColor()
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        let vc = LoginViewController()
        self.pushViewController(vc, true)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let vc = LocationViewController()
        self.pushViewController(vc, true)
        self.presenter?.validateFields(fullName: self.nameField.text ?? "", email: self.emailField.text ?? "" , password: self.passwordField.text ?? "", confirmPassword: self.confirmPasswordField.text ?? "")
        guard let password = passwordField.text,
              password == confirmPasswordField.text else {
            Singleton.shared.showErrorMessage(error: ErrorMessage.enterPasswordConfirmPasswordSame, isError: .error)
            return
        }
    }
    
    @IBAction func passwordShowAction(_ sender: UIButton) {
        self.passwordShowBtn.isSelected = !sender.isSelected
        self.passwordField.isSecureTextEntry = !self.passwordShowBtn.isSelected
    }
    
    @IBAction func confirmShowAction(_ sender: UIButton) {
        self.confirmPasswordShowBtn.isSelected = !sender.isSelected
        self.confirmPasswordField.isSecureTextEntry = !self.confirmPasswordShowBtn.isSelected
    }
    
    func setLabelColor(){
        termsAndPrivacyPolicy.attributedTextWithMultipleRange(str: AppStrings.termAndPrivacy, color1: UIColor.appColor(.blackMain), font1: UIFont(.poppinsMedium, 13),color2: UIColor(named: "Blue_main"), font2: UIFont(.poppinsMedium, 13), highlightedWords: [AppStrings.termsOfService,AppStrings.privacyPolicy],alignment: .left, isUnderLine: true)
    }
}
extension SignUpViewController: SignUpViewProtocol {
    
}
