//
//  LeadersViewController.swift
//  Foresome
//
//  Created by Deepanshu on 29/03/23.
//

import UIKit

class LeadersViewController: UIViewController {
    
    @IBOutlet weak var leaderBoardTable: StrachyHeaderTable!
    
    
    weak var headerView: TestTableHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    func setTable() {
        self.leaderBoardTable.delegate = self
        self.leaderBoardTable.dataSource = self
        self.leaderBoardTable.register(cellClass: LeaderBoardTableViewCell.self)
        setTableHeader()
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
            return 3
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(cell: LeaderBoardTableViewCell.self, for: indexPath)
        if indexPath.section == 0 {
            cell.lowRankview.isHidden = true
            cell.topRankView.isHidden = false
            switch indexPath.row {
            case 0:
                cell.topRankInnerView.applyGradientLeftToRight(colours: [UIColor(hexString: "#FD5900"), UIColor(hexString: "#FFDE00")], locations: [0.5])
                break
            case 1:
                cell.topRankInnerView.applyGradientLeftToRight(colours: [UIColor(hexString: "#353535"), UIColor(hexString: "#DEDEDE")], locations: [0.5])
                break
            case 2:
                cell.topRankInnerView.applyGradientLeftToRight(colours: [UIColor(hexString: "#98230C"), UIColor(hexString: "#FFA28F")], locations: [0.5])
                break
            default:
                break
            }
            
        } else {
            cell.lowRankview.isHidden = false
            cell.topRankView.isHidden = true
        }
        return cell
    }
}

extension LeadersViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.leaderBoardTable.setStrachyHeader()
    }
}

extension LeadersViewController: TestTableHeaderDelegate {
    func notificationBtnAction() {
         let vc = FilterViewController()
        self.pushViewController(vc, false)
    }
    
    
}



