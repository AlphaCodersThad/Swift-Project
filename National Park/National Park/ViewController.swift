//
//  ViewController.swift
//  National Park
//
//  Created by Thadea Achmad on 10/1/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var parkTitle: UILabel!
    @IBOutlet weak var sceneryTitle: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    //var nationalParkData: nationalParkModel
    
    var imageView: UIImageView?
    var photosData: NationalParkModel?
    var (x, y) = (0,0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pathToAssetsFile = NSBundle.mainBundle().pathForResource("Photos", ofType: "plist")
        photosData = NationalParksModel
        //mainScrollView.delegate = self
        mainScrollView.minimumZoomScale = 1.0
        mainScrollView.maximumZoomScale = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

