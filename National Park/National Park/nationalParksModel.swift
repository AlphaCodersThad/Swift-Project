//
//  nationalParksModel.swift
//  National Park
//
//  Created by Thadea Achmad on 10/1/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation


class NationalParksModel{
    
    
    private var photosFactory = [[ImageDetails]]()
    private var titles = [String]()
    
    private func importData(pathToAssetsFile : String?){
        for element in NSArray(contentsOfFile: pathToAssetsFile!)! as [AnyObject] {
            let photos = element as![String:AnyObject]
            for (key , value) in photos{
                if key == "name" {
                    let parkName = value as! String
                    titles.append(parkName)
                }
                if key == "photos" {
                    var captions = [ImageDetails]()
                    let imageAndCaption = value as! [[String:String]]
                    for elements in imageAndCaption {
                        captions.append(ImageDetails(imageFileName: elements["imageName"]!, caption: elements["caption"]!))
                    }
                    photosFactory.append(captions)
                }
            }
        }
    }

    
    func numberOfRows(x : Int) -> Int {
        return photosFactory[x].count
    }
    
    var numberOfColumns : Int { get { return titles.count } }
    
    func parkName(index : Int) -> String{
        return titles[index]
    }
    
    func imagePath(x: Int, y:Int) ->String{
        return photosFactory[x][y].imageFileName + ".png"
    }
    
    func imageCaption(x: Int, y: Int) -> String{
        return photosFactory[x][y].caption
    }
    
    init(pathToAssetsFile: String){
        importData(pathToAssetsFile)
    }
}

struct ImageDetails {
    var imageFileName : String
    var caption : String
}