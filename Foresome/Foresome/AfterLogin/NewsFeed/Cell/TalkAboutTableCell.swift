//
//  TalkAboutTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
//

import UIKit
protocol TalkAboutTableCellDelegate {
    func pollBtnAction()
    func photoBtnAction()
    func cameraBtnAction()
    func createPost()
}

class TalkAboutTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var talkAboutField: UITextField!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var pollBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    
    var delegate: TalkAboutTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        talkAboutField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func pollAction(_ sender: UIButton) {
        self.delegate?.pollBtnAction()
    }
    
    @IBAction func photoAction(_ sender: UIButton) {
        self.delegate?.photoBtnAction()
    }
    
    @IBAction func cameraAction(_ sender: UIButton) {
        self.delegate?.cameraBtnAction()
    }
    
}
extension TalkAboutTableCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.createPost()
        return false
    }
}
