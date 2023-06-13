//
//  FriendsTableViewCell.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit
import ImageViewer_swift

protocol FriendsTableViewCellDelegate {
    func addFriend(data:UserListModel?)
    func makeUnFriend(data:UserListModel?)
}

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addFriendsButton: UIButton!
    
    @IBOutlet weak var userProfile: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var joinedDate: UILabel!
    
    var delegate: FriendsTableViewCellDelegate?
    
    var ismembers: Bool?
    
    var membersData: UserListModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellData(isMemberData: Bool) {
        self.ismembers = isMemberData
        if isMemberData == true {
            addFriendsButton.setTitle("Add Friend", for: .normal)
            addFriendsButton.layer.borderWidth = 0
            addFriendsButton.backgroundColor = UIColor(hexString: "#EBFAF4")
            addFriendsButton.titleLabel?.textColor = UIColor(hexString: "#40CD93")
        } else {
            addFriendsButton.backgroundColor = .white
            addFriendsButton.setTitle("Unfriend", for: .normal)
            addFriendsButton.layer.borderWidth = 1
            addFriendsButton.layer.borderColor = UIColor(hexString: "#E9E9E9").cgColor
            addFriendsButton.titleLabel?.textColor = UIColor(hexString: "#979CA0")
        }
    }
    
    func setListData(data: UserListModel) {
        self.membersData = data
        self.userProfile.image = data.user_profile_pic?.base64ToImage()
        self.userName.text = data.name
        self.setDateData(data: data)
        self.userProfile.setupImageViewer()
    }
    
    func setDateData(data: UserListModel) {
//        guard let postDate = data.createdDate?.millisecToDate() else {
        let stringFormat = data.createdDate ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        //"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.date(from: stringFormat)
        guard let postDate = dateFormatter.date(from: stringFormat) else {
            return
        }
        let calendar = Calendar.current
        let diff = calendar.dateComponents([.minute, .hour, .day, .year], from: postDate, to: Date())
        if diff.year == 0 {
            if postDate.isToday {
                if diff.hour ?? 0 < 1 {
                    if diff.minute ?? 0 < 1 {
                        self.joinedDate.text = "Joined on just now"
                    } else {
                        self.joinedDate.text = "Joined on \(diff.minute ?? 0) mins"
                    }
                } else {
                    self.joinedDate.text = "Joined on \(diff.hour ?? 0) hrs"
                }
            } else if postDate.isYesterday {
                self.joinedDate.text =  "Joined on Yesterday"
            } else {
                self.joinedDate.text = "Joined on \(postDate.toUserListFormat())"
            }
        } else {
            self.joinedDate.text = "Joined on \(postDate.toUserListFormat())"
        }
    }
     
    @IBAction func addFriendsAction(_ sender: UIButton) {
        print("add friends called")
        if let delegate = delegate {
            if self.ismembers == true {
                delegate.addFriend(data: self.membersData)
            } else {
                delegate.makeUnFriend(data: self.membersData)
            }
        }
    }
}
