//
//  Shadow.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/3.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class Shadow {

    @discardableResult static func add(to superView: UIView) -> NSLayoutConstraint {
        let shadow = UIView()
        shadow.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        superView.addSubview(shadow)
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.addConstraint(NSLayoutConstraint(item: shadow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0.5))
        let shadowConstraint = NSLayoutConstraint(item: shadow, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: 0)
        superView.addConstraints([
            NSLayoutConstraint(item: shadow, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: shadow, attribute: .width, relatedBy: .equal, toItem: superView, attribute: .width, multiplier: 1, constant: 0),
            shadowConstraint
            ])
        return shadowConstraint
    }

}
