//
//  ProductModel.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation

class ProductModel {
    
    var hash: String!
    var image: String!
    var name: String!
    var tags: [String]!
    
    class Detail {
        
        var image: String!
        var specs: [String]!
        var samples: [String]!
        
        init(image: String, specs: [String], samples: [String]) {
            self.image = image
            self.specs = specs
            self.samples = samples
        }
        
    }
    
    var detail: Detail?
    
    init(hash: String, image: String, name: String, tags: [String]) {
        self.hash = hash
        self.image = image
        self.name = name
        self.tags = tags
    }
    
    func setDetail(image: String, specs: [String], samples: [String]) {
        self.detail = Detail(image: image, specs: specs, samples: samples)
    }
    
    func delDetail() {
        self.detail = nil
    }
    
}
