//
//  NewsModel.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation

class NewsModel {
    
    var title: String!
    var info: String!
    var content: String!
    var url: String?
    var image: String?
    
    init(title: String, info: String, content: String) {
        self.title = title
        self.info = info
        self.content = content
    }
    
    convenience init(title: String, info: String, content: String, url: String) {
        self.init(title: title, info: info, content: content)
        self.url = url
    }
    
    convenience init(title: String, info: String, content: String, image: String) {
        self.init(title: title, info: info, content: content)
        self.image = image
    }
    
    convenience init(title: String, info: String, content: String, url: String, image: String) {
        self.init(title: title, info: info, content: content)
        self.url = url
        self.image = image
    }
    
}
