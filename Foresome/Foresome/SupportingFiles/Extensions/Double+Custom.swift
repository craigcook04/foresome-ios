//
//  Double+Custom.swift
//  corezone
//
//  Created by apple on 14/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import CFNetwork
import NetworkExtension

extension Double {
    var toDate:Date {
        return Date(timeIntervalSince1970: self/1000)
    }
    
    var toInt:Int {
        return Int(self)
    }
    
    var toString:String {
        return "\(self)"
    }
}

extension Double {
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        let val = self * divisor
        return val.rounded()/divisor
    }
    
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        let val = self * divisor
        return val.rounded()/divisor
    }
    
    var formatPoints: String {
        var thousandNum = self/1000
        var millionNum = self/1000000
        if self >= 1000 && self < 1000000 {
            if(floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))K")
            }
            return("\(thousandNum.roundToPlaces(places: 1))K")
        }
        if self > 1000000 {
            if (floor(millionNum) == millionNum) {
                return("\(Int(thousandNum))K")
            }
            return ("\(millionNum.roundToPlaces(places: 1))M")
        } else {
            if (floor(self) == self) {
                return ("\(Int(self))")
            }
            return ("\(self)")
        }
    }
    
}

extension String {
    
}

extension Int {
    
    func dataInMb(unit: ByteCountFormatter.Units) -> String {
        print("There were \(self) bytes")
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = unit
        // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(self))
        print("formatted result: \(string)")
        return string
    }
    
    var formatPoints: String {
        return Double(self).formatPoints
    }
    
}

//Return IP address of WiFi interface (en0) as a String, or `nil`
//func getWiFiAddress() -> String? {
//
//    var address : String?
//
//    // Get list of all interfaces on the local machine:
//    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
//    if getifaddrs(&ifaddr) == 0 {
//
//        // For each interface ...
//        var ptr = ifaddr
//        while ptr != nil {
//            defer { ptr = ptr.memory.ifa_next }
//
//            let interface = ptr.memory
//
//            // Check for IPv4 or IPv6 interface:
//            let addrFamily = interface.ifa_addr.memory.sa_family
//            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//
//                // Check interface name:
//                if let name = String.fromCString(interface.ifa_name) where name == "en0" {
//
//                    // Convert interface address to a human readable string:
//                    var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
//                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.memory.sa_len),
//                                &hostname, socklen_t(hostname.count),
//                                nil, socklen_t(0), NI_NUMERICHOST)
//                    address = String.fromCString(hostname)
//                }
//            }
//        }
//        freeifaddrs(ifaddr)
//    }
//
//    return address
//}
