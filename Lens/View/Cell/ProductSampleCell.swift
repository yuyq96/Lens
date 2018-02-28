//
//  ProductSampleCell.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class ProductSampleCell: UITableViewCell {
    
    @IBOutlet weak var sampleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.transform = CGAffineTransform(rotationAngle: .pi/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
