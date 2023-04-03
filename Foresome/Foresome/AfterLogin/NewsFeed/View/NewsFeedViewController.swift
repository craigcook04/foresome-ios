//
//  NewsFeedViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
//

import UIKit

class NewsFeedViewController: UIViewController {

    @IBOutlet weak var newsFeedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableData()
//        let headerView = TournamentHeader(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 176))
//             headerView.imageView.image = UIImage(named: "irina-iriser-1379640-2")
//        self.newsFeedTableView.tableHeaderView = headerView
    }
    func setTableData() {
        self.newsFeedTableView.delegate = self
        self.newsFeedTableView.dataSource = self
        newsFeedTableView.register(cellClass: NewsFeedTableCell.self)
        newsFeedTableView.register(cellClass: TalkAboutTableCell.self)
    }
}
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TalkAboutTableCell", for: indexPath) as? TalkAboutTableCell else {return UITableViewCell()}
            return cell
        }else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableCell", for: indexPath) as? NewsFeedTableCell else {return UITableViewCell()}
            return cell
        }
        return UITableViewCell()
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let sectionHeader = UINib(nibName: "NewsHeader",bundle: nil).instantiateView as! NewsHeader
//        sectionHeader.layoutIfNeeded()
//        return sectionHeader
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 176.0
//    }
}
