//
//  SignUpViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 22/03/23.
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

class SignUpViewController: UIViewController, SignUpViewProtocol {
    
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
        setTapGuesture()
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
        self.setLabelColor()
    }
    
    func setTapGuesture() {
        let tapgesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired = 1
        termsAndPrivacyPolicy.isUserInteractionEnabled = true
        termsAndPrivacyPolicy.addGestureRecognizer(tapgesture)
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = self.termsAndPrivacyPolicy.text else { return }
        let termOfServices = (text as NSString).range(of: AppStrings.termsOfService)
        let privacyPolicy = (text as NSString).range(of: AppStrings.privacyPolicy)
        if gesture.didTapAttributedTextInLabel(label: self.termsAndPrivacyPolicy, inRange: termOfServices) {
            guard let url = URL(string: "https://www.google.com") else { return }
            UIApplication.shared.open(url)
        } else if gesture.didTapAttributedTextInLabel(label: self.termsAndPrivacyPolicy, inRange: privacyPolicy) {
            guard let url = URL(string: "https://www.google.com") else { return }
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        if self.presenter?.validateFields(fullName: self.nameField.text ?? "", email: self.emailField.text ?? "" , password: self.passwordField.text ?? "", confirmPassword: self.confirmPasswordField.text ?? "") == true  {
            guard let password = passwordField.text,
                  password == confirmPasswordField.text else {
                Singleton.shared.showMessage(message: ErrorMessage.enterPasswordConfirmPasswordSame, isError:
                        .error)
                return
            }
            self.presenter?.createNewUser(fullName: self.nameField.text ?? "", email: self.emailField.text ?? "", password: self.passwordField.text ?? "", confirmPassword: self.passwordField.text ?? "")
        } else {
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
    
    func setLabelColor() {
        termsAndPrivacyPolicy.attributedTextWithMultipleRange(str: AppStrings.termAndPrivacy, color1: UIColor.appColor(.blackMain), font1: UIFont(.poppinsMedium, 13),color2: UIColor(named: "Blue_main"), font2: UIFont(.poppinsMedium, 13), highlightedWords: [AppStrings.termsOfService, AppStrings.privacyPolicy], alignment: .left, isUnderLine: true)
    }
}

extension UITapGestureRecognizer {
    // Stored variables
    typealias MethodHandler = () -> Void
    static var stringRange: String?
    static var function: MethodHandler?
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}


