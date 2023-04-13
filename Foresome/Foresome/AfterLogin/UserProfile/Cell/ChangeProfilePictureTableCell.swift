//
//  ChangeProfilePictureTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
//

import UIKit

class ChangeProfilePictureTableCell: UITableViewCell {
    
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var profilePictureDisplay: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func changeProfileAction(_ sender: UIButton) {
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
    }
}
