//
//  HttpManager.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 03/04/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import UIKit


typealias SERVER_RESPONSE = (data:Data?, response:URLResponse?,error:Error? )



class HttpManager: NSObject {
    static public func requestToServer(timeoutInterval: TimeInterval = 20,  _ url: String, params: [String:Any], httpMethod: API.HttpMethod, isZipped: Bool, receivedResponse:@escaping (SERVER_RESPONSE) -> ()){
        var urlString = url
        if httpMethod == .GET, params.count > 0{
            urlString = urlString.query_params(params: params) ?? ""
        }else{
            urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        }
        guard let requestUrl = URL(string: API.host + urlString) else{return}
        var request = URLRequest(url: requestUrl )
        print(request.url?.absoluteString ?? "")
        print("param:\(params)")
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = timeoutInterval
        print("timeout interval:\(request.timeoutInterval)")
        if let accessToken = UserDefaultsCustom.getAccessToken(){
            request.setValue("\(accessToken)", forHTTPHeaderField: "Authorization")
            print(accessToken)
        }
        request.setValue("IOS", forHTTPHeaderField: "platform")
        if(httpMethod == API.HttpMethod.POST
           || httpMethod == API.HttpMethod.PUT
           || httpMethod == API.HttpMethod.DELETE) {
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            if isZipped == false {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } else {
                request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
                request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Encoding: gzip")
            }
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            receivedResponse((data,response,error))
        }//dataTask(with: request) {data, response, error in
//            receivedResponse((data,response,error))
//        }
        task.resume()
    }
    
}
