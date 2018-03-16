//
//  GradientView.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/16.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class GradientView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

}
