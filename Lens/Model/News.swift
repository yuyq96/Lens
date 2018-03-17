//
//  News.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation

class News {
    
    var title: String!
    var source: String!
    var timestamp = 0
    var time: String {
        return timeToCurrentTime(timestamp)
    }
    var info: String {
        get {
            return "\(source!)    \(self.time)"
        }
    }
    var content: String?
    var image: String!
    var link: String!
    
    init(title: String, source: String, timestamp: Int, content: String?, link: String, image: String) {
        self.title = title
        self.source = source
        self.timestamp = timestamp
        self.content = content
        self.link = link
        self.image = image
    }
    
}
