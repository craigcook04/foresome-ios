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
    var comments:[String]? = []
    var createdAt:String? = ""
    var updatedAt:String? = ""
    var image:[URL]? = []
    var uid:String? = ""
    var id:String? = ""
    var post_type : String? = ""
    var profileImage : String = ""
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
          
        if let comments = json["comments"] as? [String] {
            self.comments = comments
        }
        
        if let createdAt = json["createdAt"] as? String {
            self.createdAt = createdAt
        }
        
        if let updatedAt = json["updatedAt"] as? String {
            self.updatedAt = updatedAt
        }
        
        if let image = json["image"] as? [URL] {
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
        
        if let profileImage = json["profile_image"] as? String {
            self.profileImage = profileImage
        }
    }
}






