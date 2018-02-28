//
//  Cell.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/28.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
