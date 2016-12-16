//
//  TakenTime+CoreDataProperties.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/16/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import CoreData


extension TakenTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TakenTime> {
        return NSFetchRequest<TakenTime>(entityName: "TakenTime");
    }

    @NSManaged public var valueForAround: Int16
    @NSManaged public var startEndTime: NSDate?
    @NSManaged public var currentActivity: NSSet?

}

// MARK: Generated accessors for currentActivity
extension TakenTime {

    @objc(addCurrentActivityObject:)
    @NSManaged public func addToCurrentActivity(_ value: DayMO)

    @objc(removeCurrentActivityObject:)
    @NSManaged public func removeFromCurrentActivity(_ value: DayMO)

    @objc(addCurrentActivity:)
    @NSManaged public func addToCurrentActivity(_ values: NSSet)

    @objc(removeCurrentActivity:)
    @NSManaged public func removeFromCurrentActivity(_ values: NSSet)

}
