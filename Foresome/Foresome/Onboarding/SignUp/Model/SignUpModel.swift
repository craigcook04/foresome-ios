//
//  SignUpModel.swift
//  Foresome
//
//  Created by Piyush Kumar on 30/03/23.
//

import Foundation
import UIKit

class SignUpUserData {
    var fullName: String?
    var emailAddress: String?
    var userPassword: String?
    var userConfirrmPassword: String?
    var userLocation: String?
    var user_profile_pic: String?
    var skill_level: String?
    var user_uid: NSString?

    public init(fullName: String? = "", emailAddress: String? = "", userPassword: String? = "", userConfirrmPassword: String? = "", userLocation: String? = "", user_profile_pic: String? = "", skill_level: String? = "", user_uid: NSString? = "") {
        self.fullName = fullName
        self.emailAddress = emailAddress
        self.userPassword = userPassword
        self.userConfirrmPassword = userConfirrmPassword
        self.userLocation = userLocation
        self.user_profile_pic = user_profile_pic
        self.skill_level = skill_level
        self.user_uid = user_uid
    }
}

class ReturnUserData : Codable {
//    var json: JSON!
    var email: String?
    var name: String?
    var user_location: String?
    var uid: String?
    var user_skill_level: String?
    var createdDate: String?
    var user_profile_pic: String?
}
//
//extension ReturnUserData : Codable {
//    convenience init(json: [String: Any]) {
//        self.init()
//        self.json = json
//
//        if let email = json["email"] as? String {
//            self.email = email
//        }
//
//        if let name = json["name"] as? String {
//            self.name = name
//        }
//
//        if let user_location = json["user_location"] as? String {
//            self.user_location = user_location
//        }
//
//        if let uid = json["uid"] as? String {
//            self.uid = uid
//        }
//
//        if let user_skill_level = json["user_skill_level"] as? String {
//            self.user_skill_level = user_skill_level
//        }
//
//        if let createdDate = json["createdDate"] as? String {
//            self.createdDate = createdDate
//        }
//
//        if let user_profile_pic = json["user_profile_pic"] as? String {
//            self.user_profile_pic = user_profile_pic
//        }
//
//    }
//}
//
//
