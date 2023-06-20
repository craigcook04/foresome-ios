//
//  LeaderBoardDataModel.swift
//  Foresome
//
//  Created by Deepanshu on 09/06/23.
//

import Foundation
import Firebase
import FirebaseFirestore

class LeaderBoardDataModel : NSObject {
    var json: JSON!
    var tournamentId: String?
    var r1: Int?
    var r2: Int?
    var rank: Int?
    var userId: String?
    var usersDetails: UserListModel?
    var total:Int?
}

extension  LeaderBoardDataModel {
    
    convenience init(tournamentId: String, r1: Int, r2: Int, rank: Int, userId: String) {
        self.init()
        self.tournamentId = tournamentId
        self.r1 = r1
        self.r2 = r2
        self.rank = rank
        self.userId = userId
        self.total = r1 + r2
    }
    
    func getData(snapshot: QuerySnapshot?) -> [LeaderBoardDataModel] {
        ActivityIndicator.sharedInstance.showActivityIndicator()
        guard let documents = snapshot?.documents else {return []}
        let leaderboardData = documents.map { queryDocumentSnapshot -> LeaderBoardDataModel in
            let data = queryDocumentSnapshot.data()
            let r1 = data["r1"] as? Int ?? 0
            let r2 = data["r2"] as? Int ?? 0
            let tournamentId = data["tournamentId"] as? String ?? ""
            let rank = data["rank"] as? Int ?? 0
            let userId = data["userId"] as? String ?? ""
            
            return LeaderBoardDataModel(tournamentId: tournamentId, r1: r1, r2: r2, rank: rank, userId: userId)
        }
        ActivityIndicator.sharedInstance.hideActivityIndicator()
        return leaderboardData
    }
    
    func setUserDetails(userId:String) {
       
    }
}



