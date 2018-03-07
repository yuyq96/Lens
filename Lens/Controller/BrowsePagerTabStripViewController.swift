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
    
    var tab: Context.Tab!
    
    var subViewControllers: [BrowseViewController] = []
    
    override func viewDidLoad() {
        // 根据tab设置标题
        self.navigationItem.title = self.tab.rawValue
        
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
        if tab == .libraries || tab == .wishlist {
            self.containerView.isScrollEnabled = false
        }
        
        // 禁用PagerTab回弹
        self.containerView.bounces = false
        
        // 防止屏幕旋转时露出橙色的间隔
        self.buttonBarView.backgroundColor = .white
        
        // 设置PagerTab阴影
        let constraint = Shadow.add(to: self.buttonBarView.superview!)
        constraint.constant = self.buttonBarView.frame.height
        
        if tab == .equipment {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(setProdutFilter))
        }
    }

    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // 创建各个选项卡对应的页面
        let lensViewController = BrowseViewController(style: .grouped)
        lensViewController.tab = tab
        lensViewController.category = Context.Category.lenses
        lensViewController.filters = []
        self.subViewControllers.append(lensViewController)
        let cameraViewController = BrowseViewController(style: .grouped)
        cameraViewController.tab = tab
        cameraViewController.category = Context.Category.cameras
        cameraViewController.filters = []
        self.subViewControllers.append(cameraViewController)
        let accessoriesViewController = BrowseViewController(style: .grouped)
        accessoriesViewController.tab = tab
        accessoriesViewController.category = Context.Category.accessories
        accessoriesViewController.filters = []
        self.subViewControllers.append(accessoriesViewController)
        return self.subViewControllers
    }
    
    @objc func setProdutFilter(sender: UIBarButtonItem) {
        let filterViewController = FilterViewController(style: .grouped, browseViewController: self.subViewControllers[self.currentIndex])
        // 拷贝关键字
        filterViewController.keyword = self.subViewControllers[self.currentIndex].keyword
        // 拷贝过滤器
        filterViewController.filters = []
        for filter in self.subViewControllers[self.currentIndex].filters {
            filterViewController.filters.append(filter.copy)
        }
        filterViewController.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
    
}
