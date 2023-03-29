//
//  FTDelegate.swift
//  FlexibleTable
//
//  Created by Yusuf Demirci on 31.05.2020.
//
import UIKit

public protocol FTDelegate {
    func didMaskViewAlphaChange(alpha: CGFloat)
}

extension FTDelegate {
    func didMaskViewAlphaChange(alpha: CGFloat) {}
}
