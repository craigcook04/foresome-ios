//
//  FilterSectionHeader.swift
//  Foresome
//
//  Created by Deepanshu on 20/05/23.
//

import UIKit

protocol FilterSectionHeaderDelegate {
    func closeBtnAction()
}

class FilterSectionHeader: UIView {

    
    @IBOutlet weak var headerTitle: UILabel!
    
    
    @IBOutlet weak var closeButton: UIButton!
    
    var delegate: FilterSectionHeaderDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        
        if let delegate = self.delegate {
            delegate.closeBtnAction()
        }
       
    }
}
