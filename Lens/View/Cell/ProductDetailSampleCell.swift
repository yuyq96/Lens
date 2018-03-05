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

    var productSample: UITableView!
    
    var samples: [String] = []
    var sampleWidths: [Int : CGFloat] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置样片列表
        self.productSample = UITableView(frame: .zero, style: .grouped)
        self.productSample.contentMode = .scaleToFill
        self.productSample.backgroundColor = UIColor(white: 1, alpha: 0)
        self.productSample.showsVerticalScrollIndicator = false
        self.productSample.showsHorizontalScrollIndicator = false
        self.productSample.transform = CGAffineTransform(rotationAngle: -.pi/2)
        self.productSample.frame = CGRect(x: 0, y: 37, width: UIScreen.main.bounds.width, height: 90)
        self.productSample.estimatedSectionHeaderHeight = 0
        self.productSample.estimatedSectionFooterHeight = 0
        
        // 设置代理/数据
        self.productSample.delegate = self
        self.productSample.dataSource = self
        
        // 注册复用Cell
        self.productSample.register(UINib(nibName: "ProductSampleCell", bundle: nil), forCellReuseIdentifier: "ProductSampleCell")
        
        addSubview(self.productSample)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        // 旋转屏幕时调整宽度
        self.productSample.frame = CGRect(x: 0, y: 37, width: UIScreen.main.bounds.width, height: 90)
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
            tableView.reloadRows(at: [indexPath], with: .automatic)
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
