//
//  ProductDetailImageCell.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class ProductDetailImageCell: UITableViewCell {

    let productImage = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.productImage.contentMode = .scaleAspectFit
        self.addSubview(productImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        // 旋转屏幕时调整宽度
        self.productImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180)
        super.layoutSubviews()
    }

}
