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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellLeaderBoardData(data: [LeaderBoardDataModel], tableSection: Int, tableRow: Int, sortByCondition: String) {
        self.userImageView.setupImageViewer()
        self.userProfileSecondSection.setupImageViewer()
        self.data = data
        if tableSection == 0 {
            lowRankview.isHidden = true
            topRankView.isHidden = false
            switch tableRow {
            case 0:
                let oneRankUserId = data.filter({$0.rank == 1}).first?.userId ?? ""
                firestoreDb.collection("users").document(oneRankUserId).getDocument { (snapData, error) in
                    if error == nil {
                        if let data = snapData?.data() {
                            self.userListData = UserListModel(json: data)
                            self.rankerName.text = self.userListData.name
                            self.rankDetailsLabel.text = "R1 \(self.data.filter({$0.rank == 1}).first?.r1 ?? 0) • R2 \(self.data.filter({$0.rank == 1}).first?.r2 ?? 0)"
                            let totalScore = (self.data.filter({$0.rank == 1}).first?.r1 ?? 0) + (self.data.filter({$0.rank == 1}).first?.r2 ?? 0)
                            if totalScore > 0 {
                                self.rankCountLabel.text = "Total +\(totalScore)"
                            } else {
                                self.rankCountLabel.text = "Total \(totalScore)"
                            }
                            if (self.userListData.user_profile_pic?.count ?? 0) > 0 {
                                self.userImageView.image = self.userListData.user_profile_pic?.base64ToImage()
                            }
                        }
                    } else {
                        if let error = error {
                            Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                        }
                    }
                }
                topRankInnerView.firstColor = UIColor(hexString: "#FFDE00")
                topRankInnerView.secondColor = UIColor(hexString: "#FD5900")
                rankValue.text = "1st"
                break
            case 1:
                let secondRankUserId = self.data.filter({$0.rank == 2}).first?.userId ?? ""
                firestoreDb.collection("users").document(secondRankUserId).getDocument { (snapData, error) in
                    if error == nil {
                        if let data = snapData?.data() {
                            self.userListData = UserListModel(json: data)
                            self.rankerName.text = self.userListData.name
                            self.rankDetailsLabel.text = "R1 \(self.data.filter({$0.rank == 2}).first?.r1 ?? 0) • R2 \(self.data.filter({$0.rank == 1}).first?.r2 ?? 0 )"
                            let totalScore = (self.data.filter({$0.rank == 2}).first?.r1 ?? 0) + (self.data.filter({$0.rank == 2}).first?.r2 ?? 0)
                            if totalScore > 0 {
                                self.rankCountLabel.text = "Total +\(totalScore)"
                            } else {
                                self.rankCountLabel.text = "Total \(totalScore)"
                            }
                            if (self.userListData.user_profile_pic?.count ?? 0) > 0 {
                                self.userImageView.image = self.userListData.user_profile_pic?.base64ToImage()
                            }
                        }
                    } else {
                        if let error = error {
                            Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                        }
                    }
                }
                topRankInnerView.firstColor = UIColor(hexString: "#DEDEDE")
                topRankInnerView.secondColor = UIColor(hexString: "#353535")
                rankValue.text = "2nd"
                break
            case 2:
                let thirdRankUserId = self.data.filter({$0.rank == 3}).first?.userId ?? ""
                firestoreDb.collection("users").document(thirdRankUserId).getDocument { (snapData, error) in
                    if error == nil {
                        if let data = snapData?.data() {
                            self.userListData = UserListModel(json: data)
                            self.rankerName.text = self.userListData.name
                            self.rankDetailsLabel.text = "R1 \(self.data.filter({$0.rank == 3}).first?.r1 ?? 0) • R2 \(self.data.filter({$0.rank == 3}).first?.r2 ?? 0)"
                            let rankThreeR1 = (self.data.filter({$0.rank == 3}).first?.r1 ?? 0)
                            let rankThreeR2 = (self.data.filter({$0.rank == 3}).first?.r2 ?? 0)
                            print("rank three r1 value---\(rankThreeR1)")
                            print("rank three r2 value---\(rankThreeR2)")
                            let totalScore = (self.data.filter({$0.rank == 3}).first?.r1 ?? 0) + (self.data.filter({$0.rank == 3}).first?.r2 ?? 0)
                            if totalScore > 0 {
                                self.rankCountLabel.text = "Total +\(totalScore)"
                            } else {
                                self.rankCountLabel.text = "Total -\(totalScore)"
                            }
                            if (self.userListData.user_profile_pic?.count ?? 0) > 0 {
                                self.userImageView.image = self.userListData.user_profile_pic?.base64ToImage()
                            }
                        }
                    } else {
                        if let error = error {
                            Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                        }
                    }
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
                //MARK: sorting of data on basis of ranking in greater order-------
                self.data.forEach({ useFetchedData in
                    print("hello user details ----\(useFetchedData.usersDetails?.name ?? "")")
                })
                lowRankview.isHidden = false
                topRankView.isHidden = true
                self.data = self.data.sorted(by: { ($0.rank ?? 0) < ($1.rank ?? 0)})
                let rankerUserId = self.data.filter({($0.rank ?? 0) > 3})[tableRow].userId ?? ""
                if rankerUserId.isEmpty == true || rankerUserId.count == 0 {
                    return
                }
                self.secondSectionRankerName.text = self.data.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.name ?? ""
                if (self.data.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.count ?? 0) > 0 {
                    self.userProfileSecondSection.image = self.data.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.base64ToImage()
                }
                self.secondSectionRankValue.text = "#\(self.data.filter({($0.rank ?? 0) > 3})[tableRow].rank ?? 0)"
                print("index path value is ---\(tableRow)")
                print("rank value acc to table row index ---\(self.data.filter({$0.rank ?? 0 > 3})[tableRow].rank ?? 0)")
                if (self.data.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) == 0 {
                    self.secondSectionROneValue.text = "N/A"
                } else {
                    self.secondSectionROneValue.text = "\(self.data.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0)"
                }
                if (self.data.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0) == 0 {
                    self.secondSectionRTwoValue.text = "N/A"
                } else {
                    self.secondSectionRTwoValue.text = "\(self.data.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)"
                }
                let totalRank = "\(((self.data.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) + (self.data.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)))"
                self.secondSectionRThreeValue.text = totalRank
                break
            case "Highest score":
                //MARK: sorting of rank listing in case of heighest score-----
                lowRankview.isHidden = false
                topRankView.isHidden = true
                let rankerUserId = self.data.filter({($0.rank ?? 0) > 3})[tableRow].userId ?? ""
                if rankerUserId.isEmpty == true || rankerUserId.count == 0 {
                    return
                }
                self.data = self.data.sorted(by: {($0.total ?? 0) > ($1.total ?? 0)})
                if (self.data.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.count ?? 0) > 0 {
                    self.userProfileSecondSection.image =  self.data.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.base64ToImage()
                }
                self.secondSectionRankerName.text = self.data.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.name ?? ""
                self.secondSectionRankValue.text = "#\(self.data.filter({($0.rank ?? 0) > 3})[tableRow].rank ?? 0)"
                if (self.data.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) == 0 {
                    self.secondSectionROneValue.text = "N/A"
                } else {
                    self.secondSectionROneValue.text = "\(self.data.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0)"
                }
                if (self.data.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0) == 0 {
                    self.secondSectionRTwoValue.text = "N/A"
                } else {
                    self.secondSectionRTwoValue.text = "\(self.data.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)"
                }
                let totalRank = "\(((self.data.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) + (self.data.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)))"
                self.secondSectionRThreeValue.text = totalRank
                break
            case "Lowest score":
                //MARK: sorting of data on basis of score from lowest score to highest score -----
                lowRankview.isHidden = false
                topRankView.isHidden = true
                let rankerUserId = self.data.filter({($0.rank ?? 0) > 3})[tableRow].userId ?? ""
                if rankerUserId.isEmpty == true || rankerUserId.count == 0 {
                    return
                }
                self.data = self.data.sorted(by: {($0.total ?? 0) < ($1.total ?? 0)})
                
                if (self.data.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.count ?? 0) > 0 {
                    self.userProfileSecondSection.image = self.data.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.base64ToImage()
                }
                self.secondSectionRankerName.text = self.data.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.name ?? ""
                self.secondSectionRankValue.text = "#\(self.data.filter({($0.rank ?? 0) > 3})[tableRow].rank ?? 0)"
                if (self.data.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) == 0 {
                    self.secondSectionROneValue.text = "N/A"
                } else {
                    self.secondSectionROneValue.text = "\(self.data.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0)"
                }
                if (self.data.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0) == 0 {
                    self.secondSectionRTwoValue.text = "N/A"
                } else {
                    self.secondSectionRTwoValue.text = "\(self.data.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)"
                }
                let totalRank = "\(((self.data.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) + (self.data.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)))"
                self.secondSectionRThreeValue.text = totalRank
                break
            case "Most birdies":
                break
            default:
                lowRankview.isHidden = false
                topRankView.isHidden = true
                let rankerUserId = self.data.filter({($0.rank ?? 0) > 3})[tableRow].userId ?? ""
                if rankerUserId.isEmpty == true || rankerUserId.count == 0 {
                    return
                }
                if (self.data.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.count ?? 0) > 0 {
                    self.userProfileSecondSection.image = self.data.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.user_profile_pic?.base64ToImage()
                }
                self.secondSectionRankerName.text =  self.data.filter({($0.rank ?? 0) > 3})[tableRow].usersDetails?.name ?? ""
                self.secondSectionRankValue.text = "#\(self.data.filter({($0.rank ?? 0) > 3})[tableRow].rank ?? 0)"
                if (self.data.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) == 0 {
                    self.secondSectionROneValue.text = "N/A"
                } else {
                    self.secondSectionROneValue.text = "\(self.data.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0)"
                }
                if (self.data.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0) == 0 {
                    self.secondSectionRTwoValue.text = "N/A"
                } else {
                    self.secondSectionRTwoValue.text = "\(self.data.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)"
                }
                let totalRank = "\(((self.data.filter({($0.rank ?? 0) > 3})[tableRow].r1 ?? 0) + (self.data.filter({($0.rank ?? 0) > 3})[tableRow].r2 ?? 0)))"
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

