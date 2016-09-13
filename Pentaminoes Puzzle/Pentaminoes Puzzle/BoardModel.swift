//
//  BoardModel.swift
//  Pentominoes Puzzle
//
//  Created by Thadea Achmad on 9/13/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation


class BoardModel{
    private let boardModel : [String]
    let boardCount : Int = 12
    
    
    init() {
        var _boardModel = [String]()
        
        // Almsost like the example, except we're appending 12 pieces here
        for i in 0..<boardCount {
            _boardModel.append("oldLion\(i).jpg")
        }
        boardModel = _puzzlePieces
    }
    
    func getPuzzlePieces(i: Int) -> String {
        return boardModel[i]
    }
}