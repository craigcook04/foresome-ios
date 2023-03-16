//
//  ApiHandler.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 03/04/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import UIKit
import ObjectMapper

class ApiHandler {
    
    static public func call<T>(timeoutInterval: TimeInterval = 20, apiName: String,id:String? = "", params: [String : Any] = [:], httpMethod: API.HttpMethod  = .GET, completion: @escaping (T?,String?) -> ()) where T: Mappable {
        if IJReachability.isConnectedToNetwork() == true {
            var api_name = apiName
            if let _id = id, _id.count > 0{
                api_name = "\(api_name)\(_id)/"
            }
            ActivityIndicator.sharedInstance.showActivityIndicator()
            HttpManager.requestToServer(timeoutInterval: timeoutInterval, api_name, params: params, httpMethod: httpMethod, isZipped: false) { responseData in
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                print("Api_Name:\(apiName)\n Api_request_params:\(params) \n")
                guard let urlResponse = responseData.response as? HTTPURLResponse else {
                    completion(nil, responseData.error?.localizedDescription)
                    return
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: responseData.data ?? Data(), options: .mutableContainers) else{
                    completion(nil, responseData.error?.localizedDescription)
                    return
                }
                print("Api_response:\(String().jsonToPrettyString(json: json))")
                switch urlResponse.statusCode{
                case 200...299:
                    if let jsonResponse = json as? [String: Any] {
                        if  jsonResponse["success"] as? Bool == true{
                            let result = Mapper<T>().map(JSONObject: json)
                            completion(result,nil)
                        }else{
                            let error = Mapper<ErrorResponse>().map(JSONObject: json)
                            completion(nil,error?.error?.message)
                        }
                    }
                case 401:
                    Singleton.shared.logoutFromDevice()
                default:
                    let error = Mapper<ErrorResponse>().map(JSONObject: json)
                    completion(nil,error?.error?.message)
                }
            }
        }else{
            Singleton.shared.showErrorMessage(error: AlertMessage.NO_INTERNET_CONNECTION, isError: .error)
            completion(nil,AlertMessage.NO_INTERNET_CONNECTION)
        }
    }
    
    static public func callWithArrayResponse<T>(timeoutInterval: TimeInterval = 20, apiName: String, params: [String : Any] = [:], httpMethod: API.HttpMethod  = .GET, completion:@escaping ([T]?,String?) -> ()) where T: Mappable {
        if IJReachability.isConnectedToNetwork() == true {
            HttpManager.requestToServer(timeoutInterval: timeoutInterval,apiName, params: params, httpMethod: httpMethod, isZipped: false) { responseData in
                guard let urlResponse = responseData.response as? HTTPURLResponse else {
                    completion(nil, responseData.error?.localizedDescription)
                    return
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: responseData.data ?? Data(), options: .mutableContainers) else{
                    completion(nil, responseData.error?.localizedDescription)
                    return
                }
                print("Api_Name:\(apiName)\n Api_request_params:\(params) \nApi_response:\(String().jsonToPrettyString(json: json))")
                switch urlResponse.statusCode{
                case 200...299:
                    let result = Mapper<T>().mapArray(JSONObject: json)
                    completion(result,nil)
                case 401:
                    Singleton.shared.logoutFromDevice()
                default:
                    let error = Mapper<ErrorResponse>().map(JSONObject: json)
                    print("error:\(error)")
                    completion(nil,error?.error?.message)
                }
            }
        }else{
            Singleton.shared.showErrorMessage(error: AlertMessage.NO_INTERNET_CONNECTION, isError: .error)
            completion(nil,AlertMessage.NO_INTERNET_CONNECTION)
        }
    }
}
