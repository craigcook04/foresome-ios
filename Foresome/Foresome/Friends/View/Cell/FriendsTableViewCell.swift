//
//  FriendsTableViewCell.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit
import ImageViewer_swift

protocol FriendsTableViewCellDelegate {
    func addFriend(data:UserListModel?, removeButton: UIButton)
    func makeUnFriend(data:UserListModel?, senderButton: UIButton)
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
    }
    
    //MARK: code for set cell data in friends controller -----
    func setListData(data: UserListModel, isMemberData: Bool, usersFriendsList:[String]) {
        self.usersFriendsList = usersFriendsList
        if isMemberData == true {
            if self.usersFriendsList.contains(data.uid ?? "") == true {
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
        if let createdDate = data.createdDate {
            self.joinedDate.text =  "Joined on \(createdDate.changeFormat(.full3, to: .d2M4y4))"
        } else {
            self.joinedDate.text =  "Joined on 7, Mar 2023"
        }
    }
    
    //MARK: code for set cell data in case of search controller ------
    func showSearchData(searchData: UserListModel, isMemberData: Bool, usersFriendsList:[String], isfromRecent: Bool) {
        if isfromRecent == true {
            self.addFriendsButton.isHidden = true
        } else {
            self.addFriendsButton.isHidden = false
        }
        self.membersData = searchData
        if (searchData.user_profile_pic?.count ?? 0) > 0 {
            self.userProfile.image = searchData.user_profile_pic?.base64ToImage()
        } else {
            self.userProfile.image = UIImage(named: "ic_user_placeholder")
        }
        self.userProfile.setupImageViewer()
        self.userName.text = searchData.name
        self.setDateData(data: searchData)
        //MARK: code for show friend and unfriend data in searched data listing---------
        if usersFriendsList.contains(searchData.uid ?? "") == true {
            addFriendsButton.backgroundColor = .white
            addFriendsButton.setTitle("Unfriend", for: .normal)
            addFriendsButton.layer.borderWidth = 1
            addFriendsButton.layer.borderColor = UIColor(hexString: "#E9E9E9").cgColor
            addFriendsButton.setTitleColor(UIColor(hexString: "#979CA0"), for: .normal)
        } else {
            addFriendsButton.setTitle("Add Friend", for: .normal)
            addFriendsButton.layer.borderWidth = 0
            addFriendsButton.backgroundColor = UIColor(hexString: "#EBFAF4")
            addFriendsButton.setTitleColor(UIColor(hexString: "#40CD93"), for: .normal)
        }
    }
    
    @IBAction func addFriendsAction(_ sender: UIButton) {
        print("add friends called")
        if let delegate = delegate {
            if self.ismembers == true {
                delegate.addFriend(data: self.membersData, removeButton: sender)
            } else {
                delegate.makeUnFriend(data: self.membersData, senderButton: sender)
            }
        }
    }
}




