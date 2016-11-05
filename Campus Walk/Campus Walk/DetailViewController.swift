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

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    weak var dataSource: BuildingDetailDataSource?
    @IBOutlet weak var buildingImage: UIImageView!
    @IBOutlet weak var buildingNameLabel: UILabel!
    @IBOutlet weak var buildingYearLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    let buildingMutableData = buildingModel.sharedInstance
    let imagePicker = UIImagePickerController()
    
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
            favoriteButton.setTitle("Add to Favorites", forState: UIControlState.Normal)
        }
        
        if !_photoFile.isEmpty {
            buildingImage.image = UIImage(named: (_photoFile + ".jpg"))
            buildingImage.contentMode = UIViewContentMode.ScaleAspectFit
        }
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
    
    
    @IBAction func pinToMapButton(sender: UIButton) {
        buildingMutableData.currentPin = dataSource?.currentBuilding
        self.tabBarController?.selectedIndex = 0
    }
    
    /*@IBAction func addToFavorite(sender: AnyObject) {
        if sender.titleLabel?.text == "Add To Favorites" {
            addToFavorites()
        } else {
            removeFromFavorites()
        }
        self.navigationController?.popViewControllerAnimated(true)
    }*/
    
    
    override func viewWillLayoutSubviews() {
        reloadInputViews()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func configureView(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, photoFile: String){
        _title = title
        _subtitle = subtitle
        _coordinate = coordinate
        _photoFile = photoFile
    }*/
    
    
}
