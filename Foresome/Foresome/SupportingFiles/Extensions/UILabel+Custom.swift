//
//  UILabel+Custom.swift
//  DigitalMenu
//
//  Created by apple on 04/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

extension UILabel {
    
    // Mark:- UiLabel fond acc to device size
    func setFont(_ fontName:FONT_NAME,_ minSize:CGFloat){
        let deviceType = UIDevice.current.deviceType
        switch deviceType {
        case .iPhone4_4S:
            self.font = UIFont.setCustom(fontName, minSize)
        case .iPhones_5_5s_5c_SE:
            self.font = UIFont.setCustom(fontName, minSize + 2)
            
        case .iPhones_6_6s_7_8:
            self.font = UIFont.setCustom(fontName, minSize + 4)
            
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            self.font = UIFont.setCustom(fontName, minSize + 6)
            
        case .iPhoneX:
            self.font = UIFont.setCustom(fontName, minSize + 8)
            
        default:
            self.font = UIFont.setCustom(fontName, minSize + 8)

        }
    }
    
    func setTextSize(_ size:CGFloat) {
        self.font = self.font.withSize(size)
    }
    
    //MARK:- out line
    func makeOutLine(oulineColor: UIColor, foregroundColor: UIColor) {
        let strokeTextAttributes = [
        NSAttributedString.Key.strokeColor : oulineColor,
        NSAttributedString.Key.foregroundColor : foregroundColor,
        NSAttributedString.Key.strokeWidth : -4.0,
        NSAttributedString.Key.font : font ?? UIFont.systemFontSize
        ] as [NSAttributedString.Key : Any]
        self.attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
    }
    
    //MARK:- unser line
    var underline: Void {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                             value: NSUnderlineStyle.single.rawValue,
                                             range: NSRange(location: 0,
                                                            length: attributedString.length))
            attributedText = attributedString
        }
    }
    
    func drawLineOnBothSides(labelWidth: CGFloat, color: UIColor) {

        let fontAttributes = [NSAttributedString.Key.font: self.font]
        let size = self.text?.size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        let widthOfString = size!.width

        let width = CGFloat(1)

        let leftLine = UIView(frame: CGRect(x: 0, y: self.frame.height/2 - width/2, width: labelWidth/2 - widthOfString/2 - 10, height: width))
        leftLine.backgroundColor = color
        self.addSubview(leftLine)

        let rightLine = UIView(frame: CGRect(x: labelWidth/2 + widthOfString/2 + 10, y: self.frame.height/2 - width/2, width: labelWidth/2 - widthOfString/2 - 10, height: width))
        rightLine.backgroundColor = color
        self.addSubview(rightLine)
    }
    
    
    
    func setAttributed(str1:String, font1:UIFont?, color1:UIColor, str2:String, font2:UIFont?, color2:UIColor)  {
        
        let attributed = NSMutableAttributedString(string: str1, attributes: [
        .font: font1 ?? UIFont(), .foregroundColor: color1])
        
        let attributed2 = NSMutableAttributedString(string: str2, attributes: [
        .font: font2 ?? UIFont(), .foregroundColor: color2])
        
        let attributedStirng = NSMutableAttributedString(attributedString: attributed)
        attributedStirng.append(attributed2)
        
        self.attributedText = attributedStirng
    }
    func setAttributedUpToThree(str1:String, font1:UIFont?, color1:UIColor, str2:String, font2:UIFont?, color2:UIColor,str3:String, font3:UIFont?, color3:UIColor)  {
        
        let attributed = NSMutableAttributedString(string: str1, attributes: [
        .font: font1 ?? UIFont(), .foregroundColor: color1])
        
        let attributed2 = NSMutableAttributedString(string: str2, attributes: [
        .font: font2 ?? UIFont(), .foregroundColor: color2])
        
        let attributed3 = NSMutableAttributedString(string: str3, attributes: [
        .font: font3 ?? UIFont(), .foregroundColor: color3])
        
        let attributedStirng = NSMutableAttributedString(attributedString: attributed)
        attributedStirng.append(attributed2)
        attributedStirng.append(attributed3)
        self.attributedText = attributedStirng
    }
    
    
    func setAttributedForFourText(str1:String, font1:UIFont?,  color1:UIColor, str2:String, font2:UIFont?,  color2:UIColor, str3:String, font3:UIFont?,  color3:UIColor, str4:String, font4:UIFont?,  color4:UIColor, str5:String, font5:UIFont?,  color5:UIColor ) {
        
        let attributed1 = NSMutableAttributedString(string: str1, attributes: [
        .font: font1 ?? UIFont(), .foregroundColor: color1])
        
        let attributed2 = NSMutableAttributedString(string: str2, attributes: [
        .font: font2 ?? UIFont(), .foregroundColor: color2])
        
        let attributed3 = NSMutableAttributedString(string: str3, attributes: [
        .font: font3 ?? UIFont(), .foregroundColor: color3])
        
        let attributed4 = NSMutableAttributedString(string: str4, attributes: [
        .font: font4 ?? UIFont(), .foregroundColor: color4])
        
        let attributed5 = NSMutableAttributedString(string: str5, attributes: [
        .font: font5 ?? UIFont(), .foregroundColor: color5])
        
        
        let attributedStirng1 = NSMutableAttributedString(attributedString: attributed1)
        attributedStirng1.append(attributed2)
        attributedStirng1.append(attributed3)
        attributedStirng1.append(attributed4)
        attributedStirng1.append(attributed5)
         
        self.attributedText = attributedStirng1
    
    }
    
    func setLabel(_ text:String?, _ color:UIColor?, _ font:FONT_NAME, _ size: CGFloat) {
        self.textColor = color ?? UIColor.black
        self.text = text
        self.font = UIFont.setCustom(font, size)
    }
    
    func centerLine() {
        let text = self.text?.strikeThrough
        self.attributedText = text
    }
    
    func setAttributedLabel(_ title: String?,_ value: String?, _ font:FONT_NAME, _ size: CGFloat) {
        self.font = UIFont.setCustom(font, size)
        let mutable = NSMutableAttributedString(string: title ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholderColor])
        let value = NSAttributedString(string: value ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.textColor])
        mutable.append(value)
        self.attributedText = mutable
    }
    
    func setCommentLabel(title: String?, value: String?) {
        let mutable = NSMutableAttributedString(string: "\(title ?? "") ", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.placeholderColor,
            NSAttributedString.Key.font : UIFont.setCustom(.OS_Semibold, 14)
        ])
        let value = NSAttributedString(string: value ?? "", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.textColor,
            NSAttributedString.Key.font : UIFont.setCustom(.OS_Semibold, 13)
        ])
        mutable.append(value)
        self.attributedText = mutable
    }
    
    func setMediumFont(_ text:String, _ textColor:UIColor) {
        self.setLabel(text, textColor, .OS_Light, 15)
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0, textAlignment: NSTextAlignment = .natural) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = textAlignment
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
    func addTextSpacing(spacing: CGFloat){
            let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: self.text?.count ?? 0))
            self.attributedText = attributedString
        }
    
    func attributedTextWithMultipleRange(str:String,color1:UIColor? = .white, font1:UIFont? = .systemFont(ofSize: 13),color2:UIColor? = .white, font2:UIFont? = .systemFont(ofSize: 13) , highlightedWords: [String],alignment:NSTextAlignment = .center, isUnderLine:Bool = false){
            let attributedString = NSMutableAttributedString(string: str)
            attributedString.addAttribute(NSAttributedString.Key.font, value: font1 ?? .systemFont(ofSize: 13), range: NSRange(location:0, length: str.count))
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color1 ?? .white, range: NSRange(location:0, length: str.count))
                
            for highlightedWord in highlightedWords {
                let textRange = (str as NSString).range(of: highlightedWord)

                attributedString.addAttribute(NSAttributedString.Key.font, value: font2 ?? .systemFont(ofSize: 13), range: textRange)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color2 ?? .white, range: textRange)
                if isUnderLine{
                    attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                                     value: NSUnderlineStyle.single.rawValue,
                                                     range: textRange)
                }
            }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            paragraphStyle.alignment = alignment
            
            attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            self.attributedText = attributedString
            self.sizeToFit()
        }
    
    
    
    }

