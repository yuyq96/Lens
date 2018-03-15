//
//  Context.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/27.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation

class Context {
    
    enum Category: String {
        case equipment = "Equipment"
        case explore = "Explore"
        case wishlist = "Wishlist"
        case library = "Library"
    }
    
    enum EquipmentCategory: String {
        case lenses = "Lenses"
        case cameras = "Cameras"
        case accessories = "Accessories"
    }
    
    enum ExploreCategory: String {
        case articles = "Articles"
        case reviews = "Reviews"
        case news = "News"
    }
    
}
