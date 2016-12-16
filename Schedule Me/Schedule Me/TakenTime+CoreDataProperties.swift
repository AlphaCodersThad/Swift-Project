//
//  TakenTime+CoreDataProperties.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/15/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TakenTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TakenTime> {
        return NSFetchRequest<TakenTime>(entityName: "TakenTime");
    }

    @NSManaged public var activityInPlace: NSData?
    @NSManaged public var valueForAround: NSData?
    @NSManaged public var startEndTime: NSDate?
    @NSManaged public var currentActivity: NSSet?

}

// MARK: Generated accessors for currentActivity
extension TakenTime {

    @objc(addCurrentActivityObject:)
    @NSManaged public func addToCurrentActivity(_ value: Day)

    @objc(removeCurrentActivityObject:)
    @NSManaged public func removeFromCurrentActivity(_ value: Day)

    @objc(addCurrentActivity:)
    @NSManaged public func addToCurrentActivity(_ values: NSSet)

    @objc(removeCurrentActivity:)
    @NSManaged public func removeFromCurrentActivity(_ values: NSSet)

}
