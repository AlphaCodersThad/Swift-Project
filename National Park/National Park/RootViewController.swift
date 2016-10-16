//
//  RootViewController.swift
//  National Park
//
//  Created by Thadea Achmad on 10/15/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController , UIPageViewControllerDataSource{
    
    var pageViewController : UIPageViewController?
    var pageTitles: NSArray!
    var pageImages: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageTitles = NSArray(objects: "1st Preview" ,"2nd Preview", "3rd Preview")
        self.pageImages = NSArray(objects: "Image1" , "Image2", "Image3")
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        self.pageViewController?.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0)
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController?.setViewControllers( viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController?.view.frame = CGRectMake(0.0, 30.0, self.view.frame.width, self.view.frame.height - 60)
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview( (self.pageViewController?.view)!)
        self.pageViewController?.didMoveToParentViewController(self)
    }
    
    func viewControllerAtIndex(index:  Int) -> ContentViewController{
        if self.pageTitles?.count == 0 || index >= self.pageTitles?.count {
            return ContentViewController()
        }
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        vc.imageFile = self.pageImages[index] as? String
        vc.titleText = self.pageTitles[index] as? String
        vc.pageIndex = index
        return vc
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        index! -= 1
        return self.viewControllerAtIndex(index!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex
        
        if index == NSNotFound {
            return nil
        }
        index! += 1
        
        if index == self.pageTitles.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index!)
    }
}