//
//  CampusWalkModel.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 10/22/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import MapKit


class Building: NSObject, NSCoding {
    
    
    var buildingName:String?
    var buildingYear:Int?
    var buildingOpp: Int?
    
    let buildingLatitude:CLLocationDegrees
    let buildingLongitude: CLLocationDegrees
    let coordinate:CLLocationCoordinate2D
    
    var photoFile: String?
    var isFavorite: Bool
    
    init(buildingName:String, buildingOpp:Int, buildingYear:Int, coordinate:CLLocationCoordinate2D, photoFile: String, isFavorite:Bool){
        self.buildingName = buildingName
        self.buildingYear = buildingYear
        self.buildingOpp = buildingOpp
        
        self.coordinate = coordinate
        self.buildingLatitude = coordinate.latitude
        self.buildingLongitude = coordinate.longitude
        
        self.photoFile = photoFile
        self.isFavorite = isFavorite

        super.init()
    }
 
                    ////////////// NSCoding Protocol //////////////
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(buildingName, forKey: "buildingName")
        aCoder.encodeObject(buildingYear, forKey: "buildingYear")
        aCoder.encodeObject(buildingOpp, forKey: "buildingOpp")
        aCoder.encodeObject(buildingLatitude, forKey: "buildingLatitude")
        aCoder.encodeObject(buildingLongitude, forKey: "buildingLongitude")
        aCoder.encodeObject(photoFile, forKey: "photoFile")
        aCoder.encodeObject(isFavorite, forKey: "IsFavorite")
    }
    
    required init?(coder aDecoder : NSCoder){
        self.buildingName = aDecoder.decodeObjectForKey("buildingName") as? String
        self.buildingOpp = aDecoder.decodeObjectForKey("buildingOpp") as? Int
        self.buildingYear = aDecoder.decodeObjectForKey("buildingYear") as? Int
        
        self.buildingLatitude = aDecoder.decodeObjectForKey("buildingLatitude") as! CLLocationDegrees
        self.buildingLongitude = aDecoder.decodeObjectForKey("buildingLongitude") as! CLLocationDegrees
        self.coordinate = CLLocationCoordinate2DMake(buildingLatitude, buildingLongitude)

        self.photoFile = aDecoder.decodeObjectForKey("photoFile") as? String
        self.isFavorite = aDecoder.decodeObjectForKey("isFavorite") as! Bool
    }
                    //////// END OF NSCoding Protocol //////////////
}

// Should be used for annotation purpose --> Seperate than the "Building" class model
class BuildingMapData: NSObject, NSCoding, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let buildingLatitude: CLLocationDegrees
    let buildingLongitude: CLLocationDegrees
    
    let photoName:String?
    
    init(title: String, coordinate: CLLocationCoordinate2D, photoName: String) {
        self.title = title
        self.coordinate = coordinate
        self.photoName = photoName
        self.buildingLatitude = coordinate.latitude
        self.buildingLongitude = coordinate.longitude
        super.init()
    }
    
    // MKAnnotation Protocol
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    // NSCoding Protocol
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.buildingLatitude, forKey: "buildingLatitude")
        aCoder.encodeObject(self.buildingLongitude, forKey: "buildingLongitude")
        aCoder.encodeObject(self.photoName, forKey: "photoName")
    }
    
    required init?(coder aDecoder : NSCoder){
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.photoName = aDecoder.decodeObjectForKey("photoName") as? String
        self.buildingLatitude = aDecoder.decodeObjectForKey("buildingLatitude") as! CLLocationDegrees
        self.buildingLongitude = aDecoder.decodeObjectForKey("buildingLongitude") as! CLLocationDegrees
        self.coordinate = CLLocationCoordinate2DMake(buildingLatitude, buildingLongitude)
        
    }
}

class CampusModel: NSObject, NSCoding {
    
    static let sharedInstance = CampusModel()
    private var buildingData = [Building]()
    
    private var buildingDictionary = [String:[Building]]()
    private var allKeys = [String]()
    private let archivePath = "DataArchive"
    
    // Map Data
    var currentPin: BuildingMapData?
    var plotBuilding = [BuildingMapData]()
    var removeBuilding = [BuildingMapData]()
    var favoriteBuilding = [String:[Building]]()
    var favoriteKeys = [String]()
    var MapViewOption: Int?
    
    private override init(){
        if let unarchivedModel = NSUserDefaults.standardUserDefaults().objectForKey(archivePath) as? NSData{
            let campusModel = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedModel) as? CampusModel
            
            buildingDictionary = campusModel!.buildingDictionary
            allKeys = campusModel!.allKeys
            
            currentPin = campusModel!.currentPin
            plotBuilding = campusModel!.plotBuilding
            removeBuilding = campusModel!.removeBuilding
            favoriteBuilding = campusModel!.favoriteBuilding
            favoriteKeys = campusModel!.favoriteKeys
            MapViewOption = campusModel!.MapViewOption
        } else{
            let path = NSBundle.mainBundle().pathForResource("buildings", ofType: "plist")
            let data = NSArray(contentsOfFile: path!) as! [[String:AnyObject]]
            
            var _building = [Building]()
            var _buildingDictionary = [String:[Building]]()
            
            for dictionary in data {
                let aBuilding = Building(buildingName: dictionary["name"] as! String,
                                         buildingOpp: dictionary["opp_bldg_code"] as! Int,
                                         buildingYear: dictionary["year_constructed"] as! Int,
                                         coordinate: CLLocationCoordinate2D(
                                            latitude: dictionary["latitude"] as! CLLocationDegrees,
                                            longitude: dictionary["longitude"] as! CLLocationDegrees),
                                         photoFile: dictionary["photo"] as! String,
                                         isFavorite: false)
                
                _building.append(aBuilding)
                let firstLetter = aBuilding.buildingName!.firstLetter()!
                
                if let _ = _buildingDictionary[firstLetter] {
                    _buildingDictionary[firstLetter]!.append(aBuilding)
                } else {
                    _buildingDictionary[firstLetter] = [aBuilding]
                }
            }
            //favoriteBuilding = [Building]()
            buildingData = _building
            buildingDictionary = _buildingDictionary
            let keys = Array(buildingDictionary.keys)
            allKeys = keys.sort()
            for key in allKeys {
                buildingDictionary[key]!.sortInPlace({ $0.buildingName < $1.buildingName})
            }
            MapViewOption = 0
        }
    }
    
    private func importData(path: String?){
        let data = NSArray(contentsOfFile: path!) as!  [[String:AnyObject]]
        var _building = [Building]()
        var _buildingDictionary = [String:[Building]]()
        for dictionary in data {
            let aBuilding = Building(buildingName: dictionary["name"] as! String,
                                     buildingOpp: dictionary["opp_bldg_code"] as! Int,
                                     buildingYear: dictionary["year_constructed"] as! Int,
                                     coordinate: CLLocationCoordinate2D(
                                        latitude: dictionary["latitude"] as! CLLocationDegrees,
                                        longitude: dictionary["longitude"] as! CLLocationDegrees),
                                     photoFile: dictionary["photo"] as! String,
                                     isFavorite: false)
            
            _building.append(aBuilding)
            let firstLetter = aBuilding.buildingName!.firstLetter()!
            
            if let _ = _buildingDictionary[firstLetter] {
                _buildingDictionary[firstLetter]!.append(aBuilding)
            } else {
                _buildingDictionary[firstLetter] = [aBuilding]
            }
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(buildingDictionary, forKey : "buildingDictionary")
        aCoder.encodeObject(allKeys, forKey : "allKeys")
        aCoder.encodeObject(currentPin, forKey: "currentPin")
        aCoder.encodeObject(plotBuilding, forKey : "plotBuilding")
        aCoder.encodeObject(removeBuilding, forKey : "removeBuilding")
        aCoder.encodeObject(favoriteBuilding, forKey : "favoriteBuilding")
        aCoder.encodeObject(favoriteKeys, forKey : "favoriteKeys")
        aCoder.encodeObject(MapViewOption, forKey: "MapViewOption")
    }
    
    required init?(coder aDecoder : NSCoder){
        self.buildingDictionary = aDecoder.decodeObjectForKey("buildingDictionary") as! [String:[Building]]
        self.allKeys = aDecoder.decodeObjectForKey("allKeys") as! [String]
        self.currentPin = aDecoder.decodeObjectForKey("currentPin") as? BuildingMapData
        self.plotBuilding = aDecoder.decodeObjectForKey("plotPlaces") as! [BuildingMapData]
        self.removeBuilding = aDecoder.decodeObjectForKey("removeBuilding") as! [BuildingMapData]
        self.favoriteBuilding = aDecoder.decodeObjectForKey("favoriteBuildings") as! [String:[Building]]
        self.favoriteKeys = aDecoder.decodeObjectForKey("favoriteKeys") as! [String]
        self.MapViewOption = aDecoder.decodeObjectForKey("MapViewOption") as? Int
    }
    
    func saveArchive() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(CampusModel.sharedInstance)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: archivePath)
    }
    
    // Functions
    func titleForSection(section: Int) -> String {
        return allKeys[section]
    }
    
    func allSectionTitles() -> [String]{
        return allKeys
    }
    
    func numberOfBuildings() -> Int {
        return buildingData.count
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
        return buildingAtPath(indexPath).buildingName!
    }
    
    func favoriteBuildingAtPath(indexPath: NSIndexPath) -> Building {
        let index = indexPath.section
        let buildingIndex = favoriteKeys[index]
        return (favoriteBuilding[buildingIndex]![indexPath.row])
    }
    
    func keyIndex (key: String) -> Int {
        return allKeys.indexOf(key)!
    }
    
    func changeFavorite(indexPath: NSIndexPath){
        let letter = allKeys[indexPath.section]
        let favoriteState = !(buildingDictionary[letter])![indexPath.row].isFavorite
        (buildingDictionary[letter]!)[indexPath.row].isFavorite = favoriteState
    }
    
    func placesToPlot() -> [Building]{
        return buildingData
    }
    
    
    /*func getIndexPath(name: String) -> NSIndexPath{
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
     }*/
}