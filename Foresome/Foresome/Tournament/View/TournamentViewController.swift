//
//  TournamentViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 24/03/23.
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

class TournamentViewController: UIViewController, TournamenstsListViewProtocol {
    
    @IBOutlet weak var tournamentTableView: UITableView!
    
    var listTournamentsData =  [TournamentModel]()
    var presenter: TournamentsListPresenterProtocol?
    var header:TournamentHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tournamentTableView.isScrollEnabled = false
        self.tabBarController?.tabBar.isHidden = false
        getTournmentsData()
        setTableHeader()
        setTableData()
       // self.header = TournamentHeader(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 136))
        //self.header?.imageView.image = UIImage(named: "img_1")
//        let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]

        //self.header?.setHeaderData()
        
        //self.tournamentTableView.tableHeaderView = self.header
    }
    
    func setTableHeader() {
        guard let tableHeader = UINib(nibName: "TournamentHeader", bundle: nil).instantiate(withOwner: self, options: nil).first as? TournamentHeader else { return }
        tableHeader.frame = CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: 136)
        tableHeader.setHeaderData()
        self.tournamentTableView.tableHeader(with: tableHeader)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setTableData() {
        self.tournamentTableView.delegate = self
        self.tournamentTableView.dataSource = self
        tournamentTableView.register(cellClass: TournamentTableCell.self)
        setTableHeader()
    }
    
    //MARK: code for get tournamnets dtaa from firebase----------
    func getTournmentsData() {
        ActivityIndicator.sharedInstance.showActivityIndicator()
        let db = Firestore.firestore()
        db.collection("tournaments").getDocuments { (querySnapshot, err) in
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            querySnapshot?.documents.enumerated().forEach({ (index,document) in
                let tournament =  document.data()
                let tournamentsModel = TournamentModel(json: tournament)
                self.listTournamentsData.append(tournamentsModel)
            })
            self.tournamentTableView.reloadData()
        }
        self.tournamentTableView.reloadData()
    }
}

extension TournamentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTournamentsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentTableCell", for: indexPath) as? TournamentTableCell else{return UITableViewCell()}
        cell.setTournamentsCellData(data: listTournamentsData[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK: code for pass data from tournamnets list to tournamnets details page ---
        let cell = tableView.cellForRow(at: indexPath) as? TournamentTableCell
        if let image = cell?.imageItem.image {
            self.presenter?.passlistDatatoDetails(data: self.listTournamentsData[indexPath.row], tournamentsImage: image)
        }
    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let sectionHeader = UIView.getFromNib(className: TournamentHeader.self)
//        sectionHeader.frame = CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: 136)
//        sectionHeader.layoutIfNeeded()
//        return sectionHeader
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return
//    }
}

extension TournamentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let headerView = self.tournamentTableView.tableHeaderView as! TournamentHeader
        self.header?.scrollViewDidScroll(scrollView: scrollView)
        
        
    }
}
