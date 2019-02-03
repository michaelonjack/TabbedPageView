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
    var view: UIView!
    
    public init(view: UIView, type: TabType) {
        self.type = type
        self.view = view
    }
    
    public init(viewController: UIViewController, type: TabType) {
        self.type = type
        self.view = viewController.view
    }
}
