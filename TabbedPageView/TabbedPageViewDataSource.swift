//
//  TabbedPageViewDataSource.swift
//  TabbedPageView
//
//  Created by Michael Onjack on 11/4/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit

public protocol TabbedPageViewDataSource: AnyObject {
    func tabs() -> [Tab]
    func sliderColor() -> UIColor
    func tabBarPosition() -> TabBarPosition
}

public extension TabbedPageViewDataSource {
    func sliderColor() -> UIColor {
        return UIColor.blue
    }
    
    func tabBarPosition() -> TabBarPosition {
        return .top
    }
}
