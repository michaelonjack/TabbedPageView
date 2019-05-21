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
    var source: TabSource
    
    public init(contentSource: TabSource, type: TabType) {
        self.type = type
        self.source = contentSource
    }
}
