//
//  CreatePollViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 05/04/23.
//

import UIKit

class CreatePollViewController: UIViewController {
    
    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var addOptionBtn: UIButton!
    @IBOutlet weak var yourQuestion: GrowingTextView!
    @IBOutlet weak var secondOption: GrowingTextView!
    @IBOutlet weak var firstOption: GrowingTextView!
    
    var previousOptionValue: Int = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func addOptionAction(_ sender: UIButton) {
        
        if (firstOption.text.count > 0) && (secondOption.text.count > 0) {
            let view = UIView.getFromNib(className: AdditionalOption.self)
            previousOptionValue += 1
           view.optionAdd.placeholder = "option\(previousOptionValue)"
            self.optionsStackView.addArrangedSubview(view)
        } else {
            self.addOptionBtn.isEnabled = false
        }
        self.addOptionBtn.isEnabled = true
    }
}

    
   
