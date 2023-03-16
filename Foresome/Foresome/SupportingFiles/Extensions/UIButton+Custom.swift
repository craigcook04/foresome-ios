//
//  UIButton+Custom.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 01/04/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
extension UIButton {
    
    var title:String? {
        get {
            return self.titleLabel?.text
        } set {
            self.setTitle(newValue, for: .normal)
        }
    }
    
    func setMenuButton(controller: UIViewController) {
        self.setImage(#imageLiteral(resourceName: "ic_menu"), for: .normal)
//        self.addTarget(controller.revealViewController(), action: #selector(controller.revealViewController()?.revealToggle(_:)), for: .touchUpInside)
        
        
        //self.addTarget(nil, action: #selector(controller.toggleAction(_:)), for: .touchUpInside)
        
    }
   
       func addTextSpacing(spacing: CGFloat){
           let attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
           attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: (self.titleLabel?.text?.count ?? 0)))
           self.setAttributedTitle(attributedString, for: .normal)
       }
    
    
    func setBackButton(controller: UIViewController) {
        self.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
        self.addTarget(controller, action: #selector(controller.popVC) , for: .touchUpInside)
    }
    
    
//    func setActiveButton(button:UIButton) {
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor(hexString: "#CAEDFD").cgColor
//        button.layer.shadowOpacity = 1
//        button.layer.shadowRadius = 8
//        button.layer.shadowOffset = CGSize(width: 0, height: 2)
//        button.layer.shadowColor = UIColor(hexString: "00B1FF", alpha: 0.2).cgColor
//        button.backgroundColor = UIColor(hexString: "#DCF4FF")
//    }
//    
//    func setInActiveButton(button:UIButton) {
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor(hexString: "#E0E0E0").cgColor
//        button.layer.shadowOpacity = 1
//        button.layer.shadowRadius = 8
//        button.layer.shadowOffset = CGSize(width: 0, height: 2)
//        button.backgroundColor = UIColor(hexString: "##F2F2F6")
//    }
    
    
    
    
    func setTitleWithBottomView(selected: UIColor, unselected: UIColor, selectView: UIColor, unselectView: UIColor, height:CGFloat) {
        self.subviews.forEach { (view) in
            if view.accessibilityIdentifier == "bottomLine" {
                view.removeFromSuperview()
            }
        }
        self.setTitleColor(selected, for: .selected)
        self.setTitleColor(unselected, for: .normal)
        let lineView = UIView(frame: CGRect(x: 0, y: 50, width: self.frame.size.width, height: height))
        lineView.accessibilityIdentifier = "bottomLine"
        lineView.backgroundColor =  self.isSelected ? selectView  : unselectView
        self.addSubview(lineView)
    }
    
    @IBInspectable public var imageTintColor:UIColor?  {
        set (color) {
            let img = self.imageView?.image?.renderTemplateMode
            self.setImage(img, for: state)
            self.tintColor = color
        } get {
            if let color = self.tintColor {
                return color
            } else {
                return nil
            }
        }
    }
    
    func addTarget(target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    
    var underline: Void {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func setCustomButton(title:String, titleColor:UIColor, bgColor:UIColor, font:UIFont) {
        self.layer.cornerRadius = 3.0
        self.backgroundColor = bgColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
    }
    
    func setCustomButtonWithBorder(title:String?, titleColor:UIColor, bgColor:UIColor, font: FONT_NAME, fontSize:CGFloat, roundCorner:CGFloat = 0, borderWidth:CGFloat = 0, borderColor:UIColor = UIColor.lightGray) {
        self.backgroundColor = bgColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.setCustom(font, fontSize)
        self.layer.cornerRadius = roundCorner
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func setCustomButtonFont(font: FONT_NAME, fontSize:CGFloat, roundCorner:CGFloat = 0, borderWidth:CGFloat = 0, borderColor:UIColor = UIColor.lightGray) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.setCustom(font, fontSize)
        self.layer.cornerRadius = roundCorner
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        
    }
    
    
    func setButton(title:String?, titleColor:UIColor, unselected:UIColor, bgColor:UIColor, font: FONT_NAME, fontSize:CGFloat) {
        self.backgroundColor = bgColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.setTitleColor(unselected, for: .selected)
        self.titleLabel?.font = UIFont.setCustom(font, fontSize)
    }
    
    func setTitle(selected:UIColor, unselected:UIColor) {
        self.setTitleColor(selected, for: .selected)
        self.setTitleColor(unselected, for: .normal)
    }
    
    
    func setCustomAttributedButtonWithBorder(title:NSMutableAttributedString, bgColor:UIColor, borderColor:UIColor, borderWidth:CGFloat) {
        self.setAttributedTitle(title, for: .normal)
        self.backgroundColor = bgColor
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    open func setButton(enabled isEnable:Bool) {
        self.isEnabled = isEnable
        UIView.animate(withDuration: 0.25) {
            if isEnable == true {
                self.backgroundColor = UIColor.blackishColor
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    
    func alignTextBelow(spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font as Any])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    
    func setTitleImage() {
        self.imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width), bottom: 5, right: 20)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
    }
    
    func setInsets(forContentPadding contentPadding: UIEdgeInsets, imageTitlePadding: CGFloat) {
        self.contentEdgeInsets = UIEdgeInsets(
            top: contentPadding.top,
            left: contentPadding.left,
            bottom: contentPadding.bottom,
            right: contentPadding.right + imageTitlePadding
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: imageTitlePadding,
            bottom: 0,
            right: -imageTitlePadding
        )
    }
    
    func alignImageRight() {
        if let titleLabel = self.titleLabel,let imageView = self.imageView {
            // Force the label and image to resize.
            titleLabel.sizeToFit()
            imageView.sizeToFit()
            imageView.contentMode = .scaleAspectFit
            
            // Set the insets so that the title appears to the left and the image appears to the right.
            // Make the image appear slightly off the top/bottom edges of the button.
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: 1 * imageView.frame.size.width,
                bottom: 0,
                right:imageView.frame.size.width)
            self.imageEdgeInsets = UIEdgeInsets(
                top: 4,
                left: frame.size.width-imageView.frame.size.width,
                bottom: 4,
                right: 20)
        }
    }
    
    
    
    
    func setButton(_ title:String, _ bgColor:UIColor, _ image:UIImage? = nil, _ tintColor:UIColor = .white, _ font:FONT_NAME, _ size:CGFloat, corners:CGFloat = 0) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(tintColor, for: .normal)
        self.backgroundColor = bgColor
        let img = image?.renderTemplateMode
        self.setImage(img, for: .normal)
        self.titleLabel?.font = UIFont.setCustom(font, size)
        self.tintColor = tintColor
        self.cornerRadius = corners
    }
    
    func setButtonTitle(_ title:String?, _ titleColor:UIColor, _ bgColor:UIColor,  _ font:FONT_NAME, _ size:CGFloat) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = bgColor
        self.titleLabel?.lineBreakMode = .byCharWrapping
        self.titleLabel?.font = UIFont.setCustom(font, size)
    }
    
    func setButtonSelectedUnselected(_ title:String,_ isSelected:Bool) {
        let color:UIColor = isSelected == true ? UIColor.themeColor : UIColor.placeholderColor
        self.isSelected = isSelected
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.setCustom(.OS_Light, 14)
        self.setTitleColor(color, for: .normal)
    }
    
    func setImage(_ image:UIImage?, withTint color:UIColor, for state: UIControl.State = UIControl.State.normal) {
        let img = image?.renderTemplateMode
        self.setTitle("", for: state)
        self.setImage(img, for: state)
        self.tintColor = color
    }
    
    func setButtonSelectedUnselected(_ image:UIImage,_ isSelected:Bool) {
        let img = image.renderTemplateMode
        self.isSelected = isSelected
        self.setTitle("", for: .normal)
        self.setImage(img, for: .normal)
    }
    
    func setButtonTitleImage(left:CGFloat, right:CGFloat, image:UIImage) {
        self.contentHorizontalAlignment = .left
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
        let width = self.frame.size.width
        self.setImage(right: right, image: image, width: width)
    }
    
    func setImage(right:CGFloat, image:UIImage, width:CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        self.addSubview(imageView)
        let xPoint = (width-right) - (image.size.width/2)
        let yPoint = frame.height/2
        imageView.center = CGPoint(x: xPoint, y: yPoint)
        
    }
 
    
    open func setNotificationLabel() {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        let isNotifications = UserDefaultsCustom.notifications == 0
//        let img:UIImage = isNotifications ? #imageLiteral(resourceName: "ic_notification") : #imageLiteral(resourceName: "ic_notification_active")
//        self.setImage(img, for: .normal)
//        self.subviews.forEach { view in
//            if let label = view as? UILabel {
//                if (label.text?.count ?? 0) > 0 {
//                    print("tag remove cart button")
//                    view.removeFromSuperview()
//                }
//            }
//        }
//        let notifications = UserDefaultsCustom.notifications
//        if notifications != 0 {
//            let label = UILabel(frame: CGRect(x: 15, y: 3, width: 20, height: 14))
//            let txt = notifications > 9 ? "9+" : "\(notifications)"
//            label.setLabel("\(txt)", .white, .OS_Regular, 10)
//            label.backgroundColor = .systemRed
//            label.textAlignment = .center
//            label.cornerRadius = 5.0
//            label.borderColor = .ic_blueBlue
//            label.borderWidth = 2
//            self.addSubview(label)
//            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
//        } else {
//            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
    }
    
    
}

extension UISegmentedControl {
    
    
    func setSegmentStateTitles(titles: [String], font: FONT_NAME, size: CGFloat) {
        for (index, title) in titles.enumerated(){
            let font = UIFont.setCustom(font, size)
            self.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
            self.setTitle(title, forSegmentAt: index)
        }
        
    }
}


// MARK: - BUTTON USE IN APP

extension UIButton{
    func setButtonState(isActive:Bool){
        if isActive == false{
            self.backgroundColor = UIColor(hexString: "#E5E5E5")
            self.shadowColor = UIColor(hexString: "#CCCCCC",alpha: 0.5)
//            self.titleLabel?.textColor = UIColor(hexString: "#A9A9A9")
            self.shadowOffset = CGSize(width: 0, height: 2)
            self.shadowRadius = 8
            self.shadowOptacity = 1.0
            self.isUserInteractionEnabled = false
        } else {
            self.backgroundColor = UIColor.appColor(.themeYellow)
//            self.titleLabel?.textColor = UIColor.white
            self.shadowColor = UIColor(hexString: "#FB2193",alpha: 0.3)
            self.shadowOffset = CGSize(width: 0, height: 2)
            self.shadowRadius = 8
            self.shadowOptacity = 1.0
            self.isUserInteractionEnabled = true
        }
    }
    
    func setSelectedGenderBtn(){
        self.borderWidth = 1
        self.backgroundColor = UIColor(hexString: "#DCF4FF")
        self.borderColor = UIColor(hexString: "#CAEDFD")
        self.shadowColor = UIColor(hexString: "#00B1FF", alpha: 0.2)
        self.shadowOffset = CGSize(width: 0, height: 2)
        self.shadowRadius = 8
        self.shadowOptacity = 1.0
    }
    
    func setUnSelectedGenderBtn(){
        self.borderWidth = 1
        self.backgroundColor = UIColor(hexString: "#FFFFFF")
        self.borderColor = UIColor(hexString: "#CCCCCC")
        self.shadowColor = UIColor(hexString: "#00B1FF", alpha: 0.2)
        self.shadowOffset = CGSize(width: 0, height: 2)
        self.shadowRadius = 8
        self.shadowOptacity = 0.0
    }
}
