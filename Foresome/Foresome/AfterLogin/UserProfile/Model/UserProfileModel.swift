//
//  UserProfileModel.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
//

import Foundation
import UIKit

enum SettingRow {
    case changeProfilePicture
    case editProfile
    case manageSkillLevel
    case notificationSettings
    case termsOfServices
    case privacyPolicy
    case aboutApp
    case logout
    case rightArrow
    case version
}

class SettingsRowDataModel: NSObject {
    var icon : UIImage?
    var unselectedIcon:UIImage?
    var title:String?
    var isSelected:Bool = false
    var type:SettingRow?
    
    
    public init(title:String?,rightIcon:UIImage?,isSelected:Bool = false,unselectedIcon:UIImage? = nil, settingRow:SettingRow?, rightArrow: UIImage?, version: String?) {
        self.title = title
        self.icon = rightIcon
        self.isSelected = isSelected
        self.unselectedIcon = unselectedIcon
        self.type = settingRow
    }
}

class Profile {
    static var array: [SettingsRowDataModel] = [
        SettingsRowDataModel.init(title: AppStrings.changeProfilePicture, rightIcon: UIImage(named: "pic"), settingRow: .changeProfilePicture, rightArrow: UIImage(named: "ic_next_arrow"), version: nil),
        SettingsRowDataModel.init(title: AppStrings.editProfile, rightIcon: UIImage(named: "ic_edit_profile"), settingRow: .editProfile, rightArrow: UIImage(named: "ic_next_arrow"), version: nil),
        SettingsRowDataModel.init(title: AppStrings.skillLevel, rightIcon: UIImage(named: "ic_manage_skills"), settingRow: .manageSkillLevel, rightArrow: UIImage(named: "ic_next_arrow"), version: nil),
        SettingsRowDataModel.init(title: AppStrings.notificationSetting, rightIcon: UIImage(named: "ic_notification_settings"), unselectedIcon: UIImage(named: "toggle_off_ic"), settingRow: .notificationSettings, rightArrow: UIImage(named: "switch_on"), version: nil),
        SettingsRowDataModel.init(title: AppStrings.termsOfServices, rightIcon: UIImage(named: "ic_terms_of_services"), settingRow: .termsOfServices, rightArrow: UIImage(named: "ic_next_arrow"), version: nil),
        SettingsRowDataModel.init(title: AppStrings.privacyPolicy, rightIcon: UIImage(named: "ic_privacy_policy"), settingRow: .privacyPolicy, rightArrow: UIImage(named: "ic_next_arrow"), version: nil),
        SettingsRowDataModel.init(title: AppStrings.aboutApp, rightIcon: UIImage(named: "ic_info"), settingRow: .aboutApp, rightArrow: nil, version: "5.2.1.155"),
        SettingsRowDataModel.init(title: AppStrings.logout, rightIcon: UIImage(named: "ic_logout"), settingRow: .logout, rightArrow: nil, version: nil),
    ]
}
