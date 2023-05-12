//
//  AppNavigation.swift
//  DigitalMenu
//
//  Created by apple on 15/11/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class AppNavigation: UINavigationController {

    convenience init(root: UIViewController) {
        self.init(rootViewController: root)
        self.isNavigationBarHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    

    override func viewDidLoad() {
        self.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
