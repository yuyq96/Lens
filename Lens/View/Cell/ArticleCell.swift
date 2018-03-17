//
//  ArticleCell.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/16.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    let cardView = UIView()
    let coverImageView = UIImageView()
    let titleLabel = UILabel()
    let sourceLabel = UILabel()
    let timeLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.cardView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = Color.translucent
        self.cardView.backgroundColor = .white
        self.cardView.layer.cornerRadius = 12
        self.cardView.clipsToBounds = true
        self.contentView.addSubview(self.cardView)
        
        self.sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sourceLabel.font = .systemFont(ofSize: 13)
        self.cardView.addSubview(self.sourceLabel)
        
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeLabel.font = .systemFont(ofSize: 13)
        self.timeLabel.textColor = Color.gray
        self.cardView.addSubview(self.timeLabel)
        
        self.coverImageView.translatesAutoresizingMaskIntoConstraints = false
        self.coverImageView.contentMode = .scaleAspectFill
        self.coverImageView.clipsToBounds = true
        self.coverImageView.addConstraint(NSLayoutConstraint(item: self.coverImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160))
        self.cardView.addSubview(self.coverImageView)
        
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        let gradientLayer = gradientView.layer as! CAGradientLayer
        gradientLayer.colors = [UIColor(white: 0, alpha: 0).cgColor, UIColor(white: 0, alpha: 0.4).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        self.coverImageView.addSubview(gradientView)
        self.coverImageView.addConstraints([
            NSLayoutConstraint(item: gradientView, attribute: .leading, relatedBy: .equal, toItem: self.coverImageView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: gradientView, attribute: .trailing, relatedBy: .equal, toItem: self.coverImageView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: gradientView, attribute: .top, relatedBy: .equal, toItem: self.coverImageView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: gradientView, attribute: .bottom, relatedBy: .equal, toItem: self.coverImageView, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.numberOfLines = 2
        self.titleLabel.textColor = .white
        self.titleLabel.font = .systemFont(ofSize: 17)
        self.coverImageView.addSubview(self.titleLabel)
        self.coverImageView.addConstraints([
            NSLayoutConstraint(item: self.titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.coverImageView, attribute: .leading, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: self.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self.coverImageView, attribute: .trailing, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: self.titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self.coverImageView, attribute: .bottom, multiplier: 1, constant: -12)
            ])
        
        self.cardView.addConstraints([
            NSLayoutConstraint(item: self.sourceLabel, attribute: .leading, relatedBy: .equal, toItem: self.cardView, attribute: .leading, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: self.sourceLabel, attribute: .top, relatedBy: .equal, toItem: self.cardView, attribute: .top, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: self.timeLabel, attribute: .trailing, relatedBy: .equal, toItem: self.cardView, attribute: .trailing, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: self.timeLabel, attribute: .centerY, relatedBy: .equal, toItem: self.sourceLabel, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.coverImageView, attribute: .leading, relatedBy: .equal, toItem: self.cardView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.coverImageView, attribute: .trailing, relatedBy: .equal, toItem: self.cardView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.coverImageView, attribute: .top, relatedBy: .equal, toItem: self.sourceLabel, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: self.coverImageView, attribute: .bottom, relatedBy: .equal, toItem: self.cardView, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.cardView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: self.cardView, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: self.cardView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.cardView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
