//
//  SearchTableController.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 11/5/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation

import UIKit

protocol SearchCampusBuildings : class {
    func buildingSearchViewControllerDismissed(buildingClicked: BuildingMapData)
}

class SearchTableViewController: UITableViewController {
    
    var campusModel = CampusModel.sharedInstance
    weak var dataSource : SearchCampusBuildings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return campusModel.numberOfSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campusModel.numberOfBuildingsForSection(section)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return campusModel.titleForSection(section)
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return campusModel.allSectionTitles()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchTableViewCell", forIndexPath: indexPath) as! SearchCell
        cell.buildingName.text = campusModel.buildingNameAtPath(indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let buildingInstance = self.campusModel.buildingAtPath(indexPath)
        let campusBuilding = BuildingMapData(title: buildingInstance.buildingName!,
                                            coordinate: buildingInstance.coordinate,
                                            photoName: buildingInstance.photoFile!
        )
        dataSource?.buildingSearchViewControllerDismissed(campusBuilding)
    }
    
}
