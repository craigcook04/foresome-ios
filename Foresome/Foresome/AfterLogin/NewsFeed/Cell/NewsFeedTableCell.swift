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
import ImageViewer_swift

protocol NewsFeedTableCellDelegate {
    func moreButton(data: PostListDataModel, index: Int)
    func sharePost(data: PostListDataModel, postImage: UIImage)
    func likePostData(data:PostListDataModel, isLiked: Bool)
    func commmnetsPost(data:PostListDataModel, isCommented: Bool, index:Int)
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
    var isLikedPost: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postDescriptionLbl.message = AppStrings.description
        postDescriptionLbl.numberOfLines = 0
        postDescriptionLbl.delegate = self
        addTapGuesture()
    }

    func addTapGuesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapForViewImage))
        self.imageWholeStack.isUserInteractionEnabled = true
        self.imageWholeStack.addGestureRecognizer(tap)
        tap.delegate = self
        tap.numberOfTapsRequired = 1
    }
    
    @objc func tapForViewImage() {
        print("image tap guesture called.")
        let urls = postdata?.image ?? []
        var arrayOfUrl = [URL]()
        arrayOfUrl.removeAll()
        for i in 0..<(postdata?.image?.count ?? 0) {
            if let ulr = URL(string: postdata?.image?[i] ?? "") {
                arrayOfUrl.append(ulr)
            }
        }
        if postdata?.image?.count ?? 0 == 1 {
            imageOne.setupImageViewer(urls: arrayOfUrl)
        } else if postdata?.image?.count ?? 0 == 2 {
            imageOne.setupImageViewer(urls: arrayOfUrl)
            imageTwo.setupImageViewer(urls: arrayOfUrl)
        } else {
            imageOne.setupImageViewer(urls: arrayOfUrl)
            imageTwo.setupImageViewer(urls: arrayOfUrl)
            imageThree.setupImageViewer(urls: arrayOfUrl)
        }
        arrayOfUrl.removeAll()
        arrayOfUrl = []
    }
     
    //MARK: code for set cell data----
    func setCellPostData(data: PostListDataModel) {
       addTapGuesture()
        let stringss = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        let myUserId = (stringss?["uid"] as? String ) ?? ""
        self.postdata = data
        self.userNameLbl.text = "\(data.author ?? "")"
        if data.likedUserList?.count == 0 {
            self.likeBtn.isSelected = false
            self.isLikedPost =  false
        } else {
            data.likedUserList?.forEach({ myUserId in
                if myUserId == myUserId {
                    self.likeBtn.isSelected = true
                    self.isLikedPost =  true
                } else {
                    self.likeBtn.isSelected = false
                    self.isLikedPost =  false
                }
            })
        }
        self.profileImage.image = data.profileImage?.base64ToImage()
        self.likeBtn.setTitle("\(data.likedUserList?.count ?? 0)", for: .normal)
        self.commentBtn.setTitle("\(data.comments?.count ?? 0)", for: .normal)
        self.postDescriptionLbl.message = data.postDescription ?? ""
        self.setDateData(data: data)
        self.setImageData(data: data)
    }
    
    func setImageData(data: PostListDataModel) {
        if (data.image?.count ?? 0) > 0 {
            self.imageWholeStack.isHidden = false
            if (data.image?.count ?? 0) == 1 {
                self.imageOne.isHidden = false
                let url = URL(string: data.image?[0] ?? "")
                self.imageOne.kf.setImage(with: url)
                self.imageTwo.isHidden = true
                self.thirdImageBgView.isHidden = true
                self.secondImageStackview.isHidden = true
                self.thirdImageCountBgVieww.isHidden = true
            } else if (data.image?.count ?? 0) == 2 {
                self.imageOne.isHidden = false
                self.imageTwo.isHidden = false
                let urlFirst = URL(string: data.image?[0] ?? "")
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
                let urlFirst = URL(string: data.image?[0] ?? "")
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
                let urlFirst = URL(string: data.image?[0] ?? "")
                self.imageOne.kf.setImage(with: urlFirst)
                let urlSecond = URL(string: data.image?[1] ?? "")
                self.imageTwo.kf.setImage(with: urlSecond)
                let urlThird = URL(string: data.image?[2] ?? "")
                self.imageThree.kf.setImage(with: urlThird)
                self.imageCountLabel.text = "+\((data.image?.count ?? 0) - 3)"
            }
        } else {
            self.imageWholeStack.isHidden = true
        }
    }
    
    func setDateData(data: PostListDataModel) {
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
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        if let data = self.postdata {
            self.delegate?.moreButton(data: data, index: indexPath?.row ?? 0)
        }
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
        if let data = self.postdata {
            self.delegate?.commmnetsPost(data: data, isCommented: true, index:indexPath?.row ?? 0)
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        var image :UIImage?
        let currentLayer = outerView.layer
        let currentScale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(outerView.bounds.size, false, currentScale)
        guard let currentContext = UIGraphicsGetCurrentContext() else {return}
        currentLayer.render(in: currentContext)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let img = image else { return }
        if let data = self.postdata {
            self.delegate?.sharePost(data: data, postImage: img)
        }
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected = !(sender.isSelected)
        self.delegate?.likePostData(data: self.postdata ?? PostListDataModel(), isLiked: sender.isSelected)
        if self.isLikedPost == true {
            self.likeBtn.setTitle("\((self.postdata?.likedUserList?.count ?? 0) - 1)", for: .normal)
        } else {
            self.likeBtn.setTitle("\((self.postdata?.likedUserList?.count ?? 0) + 1)", for: .normal)
        }
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
