//
//  TournamentViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 24/03/23.
//

import UIKit

class TournamentViewController: UIViewController {
    
    var imageData:[UIImage] = [UIImage(named: "cccc")!,UIImage(named: "pex")!,UIImage(named: "cccc")!,UIImage(named: "pex")!,UIImage(named: "cccc")!]
    var titelName = ["MLSE Open","Foresome Scramble","RowanOak Match-Play","Foresome Scramble","Foresome Scramble","Foresome Scramble"]
    var dateData = ["Sat, Apr 29 • 10:00 a.m. EST", "Sat, May 20 • 12:00 p.m. EST", "Sat, Jun 24 • 12:00 p.m. EST", "Sat, Jun 24 • 12:00 p.m. EST", "Sat, Jun 24 • 12:00 p.m. EST"]
    
    @IBOutlet weak var tournamentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableData()
        
    }
    
    func setTableData() {
        self.tournamentTableView.delegate = self
        self.tournamentTableView.dataSource = self
        tournamentTableView.register(cellClass: TournamentTableCell.self)
    }
    
}

extension TournamentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentTableCell", for: indexPath) as? TournamentTableCell else{return UITableViewCell()}
        cell.delegate = self
        cell.imageItem.image = imageData[indexPath.row]
        cell.titleLabel.text = titelName[indexPath.row]
        cell.dateLabel.text = dateData[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UINib(nibName: "TournamentHeader",bundle: nil).instantiateView as! TournamentHeader
        sectionHeader.layoutIfNeeded()
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 136.0
    }
}

extension TournamentViewController: TournamentTableCellDelegate{
    func rightButtonAction() {
        let vc = TournamentDetailViewController()
        self.pushViewController(vc, true)
    }
    
    
}
