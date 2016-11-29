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
    fileprivate var photosDetail = [[ImageDetails]]()
    fileprivate var parkTitles = [String]()
    
    // PUBLIC VAR:
    var currentImage: UIImageView?
    
    fileprivate init(){
        let path = Bundle.main.path(forResource: "Photos", ofType: "plist")
        importData(path)
    }
    
    // Parsing data from property file
    fileprivate func importData(_ pathToAssetsFile : String?){
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
    
    func numberOfRows(_ x : Int) -> Int {
        return photosDetail[x].count
    }
    
    func parkName(_ index : Int) -> String{
        return parkTitles[index]
    }
    
    func imagePath(_ x: Int, y:Int) ->String{
        return photosDetail[x][y].imageFileName + ".png"
    }
    
    func sceneryCaption(_ x: Int, y: Int) -> String{
        return photosDetail[x][y].caption
    }
    
    func getParkTitle(_ x: Int) -> String {
        let parkTitle = photosDetail[x][0].imageFileName
        return parkTitle.substring(with: Range<String.Index> (parkTitle.characters.index(parkTitle.startIndex, offsetBy: 0) ..< parkTitle.characters.index(parkTitle.endIndex, offsetBy: -2) ))
    }
    
}

struct ImageDetails {
    var imageFileName : String
    var caption : String
}
