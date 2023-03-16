//
//  AutoResizeTableView.swift
//  Challenger
//
//  Created by Admin on 10/08/22.
//

import UIKit


class AutoResizeTableView:UITableView{
    override var contentSize: CGSize{
        didSet{
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize{
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
