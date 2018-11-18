//
//  PageViewController.swift
//  TabbedPageView
//
//  Created by Michael Onjack on 11/3/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit

public class PageViewController: UIPageViewController {
    
    var currentIndex = 0
    var pendingIndex = 0
    
    var controllers:[UIViewController] = []
    
    init(controllers: [UIViewController]) {
        self.controllers = controllers
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self

        // This sets up the first view that will show up on our page control
        if controllers.count > 0 {
            setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
        }
    }
}



extension PageViewController: UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if pendingViewControllers.count > 0  {
            let pendingController = pendingViewControllers[0]
            if let index = self.controllers.index(of: pendingController) {
                self.pendingIndex = index
            }
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.currentIndex = self.pendingIndex
        }
    }
}




extension PageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controllerIndex = controllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = controllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard controllers.count > previousIndex else {
            return nil
        }
        
        return controllers[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controllerIndex = controllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = controllerIndex + 1
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard controllers.count != nextIndex else {
            return nil
        }
        
        guard controllers.count > nextIndex else {
            return nil
        }
        
        return controllers[nextIndex]
    }
}
