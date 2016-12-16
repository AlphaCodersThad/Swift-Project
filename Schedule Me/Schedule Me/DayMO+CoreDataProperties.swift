//
//  DayMO+CoreDataProperties.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/16/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import CoreData


extension DayMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayMO> {
        return NSFetchRequest<DayMO>(entityName: "Day");
    }

    @NSManaged public var numOfInterval: Int16
    @NSManaged public var title: String?
    @NSManaged public var activityOnQueue: NSData?
    @NSManaged public var freeSlot: NSSet?
    @NSManaged public var takenSlot: TakenTime?

}

// MARK: Generated accessors for freeSlot
extension DayMO {

    @objc(addFreeSlotObject:)
    @NSManaged public func addToFreeSlot(_ value: FreeTime)

    @objc(removeFreeSlotObject:)
    @NSManaged public func removeFromFreeSlot(_ value: FreeTime)

    @objc(addFreeSlot:)
    @NSManaged public func addToFreeSlot(_ values: NSSet)

    @objc(removeFreeSlot:)
    @NSManaged public func removeFromFreeSlot(_ values: NSSet)

}
