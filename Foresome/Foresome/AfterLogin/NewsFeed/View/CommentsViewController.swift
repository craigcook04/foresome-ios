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
    var arrayOfDic = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTextView.delegate = self
        setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.submitButton.isUserInteractionEnabled = false
        self.submitButton.setTitleColor(UIColor.appColor(.grey_Light), for: .normal)
    }
    
    func setTable() {
        self.commetsTableView.delegate = self
        self.commetsTableView.dataSource = self
        self.commetsTableView.registerCell(class: CommentsTableViewCell.self)
        self.userProfileImage.image = listPostData.profileImage?.base64ToImage()
        
        listPostData.comments?.forEach({ commentsData in
            print("comments body\(commentsData.body)")
            print("comments json\(commentsData.json)")
            print("comments userporfile\(commentsData.userProfile)")
            print("comments userId\(commentsData.userId)")
            print("comments parentId\(commentsData.parentId)")
            print("comments id\(commentsData.id)")
            print("comments username\(commentsData.username)")
        })
    }
    
    func fetchAPostData() {
//        let db = Firestore.firestore()
//        db.collection("posts").getDocuments { (querySnapshot, err) in
//             if err == nil {
//                querySnapshot?.documents.enumerated().forEach({ (index, posts) in
//                    let postsData =  posts.data()
//                    print("post id is ---\(posts.documentID)")
//                    print("total post is --===\(postsData.count)")
//                    let allPostData = PostListDataModel(json: postsData)
//                    self.listPostData.append(allPostData)
//                    print("self.listpostdata---\(self.listPostData.count)")
//                })
//                self.listPostData.sort(by: {($0.createdAt?.millisecToDate() ?? Date()).compare($1.createdAt?.millisecToDate() ?? Date()) == .orderedDescending })
//                for i in 0..<self.listPostData.count  {
//                    print("printed docs id----\(self.listPostData[i].id)")
//                    print("printed docs uid----\(self.listPostData[i].uid)")
//                }
//                self.newsFeedTableView.reloadData()
//                ActivityIndicator.sharedInstance.hideActivityIndicator()
//            } else {
//                if let error = err?.localizedDescription {
//                    Singleton.shared.showMessage(message: error, isError: .error)
//                }
//            }
//        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        print("submit button called")
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        //MARK: code for make array to cooments data first----
        let addedCooments = CommentsData()
        addedCooments.id = listPostData.id
        addedCooments.username = listPostData.author
        addedCooments.userId = listPostData.uid
        addedCooments.parentId = ""
        addedCooments.body = commentsTextView.text
        addedCooments.createdAt = "\(Date().miliseconds())"
        addedCooments.userProfile = ""
        if let comments = self.listPostData.comments {
            var comment_data = [CommentsData]()
            comments.forEach { commentDic in
                comment_data.append(commentDic)
            }
            newCommentData = comment_data
        }
        
        //MARK: code for make array of dictionary from comments data---
        let commentsId =  UUID().uuidString
        newCommentData.forEach({ newData in
            var jsonData = [String:Any]()
            jsonData["username"] = newData.username
            jsonData["id"] = newData.id
            jsonData["userId"] = newData.userId
            jsonData["userProfile"] = ""
            jsonData["body"] = newData.body
            jsonData["createdAt"] = newData.createdAt
            jsonData["parentId"] = newData.parentId
            self.arrayOfDic.append(jsonData)
        })
        //MARK: code for append new dictionary to old array of dictionary---
        
        //MARK: code make change for solve comments user name issue---
        var jsonForNewCooments = [String:Any]()
        jsonForNewCooments["username"] = strings?["name"] as? String ?? ""
        jsonForNewCooments["id"] = commentsId
        jsonForNewCooments["userId"] = UserDefaultsCustom.currentUserId
        jsonForNewCooments["userProfile"] = ""
        jsonForNewCooments["body"] = commentsTextView.text
        jsonForNewCooments["createdAt"] = "\(Date().miliseconds())"
        jsonForNewCooments["parentId"] = ""
        self.arrayOfDic.append(jsonForNewCooments)
        let db = Firestore.firestore()
         let userPostCollection = db.collection("posts").document(listPostData.id ?? "")
        userPostCollection.updateData(["comments": self.arrayOfDic]) { error in
            if error == nil {
                Singleton.shared.showMessage(message: "Commented successfully.", isError: .success)
                self.listPostData.comments?.append(addedCooments)
                self.commetsTableView.reloadData()
                self.commetsTableView.scrollToRow(at: IndexPath(row:(self.listPostData.comments?.count ?? 0) - 1, section: 0), at: .none, animated: false)
                self.commentsTextView.text.removeAll()
            } else {
             if let error = error {
                 Singleton.shared.showMessage(message: (error.localizedDescription), isError: .error)
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
        cell.setCellData(data: self.listPostData.comments?[indexPath.row] ?? CommentsData())
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

