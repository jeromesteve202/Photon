//
//  backgroundTimer.swift
//  Productivity App
//
//  Created by Varun Kulkarni on 6/11/16.
//  Copyright © 2016 Rishi P. All rights reserved.
//

import Foundation
import UIKit
class backgroundTimer: UIView{
    override func draw(_ rect: CGRect){
        
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2
        let theCenter:CGPoint = CGPoint(x: centerX, y: centerY)
        let myRadius:CGFloat = max(bounds.width, bounds.height) / 3.2
        let thickness:CGFloat = 5.0
        
        let startAngle = CGFloat(3 * M_PI/2)
        let endAngle = startAngle + CGFloat(360)
        
        let path:UIBezierPath! = UIBezierPath(arcCenter: theCenter, radius: myRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let circleColor:UIColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 0.7)
        circleColor.setStroke()
        path.lineWidth = thickness
        path.stroke()
        
    }

}
