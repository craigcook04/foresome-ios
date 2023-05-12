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
    func pollMoreButton(data:PostListDataModel)
    func sharePoll(data:PostListDataModel, pollImage: UIImage)
    func voteInPoll(data:PostListDataModel, isVodeted: Bool, selectedIndex: Int)
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
    
    var selectedOption: Int?
    var isAnswer: Bool = false
    var delegate: PollResultTableCellDelegate?
    var pollData: PostListDataModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellData()
        setTableHeight()
        postDescriptionLbl.message = AppStrings.description
        postDescriptionLbl.delegate = self
        postDescriptionLbl.numberOfLines = 0
    }

    func setCellData() {
        self.pollTableView.delegate = self
        self.pollTableView.dataSource = self
        pollTableView.register(cellClass: VoteTableCell.self)
    }
    
    func setPollCellData(data: PostListDataModel) {
        self.userNameLbl.text = "\(data.author ?? "")"
        self.profileImage.image = data.profileImage.base64ToImage()
        self.postDescriptionLbl.message = data.poll_title
        
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
            self.delegate?.pollMoreButton(data: data)
        }
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected = !(sender.isSelected)
        likeBtn.setTitle("1", for: .selected)
    }
    
    @IBAction func commentAction(_ sender: UIButton) {}
    
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
//        pollData?.selectedAnswer.forEach({ voted in
//            if voted == 1 {
//                self.isAnswer = true
//            } else {
//                self.isAnswer =  false
//            }
//        })
        
        if isAnswer == true {
            if selectedOption == indexPath.row {
                cell.progressView.backgroundColor = UIColor.appColor(.lightGreen)
                cell.pollView.borderColor = UIColor.appColor(.green_main)
                cell.percentageLabel.isHidden = false
                cell.itemLabel.textAlignment = .left
                let percentage = 24.0
                cell.progressViewWidth.constant = CGFloat((percentage / 100) * Double(Int(cell.pollView.frame.width)))
            } else {
                cell.percentageLabel.isHidden = false
                let percentage = 50.0
                cell.progressViewWidth.constant = CGFloat((percentage / 100) * Double(Int(cell.pollView.frame.width)))
                cell.progressView.backgroundColor = UIColor.appColor(.light_Main)
                cell.itemLabel.textAlignment = .left
                cell.percentageLabel.text = "50%"
                cell.pollView.borderColor = UIColor.appColor(.light_Main)
            }
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
//        if let data = self.pollData?.selectedAnswer {
//            data.forEach({ seletedVote in
//                if seletedVote > 0 {
//                    return
//                } else {
//                    self.delegate?.voteInPoll(data: self.pollData ?? PostListDataModel(), isVodeted: true, selectedIndex: indexPath.row)
//                }
//            })
//        }
//        tableView.reloadData()
        
        if self.isAnswer == false {
            self.isAnswer = true
            self.selectedOption = indexPath.row
            tableView.reloadData()
        }
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
 
