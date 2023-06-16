//
//  TestTableHeader.swift
//  Dumsoraj
//
//  Created by Deepanshu on 15/04/23.
//

import UIKit

protocol TestTableHeaderDelegate {
    func notificationBtnAction()
}

class TestTableHeader: UIView {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tournamentsName: UILabel!
    
    @IBOutlet weak var headerTitle: UILabel!
    
    var delegate: TestTableHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setHeaderData() {
        let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
        if let data = strings {
            let nameValue = "\(AppStrings.userNameSuffix) \(data["name"] as? String ?? "")!"
            self.userName.text = nameValue.uppercased()
        }
        self.backgroundColor = UIColor.white
    }
    
    func setLeaderBoardHeaderData() {
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        if let data = strings {
            let nameValue = "\(AppStrings.userNameSuffix) \(data["name"] as? String ?? "")!"
            self.userName.text = nameValue.uppercased()
        }
        self.headerTitle.text = "Leaderboard"
        self.backgroundColor = UIColor(hexString: "#F0F0F0")
    }
    
    @IBAction func notificationAction(_ sender: UIButton) {
        print("notification action called")
        if let delegate =  self.delegate {
            delegate.notificationBtnAction()
        }
    }
}
