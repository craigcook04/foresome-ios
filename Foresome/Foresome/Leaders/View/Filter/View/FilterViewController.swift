//
//  FilterViewController.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit

class FilterViewController: UIViewController {

    
    @IBOutlet weak var filterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableData()
    }
    
    func setTableData() {
        
        filterTableView.delegate =  self
        filterTableView.dataSource =  self
        filterTableView.register(cellClass: FilterTableViewCell.self)
        //filterTableView.register(UINib(nibName: "FilterSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "FilterSectionHeader")
        
    }
}


extension FilterViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(cell: FilterTableViewCell.self, for: indexPath)
        if  indexPath.section == 0 {
            cell.sortView.isHidden = true
            cell.filterView.isHidden = false
        } else {
            cell.sortView.isHidden = false
            cell.filterView.isHidden = true
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = self.filterTableView.dequeueReusableHeaderFooterView(withIdentifier: "FilterSectionHeader" ) as? FilterSectionHeader
//       // headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56)
//        return headerView
//
        
        let view = UIView.initView(view: FilterSectionHeader.self)
        view.delegate = self
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
}

extension FilterViewController : FilterSectionHeaderDelegate {
    func closeBtnAction() {
        self.dismiss(animated: false)
    }
}



