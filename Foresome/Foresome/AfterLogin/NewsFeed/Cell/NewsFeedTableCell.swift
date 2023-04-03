//
//  NewsFeedTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
//

import UIKit

class NewsFeedTableCell: UITableViewCell {
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postDescriptionLbl: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
