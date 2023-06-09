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
    @IBOutlet weak var topRankInnerView: GradientViewWithAngle!
    @IBOutlet weak var rankDetailsHeadings: UIView!
    @IBOutlet weak var rankValue: UILabel!
    @IBOutlet weak var rankerName: UILabel!
    @IBOutlet weak var rankDetailsLabel: UILabel!
    @IBOutlet weak var rankCountLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    
    @IBOutlet weak var userProfileSecondSection: UIImageView!
   
    @IBOutlet weak var secondSectionRankerName: UILabel!
    
    @IBOutlet weak var secondSectionRankValue: UILabel!
    
    @IBOutlet weak var secondSectionROneValue: UILabel!
    
    @IBOutlet weak var secondSectionRTwoValue: UILabel!
    
    @IBOutlet weak var secondSectionRThreeValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
