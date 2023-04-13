//
//  UIColor.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 30/03/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }

    
    public convenience init(rgb: [CGFloat]) {
        let r = rgb[0]
        let g = rgb[1]
        let b = rgb[2]
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    
    
    open class var themeConstrast:UIColor {
        return UIColor.white
    }
    
    open class var navigationColor:UIColor {
        return UIColor(r: 42, g: 56, b: 72, a: 1)
    }
    
    open class var placeholderColor:UIColor {
        return UIColor.init(r: 183, g: 189, b: 194, a: 1)
    }
    
    open class var transColor:UIColor {
        return UIColor.init(r: 0, g: 0, b: 0, a: 0.4)
    }
    
    open class var errorColor:UIColor {
        return UIColor.init(r: 226, g: 87, b: 76, a: 1)
    }
    
    open class var successColor:UIColor {
        return UIColor.init(r: 102, g: 208, b: 42, a: 1)
    }
 
    open class var messageColor:UIColor {
        return UIColor.init(r: 0, g: 0, b: 0, a: 0.9)
    }
    
    open class var textColor:UIColor {
        return UIColor.init(r: 23, g: 23, b: 23, a: 1.0)
    }
    
    open class var themeColor:UIColor {
        return UIColor.init(r: 0, g: 0, b: 0, a: 0.9)
    }
    
    
    open class var profileDetailsHeaderColor:UIColor {
        return UIColor.init(r: 57, g: 74, b: 103, a: 1.0)
    }
    
    open class var customGrayColor:UIColor {
        return UIColor.init(r: 148, g: 155, b: 173, a: 1.0)
    }
    
    open class var presentationBgColor:UIColor {
        return UIColor.init(r: 0, g: 0, b: 0, a: 0.5)
    }
      
    
    // custom button color
    
    open class var blackishColor:UIColor {
        return UIColor(rgb: [51, 51, 51])
    }
    
    open class var fbButtonBgColor:UIColor {
        return UIColor(rgb: [60, 102, 196])
    }
    
    open class var limeGreenColor:UIColor {
        return UIColor(rgb: [63, 196, 60])
    }
    
    open class var grayColor:UIColor {
        return UIColor(rgb: [151, 151, 151])
    }
    
    open class var customLightGrayColor:UIColor {
        return UIColor(rgb: [238, 238, 238]).withAlphaComponent(0.5)
    }
    
    open class var lightOranageColor:UIColor {
        return UIColor(rgb: [255, 177, 60])
    }
    
    open class var lightBlackColor:UIColor {
        return UIColor(rgb: 0x333333)
    }
    
    open class var backgroundColor:UIColor {
        return UIColor(rgb: 0xF4F4F4)
    }
    
    open class var customOrangeColor:UIColor {
        return UIColor(rgb: 0xFFB13C)
    }
    
    open class var sellerProductColor:UIColor {
        return UIColor(rgb: 0x3C9BC4)
    }
    
    open class var newBlueColor:UIColor {
        return UIColor(rgb: 0x3C66C4)
    }
    
    open class var gray700Color:UIColor {
        return UIColor(rgb: 0x616161)
    }
    
    open class var graySolidColor:UIColor {
        return UIColor(rgb: 0xDADADA)
    }
    
    
    //MARK:- MEETWISE COLORS
    @nonobjc class var lightPurpleyBlue: UIColor {
        return UIColor(red: 231.0 / 255.0, green: 225.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var whiteWithAlpha: UIColor {
      return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.5)
    }

    @nonobjc class var blueBlue: UIColor {
      return UIColor(red: 36.0 / 255.0, green: 95.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var aquaBlue: UIColor {
      return UIColor(red: 38.0 / 255.0, green: 198.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var blueGrey: UIColor {
      return UIColor(red: 124.0 / 255.0, green: 135.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var lightishRed: UIColor {
      return UIColor(red: 251.0 / 255.0, green: 52.0 / 255.0, blue: 83.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var purpleyBlue: UIColor {
      return UIColor(red: 92.0 / 255.0, green: 55.0 / 255.0, blue: 231.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var greenishTeal: UIColor {
      return UIColor(red: 52.0 / 255.0, green: 193.0 / 255.0, blue: 162.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var paleGrey: UIColor {
      return UIColor(red: 245.0 / 255.0, green: 246.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var cloudyBlue: UIColor {
      return UIColor(red: 182.0 / 255.0, green: 189.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var sunflowerYellow: UIColor {
      return UIColor(red: 1.0, green: 219.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var coral: UIColor {
      return UIColor(red: 252.0 / 255.0, green: 87.0 / 255.0, blue: 59.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var paleOliveGreen: UIColor {
      return UIColor(red: 141.0 / 255.0, green: 211.0 / 255.0, blue: 132.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var easterPurple: UIColor {
      return UIColor(red: 208.0 / 255.0, green: 121.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    @nonobjc class var salmon: UIColor {
      return UIColor(red: 1.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var dark: UIColor {
      return UIColor(red: 38.0 / 255.0, green: 39.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var lightBlueGrey: UIColor {
      return UIColor(red: 192.0 / 255.0, green: 196.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var maize: UIColor {
      return UIColor(red: 1.0, green: 213.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var aquaMarine: UIColor {
      return UIColor(red: 44.0 / 255.0, green: 228.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var cornflower: UIColor {
      return UIColor(red: 89.0 / 255.0, green: 116.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var red: UIColor {
      return UIColor(red: 245.0 / 255.0, green: 10.0 / 255.0, blue: 4.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var weirdGreen: UIColor {
      return UIColor(red: 76.0 / 255.0, green: 217.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var bubblegum: UIColor {
      return UIColor(red: 1.0, green: 107.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var brightSkyBlue: UIColor {
      return UIColor(red: 4.0 / 255.0, green: 193.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    @nonobjc class var orange: UIColor {
      return UIColor(red: 244.0 / 255.0, green: 119.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var melon: UIColor {
      return UIColor(red: 1.0, green: 138.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var azure: UIColor {
      return UIColor(red: 0.0, green: 174.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var apple: UIColor {
      return UIColor(red: 141.0 / 255.0, green: 198.0 / 255.0, blue: 63.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var color1Fill: UIColor {
      return UIColor(red: 1.0, green: 97.0 / 255.0, blue: 171.0 / 255.0, alpha: 1.0)
    }
    
    //MARK:- Create poll COLORS
    @nonobjc class var lightSkyBlue: UIColor {
        return UIColor(red: 227.0 / 255.0, green: 248.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var lightPurple: UIColor {
        return UIColor(red: 220.0 / 255.0, green: 226.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var lightOrange: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 230.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var lightYellow: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 249.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0)
    }
    func getImage(size:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(self.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            return colorImage
        }
        UIGraphicsEndImageContext()
        return nil
    }
    //MARK: - SECOND VERSION COLORS
    
    static func color(from string: String) -> UIColor {
        let hash = string.hash
        let colorCode = abs(hash) % 0x1000000
        let red = colorCode >> 16
        let green = (colorCode >> 8) & 0xff
        let blue = colorCode & 0xff
        return UIColor(red: CGFloat(red) / 256, green: CGFloat(green) / 256, blue: CGFloat(blue) / 256, alpha: 1)
    }
    
}



//MARK: ---- NEW COLORS
extension UIColor {
    
    open class var color171717: UIColor {
        return UIColor(hexString: "171717")
    }
    
    open class var colorA2A2A2: UIColor {
        return UIColor(hexString: "A2A2A2")
    }
    
    open class var ic_blueBlue: UIColor {
        return UIColor(hexString: "245FD4")
    }
    
    open class var ic_chatLeftBgColor: UIColor {
        return UIColor(hexString: "F2F4F6")
    }
    
    open class var ic_999999: UIColor {
        return UIColor(hexString: "999999")
    }
    open class var busyOrangeColor: UIColor {
        return UIColor(hexString: "fa6400")
    }
    
    open class var offlineColor: UIColor {
        return UIColor(hexString: "E02020")
    }
    open class var blue_Color: UIColor {
        return UIColor(hexString: "307AFF")
    }
    open class var black_Color: UIColor {
        return UIColor(hexString: "222831")
    }
    
    
    
    ///Added
    enum AppAssetColor : String{
        case themeYellow = "themeYellow"
        case themeWhite = "themeWhite"
        case themeGrey = "themeGrey"
        case themeDarkGrey = "themeDarkGrey"
        case themeBlack = "themeBlack"
        case popUpColour = "popUpColour"
        case fontBlack = "fontBlack"
        case lightGreen = "lightest-green"
        case green_Light = "Green_Light"
        case Grey = "Grey"
        case lightest_Grey = "Lightest_Grey"
        case white_Light = "cellWhite"
        case transparent = "transparent"
        case light_Grey = "Light_Grey"
        case light_Main = "border"
        case pale_Grey = "Pale_Grey"
        case cyan_Light_Stroke = "Cyan_Light_Stroke"
        case whiteOpacity =  "whiteOpacity"
        case dark_Grey =  "Dark_Grey"
        case pink_Light =  "Pink_Light"
        case redFont = "Red_Main"
        case gradient_dark_yellow =  "#bb962d"
        case gradient_light_black =  "#343434"
        case white_title =  "white_main"
        case green_main =  "nxtBtnColor"
        case yellow_dark =  "pageCtrlColor"
        case Grey_dark = "greyMain"
        case whiteTransparent = "whiteTransparent"
        case blueMain = "Blue_main"
        case backgroundWhite = "backgroundWhite"
        case blackMain = "Black_main"
        
        
        
       
    }
    static func appColor(_ name:AppAssetColor)->UIColor?{
        switch name{
        case .themeYellow:
            return UIColor(named: AppAssetColor.themeYellow.rawValue)
        case .themeWhite:
            return UIColor(named: AppAssetColor.themeWhite.rawValue)
        case .themeGrey:
            return UIColor(named: AppAssetColor.themeGrey.rawValue)
        case .themeDarkGrey:
            return UIColor(named: AppAssetColor.themeDarkGrey.rawValue)
        case .themeBlack:
            return UIColor(named: AppAssetColor.themeBlack.rawValue)
        case .popUpColour:
            return UIColor(named: AppAssetColor.popUpColour.rawValue)
        case .fontBlack:
            return UIColor(named: AppAssetColor.fontBlack.rawValue)
        case .lightGreen:
            return UIColor(named: AppAssetColor.lightGreen.rawValue)
        case .green_Light:
            return UIColor(named: AppAssetColor.green_Light.rawValue)
        case .Grey:
            return UIColor(named: AppAssetColor.Grey.rawValue)
        case .lightest_Grey:
            return UIColor(named: AppAssetColor.lightest_Grey.rawValue)
        case .white_Light:
            return UIColor(named: AppAssetColor.white_Light.rawValue)
        case .transparent:
            return UIColor(named: AppAssetColor.transparent.rawValue)
        case .light_Grey:
            return UIColor(named: AppAssetColor.light_Grey.rawValue)
        case .light_Main:
            return UIColor(named: AppAssetColor.light_Main.rawValue)
        case .pale_Grey:
            return UIColor(named: AppAssetColor.pale_Grey.rawValue)
        case .cyan_Light_Stroke:
            return UIColor(named: AppAssetColor.cyan_Light_Stroke.rawValue)
        case .whiteOpacity :
            return UIColor(named: AppAssetColor.whiteOpacity.rawValue)
        case .dark_Grey:
            return UIColor(named: AppAssetColor.dark_Grey.rawValue)
        case .pink_Light:
            return UIColor(named: AppAssetColor.pink_Light.rawValue)
        case .redFont:
            return UIColor(named: AppAssetColor.redFont.rawValue)
        case .gradient_dark_yellow :
            return UIColor(named: AppAssetColor.gradient_dark_yellow.rawValue)
        case .gradient_light_black:
            return UIColor(named: AppAssetColor.gradient_light_black.rawValue)
        case .white_title:
            return UIColor(named: AppAssetColor.white_title.rawValue)
        case .green_main:
            return UIColor(named: AppAssetColor.green_main.rawValue)
        case .yellow_dark:
            return UIColor(named: AppAssetColor.yellow_dark.rawValue)
        case .Grey_dark:
            return UIColor(named: AppAssetColor.Grey_dark.rawValue)
        case .whiteTransparent:
            return UIColor(named: AppAssetColor.whiteTransparent.rawValue)
        case .blueMain:
            return UIColor(named: AppAssetColor.blueMain.rawValue)
        case .backgroundWhite:
            return UIColor(named: AppAssetColor.backgroundWhite.rawValue)
        case .blackMain:
            return UIColor(named: AppAssetColor.blackMain.rawValue)
            
        }
        
    }

}
