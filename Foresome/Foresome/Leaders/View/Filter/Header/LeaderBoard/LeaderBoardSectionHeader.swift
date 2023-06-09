//
//  LeaderBoardSectionHeader.swift
//  Foresome
//
//  Created by Deepanshu on 29/05/23.
//

import UIKit

protocol LeaderBoardSectionHeaderDelegate {
    func selectFilter()
}

class LeaderBoardSectionHeader: UIView {

    var delegate:LeaderBoardSectionHeaderDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func selectCategoryButton(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.selectFilter()
        }
    }
}
