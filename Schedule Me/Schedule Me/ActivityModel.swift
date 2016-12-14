//
//  ActivityModel.swift
//  Subtitle Me
//
//  Created by THADEA A ACHMAD on 10/31/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import EventKit
import SwiftMoment

let recommendedSleepTime: Int = 8
struct Activity{
    var name: String              // Activity name
    var category: String          // type of activity (may fall into more than one category)
    
    // Is it better to have this under activity, or under activity model...
    // If I have it
    var isFixed: Bool             // is it time-specific
    var isConsistent: Bool        // do you want going to be reoccuring?
    var isAdded: Bool             // is this class/academic related (This is iffy, may not be needed)
    
    
    var activityValue: Int        // How important is this?
    
    init(){
        self.name = "Some Activity"
        self.category = "Some Category"
        self.isFixed = false
        self.isConsistent = false
        self.isAdded = false
        self.activityValue = 0
    }
    init(name: String, category: String, isFixed: Bool, isConsistent: Bool, isAdded: Bool, activityValue: Int){
        self.name = name
        self.category = category
        self.isFixed = isFixed
        self.isConsistent = isConsistent
        self.isAdded = isAdded
        self.activityValue = activityValue
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
        activityData = fillWithExamples()
        freeTime = 16.0
        sleepTime = 8.0
    }

    fileprivate init(activities: [Activity]){
        self.activityData = activities
        self.freeTime = 16.0
        self.sleepTime = 8.0
    }
    
    func getListOfActivities() -> [Activity] {
        return activityData!
    }
    
    func getActivitiesByCategory(category: String) -> [Activity]?{
        var activitiesByCategory: [Activity]?
        for someActivity in activityData!{
            var indexPath = 0
            if category == someActivity.category{
                activitiesByCategory?.insert(someActivity, at: indexPath)
                indexPath = indexPath + 1
                print(indexPath)
            }
        }
        
        return activitiesByCategory
    }
    
    func numOfActivitiesByCategory(category: String) -> Int {
        if let testActivity = getActivitiesByCategory(category: category){
            return testActivity.count
        } else {
            return 0
        }
    }
    
    func getFreeTime() -> Float {
        return freeTime
    }
    
    func getSleepTime() -> Float {
        return sleepTime
    }
    
}


class ScheduleMeIntervalModel{
    static let sharedInstance = ScheduleMeIntervalModel()
    
}

let categoryType: [String] = ["Academic", "Health", "Extra-Curricular", "Recreational", "Chores"]
