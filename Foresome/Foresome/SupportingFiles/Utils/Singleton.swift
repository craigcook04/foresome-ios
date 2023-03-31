//
//  Singleton.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 07/04/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import UIKit

class Singleton: NSObject {
    
    static let shared = Singleton()
    var window  : UIWindow?
    var keyboardSize: CGSize = CGSize(width: 0.0, height: 0.0)
    var errorMessageView: ErrorView!
    var callBackFromError: ((Bool?) -> Void)?

    static var tabController:TabbarViewController!
    
    override init() {
        super.init()
    }

    func logoutFromDevice() {
        DispatchQueue.main.async {
            OperationQueue.main.cancelAllOperations()
            UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.accessToken)
            UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.userData)
            NotificationCenter.default.removeObserver(self)
            self.gotoLogin()
        }
    }
    
    //MARK: ERROR MESSAGE
    func showErrorMessage(error:String, isError: ERROR_TYPE) {
        DispatchQueue.main.async {
//            guard let window = UIWindow.key else {return}
            if self.errorMessageView == nil {
                self.errorMessageView = UINib(nibName: NIB_NAME.errorView, bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ErrorView
                self.errorMessageView.delegate = self
                self.errorMessageView.statusIconBgView.isHidden = true
                self.errorMessageView.frame = CGRect(x: 10, y: 43 , width: SCREEN_SIZE.width-20, height: HEIGHT.errorMessageHeight)
//    visibleController?.view.addSubview(errorMessageView)
                self.window?.addSubview(self.errorMessageView)
            }
            self.errorMessageView.setErrorMessage(message: error, isError: isError)
        }
    }
    
    
    func translateErrorMessage(toBottom:Bool) {
        if errorMessageView != nil {
            if toBottom == true {
                self.errorMessageView.translateToBottom()
            } else {
                self.errorMessageView.translateToTop()
            }
        }
    }
    
    func gotoLogin() {
        DispatchQueue.main.async {
//            let view = LoginPresenter.createLoginModule()
//            let navController = UINavigationController(rootViewController: view)
//            navController.navigationBar.isHidden = true
//            self.window?.rootViewController = navController
//            self.window?.makeKeyAndVisible()
        }
        
    }
    
    func gotoHome() {
        DispatchQueue.main.async {
            let view = TabbarViewController()
            let navController = UINavigationController(rootViewController: view)
            navController.navigationBar.isHidden = true
//            if let window = UIWindow.key{
            self.window?.rootViewController = navController
//                Singleton.shared.window = window
            self.window?.makeKeyAndVisible()
//            }
        }
    }
    
    
    func setHomeScreenView() {
        var window: UIWindow?
        if #available(iOS 13, *) {
            if SceneDelegate.shared?.window != nil {
                window = SceneDelegate.shared?.window
            } else {
                window = UIWindow(frame: UIScreen.main.bounds)
            }
        } else {
//            if let wind = (UIApplication.shared.delegate as! AppDelegate!).window {
//                window = wind
//            } else {
//                window = UIWindow(frame: UIScreen.main.bounds)
//            }
        }
        self.setHomeView(window: window)
    }
    
    
    func setHomeView(window: UIWindow? = Singleton.shared.window) {
        Singleton.tabController = TabbarViewController()
        window?.rootViewController = Singleton.tabController
        window?.makeKeyAndVisible()
        Singleton.tabController.tabBarItem.badgeColor = .green
        Singleton.tabController.selectedIndex = 2
        Singleton.shared.window = window
    }
}

extension Singleton: ErrorDelegate {
    //MARK: ERROR DELEGATE METHOD
    func removeErrorView() {
        if self.errorMessageView != nil {
            self.errorMessageView.removeFromSuperview()
            self.errorMessageView = nil
        }
    }
}

