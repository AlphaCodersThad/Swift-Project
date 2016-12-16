//
//  ActivityMO+CoreDataProperties.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/16/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import CoreData


extension ActivityMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityMO> {
        return NSFetchRequest<ActivityMO>(entityName: "Activity");
    }

    @NSManaged public var added: Bool
    @NSManaged public var name: String?
    @NSManaged public var fixed: Bool
    @NSManaged public var consistent: Bool
    @NSManaged public var category: String?
    @NSManaged public var activityValue: Int16
    @NSManaged public var choiceSlotDay: NSSet?

}

// MARK: Generated accessors for choiceSlotDay
extension ActivityMO {

    @objc(addChoiceSlotDayObject:)
    @NSManaged public func addToChoiceSlotDay(_ value: DayMO)

    @objc(removeChoiceSlotDayObject:)
    @NSManaged public func removeFromChoiceSlotDay(_ value: DayMO)

    @objc(addChoiceSlotDay:)
    @NSManaged public func addToChoiceSlotDay(_ values: NSSet)

    @objc(removeChoiceSlotDay:)
    @NSManaged public func removeFromChoiceSlotDay(_ values: NSSet)

}
