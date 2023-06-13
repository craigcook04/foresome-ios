//
//  SearchViewController.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var numberOfRow = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        setTableView()
    }
    
    func setTableView() {
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.register(cellClass: FriendsTableViewCell.self)
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
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(cell: FriendsTableViewCell.self, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.initView(view: SearchSectionHeader.self)
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
}

extension SearchViewController : SearchSectionHeaderDelegate {
    func clearAction() {
        print("clear action called.")
        self.numberOfRow = 0
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
            return false
        } else {
            if updatedString.count > 0 {
                print("updated string is ----\(updatedString)")
            } else {
                
            }
            return true
        }
    }
}





