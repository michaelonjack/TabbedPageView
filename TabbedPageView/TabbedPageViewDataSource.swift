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
    func numberOfTabs(in tabbedPageView: TabbedPageView) -> Int
}

public extension TabbedPageViewDataSource {
    
}
