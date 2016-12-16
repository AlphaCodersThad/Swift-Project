//
//  Day+CoreDataProperties.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/15/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day");
    }

    @NSManaged public var numOfInterval: Int16
    @NSManaged public var dayOfWeek: String?
    @NSManaged public var whichActivity: NSData?
    @NSManaged public var possibleActivitySlot: NSSet?
    @NSManaged public var takenSlot: TakenTime?

}

// MARK: Generated accessors for possibleActivitySlot
extension Day {

    @objc(addPossibleActivitySlotObject:)
    @NSManaged public func addToPossibleActivitySlot(_ value: FreeTime)

    @objc(removePossibleActivitySlotObject:)
    @NSManaged public func removeFromPossibleActivitySlot(_ value: FreeTime)

    @objc(addPossibleActivitySlot:)
    @NSManaged public func addToPossibleActivitySlot(_ values: NSSet)

    @objc(removePossibleActivitySlot:)
    @NSManaged public func removeFromPossibleActivitySlot(_ values: NSSet)

}
