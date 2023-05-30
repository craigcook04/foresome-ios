//
//  FilterTableViewCell.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    
    @IBOutlet weak var filterView: UIView!
    
    
    @IBOutlet weak var searchField: UITextField!
    
    
    
    @IBOutlet weak var filterIcon: UIButton!
    
    
    
    @IBOutlet weak var sortByLabel: UILabel!
    
    
    
    
    @IBOutlet weak var sortView: UIView!
    
    
    @IBOutlet weak var sortSelectedButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setCellData(isSelected: Bool) {
        if isSelected == true {
            self.sortSelectedButton.isSelected = true
        } else {
            self.sortSelectedButton.isSelected = false
        }
    }
    
}
