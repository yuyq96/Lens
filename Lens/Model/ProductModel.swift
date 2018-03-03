//
//  ProductModel.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation

class ProductModel {
    
    var pid: String!
    var image: String!
    var name: String!
    var tags: [String]!
    var detail: Detail?
    
    class Detail {
        
        var image: String!
        var specs: [String: String]!
        var samples: [String]!
        var info: String {
            get {
                var info = ""
                for (attr, value) in self.specs {
                    info += "\(attr): \(value)\n"
                }
                return info
            }
        }
        
        init(image: String, specs: [String: String], samples: [String]) {
            self.image = image
            self.specs = specs
            self.samples = samples
        }
        
    }
    
    init(pid: String, image: String, name: String, tags: [String]) {
        self.pid = pid
        self.image = image
        self.name = name
        self.tags = tags
    }
    
    func setDetail(image: String, specs: [String: String], samples: [String]) {
        self.detail = Detail(image: image, specs: specs, samples: samples)
    }
    
    func delDetail() {
        self.detail = nil
    }
    
}
