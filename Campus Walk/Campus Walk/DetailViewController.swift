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
    var currentBuilding: Building { get }
    var indexPath: NSIndexPath { get }
}

class DetailViewController: UIViewController, GetDirectionsProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var buildingImage: UIImageView!
    @IBOutlet weak var buildingNameLabel: UILabel!
    @IBOutlet weak var buildingYearLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var dataSource: BuildingDetailDataSource?
    var campusModelSource: CampusModelInformation?
    var endSource: BuildingMapData?
    var endDest: BuildingMapData?
    
    var completionBlock : (() -> Void)?
    var tappedBuilding : BuildingMapData?
    
    let buildingMutableData = CampusModel.sharedInstance
    let imagePicker = UIImagePickerController()
    
    var _name: String = ""
    var _opp_bldg_code: String = ""
    var _year_constructed: String = ""
    var _coordinate: String = ""
    var _photoFile = ""
    var _isFavorite: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonTitle = (dataSource?.currentBuilding.isFavorite)! ? "Remove From Favorites" : "Add To Favorites"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.imageTapped(_:)))
        favoriteButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        navigationItem.title = dataSource?.currentBuilding.buildingName
        buildingImage.userInteractionEnabled = true
        buildingImage.addGestureRecognizer(tapGesture)
        imagePicker.delegate = self
        

    }
    override func viewWillLayoutSubviews() {
        reloadInputViews()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        buildingImage.backgroundColor = UIColor.grayColor()
        let buttonTitle = (dataSource?.currentBuilding.isFavorite)! ? "Remove From Favorites" : "Add To Favorites"
        favoriteButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        if (dataSource?.currentBuilding.photoFile)! != nil && (dataSource?.currentBuilding.photoFile)! != "" {
            buildingImage.image = UIImage(named: String((dataSource?.currentBuilding.photoFile)! + ".jpg"))
        }
        buildingNameLabel.text = "Building Name: " + String((dataSource?.currentBuilding.buildingName)!)
        buildingYearLabel.text = (dataSource?.currentBuilding.buildingYear)! == 0 ? "Year Built: " : "Year Built: " + String((dataSource?.currentBuilding.buildingYear)!)
    }
    
    func imageTapped (img : AnyObject ) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        buildingImage.image = image
        if let viewControllers = navigationController?.viewControllers {
            // print(viewControllers[viewControllers.count])
            print(viewControllers[viewControllers.count - 1])
            /*if !viewControllers[viewControllers.count - 1].isKindOfClass() {
             dismissViewControllerAnimated(false, completion: nil)
             }*/
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func removeFromFavorites(){
        let name = (dataSource?.currentBuilding.buildingName)!
        let firstLetter = name.substringToIndex(name.startIndex.successor())
        var index = 0
        for element in buildingMutableData.favoriteBuilding[firstLetter]! {
            if (element.buildingName == (dataSource?.currentBuilding.buildingName)!){
                break
            }
            index += 1
        }
        
        var indexPath = NSIndexPath()
        let section = buildingMutableData.keyIndex(firstLetter)
        
        
        for row in 0 ..< buildingMutableData.numberOfBuildingsForSection(section) {
            if(buildingMutableData.buildingAtPath(NSIndexPath(forRow: row, inSection: section)).buildingName == (dataSource?.currentBuilding.buildingName)!){
                indexPath = NSIndexPath(forRow: row, inSection: section)
                break
            }
        }
        buildingMutableData.changeFavorite(indexPath)
        removeFromPlotPlaces()
        buildingMutableData.favoriteBuilding[firstLetter]!.removeAtIndex(index)
        //buildingMutableData.saveArchive()
    }
    func removeFromPlotPlaces(){
        for index in 0  ..< buildingMutableData.plotBuilding.count  {
            if buildingMutableData.plotBuilding[index].title == (dataSource?.currentBuilding.buildingName)! {
                buildingMutableData.plotBuilding.removeAtIndex(index)
            }
        }
    }
    
    func addToFavorites(){
        let name = (dataSource?.currentBuilding.buildingName)!
        buildingMutableData.changeFavorite((dataSource?.indexPath)!)
        let firstLetter = name.substringToIndex(name.startIndex.successor())
        if let _ = buildingMutableData.favoriteBuilding[firstLetter] {
            buildingMutableData.favoriteBuilding[firstLetter]!.append((dataSource?.currentBuilding)!)
            
        } else {
            buildingMutableData.favoriteBuilding[firstLetter] = [(dataSource?.currentBuilding)!]
        }
        let lastIndex = buildingMutableData.favoriteBuilding[firstLetter]!.count
        buildingMutableData.favoriteKeys = Array(buildingMutableData.favoriteBuilding.keys).sort()
        buildingMutableData.favoriteBuilding[firstLetter]![lastIndex-1].isFavorite = true
        for key in buildingMutableData.favoriteKeys {
            buildingMutableData.favoriteBuilding[key]!.sortInPlace({ $0.buildingName < $1.buildingName })
        }
        buildingMutableData.plotBuilding.append(BuildingMapData(
            title: (dataSource?.currentBuilding.buildingName)!,
            coordinate: (dataSource?.currentBuilding.coordinate)!,
            photoName:  (dataSource?.currentBuilding.photoFile)!
            )
        )
        // buildingMutableData.saveArchive()
    }
    
    @IBAction func addFavoriteButton(sender: UIButton) {
        if sender.titleLabel?.text == "Add To Favorites" {
            addToFavorites()
        } else {
            removeFromFavorites()
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func pinToMapButton(sender: UIButton) {
        buildingMutableData.currentPin = BuildingMapData(
            title: (dataSource?.currentBuilding.buildingName)!,
            coordinate: (dataSource?.currentBuilding.coordinate)!,
            photoName: (dataSource?.currentBuilding.photoFile)!
        )
        self.tabBarController?.selectedIndex = 0
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "directionsDetailSegue":
            let directionsViewController = segue.destinationViewController as! DirectionsViewController
            directionsViewController.dataSource = self
            let currentBuilding = (dataSource?.currentBuilding)!
            directionsViewController.source = BuildingMapData(title: currentBuilding.buildingName!,
                                                             coordinate: currentBuilding.coordinate,
                                                             photoName: currentBuilding.photoFile!
            )
            break
        default:
            assert(false, "Unhandled Segue")
        }
    }
    
    func buildingSourceAndDestinationSelected(source: MKAnnotation?, destination: MKAnnotation?){
        endSource = source as? BuildingMapData
        endDest = destination as? BuildingMapData
        getDirections()
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func getDirections() {
        let walkingRouteRequest = MKDirectionsRequest()
        
        walkingRouteRequest.transportType = .Walking
        walkingRouteRequest.source = endSource?.mapItem()
        walkingRouteRequest.destination = endDest?.mapItem()
        
        walkingRouteRequest.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: walkingRouteRequest)
        
        directions.calculateDirectionsWithCompletionHandler({
            (response:MKDirectionsResponse?, error:NSError?) in
            if error != nil {
                
            } else {
                self.campusModelSource?.campusWalkBuildingInfoViewControllerDismissed(response, sourceBuilding: self.endSource!, destinationBuilding: self.endDest!)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
