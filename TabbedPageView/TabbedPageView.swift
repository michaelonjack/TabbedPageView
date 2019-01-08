//
//  TabbedPageView.swift
//  TabbedPageView
//
//  Created by Michael Onjack on 11/3/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit

open class TabbedPageView: UIView {
    
    open var delegate: TabbedPageViewDelegate?
    open var dataSource: TabbedPageViewDataSource?
    
    open var pageViewController:PageViewController?
    
    // The container view that contains the page view controller
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var tabBar: TabBar = {
        let tb = TabBar(frame: CGRect.zero)
        tb.translatesAutoresizingMaskIntoConstraints = false
        
        return tb
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    /// Adds the necessary subviews to the `TabbedPageView`
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        
        addSubview(containerView)
        addSubview(tabBar)
    }
    
    /// Adds the necessary constraints to the subviews of the `TabbedPageView`
    ///
    /// Called when the `TabbedPageView`'s is reloaded after the delegate and datasource are set
    private func setupLayout() {
        
        switch tabBar.position {
        case .top:
            NSLayoutConstraint.activate([
                // Collection view constraints
                tabBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                
                // Container view constraint
                containerView.topAnchor.constraint(equalTo: tabBar.bottomAnchor, constant: 0),
                containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            ])
            
        case .bottom:
            NSLayoutConstraint.activate([
                // Collection view constraints
                tabBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                
                // Container view constraint
                containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                containerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0),
            ])
        }
        
        NSLayoutConstraint.activate([
            // Tab bar constraints
            tabBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            tabBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            (tabBar.height == nil ?
                tabBar.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.07) :
                tabBar.heightAnchor.constraint(equalToConstant: tabBar.height!)
            ),
            
            // Container view constraint
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        ])
    }
    
    private func initializeTabBar() {
        var tabs:[Tab] = []
        for index in 0..<dataSource!.numberOfTabs(in: self) {
            let tab = dataSource!.tabbedPageView(self, tabForIndex: index)
            tabs.append(tab)
        }
        
        DispatchQueue.main.async {
            self.tabBar.tabs = tabs
            if self.tabBar.tabWidth == nil {
                self.tabBar.tabWidth = self.bounds.size.width / CGFloat(tabs.count)
            }
            self.tabBar.tabCollectionView.delegate = self
            self.tabBar.tabCollectionView.dataSource = self
            self.tabBar.selectionSlider.backgroundColor = self.tabBar.sliderColor
            self.tabBar.reload()
        }
    }
    
    private func initializePageViewController() {
        
        var pageControllers:[UIViewController] = []
        for index in 0..<dataSource!.numberOfTabs(in: self) {
            let tab = dataSource!.tabbedPageView(self, tabForIndex: index)
            pageControllers.append(tab.viewController)
        }
        
        // Initialize the page view controller
        pageViewController = PageViewController(controllers: pageControllers)
        pageViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(pageViewController!.view)
        
        NSLayoutConstraint.activate([
            pageViewController!.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            pageViewController!.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            pageViewController!.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            pageViewController!.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
            ])
        
        // Find the page controller scroll view to set the delegate
        for view in pageViewController!.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
                break
            }
        }
    }
    
    public func reloadData() {
        guard let _ = dataSource else { return }
        
        // Once the tabs are set, create the tab bar
        initializeTabBar()
        
        // Once the page controllers are set, create the page view controller
        initializePageViewController()
        
        // Add constraints
        setupLayout()
    }
}




extension TabbedPageView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pageViewController = pageViewController else { return }
        
        // The direction of the scroll animation
        var scrollDirection = UIPageViewController.NavigationDirection.forward
        
        // If the selected index is ahead of the current page, set the scroll direction to be forward
        if pageViewController.currentIndex < indexPath.row {
            scrollDirection = UIPageViewController.NavigationDirection.forward
            var nextIndex = pageViewController.currentIndex + 1
            
            while nextIndex <= indexPath.row {
                pageViewController.pendingIndex = nextIndex
                
                // The controller within the page view we need to scroll to
                let controllerToShow = pageViewController.controllers[nextIndex]
                
                // Scroll to the selected page index
                let newIndex = nextIndex
                pageViewController.setViewControllers([controllerToShow], direction: scrollDirection, animated: true) { (completed) in
                    pageViewController.currentIndex = newIndex
                    
                    if completed {
                        DispatchQueue.main.async {
                            pageViewController.pagesScrolledForCurrentTransition += 1
                            
                            // If we've reached the destination page, reset the pages scrolled count for the next transition
                            if indexPath.row == newIndex {
                                pageViewController.pagesScrolledForCurrentTransition = 0
                            }
                        }
                    }
                }
                
                nextIndex = nextIndex + 1
            }
        }
            
            // If the selected index is before the current page, set the scroll direction to be reverse
        else if pageViewController.currentIndex > indexPath.row {
            scrollDirection = UIPageViewController.NavigationDirection.reverse
            var nextIndex = pageViewController.currentIndex - 1
            
            while nextIndex >= indexPath.row {
                pageViewController.pendingIndex = nextIndex
                
                // The controller within the page view we need to scroll to
                let controllerToShow = pageViewController.controllers[nextIndex]
                
                // Scroll to the selected page index
                let newIndex = nextIndex
                pageViewController.setViewControllers([controllerToShow], direction: scrollDirection, animated: true) { (completed) in
                    pageViewController.currentIndex = newIndex
                    
                    if completed {
                        DispatchQueue.main.async {
                            pageViewController.pagesScrolledForCurrentTransition += 1
                            
                            // If we've reached the destination page, reset the pages scrolled count for the next transition
                            if indexPath.row == newIndex {
                                pageViewController.pagesScrolledForCurrentTransition = 0
                            }
                        }
                    }
                }
                
                nextIndex = nextIndex - 1
            }
        }
        
        delegate?.tabbedPageView(self, didSelectTabAt: indexPath.row)
    }
}




extension TabbedPageView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfTabs(in: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tab = dataSource?.tabbedPageView(self, tabForIndex: indexPath.row) else { return UICollectionViewCell(frame: .zero) }
        
        switch tab.type {
        case .icon(let iconImage):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as! TabIconCollectionViewCell
            cell.imageView.image = iconImage
            
            return cell
            
        case .text(let title):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as! TabLabelCollectionViewCell
            cell.label.text = title
            
            return cell
            
        case .attributedText(let attributedTitle):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as! TabLabelCollectionViewCell
            cell.label.attributedText = attributedTitle
            
            return cell
        }
    }
}




extension TabbedPageView : UICollectionViewDelegateFlowLayout {
    // responsible for telling the layout the size of a given cell
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.tabBar.tabWidth ?? 0, height: collectionView.bounds.size.height)
    }
    
    //  returns the spacing between the cells, headers, and footers. A constant is used to store the value
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0;
    }
}




extension TabbedPageView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /// The user is scrolling through the tabs
        if scrollView == tabBar.tabCollectionView {
            let positionDifference = scrollView.contentOffset.x - tabBar.tabCollectionViewPreviousContentOffset
            tabBar.tabCollectionViewPreviousContentOffset = scrollView.contentOffset.x
            
            DispatchQueue.main.async {
                // We multiply by -1 because we need the slider to move in the opposite direction of the scroll
                // i.e. If user reveals more of left side of collection view, slider should move right
                self.tabBar.selectionSliderLeadingConstraint!.constant += positionDifference * -1
            }
        }
            
            
        /// The user is scrolling through the pages
        else {
            guard let pageViewController = pageViewController else { return }
            
            // Page has already completed transition so stop
            if pageViewController.pendingIndex == pageViewController.currentIndex { return }
            
            let numberOfTabs = dataSource?.numberOfTabs(in: self) ?? 1
            let scrollViewWidth = scrollView.frame.width
            let tabWidth = self.tabBar.tabWidth ?? 0
            let scrollViewContentOffset = scrollView.contentOffset.x
            let percentScrolled = (scrollViewContentOffset - scrollViewWidth) / scrollViewWidth
            
            let initialSpacing = CGFloat(pageViewController.currentIndex) * tabWidth - tabBar.tabCollectionView.contentOffset.x
            
            // Scrolling to the right
            if percentScrolled > 0 && pageViewController.currentIndex < numberOfTabs-1 {
                DispatchQueue.main.async {
                    switch self.tabBar.transitionStyle {
                    case .normal:
                        self.tabBar.selectionSliderLeadingConstraint!.constant = initialSpacing + (tabWidth * percentScrolled)
                    case .sticky:
                        self.tabBar.selectionSliderWidthConstraint!.constant = tabWidth + (tabWidth * (percentScrolled + CGFloat(pageViewController.pagesScrolledForCurrentTransition)))
                    }
                }
            }
                
            // Scrolling to the left
            else if percentScrolled < 0 && pageViewController.currentIndex > 0 {
                DispatchQueue.main.async {
                    switch self.tabBar.transitionStyle {
                    case .normal:
                        self.tabBar.selectionSliderLeadingConstraint!.constant = initialSpacing - (tabWidth * percentScrolled * -1)
                    case .sticky:
                        self.tabBar.selectionSliderLeadingConstraint!.constant = initialSpacing - (tabWidth * percentScrolled * -1)
                        self.tabBar.selectionSliderWidthConstraint!.constant = tabWidth + (tabWidth * (percentScrolled - CGFloat(pageViewController.pagesScrolledForCurrentTransition)) * -1)
                    }
                }
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let currentPageIndex = pageViewController?.currentIndex else { return }
        guard let pendingPageIndex = pageViewController?.pendingIndex else { return }
        
        // If the user successfully scrolled to the next page, scroll to the correct index in the tab collection view
        if currentPageIndex == pendingPageIndex && scrollView != self.tabBar.tabCollectionView {
            let tabWidth = self.tabBar.tabWidth ?? 0
            
            DispatchQueue.main.async {
                
                switch self.tabBar.transitionStyle {
                case .normal:
                    self.tabBar.tabCollectionView.scrollToItem(at: IndexPath(row: currentPageIndex, section: 0), at: .centeredHorizontally, animated: true)
                case .sticky:
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tabBar.selectionSliderWidthConstraint?.constant = tabWidth
                        self.tabBar.selectionSliderLeadingConstraint?.constant = tabWidth * CGFloat(currentPageIndex) - self.tabBar.tabCollectionView.contentOffset.x
                        self.layoutIfNeeded()
                    }) { (_) in
                        self.tabBar.tabCollectionView.scrollToItem(at: IndexPath(row: currentPageIndex, section: 0), at: .centeredHorizontally, animated: true)
                    }
                }
            }
        }
    }
    
    // Used when scrolling programatically (user select tab from tab bar)
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let pendingPageIndex = pageViewController?.pendingIndex else { return }
        guard let currentPageIndex = pageViewController?.currentIndex else { return }
        // The function is called each time we traverse across a new page so if we select a tab two indexes away
        //      then this will be called twice. But we only want it called once the final page is reached
        if abs(currentPageIndex - pendingPageIndex) > 1 { return }
        
        
        if scrollView != self.tabBar.tabCollectionView {
            let tabWidth = self.tabBar.tabWidth ?? 0
            
            DispatchQueue.main.async {
                
                switch self.tabBar.transitionStyle {
                case .sticky:
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tabBar.selectionSliderWidthConstraint?.constant = tabWidth
                        self.tabBar.selectionSliderLeadingConstraint?.constant = tabWidth * CGFloat(pendingPageIndex) - self.tabBar.tabCollectionView.contentOffset.x
                        self.layoutIfNeeded()
                    }) { (_) in
                        self.tabBar.tabCollectionView.scrollToItem(at: IndexPath(row: pendingPageIndex, section: 0), at: .centeredHorizontally, animated: true)
                    }
                default:
                    self.tabBar.tabCollectionView.scrollToItem(at: IndexPath(row: pendingPageIndex, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
}
