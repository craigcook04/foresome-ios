//
//  UserData.swift
//  NiftyExpert
//
//  Created by MAC on 17/04/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit
//class UserModel: Codable {
//    var statusCode: Int?
//    var message: String?
//    var data: UserData?
//}

//class UserData: Codable {
//    var access_token:String?
//    var email:String?
//    var _id: String?
//    var name: String?
//    var profile_pic: String?
//    var country_code:String?
//    var phone_no:String?
//    var user_name:String?
//    var invite_code:String?
//    var status: Status?
//    var last_seen: String?
//    var timezone: String?
//
//    var update: Int?
//    var bio: String?
//    var gender: String?
//    var dob: String?
//    var facebook_url: String?
//    var twitter_url: String?
//    var instagram_url: String?
//    var linked_in_url: String?
//    var vaccination_status: String?
//    var upi_id: String?
//    var selected: Bool?
//
//    init() {
//    }
//
//}

//extension UserData {
//
//    convenience init(_id: String?) {
//        self.init()
//        self._id = _id
//    }
//
//    convenience init(url: String?) {
//        self.init()
//        self.profile_pic = url
//    }
//
//}

class ImageEntity: Codable {
    var statusCode: Int?
    var message: String?
    var data: ResponseData?
}

class ResponseData: Codable {
    var thumbnail:String?
    var s3Url: String?
    var fileName:String?
}

class ImageModel: NSObject {

//    class func uploadDocument(data: Data, key: API.DataKey = .dataKey, file_name: String, to_be_replaced: Bool, progress:((_ progress: URLSessionProgress)->())?,  complitionHandler: @escaping(_ image: ResponseData) -> ()) {
////        var params = JSON()
////        params["access_token"] = UserDefaultsCustom.getAccessToken()
////        params["file_name"] = file_name
////        params["to_be_replaced"] = to_be_replaced
////        print("file upload json is \(params)")
//        
////        FileUploader().upload(API.Name.fileUpload, params: params, dataArray: [], dataKey: "", progress: nil) { response in
////            DispatchQueue.main.async {
////                if response.succeeded == true {
//                    ImageModel.fileUploader(data: data, file_name: file_name, to_be_replaced: to_be_replaced, progress: progress, complitionHandler: complitionHandler)
////                } else {
////                    ImageModel.showErrorController(response: response, data: data, file_name: file_name, progress: progress, complitionHandler: complitionHandler)
////                }
////            }
////        }
//    }
    
//    class func fileUploader(data: Data, key: API.DataKey = .dataKey, file_name: String, to_be_replaced: Bool, progress:((_ progress: URLSessionProgress)->())?,  complitionHandler: @escaping(_ image: ResponseData) -> ()) {
//        
//        var params = JSON()
//        params["access_token"] = UserDefaultsCustom.getAccessToken()
//        params["file_name"] = file_name
////        params["to_be_replaced"] = to_be_replaced
//        
//        print("json to upload file \(params)")
//        
//        FileUploader().upload(API.Name.fileUpload, params: params, dataArray: [data], dataKey: key.rawValue, progress: progress) { response in
//            DispatchQueue.main.async {
//                if response.succeeded == true {
//                    guard let data = response.data else { return }
//                    do {
//                        let decoder = JSONDecoder()
//                        let jsonResponse = try decoder.decode(ImageEntity.self, from: data)
//                        guard let data = jsonResponse.data else {return}
//                        data.fileName = file_name
//                        complitionHandler(data)
//                    } catch let err {
//                        print(err)
//                    }
//                } else {
//                    if let message = response.response["message"] as? String {
////                        if message == "File name already exists" {
////                            FileUploadErrorPopupVC.presentFileUploadErrorVC(data: data, file_name: file_name, progress: progress, complitionHandler: complitionHandler)
////                        } else {
////                            Singleton.shared.showErrorMessage(error: message, isError: .error)
////                        }
//                    }
//                    progress?((progress: -1, totalBytes: -1, bytesSent: -1, task: nil))
//                }
//            }
//        }
//    }
//
}
