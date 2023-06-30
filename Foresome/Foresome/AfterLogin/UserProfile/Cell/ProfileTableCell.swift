//
//  ProfileTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
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

protocol ProfileTableCellDelegate {
    func updateNotificationSetting()
}

class ProfileTableCell: UITableViewCell {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var titleIcon: UIImageView!
    
    var delegate:ProfileTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setNotificationToggle() {
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        if let data = strings {
            let notificationValue = (data["notification_settings"] as? String ?? "")
            if notificationValue == "true" {
                toggleButton.isSelected = true
            } else {
                toggleButton.isSelected = false
            }
        }
    }
    
    @IBAction func toggleAction(_ sender: UIButton) {
        sender.isSelected = !(sender.isSelected)
        let db = Firestore.firestore()
        let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
        db.collection("users").document(documentsId).setData(["notification_settings" : "\(sender.isSelected)"], merge: true, completion: { errors in
            if errors == nil {
                if let delegate = self.delegate {
                    db.collection("users").document(UserDefaultsCustom.currentUserId).getDocument { (snapData, error) in
                        if let data = snapData?.data() {
                            UserDefaults.standard.set(data, forKey: AppStrings.userDatas)
                            delegate.updateNotificationSetting()
                        }
                    }
                }
            } else {
                if let error = errors {
                    Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                }
            }
        })
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
      print("next button action called.")
    }
}
