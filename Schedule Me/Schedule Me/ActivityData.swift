//
//  ActivityData.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/16/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation


class Activity: NSObject, NSCoding{
    let name: String              // Activity name
    var category: String          // type of activity (may fall into more than one category)
    var isFixed: Bool             // is it time-specific
    var isConsistent: Bool        // do you want going to be reoccuring?
    var isAdded: Bool
    var activityValue: Int16       // How important is this?
    var choiceSlot: [daySchedule]
    
    //    init(){
    //        self.name = "Some Activity"
    //        self.category = "Some Category"
    //        self.isFixed = false
    //        self.isConsistent = false
    //        self.isAdded = false
    //        self.activityValue = 0
    //    }
    
    init(name: String, category: String, isFixed: Bool, isConsistent: Bool, isAdded: Bool, activityValue: Int16, choiceSlot: [daySchedule]){
        self.name = name
        self.category = category
        self.isFixed = isFixed
        self.isConsistent = isConsistent
        self.isAdded = isAdded
        self.activityValue = activityValue
        self.choiceSlot = choiceSlot
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(category, forKey: "category")
        coder.encode(isFixed, forKey: "isFixed")
        coder.encode(isConsistent, forKey: "isConsistent")
        coder.encode(isAdded, forKey: "isAdded")
        coder.encode(activityValue, forKey: "activityValue")
        coder.encode(choiceSlot, forKey: "choiceSlot")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let name = decoder.decodeObject(forKey: "name") as! String
        let category = decoder.decodeObject(forKey: "category") as! String
        let isFixed = decoder.decodeBool(forKey: "isFixed")
        let isAdded = decoder.decodeBool(forKey: "isAdded")
        let isConsistent = decoder.decodeBool(forKey: "isConsistent")
        let activityValue = decoder.decodeObject(forKey: "activityValue") as! Int16
        let choiceSlot = decoder.decodeObject(forKey: "choiceSlot") as! [daySchedule]
        
        self.init(name: name, category: category,
                  isFixed: isFixed, isConsistent: isConsistent,
                  isAdded: isAdded, activityValue: activityValue, choiceSlot: choiceSlot)
        
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////
class daySchedule: NSObject, NSCoding{
    let dayTitle: String
    var numOfInterval: Int16
    var activityOnQueue: Activity
    var takenSlot: [takenTime]
    var freeSlot: [freeTime]
    
    init(dayTitle: String, numOfInterval: Int16, activityOnQueue: Activity, takenSlot: [takenTime], freeSlot: [freeTime]){
        self.dayTitle = dayTitle
        self.numOfInterval = numOfInterval
        self.activityOnQueue = activityOnQueue
        self.takenSlot = takenSlot
        self.freeSlot = freeSlot
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(dayTitle, forKey: "dayTitle")
        coder.encode(numOfInterval, forKey: "numOfInterval")
        coder.encode(activityOnQueue, forKey: "activityOnQueue")
        coder.encode(takenSlot, forKey: "takenSlot")
        coder.encode(freeSlot, forKey: "freeSlot")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let dayTitle = decoder.decodeObject(forKey: "dayTitle") as! String
        let numOfInterval = decoder.decodeObject(forKey: "numOfInterval") as! Int16
        let activityOnQueue = decoder.decodeObject(forKey: "activityOnQueue") as! Activity
        let takenSlot = decoder.decodeObject(forKey: "takenSlot") as! [takenTime]
        let freeSlot = decoder.decodeObject(forKey: "freeSlot") as! [freeTime]
        
        
        self.init(dayTitle: dayTitle, numOfInterval: numOfInterval, activityOnQueue: activityOnQueue, takenSlot: takenSlot, freeSlot: freeSlot)
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////
class takenTime: NSObject, NSCoding{
    var valueForAround: Int16
    var intervalSlot: Date
    var currentActivity: Activity
    
    init(valueForAround: Int16, intervalSlot: Date, currentActivity: Activity)
    {
        self.valueForAround = valueForAround
        self.intervalSlot = intervalSlot
        self.currentActivity = currentActivity
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(valueForAround, forKey: "valueForAround")
        coder.encode(intervalSlot, forKey: "intervalSlot")
        coder.encode(currentActivity, forKey: "currentActivity")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let valueForAround = decoder.decodeObject(forKey: "valueForAround") as! Int16
        let intervalSlot = decoder.decodeObject(forKey: "intervalSlot") as! Date
        let currentActivity = decoder.decodeObject(forKey: "currentActivity") as! Activity
        
        
        self.init(valueForAround: valueForAround, intervalSlot: intervalSlot, currentActivity: currentActivity)
    }
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////
class freeTime: NSObject, NSCoding{
    var priorEvent: String
    var nextEvent: String
    var intervalSlot: Date
    var strengthForActivity: [Int16]            // Since activity -> groups.. I'll just return an array to match the groups
    var bestPotentialFor: Date
    
    init(priorEvent: String, nextEvent: String, intervalSlot: Date, strengthForActivity: [Int16], bestPotentialFor: Date){
        self.priorEvent = priorEvent
        self.nextEvent = nextEvent
        self.intervalSlot = intervalSlot
        self.strengthForActivity = strengthForActivity
        self.bestPotentialFor = bestPotentialFor
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(priorEvent, forKey: "priorEvent")
        coder.encode(nextEvent, forKey: "nextEvent")
        coder.encode(intervalSlot, forKey: "intervalSlot")
        coder.encode(strengthForActivity, forKey: "strengthForActivity")
        coder.encode(bestPotentialFor, forKey: "bestPotentialFor")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let priorEvent = decoder.decodeObject(forKey: "priorEvent") as! String
        let nextEvent = decoder.decodeObject(forKey: "nextEvent")   as! String
        let intervalSlot = decoder.decodeObject(forKey: "intervalSlot") as! Date
        let strengthForActivity = decoder.decodeObject(forKey: "strengthForActivity") as! [Int16]
        let bestPotentialFor = decoder.decodeObject(forKey: "bestPotentialFor") as! Date
        
        self.init(priorEvent: priorEvent, nextEvent: nextEvent, intervalSlot: intervalSlot, strengthForActivity: strengthForActivity, bestPotentialFor: bestPotentialFor)
    }
}
