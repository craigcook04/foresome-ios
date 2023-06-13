//
//  NotificationsViewController.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit

class NotificationsViewController: UIViewController, NotificationViewProtocol {
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    var presenter: NotificationPresenterProtocol?
    
    var numberOfRow = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    func setTable() {
        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        self.notificationTableView.register(cellClass: NotificationsTableViewCell.self)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func clearAllAction(_ sender: UIButton) {
        print("clear all action called.")
        self.numberOfRow = 0
        self.notificationTableView.reloadData()
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cell: NotificationsTableViewCell.self, for: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected index is -==\(indexPath.row)")
    }
}

extension NotificationsViewController: NotificationsTableViewCellDelegate {
    func closeButtonAction() {
        print("close button called ")
    }
}


