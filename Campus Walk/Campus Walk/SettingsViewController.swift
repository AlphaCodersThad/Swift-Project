//
//  SettingsViewController.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 11/5/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SettingsViewController: UIViewController {
    
    let buildingMutableData = CampusModel.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func mapType(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            buildingMutableData.MapViewOption = 0
            
        case 1:
            buildingMutableData.MapViewOption = 1
            
        case 2:
            buildingMutableData.MapViewOption = 2
            
        default:
            break
        }
    }
}
