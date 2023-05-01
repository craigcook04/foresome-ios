//
//  TestTableHeader.swift
//  Dumsoraj
//
//  Created by Deepanshu on 15/04/23.
//

import UIKit

class TestTableHeader: UIView {
 
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tournamentsName: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func notificationAction(_ sender: UIButton) {
        print("notification action called")
    }
    
    func setHeaderData() {
        let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
        if let data = strings {
            let nameValue = "\(AppStrings.userNameSuffix) \(data["name"] as? String ?? "")!"
            self.userName.text = nameValue.uppercased()
        }
    }
}
