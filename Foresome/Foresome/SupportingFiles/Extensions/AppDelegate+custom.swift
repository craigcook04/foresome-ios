//
//  AppDelegate+custom.swift
//  EGame
//
//  Created by apple on 13/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
//import FirebaseMessaging




//MARK: SET NOTIFICATION
extension AppDelegate {
    func setNotification(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        UNUserNotificationCenter.current().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
//        Messaging.messaging().delegate = self
//        let tabbarController = self.window?.rootViewController as? UITabBarController
////        if count > 0 {
//            if let tabItems = tabbarController?.tabBar.items {
//                tabItems[0].badgeColor = .red
//                tabItems[0].badgeValue = "\(1)"
//            }
////        } else {
    }
    
    func setBgNotification(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//        let token = deviceToken.reduce("") { $0 + String(format: "%02.2hhx", $1) }
//        print("registered for notifications", token)
//        print(Messaging.messaging().fcmToken)
//        print("\(UserDefaultsCustom.getDeviceToken())")
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    //MARK: - Background Fetch Result
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
//        UIApplication.shared.applicationIconBadgeNumber = 1
//        return .newData
//    }
    
    
    //MARK: - Forground push notification
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          
//        let actionButton = UNNotificationAction(identifier: "TapToReadAction", title: "Tap to read", options: .foreground)
//        let notificationCategory = UNNotificationCategory(identifier: "alarm", actions: [actionButton,deleteButton], intentIdentifiers: [])
//        UNUserNotificationCenter.current().setNotificationCategories([notificationCategory])
        completionHandler( [.alert, .badge, .sound])
    }
    
    //MARK: Background push notification Receive
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
//    //MARK: Forground push notification handle
//    func handleTap(_onForgroundNotification pushData: PushModel, controller:UIViewController) {
//
//    }
//
//    //MARK: Background push notification
//    func handleTap(_onBackgroundController pushData: PushModel) {
//
//    }
}

//MARK: FCM TOKEN
//extension AppDelegate: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(fcmToken)")
//    }
//}
