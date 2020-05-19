//
//  Ring.swift
//  5teps
//
//  Created by Fabio Palladino on 19/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import Foundation
import UIKit
class Ring: UIView
{
    public var colorCircle: UIColor = UIColor.red
    public var lineWidth: CGFloat = 2    // your desired value
    public var endAngle: CGFloat = 0
    override func draw(_ rect: CGRect)
    {
        drawRingFittingInsideView()
    }
    
    internal func drawRingFittingInsideView()->()
    {
        let halfSize:CGFloat = min(bounds.size.width/2, bounds.size.height/2)
        
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - (lineWidth)),
            startAngle: CGFloat(Double.pi*3/2),
            endAngle: endAngle,
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = colorCircle.cgColor
        shapeLayer.lineWidth = lineWidth
        
        layer.addSublayer(shapeLayer)
    }
    public static func degreeToRadiant(gradi: Int) -> CGFloat {
        let gradi2 = gradi - 90
        return CGFloat((Double(gradi2) * Double.pi)/180)
    }
}
