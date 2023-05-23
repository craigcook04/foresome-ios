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
    @IBOutlet weak var pollTableView: AutoResizeTableView!
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
        postDescriptionLbl.delegate = self
        postDescriptionLbl.numberOfLines = 0
    }

    func setCellData() {
        self.pollTableView.delegate = self
        self.pollTableView.dataSource = self
        pollTableView.register(cellClass: VoteTableCell.self)
    }
    
    func setPollCellData(data: PostListDataModel, index: Int) {
        self.pollData = data
        self.currentIndex = index
        setTableHeight()
        self.numberOfVotesLabel.text = "\(data.voted_user_list?.count ?? 0) votes"
        self.userNameLbl.text = "\(data.author ?? "")"
        self.profileImage.image = data.profileImage?.base64ToImage()
        self.postDescriptionLbl.message = data.poll_title ?? ""
        self.commentBtn.setTitle("\(data.comments?.count ?? 0)", for: .normal)
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        for i in 0..<(data.voted_user_list?.count ?? 0) {
            print("voted user id ---\(data.voted_user_list?[i] ?? "")")
            print("my user id is ----\((strings?["uid"] as? String ) ?? "")")
            if data.voted_user_list?[i] == (strings?["uid"] as? String ) ?? "" {
                self.isAnswer = true
                print("isvoted in if case is --==\(self.isAnswer)")
                self.tableView?.beginUpdates()
                self.tableView?.endUpdates()
            } else {
                print("isvoted in else case is --==\(self.isAnswer)")
                self.isAnswer = false
            }
        }
        
        for i in 0..<(data.selectedAnswerCount?.count ?? 0) {
            print("selected answer count is---\(data.selectedAnswerCount?[i] ?? 0)")
        }
        
        for i in 0..<(data.selectedAnswer?.count ?? 0) {
            print("selected anser is ----\(data.selectedAnswer?[i] ?? 0)")
        }
        //MARK: code for set date diffrent diffrent formats----
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
        self.pollTableView.layoutSubviews()
        self.pollTableView.layoutIfNeeded()
        self.layoutIfNeeded()

//        DispatchQueue.main.async {
//            self.pollTableView.reloadData()
//           // self.pollTableView.invalidateIntrinsicContentSize()
//        }
    }
    
    func  setTableHeight() {
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
        print("more action called in case of poll.")
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected = !(sender.isSelected)
        self.delegate?.likePostDatas(data: self.pollData ?? PostListDataModel(), isLiked: sender.isSelected)
        if sender.isSelected == true {
            self.likeBtn.setTitle("\((self.pollData?.likedUserList?.count ?? 0) + 1)", for: .normal)
        } else {
            self.likeBtn.setTitle("\((self.pollData?.likedUserList?.count ?? 0) + 0)", for: .normal)
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
        if isAnswer == true {
            self.votePercentage = 0
            self.pollData?.selectedAnswerCount?.forEach({ elements in
                votePercentage = (votePercentage ?? 0) + elements
            })
            if self.pollData?.selectedAnswerCount?.count ?? 0 > 0 {
                self.assignPercentage = Double((Double(self.pollData?.selectedAnswerCount?[indexPath.row] ?? 0) ) / Double((self.votePercentage) ?? 0))
            }
            if (pollData?.selectedAnserIndex ?? 0) == indexPath.row {
                cell.progressView.backgroundColor = UIColor.appColor(.lightGreen)
                cell.pollView.borderColor = UIColor.appColor(.green_main)
                cell.percentageLabel.isHidden = false
                cell.itemLabel.textAlignment = .left
            } else {
                cell.percentageLabel.isHidden = false
                cell.progressView.backgroundColor = UIColor.appColor(.light_Main)
                cell.itemLabel.textAlignment = .left
                cell.pollView.borderColor = UIColor.appColor(.light_Main)
            }
            cell.progressViewWidth.constant = (cell.pollView.frame.width * (self.assignPercentage ?? 0.0)) - 32
            print("asssignned percent ---\(self.assignPercentage ?? 0.0)")
            cell.percentageLabel.text = "\(((self.assignPercentage ?? 0.0) * 100).roundTo(places: 2)) %"
        } else {
            cell.percentageLabel.isHidden = true
            cell.itemLabel.textAlignment = .center
            cell.pollView.borderColor = UIColor.appColor(.light_Main)
        }
        cell.itemLabel.text = self.pollData?.poll_options?[indexPath.row] ?? ""
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAnswer == true {
            return
        } else {
            self.delegate?.voteInPoll(data: self.pollData ?? PostListDataModel(), isVodeted: true, selectedIndex: indexPath.row, currentPostIndex: self.currentIndex ?? 0)
        }
    }
}

extension PollResultTableCell: ExpendableLinkLabelDelegate {
    func tapableLabel(_ label: ExpendableLinkLabel, didTapUrl url: String, atRange range: NSRange) {
        print("url is equal to ---\(url)")
    }
    
    func tapableLabel(_ label: ExpendableLinkLabel, didTapString string: String, atRange range: NSRange) {
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
    }
}
