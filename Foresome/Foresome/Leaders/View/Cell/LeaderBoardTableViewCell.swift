//
//  LeaderBoardTableViewCell.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase
import ImageViewer_swift

class LeaderBoardTableViewCell: UITableViewCell {
    @IBOutlet weak var topRankView: UIView!
    @IBOutlet weak var lowRankview: UIView!
    @IBOutlet weak var topRankInnerView: GradientViewWithAngle!
    @IBOutlet weak var rankDetailsHeadings: UIView!
    @IBOutlet weak var rankValue: UILabel!
    @IBOutlet weak var rankerName: UILabel!
    @IBOutlet weak var rankDetailsLabel: UILabel!
    @IBOutlet weak var rankCountLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userProfileSecondSection: UIImageView!
    @IBOutlet weak var secondSectionRankerName: UILabel!
    @IBOutlet weak var secondSectionRankValue: UILabel!
    @IBOutlet weak var secondSectionROneValue: UILabel!
    @IBOutlet weak var secondSectionRTwoValue: UILabel!
    @IBOutlet weak var secondSectionRThreeValue: UILabel!
    
    let firestoreDb = Firestore.firestore()
    var userListData = UserListModel()
    var data = [LeaderBoardDataModel]()
    var dataForLastSection = [LeaderBoardDataModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellLeaderBoardData(data: [LeaderBoardDataModel], tableSection: Int, tableRow: Int, sortByCondition: String, dataForSecondSection:[LeaderBoardDataModel]) {
        self.dataForLastSection = dataForSecondSection
        self.data = data
        if tableSection == 0 {
            lowRankview.isHidden = true
            topRankView.isHidden = false
            switch tableRow {
            case 0:
                self.rankDetailsLabel.text = "R1 \(self.data.filter({$0.rank == 1}).first?.r1 ?? 0) • R2 \(self.data.filter({$0.rank == 1}).first?.r2 ?? 0)"
                let totalScore = (self.data.filter({$0.rank == 1}).first?.r1 ?? 0) + (self.data.filter({$0.rank == 1}).first?.r2 ?? 0)
                if totalScore > 0 {
                    self.rankCountLabel.text = "Total +\(totalScore)"
                } else {
                    self.rankCountLabel.text = "Total \(totalScore)"
                }
                if (self.data.filter({$0.rank == 1}).first?.usersDetails?.name ?? "").count > 0 {
                    self.rankerName.text = self.data.filter({$0.rank == 1}).first?.usersDetails?.name ?? ""
                } else {
                    self.rankerName.text = "N/A"
                }
                if (self.data.filter({$0.rank == 1}).first?.usersDetails?.user_profile_pic?.count ?? 0) > 0 {
                    self.userImageView.image = self.data.filter({$0.rank == 1}).first?.usersDetails?.user_profile_pic?.base64ToImage()
                } else {
                    self.userImageView.image = UIImage(named: "ic_user_placeholder")
                }
                userImageView.setupImageViewer()
                topRankInnerView.firstColor = UIColor(hexString: "#FFDE00")
                topRankInnerView.secondColor = UIColor(hexString: "#FD5900")
                rankValue.text = "1st"
                break
            case 1:
                self.rankDetailsLabel.text = "R1 \(self.data.filter({$0.rank == 2}).first?.r1 ?? 0) • R2 \(self.data.filter({$0.rank == 2}).first?.r2 ?? 0 )"
                if (self.data.filter({$0.rank == 2}).first?.usersDetails?.name ?? "").count > 0 {
                    self.rankerName.text = self.data.filter({$0.rank == 2}).first?.usersDetails?.name ?? ""
                } else {
                    self.rankerName.text = "N/A"
                }
                let totalScore = (self.data.filter({$0.rank == 2}).first?.r1 ?? 0) + (self.data.filter({$0.rank == 2}).first?.r2 ?? 0)
                if totalScore > 0 {
                    self.rankCountLabel.text = "Total +\(totalScore)"
                } else {
                    self.rankCountLabel.text = "Total \(totalScore)"
                }
                if (self.data.filter({$0.rank == 2}).first?.usersDetails?.user_profile_pic?.count ?? 0) > 0 {
                    self.userImageView.image = self.data.filter({$0.rank == 2}).first?.usersDetails?.user_profile_pic?.base64ToImage()
                } else {
                    self.userImageView.image = UIImage(named: "ic_user_placeholder")
                }
                userImageView.setupImageViewer()
                topRankInnerView.firstColor = UIColor(hexString: "#DEDEDE")
                topRankInnerView.secondColor = UIColor(hexString: "#353535")
                rankValue.text = "2nd"
                break
            case 2:
                self.rankDetailsLabel.text = "R1 \(self.data.filter({$0.rank == 3}).first?.r1 ?? 0) • R2 \(self.data.filter({$0.rank == 3}).first?.r2 ?? 0)"
                let totalScore = (self.data.filter({$0.rank == 3}).first?.r1 ?? 0) + (self.data.filter({$0.rank == 3}).first?.r2 ?? 0)
                if totalScore > 0 {
                    self.rankCountLabel.text = "Total +\(totalScore)"
                } else {
                    self.rankCountLabel.text = "Total \(totalScore)"
                }
                if (self.data.filter({$0.rank == 3}).first?.usersDetails?.user_profile_pic?.count ?? 0) > 0 {
                    self.userImageView.image = self.data.filter({$0.rank == 3}).first?.usersDetails?.user_profile_pic?.base64ToImage()
                } else {
                    self.userImageView.image = UIImage(named: "ic_user_placeholder")
                }
                userImageView.setupImageViewer()
                if (self.data.filter({$0.rank == 3}).first?.usersDetails?.name ?? "").count > 0 {
                    self.rankerName.text = self.data.filter({$0.rank == 3}).first?.usersDetails?.name ?? ""
                } else {
                    self.rankerName.text = "N/A"
                }
                topRankInnerView.firstColor = UIColor(hexString: "#FFA28F")
                topRankInnerView.secondColor = UIColor(hexString: "#98230C")
                rankValue.text = "3rd"
                break
            default:
                break
            }
        } else {
            switch sortByCondition {
            case "All":
                //MARK: sorting of data on basis of ranking in greater order data of rank greater than 3 -------
                lowRankview.isHidden = false
                topRankView.isHidden = true
                self.dataForLastSection = self.dataForLastSection.sorted(by: { ($0.rank ?? 0) < ($1.rank ?? 0)})
                let rankerUserId = self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].userId ?? ""
                if rankerUserId.isEmpty == true || rankerUserId.count == 0 {
                    return
                }
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.name ?? "").count > 0 {
                    self.secondSectionRankerName.text = self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.name ?? ""
                } else {
                    self.secondSectionRankerName.text = "N/A"
                }
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.count ?? 0) > 0 {
                    self.userProfileSecondSection.image = self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.base64ToImage()
                } else {
                    self.userProfileSecondSection.image = UIImage(named: "ic_user_placeholder")
                }
                userProfileSecondSection.setupImageViewer()
                self.secondSectionRankValue.text = "#\(self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].rank ?? 0)"
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) == 0 {
                    self.secondSectionROneValue.text = "N/A"
                } else {
                    self.secondSectionROneValue.text = "\(self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0)"
                }
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0) == 0 {
                    self.secondSectionRTwoValue.text = "N/A"
                } else {
                    self.secondSectionRTwoValue.text = "\(self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)"
                }
                let totalRank = "\(((self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) + (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)))"
                self.secondSectionRThreeValue.text = totalRank
                break
            case "Highest score":
                //MARK: sorting of rank listing in case of heighest score-----
                lowRankview.isHidden = false
                topRankView.isHidden = true
                let rankerUserId = self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].userId ?? ""
                if rankerUserId.isEmpty == true || rankerUserId.count == 0 {
                    return
                }
                self.dataForLastSection = self.dataForLastSection.sorted(by: {($0.total ?? 0) > ($1.total ?? 0)})
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.count ?? 0) > 0 {
                    self.userProfileSecondSection.image =  self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.base64ToImage()
                } else {
                    self.userProfileSecondSection.image = UIImage(named: "ic_user_placeholder")
                }
                userProfileSecondSection.setupImageViewer()
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.name ?? "").count > 0 {
                    self.secondSectionRankerName.text = self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.name ?? ""
                } else {
                    self.secondSectionRankerName.text = "N/A"
                }
                self.secondSectionRankValue.text = "#\(self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].rank ?? 0)"
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) == 0 {
                    self.secondSectionROneValue.text = "N/A"
                } else {
                    self.secondSectionROneValue.text = "\(self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0)"
                }
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0) == 0 {
                    self.secondSectionRTwoValue.text = "N/A"
                } else {
                    self.secondSectionRTwoValue.text = "\(self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)"
                }
                let totalRank = "\(((self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) + (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)))"
                self.secondSectionRThreeValue.text = totalRank
                break
            case "Lowest score":
                //MARK: sorting of data on basis of score from lowest score to highest score -----
                lowRankview.isHidden = false
                topRankView.isHidden = true
                let rankerUserId = self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].userId ?? ""
                if rankerUserId.isEmpty == true || rankerUserId.count == 0 {
                    return
                }
                self.dataForLastSection = self.dataForLastSection.sorted(by: {($0.total ?? 0) < ($1.total ?? 0)})
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.count ?? 0) > 0 {
                    self.userProfileSecondSection.image = self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.base64ToImage()
                } else {
                    self.userProfileSecondSection.image = UIImage(named: "ic_user_placeholder")
                }
                userProfileSecondSection.setupImageViewer()
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.name ?? "").count > 0{
                    self.secondSectionRankerName.text = self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.name ?? ""
                } else {
                    self.secondSectionRankerName.text = "N/A"
                }
                self.secondSectionRankValue.text = "#\(self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].rank ?? 0)"
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) == 0 {
                    self.secondSectionROneValue.text = "N/A"
                } else {
                    self.secondSectionROneValue.text = "\(self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0)"
                }
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0) == 0 {
                    self.secondSectionRTwoValue.text = "N/A"
                } else {
                    self.secondSectionRTwoValue.text = "\(self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)"
                }
                let totalRank = "\(((self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) + (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)))"
                self.secondSectionRThreeValue.text = totalRank
                break
            case "Most birdies":
                break
            default:
                lowRankview.isHidden = false
                topRankView.isHidden = true
                let rankerUserId = self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].userId ?? ""
                if rankerUserId.isEmpty == true || rankerUserId.count == 0 {
                    return
                }
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.count ?? 0) > 0 {
                    self.userProfileSecondSection.image = self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.base64ToImage()
                } else {
                    self.userProfileSecondSection.image = UIImage(named: "ic_user_placeholder")
                }
                userProfileSecondSection.setupImageViewer()
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.name ?? "").count > 0 {
                    self.secondSectionRankerName.text =  self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.name ?? ""
                } else {
                    self.secondSectionRankerName.text =  "N/A"
                }
                self.secondSectionRankValue.text = "#\(self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].rank ?? 0)"
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) == 0 {
                    self.secondSectionROneValue.text = "N/A"
                } else {
                    self.secondSectionROneValue.text = "\(self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0)"
                }
                if (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0) == 0 {
                    self.secondSectionRTwoValue.text = "N/A"
                } else {
                    self.secondSectionRTwoValue.text = "\(self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)"
                }
                let totalRank = "\(((self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) + (self.dataForLastSection.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)))"
                self.secondSectionRThreeValue.text = totalRank
                break
            }
            if tableRow == 0 {
                rankDetailsHeadings.isHidden = false
            } else {
                rankDetailsHeadings.isHidden = true
            }
        }
    }
}

