//
//  ForgotPasswordViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 22/03/23.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var forgotLabel: UILabel!
    @IBOutlet weak var submitBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboard()
        self.forgotLabel.text = AppStrings.titleLbl
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    func setKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            submitBottomConstraint.constant = keyboardHeight+23
            view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        submitBottomConstraint.constant = 40
        view.layoutIfNeeded()
    }
    
    @IBAction func submitAction(_ sender: Any) {
    }
}
