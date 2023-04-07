//
//  Constants.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 30/03/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import UIKit

let SCREEN_SIZE = UIScreen.main.bounds
var statusBarStyle: UIStatusBarStyle = .lightContent

struct FreshChatCredential{
    static let app_Id = "98c44002-62bc-4cef-90e8-21aa2d6968e8"
    static let app_key = "1a8f35bf-35c9-40b0-98a6-150e3338d04d"
    static let domain = "msdk.in.freshchat.com"
    
}


struct STORYBOARD_ID {
    static let loginNavigation = "LoginNavigation"
    static let homeNavigation = "HomeNavigation"
    static let homeTabbarController = "HomeTabbarController"
    static let otpVerifyController = "OtpVerifyController"
    static let signupCompletedController = "SignupCompletedController"
    static let walkThrew2Controller = "WalkThrew2Controller"
    static let mobileSignupController = "MobileSignupController"
    static let chatListingController = "ChatListingController"
    static let profileController = "ProfileController"
    static let dashboardNavigation = "DashboardNavigation"
    static let meetingsNavigation = "MeetingNavigation"
    static let chatNavigation = "ChatNavigation"
    static let profileNavigation = "ProfileNavigation"
}

struct cellIdentifier {
    
    static let profileImageCollectionViewCell = "ProfileImageCollectionViewCell"
    static let countryTableCell = "CountryTableCell"
    static let freshStartNewChallengeCollectionCell = "FreshStartNewChallengeCollectionCell"
    static let upgradeNowCollectionViewCell  = "UpgradeNowCollectionViewCell"
    static let quoteOfDayCollectionViewCell  = "QuoteOfDayCollectionViewCell"
    static let successReportCollectionViewCell = "SuccessReportCollectionViewCell"
    static let overAllSuccessRateCollectionCell = "OverAllSuccessRateCollectionCell"
    static let pollOfTheWeakCollectionCell = "PollOfTheWeakCollectionCell"
    static let tipOfTheDayCollectionCell = "TipOfTheDayCollectionCell"
    static let awardsCollectionViewCell = "AwardsCollectionViewCell"
    static let profileOverviewTableViewCell = "ProfileOverviewTableViewCell"
    static let awardsDataCollectionCell = "AwardsDataCollectionCell"
    static let profileOverVIewCollectionViewCell = "ProfileOverVIewCollectionViewCell"
    static let pollOfTheWaekTableViewCell = "PollOfTheWaekTableViewCell"
    
    static let recentChallengeCollectionCell = "RecentChallengeCollectionCell"
    static let challengeOverviewCollectionCell = "ChallengeOverviewCollectionCell"
    static let challengeDetailsCollectionCell = "ChallengeDetailsCollectionCell"
    static let habitMainListCollectionCell = "HabitMainListCollectionCell"
    static let habitMainSearchCollectionCell = "HabitMainSearchCollectionCell"
    static let customChooseIconCollectionCell = "CustomChooseIconCollectionCell"
    static let challengeFilterTableCell = "ChallengeFilterTableCell"
    static let habitMainSearchTableCell = "HabitMainSearchTableCell"
    static let challengesTableCell = "ChallengesTableCell"
    static let challengeNameCollectionCell = "ChallengeNameCollectionCell"
    static let challengeDetailDaysCell = "ChallengeDetailDaysCell"
    static let challengeDetailLevelCell = "ChallengeDetailLevelCell"
    static let challengeDetailTimeCell = "ChallengeDetailTimeCell"
    static let challengeSetCollectionCell = "ChallengeSetCollectionCell"
    static let challengeDetailTimeLineCell = "ChallengeDetailTimeLineCell"
    static let challengeDaySummaryTableCell = "ChallengeDaySummaryTableCell"
    static let challengeDaySummaryPhotoCell = "ChallengeDaySummaryPhotoCell"
    static let manageMoodCollectonCell = "ManageMoodCollectonCell"
    static let challengeDaySummaryNotesCell = "ChallengeDaySummaryNotesCell"
    static let challengeDayMoodMeterCell = "ChallengeDayMoodMeterCell"
    static let accountTablePerformersCell = "AccountTablePerformersCell"
    static let accountGlobalTopPerformersTableCell = "AccountGlobalTopPerformersTableCell"
    static let accountUserLevelCell = "AccountUserLevelCell"
    static let cyclingChallengeCollectionCell = "CyclingChallengeCollectionCell"
    static let leaderBoardPerformerTableCell = "LeaderBoardPerformerTableCell"
    static let leaderBoardPositionsTableCell = "LeaderBoardPositionsTableCell"
    static let leaderBoardInstructionsTableCell = "LeaderBoardInstructionsTableCell"
    static let leaderBoardRankingTablecell = "LeaderBoardRankingTablecell"
    static let awardsScoreCardTableViewCell = "AwardsScoreCardTableViewCell"
    static let awardGainedTableViewCell = "AwardGainedTableViewCell"
    static let awardsEarnedEmptyStateTableCell = "AwardsEarnedEmptyStateTableCell"

    static let challengeDegtailAwardsColectionCell = "ChallengeDegtailAwardsColectionCell"
    static let challengeDayNameSummaryTableCell = "ChallengeDayNameSummaryTableCell"
    static let verifyAccountStepsTitleCell = "VerifyAccountStepsTitleCell"
    static let verifyAccountStepsDetailTableCell = "VerifyAccountStepsDetailTableCell"
    
    static let challengesEmptyViewCell = "ChallengesEmptyViewCell"
    
    
    

    static let publicProfileInfoTableCell = "PublicProfileInfoTableCell"
    static let publicProfileChallengeOverviewTableCell = "PublicProfileChallengeOverviewTableCell"
    static let publicProfileAwardsTableCell = "PublicProfileAwardsTableCell"
    static let whatsNewTableCell = "WhatsNewTableCell"
    
   

    
}


struct NIB_NAME {
    static let errorView = "ErrorView"
    static let homeTableHeader = "HomeTableHeader"
    static let profileHeaderView = "ProfileHeaderView"
    static let profileSectionHeader = "ProfileSectionHeader"
    static let documentCollectionSectionView = "DocumentCollectionSectionView"
    static let createPollTableHeader = "CreatePollTableHeader"
    static let profileDetailTableHeader = "ProfileDetailTableHeader"
    static let editShareProfileHeader = "EditShareProfileHeader"
    static let fileDocumentSectionHeader = "FileDocumentSectionHeader"
    static let challengeDaySummaryTableHeader =
    "ChallengeDaySummaryTableHeader"
    
}

struct DEVICE_TYPE {
    static let appVersion = "1.0"
    
}

//struct STORYBOARD {
//    static let main = "Main"
//    static let login = "Login"
//}

enum STORYBOARD : String {
    case main = "Main"
    case login = "Login"
}

enum ERROR_TYPE {
    case error
    case success
    case message
    case notification
}

struct HEIGHT {
    static let errorMessageHeight: CGFloat = 43.0
    static let navigationHeight: CGFloat = 190 + getTopInsetofSafeArea + UIApplication.shared.statusBarFrame.height
    
    static var getTopInsetofSafeArea: CGFloat {
        guard let topInset = Singleton.shared.window?.safeAreaInsetsForAllOS.top else {return 0}
        if topInset > 0 {
            return topInset - 20
        }
        return topInset
    }
    
    static var getBottomInsetofSafeArea:CGFloat {
        let topInset = Singleton.shared.window?.safeAreaInsetsForAllOS.bottom ?? 0
        if topInset > 0 {
            return topInset
        }
        return topInset
    }
}

extension UINib {
    convenience public init(nibName:String) {
        self.init(nibName: nibName, bundle: nil)
    }
    
}
