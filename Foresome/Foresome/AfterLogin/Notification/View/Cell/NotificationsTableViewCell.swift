//
//  NotificationsTableViewCell.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var notifictinTitle: UILabel!
    
    
    
    @IBOutlet weak var notificationDate: UILabel!
    
    
    @IBOutlet weak var notificationButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
    
    @IBAction func notificationAction(_ sender: UIButton) {
        
        print("notification action called.")
    }
    
    
    
    
    
}
