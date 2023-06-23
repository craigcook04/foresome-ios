//
//  UserListDataModel.swift
//  Foresome
//
//  Created by Deepanshu on 30/05/23.
//

import Foundation

class UserListModel: NSObject {
    var json: JSON!
    var name: String?
    var user_skill_level:String?
    var createdDate:String?
    var uid: String?
    var user_location:String?
    var email:String?
    var user_profile_pic:String?
    var friends : [String]?
}

extension UserListModel {
    convenience init(json: [String: Any]) {
        self.init()
        self.json = json
        if let name = json["name"] as? String {
            self.name = name
        }
        if let user_skill_level = json["user_skill_level"] as? String {
            self.user_skill_level = user_skill_level
        }
        if let createdDate = json["createdDate:"] as? String {
            self.createdDate = createdDate
        } else if let createdDate = json["createdDate:"] as? Double {
            self.createdDate = "\(createdDate)"
        }
        if let uid = json["uid"] as? String {
            self.uid = uid
        }
        if let user_location = json["user_location"] as? String {
            self.user_location = user_location
        }
        if let email = json["email"] as? String {
            self.email = email
        }
        if let user_profile_pic = json["user_profile_pic"] as? String {
            self.user_profile_pic = user_profile_pic
        }
        if let friends = json["friends"] as? [String] {
            self.friends = friends
        }
    }
}

