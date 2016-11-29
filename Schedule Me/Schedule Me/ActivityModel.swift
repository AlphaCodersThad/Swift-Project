//
//  ActivityModel.swift
//  Subtitle Me
//
//  Created by THADEA A ACHMAD on 10/31/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation

let recommendedSleepTime: Int = 8
struct Activity{
    var name: String              // Activity name
    var category: [categoryType]  // type of activity (may fall into more than one category)
    
    // Is it better to have this under activity, or under activity model...
    // If I have it
    var isFixed: Bool             // is it time-specific
    var isConsistent: Bool        // do you want going to be reoccuring?
    var isAcademic: Bool          // is this class/academic related (This is iffy, may not be needed)
    
    var activityValue: Int        // How important is this?
    
    enum categoryType: String{
        // May need to enum into a school type
        case Class = "Class"
        case Academic = "Academic"
        case Job = "Job"
        case ExtraCurricular = "Extra-Curricular"
        
        case Sleep = "Sleep"
        case Health = "Health"
        
        case Recreational = "Recreational"
        case Social = "Social"
        case PersonalInterest = "Personal Interest"
    }
}

class ActivityModel{
    
    static let sharedInstance = ActivityModel()
    
    //I need to create a plist to read from, to initialize the activity, and change var to let..
    fileprivate var activityData: [Activity]?
    
    fileprivate var freeTime: Float
    fileprivate var sleepTime: Float
    // private let activityDictionary: [String: [Activity]]
    // private var lengthOfActivity: Float
    
    fileprivate init(){
        self.activityData = nil
        freeTime = 16.0
        sleepTime = 8.0
    }
    
    func getListOfActivities() -> [Activity] {
        return activityData!
    }
    func getFreeTime() -> Float {
        return freeTime
    }
    
    func getSleepTime() -> Float {
        return sleepTime
    }
    
}
