//
//  EquipmentModel.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation

class EquipmentModel {
    
    var hash: String!
    var image: String!
    var name: String!
    var tags: [String]!
    
    init(hash: String, image: String, name: String, tags: [String]) {
        self.hash = hash
        self.image = image
        self.name = name
        self.tags = tags
    }
    
}
