//
//  CommentsTableViewCell.swift
//  Foresome
//
//  Created by Deepanshu on 16/05/23.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentedDate: UILabel!
    @IBOutlet weak var commentLabel: ExpendableLinkLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellData(data:CommentsData) {
       // self.profileImage.image = data.userProfile?.base64ToImage()
        self.userName.text = data.username
        guard let postDate = data.createdAt?.millisecToDate() else {
            return
        }
        let calendar = Calendar.current
        let diff = calendar.dateComponents([.minute, .hour, .day, .year], from: postDate, to: Date())
        if diff.year == 0 {
            if postDate.isToday {
                if diff.hour ?? 0 < 1 {
                    if diff.minute ?? 0 < 1 {
                        self.commentedDate.text =  "just now"
                    } else {
                        self.commentedDate.text = "\(diff.minute ?? 0) mins"
                    }
                } else {
                    self.commentedDate.text = "\(diff.hour ?? 0) hrs"
                }
            } else if postDate.isYesterday {
                self.commentedDate.text =   "Yesterday"
            } else {
                self.commentedDate.text = postDate.toStringFormat()
            }
        } else {
            self.commentedDate.text  = postDate.toStringFormat()
        }
        self.commentLabel.message = data.body ?? ""
    }
}
