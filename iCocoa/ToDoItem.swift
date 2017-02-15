//
//  ToDoItem.swift
//  iCocoa
//
//  Created by ANI on 2/14/17.
//  Copyright © 2017 VizNetwork. All rights reserved.
//

import Foundation
import Parse

class ToDoItem: PFObject, PFSubclassing {
    
    @NSManaged var itemDesc     :String
    @NSManaged var dueDate      :Date?
    @NSManaged var isComplete   :Bool
    @NSManaged var priorityLevel:Int
    @NSManaged var hoursToDate  :Double
    
    convenience init(desc: String, priority: Int) {
        self.init()
        self.itemDesc = desc
        self.isComplete = false
        self.priorityLevel = priority
        self.hoursToDate = 0.0
    }
    
    static func parseClassName() -> String {
        return "ToDoItem"
    }

}
