//
//  CreatePostModel.swift
//  Foresome
//
//  Created by Deepanshu on 20/04/23.
//

import Foundation
import UIKit

class CreatePostModel: NSObject {
    var postDescription: String?
    var postImages: [UIImage?]?
    var createdDate: String?
    var postId: String?
    var imageUrl:[String]?
    
    init(postDescription: String? = "", postImages: [UIImage]? = nil, createdDate: String = "", postId:String = "", imageUrl:[String] = []) {
        self.postDescription = postDescription
        self.postImages = postImages
        self.createdDate = createdDate
        self.postId = postId
        self.imageUrl = imageUrl
    }
}


