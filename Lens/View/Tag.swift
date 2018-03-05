//
//  Tag.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/5.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class Tag: UIButton {
    
    init(string: String) {
        super.init(frame: CGRect.zero)
        self.isEnabled = false
        self.contentEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        self.layer.borderColor = Color.gray.cgColor
        self.layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
