//
//  TabBar.swift
//  Test
//
//  Created by Michael Onjack on 11/27/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit

public class TabBar: UIView {
    
    lazy private var tabCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }()
    
    // The collection view that contains the tabs
    lazy internal var tabCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.tabCollectionViewFlowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.setCollectionViewLayout(self.tabCollectionViewFlowLayout, animated: true)
        cv.register(TabCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        return cv
    }()
    
    internal var selectionSliderLeadingConstraint: NSLayoutConstraint?
    /// The slider bar used to indicate which tab is currently showing
    lazy internal var selectionSlider: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    internal var tabs: [Tab] = []
    internal var position: TabBarPosition = .top
    internal var tabWidth: CGFloat = 0
    internal var sliderColor:UIColor = UIColor.blue
    internal var sliderInitialOffset:CGFloat = 0
    internal var tabCollectionViewPreviousContentOffset: CGFloat = 0
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public init(tabs: [Tab], position: TabBarPosition) {
        super.init(frame: CGRect.zero)
        
        self.tabs = tabs
        self.position = position
        
        setupView()
    }
    
    
    
    open func reload() {
        setupLayout()
        tabCollectionView.reloadData()
    }
    
    
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tabCollectionView)
        addSubview(selectionSlider)
        
        setupLayout()
    }
    
    
    
    private func setupLayout() {
        guard tabs.count != 0 else { return }
        
        switch position {
        case .top:
            NSLayoutConstraint.activate([
                // Collection view constraints
                tabCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                
                // Selection indicator constraints
                selectionSlider.topAnchor.constraint(equalTo: tabCollectionView.bottomAnchor, constant: 0),
                ])
            
        case .bottom:
            NSLayoutConstraint.activate([
                // Collection view constraints
                tabCollectionView.bottomAnchor.constraint(equalTo: selectionSlider.topAnchor, constant: 0),
                
                // Selection indicator constraints
                selectionSlider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                ])
        }
        
        selectionSliderLeadingConstraint = selectionSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            // Collection view constraints
            tabCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            tabCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            tabCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.92),
            
            // Selection indicator constraints
            selectionSliderLeadingConstraint!,
            selectionSlider.widthAnchor.constraint(equalToConstant: tabWidth),
            selectionSlider.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.08)
            ])
    }
}
