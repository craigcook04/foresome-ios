//
//  StrachyHeaderTable.swift
//  CarCharger
//
//  Created by hitesh on 27/01/21.
//

import UIKit

class StrachyHeaderTable: UITableView {

    var headerHeight: CGFloat = 80.0
    var view: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = .green
    }
    
    func setStrachyHeader(header view: UIView, height: CGFloat) {
        self.tableHeaderView = nil
        self.headerHeight = height
        self.view = view
        self.view?.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: height)
        self.addSubview(self.view!)
        self.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        self.contentOffset = CGPoint(x: 0, y: -headerHeight)
        self.layoutIfNeeded()
    }
    
    func setStrachyHeader() {
        var headerRect = CGRect(x: 0, y: -headerHeight, width: self.bounds.width, height: headerHeight)
        if self.contentOffset.y < -headerHeight {
            headerRect.origin.y = self.contentOffset.y
            headerRect.size.height = -self.contentOffset.y
        } else {
        }
        self.view?.frame = headerRect
    }
}

class StrachyHeaderCollection: UICollectionView {
    var headerHeight: CGFloat = 250.0
    let header = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(header)
    }
    
    func setStrachyHeader(header view: UIView, height: CGFloat) {
        self.headerHeight = height
        header.frame = CGRect(x: 0, y: -height, width: SCREEN_SIZE.width, height: height)
        view.frame = header.bounds
        header.addSubview(view)
        self.contentInset = UIEdgeInsets(top: -height, left: 0, bottom: 0, right: 0)
        self.contentOffset = CGPoint(x: 0, y: -headerHeight)
        self.layoutIfNeeded()
    }
    
    func setStrachyHeader() {
        var headerRect = CGRect(x: 0, y: -headerHeight, width: self.bounds.width, height: headerHeight)
        if self.contentOffset.y < -headerHeight {
            headerRect.origin.y = self.contentOffset.y
            headerRect.size.height = -self.contentOffset.y
        }
        self.header.frame = headerRect
    }
}


//            print("first ********** \(self.contentOffset.y)")
//        print("headerRect ********** \(self.contentOffset.y)")
//            if self.contentOffset.y < 0, self.contentOffset.y > -headerHeight {
//                self.contentOffset.y = self.contentOffset.y
//                print("second ********** \(self.contentOffset.y)")
//            } else {
//                print("third ********** \(self.contentOffset.y)")
//            }
//            self.contentOffset = CGPoint(x: 0, y: -headerHeight


class StrachyHeaderTableView: UIView {
    
    var headerView: UIView!
    var tableView: UITableView!
    var headerHeight: CGFloat = 80.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setStrachyHeader(header view: UIView, height: CGFloat) {
        self.tableView.tableHeaderView = nil
        self.headerView = view
        
        self.headerHeight = height
        self.addSubview(self.headerView!)
        
        self.tableView = UITableView()
        self.addSubview(self.headerView!)
        self.addSubview(self.tableView!)
        
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.headerView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        self.headerView.bottomAnchor.constraint(equalTo: self.tableView!.topAnchor).isActive = true
        
        self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
//        self.view.frame = CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: height)
        
//        self.view = UIView(height: height)
//        self.view.backgroundColor = .gray
        
//        self.addSubview(self.view!)
//
//        self.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
//        self.contentOffset = CGPoint(x: 0, y: -headerHeight)
    }
    
    func setStrachyHeader() {
        var headerRect = CGRect(x: 0, y: -headerHeight, width: self.bounds.width, height: headerHeight)
        if self.tableView.contentOffset.y < -headerHeight {
            headerRect.origin.y = self.tableView.contentOffset.y
            headerRect.size.height = -self.tableView.contentOffset.y
        } else {
        }
        self.headerView.frame = headerRect
    }
}
