//
//  BottomResultView.swift
//  meetwise
//
//  Created by hitesh on 23/11/20.
//  Copyright © 2020 hitesh. All rights reserved.
//

import UIKit

open class BottomResultView: UIView {

    //MARK: - Additional Views
    let label = UILabel()
    let selectButton = UIButton(type: .custom)
    let cancelButton = UIButton(type: .custom)
    let stackView = UIStackView()
    
    private var didCancel:(()->())?
    private var didSelect:((LocationItem?)->())?
    
    
    var locationItem: LocationItem? {
        didSet {
            self.label.text = locationItem?.formattedAddressString
        }
    }
    
    //MARK: - result settings
    var resultText:String? {
        didSet {
            self.label.text = resultText
        }
    }
    var resultTextColor:UIColor = .textColor {
        didSet {
            self.label.textColor = resultTextColor
        }
    }
    var textSize:CGFloat = 16
//    var resultFont: UIFont = UIFont(.rubik_Regular, 14) ?? UIFont.systemFont(ofSize: 14) {
//        didSet {
//            label.font = resultFont
//        }
//    }
    
    //MARK: - Button settings
    var buttonTitle:String = "Select Location" {
        didSet {
            setButton()
        }
    }
//    var buttonFont: UIFont = UIFont(.rubik_Regular, 14) ?? UIFont.systemFont(ofSize: 14) {
//        didSet {
//            setButton()
//        }
//    }
    var buttonBackgroundColor: UIColor = .textColor {
        didSet {
            setButton()
        }
    }
    var buttonTitleColor: UIColor = .white {
        didSet {
            setButton()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setView()
        self.setButton()
    }
    
    func setButton() {
        self.selectButton.setTitle(buttonTitle, for: .normal)
        self.selectButton.setTitleColor(buttonTitleColor, for: .normal)
        self.selectButton.backgroundColor = buttonBackgroundColor
     //   self.selectButton.titleLabel?.font = buttonFont
        self.selectButton.cornerRadius = 7.0
        
        self.backgroundColor = .white
        self.cornerRadius = 7.0
        
        self.cancelButton.setTitle("Cancel", for: .normal)
        self.cancelButton.setTitleColor(.textColor, for: .normal)
        self.cancelButton.backgroundColor = .clear
//        self.cancelButton.titleLabel?.font = buttonFont
        
    }
    
    
    func setView() {
        label.numberOfLines = 3
        label.textAlignment = .center
        addSubview(label)
        addSubview(stackView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelConstraints = [
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ]
        
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            selectButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(labelConstraints + stackViewConstraints)
        
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 10

        stackView.addArrangedSubview(selectButton)
        stackView.addArrangedSubview(cancelButton)
        
        selectButton.addTarget(self, action: #selector(didSelect(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didCancel(_:)), for: .touchUpInside)
        
    }
    
    @objc private func didSelect(_ button:UIButton) {
        didSelect?(locationItem)
    }
    
    @objc private func didCancel(_ button:UIButton) {
        didCancel?()
    }
    
    open func callBacks(didSelect:((LocationItem?)->())?, didCancel:(()->())?) {
        self.didSelect = didSelect
        self.didCancel = didCancel
    }
}
