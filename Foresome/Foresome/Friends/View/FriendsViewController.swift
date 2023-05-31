//
//  FriendsViewController.swift
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

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var friendsTableView: StrachyHeaderTable!
     
    var listUserData =  [UserListModel]()
    
    weak var headerView: FriendsTableHeader?
    
    var isMembersdata: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMembersData()
    }
    
    func setTableView() {
        self.friendsTableView.delegate = self
        self.friendsTableView.dataSource = self
        self.friendsTableView.register(cellClass: FriendsTableViewCell.self)
        setTableHeader()
    }
    
    func fetchMembersData() {
        self.listUserData.removeAll()
        self.listUserData = []
        ActivityIndicator.sharedInstance.showActivityIndicator()
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (querySnapshot, err) in
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            querySnapshot?.documents.enumerated().forEach({ (index,document) in
                let membersData =  document.data()
                let userlistdata = UserListModel(json: membersData)
                self.listUserData.append(userlistdata)
            })
            self.friendsTableView.reloadData()
        }
        self.friendsTableView.reloadData()
    }
    
    func setTableHeader() {
        guard headerView == nil else { return }
        let height: CGFloat = 250
        let view = UIView.initView(view: FriendsTableHeader.self)
        view.delegate = self
        view.setHeaderData()
        self.friendsTableView.setStrachyHeader(header: view, height: height)
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(cell: FriendsTableViewCell.self, for: indexPath)
        cell.setCellData(isMemberData: isMembersdata)
        cell.setListData(data: self.listUserData[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension FriendsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.friendsTableView.setStrachyHeader()
    }
}

extension FriendsViewController: FriendsTableHeaderDelegate {
    func notificationBtnAction() {
        let notificationVc = NotificationPresenter.createNotificationModule()
        notificationVc.hidesBottomBarWhenPushed = true
        self.pushViewController(notificationVc, false)
    }
    
    func membersAction() {
         print("members called in controller")
        self.isMembersdata = true
        self.friendsTableView.reloadData()
    }
    
    func friendsAction() {
         print("friends called in controller")
        self.isMembersdata = false
        self.friendsTableView.reloadData()
    }
    
    func searchData() {
        let searchVC = SearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.pushViewController(searchVC, false)
    }
}

extension FriendsViewController: FriendsTableViewCellDelegate {
    func addFriend(data: UserListModel?) {
        Singleton.shared.showMessage(message: "Added successfully", isError: .success)
        print("user name ---\(data?.name ?? "")")
    }
    
    func makeUnFriend(data: UserListModel?) {
        Singleton.shared.showMessage(message: "Unfriend successfully", isError: .success)
        print("user name ---\(data?.name ?? "")")
    }
}


