//
//  LeadersViewController.swift
//  Foresome
//
//  Created by Deepanshu on 29/03/23.
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

class LeadersViewController: UIViewController {
    func fetchPresenterLeaderBoard() {
        print("fetch presenter leader board called.")
    }
    
    @IBOutlet weak var leaderBoardTable: StrachyHeaderTable!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    weak var headerView: TestTableHeader?
    var presenter: LeaderBoardPresenterProtocol?
    let firestoreDb = Firestore.firestore()
    var userListData = UserListModel()
    var leaderBoardData = [LeaderBoardDataModel]()
    var allUsersList = [UserListModel]()
    var firstThreeUsers = [UserListModel]()
    var categoryValue : String?
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leaderBoardTable.refreshControl = refreshControl
        setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loader.isHidden = true
        self.leaderBoardTable.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshLeaderBoardData(_:)), for: .valueChanged)
        // self.fetchLeaderBoardData(isFromRefresh: false)
        //MARK: code for fetch leaders board data from presenter---
        self.presenter?.fetchPresenterViewLeaderBoard(isFromRefresh: false)
    }
    
    @objc private func refreshLeaderBoardData(_ sender: Any) {
        self.refreshControl.beginRefreshing()
        self.loader.isHidden = false
        self.loader.startAnimating()
        //self.presenter?.fetchPostData(isFromRefresh: true)
        // self.fetchLeaderBoardData(isFromRefresh: true)
        self.presenter?.fetchPresenterViewLeaderBoard(isFromRefresh: false)
    }
    
    func setTable() {
        self.leaderBoardTable.delegate = self
        self.leaderBoardTable.dataSource = self
        self.leaderBoardTable.register(cellClass: LeaderBoardTableViewCell.self)
        setTableHeader()
    }
    //
    //    func fetchLeaderBoardData(isFromRefresh: Bool) {
    //        self.leaderBoardData.removeAll()
    //        self.leaderBoardData = []
    //        self.refreshControl.tintColor = .clear
    //        if isFromRefresh ==  true {
    //            ActivityIndicator.sharedInstance.hideActivityIndicator()
    //            self.refreshControl.beginRefreshing()
    //            self.loader.isHidden = false
    //            self.loader.startAnimating()
    //        } else {
    //            ActivityIndicator.sharedInstance.showActivityIndicator()
    //        }
    //        firestoreDb.collection("leaderboard").getDocuments { (querySnapshot, err) in
    //            ActivityIndicator.sharedInstance.hideActivityIndicator()
    //            querySnapshot?.documents.enumerated().forEach({ (index, document) in
    //                print("docs id is ----\(document.documentID)")
    //                let membersData =  document.data()
    //                print("membersData is ---\(membersData.description)")
    //                let leaderBoardData = document.data()
    //                let leaderBoardModel = LeaderBoardDataModel(json: leaderBoardData)
    //                self.leaderBoardData.append(leaderBoardModel)
    //                self.leaderBoardTable.reloadData()
    //                print("user leader board rank value is ---\(self.leaderBoardData[index].rank ?? 0)")
    //                print("user leader board r1 rank value is ---------\(self.leaderBoardData[index].r1 ?? 0)")
    //                print("user leader board r2 rank value is ---------\(self.leaderBoardData[index].r2 ?? 0)")
    //                self.refreshControl.endRefreshing()
    //                self.loader.isHidden = true
    //                self.loader.stopAnimating()
    //                self.fetchParticularUserData(userId: self.leaderBoardData[index].userId ?? "")
    //                print("user id in in case of leader rank data -----\(self.leaderBoardData[index].userId ?? "")")
    //            })
    //            self.leaderBoardTable.reloadData()
    //        }
    //    }
    
    func fetchParticularUserData(userId: String) {
        firestoreDb.collection("users").document(userId).getDocument { (snapData, error) in
            if error == nil {
                if let data = snapData?.data() {
                    self.userListData = UserListModel(json: data)
                    self.allUsersList.append(self.userListData)
                    print("user name---\(self.userListData.name ?? "")")
                    print("user uid---\(self.userListData.uid ?? "")")
                    print("user user_skill---\(self.userListData.user_skill_level ?? "")")
                    print("user createdDate---\(self.userListData.createdDate ?? "")")
                    print("user user_location---\(self.userListData.user_location ?? "")")
                    print("user email---\(self.userListData.email ?? "")")
                    self.firstTopRank(data: self.userListData)
                }
            } else {
                if let error = error {
                    Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                }
            }
        }
    }
    
    func firstTopRank(data: UserListModel) {
        print("passed user data is---start")
        print("user data--\(data.name ?? "")")
        print("user data--\(data.email ?? "")")
        print("user data--\(data.uid ?? "")")
        print("passed user data is---end")
    }
    
    func setTableHeader() {
        guard headerView == nil else { return }
        let height: CGFloat = 152
        let view = UIView.initView(view: TestTableHeader.self)
        view.delegate = self
        view.setLeaderBoardHeaderData()
        self.leaderBoardTable.setStrachyHeader(header: view, height: height)
    }
}

extension LeadersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.leaderBoardData.filter({$0.rank ?? 0 < 4 }).count
        } else {
            return self.leaderBoardData.filter({ $0.rank ?? 0 > 3}).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(cell: LeaderBoardTableViewCell.self, for: indexPath)
        if self.leaderBoardData.count > 0 {
            cell.setCellLeaderBoardData(data: self.leaderBoardData, tableSection: indexPath.section, tableRow: indexPath.row, sortByCondition: self.categoryValue ?? "All")
        } else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView.initView(view: LeaderBoardSectionHeader.self)
            view.delegate = self
            view.slelectedCategoryvalue.text = self.categoryValue ?? "All"
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        } else {
            return 0.001
        }
    }
}

extension LeadersViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.leaderBoardTable.setStrachyHeader()
    }
}

extension LeadersViewController: TestTableHeaderDelegate {
    func notificationBtnAction() {
        let notificationVc = NotificationPresenter.createNotificationModule()
        notificationVc.hidesBottomBarWhenPushed = true
        self.pushViewController(notificationVc, false)
    }
}

extension LeadersViewController: LeaderBoardSectionHeaderDelegate {
    func selectFilter() {
        let filterVc = FilterViewController()
        filterVc.delegate = self
        self.present(filterVc, true)
    }
}

extension LeadersViewController: FilterViewControllerDelegate {
    func selectedFilterAndSortOption(friendName: String, tournamentId: String, sortingOption: String) {
        print("friends name is -----\(friendName)")
        print("tournaments id is -----\(tournamentId)")
        print("sorting option is ------\(sortingOption)")
        
        var query = ""
        
        //MARK: sorting will be work as well as with sort conditions ----
        //MARK: filter data cases -----
        if friendName.count > 0 {
            query = query + "username=\(friendName)"
            //MARK: filter by only friends name not tournaments id ----
            print("only friends name no tournaments.")
            
        }
        
        if tournamentId.count > 0 {
            //MARK: filter by friends name and tournaments both -----
            query = "\(query)&tournamentId=\(tournamentId)"
            print("both friends name and tournaments.")
            firestoreDb.collection("leaderboard").getDocuments { (querySnapshot, err) in
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                self.leaderBoardData = LeaderBoardDataModel().getData(snapshot: querySnapshot)
                print("leader board query data is----")
                print("\(self.leaderBoardData.count)")
                print("\(self.leaderBoardData.first?.r1)")
                print("\(self.leaderBoardData.first?.r2)")
                print("\(self.leaderBoardData.first?.rank)")
                print("\(self.leaderBoardData.first?.userId)")
                print("\(self.leaderBoardData.first?.tournamentId)")
                print("\(self.leaderBoardData.first?.usersDetails?.name)")
                print("\(self.leaderBoardData.first?.usersDetails?.email)")
                print("user leader board query data end.")
                self.leaderBoardData = self.leaderBoardData.filter({$0.tournamentId == tournamentId})
                self.leaderBoardTable.reloadData()
            }
        }
        
        if friendName.count == 0 && tournamentId.count == 0 {
            firestoreDb.collection("leaderboard").getDocuments { (querySnapshot, err) in
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                self.leaderBoardData = LeaderBoardDataModel().getData(snapshot: querySnapshot)
            }
        }
        if sortingOption == "Highest score" {
//            firestoreDb.collection("leaderboard").getDocuments { (querySnapshot, err) in
//                ActivityIndicator.sharedInstance.hideActivityIndicator()
//                self.leaderBoardData = LeaderBoardDataModel().getData(snapshot: querySnapshot)
//            }
            self.leaderBoardData = self.leaderBoardData.sorted(by: {($0.total ?? 0) > ($1.total ?? 0)})
            //self.leaderBoardTable.reloadData()
        } else if sortingOption == "Lowest score" {
//            firestoreDb.collection("leaderboard").getDocuments { (querySnapshot, err) in
//                ActivityIndicator.sharedInstance.hideActivityIndicator()
//                self.leaderBoardData = LeaderBoardDataModel().getData(snapshot: querySnapshot)
//            }
            self.leaderBoardData = self.leaderBoardData.sorted(by: {($0.total ?? 0) < ($1.total ?? 0)})
            //self.leaderBoardTable.reloadData()
        } else {
            //            self.leaderBoardData = self.leaderBoardData.sorted(by: {$0.total ?? 0 < $1.total ?? 0})
//            firestoreDb.collection("leaderboard").getDocuments { (querySnapshot, err) in
//                ActivityIndicator.sharedInstance.hideActivityIndicator()
//                self.leaderBoardData = LeaderBoardDataModel().getData(snapshot: querySnapshot)
                //self.leaderBoardTable.reloadData()
            //}
        }
    }
    
    func returnSelectedCategory(name: String) {
        print("sort by category return from filte vc---\(name)")
        self.categoryValue = name
        self.leaderBoardTable.reloadData()
    }
}
//MARK: code for update controllers data ------
func fetchPresenterLeaderBoard() {
    print("view controllers methods called from presenter")
}

extension LeadersViewController: LeaderBoardViewProtocol {
    func fetchPresenterLeaderBoard(leaderBoardData: [LeaderBoardDataModel]) {
        self.leaderBoardData = leaderBoardData
        self.leaderBoardTable.reloadData()
        self.loader.isHidden = true
        self.loader.stopAnimating()
        self.refreshControl.endRefreshing()
        print("leader board data count---\(leaderBoardData.count)")
        print("leader board data first user details ----\(leaderBoardData.first?.r1 ?? 0)")
        print("leader board data first user details ----\(leaderBoardData.first?.r2 ?? 0)")
        print("leader board data first user details ----\(leaderBoardData.first?.rank ?? 0)")
        print("leader board data first user details ----\(leaderBoardData.first?.tournamentId ?? "")")
        print("leader board data first user details ----\(leaderBoardData.first?.userId ?? "")")
        if let firstUserDetils = leaderBoardData.first?.usersDetails {
            print("leader board data first user details ----\(firstUserDetils.name ?? "")")
            print("leader board data first user details ----\(firstUserDetils.uid ?? "")")
        }
    }
}










