//
//  ProfileHeader.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
//

import Foundation
import UIKit

class ProfileHeader: UIView {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
   
    func setHeaderData() {
        let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
        if let data = strings {
            self.userNameLabel.text = "HELLO, \(data["name"] as? String ?? "")!"
        }
    }
    
    @IBAction func notificationAction(_ sender: UIButton) {
        print("notification action called.")
    }
}
