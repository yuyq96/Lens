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
    private let imageWrapper = UIView()
    let nameLabel = UILabel()
    let tagButton = UIButton()
    var dxomark = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.imageWrapper.backgroundColor = Color.lightGray
        self.imageWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.imageWrapper)
        
        self.productImage.contentMode = .scaleAspectFit
        self.productImage.translatesAutoresizingMaskIntoConstraints = false
        self.imageWrapper.addSubview(self.productImage)
        
        self.dxomark.isHidden = true
        self.dxomark.backgroundColor = Color.dxo
        self.dxomark.textColor = .white
        self.dxomark.alpha = 0.8
        self.dxomark.font = .systemFont(ofSize: 11)
        self.dxomark.translatesAutoresizingMaskIntoConstraints = false
        self.imageWrapper.addSubview(self.dxomark)
        
        self.imageWrapper.addConstraints([
            NSLayoutConstraint(item: self.imageWrapper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60),
            NSLayoutConstraint(item: self.imageWrapper, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64),
            NSLayoutConstraint(item: self.productImage, attribute: .leading, relatedBy: .equal, toItem: self.imageWrapper, attribute: .leading, multiplier: 1, constant: 6),
            NSLayoutConstraint(item: self.productImage, attribute: .trailing, relatedBy: .equal, toItem: self.imageWrapper, attribute: .trailing, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: self.productImage, attribute: .top, relatedBy: .equal, toItem: self.imageWrapper, attribute: .top, multiplier: 1, constant: 4),
            NSLayoutConstraint(item: self.productImage, attribute: .bottom, relatedBy: .equal, toItem: self.imageWrapper, attribute: .bottom, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: self.dxomark, attribute: .bottom, relatedBy: .equal, toItem: self.imageWrapper, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.dxomark, attribute: .trailing, relatedBy: .equal, toItem: self.imageWrapper, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        
        let rightView = UIView()
        rightView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(rightView)
        
        self.nameLabel.font = .systemFont(ofSize: 13)
        self.nameLabel.numberOfLines = 2
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        rightView.addSubview(nameLabel)
        
        self.setStyle(tag: tagButton)
        self.tagButton.translatesAutoresizingMaskIntoConstraints = false
        rightView.addSubview(tagButton)
        
        rightView.addConstraints([
            NSLayoutConstraint(item: self.nameLabel, attribute: .leading, relatedBy: .equal, toItem: rightView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.nameLabel, attribute: .trailing, relatedBy: .equal, toItem: rightView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.nameLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: rightView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.tagButton, attribute: .leading, relatedBy: .equal, toItem: rightView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.tagButton, attribute: .top, relatedBy: .equal, toItem: self.nameLabel, attribute: .bottom, multiplier: 1, constant: 6),
            NSLayoutConstraint(item: self.tagButton, attribute: .bottom, relatedBy: .equal, toItem: rightView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        // 避免警告
        let bottomConstraint = NSLayoutConstraint(item: self.imageWrapper, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 10)
        bottomConstraint.priority = .defaultHigh
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.imageWrapper, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 10),
            bottomConstraint,
            NSLayoutConstraint(item: self.imageWrapper, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: rightView, attribute: .leading, relatedBy: .equal, toItem: self.imageWrapper, attribute: .trailing, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: rightView, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: rightView, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle(tag: UIButton) {
        tag.titleLabel?.font = .systemFont(ofSize: 11)
        tag.setTitleColor(.gray, for: .normal)
        tag.isEnabled = false
        tag.contentEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        tag.layer.cornerRadius = 6
        tag.layer.masksToBounds = true
        tag.layer.borderColor = Color.gray.cgColor
        tag.layer.borderWidth = 1
    }
    
    func showScore(score: Int) {
        if score == 0 {
            self.dxomark.isHidden = true
            return
        }
        self.dxomark.text = "  \(score)  "
        self.dxomark.isHidden = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
