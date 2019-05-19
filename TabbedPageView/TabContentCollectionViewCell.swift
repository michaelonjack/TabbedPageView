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
            
            hostedView.frame = contentView.bounds
            contentView.addSubview(hostedView)
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
