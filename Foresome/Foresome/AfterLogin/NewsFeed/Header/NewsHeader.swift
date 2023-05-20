//
//  NewsHeader.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
//

import Foundation
import UIKit

protocol NewsHeaderProtocol {
    func notificationBtnAction()
}

class NewsHeader: UIView {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var eventLbl: UILabel!
    @IBOutlet weak var memberButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var membersView: UIView!
    @IBOutlet weak var friendsView: UIView!
    @IBOutlet weak var bellButton: UIButton!
    
    var delegate: NewsHeaderProtocol?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setHeaderData() {
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        if let data = strings {
            let nameValue = "\(AppStrings.userNameSuffix) \(data["name"] as? String ?? "")!"
            self.userNameLbl.text = nameValue.uppercased()
        }
    }
    
    @IBAction func notificationAction(_ sender: UIButton) {
        self.delegate?.notificationBtnAction()
    }
    
    @IBAction func memberAction(_ sender: UIButton) {
        self.memberButton.titleLabel?.textColor = UIColor.appColor(.green_main)
        self.membersView.backgroundColor = UIColor.appColor(.green_main)
        self.friendsView.backgroundColor = UIColor.appColor(.themeWhite)
        self.friendsButton.titleLabel?.textColor = UIColor.appColor(.white_title)
    }
    
    @IBAction func friendAction(_ sender: UIButton) {
        self.memberButton.titleLabel?.textColor = UIColor.appColor(.white_title)
        self.membersView.backgroundColor = UIColor.appColor(.themeWhite)
        self.friendsView.backgroundColor = UIColor.appColor(.green_main)
        self.friendsButton.setTitleColor(.appColor(.green_main), for: .normal)
    }
}
