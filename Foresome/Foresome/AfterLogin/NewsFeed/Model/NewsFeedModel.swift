//
//  NewsFeedModel.swift
//  Foresome
//
//  Created by Piyush Kumar on 04/04/23.
//

import Foundation

class PostListDataModel: NSObject {
    var json: JSON!
    
}

extension PostListDataModel {
    convenience init(json: [String: Any]) {
        self.init()
        self.json = json
//        if let descriptions = json["descriptions"] as? String {
//            self.descriptions = descriptions
//        }
    }
}






