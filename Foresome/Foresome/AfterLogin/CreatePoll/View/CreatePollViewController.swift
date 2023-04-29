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
    @IBOutlet weak var questionCharLimits: UILabel!
    @IBOutlet weak var firstOptionCountLimt: UILabel!
    @IBOutlet weak var secondsOptionLimit: UILabel!
    
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
        view.optionAdd.tag = tag
        view.characterCountLabel.tag = tag
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
                Singleton.shared.showMessage(message: "please fill above option first.", isError: .error)
                return
            }
        }
        self.addNewField(tag: optionsFieldArray.count)
    }
    
    @IBAction func createPostAction(_ sender: UIButton) {
        if self.yourQuestion.text.count < 1 {
            Singleton.shared.showMessage(message: "Please ask a question.", isError: .error)
            return
        }
        
        for i in 0..<optionsFieldArray.count {
            guard optionsFieldArray[i].optionAdd.text.count > 0 else {
                Singleton.shared.showMessage(message: "Options not allowed to be empty.", isError: .error)
                return
            }
        }
        self.presenter?.createNewPoll(questioName: "\(self.yourQuestion.text ?? "")", optionsArray: self.optionsFieldArray)
    }
}

extension CreatePollViewController: CreatePollViewProtocol {
    
}

extension CreatePollViewController: GrowingTextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
        if updatedString == " "{
            return false
        } else {
            if textView.tag == 0 {
                if updatedString?.count ?? 0 <= 30 {
                    optionsFieldArray[0].characterCountLabel.text = "\(updatedString?.count ?? 0)/30"
                }
            } else if textView.tag == 1 {
                if updatedString?.count ?? 0 <= 30 {
                    optionsFieldArray[1].characterCountLabel.text = "\(updatedString?.count ?? 0)/30"
                }
            } else if textView.tag  == 2 {
                if updatedString?.count ?? 0 <= 30 {
                    optionsFieldArray[2].characterCountLabel.text = "\(updatedString?.count ?? 0)/30"
                }
            } else if textView.tag == 3 {
                if updatedString?.count ?? 0 <= 30 {
                    optionsFieldArray[3].characterCountLabel.text = "\(updatedString?.count ?? 0)/30"
                }
            } else {
                if updatedString?.count ?? 0 <= 150 {
                    self.questionCharLimits.text = "\(updatedString?.count ?? 0)/150"
                }
            }
            return true
        }
    }
}
