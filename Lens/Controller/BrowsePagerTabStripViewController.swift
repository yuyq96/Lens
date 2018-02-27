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
    var type: String?
    
    override func viewDidLoad() {
        // 设置默认type
        if self.type == nil {
            self.type = navigationItem.title
        } else {
            navigationItem.title = self.type
        }
        
        // 设置PagerTabStripView风格
        self.settings.style.buttonBarItemBackgroundColor = .white
        self.settings.style.buttonBarItemFont = .systemFont(ofSize: 14)
        self.settings.style.buttonBarItemTitleColor = .black
        self.settings.style.selectedBarHeight = 4
        self.settings.style.selectedBarBackgroundColor = Color.tint
        self.settings.style.buttonBarMinimumLineSpacing = 0
        
        // 更改选中选项卡标题颜色
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .black
            newCell?.label.textColor = Color.tint
        }
        
        super.viewDidLoad()
        
        // 在库和愿望清单中禁用PagerTab滑动，避免和TableView编辑冲突
        if type == Context.type.libraries || type == Context.type.wishlist {
            self.containerView.isScrollEnabled = false
        }
        
        // 禁用PagerTab回弹
        self.containerView.bounces = false
        
        // 防止屏幕旋转时露出橙色的间隔
        self.buttonBarView.backgroundColor = .white
        
        // 设置PagerTab阴影
        self.shadow.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        self.buttonBarView.superview?.addSubview(shadow)
    }
    
    override func viewWillLayoutSubviews() {
        // 旋转屏幕时刷新PagerTab阴影位置
        self.shadow.frame = CGRect(x: 0, y: buttonBarView.frame.height, width: UIScreen.main.bounds.width, height: 0.5)
    }

//    override func viewWillAppear(_ animated: Bool) {
//        // 隐藏NavigationBar阴影
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        // 恢复NavigationBar阴影
//        self.navigationController?.navigationBar.shadowImage = nil
//    }

    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // 创建各个选项卡对应的页面
        let lensViewController = BrowseTableViewController(style: .grouped)
        lensViewController.type = type
        lensViewController.info = Context.info.lens
        let cameraViewController = BrowseTableViewController(style: .grouped)
        cameraViewController.type = type
        cameraViewController.info = Context.info.camera
        let accessoriesViewController = BrowseTableViewController(style: .grouped)
        accessoriesViewController.type = type
        accessoriesViewController.info = Context.info.accessories
        return [lensViewController, cameraViewController, accessoriesViewController]
    }
    
}
