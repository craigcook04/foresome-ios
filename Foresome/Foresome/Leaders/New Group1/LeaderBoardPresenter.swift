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
        fetchDataFromFirebase(isFromRefresh: isFromRefresh)
    }
    
    func fetchDataFromFirebase(isFromRefresh:Bool) {
        let firestoreDb = Firestore.firestore()
        if isFromRefresh == true {
            ActivityIndicator.sharedInstance.hideActivityIndicator()
        } else {
            ActivityIndicator.sharedInstance.showActivityIndicator()
        }
        firestoreDb.collection("leaderboard").getDocuments { (querySnapshot, err) in
            let model = LeaderBoardDataModel()
            self.leaderBoardData = model.getData(snapshot: querySnapshot)
            self.updateTheUserDetails(index: 0)
        }
    }
    
    func updateTheUserDetails(index:Int) {
        if index < self.leaderBoardData.count {
            if let userId = self.leaderBoardData[index].userId {
                Firestore.firestore().collection("users").document(userId).getDocument { (snapData, error) in
                    if error == nil {
                        if let data = snapData?.data() {
                            self.leaderBoardData[index].usersDetails = UserListModel(json: data)
                        } else {
                            //ActivityIndicator.sharedInstance.hideActivityIndicator()
                        }
                        self.updateTheUserDetails(index: index + 1)
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
