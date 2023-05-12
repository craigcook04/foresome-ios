//
//  CustomProgressBar.swift
//  Challenger
//
//  Created by Admin on 18/04/22.
//

import UIKit

class CustomProgressBar: UIProgressView {

    override func layoutSubviews() {
           super.layoutSubviews()
           let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
           let maskLayer = CAShapeLayer()
           maskLayer.frame = self.bounds
           maskLayer.path = maskLayerPath.cgPath
           layer.mask = maskLayer
       }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 8.0)
    }
}
