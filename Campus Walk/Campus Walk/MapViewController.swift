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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    let buildingMutableData = buildingModel.sharedInstance
    let locationManager = CLLocationManager()
    
    
    // This coordinate is taken from Old Main, which is pretty much center of Penn State
    let startPoint = CLLocationCoordinate2D(latitude: 40.7965, longitude: -77.8627)
    let startingSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let calloutImageSize = CGSize(width: 40, height: 40)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.pinDrop(_:)))
        mapView.addGestureRecognizer(recognizer)
        configureLocationManager()
    }
    
    override func viewDidAppear(animated: Bool) {
        if CLLocationManager.locationServicesEnabled(){
            if CLLocationManager.authorizationStatus() == .NotDetermined{
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //mapView.addAnnotations(buildingMutableData.placesToPlot())
        if let _ = buildingMutableData.currentPin {
            let _lat = CLLocationDegrees(buildingMutableData.currentPin!.coordinate.latitude)
            let _long = CLLocationDegrees(buildingMutableData.currentPin!.coordinate.longitude)
            let centerLocation = CLLocation(latitude: _lat, longitude: _long)
            mapView.addAnnotation(buildingMutableData.currentPin!)
            centerMapOnLocation(centerLocation)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.regionThatFits(coordinateRegion)
    }
///////////////////////////////////////////////////////////
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            mapView.showsUserLocation = false
            locationManager.stopUpdatingLocation()
        }
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func pinDrop(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .Began {
            let location = recognizer.locationInView(mapView)
            let coordinate = mapView.convertPoint(location, toCoordinateFromView: mapView)
            let pinAnnotation = MKPointAnnotation()
            pinAnnotation.coordinate = coordinate
            //pinAnnotation.title = "Coordinate"
            pinAnnotation.subtitle = "Lat: \(coordinate.latitude), Long: \(coordinate.longitude)"
            
            
            let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) -> Void in
                if error != nil {
                    
                } else {
                    if let aPlacemark = placemarks!.first {
                        pinAnnotation.title = aPlacemark.name
                        self.mapView.addAnnotation(pinAnnotation)
                    }
                }
            })
        }
    }
    
    func configureMapView() {
        mapView.region = MKCoordinateRegion(center: startPoint, span: startingSpan)
        //mapView.addAnnotations(building.placesToPlot())
        mapView.delegate = self
    }
    
    // Used to create annotation whenever it is needed on the Mao View
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if let annotation = annotation as? buildingModel.Building {
            let identifier = "BuildingPin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinView.canShowCallout = true
                pinView.calloutOffset = CGPoint(x: -5, y: 5)
                pinView.pinTintColor = (buildingMutableData.currentPin?.title == annotation.title) ? UIColor.redColor() : UIColor.blueColor()
                pinView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                return pinView
            }
            return view
        }
        return nil

    }
    

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegueWithIdentifier("DetailSegue", sender: self)
    }
    
    /*func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        building.building
    }
    
    var currentBuilding : buildingModel.Building {
        get{
            return MKAnnotation(self.mapView.selectedAnnotations)
        }
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*switch segue.identifier! {
        case "DetailSegue":
            if let detailViewController = segue.destinationViewController as? DetailViewController {
                let annotation = mapView.selectedAnnotations.first! as! buildingModel.Building
                detailViewController.dataSource?.currentBuilding = annotation
            }
        default:
            assert(false, "Unhandled Segue")
        }*/
    }
///////////////////////////////////////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

