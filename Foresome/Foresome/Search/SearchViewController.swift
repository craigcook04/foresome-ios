//
//  SearchViewController.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
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
import CoreData

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var listUserData =  [UserListModel]()
    var filteredUserData = [UserListModel]()
    var recentSearchData = [UserListModel]()
    var recentSearchUserIds : [String]?
    let firebaseDb = Firestore.firestore()
    var sectionHeight = 56.0
    var headerView : SearchSectionHeader?
    var usersFriendsList: [String] = []
    var showRecentSearchData: Bool = false
    
    override func viewDidLoad() {
        self.searchTextField.autocorrectionType  = .no
        super.viewDidLoad()
        self.customPlaceholder()
        searchTextField.delegate = self
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.assignRecentSearchData()
        self.searchButton.isHidden = true
        self.getUserFriendsList()
        self.searchTextField.becomeFirstResponder()
        self.fetchMembersData()
    }
    
    func assignRecentSearchData() {
        self.recentSearchUserIds = (UserDefaults.standard.value(forKey: AppStrings.recentSearchData) as? [String]) ?? []
    }
    
    func customPlaceholder() {
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search user by name…",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#909398")]
        )
    }
    
    func setTableView() {
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.register(cellClass: FriendsTableViewCell.self)
    }
    
    func fetchMembersData() {
        self.listUserData.removeAll()
        self.listUserData = []
        firebaseDb.collection("users").getDocuments { (querySnapshot, err) in
            querySnapshot?.documents.enumerated().forEach({ (index,document) in
                let membersData =  document.data()
                let userlistdata = UserListModel(json: membersData)
                if userlistdata.uid != UserDefaultsCustom.currentUserId {
                    self.listUserData.append(userlistdata)
                } else {
                    print("no need to append current login user in user listing.")
                }
            })
            self.searchTableView.reloadData()
        }
        self.searchTableView.reloadData()
    }
    
    func fetchRecentSearchData() {
        self.listUserData.forEach({ singleSearchData in
            if recentSearchUserIds?.contains(where: {$0 == singleSearchData.uid}) == true  {
                self.recentSearchData.append(singleSearchData)
            }
        })
        self.searchTableView.reloadData()
    }
    
    @IBAction func serchAction(_ sender: UIButton) {
        self.searchButton.isHidden = true
        self.searchTextField.text?.removeAll()
        self.searchTableView.backgroundView = nil
        self.filteredUserData.removeAll()
        self.filteredUserData = []
        self.searchTableView.reloadData()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    func getUserFriendsList() {
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        let usersFriendsList = strings?["friends"] ?? []
        self.usersFriendsList = usersFriendsList as? [String] ?? []
    }
    
    //MARK: update friends list when user make unfriends-----
    func updateUnfriendsListData(friendsList: [String]) {
        ActivityIndicator.sharedInstance.showActivityIndicator()
        self.filteredUserData.removeAll()
        self.usersFriendsList.forEach({ friendsData in
            self.listUserData.forEach({ allUsersListData in
                if allUsersListData.uid == friendsData {
                    self.filteredUserData.append(allUsersListData)
                }
            })
        })
        ActivityIndicator.sharedInstance.hideActivityIndicator()
        self.searchTableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showRecentSearchData ==  true {
            return self.recentSearchData.count
        } else {
            return self.filteredUserData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(cell: FriendsTableViewCell.self, for: indexPath)
        cell.delegate = self
        if showRecentSearchData == true {
            cell.showSearchData(searchData: self.recentSearchData[indexPath.row], isMemberData: true, usersFriendsList: self.usersFriendsList, isfromRecent: true)
        } else {
            cell.showSearchData(searchData: self.filteredUserData[indexPath.row], isMemberData: true, usersFriendsList: self.usersFriendsList, isfromRecent: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = self.headerView//UIView.initView(view: SearchSectionHeader.self)
        view?.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
}

extension SearchViewController : SearchSectionHeaderDelegate {
    func clearAction() {
        self.filteredUserData.removeAll()
        self.filteredUserData = []
        UserDefaults.standard.removeObject(forKey: AppStrings.recentSearchData)
        self.recentSearchData.removeAll()
        self.recentSearchData = []
        self.searchTableView.reloadData()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text as NSString? else {
            return false
        }
        let updatedString = text.replacingCharacters(in: range, with: string)
        print("new text is ---\(updatedString)")
        if updatedString == " " {
            self.searchButton.isHidden = true
            self.sectionHeight = 56.0
            self.showRecentSearchData = true
            self.fetchRecentSearchData()
            self.headerView = UIView.initView(view: SearchSectionHeader.self)
            self.searchTableView.reloadData()
            return false
        } else {
            if updatedString.count > 0 {
                self.searchButton.isHidden = false
                self.sectionHeight = 0.001
                self.showRecentSearchData = false
                self.headerView = nil
                let searchText = updatedString
                self.filteredUserData = self.listUserData.filter({$0.name?.contains(searchText.lowercased()) ?? false})
                self.filteredUserData = self.listUserData.filter({$0.name?.lowercased().contains(searchText.lowercased()) ?? false})
                if self.filteredUserData.count == 0 {
                    self.searchTableView.setBackgroundWithCustomView(message: "No data found")
                } else {
                    self.searchTableView.restore()
                }
                self.searchTableView.reloadData()
            } else {
                self.searchButton.isHidden = true
                self.filteredUserData.removeAll()
                self.filteredUserData = []
                self.sectionHeight = 56.0
                self.showRecentSearchData = true
                self.fetchRecentSearchData()
                self.headerView = UIView.initView(view: SearchSectionHeader.self)
                self.searchTableView.reloadData()
            }
            return true
        }
    }
}

extension SearchViewController: FriendsTableViewCellDelegate {
    func makeUnFriend(data: UserListModel?, senderButton: UIButton) {
        print("senderButton current title is ----\(senderButton.currentTitle ?? "")")
        if senderButton.currentTitle == "Unfriend" {
            print("user id to make unfriend----\(data?.uid ?? "")")
            print("user name to make unfriend----\(data?.name ?? "")")
            self.usersFriendsList.remove(element: data?.uid ?? "")
            let confirmPovUp = UnFriendViewController()
            confirmPovUp.delegate = self
            confirmPovUp.userToMakeUnfriends = data ?? UserListModel()
            confirmPovUp.usersFriendsList = self.usersFriendsList
            confirmPovUp.modalPresentationStyle = .overFullScreen
            self.present(confirmPovUp, true)
        } else {
            if let userListData = data {
                // self.recentSearchData.append(userListData)
                self.recentSearchUserIds?.append(userListData.uid ?? "")
                UserDefaults.standard.set(self.recentSearchUserIds ?? [], forKey: AppStrings.recentSearchData)
            }
            print("user id to make friend ---\(data?.uid ?? "")")
            print("user name to make friend-----\(data?.name ?? "")")
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
                        self.searchTableView.reloadData()
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
    
    func addFriend(data: UserListModel?, removeButton: UIButton) {
        print("add friends called in search controller.")
    }
}

extension SearchViewController : UnFriendViewControllerDelegate {
    func updateFriendsData(friendsListData: [String]) {
        self.updateUnfriendsListData(friendsList: friendsListData)
    }
}


