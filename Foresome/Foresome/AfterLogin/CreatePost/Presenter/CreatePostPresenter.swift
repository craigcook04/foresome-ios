//
//  CreatePostPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 05/04/23.
//

import Foundation
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

class CreatePostPresenter: CreatePostPresenterProtocol {
    
    var view: CreatePostViewProtocol?
    
    static func createPostModule(delegate:CreatePostUploadDelegate?, selectedImage: [UIImage?]?) -> UIViewController {
        let view = CreatePostViewController()
        view.delegate = delegate
        view.imageSelect = selectedImage ?? []
        var presenter: CreatePostPresenterProtocol = CreatePostPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func photoButtonAction() {
        self.view?.receiveResult()
    }
    
    func cameraButtonAction() {
        self.view?.cameraReceiveResult()
    }
    
    func createNewPost() {
        print("create new post function called.")
    }
    
    func createPost(data: CreatePostModel) {
        if let currentView = self.view as? CreatePostViewController {
        }
    }
    
    func uploadMultileImage(images: UIImage) {
        
    }
}

//MARK: extension of add complition handler in pop and push of a controller ----
extension UINavigationController {
    private func doAfterAnimatingTransition(animated: Bool, completion: @escaping (() -> Void)) {
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil, completion: { _ in
                completion()
            })
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping (() ->     Void)) {
        pushViewController(viewController, animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool, completion: @escaping (() -> Void)) {
        popViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popToRootViewController(animated: Bool, completion: @escaping (() -> Void)) {
        popToRootViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
}
