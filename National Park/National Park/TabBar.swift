//
//  TabBar.swift
//  National Park
//
//  Created by Thadea Achmad on 10/8/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import UIKit

class TabBar: UITabBar {
    
    let height : CGFloat = 60.0
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var currentTabBarSize = super.sizeThatFits(size)
        currentTabBarSize.height = height
        return currentTabBarSize
    }
}
