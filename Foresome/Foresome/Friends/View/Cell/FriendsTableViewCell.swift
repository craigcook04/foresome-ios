//
//  FriendsTableViewCell.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addFriendsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setCellData(isMemberData: Bool) {
        if isMemberData == true {
            addFriendsButton.setTitle("Add Friend", for: .normal)
            addFriendsButton.layer.borderWidth = 0
            addFriendsButton.backgroundColor = UIColor(hexString: "#EBFAF4")
            addFriendsButton.titleLabel?.textColor = UIColor(hexString: "#40CD93")
        } else {
            addFriendsButton.backgroundColor = .white
            addFriendsButton.setTitle("Unfriend", for: .normal)
            addFriendsButton.layer.borderWidth = 1
            addFriendsButton.layer.borderColor = UIColor(hexString: "#E9E9E9").cgColor
            addFriendsButton.titleLabel?.textColor = UIColor(hexString: "#979CA0")
        }
    }
    
    @IBAction func addFriendsAction(_ sender: UIButton) {
        print("add friends called")
        
        
    }
    
    
}
