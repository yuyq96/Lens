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
    
    var category: Context.Category!
    
    var subViewControllers: [BrowseViewController] = []
    var filterButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        // 根据tab设置标题
        self.navigationItem.title = NSLocalizedString(self.category.rawValue, comment: "title")
        
        // 设置PagerTabStripView风格
        switch self.category! {
        case .explore, .equipment:
            self.settings.style.buttonBarBackgroundColor = .clear
            self.settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 17)
        default:
            self.settings.style.buttonBarItemFont = .systemFont(ofSize: 15)
        }
        self.settings.style.buttonBarItemBackgroundColor = .white
        self.settings.style.buttonBarItemTitleColor = .black
        self.settings.style.selectedBarHeight = 4
        self.settings.style.selectedBarBackgroundColor = Color.tint
        self.settings.style.buttonBarMinimumLineSpacing = 0
        
        // 更改选中选项卡标题颜色
        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = Color.tint
            if self.category == .equipment {
                var index = 0
                if newCell?.label.text == NSLocalizedString(Context.EquipmentCategory.cameras.rawValue, comment: "") {
                    index = 1
                } else if newCell?.label.text == NSLocalizedString(Context.EquipmentCategory.accessories.rawValue, comment: "") {
                    index = 2
                }
                self.setFiltered(self.subViewControllers[index].filtered)
            }
        }
        
        super.viewDidLoad()
        
        // 禁用PagerTab回弹
        self.containerView.bounces = false
        
        // 防止屏幕旋转时露出橙色的间隔
        self.buttonBarView.backgroundColor = .white
        
        // 设置PagerTab阴影
//        let constraint = Shadow.add(to: self.buttonBarView.superview!)
//        constraint.constant = self.buttonBarView.frame.height
        
        switch self.category! {
        case .equipment:
            self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(setProdutFilter)), animated: false)
        case .library, .wishlist:
            self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(beginEditing)), animated: false)
        default:
            break
        }
        
        switch self.category! {
        case .explore, .equipment:
            self.buttonBarView.removeFromSuperview()
            let navigationBarView = NavigationBarView(self.buttonBarView)
            self.navigationItem.titleView = navigationBarView
            navigationBarView.addConstraints([
                NSLayoutConstraint(item: navigationBarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 240)
                ])
            // 重置滑动显示区域
            let oldFrame = self.containerView.frame
            self.containerView.frame = CGRect(x: 0, y: 0, width: oldFrame.width, height: oldFrame.height + 44)
        case .library, .wishlist:
            break
        }
        
    }
    
    @objc func beginEditing(_ sender: UIButton) {
        self.subViewControllers[self.currentIndex].tableView.isEditing = true
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: NSLocalizedString("Finish", comment: "Finish"), style: .plain, target: self, action: #selector(endEditing)), animated: true)
    }
    
    @objc func endEditing(_ sender: UIButton) {
        self.subViewControllers[self.currentIndex].tableView.isEditing = false
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(beginEditing)), animated: true)
    }

    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // 创建各个选项卡对应的页面
        switch self.category! {
        case .equipment, .library, .wishlist:
            let categories = [Context.EquipmentCategory.lenses, Context.EquipmentCategory.cameras, Context.EquipmentCategory.accessories]
            for category in categories {
                let subViewController = BrowseViewController(style: .grouped)
                subViewController.equipmentCategory = category
                subViewController.category = self.category
                subViewController.filters = []
                subViewController.setFilterd = self.setFiltered
                self.subViewControllers.append(subViewController)
            }
            return self.subViewControllers
        case .explore:
            let articlesViewController = BrowseViewController(style: .grouped)
            articlesViewController.category = category
            articlesViewController.exploreCategory = Context.ExploreCategory.articles
            articlesViewController.filters = []
            self.subViewControllers.append(articlesViewController)
            let reviewsViewController = BrowseViewController(style: .grouped)
            reviewsViewController.category = category
            reviewsViewController.exploreCategory = Context.ExploreCategory.reviews
            reviewsViewController.filters = []
            self.subViewControllers.append(reviewsViewController)
            let newsViewController = BrowseViewController(style: .grouped)
            newsViewController.category = category
            newsViewController.exploreCategory = Context.ExploreCategory.news
            newsViewController.filters = []
            self.subViewControllers.append(newsViewController)
            return self.subViewControllers
        }
    }
    
    func setFiltered(_ filtered: Bool) {
        if filtered {
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "filtered")
        } else {
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "filter")
        }
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "Cancel"), style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
    
}
