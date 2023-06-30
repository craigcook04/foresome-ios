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
    var friendsListData = [UserListModel]()
    weak var headerView: FriendsTableHeader?
    var isMembersdata: Bool = true
    var usersFriendsList: [String] = []
    var arrayOfNoUserName : [String] = []
    private let refreshControl = UIRefreshControl()
    let firebaseDb = Firestore.firestore()
    
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
        fetchMembersData(isFromRefresh: false)
    }
    
    @objc private func refreshFriendsData(_ sender: Any) {
        self.refreshControl.beginRefreshing()
        self.loader.isHidden = false
        self.loader.startAnimating()
        fetchMembersData(isFromRefresh: true)
    }
    
    func setTableView() {
        self.friendsTableView.delegate = self
        self.friendsTableView.dataSource = self
        self.friendsTableView.register(cellClass: FriendsTableViewCell.self)
        setTableHeader()
    }
    
    func fetchMembersData(isFromRefresh: Bool) {
        self.refreshControl.tintColor = .clear
        self.listUserData.removeAll()
        self.listUserData = []
        if isFromRefresh == true {
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            refreshControl.beginRefreshing()
            self.loader.startAnimating()
        } else {
            ActivityIndicator.sharedInstance.showActivityIndicator()
        }
        firebaseDb.collection("users").getDocuments { (querySnapshot, err) in
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            querySnapshot?.documents.enumerated().forEach({ (index,document) in
                let membersData =  document.data()
                let userlistdata = UserListModel(json: membersData)
                if userlistdata.uid != UserDefaultsCustom.currentUserId {
                    self.listUserData.append(userlistdata)
                } else {
                    print("no need to append current user in users listing.")
                }
            })
            self.listUserData.sort(by: {($0.name ?? "").compare($1.name ?? "") == .orderedAscending })
            self.loader.isHidden = true
            self.refreshControl.endRefreshing()
            self.loader.stopAnimating()
            let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
            let usersFriendsList = strings?["friends"] ?? []
            self.usersFriendsList = usersFriendsList as? [String] ?? []
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
        if self.isMembersdata == false {
            if self.friendsListData.count == 0 {
                self.friendsTableView.setBackgroundView(message: "no friends found")
            } else {
                self.friendsTableView.restore()
            }
            return friendsListData.count
        } else {
            if self.listUserData.count == 0 {
                // self.friendsTableView.setBackgroundView(message: "No data found")
            } else {
                self.friendsTableView.restore()
            }
            return listUserData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(cell: FriendsTableViewCell.self, for: indexPath)
        cell.setCellData(isMemberData: isMembersdata)
        if self.isMembersdata == false {
            cell.setListData(data: self.friendsListData[indexPath.row], isMemberData: self.isMembersdata, usersFriendsList: self.usersFriendsList)
        } else {
            cell.setListData(data: self.listUserData[indexPath.row], isMemberData: self.isMembersdata, usersFriendsList: self.usersFriendsList)
        }
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
        self.deleteAllEmptyUsers()
        print("members called in controller")
        self.isMembersdata = true
        self.friendsTableView.reloadData()
    }
    
    //MARK: update friends list when user make unfriends-----
    func updateUnfriendsListData(friendsList: [String]) {
        ActivityIndicator.sharedInstance.showActivityIndicator()
        self.friendsListData.removeAll()
        self.usersFriendsList.forEach({ friendsData in
            self.listUserData.forEach({ allUsersListData in
                if allUsersListData.uid == friendsData {
                    self.friendsListData.append(allUsersListData)
                }
            })
        })
        ActivityIndicator.sharedInstance.hideActivityIndicator()
        self.friendsTableView.reloadData()
    }
    
    func friendsAction() {
        print("friends called in controller")
        self.isMembersdata = false
        //MARK: add friends list data inside this data-------
        self.friendsListData.removeAll()
        self.usersFriendsList.forEach({ friendsData in
            self.listUserData.forEach({ allUsersListData in
                if allUsersListData.uid == friendsData {
                    self.friendsListData.append(allUsersListData)
                }
            })
        })
        self.friendsTableView.reloadData()
    }
    
    func deleteAllEmptyUsers() {
        firebaseDb.collection("users").document(" ").delete { error in
            if error == nil {
                print("deleted ")
            } else {
                print("not deleted")
            }
        }
    }
    
    //MARK: code for search data--------
    func searchData() {
        let searchVC = SearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.pushViewController(searchVC, false)
    }
}

extension FriendsViewController: FriendsTableViewCellDelegate {
    func makeUnFriend(data: UserListModel?, senderButton: UIButton) {
        print("user name ---\(data?.name ?? "")")
        self.usersFriendsList.remove(element: data?.uid ?? "")
        let confirmPovUp = UnFriendViewController()
        confirmPovUp.delegate = self
        confirmPovUp.userToMakeUnfriends = data ?? UserListModel()
        confirmPovUp.usersFriendsList = self.usersFriendsList
        confirmPovUp.modalPresentationStyle = .overFullScreen
        self.present(confirmPovUp, true)
    }
    func addFriend(data: UserListModel?, removeButton: UIButton) {
        print("sender current title is---\(removeButton.currentTitle ?? "")")
        //MARK: First fetch current users all data from users collections -------------
        if removeButton.currentTitle == "Remove" {
            print("user name ---\(data?.name ?? "")")
            self.usersFriendsList.remove(element: data?.uid ?? "")
            let currentUserId = UserDefaultsCustom.currentUserId
            print("current login user id ---\(currentUserId)")
            firebaseDb.collection("users").document(currentUserId).setData(["friends":self.usersFriendsList], merge: true) { error  in
                if error == nil {
                    Singleton.shared.showMessage(message: "Removed friend successfully.", isError: .success)
                    DispatchQueue.main.async {
                        self.friendsTableView.reloadData()
                    }
                    self.firebaseDb.collection("users").document(currentUserId).getDocument { (snapData, error) in
                        if let data = snapData?.data() {
                            UserDefaults.standard.set(data, forKey: AppStrings.userDatas)
                        }
                    }
                } else {
                    if let error = error {
                        Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                    }
                }
            }
        } else {
            let currentUserId = UserDefaultsCustom.currentUserId
            let userToAddFriends = data?.uid ?? ""
            self.usersFriendsList.append(userToAddFriends)
            print("user id to want to add friend ---\(data?.uid ?? "")")
            print("data for added to friends list is ---\(self.usersFriendsList)")
            //MARK: code for add friends in users friends listing---
            print("current login user id ---\(currentUserId)")
            firebaseDb.collection("users").document(currentUserId).setData(["friends":self.usersFriendsList], merge: true) { error  in
                if error == nil {
                    Singleton.shared.showMessage(message: "Add friend successfully.", isError: .success)
                    DispatchQueue.main.async {
                        self.friendsTableView.reloadData()
                    }
                    self.firebaseDb.collection("users").document(currentUserId).getDocument { (snapData, error) in
                        if let data = snapData?.data() {
                            UserDefaults.standard.set(data, forKey: AppStrings.userDatas)
                        }
                    }
                } else {
                    if let error = error {
                        Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                    }
                }
            }
        }
    }
}

extension FriendsViewController: FriendsViewProtocol {
    func fetchUsersListData(data: [UserListModel]) {
        data.forEach({ singleData in
        })
    }
}

extension FriendsViewController: UnFriendViewControllerDelegate {
    func updateFriendsData(friendsListData: [String]) {
        self.updateUnfriendsListData(friendsList: friendsListData)
    }
}


