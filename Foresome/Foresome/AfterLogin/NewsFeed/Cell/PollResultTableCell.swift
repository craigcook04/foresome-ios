//
//  PollResultTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 04/04/23.
//

import UIKit
import FirebaseStorage
import FirebaseCore
import Firebase

protocol PollResultTableCellDelegate {
    func pollMoreButton(data:PostListDataModel, index: Int)
    func sharePoll(data:PostListDataModel, pollImage: UIImage)
    func voteInPoll(data:PostListDataModel, isVodeted: Bool, selectedIndex: Int, currentPostIndex: Int)
    func likePostDatas(data:PostListDataModel, isLiked: Bool)
    func commmnetsPoll(data:PostListDataModel, isCommented: Bool, index:Int)
}

class PollResultTableCell: UITableViewCell {
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pollTableView: UITableView!
    @IBOutlet weak var postDescriptionLbl: ExpendableLinkLabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var numberOfVotesLabel: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var outerView: UIView!
    
    var selectedOption: Int  = 0
    var isAnswer: Bool = false
    var delegate: PollResultTableCellDelegate?
    var pollData: PostListDataModel?
    var  votePercentage : Int?
    var assignPercentage: Double?
    var currentIndex: Int? 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellData()
        setTableHeight()
        //postDescriptionLbl.message = AppStrings.description
        postDescriptionLbl.delegate = self
        postDescriptionLbl.numberOfLines = 0
    }

    func setCellData() {
        self.pollTableView.delegate = self
        self.pollTableView.dataSource = self
        pollTableView.register(cellClass: VoteTableCell.self)
    }
    
    func setPollCellData(data: PostListDataModel) {
        //self.numberOfVotesLabel.text = "\(data.voted_user_list.count) votes • Poll ended"
        
        self.numberOfVotesLabel.text = "\(data.voted_user_list.count) votes"
         
        self.userNameLbl.text = "\(data.author ?? "")"
        self.profileImage.image = data.profileImage.base64ToImage()
        self.postDescriptionLbl.message = data.poll_title
        self.commentBtn.setTitle("\(data.comments?.count ?? 0)", for: .normal)
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        for i in 0..<(data.voted_user_list.count) {
            print("voted user id ---\(data.voted_user_list[i])")
            print("my user id is ----\((strings?["uid"] as? String ) ?? "")")
            if data.voted_user_list[i] == (strings?["uid"] as? String ) ?? "" {
                self.isAnswer = true
                //self.tableView?.reloadData()
                self.tableView?.beginUpdates()
                self.tableView?.endUpdates()
            } else {
                self.isAnswer = false
            }
        }
        
        for i in 0..<data.selectedAnswerCount.count {
            print("selected answer count is---\(data.selectedAnswerCount[i])")
        }
        
        for i in 0..<data.selectedAnswer.count {
            print("selected anser is ----\(data.selectedAnswer[i])")
        }
        
        self.pollData = data
        guard let postDate = data.createdAt?.millisecToDate() else {
            return
        }
        let calendar = Calendar.current
        let diff = calendar.dateComponents([.minute, .hour, .day, .year], from: postDate, to: Date())
        if diff.year == 0 {
            if postDate.isToday {
                if diff.hour ?? 0 < 1 {
                    if diff.minute ?? 0 < 1 {
                        self.timeLbl.text = "just now"
                    } else {
                        self.timeLbl.text = "\(diff.minute ?? 0) mins"
                    }
                } else {
                    self.timeLbl.text = "\(diff.hour ?? 0) hrs"
                }
            } else if postDate.isYesterday {
                self.timeLbl.text =  "Yesterday"
            } else {
                self.timeLbl.text = postDate.toStringFormat()
            }
        } else {
            self.timeLbl.text = postDate.toStringFormat()
        }
    }
    
    func  setTableHeight() {
        //self.tableViewHeight.constant = 4 *  64
        if let data = pollData {
            if let tableHeight = data.poll_options?.count {
                self.tableViewHeight.constant = CGFloat((tableHeight *  64))
            }
        }
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        if let data = self.pollData {
            self.delegate?.pollMoreButton(data: data, index: indexPath?.row ?? 0)
        }
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected = !(sender.isSelected)
        //likeBtn.setTitle("1", for: .selected)
        self.delegate?.likePostDatas(data: self.pollData ?? PostListDataModel(), isLiked: sender.isSelected)
        if sender.isSelected == true {
            self.likeBtn.setTitle("\((self.pollData?.likedUserList.count ?? 0) + 1)", for: .normal)
        } else {
            self.likeBtn.setTitle("\((self.pollData?.likedUserList.count ?? 0) + 0)", for: .normal)
        }
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
        if let data = self.pollData {
            self.delegate?.commmnetsPoll(data: data, isCommented: true, index: indexPath?.row ?? 0)
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        var image :UIImage?
        let currentLayer = outerView.layer
        let currentScale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(outerView.bounds.size, false, currentScale)
        guard let currentContext = UIGraphicsGetCurrentContext() else {return}
        currentLayer.render(in: currentContext)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let img = image else { return }
        if let data = self.pollData {
            self.delegate?.sharePoll(data: data, pollImage: img)
        }
    }
}

extension PollResultTableCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pollData?.poll_options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: code added by deep----
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VoteTableCell", for: indexPath) as? VoteTableCell else {
            return UITableViewCell()
        }
        
//        pollData?.voted_user_list.forEach({ votedUserId in
//            if let pollVotedUserId = self.pollData?.uid {
//                if votedUserId == pollVotedUserId {
//                    self.isAnswer = true
//                } else {
//                    self.isAnswer = false
//                }
//            }
//        })
         
        print("selectedanser array---\(self.pollData?.selectedAnswer)")
        print("selectedanser count array----\(self.pollData?.selectedAnswerCount)")
        print("self.pollData?.voted_user_list-----\(self.pollData?.voted_user_list)")
        
        if isAnswer == true {
            self.votePercentage = 0
            self.pollData?.selectedAnswerCount.forEach({ elements in
                votePercentage = (votePercentage ?? 0) + elements
            })
            
            if self.pollData?.selectedAnswerCount.count ?? 0 > 0 {
                self.assignPercentage = Double((Double(self.pollData?.selectedAnswerCount[indexPath.row] ?? 0) ) / Double((self.votePercentage) ?? 0))
            }
//            } else {
//
//            }
            
//            self.assignPercentage = Double((Double(self.pollData?.selectedAnswerCount[indexPath.row] ?? 0) ) / Double((self.votePercentage) ?? 0))
//
             
            if (pollData?.selectedAnserIndex ?? 0) == indexPath.row {
                cell.progressView.backgroundColor = UIColor.appColor(.lightGreen)
                cell.pollView.borderColor = UIColor.appColor(.green_main)
                cell.percentageLabel.isHidden = false
                cell.itemLabel.textAlignment = .left
                //cell.progressViewWidth.constant = CGFloat(((self.assignPercentage ?? 0.0)) * Double(Int(cell.pollView.frame.width)))
                
                //cell.pollView.frame.width
                
            } else {
                cell.percentageLabel.isHidden = false
                //cell.progressViewWidth.constant = CGFloat(((self.assignPercentage ?? 0.0)) * Double(Int(cell.pollView.frame.width)))
                
                cell.progressView.backgroundColor = UIColor.appColor(.light_Main)
                cell.itemLabel.textAlignment = .left
                cell.pollView.borderColor = UIColor.appColor(.light_Main)
            }
            
            cell.progressViewWidth.constant = (cell.pollView.frame.width * (self.assignPercentage ?? 0.0)) - 32
            print("asssignned percent ---\(self.assignPercentage ?? 0.0)")
             
            
            cell.percentageLabel.text = "\(((self.assignPercentage ?? 0.0) * 100).roundTo(places: 2)) %"
            cell.itemLabel.text = self.pollData?.poll_options?[indexPath.row] ?? ""
           // cell.layoutSubviews()
            return cell
        } else {
            cell.itemLabel.text = self.pollData?.poll_options?[indexPath.row] ?? ""
            cell.percentageLabel.isHidden = true
            cell.itemLabel.textAlignment = .center
            cell.pollView.borderColor = UIColor.appColor(.light_Main)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAnswer == true {
           // Singleton.shared.showMessage(message: "Already voted.", isError: .error)
            return
        } else {
            self.delegate?.voteInPoll(data: self.pollData ?? PostListDataModel(), isVodeted: true, selectedIndex: indexPath.row, currentPostIndex: self.currentIndex ?? 0)
        }
        
        
//        if let data = self.pollData?.selectedAnswerCount {
//            data.forEach({ seletedVote in
//                if seletedVote > 0 {
//                    return
//                } else {
//                    self.delegate?.voteInPoll(data: self.pollData ?? PostListDataModel(), isVodeted: true, selectedIndex: indexPath.row)
//                }
//            })
//        }
        //tableView.reloadData()
        
//        if self.isAnswer == false {
//            self.isAnswer = true
//            self.selectedOption = indexPath.row
//            tableView.reloadData()
//        }
    }
}

extension PollResultTableCell: ExpendableLinkLabelDelegate {
    func tapableLabel(_ label: ExpendableLinkLabel, didTapUrl url: String, atRange range: NSRange) {
    }
    
    func tapableLabel(_ label: ExpendableLinkLabel, didTapString string: String, atRange range: NSRange) {
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
    }
}
 
