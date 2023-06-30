//
//  CommentsTableViewCell.swift
//  Foresome
//
//  Created by Deepanshu on 16/05/23.
//

import UIKit
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentedDate: UILabel!
    @IBOutlet weak var commentLabel: ExpendableLinkLabel!
    @IBOutlet weak var sepratorView: UIView!
    
    let firestoreDb = Firestore.firestore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellData(data:CommentsData) {
        self.setCommentedUserprofile(data: data)
        if data.userId == UserDefaultsCustom.currentUserId {
            print("current loggin user case.")
            let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
            if let data = strings {
                if let image = (data["user_profile_pic"] as? String ?? "").base64ToImage() {
                    profileImage.image = image
                }
            }
        } else {
            print("other than current user case.")
            if (data.userProfile?.count ?? 0) > 0 {
                self.profileImage.image = data.userProfile?.base64ToImage()
            } else {
                self.profileImage.image = UIImage(named: "ic_user_placeholder")
            }
        }
        self.userName.text = data.username
        guard let postDate = data.createdAt?.millisecToDate() else {
            return
        }
        let calendar = Calendar.current
        let diff = calendar.dateComponents([.minute, .hour, .day, .year], from: postDate, to: Date())
        if diff.year == 0 {
            if postDate.isToday {
                if diff.hour ?? 0 < 1 {
                    if diff.minute ?? 0 < 1 {
                        self.commentedDate.text =  "just now"
                    } else {
                        self.commentedDate.text = "\(diff.minute ?? 0) mins"
                    }
                } else {
                    self.commentedDate.text = "\(diff.hour ?? 0) hrs"
                }
            } else if postDate.isYesterday {
                self.commentedDate.text =   "Yesterday"
            } else {
                self.commentedDate.text = postDate.toStringFormat()
            }
        } else {
            self.commentedDate.text  = postDate.toStringFormat()
        }
        self.commentLabel.message = data.body ?? ""
    }
    
    func setCommentedUserprofile(data:CommentsData) {
        if let user_id = data.userId {
            firestoreDb.collection("users").document(user_id).getDocument { snapShotData, error in
                if let data = snapShotData?.data() {
                    let userListData = UserListModel(json: data)
                    if let profilePicture = userListData.user_profile_pic {
                        self.profileImage.image = profilePicture.base64ToImage()
                    }
                }
            }
        }
    }
}
