//
//  TabIconLabelCollectionViewCell.swift
//  Test
//
//  Created by Michael Onjack on 1/8/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class TabIconLabelCollectionViewCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        var l = UILabel(frame: CGRect.zero)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = .clear
        l.textAlignment = .center
        l.baselineAdjustment = .alignCenters
        l.textColor = .black
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFont(ofSize: 12.0)
        
        return l
    }()
    
    lazy var imageView: UIImageView = {
        var iv = UIImageView(frame: CGRect.zero)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        
        return iv
    }()
    
    lazy var containerView: UIView = {
        var v = UIView(frame: CGRect.zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
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
        
        containerView.addSubview(label)
        containerView.addSubview(imageView)
        addSubview(containerView)
        
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.55),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5.0),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            label.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
    }
}
