//
//  VariationViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 28/03/23.
//

import UIKit
protocol VariationViewControllerDelegate {
    func playerCount(text: String)
}

class VariationViewController: UIViewController {
    
    @IBOutlet weak var foresomeBtn: UIButton!
    @IBOutlet weak var singlePlayerBtn: UIButton!
    var delegate: VariationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func singlePlayerAction(_ sender: Any) {
        self.delegate?.playerCount(text: "Single Player")
        self.dismiss(animated: false)
        
    }
    
    @IBAction func foursomeAction(_ sender: Any) {
        self.delegate?.playerCount(text: "Foresome")
        self.dismiss(animated: false)
    }
    
}
