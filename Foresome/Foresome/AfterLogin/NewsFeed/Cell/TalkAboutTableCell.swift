//
//  TalkAboutTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
//

import UIKit

class TalkAboutTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var talkAboutField: UITextField!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var pollBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
