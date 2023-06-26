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

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var numberOfRow = 10
    var listUserData =  [UserListModel]()
    var filteredUserData = [UserListModel]()
    let firebaseDb = Firestore.firestore()
    var sectionHeight = 56.0
    var recentSearchData = [UserListModel]()
    var headerView : SearchSectionHeader?
    var usersFriendsList: [String] = []
    
    override func viewDidLoad() {
        self.searchTextField.autocorrectionType  = .no
        super.viewDidLoad()
        self.customPlaceholder()
        searchTextField.delegate = self
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserFriendsList()
        self.searchTextField.becomeFirstResponder()
        self.fetchMembersData()
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
                self.listUserData.append(userlistdata)
            })
            self.searchTableView.reloadData()
        }
        self.searchTableView.reloadData()
    }
    
    @IBAction func serchAction(_ sender: UIButton) {
        print("search action called.")
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        print("back called")
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
        return self.filteredUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(cell: FriendsTableViewCell.self, for: indexPath)
        cell.delegate = self
        cell.showSearchData(searchData: self.filteredUserData[indexPath.row], isMemberData: true, usersFriendsList: self.usersFriendsList)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = self.headerView//UIView.initView(view: SearchSectionHeader.self)
        view?.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  sectionHeight
    }
}

extension SearchViewController : SearchSectionHeaderDelegate {
    func clearAction() {
        self.filteredUserData.removeAll()
        self.filteredUserData = []
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
            self.sectionHeight = 56.0
            self.headerView = UIView.initView(view: SearchSectionHeader.self)
            self.searchTableView.reloadData()
            return false
        } else {
            if updatedString.count > 0 {
                print("updated string is ----\(updatedString)")
                self.sectionHeight = 0.001
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
                self.filteredUserData.removeAll()
                self.filteredUserData = []
                self.sectionHeight = 56.0
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
        //self.searchTableView.reloadData()
    }
    
    func addFriend(data: UserListModel?, removeButton: UIButton) {
        print("add friends called in search controller.")
    }
}

extension SearchViewController : UnFriendViewControllerDelegate {
    func updateFriendsData(friendsListData: [String]) {
        print("updated friends list data count is ----\(friendsListData.count)")
        self.usersFriendsList = friendsListData
        self.searchTableView.reloadData()
    }
}




