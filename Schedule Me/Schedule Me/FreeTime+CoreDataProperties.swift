//
//  FreeTime+CoreDataProperties.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/15/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension FreeTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FreeTime> {
        return NSFetchRequest<FreeTime>(entityName: "FreeTime");
    }

    @NSManaged public var groupFromBefore: String?
    @NSManaged public var startEndLocation: NSDate?
    @NSManaged public var groupFromAfter: String?
    @NSManaged public var strengthForActivity: Int16
    @NSManaged public var bestPotentialFor: Day?

}
