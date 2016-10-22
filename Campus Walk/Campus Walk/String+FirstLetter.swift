//
//  String+FirstLetter.swift
//  Campus Walk
//
//  Created by Thadea Achmad on 10/22/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
extension String {
    func firstLetter() -> String? {
        return (self.isEmpty ? nil : self.substringToIndex(self.startIndex.successor()))
    }
}
