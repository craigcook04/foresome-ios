//
//  NewsFeedModel.swift
//  Foresome
//
//  Created by Piyush Kumar on 04/04/23.
//

import Foundation

class PostListDataModel: NSObject {
    var json: JSON!
    var author:String? = ""
    var postDescription:String? = ""
    var comments:[CommentsData]? = []
    var createdAt:String? = ""
    var updatedAt:String? = ""
    var image:[String]? = []
    var uid:String? = ""
    var id:String? = ""
    var post_type : String? = ""
    var profileImage : String = ""
    var poll_title: String = ""
    var poll_options: [String]? = []
    var selectedAnswerCount : [Int] = []
    var selectedAnswer: [Int] = []
    var likedUserList : [String] = []
    var voted_user_list : [String] = []
    var selectedAnserIndex: Int?
    var reportedUserList: [String]?
}

extension PostListDataModel {
    convenience init(json: [String: Any]) {
        self.init()
        self.json = json
        
        if let author = json["author"] as? String {
            self.author = author
        }
        
        if let postDescription = json["description"] as? String {
            self.postDescription = postDescription
        }
//
//        if let comments = json["comments"] as? [CommentsData] {
//            self.comments = comments
//        }
//
        if let comments = json["comments"] as? [[String:Any]] {
            var comment_data = [CommentsData]()
            comments.forEach{ commentDic in
                comment_data.append(CommentsData(json:commentDic))
            }
            self.comments = comment_data
        }
        
        if let createdAt = json["createdAt"] as? String {
            self.createdAt = createdAt
        } else if let createdAt = json["createdAt"] as? Double {
            self.createdAt = "\(createdAt)"
        }
        
        if let updatedAt = json["updatedAt"] as? String {
            self.updatedAt = updatedAt
        }
        
        if let image = json["image"] as? [String] {
            self.image = image
        }
        
        if let userUid = json["uid"] as? String {
            self.uid = userUid
        }
        
        if let postId = json["id"] as? String {
            self.id = postId
        }
        
        if let post_type = json["post_type"] as? String {
            self.post_type = post_type
        }
        
        if let profileImage = json["profile"] as? String {
            self.profileImage = profileImage
        }
        
        if let pollTitle = json["poll_title"] as? String {
            self.poll_title = pollTitle
        }
        
        if let pollOptions = json["poll_options"] as? [String] {
            self.poll_options = pollOptions
        }
        
        if let selectedAnswerCount = json["selectedAnswerCount"] as? [Int] {
            self.selectedAnswerCount = selectedAnswerCount
        }
        
        if let selectedAnswer = json["selectedAnswer"] as? [Int] {
            self.selectedAnswer = selectedAnswer
        }
        
        if let likedUserList = json["likedUserList"] as? [String] {
            self.likedUserList = likedUserList
        }
        
        if let voted_user_list = json["voted_user_list"] as? [String] {
            self.voted_user_list = voted_user_list
        }
        
        if let selectedAnserIndex = json["selectedAnserIndex"] as? Int {
            self.selectedAnserIndex = selectedAnserIndex
        }
        
        if let reportedUserList = json["reportedUserList"] as? [String] {
            self.reportedUserList = reportedUserList
        }
    }
}

class CommentsData: NSObject {
    var json: JSON!
    var body: String? = ""
    var createdAt: String? = ""
    var id: String? = ""
    var parentId: String = ""
    var userId:String? = ""
    var username: String? = ""
    var userProfile: String? = ""
}

extension CommentsData {
    convenience init(json: [String: Any]) {
        self.init()
        self.json = json
        
        if let body = json["body"] as? String {
            self.body = body
        }
        
        if let createdAt = json["createdAt"] as? String {
            self.createdAt =  createdAt
        } else if let createdAt = json["createdAt"] as? Double {
            self.createdAt =  "\(createdAt)"
        }
        
        if let id = json["id"] as? String {
            self.id = id
        }
        
        if let parentId = json["parentId"] as? String {
            self.parentId = parentId
        }
        
        if let userId = json["userId"] as? String {
            self.userId = userId
        }
        
        if let username = json["username"] as? String {
            self.username = username
        }
        
        if let userProfile = json["userProfile"] as? String {
            self.userProfile = userProfile
        }
    }
}






