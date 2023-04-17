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
    @IBOutlet weak var postDescriptionLbl: ExpendableLinkLabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var imageCountLabel: UILabel!
    
    var delegate: NewsFeedTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postDescriptionLbl.message = AppStrings.description
        postDescriptionLbl.numberOfLines = 0
        postDescriptionLbl.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

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

extension NewsFeedTableCell: ExpendableLinkLabelDelegate {
    func tapableLabel(_ label: ExpendableLinkLabel, didTapUrl url: String, atRange range: NSRange) {     
    }
    
    func tapableLabel(_ label: ExpendableLinkLabel, didTapString string: String, atRange range: NSRange) {
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
    }
}
