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
    var filters: [[Filter]]!
    
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
            self.filters = [[], [], []]
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(setProdutFilter))
            filters[0].append(Filter(name: "Brand", include: ["Canon", "Carl Zeiss", "Fujifilm", "Kenko Tokina", "Konica Minolta", "Leica", "Lensbaby", "Lomography", "Mitakon", "Nikon", "Noktor", "Olympus", "Panasonic", "Pentax", "Ricoh", "Samyung", "Schneider Kreuznach", "Sigma", "Sony", "Tamron", "Tokina", "Voigtlander", "YI"]))
            filters[0].append(Filter(name: "Mount Type", include: ["Canon EF", "Canon EF-M", "Canon EF-S", "Compact", "Composor Pro", "Four Thirds", "Fujifilm G", "Fujifilm X", "Leica M", "Leica S", "Leica T", "Mamiya 645 AF", "Nikon 1 CX", "Nikon F DX", "Nikon F FX", "Pentax KAF", "Pentax Q", "Samsung NX", "Samsung NX-M", "Sigma SA", "Sony Alpha", "Sony Alpha DT", "Sony E", "Sony FE"]))
            filters[0].append(Filter(name: "Lens Type", include: ["Zoom", "Prime"]))
            filters[0].append(Filter(name: "Lens Size", include: ["super wide-angle", "wide-angle", "standard", "telephoto", "super telephoto"]))
            filters[0].append(Filter(name: "Focal Range", from: 1, to: 1500))
            filters[0].append(Filter(name: "Aperture", from: 0.95, to: 45))
            filters[1].append(Filter(name: "Brand", include: ["Canon", "Casio", "DJI", "DxO", "GoPro", "Hasselblad", "Konica Minolta", "Fujifilm", "Leaf", "Leica", "Mamiya", "Nikon", "Nokia", "Olympus", "Panasonic", "Pentax", "Phase One", "Ricoh", "Samsung", "Sigma", "Sony", "YI", "YUNEEC"]))
            filters[1].append(Filter(name: "Mount Type", include: ["Canon EF", "Canon EF-M", "Canon EF-S", "Compact", "Composor Pro", "Four Thirds", "Fujifilm G", "Fujifilm X", "Leica M", "Leica S", "Leica T", "Mamiya 645 AF", "Nikon 1 CX", "Nikon F DX", "Nikon F FX", "Pentax KAF", "Pentax Q", "Samsung NX", "Samsung NX-M", "Sigma SA", "Sony Alpha", "Sony Alpha DT", "Sony E", "Sony FE"]))
            filters[1].append(Filter(name: "Sensor Format", include: ["Full Frame", "Medium Format", "APS-H", "APS-C", "4/3\"", "1\"", "2/3\"", "1/1.7\"", "1/2.3\""]))
            filters[1].append(Filter(name: "Lens Size", include: ["super wide-angle", "wide-angle", "standard", "telephoto", "super telephoto"]))
            filters[1].append(Filter(name: "Resolution(M)", from: 1.0, to: 100.0))
        }
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
        let filterViewController = FilterViewController(style: .grouped)
        filterViewController.filters = filters[self.currentIndex]
        filterViewController.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
    
}
