//
//  FriendsTableHeader.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit


protocol FriendsTableHeaderDelegate {
    func searchData()
    
}


class FriendsTableHeader: UIView, UITextFieldDelegate {

    
    
    @IBOutlet weak var userNamelabel: UILabel!
    
    
    @IBOutlet weak var headerTitle: UILabel!
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
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
}
