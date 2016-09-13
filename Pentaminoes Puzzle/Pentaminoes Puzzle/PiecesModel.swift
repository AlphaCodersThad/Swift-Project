//
//  PuzzleModel.swift
//  Pentominoes Puzzle
//
//  Created by Thadea Achmad on 9/13/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation


class PiecesModel{
    private let puzzlePieces : [String]
    let piecesCount : Int = 12
    
    
    init() {
        var _puzzlePieces = [String]()
        
        // Almsost like the example, except we're appending 12 pieces here
        for i in 0..<piecesCount {
            _puzzlePieces.append("oldLion\(i).jpg")
        }
        puzzlePieces = _puzzlePieces
    }

    func getPuzzlePieces(i: Int) -> String {
        return puzzlePieces[i]
    }
    
}