//
//  NewsFeedTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
//

import UIKit
import Kingfisher
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

protocol NewsFeedTableCellDelegate {
    func moreButton(data: PostListDataModel)
    func sharePost(data: PostListDataModel, postImage: UIImage)
    func likePostData(data:PostListDataModel, isLiked: Bool)
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
    @IBOutlet weak var thirdImageCountBgVieww: UIView!
    @IBOutlet weak var secondImageStackview: UIStackView!
    @IBOutlet weak var outerView: UIView!
    
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
        self.userNameLbl.text = "\(data.author ?? "")"
        self.profileImage.image = data.profileImage.base64ToImage()
        self.likeBtn.setTitle("\(data.likedUserList.count)", for: .normal)
        
        data.likedUserList.forEach({ likes in
            if likes == data.uid {
                self.likeBtn.isSelected = true
            } else {
                self.likeBtn.isSelected = false
            }
        })
        print("docs id is --==\(data.id ?? "")")
        for i in 0..<(data.image?.count ?? 0) {
            print("feed images is -----\(data.image?[i] ?? "")")
        }
        guard let postDate = data.createdAt?.millisecToDate() else {
            return
        }
        let calendar = Calendar.current
        let diff = calendar.dateComponents([.minute, .hour, .day, .year], from: postDate, to: Date())
        if diff.year == 0 {
            if postDate.isToday {
                if diff.hour ?? 0 < 1 {
                    if diff.minute ?? 0 < 1 {
                        self.postTime.text = "just now"
                    } else {
                        self.postTime.text = "\(diff.minute ?? 0) mins"
                    }
                } else {
                    self.postTime.text = "\(diff.hour ?? 0) hrs"
                }
            } else if postDate.isYesterday {
                self.postTime.text =  "Yesterday"
            } else {
                self.postTime.text = postDate.toStringFormat()
            }
        } else {
            self.postTime.text = postDate.toStringFormat()
        }
        self.postDescriptionLbl.message = data.postDescription ?? ""
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
                let url = URL(string: data.image?.first ?? "")
                self.imageOne.kf.setImage(with: url)
                self.imageTwo.isHidden = true
                self.thirdImageBgView.isHidden = true
                self.secondImageStackview.isHidden = true
                self.thirdImageCountBgVieww.isHidden = true
            } else if (data.image?.count ?? 0) == 2 {
                self.imageOne.isHidden = false
                
                self.imageTwo.isHidden = false
                
                let urlFirst = URL(string: data.image?.first ?? "")
                self.imageOne.kf.setImage(with: urlFirst)
                
                let urlSecond = URL(string: data.image?[1] ?? "")
                self.imageTwo.kf.setImage(with: urlSecond)
                
                self.secondImageStackview.isHidden = false
                self.thirdImageCountBgVieww.isHidden = true
                self.thirdImageBgView.isHidden = true
            } else if (data.image?.count ?? 0) == 3 {
                self.imageOne.isHidden = false
                self.imageTwo.isHidden = false
                self.imageThree.isHidden = false
                self.thirdImageBgView.isHidden = false
                self.secondImageStackview.isHidden = false
                
                let urlFirst = URL(string: data.image?.first ?? "")
                self.imageOne.kf.setImage(with: urlFirst)
                
                let urlSecond = URL(string: data.image?[1] ?? "")
                self.imageTwo.kf.setImage(with: urlSecond)
                
                let urlThird = URL(string: data.image?[2] ?? "")
                self.imageThree.kf.setImage(with: urlThird)
                
                self.thirdImageCountBgVieww.isHidden = true
            } else {
                self.imageOne.isHidden = false
                self.imageTwo.isHidden = false
                self.imageThree.isHidden = false
                self.thirdImageBgView.isHidden = false
                self.thirdImageCountBgVieww.isHidden = false
                self.secondImageStackview.isHidden = false
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
       print("comments section in progress.....")
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
//        outerView.backgroundColor = .black
        var image :UIImage?
        let currentLayer = outerView.layer
        let currentScale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(outerView.bounds.size, false, currentScale)
        guard let currentContext = UIGraphicsGetCurrentContext() else {return}
        currentLayer.render(in: currentContext)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let img = image else { return }
//        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
       // Singleton.shared.showMessage(message: "QR code downloaded and saved to Gallery", isError: .success)
//        outerView.backgroundColor = .clear
        if let data = self.postdata {
            self.delegate?.sharePost(data: data, postImage: img)
        }
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected = !(sender.isSelected)
        likeBtn.setTitle("1", for: .selected)
//        self.delegate?.likePostData(data: self.postdata ?? PostListDataModel(), isLiked: sender.isSelected)
//        if sender.isSelected == true {
//            self.likeBtn.setTitle("\((self.postdata?.likedUserList.count ?? 0) + 1)", for: .normal)
//        } else {
//            self.likeBtn.setTitle("\((self.postdata?.likedUserList.count ?? 0) + -1)", for: .normal)
//        }
    }
}

extension NewsFeedTableCell: ExpendableLinkLabelDelegate {
    func tapableLabel(_ label: ExpendableLinkLabel, didTapUrl url: String, atRange range: NSRange) {
        print("url is -----\(url)")
    }
    
    func tapableLabel(_ label: ExpendableLinkLabel, didTapString string: String, atRange range: NSRange) {
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
    }
}
