//
//  SignUpViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 22/03/23.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var termsAndPrivacyPolicy: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabelColor()
    }
    @IBAction func loginAction(_ sender: Any) {
        let vc = LoginViewController()
        self.popVC()
    }
    
    func setLabelColor(){
        termsAndPrivacyPolicy.attributedTextWithMultipleRange(str: AppStrings.termAndPrivacy, color1: UIColor.appColor(.blackMain) , font1: UIFont(.poppinsMedium, 13),color2: UIColor(named: "Blue_main") , font2: UIFont(.poppinsMedium, 13), highlightedWords: [AppStrings.termsOfService,AppStrings.privacyPolicy],alignment: .left, isUnderLine: true)
        
           }
    }

