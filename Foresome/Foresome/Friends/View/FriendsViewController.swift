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
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var presenter: FriendsPresenterProtocol?
    var listUserData =  [UserListModel]()
    weak var headerView: FriendsTableHeader?
    var isMembersdata: Bool = true
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.isHidden = true
        self.friendsTableView.refreshControl = refreshControl
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.friendsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshFriendsData(_:)), for: .valueChanged)
        fetchMembersData()
    }
    
    @objc private func refreshFriendsData(_ sender: Any) {
        self.refreshControl.beginRefreshing()
        self.loader.isHidden = false
        self.loader.startAnimating()
        fetchMembersData()
    }
    
    func setTableView() {
        self.friendsTableView.delegate = self
        self.friendsTableView.dataSource = self
        self.friendsTableView.register(cellClass: FriendsTableViewCell.self)
        setTableHeader()
    }
    
    func fetchMembersData() {
        self.refreshControl.tintColor = .clear
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
        self.loader.isHidden = true
        self.refreshControl.endRefreshing()
        self.loader.stopAnimating()
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
        print("user name ---\(data?.name ?? "")")
        let confirmPovUp = UnFriendViewController()
        confirmPovUp.modalPresentationStyle = .overFullScreen
        self.present(confirmPovUp, true)
    }
}

extension FriendsViewController: FriendsViewProtocol {
    func fetchUsersListData(data: [UserListModel]) {
    }
}


