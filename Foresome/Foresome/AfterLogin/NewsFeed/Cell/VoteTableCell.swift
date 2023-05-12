//
//  VoteTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 08/04/23.
//

import UIKit

class VoteTableCell: UITableViewCell {
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var pollView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var progressViewWidth: NSLayoutConstraint!
    
     override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPollData(data:PostListDataModel, pollOptions: String) {
        self.itemLabel.text = pollOptions
    }
}

