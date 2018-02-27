//
//  NavigationBarShadowViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/27.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class NavigationBarShadowViewController: UIViewController {
    
    let shadow = UIView()
    
    var rootViewController: UIViewController!
    
    init(rootViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.rootViewController = rootViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.rootViewController.view)
        self.shadow.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        self.view.addSubview(self.shadow)
    }
    
    override func viewWillLayoutSubviews() {
        // 旋转屏幕时刷新NavigationBar阴影位置
        self.shadow.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
