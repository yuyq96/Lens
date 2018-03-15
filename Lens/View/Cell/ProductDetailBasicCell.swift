//
//  ProductDetailBasicCell.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class ProductDetailBasicCell: UITableViewCell {
    
    var nameLabel = UILabel()
    var attribLabel = UILabel()
    var showMoreButton = UIButton(type: UIButtonType.system)
    var notifyTableView: (() -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        self.nameLabel.numberOfLines = 2
        self.nameLabel.font = .boldSystemFont(ofSize: 16)
        self.attribLabel.numberOfLines = 6
        self.showMoreButton.backgroundColor = Color.tint
        self.showMoreButton.setTitle(NSLocalizedString("Show More", comment: "Show More"), for: .normal)
        self.showMoreButton.titleLabel?.font = .systemFont(ofSize: 11)
        self.showMoreButton.setTitleColor(.white, for: .normal)
        self.showMoreButton.layer.cornerRadius = 15
        self.showMoreButton.layer.masksToBounds = true
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.attribLabel)
        self.contentView.addSubview(self.showMoreButton)
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.attribLabel.translatesAutoresizingMaskIntoConstraints = false
        self.showMoreButton.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 21))
        self.showMoreButton.addConstraints([
            NSLayoutConstraint(item: self.showMoreButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: self.showMoreButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80),
        ])
        let bottomConstraint = NSLayoutConstraint(item: self.attribLabel, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -11)
        bottomConstraint.priority = .defaultLow
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.nameLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 11),
            NSLayoutConstraint(item: self.nameLabel, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: self.nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: self.attribLabel, attribute: .top, relatedBy: .equal, toItem: self.nameLabel, attribute: .bottom, multiplier: 1, constant: 6),
            bottomConstraint,
            NSLayoutConstraint(item: self.attribLabel, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: self.attribLabel, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: self.showMoreButton, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: self.showMoreButton, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -11)
            ])
        self.showMoreButton.addTarget(self, action: #selector(showMore), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showMore(_ sender: UIButton) {
        if self.attribLabel.numberOfLines == 6 {
            self.attribLabel.numberOfLines = 30
            sender.setTitle(NSLocalizedString("Hide", comment: "Hide"), for: .normal)
        } else {
            self.attribLabel.numberOfLines = 6
            sender.setTitle(NSLocalizedString("Show More", comment: "Show More"), for: .normal)
        }
        self.notifyTableView?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
