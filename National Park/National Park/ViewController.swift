//
//  ViewController.swift
//  National Park
//
//  Created by Thadea Achmad on 10/1/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    
    ///////////////// [ VARIABLE DECLARATION ] /////////////////

    @IBOutlet weak var parkTitle: UILabel!
    @IBOutlet weak var sceneryTitle: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    
    //var nationalParkData: nationalParkModel
    
    var imageView: UIImageView?
    var photosData: NationalParksModel?
    var x = 0, y = 0

    
    ///////////////// [ View ] /////////////////

    override func viewDidLoad() {
        super.viewDidLoad()
        let pathToAssetsFile = NSBundle.mainBundle().pathForResource("Photos", ofType: "plist")
        photosData = NationalParksModel(pathToAssetsFile: pathToAssetsFile!)
        
        
        mainScrollView.delegate = self
        mainScrollView.minimumZoomScale = 1.0
        mainScrollView.maximumZoomScale = 10.0
    }
    
    override func viewDidLayoutSubviews()
    {
        super.view.bringSubviewToFront(parkTitle)
        super.view.bringSubviewToFront(sceneryTitle)
        
        // Reading from property list to change labels of specific park->scenery
        parkTitle.text = photosData!.parkName(x)
        configureScrollView()
        sceneryTitle.text = photosData!.sceneryCaption(x, y: y)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    ///////////////// [ Functions/Methods ] /////////////////

    
    func configureScrollView(){
        
        let viewSize = mainScrollView.bounds.size
        let numberOfColumns = photosData!.numberOfColumns
        
        for j in 0..<photosData!.numberOfRows(x) {
            let frame = CGRect(x: viewSize.width*(CGFloat(x)), y: viewSize.height*(CGFloat(j)), width: viewSize.width, height: viewSize.height)
            let image = UIImage(named: photosData!.imagePath(x, y: j))
            imageView = UIImageView(frame: frame)
            imageView!.image = image
            imageView!.contentMode = .ScaleAspectFit
            imageView?.autoresizingMask = [.FlexibleWidth , .FlexibleHeight , .FlexibleLeftMargin , .FlexibleRightMargin , .FlexibleTopMargin , .FlexibleBottomMargin]
            mainScrollView.addSubview(imageView!)
        }
        
        mainScrollView.contentSize = CGSize(width: viewSize.width*CGFloat(numberOfColumns), height: viewSize.height*CGFloat(photosData!.numberOfRows(x)))
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        if scrollView.contentOffset.y > 0 {
            var offset = scrollView.contentOffset
            offset.x = CGFloat(x)*scrollView.frame.width
            scrollView.contentOffset = offset
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        x = Int(scrollView.contentOffset.x / scrollView.frame.width)
        y = Int(scrollView.contentOffset.y / scrollView.frame.height)
        sceneryTitle.text = photosData!.sceneryCaption(x, y: y)
        configureScrollView()
    }
    
    // MARK: TODO!
    
    @IBAction func zoomInOut(sender: UIPinchGestureRecognizer) {
        if sender.state == .Ended || sender.state == .Changed {
           
            
            
            /* var vWidth = self.view.frame.width
            var vHeight = self.view.frame.height
            
            var scrollImg: UIScrollView = UIScrollView()
            scrollImg.delegate = self
            scrollImg.frame = CGRectMake(0, 0, vWidth, vHeight)
            scrollImg.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
            scrollImg.alwaysBounceVertical = false
            scrollImg.alwaysBounceHorizontal = false
            scrollImg.showsVerticalScrollIndicator = true
            scrollImg.flashScrollIndicators()
            
            scrollImg.minimumZoomScale = 1.0
            scrollImg.maximumZoomScale = 10.0
            
            mainScrollView.addSubview(scrollImg)
            
            imageView!.layer.cornerRadius = 11.0
            imageView!.clipsToBounds = false
            scrollImg.addSubview(imageView!)*/
            
        }

    }
    
    
    //  Scale view when zooming is about to occur in scroll view
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        // I have to update imageView here somehow
    }


}

