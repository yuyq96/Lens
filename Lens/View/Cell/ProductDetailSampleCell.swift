//
//  ProductDetailSampleCell.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit
import Kingfisher

class ProductDetailSampleCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    var sampleLabel = UILabel()
    var sampleTableView = UITableView(frame: .zero, style: .grouped)
    
    var samples: [String] = []
    var sampleWidths: [Int : CGFloat] = [:]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        
        // 设置标题
        self.sampleLabel.text = NSLocalizedString("Sample", comment: "Sample")
        self.sampleLabel.font = .systemFont(ofSize: 17)
        
        // 设置样片列表
        self.sampleTableView.contentMode = .scaleToFill
        self.sampleTableView.backgroundColor = UIColor(white: 1, alpha: 0)
        self.sampleTableView.showsVerticalScrollIndicator = false
        self.sampleTableView.showsHorizontalScrollIndicator = false
        self.sampleTableView.transform = CGAffineTransform(rotationAngle: -.pi/2)
        self.sampleTableView.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 90)
        self.sampleTableView.estimatedSectionHeaderHeight = 0
        self.sampleTableView.estimatedSectionFooterHeight = 0
        
        // 设置代理/数据
        self.sampleTableView.delegate = self
        self.sampleTableView.dataSource = self
        
        // 注册复用Cell
        self.sampleTableView.register(UINib(nibName: "ProductSampleCell", bundle: nil), forCellReuseIdentifier: "ProductSampleCell")
        
        self.contentView.addSubview(self.sampleLabel)
        self.contentView.addSubview(self.sampleTableView)
        self.sampleLabel.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self.sampleLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 11)
        topConstraint.priority = .defaultHigh
        let bottomConstraint = NSLayoutConstraint(item: self.sampleLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -130)
        bottomConstraint.priority = .defaultHigh
        self.contentView.addConstraints([
            topConstraint,
            bottomConstraint,
            NSLayoutConstraint(item: self.sampleLabel, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: self.sampleLabel, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -12)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        // 旋转屏幕时调整宽度
        self.sampleTableView.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 90)
        super.layoutSubviews()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.samples.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSampleCell", for: indexPath) as! ProductSampleCell
        cell.sampleImageView.kf.setImage(with: URL(string: samples[indexPath.section]), completionHandler: {
            (image, error, cacheType, imageUrl) in
            self.sampleWidths[indexPath.section] = (image?.size.width)! / (image?.size.height)! * 90
            tableView.beginUpdates()
            tableView.endUpdates()
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 自适应图片比例
        return self.sampleWidths[indexPath.row] ?? 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 12
        default:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case samples.count - 1:
            return 12
        default:
            return 4
        }
    }

}
