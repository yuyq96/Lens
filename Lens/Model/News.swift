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
    var timestamp: String!
    var info: String {
        get {
            let timeInterval = TimeInterval(timestamp)
            let date = Date(timeIntervalSince1970: timeInterval!)
            let dformatter = DateFormatter()
            if getCurrentLanguage() == "cn" {
                dformatter.dateFormat = "yyyy年MM月dd日"
            } else {
                dformatter.dateFormat = "MMM.dd yyyy"
            }
            return "\(source!)    \(dformatter.string(from: date))"
        }
    }
    var content: String!
    var image: String!
    var link: String!
    
    init(title: String, source: String, timestamp: String, content: String, link: String, image: String) {
        self.title = title
        self.source = source
        self.timestamp = timestamp
        self.content = content
        self.link = link
        self.image = image
    }
    
}
