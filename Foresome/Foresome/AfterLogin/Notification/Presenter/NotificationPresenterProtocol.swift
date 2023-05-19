//
//  NotificationPresenterProtocol.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import Foundation
import UIKit

protocol NotificationViewProtocol {
    var presenter :NotificationPresenterProtocol? {get set}
}

protocol NotificationPresenterProtocol {
    var view: NotificationViewProtocol? {get set}
}
