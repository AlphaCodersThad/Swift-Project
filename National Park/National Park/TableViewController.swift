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
    
    class NationalParksPhotosTableViewController: UITableViewController {
        
        let nationalParkData = NationalParksModel.sharedInstance
        var sectionCollapsed = [Bool](count: NationalParksModel.sharedInstance.numberOfColumns, repeatedValue: false)
        var scrollView : UIScrollView?
        let headerHeight : CGFloat = 60.0
        let zoomThreshold : CGFloat = 1.1
        var isSelected = false
        var oldWidth : CGFloat?
        var currentImageSelectedIndex : NSIndexPath?
        
        override func viewDidLoad() {
            oldWidth = self.view.bounds.width
        }
        
        override func viewDidLayoutSubviews() {
            if oldWidth != self.view.bounds.width && isSelected{
                scrollView?.removeFromSuperview()
                configureScrollView(currentImageSelectedIndex!)
            }
        }
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return nationalParkData.numberOfColumns
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return (!sectionCollapsed[section]) ? nationalParkData.numberOfRows(section) : 0
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("Table Cell", forIndexPath: indexPath) as! TableCell
            cell.sceneryLabel!.text = nationalParkData.sceneryCaption(indexPath.section, y: indexPath.row)
            let image = UIImage(named: nationalParkData.imagePath(indexPath.section, y: indexPath.row))
            cell.sceneryImage!.image = image
            return cell
        }
        // Setting the title here
        override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return nationalParkData.getParkTitle(section)
        }
        
        // Setting the height for the header section in UITableView
        override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return headerHeight;
        }
        
        //
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.scrollEnabled = false
            oldWidth = self.view.bounds.width
            currentImageSelectedIndex = indexPath
            isSelected = true
            configureScrollView(indexPath)
        }
        
        func configureScrollView(indexPath: NSIndexPath){
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
            
            scrollView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NationalParksPhotosTableViewController.imageTapped(_:))))
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
            
            /****** MARK : Comment this if you want clear background without any color!! ******************************************/
            /**/    scrollView!.backgroundColor = UIColor.darkGrayColor() // Changed from white bruh                                                          /**/
            /**********************************************************************************************************************/
        }
        
        func imageTapped(gesture: UITapGestureRecognizer){
            if scrollView?.zoomScale == 1{
                scrollView?.removeFromSuperview()
                super.tableView.scrollEnabled = true
                isSelected = false
            }
        }
        
        override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
            return nationalParkData.currentImage
        }
        
        
        override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerHeight))
            headerView.autoresizingMask = [.FlexibleWidth , .FlexibleHeight , .FlexibleLeftMargin , .FlexibleRightMargin , .FlexibleTopMargin , .FlexibleBottomMargin]
            let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerHeight))
            headerView.tag = section
            headerView.backgroundColor = UIColor.whiteColor()
            // headerLabel.layer.borderColor = UIColor.orangeColor().CGColor
            headerLabel.text = nationalParkData.getParkTitle(section)
            headerLabel.textAlignment = .Center                                             // Changed From Left
            headerView.addSubview(headerLabel)
            let headerTapped = UITapGestureRecognizer(target: self, action: #selector(NationalParksPhotosTableViewController.sectionHeaderTapped(_:)))
            headerView.addGestureRecognizer(headerTapped)
            return headerView
        }
        
        func sectionHeaderTapped (gestureRecognizer : UITapGestureRecognizer){
            let indexPath = NSIndexPath(forRow: 0, inSection: (gestureRecognizer.view?.tag)!)
            if indexPath.row == 0 {
                sectionCollapsed[indexPath.section] = !sectionCollapsed[indexPath.section]
                self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Right)   // Row animation changed from .Fade
            }
        }
    }

}
