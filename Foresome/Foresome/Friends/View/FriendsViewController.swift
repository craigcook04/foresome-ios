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
       // self.addCollectionData()
        self.fetchFriendsData()
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
    
    func addCollectionData() {
        print("users collection id ----\(firebaseDb.collection("users").collectionID)")
        let parentCollectionRef = Firestore.firestore().collection("users")
        let newDocumentRef = parentCollectionRef.addDocument(data: ["user_id:":""])
        let subcollectionRef = newDocumentRef.collection("friends")
        subcollectionRef.addDocument(data: ["user_id:":""])
    }
    
    func fetchFriendsData() {
        firebaseDb.collection("friends").getDocuments { (querySnapshot, err) in
            querySnapshot?.documents.enumerated().forEach({ (index,document) in
                let membersData =  document.data()
                print("friends data ----\(membersData)")
            })
        }
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
        if self.isMembersdata == false {
            if self.friendsListData.count == 0 {
                //self.friendsTableView.setBackgroundView(message: "No data found")
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
            cell.setListData(data: self.friendsListData[indexPath.row], isMemberData: self.isMembersdata)
        } else {
            cell.setListData(data: self.listUserData[indexPath.row], isMemberData: self.isMembersdata)
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
        self.getOnlyMembersData()
        self.arrayOfNoUserName.forEach({ userid in
            print("no user name user id is ----\(userid)")
        })
    }
    
    //MARK: update friends list when user make unfriends-----
    func updateUnfriendsListData(friendsList: [String]) {
        ActivityIndicator.sharedInstance.showActivityIndicator()
        self.friendsListData.removeAll()
        self.listUserData.forEach({ allUsersListData in
            print("all users list uid is ---\(allUsersListData.uid ?? "")")
            friendsList.forEach({ friendsData in
                if allUsersListData.uid == friendsData {
                    self.friendsListData.append(allUsersListData)
                }
            })
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            self.friendsTableView.reloadData()
        })
    }
    
    func friendsAction() {
        print("friends called in controller")
        self.isMembersdata = false
        //MARK: only fetch those users which have in  current login user friend list---
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        var usersFriendsList = strings?["friends"] ?? []
        self.usersFriendsList = usersFriendsList as? [String] ?? []
        //MARK: add friends list data inside this data-------
        self.listUserData.forEach({ allUsersListData in
            print("all users list uid is ---\(allUsersListData.uid ?? "")")
            self.usersFriendsList.forEach({ friendsData in
                if allUsersListData.uid == friendsData {
                    self.friendsListData.append(allUsersListData)
                }
            })
            self.friendsTableView.reloadData()
        })
        self.listUserData.forEach({ data in
            if data.name == "" || data.name == nil {
                if let user_id = data.uid {
                    self.arrayOfNoUserName.append(user_id)
                }
            }
        })
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
     
    //MARK: code for seprate only members data and remove all friends data from users list ------
    func getOnlyMembersData() {
        self.listUserData.forEach({ allListData in
            self.usersFriendsList.forEach({ userFriendsData  in
                if allListData.uid == userFriendsData {
                    self.listUserData.remove(element: allListData)
                }
            })
        })
    }
    //MARK: code for search data--------
    func searchData() {
        let searchVC = SearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.pushViewController(searchVC, false)
    }
}

extension FriendsViewController: FriendsTableViewCellDelegate {
    func addFriend(data: UserListModel?) {
        //MARK: First fetch current users all data from users collections -------------
        let currentUserId = UserDefaultsCustom.currentUserId
        firebaseDb.collection("users").document((currentUserId) as String).getDocument { (snapData, error) in
            if error == nil {
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                if let data = snapData?.data() {
                    UserDefaults.standard.set(data, forKey: AppStrings.userDatas)
                }
            } else {
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                Singleton.shared.showMessage(message: error?.localizedDescription ?? "" , isError: .error)
            }
        }
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        var usersFriendsList = strings?["friends"] ?? []
        self.usersFriendsList = usersFriendsList as? [String] ?? []
        let userToAddFriends = data?.uid ?? ""
        self.usersFriendsList.append(userToAddFriends)
        print("user id to want to add friend ---\(data?.uid ?? "")")
        print("data for added to friends list is ---\(self.usersFriendsList)")
        //MARK: code for add friends in users friends listing---
        print("current login user id ---\(currentUserId)")
        firebaseDb.collection("users").document(currentUserId).setData(["friends":self.usersFriendsList], merge: true) { error  in
            if error == nil {
                Singleton.shared.showMessage(message: "Add friend successfully.", isError: .success)
                self.listUserData.removeAll { singleUserData in
                    singleUserData.uid = userToAddFriends
                    self.friendsTableView.reloadData()
                    return true
                }
                if let data = data {
                    let removeIndex =  self.listUserData.firstIndex(of: data)
                    print("remove index is equal to ----\(removeIndex ?? 0)")
                    if let index = removeIndex {
                        self.listUserData.remove(at: index)
                    }
                }
            } else {
                if let error = error {
                    Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                }
            }
        }
        print("user name ---\(data?.name ?? "")")
    }
    
    func makeUnFriend(data: UserListModel?) {
        print("user name ---\(data?.name ?? "")")
        let confirmPovUp = UnFriendViewController()
        confirmPovUp.delegate = self
        confirmPovUp.userToMakeUnfriends = data ?? UserListModel()
        confirmPovUp.modalPresentationStyle = .overFullScreen
        self.present(confirmPovUp, true)
    }
}

extension FriendsViewController: FriendsViewProtocol {
    func fetchUsersListData(data: [UserListModel]) {
        data.forEach({ singleData in
            print("single data name is----\(singleData.name ?? "")")
            print("single data email is----\(singleData.email ?? "")")
            print("single data uid is ----\(singleData.uid ?? "")")
        })
    }
}

extension FriendsViewController: UnFriendViewControllerDelegate {
    func updateFriendsData(friendsListData: [String]) {
        self.updateUnfriendsListData(friendsList: friendsListData)
    }
}


