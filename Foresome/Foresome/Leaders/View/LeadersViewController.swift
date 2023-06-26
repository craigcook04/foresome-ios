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
    var filteredData = [LeaderBoardDataModel]()
    var allUsersList = [UserListModel]()
    var firstThreeUsers = [UserListModel]()
    var categoryValue : String?
    private let refreshControl = UIRefreshControl()
    var usersFriendsList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leaderBoardTable.refreshControl = refreshControl
        self.leaderBoardTable.automaticallyAdjustsScrollIndicatorInsets = false
        setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loader.isHidden = true
        self.leaderBoardTable.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshLeaderBoardData(_:)), for: .valueChanged)
        //MARK: code for fetch leaders board data from presenter---
        self.presenter?.fetchPresenterViewLeaderBoard(isFromRefresh: false)
    }
    
    @objc private func refreshLeaderBoardData(_ sender: Any) {
        self.refreshControl.beginRefreshing()
        self.loader.isHidden = false
        self.loader.startAnimating()
        self.presenter?.fetchPresenterViewLeaderBoard(isFromRefresh: true)
    }
    
    func setTable() {
        self.leaderBoardTable.delegate = self
        self.leaderBoardTable.dataSource = self
        self.leaderBoardTable.register(cellClass: LeaderBoardTableViewCell.self)
        setTableHeader()
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
        if leaderBoardData.count > 0 {
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.leaderBoardData.filter({$0.rank ?? 0 < 4 }).count
        } else {
            return self.filteredData.filter({ $0.rank ?? 0 > 3}).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(cell: LeaderBoardTableViewCell.self, for: indexPath)
        if self.leaderBoardData.count > 0 {
            cell.setCellLeaderBoardData(data: self.leaderBoardData, tableSection: indexPath.section, tableRow: indexPath.row, sortByCondition: self.categoryValue ?? "All", dataForSecondSection: self.filteredData)
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView()
            view.backgroundColor = .red
            return view
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            if leaderBoardData.count < 4 {
                return 0.001
            } else {
                return 50
            }
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
        }
        if tournamentId.count > 0 {
            //MARK: filter by friends name and tournaments both -----
            query = "\(query)&tournamentId=\(tournamentId)"
            self.filteredData = self.leaderBoardData.filter({$0.rank ?? 0 > 3}).filter({$0.tournamentId == tournamentId})
            if sortingOption == "Highest score" {
                self.filteredData = self.filteredData.filter({$0.rank ?? 0 > 3}).sorted(by: {($0.total ?? 0) > ($1.total ?? 0)})
                self.leaderBoardTable.reloadData()
            } else if sortingOption == "Lowest score" {
                self.filteredData = self.filteredData.filter({$0.rank ?? 0 > 3}).sorted(by: {($0.total ?? 0) < ($1.total ?? 0)})
                self.leaderBoardTable.reloadData()
            } else {
                self.leaderBoardTable.reloadData()
            }
        }
        
        if friendName.count == 0 && tournamentId.count == 0 {
            if sortingOption == "Highest score" {
                self.filteredData = self.leaderBoardData.filter({$0.rank ?? 0 > 3})
                self.filteredData = self.leaderBoardData.filter({$0.rank ?? 0 > 3}).sorted(by: {($0.total ?? 0) > ($1.total ?? 0)})
                self.leaderBoardTable.reloadData()
            } else if sortingOption == "Lowest score" {
                self.filteredData = self.leaderBoardData.filter({$0.rank ?? 0 > 3}).sorted(by: {($0.total ?? 0) < ($1.total ?? 0)})
                self.leaderBoardTable.reloadData()
            } else {
                self.filteredData = self.leaderBoardData.filter({$0.rank ?? 0 > 3})
                self.leaderBoardTable.reloadData()
            }
        }
        
        if friendName.count > 0 {
            self.filteredData = self.leaderBoardData.filter({$0.rank ?? 0 > 3})
            self.filteredData = self.leaderBoardData.filter({$0.rank ?? 0 > 3}).filter({$0.usersDetails?.name ?? "" == friendName })
            if sortingOption == "Highest score" {
                self.filteredData = self.filteredData.filter({$0.rank ?? 0 > 3}).sorted(by: {($0.total ?? 0) > ($1.total ?? 0)})
                self.leaderBoardTable.reloadData()
            } else if sortingOption == "Lowest score" {
                self.filteredData = self.filteredData.filter({$0.rank ?? 0 > 3}).sorted(by: {($0.total ?? 0) < ($1.total ?? 0)})
                self.leaderBoardTable.reloadData()
            } else {
                self.leaderBoardTable.reloadData()
            }
        }
        
        if friendName.count > 0 && tournamentId.count > 0  {
            print("search by friends and tournamentsid same time.")
            self.filteredData = self.leaderBoardData.filter({$0.rank ?? 0 > 3})
            self.filteredData = self.leaderBoardData.filter({$0.rank ?? 0 > 3}).filter({$0.usersDetails?.name ?? "" == friendName })
            self.filteredData = self.filteredData + self.leaderBoardData.filter({$0.rank ?? 0 > 3}).filter({$0.usersDetails?.name ?? "" == tournamentId })
            if sortingOption == "Highest score" {
                self.filteredData = self.filteredData.filter({$0.rank ?? 0 > 3}).sorted(by: {($0.total ?? 0) > ($1.total ?? 0)})
                self.leaderBoardTable.reloadData()
            } else if sortingOption == "Lowest score" {
                self.filteredData = self.filteredData.filter({$0.rank ?? 0 > 3}).sorted(by: {($0.total ?? 0) < ($1.total ?? 0)})
                self.leaderBoardTable.reloadData()
            } else {
                self.leaderBoardTable.reloadData()
            }
        }
    }
    
    func returnSelectedCategory(name: String) {
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
        self.filteredData = leaderBoardData
        self.leaderBoardTable.reloadData()
        ActivityIndicator.sharedInstance.hideActivityIndicator()
        self.loader.isHidden = true
        self.loader.stopAnimating()
        self.refreshControl.endRefreshing()
        if let firstUserDetils = leaderBoardData.first?.usersDetails {
            print("leader board data first user details ----\(firstUserDetils.name ?? "")")
            print("leader board data first user details ----\(firstUserDetils.uid ?? "")")
        }
    }
}










