//
//  CampusWalkModel.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 10/22/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import MapKit


class Building: NSObject, NSCoding{
    
    
    var buildingName:String?
    var buildingYear:Int?
    var buildingOpp: Int?
    
    let latitude:CLLocationDegrees
    let longitude: CLLocationDegrees
    let coordinate:CLLocationCoordinate2D
    
    var photoFile: String?
    var isFavorite: Bool?
    
    init(buildingName:String, buildingOpp:Int, buildingYear:Int, coordinate:CLLocationCoordinate2D, isFavorite:Bool){
        self.buildingName = buildingName
        self.coordinate = coordinate
        self.buildingYear = buildingYear
        self.buildingOpp = buildingOpp
        self.isFavorite = isFavorite
        
        self.title = buildingName
        self.subtitle = " Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)"
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = buildingName
        return mapItem
    }
}


class buildingModel{
    static let sharedInstance = buildingModel()
    private let buildingData: [Building]
    private var favoriteBuilding: [Building]
    private let buildingDictionary: [String:[Building]]
    private let allKeys: [String]
    
    // temp data for pinning building to map -> DetailViewController
    var currentPin : Building?
    
    private init(){
        let path = NSBundle.mainBundle().pathForResource("buildings", ofType: "plist")
        let data = NSArray(contentsOfFile: path!) as! [[String:AnyObject]]
        
        var _building = [Building]()
        var _buildingDictionary = [String:[Building]]()
        
        for dictionary in data {
            let aBuilding = Building(buildingName: dictionary["name"] as! String, buildingOpp: dictionary["opp_bldg_code"] as! Int, buildingYear: dictionary["year_constructed"] as! Int, coordinate: CLLocationCoordinate2D(latitude: dictionary["latitude"] as! CLLocationDegrees, longitude: dictionary["longitude"] as! CLLocationDegrees), isFavorite: false)
            _building.append(aBuilding)
            if (dictionary["photo"] != nil){
                aBuilding.photoFile = dictionary["photo"] as? String
            }
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
    
    func getIndexPath(name: String) -> NSIndexPath{
        let firstLetter = name.firstLetter()!
        var section: Int?
        var row: Int?
        let indexPath: NSIndexPath
        for i in 0...(allKeys.count-1) {
            if firstLetter == allKeys[i]{
                section = i
            }
        }
        for j in 0...(numberOfBuildingsForSection(section!)-1){
            if name == buildingDictionary[firstLetter]![j].buildingName{
                row = j
            }
        }
        indexPath = NSIndexPath(forRow: row!, inSection: section!)
        return indexPath
    }
    
    func placesToPlot() -> [Building]{
        return buildingData
    }
}