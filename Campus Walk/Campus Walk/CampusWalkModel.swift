//
//  CampusWalkModel.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 10/22/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import MapKit

class buildingModel{
    class Building: NSObject, MKAnnotation {
        
        let buildingName:String?
        let buildingYear:Int?
        let buildingOpp: Int?
        let photoFile: String?
        let coordinate:CLLocationCoordinate2D
        var isFavorite: Bool?
    
        init(buildingName:String, buildingOpp:Int, buildingYear:Int, coordinate:CLLocationCoordinate2D, photoFile:String, isFavorite:Bool){
            self.buildingName = buildingName
            self.coordinate = coordinate
            self.buildingYear = buildingYear
            self.buildingOpp = buildingOpp
            self.photoFile = photoFile
            self.isFavorite = isFavorite
            super.init()
        }
        
        func mapItem() -> MKMapItem {
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = buildingName
            return mapItem
        }
    }
    
    
    static let sharedInstance = buildingModel()
    private let buildingData: [Building]
    private var favoriteBuilding: [Building]
    private let buildingDictionary: [String:[Building]]
    private let allKeys: [String]
    
    private init(){
        let path = NSBundle.mainBundle().pathForResource("buildings", ofType: "plist")
        let data = NSArray(contentsOfFile: path!) as! [[String:AnyObject]]
        
        var _building = [Building]()
        var _buildingDictionary = [String:[Building]]()
        
        for dictionary in data {
            let aBuilding = Building(buildingName: dictionary["name"] as! String, buildingOpp: dictionary["opp_bldg_code"] as! Int, buildingYear: dictionary["year_constructed"] as! Int, coordinate: CLLocationCoordinate2D(latitude: dictionary["latitute"] as! CLLocationDegrees, longitude: dictionary["longitude"] as! CLLocationDegrees), photoFile: dictionary["photo"] as! String, isFavorite: false)
            _building.append(aBuilding)
            let firstLetter = aBuilding.buildingName!.firstLetter()!
            
            if let _ = _buildingDictionary[firstLetter] {
                _buildingDictionary[firstLetter]!.append(aBuilding)
            } else {
                _buildingDictionary[firstLetter] = [aBuilding]
            }
        }
        favoriteBuilding = [Building]()
        buildingData = _building
        buildingDictionary = _buildingDictionary
        let keys = Array(buildingDictionary.keys)
        allKeys = keys.sort()
    }
    
    // Functions
    func titleForSection(section: Int) -> String {
        return allKeys[section]
    }
    
    func allSectionTitles() -> [String]{
        return allKeys
    }
    
    func numberOfSections() -> Int {
        return allKeys.count
    }
    
    func numberOfBuildingsForSection(section: Int) -> Int {
        return buildingDictionary[(allKeys[section])]!.count
    }
    
    func buildingAtPath(indexPath: NSIndexPath)-> Building {
        return (buildingDictionary[(allKeys[indexPath.section])]!)[indexPath.row]
    }
    
    func buildingNameAtPath(indexPath: NSIndexPath) -> String{
        let building = buildingAtPath(indexPath)
            return building.buildingName!
    }
    
    
    
    
}