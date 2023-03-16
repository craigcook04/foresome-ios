//
//  UICollectionView+Custom.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 04/04/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import Foundation
import UIKit

typealias RefreshCallback = ((_ data: UIRefreshControl) -> ())

class RefreshControl: UIRefreshControl {
    var callback: RefreshCallback?
    
}

extension UICollectionView {
    
    public func dequeue<T: UICollectionViewCell>(cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: String(describing: cellClass.self), for: indexPath) as? T else {
                fatalError(
                    "Error: cell with id: \(String(describing: cellClass.self)) for indexPath: \(indexPath) is not \(T.self)")
            }
        return cell
    }
    
    func register<T: UICollectionViewCell>(cellClass: T.Type){
        self.register(UINib(nibName:String(describing: cellClass.self), bundle:nil), forCellWithReuseIdentifier: String(describing: cellClass.self))
    }
    
    func registerCell(identifier: String) {
        self.register(UINib(nibName:identifier, bundle:nil), forCellWithReuseIdentifier: identifier)
    }
    
    func registerHeader(nibName:String) {
        self.register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: nibName)
    }
    
    func registerHeader<T: UICollectionReusableView>(headerClass:T.Type){
        self.register(UINib(nibName: String(describing: T.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:  String(describing: T.self))
    }
    
    func registerFooter<T: UICollectionReusableView>(footerClass:T.Type) {
        self.register(UINib(nibName: String(describing: T.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self))
    }
    
    func registerFooter(nibName:String) {
        self.register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: nibName)
    }
    
    func dequeSupplementaryView<T: UICollectionReusableView>(viewClass:T.Type, kind: String, forIndexPath indexPath: IndexPath) -> T{
        guard let reusableView = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: viewClass.self), for: indexPath) as? T else {
            fatalError(
                "Error: cell with id: \(String(describing: viewClass.self)) for indexPath: \(indexPath) is not \(T.self)")
        }
        return reusableView
    }
    
    
    func setBackgroundView(message:String) {
        // let view = UIView(frame: self.frame)
        let label = UILabel()
        label.text = message
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.setCustom(.OS_Bold, 16)
        label.center = CGPoint(x: self.center.x, y: self.center.y - 150)
        self.backgroundView = label
    }
    
    func addRefreshControl(refresh: @escaping(RefreshCallback)) {
        let refreshControl = RefreshControl()
        refreshControl.callback = refresh
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.addSubview(refreshControl)
    }
    
    @objc func handleRefresh(_ refresh: RefreshControl) {
        refresh.callback?(refresh)
    }
    
    func addBackgoundSkeletonImage() {
        let backgroundImage = UIImageView(frame: self.bounds)
        backgroundImage.image = .gifImageWithName(name: "skeleton-loading")
        self.backgroundView = backgroundImage
    }
    
    
}

//
//extension UICollectionViewCell {
//    var collectionView: UITableView? {
//        return self.parentView(of: UICollectionView.self)
//    }
//
//    var indexPath: IndexPath? {
//        return self.collectionView?.indexPath(for: self)
//    }
//
//}

extension UICollectionViewCell {
    // Search up the view hierarchy of the table view cell to find the containing table view
    var collectionView: UICollectionView? {
        get {
            var table: UIView? = superview
            while !(table is UICollectionView) && table != nil {
                table = table?.superview
            }
            return table as? UICollectionView
        }
    }

    var indexPath:IndexPath? {
        return self.collectionView?.indexPath(for: self)
    }
}


class AutoSizedCollectionView: UICollectionView {

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
