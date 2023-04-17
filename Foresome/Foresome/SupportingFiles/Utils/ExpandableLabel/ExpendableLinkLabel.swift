//
//  ExpendableLinkLabel.swift
//  meetwise
//
//  Created by hitesh on 22/07/21.
//  Copyright © 2021 hitesh. All rights reserved.
//

import UIKit


public protocol ExpendableLinkLabelDelegate: NSObjectProtocol {
    func tapableLabel(_ label: ExpendableLinkLabel, didTapUrl url: String, atRange range: NSRange)
    func tapableLabel(_ label: ExpendableLinkLabel, didTapString string: String, atRange range: NSRange)
}

public class ExpendableLinkLabel: UILabel {

    lazy var readMoreFont: UIFont = UIFont.setCustom(.poppinsRegular, 14)
    lazy var readLessFont: UIFont = UIFont.setCustom(.poppinsRegular, 14)
    lazy var readMoreString = "  ...Read More"
    lazy var readLessString = "  ...Read Less"
    lazy var characterLimit: Int = 120 {
        didSet {
            setNeedsLayout()
        }
    }
    public weak var delegate: ExpendableLinkLabelDelegate?
    private var links: [[String: NSRange]] = [[:]]
    private(set) var layoutManager = NSLayoutManager()
    private(set) var textContainer = NSTextContainer(size: CGSize.zero)
    private(set) var textStorage = NSTextStorage() {
        didSet {
            textStorage.addLayoutManager(layoutManager)
        }
    }
    lazy var message: String = "" {
        didSet {
            self.setTextData()
        }
    }
    lazy var readMoreColor: UIColor = UIColor(hexString: "#307AFF") {
        didSet {
            self.setTextData()
        }
    }
    lazy var readLessColor:UIColor = UIColor(hexString: "#307AFF") {
        didSet {
            self.setTextData()
        }
    }
    public var textForegroundColor: UIColor = UIColor.color171717
    
    
    public override var text: String? {
        didSet {
            if let text = text {
                setTextData(text: text )
            }
        }
    }
    
    
    func setTextData(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : textForegroundColor], range: NSRange(location: 0, length: text.count))
        self.text?.detectedLinksRange.forEach({ (link, range) in
            attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        })
        self.text?.detectedPhoneNumbersRange.forEach({ (link, range) in
            attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        })
        self.text?.detectedEmailRange.forEach({ (link, range) in
            attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        })
        self.attributedText = attributedString
    }
    
    

    public override var attributedText: NSAttributedString? {
        didSet {
            if let attributedText = attributedText {
                textStorage = NSTextStorage(attributedString: attributedText)
                findLinksAndRange(attributeString: attributedText)
            } else {
                textStorage = NSTextStorage()
                links = [[:]]
            }
        }
    }
    
    public override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
        }
    }
    
    public override var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isUserInteractionEnabled = true
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines  = numberOfLines
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }

    private func findLinksAndRange(attributeString: NSAttributedString) {
        links.removeAll()
        let enumerationBlock: (Any?, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void = { [weak self] value, range, isStop in
            guard let strongSelf = self else { return }
            if let value = value {
                strongSelf.links.append(["\(value)": range])
            }
        }
        attributeString.enumerateAttribute(.link, in: NSRange(0..<attributeString.length), options: [.longestEffectiveRangeNotRequired], using: enumerationBlock)
        attributeString.enumerateAttribute(.attachment, in: NSRange(0..<attributeString.length), options: [.longestEffectiveRangeNotRequired], using: enumerationBlock)
    }
    
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        let locationOfTouch = gesture.location(in: self)
        textContainer.size = bounds.size
        let indexOfCharacter = layoutManager.glyphIndex(for: locationOfTouch, in: textContainer)
        for link in links where NSLocationInRange(indexOfCharacter, link.values.first!) {
            if let urlString = link.keys.first,
               let range = link.values.first {
                DispatchQueue.main.async { [self] in
                    if urlString == readMoreString || urlString == readLessString  {
                        clickedReadText(urlString, range: range)
                    } else {
                        delegate?.tapableLabel(self, didTapUrl: urlString, atRange: range)
                    }
                }
                return
            }
        }
    }
    
    
    
    
//    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let locationOfTouch = touches.first?.location(in: self) else { return }
//        textContainer.size = bounds.size
//        let indexOfCharacter = layoutManager.glyphIndex(for: locationOfTouch, in: textContainer)
//        for link in links where NSLocationInRange(indexOfCharacter, link.values.first!) {
//            if let urlString = link.keys.first,
//               let range = link.values.first {
//                DispatchQueue.main.async { [self] in
//                    if urlString == readMoreString || urlString == readLessString  {
//                        clickedReadText(urlString, range: range)
//                    } else {
//                        delegate?.tapableLabel(self, didTapUrl: urlString, atRange: range)
//                    }
//                }
//                return
//            }
//        }
//    }
    
    func setTextData() {
        if (message.count) > characterLimit {
            var attri = [NSAttributedString.Key : Any]()
            attri[.font] = self.font
            attri[.foregroundColor] = textForegroundColor
                        
            var trimData = String(message.prefix(characterLimit))
            trimData = trimData.components(separatedBy: " ").dropLast().joined(separator: " ")
            
            let attributedString = NSMutableAttributedString(string: trimData)
            attributedString.addAttributes(attri, range: NSRange(location: 0, length: trimData.count))
            print("trim data count *****\(trimData.count)")
            trimData.detectedLinksRange.forEach({ (link, range) in
                attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
            })
            trimData.detectedPhoneNumbersRange.forEach({ (link, range) in
                attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
            })
            trimData.detectedEmailRange.forEach({ (link, range) in
                attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
            })
            
            let attributed2 = NSMutableAttributedString(string: readMoreString, attributes: [
            .font: readMoreFont, .foregroundColor: readMoreColor])
            attributedString.append(attributed2)
            
            self.attributedText = attributedString
            
            let range = NSString(string: self.text ?? "").range(of: readMoreString)
            links.append([readMoreString: range])
        } else {
//            self.textColor = UIColor.color171717
            self.text = message
        }
    }
    
    func clickedReadText(_ text: String, range: NSRange) {
        
        var attri = [NSAttributedString.Key : Any]()
        attri[.font] = self.font
        attri[.foregroundColor] = textForegroundColor //UIColor.color171717
        
        switch text {
        case readMoreString:
            let attributedString = NSMutableAttributedString(string: message)
            attributedString.addAttributes(attri, range: NSRange(location: 0, length: message.count))
            
            let attributed2 = NSMutableAttributedString(string: readLessString, attributes: [
            .font: readLessFont, .foregroundColor: readLessColor])
            attributedString.append(attributed2)
            
            message.detectedLinksRange.forEach({ (link, range) in
                attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
            })
            message.detectedPhoneNumbersRange.forEach({ (link, range) in
                attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
            })
            
            message.detectedEmailRange.forEach({ (link, range) in
                attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
            })
            
            self.attributedText = attributedString
            
            let range = NSString(string: self.text ?? "").range(of: readLessString)
            links.append([readLessString : range])
            
        case readLessString:
            
            var trimData = String(message.prefix(characterLimit))
            trimData = trimData.components(separatedBy: " ").dropLast().joined(separator: " ")
            
            let attributedString = NSMutableAttributedString(string: trimData)
            attributedString.addAttributes(attri, range: NSRange(location: 0, length: trimData.count))
            
            trimData.detectedLinksRange.forEach({ (link, range) in
                attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
                
            })
            trimData.detectedPhoneNumbersRange.forEach({ (link, range) in
                attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
            })
            trimData.detectedEmailRange.forEach({ (link, range) in
                attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
            })
            
            let attributed2 = NSMutableAttributedString(string: readMoreString, attributes: [
            .font: readMoreFont, .foregroundColor: readMoreColor])
            attributedString.append(attributed2)
            
            self.attributedText = attributedString
            
            let range = NSString(string: self.text ?? "").range(of: readMoreString)
            links.append([readMoreString : range])
        default: break
        }
        self.delegate?.tapableLabel(self, didTapString: text, atRange: range)
    }

    func setReadLess() {
        
        var attri = [NSAttributedString.Key : Any]()
        attri[.font] = self.font
        attri[.foregroundColor] = textForegroundColor
        
        
        let attributedString = NSMutableAttributedString(string: message)
        attributedString.addAttributes(attri, range: NSRange(location: 0, length: message.count))
        
        let attributed2 = NSMutableAttributedString(string: readLessString, attributes: [
        .font: readLessFont, .foregroundColor: readLessColor])
        attributedString.append(attributed2)
        
        message.detectedLinksRange.forEach({ (link, range) in
            attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        })
        message.detectedPhoneNumbersRange.forEach({ (link, range) in
            attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        })
        message.detectedEmailRange.forEach({ (link, range) in
            attributedString.addAttribute(.attachment, value: URL(string: link)!, range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        })
        
        self.attributedText = attributedString
        
        let range = NSString(string: self.text ?? "").range(of: readLessString)
        links.append([readLessString : range])
    }
    
}


// MARK: DataDetector
class DataDetector {
    
    private class func _find(all type: NSTextCheckingResult.CheckingType,
                             inString string: String, iterationClosure: ((String,NSRange)) -> Bool) {
        guard let detector = try? NSDataDetector(types: type.rawValue) else { return }
        let range = NSRange(location: 0, length: string.utf16.count)
        let matches = detector.matches(in: string, options: NSRegularExpression.MatchingOptions.reportCompletion, range: range)
        loop: for match in matches {
            for i in 0 ..< match.numberOfRanges {
                let nsrange = match.range(at: i)
                let startIndex = string.index(string.startIndex, offsetBy: nsrange.lowerBound)
                let endIndex = string.index(string.startIndex, offsetBy: nsrange.upperBound)
                let range = startIndex..<endIndex
                
                if match.resultType == .link {
                    if match.url?.scheme != "mailto" {
                        guard iterationClosure((String(string[range]), match.range)) else { break loop }
                    }
                }
            }
        }
    }
    
    private class func _findEmail(all type: NSTextCheckingResult.CheckingType,
                             inString string: String, iterationClosure: ((String,NSRange)) -> Bool) {
        guard let detector = try? NSDataDetector(types: type.rawValue) else { return }
        let range = NSRange(location: 0, length: string.utf16.count)
        let matches = detector.matches(in: string, options: NSRegularExpression.MatchingOptions.reportCompletion, range: range)
        loop: for match in matches {
            for i in 0 ..< match.numberOfRanges {
                let nsrange = match.range(at: i)
                let startIndex = string.index(string.startIndex, offsetBy: nsrange.lowerBound)
                let endIndex = string.index(string.startIndex, offsetBy: nsrange.upperBound)
                let range = startIndex..<endIndex
                
                if match.resultType == .link {
                    if match.url?.scheme == "mailto" {
                        guard iterationClosure((String(string[range]), match.range)) else { break loop }
                    }
                }
            }
        }
    }
    
    private class func _findPhone(all type: NSTextCheckingResult.CheckingType,
                             inString string: String, iterationClosure: ((String,NSRange)) -> Bool) {
        guard let detector = try? NSDataDetector(types: type.rawValue) else { return }
        let range = NSRange(location: 0, length: string.utf16.count)
        let matches = detector.matches(in: string, options: NSRegularExpression.MatchingOptions.reportCompletion, range: range)
        loop: for match in matches {
            for i in 0 ..< match.numberOfRanges {
                let nsrange = match.range(at: i)
                let startIndex = string.index(string.startIndex, offsetBy: nsrange.lowerBound)
                let endIndex = string.index(string.startIndex, offsetBy: nsrange.upperBound)
                let range = startIndex..<endIndex
                
                guard iterationClosure((String(string[range]), match.range)) else { break loop }
            }
        }
    }
    
    private class func _findEmails(all type: NSTextCheckingResult.CheckingType,
                             inString string: String, iterationClosure: ((String,NSRange)) -> Bool) {
        guard let detector = try? NSDataDetector(types: type.rawValue) else { return }
        let range = NSRange(location: 0, length: string.utf16.count)
        let matches = detector.matches(in: string, options: NSRegularExpression.MatchingOptions.reportCompletion, range: range)
        loop: for match in matches {
            for i in 0 ..< match.numberOfRanges {
                let nsrange = match.range(at: i)
                let startIndex = string.index(string.startIndex, offsetBy: nsrange.lowerBound)
                let endIndex = string.index(string.startIndex, offsetBy: nsrange.upperBound)
                let range = startIndex..<endIndex
                guard iterationClosure((String(string[range]), match.range)) else { break loop }
            }
        }
    }
    
    
    class func find(all type: NSTextCheckingResult.CheckingType, in strings: String) -> [(String, NSRange)] {
        var results = [(String, NSRange)]()
        _findEmails(all: type, inString: strings) {
            results.append($0)
            return true
        }
        return results
    }
    
    class func findEmails(in strings: String) -> [(String, NSRange)] {
        var results = [(String, NSRange)]()
        _find(all: .link, inString: strings) {
            results.append($0)
            return true
        }
        return results
    }
    
    class func findEmail(all type: NSTextCheckingResult.CheckingType, in strings: String) -> [(String, NSRange)] {
        var results = [(String, NSRange)]()
        _findEmail(all: type, inString: strings) {
            results.append($0)
            return true
        }
        return results
    }
    
    class func findPhone(all type: NSTextCheckingResult.CheckingType, in strings: String) -> [(String, NSRange)] {
        var results = [(String, NSRange)]()
        _findPhone(all: type, inString: strings) {
            results.append($0)
            return true
        }
        return results
    }
    
    private class func _find(all type: NSTextCheckingResult.CheckingType, in string: String, iterationClosure: (String) -> Bool) {
        guard let detector = try? NSDataDetector(types: type.rawValue) else { return }
        let range = NSRange(location: 0, length: string.utf16.count)
        let matches = detector.matches(in: string, options: NSRegularExpression.MatchingOptions.reportCompletion, range: range)
        loop: for match in matches {
            for i in 0 ..< match.numberOfRanges {
                let nsrange = match.range(at: i)
                let startIndex = string.index(string.startIndex, offsetBy: nsrange.lowerBound)
                let endIndex = string.index(string.startIndex, offsetBy: nsrange.upperBound)
                let range = startIndex ..< endIndex
                guard iterationClosure(String(string[range])) else { break loop }
            }
        }
    }

    class func find(all type: NSTextCheckingResult.CheckingType, in string: String) -> [String] {
        var results = [String]()
        _find(all: type, in: string) {
            results.append($0)
            return true
        }
        return results
    }

    class func first(type: NSTextCheckingResult.CheckingType, in string: String) -> String? {
        var result: String?
        _find(all: type, in: string) {
            result = $0
            return false
        }
        return result
    }
}

// MARK: String extension
extension String {
    var detectedLinksRange: [(String, NSRange)] { DataDetector.find(all: .link, in: self) }
    var detectedPhoneNumbersRange: [(String, NSRange)] { DataDetector.findPhone(all: .phoneNumber, in: self) }
    var detectedEmailRange: [(String, NSRange)] { DataDetector.findEmail(all: .link, in: self)}
 
    var detectedLinks: [String] { DataDetector.find(all: .link, in: self) }
    var detectedFirstLink: String? { DataDetector.first(type: .link, in: self) }
    var detectedURLs: [URL] { detectedLinks.compactMap { URL(string: $0) } }
    var detectedFirstURL: URL? {
        guard let urlString = detectedFirstLink else { return nil }
        return URL(string: urlString)
    }
    
}
