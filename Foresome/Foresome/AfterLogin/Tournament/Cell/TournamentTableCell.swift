//
//  TournamentTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 24/03/23.
//

import UIKit
protocol TournamentTableCellDelegate{
    func rightButtonAction()
}

class TournamentTableCell: UITableViewCell {
    
    @IBOutlet weak var rightBtn: NSLayoutConstraint!
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: TournamentTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func rightAction(_ sender: Any) {
        self.delegate?.rightButtonAction()
    }
    
}
