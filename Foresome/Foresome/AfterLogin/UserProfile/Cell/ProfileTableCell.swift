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

class ProfileTableCell: UITableViewCell {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var titleIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func toggleAction(_ sender: UIButton) {
        sender.isSelected = !(sender.isSelected)
      //  print("sender is selected--\(sender.isSelected)")
        let db = Firestore.firestore()
        let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
        db.collection("users").document(documentsId).setData(["notification_settings" : "\(sender.isSelected)"], merge: true)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
      //  print("next button called")
    }
}
