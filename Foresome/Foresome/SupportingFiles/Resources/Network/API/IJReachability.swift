//
//  IJReachability.swift
//  Comepriceshop
//
//  Created by Click Labs on 6/23/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

import Foundation


import SystemConfiguration

public enum IJReachabilityType {
  case wwan,
  wiFi,
  notConnected
}

open class IJReachability {
  
  /**
  :see: Original post - http://www.chrisdanielson.com/2009/07/22/iphone-network-connectivity-test-example/
  */
  open class func isConnectedToNetwork() -> Bool {
      
      var zeroAddress = sockaddr_in()
      zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
      zeroAddress.sin_family = sa_family_t(AF_INET)
      //    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
      //        SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
      //    }
      
      let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
          $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
              SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
          }
      }
      
      var flags = SCNetworkReachabilityFlags.connectionAutomatic
      if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
          return false
      }
      let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
      let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
      return (isReachable && !needsConnection)
      
  }
  
//  public class func isConnectedToNetworkOfType() -> IJReachabilityType {
//    
//    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
//    zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
//    zeroAddress.sin_family = sa_family_t(AF_INET)
//    
//    let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
//      SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
//    }
//    
//    var flags: SCNetworkReachabilityFlags = []
//    if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
//      return .NotConnected
//    }
//    
//    let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
//    let isWWAN = (flags.intersect(SCNetworkReachabilityFlags.IsWWAN)) != []
//    //let isWifI = (flags & UInt32(kSCNetworkReachabilityFlagsReachable)) != 0
//    if(isReachable && isWWAN){
//      return .WWAN
//    }
//    if(isReachable && !isWWAN){
//      return .WiFi
//    }
//    return .NotConnected
//    //let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//    //return (isReachable && !needsConnection) ? true : false
//  }
}




class Reachability: NSObject {
    
    static let shared = Reachability()
    static var isChatScreenOpen: Bool = false
    static var last_updated_time: String = ""
    var timer: Timer?
    var lastUpdate: Bool = true
    var setting_data: Bool = false
    var time: Int = 0
    
    override init() {
        super.init()
        self.timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(sendNotificationOfConnection), userInfo: nil, repeats: true)
    }
    
    @objc func sendNotificationOfConnection() {
        let isConnectedToInternet = IJReachability.isConnectedToNetwork()
//        print("check internet connection \(isConnectedToInternet) \(time)")
        if isConnectedToInternet, Self.isChatScreenOpen == false {
//            DBMessagesManger.updateAllPendingMessages()
        }
        //if isConnectedToInternet, (self.time % 3) == 0,
         //  SyncMessagesManager.sync_mode == nil {
//            self.checkLastMessageApi()
            //time = 0
       // }
        time += 1
        guard isConnectedToInternet != lastUpdate else { return }
        lastUpdate = isConnectedToInternet
        //NotificationCenter.default.post(name: .networkConnection, object: isConnectedToInternet, userInfo: nil)
    }
    
    
    
}
