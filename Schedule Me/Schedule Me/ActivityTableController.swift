
//
//  ActivityTableController.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/14/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ActivityTableController: UITableViewController {
    let activitySingleton = ActivityModel.sharedInstance
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryInput = categoryType[section]
        return activitySingleton.numOfActivitiesByCategory(category: categoryInput)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryType[section]
    }
}
