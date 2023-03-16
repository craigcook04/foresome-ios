//
//  Validator.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 03/04/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import UIKit

class Validator {
    
// ABCDEFGHIJKLMNOPQRSTUVWXYZ - ABCDEFGHIJKLMNOPQRSTUVWXYZ
    
    static let alphaNumericRegex = "-abcdefghijklmnopqrstuvwxyz_1234567890"
    
    
    static public func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let isValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
        return isValid
    }
    
    static public func validateAccountId(id:String) -> Bool {
        let regex = "^[a-z-A-Z]{6}+[0-9]{2}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: id)
    }
    
    static public func validateName(name: String) -> Bool {
        guard name != "" else {
            return false
        }
        return true
    }
    
    static public func validateLastName(lastName: String) -> Bool {
        guard lastName != "" else {
            return false
        }
        return true
    }
    
    static public func validatePhoneNumber(number: String?) -> (Bool, String) {
        guard let phone = number, phone.count > 0 else {
            return (false, "Please enter phone number")
        }
        guard phone.count > 6 && phone.count < 14 else {
            return (false, "Please enter valid phone number")
        }
        return (true, "")
    }
    
    static public func validatePassword(password:String?) -> (Bool,String) {
        guard let pwd = password, pwd.count > 0 else {
            return (false,"Please enter your password")
        }
        guard pwd.count >= 6 else {
            return (false, "Password should be 6 characters long")
        }
        return (true, "")
    }
    
}


extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
    
    func isAlphanumeric(ignoreDiacritics: Bool = false) -> Bool {
        if ignoreDiacritics {
            return self.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil && self != ""
        } else {
            return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
        }
    }
    
    
    
}
