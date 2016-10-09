//
//  NationalParksModel.swift
//  National Park
//
//  Created by Thadea Achmad on 10/1/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import UIKit


class NationalParksModel{
    
    static let sharedInstance = NationalParksModel()

    // PRIVATE:
    private var photosDetail = [[ImageDetails]]()
    private var parkTitles = [String]()
    
    // PUBLIC VAR:
    var currentImage: UIImageView?
    
    private init(){
        let path = NSBundle.mainBundle().pathForResource("Photos", ofType: "plist")
        importData(path)
    }
    
    // Parsing data from property file
    private func importData(pathToAssetsFile : String?){
        for element in NSArray(contentsOfFile: pathToAssetsFile!)! as [AnyObject]{
            let photos = element as![String:AnyObject]
            
            // read and append plist values
            for (key , value) in photos{
                if key == "name" {
                    let parkName = value as! String
                    parkTitles.append(parkName)
                }
                if key == "photos" {
                    var captions = [ImageDetails]()
                    let imageAndCaption = value as! [[String:String]]
                    for elements in imageAndCaption {
                        captions.append(ImageDetails(imageFileName: elements["imageName"]!, caption: elements["caption"]!))
                    }
                    photosDetail.append(captions)
                }
            }
        }
    }

    // PUBLIC:
    var totalColumns : Int {
        get { return parkTitles.count }
    }
    
    func numberOfRows(x : Int) -> Int {
        return photosDetail[x].count
    }
    
    func parkName(index : Int) -> String{
        return parkTitles[index]
    }
    
    func imagePath(x: Int, y:Int) ->String{
        return photosDetail[x][y].imageFileName + ".png"
    }
    
    func sceneryCaption(x: Int, y: Int) -> String{
        return photosDetail[x][y].caption
    }
    
    func getParkTitle(x: Int) -> String {
        let parkTitle = photosDetail[x][0].imageFileName
        return parkTitle.substringWithRange(Range<String.Index> (parkTitle.startIndex.advancedBy(0) ..< parkTitle.endIndex.advancedBy(-2) ))
    }
    
}

struct ImageDetails {
    var imageFileName : String
    var caption : String
}