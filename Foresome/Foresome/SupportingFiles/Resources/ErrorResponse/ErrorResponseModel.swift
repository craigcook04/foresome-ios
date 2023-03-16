//
//  ErrorResponseModel.swift
//  Pouch
//
//  Created by Raman choudhary on 06/02/23.
//

import Foundation
import ObjectMapper

struct MessageResponse : Mappable {
    var success : Bool?
    var response : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        success <- map["success"]
        response <- map["response"]
    }

}

struct ErrorResponse : Mappable {
    var error : ErrorData?
    var success : Bool?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        error <- map["error"]
        success <- map["success"]
    }
}

struct ErrorData : Mappable {
    var message : String?
    var status_code : Int?
    var code : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        message <- map["message"]
        status_code <- map["status_code"]
        code <- map["code"]
    }

}
