//
//  NewsFeedTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
//

import UIKit
protocol NewsFeedTableCellDelegate {
    func moreButton()
}

class NewsFeedTableCell: UITableViewCell,UIActionSheetDelegate {
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postDescriptionLbl: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    var delegate: NewsFeedTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
         setLabelColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setLabelColor(){
        postDescriptionLbl.attributedTextWithMultipleRange(str: AppStrings.description, color1: UIColor.appColor(.blackMain), font1: UIFont(.poppinsRegular, 14),color2: UIColor.appColor(.blueMain), font2: UIFont(.poppinsRegular, 14), highlightedWords: [AppStrings.readMore],alignment: .left)
       
    }
    @IBAction func moreAction(_ sender: UIButton) {
        self.delegate?.moreButton()
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected = !(sender.isSelected)
        likeBtn.setTitle("1", for: .selected)
    }
}
