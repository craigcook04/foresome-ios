//
//  NewsFeedViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var newsFeedTableView: UITableView!
    
    var presenter: NewsFeedPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableData()
    }
    
    func setTableData() {
        self.newsFeedTableView.delegate = self
        self.newsFeedTableView.dataSource = self
        newsFeedTableView.register(cellClass: NewsFeedTableCell.self)
        newsFeedTableView.register(cellClass: TalkAboutTableCell.self)
        newsFeedTableView.register(cellClass: PollResultTableCell.self)
        newsFeedTableView.contentInset = UIEdgeInsets(top: -28, left: 0, bottom: 0, right: 0)
        
    }
}
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TalkAboutTableCell", for: indexPath) as? TalkAboutTableCell else {return UITableViewCell()}
            return cell
        }else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PollResultTableCell", for: indexPath) as? PollResultTableCell else{return UITableViewCell()}
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableCell", for: indexPath) as? NewsFeedTableCell else {return UITableViewCell()}
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.getFromNib(className: NewsHeader.self)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
}
extension NewsFeedViewController: NewsFeedViewProtocol {
    
}
