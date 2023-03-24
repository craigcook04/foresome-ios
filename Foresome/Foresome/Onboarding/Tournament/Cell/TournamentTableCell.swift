//
//  TournamentTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 24/03/23.
//

import UIKit

class TournamentTableCell: UITableViewCell {

    
    @IBOutlet weak var rightBtn: NSLayoutConstraint!
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func rightAction(_ sender: Any) {
    }
}
