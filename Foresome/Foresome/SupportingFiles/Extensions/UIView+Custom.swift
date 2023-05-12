//
//  UIView + Custom.swift
//  Leila
//
//  Created by Soumya Jain on 07/06/18.
//  Copyright © 2018 Soumya Jain. All rights reserved.
//

import UIKit

internal extension UIView {
    
    static func getFromNib<T : UIView>(className:T.Type) -> T{
        guard let view = UINib(nibName: String(describing: className.self), bundle: nil).instantiate(withOwner: nil, options: nil).first as? T else {
                fatalError(
                    "Error: nib with id: \(String(describing: className.self)) is not \(T.self)")
            }
        return view
       }
    
    func setCornerRadius(forIndexPath indexPath: IndexPath, inTableView tableView: UITableView) {
            let lastRow = tableView.numberOfRows(inSection: indexPath.section) - 1
            self.layer.maskedCorners = []

            if indexPath.row == 0 && indexPath.row == lastRow {
                self.cornerRadius = 16
               self.layer.maskedCorners = [.layerMaxXMinYCorner,
                                            .layerMinXMinYCorner,
                                            .layerMinXMaxYCorner,
                                            .layerMaxXMaxYCorner]
            } else if indexPath.row == 0 {
                self.cornerRadius = 16
                self.layer.maskedCorners = [.layerMaxXMinYCorner,
                                            .layerMinXMinYCorner]
            } else if indexPath.row == lastRow {
                self.cornerRadius = 16
                self.layer.maskedCorners = [.layerMinXMaxYCorner,
                                            .layerMaxXMaxYCorner]
            }
        }
    
    func setdd(){
        var pulse: CAGradientLayer = {
            let l = CAGradientLayer()
            l.type = .radial
            l.colors = [ UIColor.red.cgColor,
                UIColor.yellow.cgColor]
            l.locations = [ 0, 0.3]
            l.startPoint = CGPoint(x: 0.5, y: 0.5)
            l.endPoint = CGPoint(x: 1, y: 1)
            layer.addSublayer(l)
            return l
        }()
    }
    // ChallengeDetailVC Cases color
    
    func orangeLogNowGradientColor(){
        self.applyGradient(colours: [UIColor(hexString: "#FFD977", alpha: 1),UIColor(hexString: "#F9B301", alpha: 1)], locations: [0,1])
    }
   
    func todayGradientColor(){
        self.applyGradient(colours: [UIColor(hexString: "#6FD3FF", alpha: 1),UIColor(hexString: "#00B1FF", alpha: 1)], locations: [0,1])
    }
    func actNowGradientColor(){
        self.applyGradient(colours: [UIColor(hexString: "#FF81C3", alpha: 1),UIColor(hexString: "#FB2193", alpha: 1)], locations: [0,1])
    }
    func completedGradientColor(){
        self.applyGradient(colours: [UIColor(hexString: "#03D670", alpha: 0.5),UIColor(hexString: "#03D670", alpha: 1)], locations: [0,1])
    }
    func failedGradientColor(){
        self.applyGradient(colours: [UIColor(hexString: "#FF8181", alpha: 0.95),UIColor(hexString: "#F55E5E", alpha: 1)], locations: [0,1])
    }
    
    func setHeight(_ h:CGFloat, animateTime:TimeInterval?=nil) {
        if let c = self.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }) {
            c.constant = CGFloat(h)

            if let animateTime = animateTime {
                UIView.animate(withDuration: animateTime, animations:{
                    self.superview?.layoutIfNeeded()
                })
            }  else {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    func setConstraint(_ h: CGFloat,  type: NSLayoutConstraint.Attribute,  animateTime:TimeInterval? = nil) {
        if let c = self.constraints.first(where: { $0.firstAttribute == type && $0.relation == .equal}) {
            c.constant = h
            if let animateTime = animateTime {
                UIView.animate(withDuration: animateTime, animations:{
                    self.superview?.layoutIfNeeded()
                })
            }  else {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    func addTarget(target: Any?, action: Selector?) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    func makeSlide() {
        let frame = self.bounds
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 20))
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        
        path.close()
        path.fill()
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func addDashedBorder(_ color:UIColor, size:CGSize) {
        let color = color.cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        shapeLayer.bounds = frameSize
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [5,5]
        shapeLayer.path = UIBezierPath(roundedRect: frameSize, cornerRadius: 5).cgPath
        self.layer.addSublayer(shapeLayer)
        self.setNeedsLayout()
    }
    
    
    var safeAreaInsetsForAllOS: UIEdgeInsets {
        var insets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            insets = safeAreaInsets
        } else {
            insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return insets
    }
    
    func setShadow(upside:Bool = true) {
        setShadowBounds(upside: upside)
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
    }
    
    func setViewBorder(borderWidth:CGFloat, background: UIColor, borderColor: UIColor) {
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.backgroundColor = background
    }
    
    func setView(borderWidth:CGFloat, background:UIColor, outerColor:UIColor = UIColor.white) {
        self.borderColor = outerColor
        self.borderWidth = borderWidth
        self.backgroundColor = background
        self.addShadow()
    }
    
    func addShadow(color:UIColor = UIColor.black.withAlphaComponent(0.1), opticity:Float = 1.0, shadowRadius : CGFloat = 0, shadowOffset : CGSize = CGSize(width: 0, height: 0) ) {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = opticity
    }
    
    func tabbarShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: -3)
        self.layer.shadowRadius = 5
    }
    
    func setShadowBounds(upside:Bool) {
        if upside == true {
            self.layer.shadowOffset = CGSize(width: -6, height: -8)
        } else {
            self.layer.shadowOffset = CGSize(width: 6, height: 8)
        }        
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 6
        self.clipsToBounds = false
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat, width: CGFloat, height: CGFloat) {
        let path = UIBezierPath(roundedRect: CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: width, height: height), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        DispatchQueue.main.async {
            let gradient:CAGradientLayer = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.colors = colours.map { $0.cgColor }
            gradient.locations = locations
            gradient.name = "gradientLayer"
            //        gradient.startPoint = CGPoint(x: 0.0, y: 0.5) // CGPointMake(0.0, 0.5)
            //        gradient.endPoint = CGPoint(x: 1.0, y: 0.5) //CGPointMake(1.0, 0.5)
            self.layer.insertSublayer(gradient, at: 0)
            self.clipsToBounds = true
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius
    }
    
    ///Added
    func addShadowToEdges(to edges: [UIRectEdge], radius: CGFloat = 10.0, opacity: Float = 0.35, color: CGColor = UIColor.clear.cgColor) {
            removeInnerShadows()
            let fromColor = color
            let toColor = UIColor.clear.cgColor
            let viewFrame = self.frame
            self.clipsToBounds = true
            for edge in edges {
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [fromColor, toColor]
                gradientLayer.opacity = opacity
                gradientLayer.name = "innerShadow"
                switch edge {
                case .top:
                    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.6)
                    gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: radius)
                case .bottom:
                    gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.6)
                    gradientLayer.frame = CGRect(x: 0.0, y: viewFrame.height - radius, width: viewFrame.width, height: radius)
                case .left:
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.6)
                    gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: radius, height: viewFrame.height)
                case .right:
                    gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                    gradientLayer.frame = CGRect(x: viewFrame.width - radius, y: 0.0, width: radius, height: viewFrame.height)
                default:
                    break
                }
                self.layer.addSublayer(gradientLayer)
            }
        }
    
    func removeGradient() {
        guard let layers = self.layer.sublayers else {
            return
        }
        for subLayer in layers {
            if subLayer.name == "gradientLayer" {
                subLayer.removeFromSuperlayer()
            }
        }
    }
    
    func removeInnerShadows() {
        guard let layers = self.layer.sublayers else {
            return
        }
        for subLayer in layers {
            if subLayer.name == "innerShadow" {
                subLayer.removeFromSuperlayer()
            }
        }
    }
    
    func setBorder(_ color:UIColor, corner radius: CGFloat, _ width: CGFloat) {
        self.borderColor = color
        self.cornerRadius = radius
        self.borderWidth = width
        self.clipsToBounds = true
    }
    
    func applyGradientOnBorder(colours: [CGColor], locations: [NSNumber]?) {
        self.borderColor = UIColor.clear
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = colours
        self.layer.cornerRadius = self.frame.height / 2
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)// CGPointMake(0.0, 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)//CGPointMake(1.0, 0.5)
        gradient.name = "gradientLayer"
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        // shape.path = UIBezierPath(rect: self.bounds).cgPath
        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: (self.frame.height/2)).cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        self.layer.addSublayer(gradient)
        print(self.frame.size)
    }
    
    func applyGradientOnBorderView(colours: [CGColor], locations: [NSNumber]?) {
        self.borderColor = UIColor.clear
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = colours
        self.layer.cornerRadius = self.frame.height / 2
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)// CGPointMake(0.0, 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)//CGPointMake(1.0, 0.5)
        gradient.name = "gradientLayer"
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        // shape.path = UIBezierPath(rect: self.bounds).cgPath
        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: (self.frame.height/2)).cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        self.layer.addSublayer(gradient)
        print(self.frame.size)
    }
    
    func applyGradientLeftToRight(colours: [UIColor], locations: [NSNumber]?) -> Void {
        DispatchQueue.main.async {
            let gradient:CAGradientLayer = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.colors = colours.map { $0.cgColor }
            gradient.locations = locations
            gradient.name = "gradientLayer"
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)// CGPointMake(0.0, 0.5)
            gradient.endPoint = CGPoint(x: 1.5, y: 0.5)//CGPointMake(1.0, 0.5)
            self.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    func animateSping() {
        self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
    
    func dissmissPopup(complitionHandler: @escaping(_ complitionHandler:Bool) -> (Void)) {
        UIView.animate(withDuration: 0.35) {
            self.transform = CGAffineTransform(scaleX: 0.02, y: 0.02)
            complitionHandler(true)
        }
    }
    
    func setCornerRadius(topLeft:CGFloat, topRight:CGFloat, bottomLeft:CGFloat, bottomRight:CGFloat) {
        self.roundCorners(corners: [.topLeft], radius: topLeft, width: self.frame.width, height: self.frame.height)
        self.roundCorners(corners: [.topRight], radius: topRight, width: self.frame.width, height: self.frame.height)
        self.roundCorners(corners: [.bottomLeft], radius: bottomLeft, width: self.frame.width, height: self.frame.height)
        self.roundCorners(corners: [.bottomRight], radius: bottomRight, width: self.frame.width, height: self.frame.height)
    }
    // for corner radius
    @IBInspectable var isRounded: Bool {
        set  {
            if newValue {
                self.layer.cornerRadius = (self.frame.height/2)
                self.clipsToBounds = true
            }
        } get {
            return self.layer.cornerRadius == 0
        }
    }
    // for corner radius
    @IBInspectable var cornerRadius: CGFloat
        {
        set (radius) {
            self.layer.cornerRadius = radius
            self.clipsToBounds = radius > 0
        }
        get {
            return self.layer.cornerRadius
        }
    }
    //-----------round bottom corners---
    @IBInspectable var topCornerRadius: CGFloat {
        set (radius) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } get {
            return self.layer.cornerRadius
        }
    }
    //-----------round bottom corners---
    @IBInspectable var bottomCornerRadius:CGFloat{
        set(radius){
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        get{
            return self.layer.cornerRadius
        }
    }
    //-----------round left corners---
    @IBInspectable var leftCornerRadius:CGFloat{
        set(radius){
            self.clipsToBounds = radius > 0
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
        get{
            return self.layer.cornerRadius
        }
    }
    //-----------round right corners---
    @IBInspectable var rightCornerRadius:CGFloat{
        set(radius){
            self.clipsToBounds = radius > 0
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
        
        get{
            return self.layer.cornerRadius
        }
    }
    // for border width
    @IBInspectable var borderWidth: CGFloat {
        set (borderWidth) {
            self.layer.borderWidth = borderWidth
        } get {
            return self.layer.borderWidth
        }
    }
    // for border Color
    @IBInspectable var borderColor:UIColor? {
        set (color) {
            self.layer.borderColor = color?.cgColor
        } get {
            if let color = self.layer.borderColor  {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }
    // shadow Radius
    @IBInspectable var shadowRadius: CGFloat
        {
        set (radius) {
            self.layer.shadowRadius = radius
            guard self.layer.cornerRadius > 0 else {
                return}
            self.layer.masksToBounds = false
        }
        get {
            return self.layer.shadowRadius
        }
    }
    // shadow optacity
    @IBInspectable var shadowOptacity: Float
        {
        set (opticity) {
            self.layer.shadowOpacity = opticity
        }
        get {
            return self.layer.shadowOpacity
        }
    }
    //  for shadow color
    @IBInspectable var shadowColor:UIColor?
        {
        set (color) {
            self.layer.shadowColor = color?.cgColor
        }
        get {
            if let color = self.layer.shadowColor
            {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set (offSet) {
            self.layer.shadowOffset = offSet
        }
        get {
            return self.layer.shadowOffset
        }
    }
    
    @IBInspectable var rightRadius: CGFloat {
        set (radius) {
            self.roundCorners(corners: [.bottomRight,.topRight], radius: radius, width: self.frame.width, height: self.frame.height)
            self.clipsToBounds = true
        }
        get {
            return self.cornerRadius
        }
    }
    
    @IBInspectable var topRadius: CGFloat {
        set (radius) {
            self.roundCorners(corners: [.topRight,.topLeft], radius: radius, width: self.frame.width, height: self.frame.height)
            self.clipsToBounds = true
        }
        get {
            return self.cornerRadius
        }
    }
    
    @IBInspectable var bottomRadius: CGFloat {
        set (radius) {
            self.roundCorners(corners: [.bottomRight,.bottomLeft], radius: radius, width: self.frame.width, height: self.frame.height)
            self.clipsToBounds = true
        }
        get {
            return self.cornerRadius
        }
    }
    
    @IBInspectable var leftRadius: CGFloat {
        set (radius) {
            self.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius, width: self.frame.width, height: self.frame.height)
            self.clipsToBounds = true
        }
        get {
            return self.cornerRadius
        }
    }
    //    @IBInspectable public var topLeftRadius: CGFloat
    //        {
    //        set (radius) {
    //            self.roundCorners(corners: [.topLeft], radius: radius, width: self.frame.width, height: self.frame.height)
    //        }
    //        get {
    //            return self.layer.cornerRadius
    //        }
    //    }
    //
    //    @IBInspectable public var topRightRadius: CGFloat
    //        {
    //        set (radius) {
    //            self.roundCorners(corners: [.topRight], radius: radius, width: self.frame.width, height: self.frame.height)
    //        }
    //        get {
    //            return self.layer.cornerRadius
    //        }
    //    }
    //
    //    @IBInspectable public var bottonLeftRadius: CGFloat
    //        {
    //        set (radius) {
    //            self.roundCorners(corners: [.bottomLeft], radius: radius, width: self.frame.width, height: self.frame.height)
    //        }
    //        get {
    //            return self.layer.cornerRadius
    //        }
    //    }
    //
    //    @IBInspectable public var bottomRightRadius: CGFloat
    //        {
    //        set (radius) {
    //            self.roundCorners(corners: [.bottomRight], radius: radius, width: self.frame.width, height: self.frame.height)
    //        }
    //        get {
    //            return self.layer.cornerRadius
    //        }
    //    }
    //
    
//    func copyView<T: UIView>() -> T? {
//        return NSKeyedUnarchiver.classForKeyedUnarchiver()  as? T
//        unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
//    }
    
    var takeScreenshot: UIImage? {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
        
//        if let img = image {
//            return img
//        }
    }
    
    func removeSubviews() {
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
    
    func getImageView(frame:CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.image = self.takeScreenshot
        return imageView
    }
}

extension UIView {
    class func header(size:CGSize, title:String?, textColor:UIColor = .placeholderColor) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: size.width-30, height: size.height))
        label.setLabel(title, textColor, .OS_Regular, 16)
        label.backgroundColor = .white
        view.backgroundColor = .white
        view.addSubview(label)
        return view
    }
    
    class func initView<T>(view type: T.Type) -> T where T : UIView {
        let view = UINib(nibName: String(describing: type.self), bundle: nil
        ).instantiate(withOwner: nil, options: nil).first as? UIView
        return view as! T
    }
    
    func addLine(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        switch position {
        case .top:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .bottom:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
//        case .center:
//            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
//            break
        }
//        return lineView
    }
    
    func addCenterLine(color:UIColor) {
        let y = self.frame.height/2
        let view = UIView(frame: CGRect(x: 0, y: y, width: self.frame.width, height: 1))
        view.backgroundColor = color
        self.addSubview(view)
    }
    
    func addActivityIndigator(isRounded:Bool = false, color: UIColor? = nil, indigatorColor:UIColor? = nil) {
        removeActivityIndigator()
        
        let indigator = UIActivityIndicatorView(style: .gray)
        if let color = color {
            indigator.backgroundColor = color
        } else {
            indigator.backgroundColor = .white
        }
        if let indigatorColor = indigatorColor {
            indigator.color = indigatorColor
        }
        indigator.restorationIdentifier = "activity"
        indigator.tag = 90909090
        indigator.startAnimating()
        indigator.frame = self.bounds
        if isRounded {
            indigator.cornerRadius = indigator.frame.size.height/2
        }
        self.addSubview(indigator)
    }
    
    func removeActivityIndigator() {
        self.subviews.forEach { v in
            if let v = v as? UIActivityIndicatorView {
                v.stopAnimating()
                v.removeFromSuperview()
            }
        }
    }
}

enum LINE_POSITION {
    case top
    case bottom
}

extension UINib {
    var instantiate: [Any] {
        return self.instantiate(withOwner: nil, options: nil)
    }
    
    var instantiateView: UIView? {
        return self.instantiate(withOwner: nil, options: nil).first as? UIView
    }
    
    class func instantiateView(with name:String) -> UIView? {
        return UINib(nibName: name).instantiateView
    }
}

extension UIResponder {
    
    func getParentViewController() -> UIViewController? {
        if let vc = self.next as? UIViewController {
            return vc
        } else {
            if self.next != nil {
                return self.next?.getParentViewController()
            } else {
                return nil
            }
        }
    }
}

class DefaultPageControl: UIPageControl {
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    func updateDots() {
        let currentDot = subviews[currentPage]
        subviews.forEach {
            $0.bounds.size = ($0 == currentDot) ? CGSize(width: 6, height: 6) : CGSize(width: 3, height: 3)
            $0.layer.cornerRadius = 2
        }
    }
}

extension UIPageControl {
    func customPageControl(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            }else{
                dotView.backgroundColor = .white
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }
}
// MARK: - VIEWS USE IN APP
extension UIView{
    func setCurrentTextFieldBgView(){
        self.backgroundColor = UIColor.white
        self.shadowColor = UIColor(hexString: "#00B1FF", alpha: 0.2)
        self.shadowOptacity = 1.0
        self.shadowRadius = 8.0
        self.shadowOffset = CGSize(width: 0, height: 2)
        self.borderColor = UIColor(hexString: "#00B1FF")
    }
    
    func addShadow(color:UIColor){
        self.shadowColor = color
        self.shadowOptacity = 1
        self.shadowRadius = 8
        self.shadowOffset = CGSize(width: 0, height: 2)
    }
}
