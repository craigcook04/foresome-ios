//
//  TutorialCollectionCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 17/03/23.
//

import UIKit

class TutorialCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var tutorialHeadingLbl: UILabel!
    @IBOutlet weak var tutorialDescriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tutorialHeadingLbl.setLineSpacing(lineSpacing: 1.0, textAlignment: .left)
    }
    
}
