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
    
    let building = buildingModel.sharedInstance
    let locationManager = CLLocationManager()
    
    let startPoint = CLLocationCoordinate2D(latitude: 40.7965, longitude: -77.8627)
    let startingSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let calloutImageSize = CGSize(width: 40, height: 40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
    }
    
    override func viewDidAppear(animated: Bool) {
        if CLLocationManager.locationServicesEnabled(){
            if CLLocationManager.authorizationStatus() == .NotDetermined{
                locationManager.requestWhenInUseAuthorization()
            }
        }
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
        mapView.addAnnotations(building.placesToPlot())
        mapView.delegate = self
    }
    
    /*
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? buildingModel.Building {
            let identifier = String(annotation.category)
            let view: MKAnnotationView
            if let dequedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
                dequedView.annotation = annotation
                view = dequedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                
                let image = UIImage(named: annotation.photoName!)
                let imageView = UIImageView(image: image)
                imageView.frame.size = calloutImageSize
                
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                view.leftCalloutAccessoryView = imageView
                
                let buildingType = annotation.category
                view.image = model.imageForBuildingType(buildingType)
            }
            return view
        }
        
        if annotation is MKPointAnnotation {
            let identifier = "DroppedPin"
            var view: MKPinAnnotationView
            if let dequedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequedView.annotation = annotation
                view = dequedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                view.canShowCallout = true
                view.pinTintColor = UIColor.blueColor()
                view.animatesDrop = true
                view.draggable = true
            }
            
            return view
        }
        
        return nil
    }*/
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegueWithIdentifier("detailSegue", sender: self)
    }
///////////////////////////////////////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

