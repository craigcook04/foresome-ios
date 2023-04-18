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
        yourQuestion.autocorrectionType = .no
        secondOption.autocorrectionType = .no
        firstOption.autocorrectionType = .no
        yourQuestion.delegate = self
        secondOption.delegate = self
        firstOption.delegate = self
        self.setupFirstTwoOptions()
    }
    
    func setupFirstTwoOptions() {
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
        if optionsFieldArray.count > 3 {
            self.addOptionBtn.isHidden = true
        } else {
            self.addOptionBtn.isHidden = false
        }
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
    
    @IBAction func createPostAction(_ sender: UIButton) {
        if ((optionsFieldArray.first?.optionAdd.text.count ?? 0) < 1) && ((optionsFieldArray[1].optionAdd.text.count ) < 1) {
            Singleton.shared.showMessage(message: "Options not allowed to be empty.", isError: .error)
        } else {
            self.presenter?.createNewPoll(questioName: "\(self.yourQuestion.text ?? "")", optionsArray: optionsFieldArray)
        }
    }
}

extension CreatePollViewController: CreatePollViewProtocol {
    
}

extension CreatePollViewController: GrowingTextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
        print("updated text is equal to -==\(updatedString)")
        print("text view tag value is -===\(textView.tag)")
        if updatedString?.count ?? 0 > 0 {
            print("enable called.")
        } else {
            print("disable called.")
        }
        return true
    }
}
