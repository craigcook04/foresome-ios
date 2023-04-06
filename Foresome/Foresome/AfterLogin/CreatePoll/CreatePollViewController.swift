//
//  CreatePollViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 05/04/23.
//

import UIKit

class CreatePollViewController: UIViewController {
    
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var addOptionBtn: UIButton!
    @IBOutlet weak var yourQuestion: GrowingTextView!
    @IBOutlet weak var secondOption: GrowingTextView!
    @IBOutlet weak var firstOption: GrowingTextView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
}

