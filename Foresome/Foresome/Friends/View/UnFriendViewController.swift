//
//  UnFriendViewController.swift
//  Foresome
//
//  Created by Deepanshu on 08/06/23.
//

import UIKit

class UnFriendViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var unfriendDescription: UILabel!
    @IBOutlet weak var dismissView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapToDismiss()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.dismissView.transform = CGAffineTransform.identity
        }
    }
    
    //MARK: code for add atp guesture for dismiss view on tap any part of top view-------
    func tapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissController))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    //MARK: code for dismiss view on tap any part of top view-------
    @objc func dismissController() {
        UIView.animate(withDuration: 0.3) {
            self.dismissView.transform = CGAffineTransform(translationX: 0, y: self.dismissView.frame.height)
        } completion: { isSucceed in
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        print("make unfriend request.")
        Singleton.shared.showMessage(message: "Unfriends successfully.", isError: .success)
        UIView.animate(withDuration: 0.3) {
            self.dismissView.transform = CGAffineTransform(translationX: 0, y: self.dismissView.frame.height)
        } completion: { isSucceed in
            self.dismiss(animated: false)
        }
    }
}

