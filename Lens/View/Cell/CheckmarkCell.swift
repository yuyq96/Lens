//
//  CheckmarkCell.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/5.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class CheckmarkCell: BasicCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        self.tintColor = Color.tint
        self.textLabel?.textColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func check() -> Bool {
        if self.accessoryType == .none {
            self.accessoryType = .checkmark
            self.textLabel?.textColor = .black
            return true
        } else {
            self.accessoryType = .none
            self.textLabel?.textColor = .gray
            return false
        }
    }
    
    func setCheck(_ check: Bool) {
        if check {
            self.accessoryType = .checkmark
            self.textLabel?.textColor = .black
        } else {
            self.accessoryType = .none
            self.textLabel?.textColor = .gray
        }
    }

}
