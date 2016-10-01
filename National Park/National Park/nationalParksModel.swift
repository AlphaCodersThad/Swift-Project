//
//  nationalParksModel.swift
//  National Park
//
//  Created by Thadea Achmad on 10/1/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation


class NationalParksModel  {
    

    
    func numberOfRows(x : Int) -> Int {
        return photosFactory[x].count
    }
    
    var numberOfColumns : Int { get { return titles.count } }
    
    func parkName(index : Int) -> String{
        return titles[index]
    }
    
    func imagePath(x: Int, y:Int) ->String{
        return photosFactory[x][y].imageFileName + ".jpg"
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