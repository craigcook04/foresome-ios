//
//  LogoutViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 14/04/23.
//

import UIKit

class LogoutViewController: UIViewController {
    
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dismissBtn: UIButton!
    
    @IBOutlet weak var yesIAmSureBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func yesIamSureAction(_ sender: UIButton) {
    }
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
