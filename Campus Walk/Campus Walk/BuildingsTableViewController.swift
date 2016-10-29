//
//  BuildingTableViewController.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 10/22/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class BuildingsTableViewController: UITableViewController, BuildingDetailDataSource {
    
    let buildingMutableData = buildingModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return buildingMutableData.numberOfSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildingMutableData.numberOfBuildingsForSection(section)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return buildingMutableData.titleForSection(section)
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return buildingMutableData.allSectionTitles()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BuildingCell", forIndexPath: indexPath) as! BuildingCell
        cell.buildingName.text = buildingMutableData.buildingNameAtPath(indexPath)
        
        return cell
    }
    
    var currentBuilding : buildingModel.Building {
        get {
            return buildingMutableData.buildingAtPath(self.tableView.indexPathForSelectedRow!)
        }
    }
    
    var indexPath : NSIndexPath {
        get { return tableView.indexPathForSelectedRow! }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "DetailSegue":
            if let detailViewController = segue.destinationViewController as? DetailViewController {
                detailViewController.dataSource = self
            }
        default:
            assert(false, "Unhandled Segue")
        }
    }
}