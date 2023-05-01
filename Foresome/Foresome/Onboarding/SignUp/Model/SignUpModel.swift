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
    var bio: String?
}
