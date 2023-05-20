//
//  LeaderBoardTableViewCell.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit

class LeaderBoardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var topRankView: UIView!
    
    
    
    @IBOutlet weak var lowRankview: UIView!
    
    
    @IBOutlet weak var topRankInnerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    
    
}
