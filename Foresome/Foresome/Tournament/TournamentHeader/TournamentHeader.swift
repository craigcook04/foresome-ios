//
//  TournamentHeader.swift
//  Foresome
//
//  Created by Piyush Kumar on 24/03/23.
//

import Foundation
import UIKit

class TournamentHeader: UIView {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setHeaderData() {
        let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
        if let data = strings {
            self.usernameLabel.text = "HELLO,\(data["name"] as? String ?? "")!"
        }
    }
}
