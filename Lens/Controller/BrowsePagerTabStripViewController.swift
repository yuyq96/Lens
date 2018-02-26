//
//  BrowsePagerTabStripViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/25.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BrowsePagerTabStripViewController: ButtonBarPagerTabStripViewController {
    
    let shadow = UIView()
    
    override func viewDidLoad() {
        // 移动顶部导航栏阴影位置（1）
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // 选中颜色
        let tintColor = UIColor(red: 126.0/255, green: 211.0/255, blue: 33.0/255, alpha: 1)
        
        // 设置PagerTabStripView风格
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14)
        settings.style.buttonBarItemTitleColor = UIColor.black
        settings.style.selectedBarHeight = 4
        settings.style.selectedBarBackgroundColor = tintColor
        settings.style.buttonBarMinimumLineSpacing = 0
        
        // 更改选中选项卡标题颜色
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor.black
            newCell?.label.textColor = tintColor
        }
        
        super.viewDidLoad()
        
        // 防止屏幕旋转时露出橙色的间隔
        buttonBarView.backgroundColor = UIColor.white
        
        // 移动顶部导航栏阴影位置（2）
        shadow.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        buttonBarView.superview?.addSubview(shadow)
    }
    
    override func viewWillLayoutSubviews() {
        // 旋转屏幕时刷新顶部导航栏阴影位置
        shadow.frame = CGRect(x: 0, y: buttonBarView.frame.height, width: UIScreen.main.bounds.width, height: 0.5)
    }

    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // 创建各个选项卡对应的页面
        let lensViewController = BrowseTableViewController(style: UITableViewStyle.grouped)
        let cameraViewController = BrowseTableViewController(style: UITableViewStyle.grouped)
        let accessoriesViewController = BrowseTableViewController(style: UITableViewStyle.grouped)
        lensViewController.type = navigationItem.title
        cameraViewController.type = navigationItem.title
        accessoriesViewController.type = navigationItem.title
        lensViewController.info = "Lens"
        cameraViewController.info = "Camera"
        accessoriesViewController.info = "Accessories"
        return [lensViewController, cameraViewController, accessoriesViewController]
    }
    
}
