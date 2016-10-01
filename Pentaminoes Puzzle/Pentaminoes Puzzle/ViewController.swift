//
//  ViewController.swift
//  Pentaminoes Puzzle
//
//  Created by Thadea Achmad on 9/13/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /*let boardImage = UIImage(named: "Board0.png")
     var boardImageView:UIImageView!*/
    
    
    func readPropertyList(){
        
        /*if let path = NSBundle.mainBundle().pathForResource("Solutions", ofType: "plist"),
            let arrayOfItems = NSArray(contentsOfFile: path)
        {
            
        }*/
        
        //let uDict = NSDictionary(){
        //print(arrayOfItems.description)
        //let chapterNames: [String] = arrayOfItems.valueForKeyPath("chapterName") as! NSArray as! [String]
        //let pageNumbers: [Int] = arrayOfItems.valueForKeyPath("pageNumber") as! NSArray as! [Int]
        
        
        // Format of property list
        var format = NSPropertyListFormat.XMLFormat_v1_0
        var plistData:[String:AnyObject] = [:]              // Data??
        
        let plistPath:String? = NSBundle.mainBundle().pathForResource("Solutions", ofType: "plist")!
        let plistXML = NSFileManager.defaultManager().contentsAtPath(plistPath!)!
        do{
            plistData = try NSPropertyListSerialization.propertyListWithData(plistXML, options: .MutableContainersAndLeaves, format: &format)
                as! [String:AnyObject]
        }
        catch{
            print("Error reading plist: \(error), format: \(format)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // IGNORE, JUST PRACTICE
        /*boardImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 420, height: 420))
         boardImageView.contentMode = .ScaleAspectFill
         boardImageView.image  = boardImage
         view.addSubview(boardImageView)*/
        
        
        createShapes()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var largeBoard: UIImageView!
    
    @IBAction func selectLargeBoard(sender: UIButton) {
        //Change the playing board image based on the selected..
        largeBoard.image = UIImage( named: "Board\(sender.tag)")
        
        
    }
    
    
    @IBAction func solvePuzzle(sender: UIButton) {
        readPropertyList()
    }
    
//////////////////////////////////////////////
    
    class shape{
        let tile: String
        let origin_x, origin_y, width, height: Int
        
        init(tile: String, x: Int, y: Int, width: Int, height: Int){
            self.tile = tile
            origin_x = x
            origin_y = y
            self.width = width
            self.height = height
        }
        
        func getView() -> UIImageView{
            let imageView = UIImageView(image: UIImage(named: tile))
            imageView.frame = CGRect(x: origin_x, y: origin_y, width: width, height: height)
            return imageView
        }
        
    }


    
    func createShapes(){
        
        let tileF = shape(tile: "tileF", x: -200, y: Int(largeBoard.frame.height) + 30, width: 90, height: 90)
        largeBoard.addSubview(tileF.getView())
        
        let tileI = shape(tile: "tileI", x: -30, y: Int(largeBoard.frame.height) + 60, width: 150, height: 30)
        largeBoard.addSubview(tileI.getView())
        
        let tileL = shape(tile: "tileL", x: 150, y: Int(largeBoard.frame.height) + 60, width: 120, height: 60)
        largeBoard.addSubview(tileL.getView())
        
        let tileN = shape(tile: "tileN", x: 330, y: Int(largeBoard.frame.height) + 60, width: 120, height: 60)
        largeBoard.addSubview(tileN.getView())
        
        let tileP = shape(tile: "tileP", x: 540, y: Int(largeBoard.frame.height) + 30, width: 60, height: 90)
        largeBoard.addSubview(tileP.getView())
        
        let tileT = shape(tile: "tileT", x: -200, y: Int(largeBoard.frame.height) + 180, width: 90, height: 90)
        largeBoard.addSubview(tileT.getView())
        
        let tileU = shape(tile: "tileU", x: 0, y: Int(largeBoard.frame.height) + 210, width: 90, height: 60)
        largeBoard.addSubview(tileU.getView())
        
        let tileV = shape(tile: "tileV", x: 180, y: Int(largeBoard.frame.height) + 180, width: 90, height: 90)
        largeBoard.addSubview(tileV.getView())
        
        let tileW = shape(tile: "tileW", x: 360, y: Int(largeBoard.frame.height) + 180, width: 90, height: 90)
        largeBoard.addSubview(tileW.getView())
        
        let tileX = shape(tile: "tileX", x: 540, y: Int(largeBoard.frame.height) + 180, width: 90, height: 90)
        largeBoard.addSubview(tileX.getView())
        
        let tileY = shape(tile: "tileY", x: -200, y: Int(largeBoard.frame.height) + 360, width: 120, height: 60)
        largeBoard.addSubview(tileY.getView())
        
        let tileZ = shape(tile: "tileZ", x: 0, y: Int(largeBoard.frame.height) + 330, width: 90, height: 90)
        largeBoard.addSubview(tileZ.getView())
        
    }



}

