//
//  DirectionsViewController.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 11/5/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation

import UIKit
import MapKit

protocol GetDirectionsProtocol : class {
    func buildingSourceAndDestinationSelected(source: MKAnnotation?, destination: MKAnnotation?)
}

class DirectionsViewController: UIViewController , SearchCampusBuildings{
    
    @IBOutlet weak var tableView: UITableView!
    var lastClickedTextField: UIButton?
    var source: BuildingMapData?
    var destination: BuildingMapData?
    var campusModel = CampusModel.sharedInstance
    
    @IBOutlet weak var selectDestinationLabel: UIButton!
    @IBOutlet weak var selectSourceLabel: UIButton!
    
    weak var dataSource : GetDirectionsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dest = destination {
            selectDestinationLabel.setTitle(dest.title, forState: UIControlState.Normal)
        }
        
        if let src = source {
            selectSourceLabel.setTitle(src.title, forState: UIControlState.Normal)
        }
    }
    
    @IBAction func selectSourceAndDestination(sender: UIButton) {
        lastClickedTextField = sender
        let bldgSearchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SearchTable") as! SearchTableController
        bldgSearchViewController.campusModel = campusModel
        bldgSearchViewController.dataSource = self
        self.presentViewController(bldgSearchViewController, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func getDirections(sender: UIButton) {
        if let src = source {
            if let dest = destination {
                dataSource?.buildingSourceAndDestinationSelected(src, destination: dest)
            } else {
                let alertController = UIAlertController(title: "Invalid Destination", message: "Please enter a valid destination", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Invalid Source", message: "Please enter a valid source", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func buildingSearchViewControllerDismissed(buildingClicked: BuildingMapData) {
        lastClickedTextField!.setTitle(buildingClicked.title, forState: UIControlState.Normal)
        if lastClickedTextField?.tag == 0 {
            source = buildingClicked
        } else {
            destination = buildingClicked
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
}
