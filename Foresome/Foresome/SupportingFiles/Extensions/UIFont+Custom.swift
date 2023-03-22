//
//  UIFont.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 31/03/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import Foundation
import UIKit

enum FONT_NAME: String {
    case OS_ExtraBoldItalic = "OpenSans-ExtraBoldItalic"
    case OS_ExtraBold = "OpenSans-ExtraBold"
    case OS_BoldItalic = "OpenSans-BoldItalic"
    case OS_Bold = "OpenSans-Bold"
    case OS_SemiboldItalic = "OpenSans-SemiboldItalic"
    case OS_Semibold = "OpenSans-Semibold"
    case OS_Italic = "OpenSans-Italic"
    case OS_Regular = "OpenSans-Regular"
    case OS_LightItalic = "OpenSans-LightItalic"
    case OS_Light = "OpenSans-Light"
    
    case SSP_BlackIt = "SourceSansPro-BlackIt"
    case SSP_Black = "SourceSansPro-Black"
    case SSP_BoldIt = "SourceSansPro-BoldIt"
    case SSP_Bold = "SourceSansPro-Bold"
    case SSP_SemiboldIt = "SourceSansPro-SemiboldIt"
    case SSP_Semibold = "SourceSansPro-Semibold"
    case SSP_It = "SourceSansPro-It"
    case SSP_Regular = "SourceSansPro-Regular"
    case SSP_LightIt = "SourceSansPro-LightIt"
    case SSP_Light = "SourceSansPro-Light"
    case SSP_ExtraLightIt = "SourceSansPro-ExtraLightIt"
    case SSP_ExtraLight = "SourceSansPro-ExtraLight"
    case poppinsMedium = "Poppins-Medium"
    
//MARK:-    version 2 Fonts
    case latoThinItalic = "Lato-ThinItalic"
    case latoThin = "Lato-Thin"
    case latoSemiboldItalic = "Lato-SemiboldItalic"
    case latoSemibold = "Lato-Semibold"
    case latoRegular = "Lato-Regular"
    case latoMediumItalic = "Lato-MediumItalic"
    case latoMedium = "Lato-Medium"
    case latoLightItalic = "Lato-LightItalic"
    case latoLight = "Lato-Light"
    case latoItalic = "Lato-Italic"
    case latoHeavyItalic = "Lato-HeavyItalic"
    case latoHeavy = "Lato-Heavy"
    case latoHairlineItalic = "Lato-HairlineItalic"
    case latoHairline = "Lato-Hairline"
    case latoBoldItalic = "Lato-BoldItalic"
    case latoBold = "Lato-Bold"
    case latoBlackItalic = "Lato-BlackItalic"
    case latoBlack = "Lato-Black"
    
    // ONBOARDING
    case sf_ProDisplay_Semibold = "SF-Pro-Display-Semibold"
    case sf_ProDisplay_bold = "SF-Pro-Display-Bold"
    case SFProDisplay_Regular = "SFProDisplay-Regular"
    case SFProDisplay_Medium = "SFProDisplay-Medium"
    case SFProDisplay_Heavy = "SFProDisplay-Heavy"
    case SFProDisplay_Semibold = "SFProDisplay-Semibold"
    case SFProDisplay_Bold = "SFProDisplay-Bold"
    
    //SF Pro Text
    case SFProText_Regular = "SFProText-Regular"
    case SFProText_Medium = "SFProText-Medium"
    case SFProText_Semibold = "SFProText-Semibold"
    case SFProText_Bold = "SFProText-Bold"
    
    // SF UI Text
    case SFUIText_Regular = "SFUIText-Regular"
    case SFUIText_Medium = "SFUIText-Medium"
    case SFUIText_Bold = "SFUIText-Bold"
    
    // Font Awesome
//    case SFUIText_Regular = "SFUIText-Regular"
//    case SFUIText_Medium = "SFUIText-Medium"
//    case SFUIText_Bold = "SFUIText-Bold"
    
    // Font Awesome
    
    case fontAwesome5ProSolid = "FontAwesome5ProSolid"
    case fontAwesome = "FontAwesome"
  
}


extension UIFont {
    
    static func setDynamicFont(_ fontName:FONT_NAME,_ minSize:CGFloat)  -> UIFont {
        let deviceType = UIDevice.current.deviceType
        switch deviceType {
        case .iPhone4_4S:
            return UIFont.setCustom(fontName, minSize)
        case .iPhones_5_5s_5c_SE:
            return UIFont.setCustom(fontName, minSize)
            
        case .iPhones_6_6s_7_8:
            return UIFont.setCustom(fontName, minSize + 2)
            
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            return UIFont.setCustom(fontName, minSize + 4)
            
        case .iPhoneX:
            return UIFont.setCustom(fontName, minSize + 6)
            
        default:
            return UIFont.setCustom(fontName, minSize + 6)

        }
    }
    
    
    static func setCustom(_ font: FONT_NAME, _ size:CGFloat) -> UIFont {
        if let font = UIFont(name: font.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    convenience init?(_ font: FONT_NAME, _ size:CGFloat) {
        self.init(name: font.rawValue, size: size)
    }
    
   public class func fontFamilies() {
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
    
    
}



extension CAGradientLayer {
    public convenience init(frame:CGRect, colours: [UIColor], locations: [NSNumber]) {
        self.init(layer:frame)
        self.frame = self.bounds
        self.colors = colours.map { $0.cgColor }
        self.locations = locations
        self.name = "gradientLayer"
        self.startPoint = CGPoint(x: 0.0, y: 0.5)
        self.endPoint = CGPoint(x: 1.5, y: 0.5)//CGPointMake(1.0, 0.5)
    }
}


extension UIBezierPath {
    /// The Unwrap logo as a Bezier path.
    static var logo: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.534, y: 0.5816))
        path.addCurve(to: CGPoint(x: 0.1877, y: 0.088), controlPoint1: CGPoint(x: 0.534, y: 0.5816), controlPoint2: CGPoint(x: 0.2529, y: 0.4205))
        path.addCurve(to: CGPoint(x: 0.9728, y: 0.8259), controlPoint1: CGPoint(x: 0.4922, y: 0.4949), controlPoint2: CGPoint(x: 1.0968, y: 0.4148))
        path.addCurve(to: CGPoint(x: 0.0397, y: 0.5431), controlPoint1: CGPoint(x: 0.7118, y: 0.5248), controlPoint2: CGPoint(x: 0.3329, y: 0.7442))
        path.addCurve(to: CGPoint(x: 0.6211, y: 0.0279), controlPoint1: CGPoint(x: 0.508, y: 1.1956), controlPoint2: CGPoint(x: 1.3042, y: 0.5345))
        path.addCurve(to: CGPoint(x: 0.6904, y: 0.3615), controlPoint1: CGPoint(x: 0.7282, y: 0.2481), controlPoint2: CGPoint(x: 0.6904, y: 0.3615))
        return path
    }
}

