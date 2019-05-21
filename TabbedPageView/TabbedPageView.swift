//
//  TabbedPageView.swift
//  TabbedPageView
//
//  Created by Michael Onjack on 11/3/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit

open class TabbedPageView: UIView {
    open weak var delegate: TabbedPageViewDelegate?
    open weak var dataSource: TabbedPageViewDataSource?
    
    // The container view that contains the tab content (views)
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // View that contains the collection view that displays the different pages
    private lazy var tabContentView: TabContentView = {
        let tcv = TabContentView(views: [])
        tcv.translatesAutoresizingMaskIntoConstraints = false
        
        return tcv
    }()
    
    // View that holds the tabs and selection slider
    public lazy var tabBar: TabBar = {
        let tb = TabBar(frame: CGRect.zero)
        tb.translatesAutoresizingMaskIntoConstraints = false
        
        return tb
    }()
    
    // Determines if the user can manually swipe through the tab views or if they're required to press the tab headers in order to change tabs
    public var isManualScrollingEnabled: Bool = true
    
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
        containerView.addSubview(tabContentView)
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
                tabBar.heightAnchor.constraint(equalToConstant: tabBar.height!)),
            
            // Container view constraint
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            // Tab content view constraints
            tabContentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tabContentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            tabContentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tabContentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
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
    
    private func initializeTabContents() {
        let parentViewController = getViewController(for: self)
        
        var views:[UIView] = []
        for index in 0..<dataSource!.numberOfTabs(in: self) {
            let tab = dataSource!.tabbedPageView(self, tabForIndex: index)
            
            switch tab.source {
            case .view(let view):
                views.append(view)
            case .viewController(let viewController):
                parentViewController?.addChild(viewController)
                viewController.didMove(toParent: parentViewController)
                
                views.append(viewController.view)
            }
        }
        
        tabContentView.views = views
        tabContentView.scrollViewDelegate = self
        tabContentView.tabContentCollectionView.isScrollEnabled = isManualScrollingEnabled
        tabContentView.tabContentCollectionView.reloadData()
    }
    
    public func reloadData() {
        guard let _ = dataSource else { return }
        
        // Once the tabs are set, create the tab bar
        initializeTabBar()
        
        // Once the views are set, initialize the tab contents
        initializeTabContents()
        
        // Add constraints
        setupLayout()
    }
    
    private func getViewController(for view: UIView) -> UIViewController? {
        if let nextResponder = view.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = view.next as? UIView {
            return getViewController(for: nextResponder)
        } else {
            return nil
        }
    }
}




extension TabbedPageView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tabContentView.tabContentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
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
            
        case .iconWithText(let iconImage, let attributedTitle):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconLabelCell", for: indexPath) as! TabIconLabelCollectionViewCell
            cell.imageView.image = iconImage
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



extension TabbedPageView: TabContentScrollViewDelegate {
    func tabContentViewDidScroll(_ scrollView: UIScrollView) {
        
        DispatchQueue.main.async {
            let positionDifference = scrollView.contentOffset.x - self.tabContentView.previousTabContentOffset
            let positionDifferenceScaled = (positionDifference / scrollView.contentSize.width) * self.tabBar.tabCollectionView.contentSize.width
            self.tabContentView.previousTabContentOffset = scrollView.contentOffset.x
            
            switch self.tabBar.transitionStyle {
            case .normal:
                self.tabBar.selectionSliderLeadingConstraint!.constant += positionDifferenceScaled
                
            case .sticky:
                
                // Scrolling to the right
                if positionDifference > 0 {
                    self.tabBar.selectionSliderWidthConstraint!.constant += positionDifferenceScaled
                }
                    
                    // Scrolling to the left
                else {
                    self.tabBar.selectionSliderLeadingConstraint!.constant += positionDifferenceScaled
                    self.tabBar.selectionSliderWidthConstraint!.constant -= positionDifferenceScaled
                }
            }
        }
    }
    
    func tabContentViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let progress = tabBar.tabCollectionView.contentSize.width * (scrollView.contentOffset.x / scrollView.contentSize.width) - tabBar.tabCollectionView.contentOffset.x
        let currentTabIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        let tabWidth = self.tabBar.tabWidth ?? 0
        
        DispatchQueue.main.async {
            switch self.tabBar.transitionStyle {
            case .normal:
                self.tabBar.tabCollectionView.scrollToItem(at: IndexPath(row: currentTabIndex, section: 0), at: .centeredHorizontally, animated: true)
            case .sticky:
                UIView.animate(withDuration: 0.2, animations: {
                    self.tabBar.selectionSliderWidthConstraint!.constant = tabWidth
                    self.tabBar.selectionSliderLeadingConstraint!.constant = progress
                    self.layoutIfNeeded()
                }, completion: { (completed) in
                    self.tabBar.tabCollectionView.scrollToItem(at: IndexPath(row: currentTabIndex, section: 0), at: .centeredHorizontally, animated: true)
                })
            }
        }
    }
    
    func tabContentViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let progress = tabBar.tabCollectionView.contentSize.width * (scrollView.contentOffset.x / scrollView.contentSize.width) - tabBar.tabCollectionView.contentOffset.x
        let currentTabIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        let tabWidth = self.tabBar.tabWidth ?? 0
        
        DispatchQueue.main.async {
            switch self.tabBar.transitionStyle {
            case .normal:
                self.tabBar.tabCollectionView.scrollToItem(at: IndexPath(row: currentTabIndex, section: 0), at: .centeredHorizontally, animated: true)
            case .sticky:
                UIView.animate(withDuration: 0.2, animations: {
                    self.tabBar.selectionSliderWidthConstraint!.constant = tabWidth
                    self.tabBar.selectionSliderLeadingConstraint!.constant = progress
                    self.layoutIfNeeded()
                }, completion: { (completed) in
                    self.tabBar.tabCollectionView.scrollToItem(at: IndexPath(row: currentTabIndex, section: 0), at: .centeredHorizontally, animated: true)
                })
            }
        }
    }
}


extension TabbedPageView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /// The user is scrolling through the tabs
        let positionDifference = scrollView.contentOffset.x - tabBar.tabCollectionViewPreviousContentOffset
        tabBar.tabCollectionViewPreviousContentOffset = scrollView.contentOffset.x
        
        DispatchQueue.main.async {
            // We multiply by -1 because we need the slider to move in the opposite direction of the scroll
            // i.e. If user reveals more of left side of collection view, slider should move right
            self.tabBar.selectionSliderLeadingConstraint!.constant += positionDifference * -1
        }
    }
}


