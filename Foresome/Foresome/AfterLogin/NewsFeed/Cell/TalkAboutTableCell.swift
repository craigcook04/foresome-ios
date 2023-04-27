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
        talkAboutField.delegate = self
        self.postingImageView.isHidden = true
    }

    func setCellProgressData(data: CreatePostModel) {
        if (data.postImages?.count ?? 0) > 0 {
            self.postingImageView.isHidden = false
        } else {
            self.postingImageView.isHidden = true
        }
        self.imagesCountLabel.text = "Posting \("3") of \(data.postImages?.count ?? 0) selected..."
        uploadPostData(data: data)
    }
    
    func setCellDataAndProgress(data: CreatePostModel, progress: Float, uploadedCount: Int) {
        if (data.postImages?.count ?? 0) > 0 {
            self.postingImageView.isHidden = false
        } else {
            self.postingImageView.isHidden = true
        }
        self.progressView.progress = progress
        self.imagesCountLabel.text = "Posting \(uploadedCount) of \(data.postImages?.count ?? 0) selected..."   
    }
    
    func uploadPostData(data:CreatePostModel) {
        //MARK: code for create poll using firebase ---
        ActivityIndicator.sharedInstance.showActivityIndicator()
        let db = Firestore.firestore()
        let documentsId =  UUID().uuidString
        var postImages = [String]()
        //MARK: code for upload multiple image upload-----
        for i in 0..<(data.postImages?.count ?? 0) {
            uploadimage(image: data.postImages?[i] ?? UIImage())
        }
        
        for i in 0..<(data.postImages?.count ?? 0) {
            postImages.append(data.postImages?[i]?.convertImageToBase64String() ?? "")
        }
        
        print("all postImages after convert to base64 is count ---\(postImages.count)")
        let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
        let createdDate = Date().miliseconds()
        print("created date---=\(createdDate)")
        //print("user profile picture----\(strings?["user_profile_pic"] ?? "")")
        print("user name of created poll----= \(strings?["name"] ?? "")")
        print("user uid is ----\(strings?["uid"] ?? "")")
        print("documents id is---==\(documentsId)")
        
//        db.collection("posts").document(documentsId).setData(["author":"\(strings?["name"] ?? "")", "createdAt":"\(Date().miliseconds())", "description":"", "id": "\(documentsId)", "image":[postImages], "photoURL":"", "profile":"\(strings?["user_profile_pic"] ?? "")", "uid":"\(strings?["uid"] ?? "")", "updatedAt":"", "comments":[""], "post_type":"feed"], merge: true)
        ActivityIndicator.sharedInstance.hideActivityIndicator()
         
    }
    
    func uploadimage(image: UIImage) {
        let storageRef = Storage.storage().reference()
        var data = Data()
        data = image.pngData() ?? Data()
        let date = Date()
        print("image name is -==\(date.miliseconds().toInt).png")
        let riversRef = storageRef.child("images/IMG_\(date.miliseconds().toInt).png")
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            let size = metadata.size
            riversRef.downloadURL { (url,error) in
                guard let downloadUrl = url else {
                    return
                }
                self.uploadedImageUrls?.append(downloadUrl.absoluteString)
            }
        }
        
        uploadTask.observe(.progress) { data in
            self.progressView.progress = Float(data.progress?.fractionCompleted.roundTo(places: 2) ?? 0.0)
            if Float(data.progress?.fractionCompleted.roundTo(places: 2) ?? 0.0) == 1.0 {
                self.tableView?.beginUpdates()
                self.postingImageView.isHidden = true
                self.tableView?.endUpdates()
            } else {
                self.postingImageView.isHidden = false
            }
        }
        
        uploadTask.observe(.success) { data in
            print("success called.")
        }
        
        uploadTask.observe(.failure) { data in
            print("failure called.")
        }
    }
    
    func uploadImageasRef() {
        
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
        print("cancel action called")
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
