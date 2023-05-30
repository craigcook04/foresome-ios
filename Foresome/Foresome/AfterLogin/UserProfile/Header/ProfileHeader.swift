//
//  ProfileHeader.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
//

import Foundation
import UIKit

protocol ProfileHeaderDelegate {
    func notificationbtnAction()
}


class ProfileHeader: UIView {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
   
    var delegate: ProfileHeaderDelegate?
    
    
    func setHeaderData() {
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        if let data = strings {
            let nameValue = "\(AppStrings.userNameSuffix) \(data["name"] as? String ?? "")!"
            self.userNameLabel.text = nameValue.uppercased()
        }
    }
    
    @IBAction func notificationAction(_ sender: UIButton) {
        print("notification action called.")
        
        if let delegate = delegate {
            delegate.notificationbtnAction()
        }
    }
}
