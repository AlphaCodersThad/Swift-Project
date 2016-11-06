//
//  FavoriteViewController.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 11/5/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//


import Foundation
import UIKit

class FavoriteViewController: UITableViewController , BuildingDetailDataSource{
    
    let buildingMutableData = CampusModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = backgroundView
        self.tableView.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCampusWalkBuildingCell", forIndexPath: indexPath) as! FavoriteCampusWalkBuildingCell
     cell.buildingName.text = campusWalkData.favoriteBuildings[indexPath.row].name
     return cell
     }*/
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        buildingMutableData.favoriteKeys = Array(buildingMutableData.favoriteBuilding.keys).sort()
        return buildingMutableData.favoriteKeys.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let letter = buildingMutableData.favoriteKeys[section]
        return buildingMutableData.favoriteBuilding[letter]!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return buildingMutableData.favoriteKeys[section]
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return buildingMutableData.favoriteKeys
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteBuildingCell", forIndexPath: indexPath) as! FavoriteBuildingCell
        let letter = buildingMutableData.favoriteKeys[indexPath.section]
        let buildings = buildingMutableData.favoriteBuilding[letter]!
        cell.favoriteBuildingLabel.text = (buildings[indexPath.row]).buildingName
        cell.favoriteBuildingLabel.textColor = UIColor.purpleColor()
        return cell
    }
    
    /*
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     switch segue.identifier! {
     case "InfoSegue":
     let detailViewController = segue.destinationViewController as! InfoViewController
     detailViewController.dataSource = self
     detailViewController.completionBlock = { () in self.dismissViewControllerAnimated(true, completion: nil)}
     break
     default:
     assert(false, "Unhandled Segue")
     }
     }*/
    
    var currentBuilding : Building {
        get {
            return buildingMutableData.favoriteBuildingAtPath(self.tableView.indexPathForSelectedRow!)
        }
    }
    
    var indexPath : NSIndexPath {
        get {
            return tableView.indexPathForSelectedRow!
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "FavInfoSegue":
            let svc = self.tabBarController?.viewControllers![0].childViewControllers[0] as! MapViewController
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.dataSource = self
            detailViewController.campusModelSource = svc
            detailViewController.completionBlock = { () in self.dismissViewControllerAnimated(false, completion: nil)}
            break
        default:
            assert(false, "Unhandled Segue")
        }
    }
}