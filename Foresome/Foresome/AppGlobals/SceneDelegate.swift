//
//  SceneDelegate.swift
//  Foresome
//
//  Created by Piyush Kumar on 16/03/23.
//

import UIKit
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private(set) static var shared: SceneDelegate!

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Self.shared = self
        FirebaseApp.configure()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        Singleton.shared.window = self.window
        if ((UserDefaults.standard.value(forKey: "user_uid") as? String)?.count ?? 0) > 0 {
            Singleton.shared.setHomeScreenView()
        } else {
            Singleton.shared.gotoLogin()
        }
        
       // var handle: AuthStateDidChangeListenerHandle?
//         handle = Auth.auth().addStateDidChangeListener { (auth, user) in
////             auth.currentUser
////             auth.app?.name
////             auth.currentUser?.displayName
////             auth.currentUser?.uid
////             auth.currentUser?.displayName
////             auth.currentUser?.metadata
//                if((user) != nil) {
//                    Singleton.shared.setHomeScreenView()
//                } else if ((user) == nil) {
//                    Singleton.shared.gotoLogin()
//                }
//            }
//        if Auth.auth().currentUser  == nil {
//            Singleton.shared.gotoLogin()
//        } else {
//            Singleton.shared.setHomeScreenView()
//        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

