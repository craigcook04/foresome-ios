//
//  FilterViewController.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit

protocol FilterViewControllerDelegate {
    func returnSelectedCategory(name: String)
    func selectedFilterAndSortOption(friendName: String, tournamentId: String, sortingOption: String)
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var filterTableView: UITableView!
    
    var selectedIndex: Int?
    var delegate: FilterViewControllerDelegate?
    var friendNameForFilter: String?
    var tournamentId: String?
    
    var isResetFilter: Bool = false
    
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
        self.isResetFilter = true
        self.selectedIndex = nil
        self.filterTableView.reloadData()
    }
    
    @IBAction func applyAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: {
            if let delegate = self.delegate {
                delegate.returnSelectedCategory(name: FilterData.sortByData[self.selectedIndex ?? 0])
                delegate.selectedFilterAndSortOption(friendName: self.friendNameForFilter ?? "", tournamentId: self.tournamentId ?? "", sortingOption: FilterData.sortByData[self.selectedIndex ?? 0])
            }
        })
    }
}

extension FilterViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 3
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
        cell.delegate = self
        if isResetFilter == true {
            cell.resetFilterAndSorting()
        }
        cell.tournamentsIndex = indexPath.row
        cell.addPickerView()
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
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        UserDefaults.standard.set(indexPath.row as? Int, forKey: "selectedFilter")
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

extension FilterViewController : FilterTableViewCellDelegate {
    func getUpdatedText(filterBy: String, index: Int) {
        print("index of filter text fields is ---\(index)")
        if index == 0 {
            print("filter by name is ----\(filterBy)")
            self.friendNameForFilter = filterBy
        } else {
            print("filter by tournaments is ---\(filterBy)")
            self.tournamentId = filterBy
        }
    }
}





