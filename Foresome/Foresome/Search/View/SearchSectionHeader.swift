//
//  SearchSectionHeader.swift
//  Foresome
//
//  Created by Deepanshu on 29/05/23.
//

import UIKit

protocol SearchSectionHeaderDelegate {
    func clearAction()
}

class SearchSectionHeader: UIView {
    var delegate: SearchSectionHeaderDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func clearButtonAction(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.clearAction()
        }
    }
}
