//
//  ProductCell.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/25.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    let productImage = UIImageView()
    let nameLabel = UILabel()
    let tagButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.productImage.contentMode = .scaleAspectFit
        self.nameLabel.font = .systemFont(ofSize: 13)
        self.nameLabel.numberOfLines = 2
        self.setStyle(tag: tagButton)
        let rightView = UIView()
        self.contentView.addSubview(productImage)
        rightView.addSubview(nameLabel)
        rightView.addSubview(tagButton)
        self.contentView.addSubview(rightView)
        self.productImage.translatesAutoresizingMaskIntoConstraints = false
        rightView.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tagButton.translatesAutoresizingMaskIntoConstraints = false
        self.productImage.addConstraints([
            NSLayoutConstraint(item: self.productImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56),
            NSLayoutConstraint(item: self.productImage, attribute: .width, relatedBy: .equal, toItem: self.productImage, attribute: .height, multiplier: 1, constant: 0)
        ])
        rightView.addConstraints([
            NSLayoutConstraint(item: self.nameLabel, attribute: .leading, relatedBy: .equal, toItem: rightView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.nameLabel, attribute: .trailing, relatedBy: .equal, toItem: rightView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.nameLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: rightView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.tagButton, attribute: .leading, relatedBy: .equal, toItem: rightView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.tagButton, attribute: .top, relatedBy: .equal, toItem: self.nameLabel, attribute: .bottom, multiplier: 1, constant: 6),
            NSLayoutConstraint(item: self.tagButton, attribute: .bottom, relatedBy: .equal, toItem: rightView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.productImage, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: self.productImage, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 11),
            NSLayoutConstraint(item: self.productImage, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -11),
            NSLayoutConstraint(item: rightView, attribute: .leading, relatedBy: .equal, toItem: self.productImage, attribute: .trailing, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: rightView, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: rightView, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStyle(tag: UIButton) {
        tag.titleLabel?.font = .systemFont(ofSize: 11)
        tag.setTitleColor(.gray, for: .normal)
        tag.isEnabled = false
        tag.contentEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        tag.layer.cornerRadius = 6
        tag.layer.masksToBounds = true
        tag.layer.borderColor = Color.gray.cgColor
        tag.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
