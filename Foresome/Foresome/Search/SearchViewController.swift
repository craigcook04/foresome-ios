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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customPlaceholder()
        searchTextField.delegate = self
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filteredUserData.count == 0 {
            self.searchTableView.setBackgroundView(message: "No data found")
        } else {
            self.searchTableView.restore()
        }
        return self.filteredUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(cell: FriendsTableViewCell.self, for: indexPath)
        cell.showSearchData(searchData: self.filteredUserData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.initView(view: SearchSectionHeader.self)
        view.delegate = self
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
            self.searchTableView.reloadData()
            return false
        } else {
            if updatedString.count > 0 {
                print("updated string is ----\(updatedString)")
                self.sectionHeight = 0.001
                let searchText = updatedString
                self.filteredUserData = self.listUserData.filter({$0.name?.contains(searchText.lowercased()) ?? false})
                self.filteredUserData = self.listUserData.filter({$0.name?.lowercased().contains(searchText.lowercased()) ?? false})
                self.searchTableView.reloadData()
            } else {
                self.filteredUserData.removeAll()
                self.filteredUserData = []
                self.sectionHeight = 56.0
                self.searchTableView.reloadData()
            }
            return true
        }
    }
}

