//
//  Activity+CoreDataProperties.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/15/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity");
    }

    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var fixed: Bool
    @NSManaged public var consistent: Bool
    @NSManaged public var scheduled: Bool
    @NSManaged public var choiceSlot: NSSet?

}

// MARK: Generated accessors for choiceSlot
extension Activity {

    @objc(addChoiceSlotObject:)
    @NSManaged public func addToChoiceSlot(_ value: Day)

    @objc(removeChoiceSlotObject:)
    @NSManaged public func removeFromChoiceSlot(_ value: Day)

    @objc(addChoiceSlot:)
    @NSManaged public func addToChoiceSlot(_ values: NSSet)

    @objc(removeChoiceSlot:)
    @NSManaged public func removeFromChoiceSlot(_ values: NSSet)

}
