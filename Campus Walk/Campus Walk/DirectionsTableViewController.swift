//
//  DirectionsTableViewController.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 11/5/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol DirectionTableDataSource : class {
    var directions : [MKRouteStep]? { get }
}

class DirectionTableViewController: UITableViewController {
    
    weak var dataSource : DirectionTableDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.directions?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DirectionsViewCell", forIndexPath: indexPath) as! DirectionsViewCell
        cell.navigationText.text = (dataSource?.directions![indexPath.row])?.instructions
        return cell
    }
    
}
