//
//  NewsFeedTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
//

import UIKit
protocol NewsFeedTableCellDelegate {
    func moreButton(data: PostListDataModel)
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
    @IBOutlet weak var thirdImageBgView: UIView!
    @IBOutlet weak var imageWholeStack: UIStackView!
    
    var delegate: NewsFeedTableCellDelegate?
    var postdata: PostListDataModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postDescriptionLbl.message = AppStrings.description
        postDescriptionLbl.numberOfLines = 0
        postDescriptionLbl.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //MARK: code for set cell data----
    func setCellPostData(data: PostListDataModel) {
        self.postdata = data
        self.userNameLbl.text = "\(data.author ?? "")--\(data.post_type ?? "")"
        self.profileImage.image = data.profileImage.base64ToImage()
        self.postTime.text = data.createdAt?.toDouble?.toDate.utcToLocal?.toString(format: .full1)
        self.postDescriptionLbl.text = data.postDescription
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        if strings?["uid"] as? String ?? "" == data.uid {
           print("This is owner posts.")
        } else {
            print("This is other users posts.")
        }
        print("image counts in case of posts is --====\(data.image?.count ?? 0)")
        
        
        if (data.image?.count ?? 0) > 0 {
            self.imageWholeStack.isHidden = false
            if (data.image?.count ?? 0) == 1 {
                self.imageOne.isHidden = false
            } else if (data.image?.count ?? 0) == 2 {
                self.imageOne.isHidden = false
                self.imageTwo.isHidden = false
            } else if (data.image?.count ?? 0) == 3 {
                self.imageOne.isHidden = false
                self.imageTwo.isHidden = false
                self.imageThree.isHidden = false
            } else {
                self.imageOne.isHidden = false
                self.imageTwo.isHidden = false
                self.imageThree.isHidden = false
            }
        } else {
            self.imageWholeStack.isHidden = true
        }
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        if let data = self.postdata {
            self.delegate?.moreButton(data: data)
        }
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
