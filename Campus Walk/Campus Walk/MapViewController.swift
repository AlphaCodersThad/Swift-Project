//
//  ViewController.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 10/19/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class MapViewController: UIViewController, CampusModelInformation, SearchCampusBuildings, DirectionTableDataSource, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationText: UITextView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let buildingMutableData = CampusModel.sharedInstance
    let locationManager = CLLocationManager()
    
    var stepByStepDirections : [MKRouteStep]?
    var directionCount : Int = 0
    
    var response : MKDirectionsResponse?
    var sourceBuilding : BuildingMapData?
    var destinationBuilding : BuildingMapData?
    
    let centerOfCampus = CLLocation(
        latitude: CLLocationDegrees("40.7981184")!,
        longitude: CLLocationDegrees("-77.8610388")!
    )
    
    var directions : [MKRouteStep]? {
        get {
            return stepByStepDirections
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationText.hidden = true
        nextButton.hidden = true
        previousButton.hidden = true
        moreButton.hidden = true
        navigationText.editable = false
        cancelButton.hidden = true
        centerMapOnLocation(centerOfCampus)
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        navigationText.textAlignment = NSTextAlignment.Center
        setMapType()
        self.navigationItem.rightBarButtonItem = MKUserTrackingBarButtonItem(mapView: mapView)
    }
    
    override func viewWillAppear(animated: Bool) {
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
        mapView.addAnnotations(buildingMutableData.plotBuilding)
        if let _ = buildingMutableData.currentPin {
            let location = CLLocation(latitude: (buildingMutableData.currentPin?.coordinate.latitude)!,
                                      longitude: (buildingMutableData.currentPin?.coordinate.longitude)!
            )
            centerMapOnLocation(location)
            mapView.addAnnotation(buildingMutableData.currentPin!)
        }
        
        if let _ = sourceBuilding {
            campusWalkBuildingInfoViewControllerDismissed(response, sourceBuilding: sourceBuilding!, destinationBuilding: destinationBuilding!)
        }
        setMapType()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.locationServicesEnabled()  {
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    func setMapType(){
        switch buildingMutableData.MapViewOption! {
        case 0:
            mapView.mapType = MKMapType.Standard
            
        case 1:
            mapView.mapType = MKMapType.Satellite
            
        case 2:
            mapView.mapType = MKMapType.Hybrid
            
        default:
            break
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.regionThatFits(coordinateRegion)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            self.mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            self.mapView.showsUserLocation = false
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    @IBAction func stepByStep(sender: UIButton) {
        if sender.tag == 0 {
            directionCount += 1
            previousButton.hidden = false
            previousButton.enabled = true
            navigationText.text = stepByStepDirections![directionCount].instructions
            
            if directionCount+1 == stepByStepDirections?.count {
                nextButton.hidden = true
            }
        } else if sender.tag == 1 {
            directionCount -= 1
            nextButton.hidden = false
            navigationText.text = stepByStepDirections![directionCount].instructions
            
            if directionCount-1 < 0 {
                previousButton.hidden = true
            }
        }
        
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        previousButton.hidden = true
        nextButton.hidden = true
        navigationText.hidden = true
        sender.hidden = true
        moreButton.hidden = true
        
        previousButton.enabled = false
        nextButton.enabled = false
        sender.enabled = false
        moreButton.enabled = false
        
        mapView.removeOverlays(mapView.overlays)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blackColor()
            polylineRenderer.lineWidth = 4.0
            
            return polylineRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func campusWalkBuildingInfoViewControllerDismissed(response: MKDirectionsResponse?, sourceBuilding: BuildingMapData, destinationBuilding: BuildingMapData){
        tabBarController?.selectedIndex = 0
        moreButton.hidden = false
        moreButton.enabled = true
        cancelButton.hidden = false
        cancelButton.enabled = true
        navigationText.hidden = false
        moreButton.hidden = false
        for route in (response?.routes)! {
            self.mapView.addOverlay(route.polyline)
            
            stepByStepDirections = route.steps
            
            directionCount = 0
            navigationText.text = stepByStepDirections![directionCount].instructions
            
            previousButton.hidden = true
            nextButton.hidden = false
            nextButton.enabled = true
            if directionCount+1 == stepByStepDirections?.count {
                nextButton.hidden = true
            }
        }
        
        let region = MKCoordinateRegionMakeWithDistance((response?.source.placemark.location?.coordinate)!, 2000, 2000)
        mapView.setRegion(region, animated: false)
        mapView.selectAnnotation(sourceBuilding, animated: false)
        
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("annotationController") as! AnnotationController
        detailViewController.dataSource = self
        detailViewController.tappedBuilding = view.annotation as? BuildingMapData
        self.presentViewController(detailViewController, animated: false, completion: nil)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        if let annotation = annotation as? BuildingMapData {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                let pinView =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinView.canShowCallout = true
                pinView.calloutOffset = CGPoint(x: -5, y: 5)
                pinView.pinTintColor = (buildingMutableData.currentPin?.title == annotation.title ) ? UIColor.redColor() : UIColor.blueColor()
                pinView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                return pinView
            }
            return view
        }
        return nil
    }
    
    func buildingSearchViewControllerDismissed(buildingClicked: BuildingMapData) {
        mapView.selectAnnotation(buildingClicked, animated: true)
        
        mapView.removeOverlays(mapView.overlays)
        
        centerMapOnLocation(CLLocation(latitude: buildingClicked.coordinate.latitude, longitude: buildingClicked.coordinate.longitude))
        
        dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "directionSegue" :
            let directionsViewController = segue.destinationViewController as! DirectionTableViewController
            directionsViewController.dataSource = self
            break
            
        default :
            assert(false, "Unhandled Segue")
        }
    }
    
}