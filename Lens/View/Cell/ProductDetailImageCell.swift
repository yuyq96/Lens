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
    var dxomark: DxOMARK!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        self.productImage.contentMode = .scaleAspectFit
        self.dxomark = Bundle.main.loadNibNamed("DxOMARK", owner: nil, options: nil)?.first as! DxOMARK
        self.dxomark.isHidden = true
        self.dxomark.alpha = 0.8
        self.contentView.addSubview(self.productImage)
        self.contentView.addSubview(self.dxomark)
        self.productImage.translatesAutoresizingMaskIntoConstraints = false
        self.dxomark.translatesAutoresizingMaskIntoConstraints = false
        self.productImage.addConstraints([
            NSLayoutConstraint(item: self.productImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 156)
        ])
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.productImage, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.productImage, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.productImage, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: self.productImage, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: self.dxomark, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: self.dxomark, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 11),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showScore(equipmentCategory: Context.EquipmentCategory, score: Int) {
        if score == 0 {
            self.dxomark.isHidden = true
            return
        }
        switch equipmentCategory {
        case .lenses:
            self.dxomark.lensLabel.isHidden = false
        case .cameras:
            self.dxomark.sensorLabel.isHidden = false
        default:
            return
        }
        self.dxomark.scoreLabel.text = "\(score)"
        self.dxomark.isHidden = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
