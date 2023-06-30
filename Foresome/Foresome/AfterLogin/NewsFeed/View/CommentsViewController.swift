//
//  CommentsViewController.swift
//  Foresome
//
//  Created by Deepanshu on 16/05/23.
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
import Kingfisher

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var commetsTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var commentsTextView: GrowingTextView!
    
    var listPostData = PostListDataModel()
    var newCommentData = [CommentsData]()
    var commentsData = [CommentsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTextView.delegate = self
        setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setEmptyView()
        self.submitButton.isUserInteractionEnabled = false
        self.submitButton.setTitleColor(UIColor.appColor(.grey_Light), for: .normal)
    }
    
    func setTable() {
        self.commetsTableView.delegate = self
        self.commetsTableView.dataSource = self
        self.commetsTableView.registerCell(class: CommentsTableViewCell.self)
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        if let data = strings {
            if let image = (data["user_profile_pic"] as? String ?? "").base64ToImage() {
                self.userProfileImage.image = image
            } else {
                self.userProfileImage.image = UIImage(named: "ic_user_placeholder")
            }
        }
    }
    
    func setEmptyView() {
        if (self.listPostData.comments?.count ?? 0) > 0 {
            self.commetsTableView.backgroundView = nil
        } else {
            self.commetsTableView.setBackgroundView(message:"No comments found")
        }
    }
    
    func updateCommentsData(currentPostId: String) {
        let db = Firestore.firestore()
        db.collection("posts").document(currentPostId).getDocument { snapShotData, error in
            if error == nil {
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                if let foundPostData = snapShotData?.data() {
                    let dataToModelData = PostListDataModel(json: foundPostData)
                    self.listPostData = dataToModelData
                    self.listPostData.comments = dataToModelData.comments
                }
            } else {
                if let foundError = error {
                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                    Singleton.shared.showMessage(message: foundError.localizedDescription, isError: .error)
                }
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        dismissKeyboard()
        self.submitButton.isUserInteractionEnabled = false
        self.submitButton.setTitleColor(UIColor.appColor(.grey_Light), for: .normal)
        ActivityIndicator.sharedInstance.showActivityIndicator()
        var arrayOfDic = [[String:Any]]()
        let userData = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        //MARK: code for make array to cooments data first----
        let commentsId =  UUID().uuidString
        let addedCooments = CommentsData()
        addedCooments.id = commentsId
        addedCooments.username = userData?["name"] as? String ?? ""
        addedCooments.userId = UserDefaultsCustom.currentUserId
        addedCooments.parentId = ""
        addedCooments.body = commentsTextView.text
        addedCooments.createdAt = "\(Date().miliseconds())"
        addedCooments.userProfile = ""
        commentsTextView.text.removeAll()
        self.listPostData.comments?.append(addedCooments)
        if let comments = self.listPostData.comments {
            comments.forEach { commentDic in
                var jsonData = [String:Any]()
                jsonData["username"] = commentDic.username
                jsonData["id"] = commentDic.id
                jsonData["userId"] = commentDic.userId
                jsonData["userProfile"] = ""
                jsonData["body"] = commentDic.body
                jsonData["createdAt"] = commentDic.createdAt
                jsonData["parentId"] = commentDic.parentId
                arrayOfDic.append(jsonData)
            }
        }
        let db = Firestore.firestore()
        let userPostCollection = db.collection("posts").document(listPostData.id ?? "")
        userPostCollection.updateData(["comments": arrayOfDic]) { error in
            if error == nil {
                Singleton.shared.showMessage(message: "Commented successfully.", isError: .success)
                self.setEmptyView()
                self.commetsTableView.reloadData()
                self.commetsTableView.scrollToRow(at: IndexPath(row:0, section: 0), at: .top, animated: true)
                ActivityIndicator.sharedInstance.hideActivityIndicator()
            } else {
                if let error = error {
                    Singleton.shared.showMessage(message: (error.localizedDescription), isError: .error)
                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                }
            }
        }
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listPostData.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = commetsTableView.dequeueReusableCell(withIdentifier: cellIdentifier.commentsTableViewCell, for: indexPath) as? CommentsTableViewCell else {
            return UITableViewCell()
        }
        self.commentsData = self.listPostData.comments ?? []
        self.commentsData.sort(by: {($0.createdAt?.millisecToDate() ?? Date()).compare($1.createdAt?.millisecToDate() ?? Date()) == .orderedDescending })
        //        cell.setCellData(data: self.listPostData.comments?[indexPath.row] ?? CommentsData())
        cell.setCellData(data: self.commentsData[indexPath.row])
        if ((self.listPostData.comments?.count ?? 0) - 1) == indexPath.row {
            cell.sepratorView.isHidden = true
        } else {
            cell.sepratorView.isHidden = false
        }
        return cell
    }
}


extension CommentsViewController : GrowingTextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
        print("updated post text strings----=\(updatedString ?? "")")
        //creatPostData.postDescription = updatedString
        if updatedString == " "{
            return false
        } else {
            if updatedString?.count ?? 0 > 0 {
                self.submitButton.isUserInteractionEnabled = true
                self.submitButton.setTitleColor(UIColor.appColor(.green_main), for: .normal)
            } else {
                self.submitButton.isUserInteractionEnabled = false
                self.submitButton.setTitleColor(UIColor.appColor(.grey_Light), for: .normal)
            }
        }
        return true
    }
}

