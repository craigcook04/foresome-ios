//
//  TalkAboutTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
//

import UIKit
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase
import FirebaseStorage

protocol TalkAboutTableCellDelegate {
    func pollBtnAction()
    func photoBtnAction()
    func cameraBtnAction()
    func createPost()
    func cancelAction()
}

class TalkAboutTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var talkAboutField: UITextField!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var pollBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var imagesCountLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var postingImageView: UIView!
    
    var delegate: TalkAboutTableCellDelegate?
    var uploadedImageUrls: [String]? = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setProfileData()
        talkAboutField.delegate = self
        self.postingImageView.isHidden = true
    }
    
    func setProfileData() {
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        if let data = strings {
            if let image = (data["user_profile_pic"] as? String ?? "").base64ToImage() {
                profileImage.image = image
                profilePicture.image = image
            }
        }
    }

    func setCellDataAndProgress(data: CreatePostModel, progress: Float, uploadedCount: Int) {
        if (data.postImages?.count ?? 0) > 0 {
            self.postingImageView.isHidden = false
        } else {
            self.postingImageView.isHidden = true
        }
        self.progressView.progress = progress
        self.imagesCountLabel.text = "\(AppStrings.posting) \(uploadedCount) \(AppStrings.of) \(data.postImages?.count ?? 0) \(AppStrings.selected)"
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
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.delegate?.cancelAction()
        self.tableView?.beginUpdates()
        self.postingImageView.isHidden = true
        self.tableView?.endUpdates()
    }
}

extension TalkAboutTableCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.createPost()
        return false
    }
}
