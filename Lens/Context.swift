//
//  Context.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/27.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation

class Context {
    
    enum Tab: String {
        case equipment = "Equipment"
        case news = "News"
        case personal = "Personal"
        case wishlist = "Wishlist"
        case library = "Library"
        case budget = "Budget"
    }
    
    enum Category: String {
        case lenses = "Lenses"
        case cameras = "Cameras"
        case accessories = "Accessories"
    }
    
}
