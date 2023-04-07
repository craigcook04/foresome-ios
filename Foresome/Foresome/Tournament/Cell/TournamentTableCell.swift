//
//  TournamentTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 24/03/23.
//

import UIKit
protocol TournamentTableCellDelegate{
    func rightButtonAction()
}

class TournamentTableCell: UITableViewCell {
    
    @IBOutlet weak var rightBtn: NSLayoutConstraint!
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var imageData:[UIImage] = [UIImage(named: "fs-hidden-lake")!,UIImage(named: "fs-pipers")!,UIImage(named: "fs-woodbine")!]
    var delegate: TournamentTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setTournamentsCellData(data:TournamentModel, index: Int) {
        self.imageItem.image  = self.imageData[index % 3]
        self.titleLabel.text = data.title
        self.dateLabel.text =  data.date
    }
    
    @IBAction func rightAction(_ sender: Any) {
        self.delegate?.rightButtonAction()
    }
}
