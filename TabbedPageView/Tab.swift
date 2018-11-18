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
    
    init(viewController: UIViewController, iconImage: UIImage) {
        self.icon = iconImage
        self.viewController = viewController
    }
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}
