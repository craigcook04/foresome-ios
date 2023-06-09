//
//  LeadersViewController.swift
//  Foresome
//
//  Created by Deepanshu on 29/03/23.
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

class LeadersViewController: UIViewController, LeaderBoardViewProtocol {
    
    @IBOutlet weak var leaderBoardTable: StrachyHeaderTable!
    
    weak var headerView: TestTableHeader?
    var presenter: LeaderBoardPresenterProtocol?
    let firestoreDb = Firestore.firestore()
    
    var userListData = UserListModel()
    
    var leaderBoardData = [LeaderBoardDataModel]()
    var allUsersList = [UserListModel]()
    
    var firstThreeUsers = [UserListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLeaderBoardData()
    }
    
    func setTable() {
        self.leaderBoardTable.delegate = self
        self.leaderBoardTable.dataSource = self
        self.leaderBoardTable.register(cellClass: LeaderBoardTableViewCell.self)
        setTableHeader()
    }
    
    func fetchLeaderBoardData() {
        self.leaderBoardData.removeAll()
        self.leaderBoardData = []
        ActivityIndicator.sharedInstance.showActivityIndicator()
        firestoreDb.collection("leaderboard").getDocuments { (querySnapshot, err) in
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            querySnapshot?.documents.enumerated().forEach({ (index, document) in
                print("docs id is ----\(document.documentID)")
                let membersData =  document.data()
                print("membersData is ---\(membersData.description)")
                let leaderBoardData = document.data()
                 
                let leaderBoardModel = LeaderBoardDataModel(json: leaderBoardData)
                self.leaderBoardData.append(leaderBoardModel)
                self.leaderBoardTable.reloadData()
                print("user leader board rank value is ---\(self.leaderBoardData[index].rank ?? 0)")
                
                print("user leader board r1 rank value is ---------\(self.leaderBoardData[index].r1 ?? 0)")
                
                print("user leader board r2 rank value is ---------\(self.leaderBoardData[index].r2 ?? 0)")
                
                self.fetchParticularUserData(userId: self.leaderBoardData[index].userId ?? "")
                
                print("user id in in case of leader rank data -----\(self.leaderBoardData[index].userId ?? "")")
            })
        }
    }
    
    func fetchParticularUserData(userId: String) {
        firestoreDb.collection("users").document(userId).getDocument { (snapData, error) in
            if error == nil {
                if let data = snapData?.data() {
                    print("user name value in case of leaderboard is ---\(data.valuefor(key: "name"))")
                    self.userListData = UserListModel(json: data)
                    self.allUsersList.append(self.userListData)
                    print("user name---\(self.userListData.name ?? "")")
                    print("user uid---\(self.userListData.uid ?? "")")
                    print("user user_skill---\(self.userListData.user_skill_level ?? "")")
                    print("user createdDate---\(self.userListData.createdDate ?? "")")
                    print("user user_location---\(self.userListData.user_location ?? "")")
                    print("user email---\(self.userListData.email ?? "")")
                    self.firstTopRank(data: self.userListData)
                }
            } else {
                if let error = error {
                    Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                }
            }
        }
    }
    
    func firstTopRank(data: UserListModel) {
        print("passed user data is---start")
        print("user data--\(data.name ?? "")")
        print("user data--\(data.email ?? "")")
        print("user data--\(data.uid ?? "")")
        print("passed user data is---end")
    }
    
    func setTableHeader() {
        guard headerView == nil else { return }
        let height: CGFloat = 152
        let view = UIView.initView(view: TestTableHeader.self)
        view.delegate = self
        view.setLeaderBoardHeaderData()
        self.leaderBoardTable.setStrachyHeader(header: view, height: height)
    }
}

extension LeadersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.leaderBoardData.filter({$0.rank ?? 0 < 4 }).count
        } else {
            return self.leaderBoardData.filter({ $0.rank ?? 0 > 3}).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(cell: LeaderBoardTableViewCell.self, for: indexPath)
        if indexPath.section == 0 {
            cell.lowRankview.isHidden = true
            cell.topRankView.isHidden = false
            switch indexPath.row {
            case 0:
                let oneRankUserId = self.leaderBoardData.filter({$0.rank == 1}).first?.userId ?? ""
                firestoreDb.collection("users").document(oneRankUserId).getDocument { (snapData, error) in
                    if error == nil {
                        if let data = snapData?.data() {
                            self.userListData = UserListModel(json: data)
                            cell.rankerName.text = self.userListData.name
                            cell.rankDetailsLabel.text = "R1 \(self.leaderBoardData.filter({$0.rank == 1}).first?.r1 ?? 0) • R2 \(self.leaderBoardData.filter({$0.rank == 1}).first?.r2 ?? 0)"
                            cell.rankCountLabel.text = "Total \((self.leaderBoardData.filter({$0.rank == 1}).first?.r1 ?? 0) + (self.leaderBoardData.filter({$0.rank == 1}).first?.r2 ?? 0))"
                            if (self.userListData.user_profile_pic?.count ?? 0) > 0 {
                                cell.userImageView.image = self.userListData.user_profile_pic?.base64ToImage()
                            }
                        }
                    } else {
                        if let error = error {
                            Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                        }
                    }
                }
                cell.topRankInnerView.firstColor = UIColor(hexString: "#FFDE00")
                cell.topRankInnerView.secondColor = UIColor(hexString: "#FD5900")
                cell.rankValue.text = "1st"
                break
            case 1:
                let secondRankUserId = self.leaderBoardData.filter({$0.rank == 2}).first?.userId ?? ""
                firestoreDb.collection("users").document(secondRankUserId).getDocument { (snapData, error) in
                    if error == nil {
                        if let data = snapData?.data() {
                            self.userListData = UserListModel(json: data)
                            cell.rankerName.text = self.userListData.name
                            cell.rankDetailsLabel.text = "R1 \(self.leaderBoardData.filter({$0.rank == 2}).first?.r1 ?? 0) • R2 \(self.leaderBoardData.filter({$0.rank == 1}).first?.r2 ?? 0)"
                            cell.rankCountLabel.text = "Total \((self.leaderBoardData.filter({$0.rank == 2}).first?.r1 ?? 0) + (self.leaderBoardData.filter({$0.rank == 2}).first?.r2 ?? 0))"
                            if (self.userListData.user_profile_pic?.count ?? 0) > 0 {
                                cell.userImageView.image = self.userListData.user_profile_pic?.base64ToImage()
                            }
                        }
                    } else {
                        if let error = error {
                            Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                        }
                    }
                }
                cell.topRankInnerView.firstColor = UIColor(hexString: "#DEDEDE")
                cell.topRankInnerView.secondColor = UIColor(hexString: "#353535")
                cell.rankValue.text = "2nd"
                break
            case 2:
                let thirdRankUserId = self.leaderBoardData.filter({$0.rank == 3}).first?.userId ?? ""
                firestoreDb.collection("users").document(thirdRankUserId).getDocument { (snapData, error) in
                    if error == nil {
                        if let data = snapData?.data() {
                            self.userListData = UserListModel(json: data)
                            cell.rankerName.text = self.userListData.name
                            cell.rankDetailsLabel.text = "R1 \(self.leaderBoardData.filter({$0.rank == 3}).first?.r1 ?? 0) • R2 \(self.leaderBoardData.filter({$0.rank == 1}).first?.r2 ?? 0)"
                            cell.rankCountLabel.text = "Total \((self.leaderBoardData.filter({$0.rank == 3}).first?.r1 ?? 0) + (self.leaderBoardData.filter({$0.rank == 3}).first?.r2 ?? 0))"
                            if (self.userListData.user_profile_pic?.count ?? 0) > 0 {
                                cell.userImageView.image = self.userListData.user_profile_pic?.base64ToImage()
                            }
                        }
                    } else {
                        if let error = error {
                            Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                        }
                    }
                }
                cell.topRankInnerView.firstColor = UIColor(hexString: "#FFA28F")
                cell.topRankInnerView.secondColor = UIColor(hexString: "#98230C")
                cell.rankValue.text = "3rd"
                break
            default:
                break
            }
        } else {
            cell.lowRankview.isHidden = false
            cell.topRankView.isHidden = true
           let rankerUserId = self.leaderBoardData.filter({($0.rank ?? 0) > 3})[indexPath.row].userId ?? ""
            firestoreDb.collection("users").document(rankerUserId).getDocument { (snapData, error) in
                if error == nil {
                    if let data = snapData?.data() {
                        self.userListData = UserListModel(json: data)
                        if (self.userListData.user_profile_pic?.count ?? 0) > 0 {
                            cell.userProfileSecondSection.image = self.userListData.user_profile_pic?.base64ToImage()
                        }
                        cell.secondSectionRankerName.text = self.userListData.name
                        cell.secondSectionRankValue.text = "#\(self.leaderBoardData.filter({($0.rank ?? 0) > 3})[indexPath.row].rank ?? 0)"
                        cell.secondSectionROneValue.text = "\(self.leaderBoardData.filter({($0.rank ?? 0) > 3})[indexPath.row].r1 ?? 0)"
                        cell.secondSectionRTwoValue.text = "\(self.leaderBoardData.filter({($0.rank ?? 0) > 3})[indexPath.row].r2 ?? 0)"
                        let totalRank = "\((self.leaderBoardData.filter({($0.rank ?? 0) > 3})[indexPath.row].r1 ?? 0 + (self.leaderBoardData.filter({($0.rank ?? 0) > 3})[indexPath.row].r2 ?? 0)))"
                        cell.secondSectionRThreeValue.text = totalRank
                    }
                }
            }
            if indexPath.row == 0 {
                cell.rankDetailsHeadings.isHidden = false
            } else {
                cell.rankDetailsHeadings.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView.initView(view: LeaderBoardSectionHeader.self)
            view.delegate = self
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        } else {
            return 0.001
        }
    }
}

extension LeadersViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.leaderBoardTable.setStrachyHeader()
    }
}

extension LeadersViewController: TestTableHeaderDelegate {
    func notificationBtnAction() {
        let notificationVc = NotificationPresenter.createNotificationModule()
        notificationVc.hidesBottomBarWhenPushed = true
        self.pushViewController(notificationVc, false)
    }
}

extension LeadersViewController: LeaderBoardSectionHeaderDelegate {
    func selectFilter() {
        let filterVc = FilterViewController()
        self.present(filterVc, true)
    }
}

