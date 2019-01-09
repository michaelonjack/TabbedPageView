//
//  TabType.swift
//  TabbedPageView
//
//  Created by Michael Onjack on 12/6/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit

public enum TabType {
    case icon(UIImage?)
    case text(String)
    case attributedText(NSAttributedString?)
    case iconWithText(UIImage?, NSAttributedString?)
}
