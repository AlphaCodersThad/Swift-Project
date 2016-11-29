//
//  TableViewController.swift
//  National Park
//
//  Created by Thadea Achmad on 10/8/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController{
    
    let nationalParkData = NationalParksModel.sharedInstance
    var sectionCollapsed = [Bool](repeating: false, count: NationalParksModel.sharedInstance.totalColumns)
    //var scrollView : UIScrollView?
    let headerHeight : CGFloat = 60.0
    let zoomThreshold : CGFloat = 1.1
    //var isSelected = false
    var oldWidth : CGFloat?
    var currentImageSelectedIndex : IndexPath?
    let heightOfLabel : CGFloat = 45
    let textSize : CGFloat = 30
    
    override func viewDidLoad() {
        currentImageSelectedIndex = IndexPath(row: 0, section: 0)

    }
    
    /*override func viewDidLayoutSubviews() {
        if oldWidth != self.view.bounds.width && isSelected{
            scrollView?.removeFromSuperview()
            configureScrollView(currentImageSelectedIndex!)
        }
    }*/
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return nationalParkData.totalColumns
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (!sectionCollapsed[section]) ? nationalParkData.numberOfRows(section) : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Table Cell", for: indexPath) as! TableCell
        cell.sceneryLabel!.text = nationalParkData.sceneryCaption(indexPath.section, y: indexPath.row)
        let image = UIImage(named: nationalParkData.imagePath(indexPath.section, y: indexPath.row))
        cell.sceneryImage!.image = image
        return cell
    }
    
    // Setting the title here
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let GrandTeton = "GrandTeton"
        let BryceCanyon = "BryceCanyon"
        
        if nationalParkData.getParkTitle(section) == GrandTeton {
            return "Grand Teton"
        }
        else if nationalParkData.getParkTitle(section) == BryceCanyon{
            return "Bryce Canyon"
        }
        else{
            return nationalParkData.getParkTitle(section)
        }
    }
    
    // Setting the height for the header section in UITableView
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight;
    }
    
    //
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.scrollEnabled = false
        oldWidth = self.view.bounds.width
        currentImageSelectedIndex = indexPath
        isSelected = true
        configureScrollView(indexPath)
    }*/
    
    /*func configureScrollView(indexPath: NSIndexPath){
        let viewSize = self.view.bounds.size
        
        let tableViewOffsetIndex = self.tableView.rectForRowAtIndexPath(indexPath)
        let tableViewOffsetView = self.tableView.convertPoint(tableViewOffsetIndex.origin, fromCoordinateSpace: tableView)
        
        
        let tableViewOffset = self.tableView.contentOffset
        let frame = CGRect(x: viewSize.width - 151, y: tableViewOffsetView.y, width:151, height: 81)
        let imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: nationalParkData.imagePath(indexPath.section, y: indexPath.row))
        
        scrollView = UIScrollView(frame: CGRect(x: tableViewOffset.x, y: tableViewOffset.y, width: viewSize.width, height: viewSize.height) )
        imageView.contentMode = .ScaleAspectFit
        imageView.autoresizingMask = [.FlexibleWidth , .FlexibleHeight , .FlexibleLeftMargin , .FlexibleRightMargin , .FlexibleTopMargin , .FlexibleBottomMargin]
        nationalParkData.currentImage = imageView
        
        scrollView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TableViewController.imageTapped(_:))))
        scrollView!.addSubview(nationalParkData.currentImage!)
        scrollView!.contentSize = self.view.bounds.size
        scrollView!.delegate = self
        scrollView!.minimumZoomScale = 1.0
        scrollView!.maximumZoomScale = 10.0
        self.view.addSubview(scrollView!)
        self.view.bringSubviewToFront(scrollView!)
        
        UIView.animateWithDuration(2.0) { () -> Void in
            imageView.frame = CGRect(x: 0.0 , y: 0.0 ,width: viewSize.width, height: viewSize.height)
        }
        scrollView!.backgroundColor = UIColor.darkGrayColor()
    }
    
    func imageTapped(gesture: UITapGestureRecognizer){
        if scrollView?.zoomScale == 1{
            scrollView?.removeFromSuperview()
            super.tableView.scrollEnabled = true
            isSelected = false
        }
    }*/
    
    /*override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return nationalParkData.currentImage
    }*/
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerHeight))
        headerView.autoresizingMask = [.flexibleWidth , .flexibleHeight , .flexibleLeftMargin , .flexibleRightMargin , .flexibleTopMargin , .flexibleBottomMargin]
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerHeight))
        headerView.tag = section
        headerView.backgroundColor = UIColor.white
        // headerLabel.layer.borderColor = UIColor.orangeColor().CGColor
        headerLabel.text = nationalParkData.getParkTitle(section)
        headerLabel.textAlignment = .center                                             // Changed From Left
        headerView.addSubview(headerLabel)
        let headerTapped = UITapGestureRecognizer(target: self, action: #selector(TableViewController.sectionHeaderTapped(_:)))
        headerView.addGestureRecognizer(headerTapped)
        return headerView
    }
    
    func sectionHeaderTapped (_ gestureRecognizer : UITapGestureRecognizer){
        let indexPath = IndexPath(row: 0, section: (gestureRecognizer.view?.tag)!)
        if indexPath.row == 0 {
            sectionCollapsed[indexPath.section] = !sectionCollapsed[indexPath.section]
            self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .right)   // Row animation changed from .Fade
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "getImageDetail" {
            let control = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            let imageName = self.nationalParkData.imagePath(indexPath!.section, y: indexPath!.row)
            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: control.view.frame.width, height: control.view.frame.height))
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFit
            imageView.autoresizingMask = [.flexibleWidth , .flexibleHeight , .flexibleLeftMargin , .flexibleRightMargin , .flexibleTopMargin , .flexibleBottomMargin]
            let caption = UILabel(frame: CGRect(x: 0.0, y: control.view.frame.height/2, width: control.view.frame.width, height: heightOfLabel))
            caption.text = nationalParkData.sceneryCaption(indexPath!.section, y: indexPath!.row)
            caption.textColor = UIColor.magenta
            caption.font = UIFont(name: "HelveticaNeue-Bold", size: textSize)
            // caption.backgroundColor = UIColor.lightGrayColor()
            caption.textAlignment = .center
            
            control.view.addSubview(imageView)
            control.view.addSubview(caption)
        }
    }

}
