//
//  FilterViewController.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var filterTableView: UITableView!
    
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableData()
    }
    
    func setTableData() {
        filterTableView.delegate =  self
        filterTableView.dataSource =  self
        filterTableView.register(cellClass: FilterTableViewCell.self)
    }
    
    @IBAction func resetAction(_ sender: UIButton) {
        self.dismiss(animated: false)
    }

    @IBAction func applyAction(_ sender: UIButton) {
        self.dismiss(animated: false)
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
            cell.searchField.placeholder = FilterData.filterArray[indexPath.row].filterPlaceHolder
            cell.filterIcon.setImage(FilterData.filterArray[indexPath.row].filterByIcon, for: .normal)
            
        } else {
            cell.sortView.isHidden = false
            cell.filterView.isHidden = true
            cell.sortByLabel.text = FilterData.sortByData[indexPath.row]
            cell.setCellData(isSelected: selectedIndex == indexPath.row)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.initView(view: FilterSectionHeader.self)
        view.delegate = self
        if section == 0 {
            view.closeButton.isHidden = false
            view.headerTitle.text = "Filter by"
        } else {
            view.closeButton.isHidden = true
            view.headerTitle.text = "Sort by"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        for i in 0..<4 {
            print("reloading index is ---\(i)")
            let reloadIndex = IndexPath(row: i, section: 1)
            self.filterTableView.reloadRows(at: [reloadIndex], with: .none)
        }
    }
}

extension FilterViewController : FilterSectionHeaderDelegate {
    func closeBtnAction() {
        self.dismiss(animated: true)
    }
}



