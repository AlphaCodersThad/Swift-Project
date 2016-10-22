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

class BuildingsTableViewController: UITableViewController{
    
    let buildingData = buildingModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return buildingData.numberOfSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildingData.numberOfBuildingsForSection(section)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return buildingData.titleForSection(section)
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return buildingData.allSectionTitles()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BuildingCell", forIndexPath: indexPath) as! BuildingCell
        cell.buildingName.text = buildingData.buildingNameAtPath(indexPath)
        
        return cell
    }
    
    /*var currentBuilding : Building {
        get {
            return buildingData.buildingAtIndexPath(self.tableView.indexPathForSelectedRow!)
        }
    }*/
    
    var indexPath : NSIndexPath {
        get { return tableView.indexPathForSelectedRow! }
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "InfoSegue":
            let infoViewController = segue.destinationViewController as! InfoViewController
            let svc = self.tabBarController?.viewControllers![0].childViewControllers[0] as! CampusWalkViewController
            infoViewController.dataSource = self
            infoViewController.campusWalkDataSource = svc
            infoViewController.completionBlock = { () in self.dismissViewControllerAnimated(true, completion: nil)}
            break
        default:
            assert(false, "Unhandled Segue")
        }
    }*/
}