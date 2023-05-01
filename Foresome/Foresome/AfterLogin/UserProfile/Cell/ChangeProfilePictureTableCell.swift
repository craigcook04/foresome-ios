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
        }
    }
    
    @IBAction func changeProfileAction(_ sender: UIButton) {
        
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
    }
}
