//
//  EquipmentPagerTabStripViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/25.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class EquipmentPagerTabStripViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let tintColor = UIColor(red: 126.0/255, green: 211.0/255, blue: 33.0/255, alpha: 1)
        
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.buttonBarItemTitleColor = UIColor.black
        settings.style.selectedBarHeight = 4
        settings.style.selectedBarBackgroundColor = tintColor
        settings.style.buttonBarMinimumLineSpacing = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor.black
            newCell?.label.textColor = tintColor
        }
        
        super.viewDidLoad()
        
        let shadow = UIView(frame: CGRect(x: 0, y: buttonBarView.frame.height, width: 375, height: 0.5))
        shadow.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        buttonBarView.superview?.addSubview(shadow)
    }

    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let lensViewController = EquipmentTableViewController()
        let cameraViewController = EquipmentTableViewController()
        let accessoriesViewController = EquipmentTableViewController()
        lensViewController.info = "Lens"
        cameraViewController.info = "Camera"
        accessoriesViewController.info = "Accessories"
        return [lensViewController, cameraViewController, accessoriesViewController]
    }
    
}
