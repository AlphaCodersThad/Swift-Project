//
//  AnnotationController.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 11/5/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol CampusModelInformation : class {
    func campusWalkBuildingInfoViewControllerDismissed(
        response: MKDirectionsResponse?,
        sourceBuilding: BuildingMapData,
        destinationBuilding: BuildingMapData
    )
}

class AnnotationController: UIViewController , GetDirectionsProtocol, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var campusBuildingImage: UIImageView!
    @IBOutlet weak var campusBuildingTitle: UILabel!
    
    weak var dataSource : CampusModelInformation?
    var tappedBuilding : BuildingMapData?
    var finalSource : BuildingMapData?
    var finalDest : BuildingMapData?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        campusBuildingImage.backgroundColor = UIColor.grayColor()
        campusBuildingImage.image = UIImage(named: (tappedBuilding?.photoName)!+".jpg")
        campusBuildingTitle.text = (tappedBuilding?.title)!
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AnnotationController.imageTapped(_:)))
        campusBuildingImage.userInteractionEnabled = true
        campusBuildingImage.addGestureRecognizer(tapGesture)
        imagePicker.delegate = self
    }
    
    func imageTapped (img : AnyObject ) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        campusBuildingImage.image = image
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func getDirections() {
        let walkingRouteRequest = MKDirectionsRequest()
        
        walkingRouteRequest.transportType = .Walking
        walkingRouteRequest.source = finalSource?.mapItem()
        walkingRouteRequest.destination = finalDest?.mapItem()
        
        walkingRouteRequest.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: walkingRouteRequest)
        
        directions.calculateDirectionsWithCompletionHandler({
            (response:MKDirectionsResponse?, error:NSError?) in
            
            if error != nil {
                
            } else {
                self.dataSource?.campusWalkBuildingInfoViewControllerDismissed(response, sourceBuilding: self.finalSource!, destinationBuilding: self.finalDest!)
            }
        })
    }
    
    func buildingSourceAndDestinationSelected(source: MKAnnotation?, destination: MKAnnotation?){
        finalSource = source as? BuildingMapData
        finalDest = destination as? BuildingMapData
        getDirections()
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "directionsSegue":
            let directionsViewController = segue.destinationViewController as! DirectionsViewController
            directionsViewController.dataSource = self
            directionsViewController.source = tappedBuilding
            break
            
        default:
            assert(false, "Unhandled Segue")
        }
    }
}
