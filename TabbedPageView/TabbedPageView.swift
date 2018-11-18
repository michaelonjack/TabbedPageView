//
//  TabbedPageView.swift
//  TabbedPageView
//
//  Created by Michael Onjack on 11/3/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit

public class TabbedPageView: UIView {
    
    open var delegate: TabbedPageViewDelegate?
    open var dataSource: TabbedPageViewDataSource?
    
    open var pageViewController:PageViewController?
    
    private var tabs: [Tab] = []
    
    private var numberOfTabs = 1
    
    private var tabBarPosition: TabBarPosition = .top
    
    private var sliderColor: UIColor = .blue
    
    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }()
    
    // The collection view that contains the tabs
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clear
        cv.setCollectionViewLayout(self.collectionViewFlowLayout, animated: true)
        cv.dataSource = self
        cv.delegate = self
        cv.register(TabCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        return cv
    }()
    
    // The container view that contains the page view controller
    lazy var containerView: UIView = {
       let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.purple
        
        return view
    }()
    
    // The slider bar used to indicate which tab is currently showing
    private var selectionSliderLeadingConstraint: NSLayoutConstraint?
    lazy var selectionSlider: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        
        return view
    }()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        addSubview(containerView)
        addSubview(selectionSlider)
    }
    
    private func setupLayout() {
        
        switch tabBarPosition {
        case .top:
            NSLayoutConstraint.activate([
                // Collection view constraints
                collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                
                // Container view constraint
                containerView.topAnchor.constraint(equalTo: selectionSlider.bottomAnchor, constant: 0),
                containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                
                // Selection indicator constraints
                selectionSlider.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0),
            ])
            
        case .bottom:
            NSLayoutConstraint.activate([
                // Collection view constraints
                collectionView.bottomAnchor.constraint(equalTo: selectionSlider.topAnchor, constant: 0),
                
                // Container view constraint
                containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                containerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0),
                
                // Selection indicator constraints
                selectionSlider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            ])
        }
        
        selectionSliderLeadingConstraint = selectionSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            // Collection view constraints
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.064),
            
            // Container view constraint
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            // Selection indicator constraints
            selectionSliderLeadingConstraint!,
            selectionSlider.widthAnchor.constraint(equalTo: self.collectionView.widthAnchor, multiplier: CGFloat(1)/CGFloat(numberOfTabs)),
            selectionSlider.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.007)
        ])
    }
    
    private func initializePageViewController() {
        
        var pageControllers:[UIViewController] = []
        for tab in tabs {
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
        guard let dataSource = dataSource else { return }
        
        // Initialize member variables
        tabs = dataSource.tabs()
        numberOfTabs = dataSource.tabs().count
        sliderColor = dataSource.sliderColor()
        tabBarPosition = dataSource.tabBarPosition()
        
        // Add constraints
        setupLayout()
        
        // Once the page controllers are set, create the page view controller
        initializePageViewController()
        
        // Once the slider color is set, update the slider color
        selectionSlider.backgroundColor = sliderColor
        
        // Once the tabImages are set, reload the collection view
        collectionView.reloadData()
    }
}




extension TabbedPageView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pageViewController = pageViewController else { return }
        if indexPath.row > tabs.count { return }
        
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
                }
                
                nextIndex = nextIndex - 1
            }
        }
    }
}




extension TabbedPageView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfTabs
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TabCollectionViewCell
        
        if indexPath.row < tabs.count {
            cell.imageView.image = tabs[indexPath.row].icon
        }
        
        return cell
    }
}




extension TabbedPageView : UICollectionViewDelegateFlowLayout {
    // responsible for telling the layout the size of a given cell
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Subtract 1 from the height and width so it doesn't complain about the cell being the same size as the container
        return CGSize(width: collectionView.bounds.size.width/CGFloat(numberOfTabs) - 1, height: collectionView.bounds.size.height - 1)
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
        guard let pageViewController = pageViewController else { return }
        // Page has already completed transition so stop
        if pageViewController.pendingIndex == pageViewController.currentIndex { return }
        
        let scrollViewWidth = scrollView.frame.width
        let tabWidth = scrollViewWidth / CGFloat(self.numberOfTabs)
        let scrollViewContentOffset = scrollView.contentOffset.x
        let percentScrolled = (scrollViewContentOffset - scrollViewWidth) / scrollViewWidth
        let initialSpacing = CGFloat(pageViewController.currentIndex) * (scrollViewWidth / CGFloat(self.numberOfTabs))
        
        // Scrolling to the right
        if percentScrolled > 0 && pageViewController.currentIndex < self.numberOfTabs-1 {
            DispatchQueue.main.async {
                self.selectionSliderLeadingConstraint!.constant = initialSpacing + (tabWidth * percentScrolled)
            }
        }
            
        // Scrolling to the left
        else if percentScrolled < 0 && pageViewController.currentIndex > 0 {
            DispatchQueue.main.async {
                self.selectionSliderLeadingConstraint!.constant = initialSpacing - (tabWidth * percentScrolled * -1)
            }
        }
    }
}
