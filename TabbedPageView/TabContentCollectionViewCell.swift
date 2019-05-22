//
//  TabContentCollectionViewCell.swift
//  Test
//
//  Created by Michael Onjack on 5/19/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class TabContentCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TabContentCollectionViewCell"
    
    var hostedView: UIView? {
        didSet {
            guard let hostedView = hostedView else { return }
            
            hostedView.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(hostedView)
            
            NSLayoutConstraint.activate([
                hostedView.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                hostedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if hostedView?.superview == contentView {
            hostedView?.removeFromSuperview()
        }
        
        hostedView = nil
    }
}
