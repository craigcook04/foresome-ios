//
//  UIImageView + Custom.swift
//  Leila
//
//  Created by Soumya Jain on 01/06/18.
//  Copyright © 2018 Soumya Jain. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit


extension UIImage {
    
    var renderTemplateMode: UIImage {
        return self.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    }
    
    var renderOriginalMode: UIImage {
        return self.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
    //MARK: added by deep get base 64 string fro uiimage -----
    func convertImageToBase64String() -> String {
        return self.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func maskWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        color.setFill()
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        context.draw(self.cgImage!, in: rect)
        context.setBlendMode(CGBlendMode.sourceIn)
        context.addRect(rect)
        context.drawPath(using: CGPathDrawingMode.fill)
        
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return coloredImage!
    }
    
    func resizeImage(newWidth: CGFloat) -> UIImage {
           let scale = newWidth / self.size.width
           let newHeight = self.size.height * scale
           UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth,
                                                         height: newHeight),
                                                  false,
                                                  0)
           self.draw(in: CGRect(x: 0,
                                y: 0,
                                width: newWidth,
                                height: newHeight))

           let newImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()

           return newImage!
       }
    
    
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
    
    
}

extension UIImageView {
    
    
    @IBInspectable var imageTintColor: UIColor? {
        get {
            return self.imageTintColor
        }
        set {
            if let img: UIImage = self.image, let color = newValue {
                self.image = img.maskWithColor(color: color)
            }
        }
    }
    
    func setImage(image urlString:String?, placeholder image:UIImage? = UIImage(named: "imagePlaceholder")) {
        if let urlStr = urlString, urlStr.count > 0 {
            if let url = URL(string: urlStr){
                    self.kf.setImage(with: url)
            } else {
                self.image = image
            }
            
        } else {
            self.image = image
        }
    }
    
    
    func imageWith(name: String?, lastname:String?, bgColor:UIColor? = UIColor(named:"Neutral_600"), frame:CGRect?, fontSize:  CGFloat?)->UIImage? {
            
            let nameLabel = UILabel(frame: frame ?? CGRect(x: 0, y: 0, width: 50, height: 50))
            nameLabel.textAlignment = .center
            //        nameLabel.applyGradient(colours: [.red,.green], locations: [0.5,1])
            nameLabel.backgroundColor = bgColor
        nameLabel.setLabel("", UIColor(hexString: "#00B1FF"), FONT_NAME.SFProDisplay_Bold, fontSize ?? 18)
        
        
            guard let firstLetter = name?.prefix(1),firstLetter != " " else{return UIImage()}
        
        guard let secondLetter = lastname?.prefix(1), secondLetter != " " else  {
            return UIImage()
         }
        
        
        let shortName = "\(firstLetter)\(secondLetter)"
        
            nameLabel.text = "\(shortName.uppercased())"
        UIGraphicsBeginImageContext(frame?.size ?? CGSize(width: 50, height: 50))
            if let currentContext = UIGraphicsGetCurrentContext() {
                nameLabel.layer.render(in: currentContext)
                let nameImage = UIGraphicsGetImageFromCurrentImageContext()
                self.image = nameImage
                return nameImage
            }else{
                return UIImage()
            }
        }
    
    
//    public func setImageView(urls urlStrings: [String], item: Int, isSkeleton: Bool = false, controller: UIViewController?) {
//        print("urls count is *******  \(urlStrings)")
//        guard urlStrings.filter({$0.count > 0}).count > 0 else { return }
//        
//        let urls = urlStrings.map { str -> URL in
//            let val = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//            return URL(string: val)!
//        }
//        guard urls.count > 0 else { return }
//      //  let types: [ImageViewerOption] = [.theme(.dark)]
//       // self.setupImageViewer(urls: urls, initialIndex: item, options: types, from: controller)
//        
//        let url = URL(string: urlStrings[item].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//        if isSkeleton {
//            self.image = UIImage.gifImageWithName(name: "skeleton-loading")
//        } else {
//            self.setProgressView()
//        }
//        self.kf.setImage(with: url, progressBlock: { receivedSize, totalSize in
//            if !isSkeleton {
//                let progress = Float(receivedSize)/Float(totalSize)
//                    self.setProgressView(progress: progress)
//            }
//        }, completionHandler: { result in
////            print("progress completed")
//            if !isSkeleton {
//                self.removeProgressView()
//            }
//            switch result {
//            case .failure(_) :
//                self.image = UIImage(named: "ic_home_profile_placeholder")
//            case .success(let img):
//                self.image = img.image
//            }
//        })
//    }
//    
    open func setImageView(_ image:UIImage, with color:UIColor) {
        let img = image.renderTemplateMode
        self.tintColor = color
        self.image = img
    }
    
//    public func setUserImage(_ urlString: String?, placeholder: UIImage? = nil) {
//        var urlStr: String = urlString ?? ""
//        if urlStr.isNotEmpty, String(urlStr.last!) == " " {
//            urlStr.removeLast()
//        }
//        guard let urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
//            urlStr.count > 0, let url = URL(string: urlStr), url.canOpen else {
//            self.image = UIImage(named: "ic_home_profile_placeholder")
//            return
//        }
//        if urlStr.isImageType {
//            self.kf.setImage(with: url, progressBlock: { (receivedSize, totalSize) in
//                if self.image == nil {
//                    self.image = UIImage.gifImageWithName(name: "skeleton-loading")
//                }
//            }, completionHandler: { result in
//                switch result {
//                case .failure(_) :
//                    self.image = placeholder != nil ? placeholder : UIImage(named: "ic_home_profile_placeholder")
//                case .success(let img):
//                    self.image = img.image
//                }
//            })
//        } else {
//            self.setVideoImage(image: urlStr, placeholder: UIImage.gifImageWithName(name: "skeleton-loading"))
//        }
//    }
//
    
//    func setImage(image urlString: String?, isSkeleton: Bool = false, placeholder image:UIImage? = nil, completion: ((_ image: UIImage?)->Void)? = nil) {
//        
//        if let urlStr = urlString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
//           urlStr.count > 0 {
//            if let url = URL(string: urlStr), url.canOpen {
//                if urlStr.isImageType {
//                    self.setImageView(with: url, isSkeleton: isSkeleton)
//                } else {
//                    self.setVideoImage(image: urlStr, placeholder: UIImage.gifImageWithName(name: "skeleton-loading"))
//                }
//                print("can open url")
//            } else {
//                self.image = image
//                print("can not open url")
//            }
//        } else {
//            self.image = image
//        }
//    }
//    
////    private func setImageView(with url:URL, isSkeleton: Bool) {
////        if isSkeleton {
////            self.image = .gifImageWithName(name: "skeleton-loading")
////        } else {
////            self.setProgressView()
////        }
////        self.kf.setImage(with: url, progressBlock: { receivedSize, totalSize in
////            if !isSkeleton {
////                let progress = Float(receivedSize)/Float(totalSize)
////                self.setProgressView(progress: progress)
////            }
////        }, completionHandler: { result in
//////            print("progress completed")
////            switch result {
////            case .success(let result):
////                if !isSkeleton {
////                    self.removeProgressView()
////                } else {
////                    self.image = result.image
////                }
////            case .failure(let error):
////                print("error  ********* \(error)")
////                self.image = #imageLiteral(resourceName: "placeholder_banner")
////            }
////        })
////    }
    
    func setVideoImage(image urlString: String?, placeholder image: UIImage?) {
        guard let imageURL = urlString else {
            self.image = image
            return
        }
        if let data = UserDefaults.standard.value(forKey: imageURL) as? Data {
            self.image = UIImage(data: data)
            return
        }
        self.image = image
        guard let url = URL(string: imageURL) else {
            self.image = image
            return
        }
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let timestamp = CMTime(seconds: 1, preferredTimescale: 10)
        self.restorationIdentifier = imageURL
        DispatchQueue.global().async {
            do {
                let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
                DispatchQueue.main.async {
                    let image = UIImage(cgImage: imageRef)
                    
                    UserDefaults.setValue(value: image.jpegData(compressionQuality: 1.0), for: imageURL)
                    
                    if self.restorationIdentifier == imageURL {
                        self.image = image
                    }
                }
            } catch {
                print("Image generation failed with error \(error)")
            }
        }
    }
    
}

extension UIImage {
    
    public class func gifImageWithData(data: NSData) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("image doesn't exist")
            return nil
        }
        return UIImage.animatedImageWithSource(source: source)
    }
    
    public class func gifImageWithURL(gifUrl: String) -> UIImage? {
        guard let bundleURL = NSURL(string: gifUrl)
        else {
            print("image named \"\(gifUrl)\" doesn't exist")
            return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL as URL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        return gifImageWithData(data: imageData)
    }
    
    public class func gifImageWithName(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
                .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        
        guard let imageData = NSData(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(data: imageData)
    }
    
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a!
            a = b!
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b!
                b = rest
            }
        }
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(a: val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i), source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(array: delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        
        return animation
    }
}




