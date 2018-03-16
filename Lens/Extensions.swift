//
//  Extensions.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/17.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

extension UIImage {
    static func with(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
