//
//  CustomNavController.swift
//  EQ
//
//  Created by apple on 24/01/22.
//

import Foundation
import UIKit
final class NavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(root:UIViewController) {
        super.init(rootViewController: root)
        self.navigationBar.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
