//
//  FreeTime+CoreDataProperties.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/16/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import CoreData


extension FreeTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FreeTime> {
        return NSFetchRequest<FreeTime>(entityName: "FreeTime");
    }

    @NSManaged public var priorEvent: String?
    @NSManaged public var intervalSlot: NSDate?
    @NSManaged public var nextEvent: String?
    @NSManaged public var strengthForActivity: NSObject?
    @NSManaged public var bestPotentialFor: DayMO?

}
