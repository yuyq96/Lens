//
//  KV.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/8.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation

class KV: NSObject, NSCoding {
    
    var key: String
    var value: String
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.key, forKey: "key")
        aCoder.encode(self.value, forKey: "value")
    }
    
    init(_ key: String, _ value: String) {
        self.key = key
        self.value = value
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let key = aDecoder.decodeObject(forKey: "key") as? String {
            self.key = key
        } else {
            return nil
        }
        if let value = aDecoder.decodeObject(forKey: "value") as? String {
            self.value = value
        } else {
            return nil
        }
    }
    
}
