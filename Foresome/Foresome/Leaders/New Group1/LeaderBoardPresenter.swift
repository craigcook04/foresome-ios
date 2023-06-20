//
//  LeaderBoardPresenter.swift
//  Foresome
//
//  Created by Deepanshu on 08/06/23.
//

import Foundation
import FirebaseFirestore

 class LeaderBoardPresenter :  LeaderBoardPresenterProtocol {
     
    func fetchPresenterViewLeaderBoard(leaderBoardData: [LeaderBoardDataModel]) { }
    var view : LeaderBoardViewProtocol?
    var leaderBoardData = [LeaderBoardDataModel]()
    
    static func createLeaderBoardModule() -> LeadersViewController {
        let view = LeadersViewController()
        var presenter: LeaderBoardPresenterProtocol = LeaderBoardPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    //MARK: code for fetch leaders board  data from presenter-----
    func fetchPresenterViewLeaderBoard(isFromRefresh: Bool) {
        fetchDataFromFirebase()
    }
    
    func fetchDataFromFirebase() {
        let firestoreDb = Firestore.firestore()
        ActivityIndicator.sharedInstance.showActivityIndicator()
        firestoreDb.collection("leaderboard").getDocuments { (querySnapshot, err) in
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            let model = LeaderBoardDataModel()
            self.leaderBoardData = model.getData(snapshot: querySnapshot)
            self.updateTheUserDetails(index: 0)
            
            
            
//            firestoreDb.collection("users").document(rankerUserId).getDocument { (snapData, error) in
//                if error == nil {
//                    if let data = snapData?.data() {
//                        self.userListData = UserListModel(json: data)
//                        self.leaderBoardData[index].usersDetails = self.userListData
//                    }
//                } else {
//                    if let error = error {
//                        Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
//                    }
//                }
//            }
            
//            documents.enumerated().forEach({ (index, document) in
//                print("docs id is ----\(document.documentID)")
//                guard let documentData = document.data() else {return}
//                let leaderBoardData = document.data()
//              //  if let leaderBoardData = leaderBoardData {
//                let leaderBoardModel = LeaderBoardDataModel(json: leaderBoardData ?? [:])
//                    let rankerUserId = self.leaderBoardModel[index].userId
//                    self.leaderBoardData.append(leaderBoardModel)
//              //  }
//                print("user leader board rank value is ---\(self.leaderBoardData[index].rank ?? 0)")
//                print("user leader board r1 rank value is ---------\(self.leaderBoardData[index].r1 ?? 0)")
//                print("user leader board r2 rank value is ---------\(self.leaderBoardData[index].r2 ?? 0)")
//                print("user id in in case of leader rank data -----\(self.leaderBoardData[index].userId ?? "")")
//            })
        }
    }
     
     func updateTheUserDetails(index:Int) {
         if index < self.leaderBoardData.count {
             if let userId = self.leaderBoardData[index].userId {
                 Firestore.firestore().collection("users").document(userId).getDocument { (snapData, error) in
                     if error == nil {
                         if let data = snapData?.data() {
                             self.leaderBoardData[index].usersDetails = UserListModel(json: data)
                             self.updateTheUserDetails(index: index + 1)
                         }
                     } else {
                         if let error = error {
                             Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                         }
                     }
                 }
             }
         } else {
             self.view?.fetchPresenterLeaderBoard(leaderBoardData: self.leaderBoardData)
         }
     }
}
