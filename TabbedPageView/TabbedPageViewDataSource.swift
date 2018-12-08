//
//  TabbedPageViewDataSource.swift
//  TabbedPageView
//
//  Created by Michael Onjack on 11/4/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit

public protocol TabbedPageViewDataSource: AnyObject {
    func tabbedPageView(_ tabbedPageView: TabbedPageView, tabForIndex index: Int) -> Tab
    func tabbedPageView(_ tabbedPageView: TabbedPageView, positionOf tabBar: TabBar) -> TabBarPosition
    func tabbedPageView(_ tabbedPageView: TabbedPageView, backgroundColorOf tabBar: TabBar) -> UIColor
    func tabbedPageView(_ tabbedPageView: TabbedPageView, colorOfSelectionSliderIn tabBar: TabBar) -> UIColor
    func numberOfTabs(in tabbedPageView: TabbedPageView) -> Int
}

public extension TabbedPageViewDataSource {
    
    func tabbedPageView(_ tabbedPageView: TabbedPageView, backgroundColorOf tabBar: TabBar) -> UIColor {
        return UIColor.clear
    }
    
    func tabbedPageView(_ tabbedPageView: TabbedPageView, colorOfSelectionSliderIn tabBar: TabBar) -> UIColor {
        return UIColor.blue
    }
    
    func tabbedPageView(_ tabbedPageView: TabbedPageView, positionOf tabBar: TabBar) -> TabBarPosition {
        return .top
    }
}
