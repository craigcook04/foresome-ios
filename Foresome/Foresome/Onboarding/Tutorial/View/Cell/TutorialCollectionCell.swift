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
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pageControl.currentPage = 0
        
    }

}
