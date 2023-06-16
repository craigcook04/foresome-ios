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
    
    var usersFriendsList: [String]?
    
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
        self.addCollectionData()
        self.fetchFriendsData()
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
    
    func fetchMembersData() {
        self.refreshControl.tintColor = .clear
        self.listUserData.removeAll()
        self.listUserData = []
        ActivityIndicator.sharedInstance.showActivityIndicator()
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
        self.arrayOfNoUserName.forEach({ userid in
            print("no user name user id is ----\(userid)")
        })
    }
    
    func friendsAction() {
        print("friends called in controller")
        self.isMembersdata = false
        self.friendsTableView.reloadData()
        self.listUserData.forEach({ data in
            if data.name == "" || data.name == nil {
                if let user_id = data.uid {
                    self.arrayOfNoUserName.append(user_id)
                }
            }
        })
    }
    
    func searchData() {
        let searchVC = SearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.pushViewController(searchVC, false)
    }
}

extension FriendsViewController: FriendsTableViewCellDelegate {
    func addFriend(data: UserListModel?) {
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        var usersFriendsList = strings?["friends"] ?? []
        var oldFriendsListing = usersFriendsList
        self.usersFriendsList = usersFriendsList
        
        
        usersFriendsList
        
        
        
        
        
        
        
        //MARK: code for add friends in users friends listing---
        let currentUserId = UserDefaultsCustom.currentUserId
        print("current login user id ---\(currentUserId)")
         
        firebaseDb.collection("users").document(currentUserId).setData(["friends":""], merge: true) { error  in
            if error == nil {
                Singleton.shared.showMessage(message: "Add friend successfully.", isError: .success)
            } else {
                if let error = error {
                    Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                }
            }
        }
        
        //MARK: code for create new user on firebase ------
        func createNewUser(fullName: String, email: String, password: String, confirmPassword: String) {
            ActivityIndicator.sharedInstance.showActivityIndicator()
            Auth.auth().createUser(withEmail: "\(email)", password: "\(password)", completion: { (result, error) -> Void in
                if (error == nil) {
                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData(["name":"\(fullName)", "email":"\(email)", "createdDate:":"\(Date().localToUtc ?? Date())", "uid": result!.user.uid, "user_location":"", "user_profile_pic":"", "user_skill_level":""])
                    UserDefaultsCustom.setValue(value: result!.user.uid, forKey: "user_uid")
                    db.collection("users").document(result!.user.uid).getDocument { (snapData, error) in
                        if let data = snapData?.data() {
                            let userdata = ReturnUserData()
                            UserDefaults.standard.set(data, forKey: AppStrings.userDatas)
                        }
                    }
                    if let signupVc = self.view as? SignUpViewController {
                        let locationVc = LocationPresenter.createLocationModule()
                        signupVc.pushViewController(locationVc, true)
                    }
                } else {
                    Singleton.shared.showMessage(message:error?.localizedDescription ?? "", isError: .error)
                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                }
            })
        }
        
        
        
        
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
        data.forEach({ singleData in
            print("single data name is----\(singleData.name ?? "")")
            print("single data email is----\(singleData.email ?? "")")
            print("single data uid is ----\(singleData.uid ?? "")")
        })
    }
}


