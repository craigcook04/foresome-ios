//
//  Array+Custom.swift
//  Wedswing
//
//  Created by Rakesh Kumar on 27/06/18.
//  Copyright © 2018 rakesh. All rights reserved.
//

import UIKit

extension Array {
    
    var jsonString: String {
        do {
            let dataObject:Data? = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let data = dataObject {
                let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                if let json = json {
                    return json as String
                }
            }
        } catch {
            print("Error")
        }
        return ""
    }
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    public mutating func appendAtBeginning(newItem : Element) {
        let copy = self
        self = []
        self.append(newItem)
        self.append(contentsOf: copy)
    }
    
}

extension Array where Element: Equatable {
    
    public mutating func removeDuplicate() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
    
    public mutating func remove(element: Element) {
        var result = [Element]()
        for value in self {
            if value != element {
                result.append(value)
            }
        }
        self = result
    }
    
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }

//    func remove(element: Element) -> [Element] {
//        var result = [Element]()
//        for value in self {
//            if value != element {
//                result.append(value)
//            }
//        }
//        return result
//    }
    
}


extension Array {
    mutating func move(fromIndex: Int, toIndex: Int){
        var arr = self
        let element = arr.remove(at: fromIndex)
        arr.insert(element, at: toIndex)
        self = arr
//        let element = self.remove(at: fromIndex)
//        self.insert(element, at: toIndex)
    }
}

extension Array where Element: Comparable {
   var indexOfMax: Index? {
      guard var maxValue = self.first else { return nil }
      var maxIndex = 0

      for (index, value) in self.enumerated() {
         if value > maxValue {
            maxValue = value
            maxIndex = index
         }
     }
     return maxIndex
   }
}

public extension Sequence where Element: Hashable {
    var firstUniqueElements: [Element] {
        var set: Set<Element> = []
        return filter { set.insert($0).inserted }
    }
    
}

extension Dictionary {
    var stringValues: [String] {
        var values = [String]()
        self.values.forEach { value in
            if let val = value as? String {
                values.append(val)
            }
        }
        return values
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
}



extension Dictionary {
    
    func string(forKey:String) -> String? {
        return (self as! JSON)[forKey] as? String
    }
    
    func bool(forKey: String) -> Bool? {
        return (self as! JSON)[forKey] as? Bool
    }
    
    func int(forKey: String) -> Int? {
        return (self as! JSON)[forKey] as? Int
    }
    
    
    func valuefor(key:String) -> JSON? {
        return (self as! JSON)[key] as? JSON
    }
    
//    func getUserData() -> UserData {
//        let dict = (self as? JSON)?["sender"] as? JSON
//        let sender = UserData()
//        sender._id = dict?["_id"] as? String
//        sender.name = dict?["name"] as? String
//        sender.profile_pic = dict?["profile_pic"] as? String
//        return sender
//    }
    
}

