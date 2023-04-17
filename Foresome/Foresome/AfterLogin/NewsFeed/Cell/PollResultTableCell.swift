//
//  PollResultTableCell.swift
//  Foresome
//
//  Created by Piyush Kumar on 04/04/23.
//

import UIKit
protocol PollResultTableCellDelegate {
    func PollMoreButton()
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
    
    var selectedOption: Int?
    var isAnswer: Bool = false
    var delegate: PollResultTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellData()
        setTableHeight()
        postDescriptionLbl.message = AppStrings.description
        postDescriptionLbl.delegate = self
        postDescriptionLbl.numberOfLines = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellData() {
        self.pollTableView.delegate = self
        self.pollTableView.dataSource = self
        pollTableView.register(cellClass: VoteTableCell.self)
    }
    
    func  setTableHeight() {
        self.tableViewHeight.constant = 4 *  64
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        self.delegate?.PollMoreButton()
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected = !(sender.isSelected)
        likeBtn.setTitle("1", for: .selected)
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
    }
    
    @IBAction func shareAction(_ sender: Any) {
    }
}

extension PollResultTableCell: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isAnswer == true {
            let cell = tableView.dequeue(cellClass: VoteTableCell.self, forIndexPath: indexPath)
            if selectedOption == indexPath.row {
                cell.progressView.backgroundColor = UIColor.appColor(.lightGreen)
                cell.pollView.borderColor = UIColor.appColor(.green_main)
                cell.percentageLabel.isHidden = false
                cell.itemLabel.textAlignment = .left
                let percentage = 24.0
                cell.progressViewWidth.constant = CGFloat((percentage / 100) * Double(Int(cell.pollView.frame.width)))
            }else{
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
            let cell = tableView.dequeue(cellClass: VoteTableCell.self, forIndexPath: indexPath)
            cell.itemLabel.text = "The Masters"
            cell.percentageLabel.isHidden = true
            cell.itemLabel.textAlignment = .center
            cell.pollView.borderColor = UIColor.appColor(.light_Main)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
