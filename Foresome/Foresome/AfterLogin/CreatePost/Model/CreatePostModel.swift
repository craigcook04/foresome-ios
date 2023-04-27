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
    
    init(postDescription: String? = "", postImages: [UIImage]? = nil) {
        self.postDescription = postDescription
        self.postImages = postImages
    }
}

