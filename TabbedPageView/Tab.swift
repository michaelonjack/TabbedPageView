//
//  Tab.swift
//  TabbedPageView
//
//  Created by Michael Onjack on 11/6/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit

public struct Tab {
    var type: TabType
    var viewController: UIViewController!
    
    public init(viewController: UIViewController, type: TabType) {
        self.type = type
        self.viewController = viewController
    }
}
