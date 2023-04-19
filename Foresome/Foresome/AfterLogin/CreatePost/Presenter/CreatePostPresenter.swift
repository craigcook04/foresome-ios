//
//  CreatePostPresenter.swift
//  Foresome
//
//  Created by Piyush Kumar on 05/04/23.
//

import Foundation
import UIKit

class CreatePostPresenter: CreatePostPresenterProtocol {
 

  var view: CreatePostViewProtocol?
    
    static func createPostModule() -> UIViewController {
        let view = CreatePostViewController()
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
}
