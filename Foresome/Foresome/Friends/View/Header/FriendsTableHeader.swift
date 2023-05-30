//
//  FriendsTableHeader.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit


protocol FriendsTableHeaderDelegate {
    func searchData()
    func membersAction()
    func friendsAction()
    func notificationBtnAction()
}

class FriendsTableHeader: UIView, UITextFieldDelegate {
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var membersButton: UIButton!
    @IBOutlet weak var membersView: UIView!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var friendsView: UIView!
    
    var delegate: FriendsTableHeaderDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setHeaderData() {
        searchTextField.delegate = self
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        if let data = strings {
            let nameValue = "\(AppStrings.userNameSuffix) \(data["name"] as? String ?? "")!"
            self.userNamelabel.text = nameValue.uppercased()
        }
    }
    
    @IBAction func notificationAction(_ sender: UIButton) {
        print("hello ")
        
        if let delegate = delegate {
            delegate.notificationBtnAction()
        }
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        print("hello  bbv")
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.searchData()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func membersAction(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.membersAction()
        }
        self.membersButton.titleLabel?.textColor = UIColor.appColor(.green_main)
        self.membersView.backgroundColor = UIColor.appColor(.green_main)
        self.friendsView.backgroundColor = UIColor.appColor(.themeWhite)
        self.friendsButton.titleLabel?.textColor = UIColor.appColor(.white_title)
        
    }
    
    @IBAction func friendsAction(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.friendsAction()
        }
        self.membersButton.titleLabel?.textColor = UIColor.appColor(.white_title)
        self.membersView.backgroundColor = UIColor.appColor(.themeWhite)
        self.friendsView.backgroundColor = UIColor.appColor(.green_main)
        self.friendsButton.setTitleColor(.appColor(.green_main), for: .normal)
    }
}
