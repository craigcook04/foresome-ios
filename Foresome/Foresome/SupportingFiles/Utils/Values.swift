//
//  Values.swift
//  juglo
//
//  Created by apple on 08/06/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit


typealias JSON = [String: Any]

struct AppStrings {
    
    static let account = "Account"
    static let editProfile = "Edit Profile"
    static let privacy = "Privacy"
    static let notification = "Notification"
    static let notifications = "Notifications"
    static let appNotifications = "App Notifications"
    static let more = "More"
    static let language = "Language"
    static let country = "Country"
    static let emailAddress = "Email Address"
    static let firstName = "First Name"
    static let lastName = "Last Name"
    static let save = "Save"
    static let settings = "Settings"
    static let enterEmail = "Email"
    static let enterLastName = "Last Name"
    static let enterFirstName = "First Name"
    static let title = "Vacation World"
    static let tollFree = "Toll Free Number: 1800 532 2060"
    static let dinnerType = "Food Voucher"
    static let backgroundImage = "membership_bg_img"
    static let code = "Your Code: MA000567"
    static let rsOff = "Rs \nOFF"
    static let hotelName = "This is non transferable coupon"
    static let coupon = "Coupon_ic"
    static let city = "City"
    static let termAndPrivacy = "By using this app you agree to the FORESOME \nTerms of services and Privacy policy."
    static let termsOfService = "Terms of services"
    static let privacyPolicy = "Privacy policy"
    static let titleLabel = "Where are you \nfrom?"
    static let titleLbl = "Forgot Your \nPassword?"
    static let addPictureLbl = "Would you like to add \na profile picture?"
    static let readMore = "Read More"
    static let description = "Thanks to everyone at the first ever Foresome Golf Tournament!! Congrats to the winners Adam Goraieb an hanks to everyone at the first ever Foresome Golf Tournament!! Congrats to the winners Adam Goraieb an"
    static let skillLevel = "Manage skill level"
    static let notificationSetting = "Notification settings"
    static let termsOfServices = "Terms of Services"
    static let aboutApp = "About App"
    static let logout = "Logout"
    static let changeProfilePicture = "Change Profile Picture"
    static let rightArrow = ""
    //MARK: keys for foursome-----
    static let userDatas = "myUserData"
    static let profileUpdated = "Profile updated successfully."
    static let camera = "Camera"
    static let userNameSuffix = "HELLO,"
    static let option = "Option"
    static let reportPost = "Report post"
    static let delete = "Delete"
    static let dismiss = "Dismiss"
    static let selectOption = "Please Select an Option"
    static let posting = "Posting"
    static let selected = "selected..."
    static let of = "selected"
    static let variation = "Variation:"
    static let paymentSuccess =  "Payments successfull."
    static let singlePlayer = "Single Player"
    static let phoneGallery =  "Phone gallery"
    static let foursome = "Foursome"
    static let editProfilePic = "Edit profile picture"
    static let addProfilePic = "Add profile picture"
    static let cad = "CAD"
    static let attendCad =  "Attend CAD"
    static let selectOne = "Select one"
    static let variationMessage = "Please select atleast one variaton."
    static let noAvalibility = "No avalibility."
    static let attendCurrency = "Attend CAD$"
    static let next = "Next"
    static let selectOneSkill = "Please select any one skill Or skip."
    static let uploadOrskipImage = "please upload image or skip"
    static let tutorialTitle1 = "Invite and play together with friends"
    static let tutorialTitle2 = "Invite and play together with friends"
    static let tutorialTitle3 = "Invite and play together with friends"
    static let tutorialDescription1 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi convallis."
    static let tutorialDescription2 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi convallis."
    static let tutorialDescription3 =  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi convallis."
}

struct Messages {
    static let enterEmail = "Please enter your Email ID"
    static let enterValidEmail = "Please enter valid Email ID"
    static let enterPassword = "Please enter your password"
    static let enterConPassword = "Please enter confirm password"
    static let conValidPassword = "Password should be 6 character long"
    static let bothPasswordNotSame = "Password and confirm password are not same"
    static let validPassword = "Password should be 6 characters long"
    static let enterValidPassword = "Please enter valid password"
    static let enterFirstName = "Enter your first name"
    static let enterLastName = "Enter your last name"
    static let enterPhone = "Enter your phone number"
    static let changePasswrodDesc = "Please enter the new password and confirm new password"
    
    static let mediaAddedSuccessfully = "Media added successfully"
    static let documentAddedSuccessfully = "Document added successfully"
    static let areYouSureYouWantToDeleteThisGroup = "Are you sure,\nYou want to delete this group?"
    static let areYouSureYouWantToDeleteThisComment = "Are you sure,\nYou want to delete this comment?"
    static let mediaNotAvailable = "Media not available!"
    static let feedsNotAvailable = "Feeds not available"
    static let noEventMeetingAreFound = "No Events & Meetings \nare found!"
    static let areYouSureYouWantToSubmitThisTask = "Are you sure you want to mark this task completed"
    static let areYouSureYouWantToClearAllNotifications = "Are you sure you want to clear all notifications"
    static let thisPollIsFinishedPleaseCheckResult = "This poll is finished, please check result."
    static let areYouSureYouWantToDeleteThisExpense = "Are you sure you want to delete this expense?"
    static let meetingMissedMesage = "Oops, You missed this Meeting!"
    static let eventMissedMesage = "Oops, You missed this Event!"
    static let pleaseAddYourWorkProfileBeforeSharing = "Please add your work profile before share."
    static let noDataFound = "No data found!"
    //MARK: error message for foursome------
    static let logoutSuccess = "logout successfully."
    static let logoutError = "Unable to logout."
    static let oldPassRequired = "Please fill old password."
    static let confirmPassMatch = "Conform pass not same"
    static let oldPasswordError = "Old password not matched."
    static let passWordFieldError = "password details are not matched."
    static let fillAllDetails = "Please fill all details."
    static let fillAboveDetails =  "please fill above details."
    static let profileImageUpdated = "Profile image updated successfully"
    static let pollAddOptionMsg = "please fill above option first."
    static let pollQuestionsMsg  = "Please ask a question."
    static let pollOptionRequiredMsg =  "Options not allowed to be empty."
    static let pollCreatedMsg = "poll created successfully."
    static let optionsNotSame = "Answer not be same."
    static let postCreated = "post created successfully."
    static let enterFullName = "Please Enter FullName"
    static let enterEmailAdd = "Please Enter an Email"
    static let enterValidEmailAdd  = "Please Enter Valid Email"
    static let passwordLinkSent = "Password reset link send successfully."
    static let invalidEmailPassword = "Invalid email and password"
}

struct ErrorMessage {
    static let enterValidFirstName = "Enter valid first name."
    static let enterValidLastName = "Enter valid last name."
    static let enterValidMoblie = "Enter your mobile number."
    static let enterValidEmail = "Enter your valid email."
    static let enterValidPassword = "Enter valid password."
    static let enterValidOtp = "Enter valid OTP"
    static let enterPhoneNumber = "Enter your phone number"
    static let enterPasswordConfirmPasswordSame = "Enter password and confirm password same."
    static let wrongPaymentInformation = "Wrong payment information. Please try again."
    static let pleaseEnterYourOrdeId = "Please enter your order Id!"
    static let nameIsRequired = "Name is required"
    static let messageIsRequired = "Message is required"
    static let enterValidProfileName = "Enter valid profile name."
    static let selectProductToReturn = "Select product to return"
    static let selectAnyContactForInvite = "Please select at least one contact to Invite"
    static let wrongFileSize = "Accepted file size upto 20mb"
    static let selectLocationOnMap = "Please select location on map"
    static let enterQuestion = "Please ask a question..."
    static let selectStartDate = "Select start date"
    static let selectStartTime = "Select start time"
    static let selectEndTime = "Select end time"
    static let selectEndDate = "Select end date"
    static let enterTitle = "Please enter title"
    static let enterFullName = "Enter full name"
    static let enterEmailId = "Enter email"
    static let enterCorrectEmailId = "Enter correct email"
    static let enterDescription = "Enter description"
    static let addMoreOptions = "Please add more options"
    static let usernameNotAvailable = "Username not available"
    static let pleaseEnterEventTitle = "Please enter Event title"
    static let fileAlreadySaved = "File already saved."
    static let pdfSuccessfullySaved = "PDF successfully saved!"
    static let pdfCouldNotBeSaved = "Pdf could not be saved"
    static let businessDomainHaveWrongFormat = "Business Email ID wrong format"
    static let contactNoIsInvalid = "Contact no is invalid"
    static let websiteLinkHaveWrongFormat = "Website URL wrong format."
    static let pleaseEnterTaskTitle = "Please enter task title"
    static let userNameShouldContainMimum3Characters = "User name should contain minimum 3 characters"
    
    
     
}

extension Int {
    var toString: String {
        return "\(self)"
    }
}

