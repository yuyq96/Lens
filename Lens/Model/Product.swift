//
//  Product.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation
import PINCache

class Detail: NSObject, NSCoding {
    
    var image: String!
    var specs: [String : String]!
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
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.specs, forKey: "specs")
        aCoder.encode(self.samples, forKey: "samples")
    }
    
    init(image: String, specs: [String: String], samples: [String]) {
        self.image = image
        self.specs = specs
        self.samples = samples
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.image = aDecoder.decodeObject(forKey: "image") as! String
        self.specs = aDecoder.decodeObject(forKey: "specs") as! [String : String]
        self.samples = aDecoder.decodeObject(forKey: "samples") as! [String]
    }
    
}

class Product: NSObject, NSCoding {
    
    var pid: String!
    var image: String!
    var name: String!
    var tags: [String]!
    var detail: Detail?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.pid, forKey: "pid")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.tags, forKey: "tags")
        aCoder.encode(self.detail, forKey: "detail")
    }
    
    init(pid: String, image: String, name: String, tags: [String]) {
        self.pid = pid
        self.image = image
        self.name = name
        self.tags = tags
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.pid = aDecoder.decodeObject(forKey: "pid") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.image = aDecoder.decodeObject(forKey: "image") as! String
        self.tags = aDecoder.decodeObject(forKey: "tags") as! [String]
        self.detail = aDecoder.decodeObject(forKey: "detail") as? Detail
    }
    
    func cache() {
        PINCache.shared().setObject(self, forKey: self.pid)
    }
    
    static func load(pid: String) -> Product? {
        var product: Product?
        PINCache.shared().object(forKey: pid) { (cache, key, object) in
            product = object as? Product
        }
        return product
    }
    
    func setDetail(image: String, specs: [String: String], samples: [String]) {
        self.detail = Detail(image: image, specs: specs, samples: samples)
    }
    
    func delDetail() {
        self.detail = nil
    }
    
}
