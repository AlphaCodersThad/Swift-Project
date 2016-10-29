//
//  DetailViewController.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 10/22/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol BuildingDetailDataSource: class {
    var currentBuilding: buildingModel.Building { get }
    var indexPath: NSIndexPath { get }
}

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    weak var dataSource: BuildingDetailDataSource?
    @IBOutlet weak var buildingImage: UIImageView!
    @IBOutlet weak var buildingNameLabel: UILabel!
    @IBOutlet weak var buildingYearLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    let buildingMutableData = buildingModel.sharedInstance
    
    var _name: String = ""
    var _opp_bldg_code: String = ""
    var _year_constructed: String = ""
    var _coordinate: String = ""
    var _photoFile = ""
    var _isFavorite: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //subtitleTextField.editable = false
        _name = (dataSource?.currentBuilding.buildingName)!
        _opp_bldg_code = String((dataSource?.currentBuilding.buildingOpp)!)
        _year_constructed = String((dataSource?.currentBuilding.buildingYear)!)
        _coordinate = " Latitude: \(dataSource?.currentBuilding.coordinate.latitude), Longitude: \(dataSource?.currentBuilding.coordinate.longitude)"
        _photoFile = (dataSource?.currentBuilding.photoFile)!
        _isFavorite = (dataSource?.currentBuilding.isFavorite)!
        
        
        // Display building name
        buildingNameLabel.text = _name
        
        // Display year constructed
        switch _year_constructed{
        case "0":
            buildingYearLabel.text = "Year Constructed: Unknown"
        default:
            buildingYearLabel.text = "Year Constructed: " + _year_constructed
        }
        if !_isFavorite! {
            favoriteButton.setTitle("Add to Favorite", forState: UIControlState.Normal)
        }
        
        if !_photoFile.isEmpty {
            buildingImage.image = UIImage(named: (_photoFile + ".jpg"))
            buildingImage.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
    
    @IBAction func pinToMapButton(sender: UIButton) {
        buildingMutableData.currentPin = dataSource?.currentBuilding
        self.tabBarController?.selectedIndex = 0
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
