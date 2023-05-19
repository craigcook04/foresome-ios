//
//  NotificationPresenter.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import Foundation
import UIKit

class NotificationPresenter: NotificationPresenterProtocol {
    
    var view: NotificationViewProtocol?
     
    static func createNotificationModule() -> NotificationsViewController {
        let view = NotificationsViewController()
        var presenter: NotificationPresenterProtocol = NotificationPresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
