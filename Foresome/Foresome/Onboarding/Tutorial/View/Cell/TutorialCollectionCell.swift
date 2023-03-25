//
//  TutorialCollectionCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 17/03/23.
//

import UIKit
//protocol tutorialCollectionCellDelegate{
//
//}

class TutorialCollectionCell: UICollectionViewCell {

    @IBOutlet weak var tutorialHeadingLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tutorialHeadingLbl.setLineSpacing(lineSpacing: 1.0, textAlignment: .left)
    }

}
