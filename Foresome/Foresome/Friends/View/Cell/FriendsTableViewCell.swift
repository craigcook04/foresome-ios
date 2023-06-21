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
    var usersFriendsList: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellData(isMemberData: Bool) {
        self.ismembers = isMemberData
//        if isMemberData == true {
//            addFriendsButton.setTitle("Add Friend", for: .normal)
//            addFriendsButton.layer.borderWidth = 0
//            addFriendsButton.backgroundColor = UIColor(hexString: "#EBFAF4")
//            addFriendsButton.titleLabel?.textColor = UIColor(hexString: "#40CD93")
//        } else {
//            addFriendsButton.backgroundColor = .white
//            addFriendsButton.setTitle("Unfriend", for: .normal)
//            addFriendsButton.layer.borderWidth = 1
//            addFriendsButton.layer.borderColor = UIColor(hexString: "#E9E9E9").cgColor
//            addFriendsButton.titleLabel?.textColor = UIColor(hexString: "#979CA0")
//        }
    }
    
    func setListData(data: UserListModel, isMemberData: Bool, usersFriendsList:[String]) {
      //  let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
//        var usersFriendsList = strings?["friends"] ?? []
        self.usersFriendsList = usersFriendsList
        if isMemberData == true {
            if self.usersFriendsList.contains(data.uid ?? "") == true{
                addFriendsButton.setTitle("Remove", for: .normal)
                addFriendsButton.layer.borderWidth = 0
                addFriendsButton.backgroundColor = UIColor(hexString: "#EBFAF4")
                addFriendsButton.setTitleColor(UIColor(hexString: "#40CD93"), for: .normal)
            } else {
                addFriendsButton.setTitle("Add Friend", for: .normal)
                addFriendsButton.layer.borderWidth = 0
                addFriendsButton.backgroundColor = UIColor(hexString: "#EBFAF4")
                addFriendsButton.setTitleColor(UIColor(hexString: "#40CD93"), for: .normal)
            }
            
//            self.usersFriendsList.forEach({ usersData in
//                if usersData == data.uid {
//                    addFriendsButton.setTitle("Remove", for: .normal)
//                    addFriendsButton.layer.borderWidth = 0
//                    addFriendsButton.backgroundColor = UIColor(hexString: "#EBFAF4")
//                    addFriendsButton.setTitleColor(UIColor(hexString: "#40CD93"), for: .normal)
//                } else {
//                    addFriendsButton.setTitle("Add Friend", for: .normal)
//                    addFriendsButton.layer.borderWidth = 0
//                    addFriendsButton.backgroundColor = UIColor(hexString: "#EBFAF4")
//                    addFriendsButton.setTitleColor(UIColor(hexString: "#40CD93"), for: .normal)
//                }
//            })
        } else {
            addFriendsButton.backgroundColor = .white
            addFriendsButton.setTitle("Unfriend", for: .normal)
            addFriendsButton.layer.borderWidth = 1
            addFriendsButton.layer.borderColor = UIColor(hexString: "#E9E9E9").cgColor
            addFriendsButton.setTitleColor(UIColor(hexString: "#979CA0"), for: .normal)
        }
        self.membersData = data
        if (data.user_profile_pic?.count ?? 0) > 0 {
            self.userProfile.image = data.user_profile_pic?.base64ToImage()
        } else {
            self.userProfile.image = UIImage(named: "ic_user_placeholder")
        }
        self.userProfile.setupImageViewer()
        self.userName.text = data.name
        self.setDateData(data: data)
    }
    
    func setDateData(data: UserListModel) {
//        guard let postDate = data.createdDate?.millisecToDate() else {
//        let stringFormat = data.createdDate ?? ""
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yy"
//        //"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        dateFormatter.date(from: stringFormat)
//        guard let postDate = dateFormatter.date(from: stringFormat) else {
//            return
//        }
//        let calendar = Calendar.current
//        let diff = calendar.dateComponents([.minute, .hour, .day, .year], from: postDate, to: Date())
//        if diff.year == 0 {
//            if postDate.isToday {
//                if diff.hour ?? 0 < 1 {
//                    if diff.minute ?? 0 < 1 {
//                        self.joinedDate.text = "Joined on just now"
//                    } else {
//                        self.joinedDate.text = "Joined on \(diff.minute ?? 0) mins"
//                    }
//                } else {
//                    self.joinedDate.text = "Joined on \(diff.hour ?? 0) hrs"
//                }
//            } else if postDate.isYesterday {
//                self.joinedDate.text =  "Joined on Yesterday"
//            } else {
//                self.joinedDate.text = "Joined on \(postDate.toUserListFormat())"
//            }
//        } else {
//            self.joinedDate.text = "Joined on \(postDate.toUserListFormat())"
//        }

        if let createdDate = data.createdDate {
            self.joinedDate.text =  "Joined on \(createdDate.changeFormat(.full3, to: .d2M4y4))"
        } else {
            self.joinedDate.text =  "Joined on 7, Mar 2023"
        }
    }
    
    func showSearchData(searchData: UserListModel) {
        self.membersData = searchData
        if (searchData.user_profile_pic?.count ?? 0) > 0 {
            self.userProfile.image = searchData.user_profile_pic?.base64ToImage()
        } else {
            self.userProfile.image = UIImage(named: "ic_user_placeholder")
        }
        self.userProfile.setupImageViewer()
        self.userName.text = searchData.name
        self.setDateData(data: searchData)
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




