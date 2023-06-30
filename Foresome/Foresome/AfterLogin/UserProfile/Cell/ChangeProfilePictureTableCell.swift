//
//  ChangeProfilePictureTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
//

import UIKit

class ChangeProfilePictureTableCell: UITableViewCell {
    
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var userProfilePicImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellData()
    }
    
    func setCellData() {
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        if let data = strings {
            if let image = (data["user_profile_pic"] as? String ?? "").base64ToImage() {
                userProfilePicImageView.image = image
            }
            let imagefound = (data["user_profile_pic"] as? String ?? "")
            if imagefound.count > 0 {
                self.changeProfileButton.setTitle("Change Profile Picture", for: .normal)
            } else {
                self.changeProfileButton.setTitle("Add Profile Picture", for: .normal)
            }
        }
    }
    
    @IBAction func changeProfileAction(_ sender: UIButton) {
        print("change profile action called.")
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        print("next button action called.")
    }
}
