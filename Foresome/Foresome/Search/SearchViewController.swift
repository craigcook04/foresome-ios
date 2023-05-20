//
//  SearchViewController.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        print("back called")
        self.popVC()
    }
     
}
