//
//  FriendsViewController.swift
//  Foresome
//
//  Created by Deepanshu on 29/03/23.
//

import UIKit

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var friendsTableView: StrachyHeaderTable!
    
    
    
    weak var headerView: FriendsTableHeader?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    func setTableView() {
        self.friendsTableView.delegate = self
        self.friendsTableView.dataSource = self
        self.friendsTableView.register(cellClass: FriendsTableViewCell.self)
        setTableHeader()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(cell: FriendsTableViewCell.self, for: indexPath)
        return cell
    }
}

extension FriendsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.friendsTableView.setStrachyHeader()
    }
}

extension FriendsViewController: FriendsTableHeaderDelegate {
    func searchData() {
        let searchVC = SearchViewController()
        self.pushViewController(searchVC, false)
    }
}

