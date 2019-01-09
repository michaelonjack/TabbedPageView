//
//  TabCollectionViewCell.swift
//  TabbedPageView
//
//  Created by Michael Onjack on 11/3/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit

class TabIconCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        var iv = UIImageView(frame: .zero)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        setupLayout()
    }
    
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
}
