//
//  Server.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/3.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation

class Server {
    
    static let url = "http://115.159.208.82:443/lens"
    static var userUrl: String {
        get {
            return "\(url)/user"
        }
    }
    static var userInfoUrl: String {
        get {
            return "\(url)/user/info"
        }
    }
    static var productUrl: String {
        get {
            return "\(url)/product"
        }
    }
    static var newsUrl: String {
        get {
            return "\(url)/news"
        }
    }
    
}
