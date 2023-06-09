//
//  GradientViewWithAngle.swift
//  Foresome
//
//  Created by Deepanshu on 09/06/23.
//

import Foundation
import UIKit

@IBDesignable
final class GradientViewWithAngle: UIView {

    @IBInspectable var firstColor: UIColor = .clear { didSet { updateView() } }
    @IBInspectable var secondColor: UIColor = .clear { didSet { updateView() } }

//    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 0) { didSet { updateView() } }
//    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1, y: 1) { didSet { updateView() } }

    override class var layerClass: AnyClass { get { CAGradientLayer.self } }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
        layer.frame = self.frame
        
    }

    private func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map {$0.cgColor}
//        layer.startPoint = startPoint
//        layer.endPoint = endPoint
        layer.locations = [0,1]
        
       
       
        // Define the angle of the gradient (in radians)
        let angle = (CGFloat.pi / 4) * 4.0 // Example angle of 135 degrees
        
        // Calculate the start and end points of the gradient based on the angle
        let startPoint = CGPoint(x: 0.5 - cos(angle) * 0.5, y: 0.5 + sin(angle) * 0.5)
        
        let endPoint = CGPoint(x: 0.5 + cos(angle) * 0.5, y: 0.5 - sin(angle) * 0.5)
        
        // Set the start and end points of the gradient
        layer.startPoint = startPoint
        layer.endPoint = endPoint
    }
    
    
    
    
    
    
    
    
    
}


