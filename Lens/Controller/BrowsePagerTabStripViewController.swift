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
    
    override func viewDidLoad() {
        // 根据tab设置标题
        navigationItem.title = self.tab.rawValue
        
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
    }

    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // 创建各个选项卡对应的页面
        let lensViewController = BrowseViewController(style: .grouped)
        lensViewController.tab = tab
        lensViewController.category = Context.Category.lenses
        let cameraViewController = BrowseViewController(style: .grouped)
        cameraViewController.tab = tab
        cameraViewController.category = Context.Category.cameras
        let accessoriesViewController = BrowseViewController(style: .grouped)
        accessoriesViewController.tab = tab
        accessoriesViewController.category = Context.Category.accessories
        return [lensViewController, cameraViewController, accessoriesViewController]
    }
    
    @objc func setProdutFilter(sender: UIBarButtonItem) {
        let filterRootViewController = UIViewController()
        filterRootViewController.view.backgroundColor = .white
        filterRootViewController.navigationItem.title = "Filter"
        filterRootViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelProdutFilter))
        filterRootViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(confirmProdutFilter))
        let filterViewController = NavigationController(rootViewController: filterRootViewController)
        filterViewController.navigationBar.shadowImage = nil
        self.present(filterViewController, animated: true, completion: nil)
    }
    
    @objc func cancelProdutFilter(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmProdutFilter(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
