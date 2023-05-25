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
    
    @IBOutlet weak var tournamentTableView: StrachyHeaderTable!
    
    var listTournamentsData =  [TournamentModel]()
    var presenter: TournamentsListPresenterProtocol?
    weak var headerView: TestTableHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
       // getTournmentsData()
        setTableData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        getTournmentsData()
    }
    
    func setTableData() {
        self.tournamentTableView.delegate = self
        self.tournamentTableView.dataSource = self
        tournamentTableView.register(cellClass: TournamentTableCell.self)
        setTableHeader()
    }
    
    func setTableHeader() {
        guard headerView == nil else { return }
        let height: CGFloat = 152
        let view = UIView.initView(view: TestTableHeader.self)
        view.setHeaderData()
        self.tournamentTableView.setStrachyHeader(header: view, height: height)
    }
    
    //MARK: code for get tournamnets dtaa from firebase----------
    func getTournmentsData() {
        ActivityIndicator.sharedInstance.showActivityIndicator()
        let db = Firestore.firestore()
        db.collection("tournaments").getDocuments { (querySnapshot, err) in
            print(err?.localizedDescription)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.tournamentTableCell, for: indexPath) as? TournamentTableCell else{return UITableViewCell()}
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}

extension TournamentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tournamentTableView.setStrachyHeader()
    }
}
