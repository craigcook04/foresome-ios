//
//  PollResultTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 04/04/23.
//

import UIKit

class PollResultTableCell: UITableViewCell {
    
    
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var postDescriptionLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var pollItemLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var percentLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected = !(sender.isSelected)
        likeBtn.setTitle("1", for: .selected)
        
    }
    
    
    @IBAction func commentAction(_ sender: UIButton) {
    }
    
    @IBAction func shareAction(_ sender: Any) {
    }
}
