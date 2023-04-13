//
//  CreatePollViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 05/04/23.
//

import UIKit

class CreatePollViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var addOptionBtn: UIButton!
    @IBOutlet weak var yourQuestion: GrowingTextView!
    
    @IBOutlet weak var secondOption: GrowingTextView!
    @IBOutlet weak var firstOption: GrowingTextView!
   
    var previousOptionValue: Int = 0
    var optionsFieldArray = [AdditionalOption]()
    var presenter: CreatePollPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFirstTwoOptions()
    }
    
    func setupFirstTwoOptions(){
        for i in 0...1 {
            self.addNewField(tag: i)
        }
    }
    
    func addNewField(tag:Int) {
        let view = UIView.getFromNib(className: AdditionalOption.self)
        view.optionAdd.delegate = self
        view.tag = tag
        previousOptionValue += 1
        view.optionAdd.placeholder = "Option \(previousOptionValue)"
        view.optionAdd.textColor = .black
        self.optionsStackView.addArrangedSubview(view)
        self.optionsFieldArray.append(view)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func addOptionAction(_ sender: UIButton) {
        
        for optionField in optionsFieldArray {
            if optionField.optionAdd.text.count == 0 {
                return
            }
        }
        
        self.addNewField(tag: optionsFieldArray.count)
    }
}

extension CreatePollViewController: CreatePollViewProtocol {
   
}
