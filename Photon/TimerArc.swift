//
//  WithinTwoHoursDisplayView.swift
//  Productivity App
//
//  Created by Varun Kulkarni on 5/25/16.
//  Copyright © 2016 Rishi P. All rights reserved.
//

import Foundation
import UIKit
import GLKit

let startAngle:CGFloat = CGFloat((M_PI/2) * 3)

let convertToRad = M_PI/180

@IBDesignable class TimerArc: UIView {

    override func draw(_ rect: CGRect){
        self.isOpaque = true
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2
        let theCenter:CGPoint = CGPoint(x: centerX, y: centerY)
        let myRadius:CGFloat = max(bounds.width, bounds.height) / 3.2
        let thickness:CGFloat = (max(bounds.width, bounds.height) / 3.2) / 18.8392857

        let endAnglem = CGFloat(degrees * convertToRad) + startAngle
        
        let path2:UIBezierPath! = UIBezierPath(arcCenter: theCenter, radius: myRadius, startAngle: endAnglem, endAngle: CGFloat(7 * M_PI / 2), clockwise: true)
            
        let path:UIBezierPath! = UIBezierPath(arcCenter: theCenter, radius: myRadius, startAngle: startAngle, endAngle: endAnglem, clockwise: true)
        
        let circleColor2:UIColor = UIColor(red: 166/255.0, green: 166/255.0, blue: 166/255.0, alpha: 0.66)
        circleColor2.setStroke()
        path2.lineWidth = thickness
        path2.stroke()
        
        let circleColor:UIColor = UIColor(red: 181/255.0, green: 210/255.0, blue: 207/255.0, alpha: 1.0)
        circleColor.setStroke()
        path.lineWidth = thickness
        path.stroke()
        
    }
    
}


