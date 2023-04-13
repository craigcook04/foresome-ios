//
//  ProfileTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
//

import UIKit

class ProfileTableCell: UITableViewCell {
    
   
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var titleIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func toggleAction(_ sender: UIButton) {
        sender.isSelected = !(sender.isSelected)
       
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
    }
}
