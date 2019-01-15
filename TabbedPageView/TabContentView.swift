//
//  TabCollectionView.swift
//  Test
//
//  Created by Michael Onjack on 1/13/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class TabContentView: UIView {
    lazy private var tabContentCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        return flowLayout
    }()
    
    lazy internal var tabContentCollectionView: UICollectionView = {
        var cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: tabContentCollectionViewFlowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .black
        cv.isPagingEnabled = true
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        
        return cv
    }()
    
    internal var controllers: [UIViewController] = []
    internal var scrollViewDelegate: TabContentScrollViewDelegate?
    internal var previousTabContentOffset: CGFloat = 0
    
    init(controllers: [UIViewController]) {
        super.init(frame: CGRect.zero)
        
        self.controllers = controllers
        tabContentCollectionView.delegate = self
        tabContentCollectionView.dataSource = self
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tabContentCollectionView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tabContentCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            tabContentCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tabContentCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tabContentCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}



extension TabContentView: UICollectionViewDelegate {
    
}



extension TabContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tabContentCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        
        guard let controllerView = controllers[indexPath.row].view else { return cell }
        controllerView.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(controllerView)
        
        NSLayoutConstraint.activate([
            controllerView.topAnchor.constraint(equalTo: cell.topAnchor),
            controllerView.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            controllerView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            controllerView.trailingAnchor.constraint(equalTo: cell.trailingAnchor)
        ])
        
        return cell
    }
}



extension TabContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}



extension TabContentView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.tabContentViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.tabContentViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDelegate?.tabContentViewDidEndScrollingAnimation(scrollView)
    }
}