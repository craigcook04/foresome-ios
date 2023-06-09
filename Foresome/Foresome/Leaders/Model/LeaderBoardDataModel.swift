//
//  LeaderBoardDataModel.swift
//  Foresome
//
//  Created by Deepanshu on 09/06/23.
//

import Foundation


class LeaderBoardDataModel : NSObject {
    var json: JSON!
    var tournamentId: String?
    var r1: Int?
    var r2: Int?
    var rank: Int?
    var userId: String?
}

extension  LeaderBoardDataModel {
    convenience init(json: [String: Any]) {
        self.init()
        self.json = json
        if let tournamentId = json["tournamentId"] as? String {
            self.tournamentId = tournamentId
        }
        if let r1 = json["r1"] as? Int {
            self.r1 = r1
        }
        
        if let r2 = json["r2"] as? Int {
            self.r2 = r2
        }
        
        if let rank = json["rank"] as? Int {
            self.rank = rank
        }
        
        if let userId = json["userId"] as? String {
            self.userId = userId
        }
    }
}



