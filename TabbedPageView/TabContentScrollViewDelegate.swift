//
//  TabContentScrollViewDelegate.swift
//  Test
//
//  Created by Michael Onjack on 1/13/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

internal protocol TabContentScrollViewDelegate {
    func tabContentViewDidScroll(_ scrollView: UIScrollView)
    func tabContentViewDidEndDecelerating(_ scrollView: UIScrollView)
    func tabContentViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
}
