//
//  TabbedPageViewDelegate.swift
//  TabbedPageView
//
//  Created by Michael Onjack on 11/4/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit

public protocol TabbedPageViewDelegate: AnyObject {
    func tabbedPageView(_ tabbedPageView: TabbedPageView, didSelectTabAt index: Int)
}

public extension TabbedPageViewDelegate {
    func tabbedPageView(_ tabbedPageView: TabbedPageView, didSelectTabAt index: Int) {
        return
    }
}
