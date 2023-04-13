//
//  PresentableController.swift
//  meetwise
//
//  Created by Amandeep on 29/12/21.
//  Copyright © 2021 hitesh. All rights reserved.
//

import UIKit

class PresentableController: UIViewController {
    
    var transitionHeight: CGFloat = 150
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.transitionHeight = self.view.frame.height/2
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    @objc func handleDismiss(sender : UIPanGestureRecognizer){
        let transfromY = sender.translation(in: view).y
        switch sender.state {
        case .changed:
            if transfromY > 0 {
                self.view.transform = CGAffineTransform(translationX: 0, y: transfromY)
            } else {
                self.view.transform = .identity
            }
        case .ended:
            if transfromY < transitionHeight {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
}

