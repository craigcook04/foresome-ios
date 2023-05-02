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
    var socialLoginId: String?
    var userProfileString: String?
    
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
        ActivityIndicator.sharedInstance.showActivityIndicator()
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            print(self as Any)
            guard error == nil else {
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                return
            }
            self.socialLoginId = user.userID
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                if error == nil {
                    guard let data = result?.user.providerData else {
                        return
                    }
                    let profileUrlString = data.first?.photoURL ?? URL(fileURLWithPath: "")
                    let url = profileUrlString
                    if let data = try? Data(contentsOf: url) {
                        let image: UIImage = UIImage(data: data) ?? UIImage()
                        self.userProfileString = image.convertImageToBase64String()
                    }
                    UserDefaultsCustom.setValue(value:(self.socialLoginId as? NSString) ?? "", forKey: "user_uid")
                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                    Singleton.shared.setHomeScreenView()
                    let db = Firestore.firestore()
                    db.collection("users").getDocuments { (querySnapshot, err) in
                        ActivityIndicator.sharedInstance.hideActivityIndicator()
                        querySnapshot?.documents.enumerated().forEach({ (index, document) in
                            if document.documentID == self.socialLoginId {
                                db.collection("users").document(self.socialLoginId ?? "").getDocument { (snapData, error) in
                                    if let data = snapData?.data() {
                                        let userdata = ReturnUserData()
                                        UserDefaults.standard.set(data, forKey: AppStrings.userDatas)
                                    }
                                }
                            } else {
                                db.collection("users").document(self.socialLoginId ?? "").setData(["name":"\(result?.user.displayName ?? "")", "email":"\(result?.user.email ?? "")", "createdDate:":"\(String(describing: Date().localToUtc))", "uid": self.socialLoginId ?? "", "user_location":"", "user_profile_pic":"\(self.userProfileString ?? "")", "user_skill_level":""]) { error in
                                    if error == nil {
                                        db.collection("users").document(self.socialLoginId ?? "").getDocument { (snapData, error) in
                                            if let data = snapData?.data() {
                                                let userdata = ReturnUserData()
                                                UserDefaults.standard.set(data, forKey: AppStrings.userDatas)
                                            }
                                        }
                                    } else {
                                        Singleton.shared.showMessage(message: error?.localizedDescription ?? "", isError: .error)
                                    }
                                }
                            }
                        })
                    }
                } else {
                    if let foundError = error {
                        Singleton.shared.showMessage(message: foundError.localizedDescription, isError: .error)
                    }
                }
            }
        }
    }
    
    @IBAction func facebookAction(_ sender: UIButton) {
        
    }
    
    @IBAction func appleAction(_ sender: UIButton) {
        
    }
}

