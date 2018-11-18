//
//  Tab.swift
//  TabbedPageView
//
//  Created by Michael Onjack on 11/6/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit


public struct Tab {
    var icon: UIImage?
    var viewController: UIViewController!
    
    public init(viewController: UIViewController, iconImage: UIImage) {
        self.icon = iconImage
        self.viewController = viewController
    }
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
}
