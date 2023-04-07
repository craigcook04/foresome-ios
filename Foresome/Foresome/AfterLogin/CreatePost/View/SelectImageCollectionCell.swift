//
//  SelectImageCollectionCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 07/04/23.
//

import UIKit

protocol SelectImageCollectionCellDelegate{
    func removeImage(index: Int)
}

class SelectImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var removeImageBtn: UIButton!
    
    var delegate: SelectImageCollectionCellDelegate?
    var selectedRow:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func removeBtnAction(_ sender: UIButton) {
        self.delegate?.removeImage(index: self.selectedRow ?? 0)
    }
}
