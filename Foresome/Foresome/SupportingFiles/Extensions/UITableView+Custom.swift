//
//  UITableView+Custom.swift
//  meetwise
//
//  Created by hitesh on 30/09/20.
//  Copyright © 2020 hitesh. All rights reserved.
//

import UIKit

internal extension UITableView {
    
    func registerCell(identifier: String) {
        self.register(UINib(nibName:identifier, bundle:nil), forCellReuseIdentifier: identifier)
    }
    
    func registerCell(class identifier: AnyClass) {
        let id = String(describing: identifier)
        let nib = UINib(nibName:id, bundle:nil)
        self.register(nib, forCellReuseIdentifier: String(describing: identifier))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cell Class: T.Type, for indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: Class), for: indexPath)
        return cell as! T
    }
    
    func register<T: UITableViewCell>(cellClass: T.Type) {
        register(UINib(nibName:String(describing: cellClass.self), bundle:nil), forCellReuseIdentifier: String(describing: cellClass.self))
    }
    
    func dequeue<T: UITableViewCell>(cellClass: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: cellClass.self)) as? T
    }
    
    func dequeue<T: UITableViewCell>(cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        print("identifiername:\(String(describing: cellClass.self))")
        guard let cell = dequeueReusableCell(
            withIdentifier: String(describing: cellClass.self), for: indexPath) as? T else {
                fatalError(
                    "Error: cell with id: \(String(describing: cellClass.self)) for indexPath: \(indexPath) is not \(T.self)")
            }
        return cell
    }
    
    func setBackgroundView(message: String) {
        let label = UILabel()
        label.text = message
        label.textColor = UIColor.placeholderColor
        label.textAlignment = .center
        label.font = UIFont.setCustom(.poppinsMedium, 24)
        label.center = CGPoint(x: self.center.x, y: self.center.y - 150)
        label.numberOfLines = 5
        self.backgroundView = label
    }
    
    //MARK: table view background view with some modifications------
    func setBackgroundWithCustomView(message: String) {
        let view = UIView(frame: self.bounds)
        let label = UILabel()
        label.text = message
        label.textColor = UIColor.placeholderColor
        label.textAlignment = .center
        label.font = UIFont.setCustom(.poppinsMedium, 24)
        label.frame = CGRect(x: 0, y: 110, width: SCREEN_SIZE.width, height: 100)
        label.numberOfLines = 5
        view.addSubview(label)
        self.backgroundView = view
    }
    
    func setTableBackgroundView(message: String, color:UIColor? = .white, fontName: FONT_NAME = .SFProDisplay_Bold, fontSize: CGFloat = 14) {
        let label = UILabel()
        label.setLabel(message, color, fontName, fontSize)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.center = CGPoint(x: self.center.x, y: self.center.y - 150)
        self.backgroundView = label
    }
    
    func tableHeader(with view:UIView) {
        let headerView = UIView()
        headerView.frame = view.bounds
        headerView.addSubview(view)
        self.tableHeaderView = headerView
    }
    
    func tableFooter(with view: UIView?) {
        let headerView = UIView()
        headerView.frame = view!.bounds
        headerView.addSubview(view!)
        self.tableFooterView = headerView
    }
    
    func insertRow(at indexPath: IndexPath, animation: RowAnimation = .none) {
        self.beginUpdates()
        self.insertRows(at: [indexPath], with: animation)
        self.endUpdates()
    }
    
    func insertRows(at indexPaths: [IndexPath], animation: RowAnimation = .none) {
        self.beginUpdates()
        self.insertRows(at: indexPaths, with: animation)
        self.endUpdates()
    }
    
    func reload(row:Int, animation: UITableView.RowAnimation = .automatic) {
        self.reloadRows(at: [IndexPath(row: row, section: 0)], with: animation)
    }
    
    func reloads(rows:[Int], animation: UITableView.RowAnimation = .automatic) {
        var indexs = [IndexPath]()
        rows.forEach { row in
            indexs.append(IndexPath(row: row, section: 0))
        }
        guard indexs.count > 0 else {return}
        self.reloadRows(at: indexs, with: animation)
    }
    
    func reload(indexPath:IndexPath, animation: UITableView.RowAnimation = .automatic) {
        self.reloadRows(at: [indexPath], with: animation)
    }
    
    func reload(section: Int, animation: UITableView.RowAnimation = .automatic) {
        self.reloadSections(IndexSet(integer: section), with: animation)
    }
    
    func reloadWithNoAnimation(section: Int, animation: UITableView.RowAnimation = .none) {
        self.reloadSections(IndexSet(integer: section), with: animation)
    }
    
    func sizeHeaderToFit() {
        if let headerView = tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            tableHeaderView = headerView
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
        }
    }
    
    func addRefreshControl(refresh: @escaping(RefreshCallback)) {
        let refreshControl = RefreshControl()
        refreshControl.transform = CGAffineTransform.init(scaleX: 0.75, y: 0.75)
        
        refreshControl.tintColor = UIColor.appColor(.light_Grey)
        refreshControl.callback = refresh
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.addSubview(refreshControl)
    }
    
    @objc func handleRefresh(_ refresh: RefreshControl) {
        refresh.callback?(refresh)
    }
    
//    var scrollToBottom: Void {
//        
//        let contentOffset = self.contentSize.height
//        let height = self.bounds.height
//        if contentOffset > (height * 2) {
//            let point = CGPoint(x: 0, y: contentOffset - height)
//            self.setContentOffset(point, animated: true)
//        }
//    }
    
    var scrollToBottom: Void {
        let section = self.numberOfSections
        guard section != 0 else {return}
        let row = self.numberOfRows(inSection: section-1)
        guard row != 0 else {return}
        let indexPath = IndexPath(row: row-1, section: section-1)
        guard section != -1 , row != -1 else {return}
        self.scrollToRow(at: indexPath, at: .none, animated: false)
        print("scroll to bottom")
    }
    
//    var lastIndex: IndexPath {
//        let section = self.numberOfSections
//        let row = self.numberOfRows(inSection: section-1)
//        let indexPath = IndexPath(row: row-1, section: section-1)
//        return indexPath
//    }
    
    var tableViewHeight: CGFloat {
        self.layoutIfNeeded()
        return self.contentSize.height
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
    
    func addBackgoundSkeletonImage() {
        let backgroundImage = UIImageView(frame: self.bounds)
        backgroundImage.image = .gifImageWithName(name: "skeleton-loading")
        self.backgroundView = backgroundImage
    }
    
    func addBackgoundImage(image name: String) {
        let backgroundImage = UIImageView(frame: self.bounds)
        backgroundImage.image = .gifImageWithName(name: name)
        self.backgroundView = backgroundImage
    }
    
    
}

//extension UITableViewCell {
//    // Search up the view hierarchy of the table view cell to find the containing table view
//    var tableView: UITableView? {
//        var table: UIView? = superview
//        while !(table is UITableView) && table != nil {
//            table = table?.superview
//        }
//        return table as? UITableView
//    }
//
//
//}


extension UIView {
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
}

extension UITableViewCell {
    var tableView: UITableView? {
        return parentView(of: UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return self.tableView?.indexPath(for: self)
    }
}




//MARK: --- UIContextualAction


extension UIContextualAction {
    
    convenience init(handler: @escaping UIContextualAction.Handler) {
        self.init(style: .destructive, title: "", handler: handler)
    }
    
}


extension UIView {
    func setViewSizeToFit() {
        let height = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = self.frame
        frame.size.height = height
        self.frame = frame
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    var getFittedHeight: CGFloat {
        let height = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
}
