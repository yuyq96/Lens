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
    
    var image: String
    var specs: [KV]
    var samples: [String]
    var info: NSMutableAttributedString? {
        get {
            let paraph = NSMutableParagraphStyle()
            paraph.lineSpacing = 4
            let attribAttributes = [
//                NSAttributedStringKey.kern: NSNumber(value: 1.2),
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.foregroundColor: UIColor.black,
                NSAttributedStringKey.paragraphStyle: paraph
            ]
            let valueAttributes = [
//                NSAttributedStringKey.kern: NSNumber(value: 1.2),
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.foregroundColor: UIColor.gray,
                NSAttributedStringKey.paragraphStyle: paraph
            ]
            var text: String?
            var colon = ": "
            if getCurrentLanguage() == "cn" {
                colon = "："
            }
            for spec in self.specs {
                if text == nil {
                    text = spec.key + colon + spec.value
                } else {
                    text! += "\n" + spec.key + colon + spec.value
                }
            }
            if text != nil {
                let info = NSMutableAttributedString(string: text!)
                var pos = -1
                var len: Int!
                for spec in self.specs {
                    if pos == -1 {
                        pos = 0
                        len = spec.key.count + colon.count
                    } else {
                        len = spec.key.count + colon.count + 1
                    }
                    info.addAttributes(attribAttributes, range: NSMakeRange(pos, len))
                    pos += len
                    len = spec.value.count
                    info.addAttributes(valueAttributes, range: NSMakeRange(pos, len))
                    pos += len
                }
                return info
            } else {
                return nil
            }
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.specs, forKey: "specs")
        aCoder.encode(self.samples, forKey: "samples")
    }
    
    init(image: String, specs: [KV], samples: [String]) {
        self.image = image
        self.specs = specs
        self.samples = samples
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let image = aDecoder.decodeObject(forKey: "image") as? String {
            self.image = image
        } else {
            return nil
        }
        if let specs = aDecoder.decodeObject(forKey: "specs") as? [KV] {
            self.specs = specs
        } else {
            return nil
        }
        if let samples = aDecoder.decodeObject(forKey: "samples") as? [String] {
            self.samples = samples
        } else {
            return nil
        }
        
    }
    
}

class Product: NSObject, NSCoding {
    
    var pid: String
    var image: String
    var name: String
    var dxoScore: Int
    var tags: [String]
    var detail: Detail?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.pid, forKey: "pid")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.dxoScore, forKey: "dxoScore")
        aCoder.encode(self.tags, forKey: "tags")
        aCoder.encode(self.detail, forKey: "detail")
    }
    
    init(pid: String, image: String, name: String, dxoScore: Int, tags: [String]) {
        self.pid = pid
        self.image = image
        self.name = name
        self.dxoScore = dxoScore
        self.tags = tags
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.pid = aDecoder.decodeObject(forKey: "pid") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.image = aDecoder.decodeObject(forKey: "image") as! String
        self.dxoScore = aDecoder.decodeInteger(forKey: "dxoScore")
        self.tags = aDecoder.decodeObject(forKey: "tags") as! [String]
    }
    
    func cache() {
        PINCache.shared().setObject(self, forKey: self.pid)
    }
    
    static func load(pid: String, completion: @escaping (Product?) -> Void) -> Bool {
        PINCache.shared().object(forKey: pid) { (cache, key, object) in
            completion(object as? Product)
        }
        return PINCache.shared().containsObject(forKey: pid)
    }
    
    func setDetail(image: String, specs: [KV], samples: [String]) {
        self.detail = Detail(image: image, specs: specs, samples: samples)
        PINCache.shared().setObject(self.detail!, forKey: "\(self.pid)_detail")
    }
    
    @discardableResult func loadDetail() -> Bool {
        PINCache.shared().object(forKey: "\(self.pid)_detail") { (cache, key, object) in
            self.detail = object as? Detail
        }
        return PINCache.shared().containsObject(forKey: "\(self.pid)_detail")
    }
    
    func delDetail() {
        self.detail = nil
    }
    
}
