//
//  NavigationBarView.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/16.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class NavigationBarView: UIView {
    
    init(_ contentView: UIView) {
        super.init(frame: .zero)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        self.addConstraints([
            NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return UILayoutFittingExpandedSize
        }
    }

}
