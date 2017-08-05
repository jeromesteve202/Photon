//
//  InteractiveCell.swift
//  Photon
//
//  Created by Varun Kulkarni on 6/20/16.
//  Copyright © 2016 Rishi P. All rights reserved.
//

import Foundation
import UIKit

var testSegue = false

class InteractiveCell: UITableViewCell{
    var scheduleButton:UIButton!
    var task:UILabel!
    
    init(frame: CGRect, inTask:String){
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "todoTime")
        
        let aFrame = CGRect(x: 12, y: 0, width: 100.0, height: 40.0)
        task = UILabel(frame: aFrame)
        task.textColor = UIColor.darkGray
        let font = UIFontDescriptor(name: "Futura", size: 21.0)
        task.font = UIFont(descriptor: font, size: 21.0)
        task.text = inTask
        
        
        
        let bFrame = CGRect(x: self.frame.width, y: 0, width: 50, height: 50)
        scheduleButton = UIButton(frame: bFrame)
        scheduleButton.setImage(UIImage(named: "eventbutton.png"), for: UIControlState())
        addSubview(task)
        addSubview(scheduleButton)
            }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
