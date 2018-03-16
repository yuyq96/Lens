//
//  BasicCell.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/16.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {
    
    func initialize() {
        let seperator = UIView()
        seperator.backgroundColor = Color.seperator
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.addConstraint(NSLayoutConstraint(item: seperator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0.5))
        self.addSubview(seperator)
        self.addConstraints([
            NSLayoutConstraint(item: seperator, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: seperator, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: seperator, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ])
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
