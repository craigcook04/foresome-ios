//
//  TabbarViewController.swift
//  Challenger
//
//  Created by Macbook Air on 16/05/22.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    var selectedStateImages:[UIImage] = [#imageLiteral(resourceName: "ic_logout"), #imageLiteral(resourceName: "ic_remove_feed_image"), #imageLiteral(resourceName: "ic_current_location"), #imageLiteral(resourceName: "ic_radio_button_inactive"), #imageLiteral(resourceName: "ic_apple")]
    var unselectedStateImages:[UIImage] = [#imageLiteral(resourceName: "ic_add_poll_options"), #imageLiteral(resourceName: "ic_close_white"), #imageLiteral(resourceName: "ic_leaders"), #imageLiteral(resourceName: "ic_radio_button_active"), #imageLiteral(resourceName: "ic_notification")]
    let itemArray:[String] = ["News", "Friends", "Tour", "Leaders", "Profile"]
    
    let HEIGHT_TAB_BAR:CGFloat = 68
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height += 8
        tabFrame.origin.y = self.view.frame.size.height - tabFrame.size.height //self.view.frame.size.height - HEIGHT_TAB_BAR
        self.tabBar.frame = tabFrame
    }
    
    private func setViewControllers() {
    
        let newsVC = SignUpViewController()
        let friendsVC  = SignUpViewController()
        let tourVC  = SignUpViewController()
        let leadersVC  = SignUpViewController()
        let profileVC  = SignUpViewController()
        
        let controllers: [UIViewController] = [newsVC, friendsVC, tourVC, leadersVC, profileVC]
        self.viewControllers = controllers.map({AppNavigation(root: $0)})
        
        self.tabBar.items?.enumerated().forEach({ (index, item) in
            item.selectedImage = self.selectedStateImages[index]
            item.image = self.unselectedStateImages[index]
            item.title = self.itemArray[index]
            item.tag = index
            item.imageInsets.top = 4
            item.imageInsets.bottom = 4
        })
    }
    
    private func presentViewController() {
        let controller = SignUpViewController()
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, false)
    }
}

extension UITabBar {
    func addBadge(index:Int) {
        if let tabItems = self.items {
            let tabItem = tabItems[index]
            tabItem.badgeValue = ""
        }
    }
    
    func removeBadge(index:Int) {
        if let tabItems = self.items {
            let tabItem = tabItems[index]
            tabItem.badgeValue = nil
        }
    }
 }
