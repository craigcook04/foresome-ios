//
//  UIViewController+Custom.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 04/04/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import UIKit
//import ESTabBarController
import CoreLocation

extension UIViewController {
    
    var isModal: Bool {
        return (nil != self.presentingViewController) ||
            (self.navigationController?.presentingViewController?.presentedViewController == self.navigationController) ||
            (self.tabBarController?.presentingViewController is UITabBarController)
    }
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func removeChid() {
// Just to be safe, we check that this view controller
// is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func dismisController(with view:UIView, complition:@escaping() -> ()) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { finished in
            self.dismiss(animated: false) {
                DispatchQueue.main.async {
                    complition()
                }
            }
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func pushViewController(_ viewController: UIViewController, _ isAnimated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: isAnimated)
    }
    
    @objc func popViewController(_ isAnimated: Bool) {
        self.navigationController?.popViewController(animated: isAnimated)
    }
    
    func popToBackSteps(steps: Int) {
        guard let controllers = self.navigationController?.viewControllers else {return}
        print("12345678912356789 \(controllers.count) \(steps)")
        guard controllers.count > steps else {
            self.popViewController(true)
            return}
        let controller = controllers[controllers.count-steps-1]
        self.navigationController?.popToViewController(controller, animated: true)
    }
    
    
    @objc func popToRootViewController(_ isAnimated: Bool) {
        self.navigationController?.popToRootViewController(animated: isAnimated)
    }
    
    func share(items:[Any]) {
        DispatchQueue.main.async {
            let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
            self.present(vc, animated: true)
        }
    }
    
    @objc func back(_ button:UIButton) {
        self.popViewController(true)
    }
    
    func showAlert(message: String, title: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String, title: String?, complition:@escaping()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { ha in
            complition()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showAlert(title: String? = nil, message: String, cancel:String, ok: String, complition: @escaping()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: ok, style: .default) { ha in
            complition()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertNotification(title: String? = nil, message: String, DontAllow :String, Allow: String, complition: @escaping()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Allow, style: .default) { ha in
            complition()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Don't Allow", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
//    var currentViewController: UIViewController? {
//        if let window = Singleton.window {
//            if let menuController = window.rootViewController as? SGMenuVC {
//                if let tabCon = menuController.frontViewController as? UITabBarController {
//                    if let navCon = tabCon.selectedViewController as? UINavigationController {
//                        if let currentCon = navCon.visibleViewController {
//                            return currentCon
//                        }
//                    }
//                }
//            }
//        }
//        return nil
//    }
    
   
    
//    var tabBarController: CustomTabController? {
//        if let window = Singleton.window {
//            if let menuController = window.rootViewController as? SGMenuVC {
//                if let tabCon = menuController.frontViewController as? CustomTabController {
//                    print("tabbar con \(tabCon)")
//                    return tabCon
//                }
//            }
//        }
//        return nil
//    }
    
    func present(_ viewController:UIViewController, _ animated: Bool) {
        self.present(viewController, animated: animated, completion: nil)
    }
    
//    func getBanner(url:String?, picker:PickerData?) -> Banner {
//        let banner = Banner()
//        banner.added_on = Date().toString(format: .full1)
//        banner.modified_on = Date().toString(format: .full1)
//        banner.file_name = picker?.fileName
//        banner.url = url
//        banner.user_id = UserDefaultsCustom.getUserData()?._id
//        banner.file_size = picker?.fileSize
//        return banner
//    }
    
//    func newVersionAvailable(update: Int) {
//        let title = "New Update"
//        let message = Str.newVersionDescription
//        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        
//        let download = UIAlertAction(title: Str.download, style: .default) { d in
//            DispatchQueue.main.async {
//                if let url = URL(string: API.appStore) {
//                    UIApplication.shared.open(url)
//                }
//            }
//        }
//        controller.addAction(download)
//        if update == 1 {
//            let no = UIAlertAction(title: Str.no, style: .cancel, handler: nil)
//            controller.addAction(no)
//        }
//        self.present(controller, true)
//    }
    
}

extension UIViewController {
    
//    func makeACall(countryCode: String? = nil, phoneNo:String?) {
//        if let code = countryCode {
//            if let phone = phoneNo {
//                URL(string: "tel://\(code)\(phone)")?.open()
//            }
//        } else {
//            if let phone = phoneNo {
//                URL(string: "tel://\(phone)")?.open()
//            }
//        }
//    }
    
}

extension UIViewController {

    func showAlert(_ title: String?,
                   message: String?,
                   actions:[UIAlertAction],
                   textFields: [((UITextField) -> Void)] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            for action in actions {
                alert.addAction(action)
            }
        }
        for textField in textFields {
            alert.addTextField(configurationHandler: textField)
        }
        present(alert, animated: true)
    }
}




extension NSObject {
    
    func showMessage(message:String, isError:ERROR_TYPE) {
        Singleton.shared.showErrorMessage(error: message, isError: isError)
    }
    
    static func showMessage(message:String, isError:ERROR_TYPE) {
        Singleton.shared.showErrorMessage(error: message, isError: isError)
    }
    
    func makeACall(countryCode: String? = nil, phoneNo:String?) {
        if let code = countryCode {
            if let phone = phoneNo {
                URL(string: "tel://\(code)\(phone)")?.open()
            }
        } else {
            if let phone = phoneNo {
                URL(string: "tel://\(phone)")?.open()
            }
        }
    }
    
    func mailTo(address email: String?) {
        guard let mailId = email else { return }
        if let url = URL(string: "mailto:\(mailId)") {
            UIApplication.shared.open(url)
        }
    }
    
}

func format(with mask: String, phone: String) -> String {
    let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    var result = ""
    var index = numbers.startIndex
    for ch in mask where index < numbers.endIndex {
        if ch == "X" {
            result.append(numbers[index])
            index = numbers.index(after: index)
        } else {
            result.append(ch)
        }
    }
    return result
}
