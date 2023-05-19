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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func clearAllAction(_ sender: UIButton) {
        print("clear all action called.")
    }
}

 
