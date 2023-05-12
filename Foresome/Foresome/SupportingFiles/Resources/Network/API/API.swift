//
//  API.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 03/04/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import UIKit


class API {
    //    DEV HOST
    static let imageHost = "http://www.21by90.com/api/"
    static let host = "http://testio.pouch.club/"
    
    
    static let deviceType = "Ios"
    static let version = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String).numeralsOnly.toString
    
    enum DataKey: String {
        case dataKey = "pic"
        case image = "image"
    }
    
    struct Name {
        static let login_Init = "login/init/"
        static let login_attempt = "login/attempt"
        static let logout = "logout"
        
    }
    
    struct keys {
        static let access_token = "access_token"
        static let country_code = "country_code"
        static let phone_no = "phone_no"
        static let otp = "otp"
        static let device_type = "device_type"
        static let device_token = "device_token"
        static let email = "email"
        static let device_id = "device_id"
    }
    
    enum HttpMethod: String {
        case POST = "POST"
        case GET = "GET"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    struct statusCodes {
        static let INVALID_ACCESS_TOKEN = 401
        static let BAD_REQUEST = 400
        static let UNAUTHORIZED_ACCESS = 401
        static let SHOW_MESSAGE = 201
        static let SHOW_DATA = 1
        static let SLOW_INTERNET_CONNECTION = 999
    }
    
}

struct AlertMessage {
    static let INVALID_ACCESS_TOKEN = "Product is being used on another device"
    static let SERVER_NOT_RESPONDING = "Oops... Network issue, Please try again!"
    //        "Something went wrong while connecting to server!"
    static let NO_INTERNET_CONNECTION = "Unable to connect with the server. Check your internet connection and try again."
    static let pleaseEnter = "Please enter "
    static let invalidEmailId = "Please enter valid email id."
    static let enterEmailId = "Please enter email id."
    static let invalidPassword = "Please enter correct password."
    static let invalidPhoneNumber = "Please enter valid phone."
    static let invalidPasswordLength = "Password must contain atleast 6 characters"
    static let logoutAlert = "Are you sure you want to logout?"
    static let imageWarning = "The image we have showed above is for reference purpose. Actual car could be slightly different."
    static let emptyMessage = " can not be empty."
    static let bookingCreated = "Booking created successfully"
    static let passwordMismatch = "New password and confirm password does not match."
    static let passwordChangedSuccessfully = "Password changed successfully."
    static let pleaseEnterValid = "Please enter valid "
    static let transactionSuccessful = "Your transaction was successful"
    static let PROFILE_SAVED = "Profile has been saved successfully"
}

struct ERROR_MESSAGE {
    static let NO_CAMERA_SUPPORT = "This device does not support camera"
    static let NO_GALLERY_SUPPORT = "Photo library not found in this device."
    static let REJECTED_CAMERA_SUPPORT = "Need permission to open camera"
    static let REJECTED_GALLERY_ACCESS = "Need permission to open Gallery"
    static let SOMETHING_WRONG = "Oops... Network issue, Please try again!"
    //"Something went wrong. Please try again."
    static let NO_INTERNET_CONNECTION = "Unable to connect with the server. Check your internet connection and try again."
    static let SERVER_NOT_RESPONDING = "Oops... Network issue, Please try again!"
    //        "Something went wrong while connecting to server!"
    static let INVALID_ACCESS_TOKEN = "Invalid Access Token"
    static let ALL_FIELDS_MANDATORY = "All Fields Mandatory"
    static let CALLING_NOT_AVAILABLE = "Calling facility not available on this device."
}

