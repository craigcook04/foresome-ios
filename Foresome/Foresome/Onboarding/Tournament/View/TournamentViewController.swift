//
//  TournamentViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 24/03/23.
//

import UIKit
import StrechableHeader
import GSKStretchyHeaderView



class TournamentViewController: UIViewController, FTDelegate, GSKStretchyHeaderViewStretchDelegate {
    func stretchyHeaderView(_ headerView: GSKStretchyHeaderView, didChangeStretchFactor stretchFactor: CGFloat) {
         
    }
    
    func didMaskViewAlphaChange(alpha: CGFloat) {
         
    }
    
    //var stretchyHeader: GSKStretchyHeaderView!
    
    var stretchyHeader: GSKStretchyHeaderView!
    var imageData:[UIImage] = [UIImage(named: "cccc")!,UIImage(named: "cccc")!,UIImage(named: "cccc")!,UIImage(named: "cccc")!,UIImage(named: "cccc")!,UIImage(named: "cccc")!]
    var titelName = ["MLSE Open","Foresome Scramble","RowanOak Match-Play","MLSE Open","Foresome Scramble","RowanOak Match-Play"]
    var dateData = ["Sat, Apr 29 • 10:00 a.m. EST", "Sat, May 20 • 12:00 p.m. EST", "Sat, Jun 24 • 12:00 p.m. EST","Sat, Apr 29 • 10:00 a.m. EST", "Sat, May 20 • 12:00 p.m. EST", "Sat, Jun 24 • 12:00 p.m. EST"]
    
    @IBOutlet weak var tournamentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableData()
//        stretchyHeader.stretchDelegate = self
//        let headerSize = CGSize(width: self.tournamentTableView.frame.size.width,
//                                height: 200) // 200 will be the default height
//        self.stretchyHeader = GSKStretchyHeaderView(frame: CGRect(x: 0, y: 0,
//                                                                          width: headerSize.width,
//                                                                          height: headerSize.height))
//        self.stretchyHeader.stretchDelegate = self // this is completely optional
//        self.tournamentTableView.addSubview(self.stretchyHeader)
    }
    
    func setTableData() {
        self.tournamentTableView.delegate = self
        self.tournamentTableView.dataSource = self
        tournamentTableView.stickyHeader.delegate  = self
        tournamentTableView.register(cellClass: TournamentTableCell.self)
        setTableHeader()
    }
    
    func setTableHeader() {
        guard let tableHeader = UINib(nibName: "TournamentHeader", bundle: nil).instantiate(withOwner: self, options: nil).first as? TournamentHeader else{return}
//        tableHeader.frame = CGRect(x: 0, y: 0, width: self.whatsNewTableView.frame.width, height: 121)
        tableHeader.frame = CGRect(x: 0, y: 0, width: self.tournamentTableView.frame.width, height: 125)
        let view = UIView()
        view.frame = tableHeader.bounds
        view.backgroundColor = .green
        view.addSubview(tableHeader)
        //tournamentTableView.stickyHeader.view = view
        
        let nibViews = Bundle.main.loadNibNamed("TournamentHeader", owner: self, options: nil)
//        self.stretchyHeader = view as? GSKStretchyHeaderView
//        self.tournamentTableView.addSubview(self.stretchyHeader)
        
        self.tournamentTableView.tableHeaderView = view
        //self.tournamentTableView.setStrechHeader(tableHeader, withNaviBarHidden: true)
    }
}

extension TournamentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentTableCell", for: indexPath) as? TournamentTableCell else{return UITableViewCell()}
        cell.imageItem.image = imageData[indexPath.row]
        cell.titleLabel.text = titelName[indexPath.row]
        cell.dateLabel.text = dateData[indexPath.row]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let sectionHeader = UINib(nibName: "TournamentHeader",bundle: nil).instantiateView as! TournamentHeader
//
//        return sectionHeader
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 136.0
    }
}
