//
//  TabBar.swift
//  National Park
//
//  Created by Thadea Achmad on 10/8/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import UIKit

class TabBar: UITabBar {
    override func sizeThatFits(size: CGSize) -> CGSize {
        var currentTabBarSize = super.sizeThatFits(size)
        currentTabBarSize.height = 70.0
        return currentTabBarSize
    }
}
