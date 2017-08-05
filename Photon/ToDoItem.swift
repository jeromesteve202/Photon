//
//  ToDoItem.swift
//  Productivity App
//
//  Created by Steve  on 5/15/16.
//  Copyright © 2016 Rishi P. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
    
    // A text description of this item.
    var text: String
    
    // A Boolean value that determines the completed state of this item.
    var isStruck: Bool
    
    var completed: Bool
    var isScheduled: Bool
    
    // Returns a ToDoItem initialized with the given text and default completed value.
    init(text: String) {
        self.text = text
        self.isStruck = false
        self.isScheduled = false
        self.completed = false
    }
}
