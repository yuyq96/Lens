//
//  User.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/28.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation
import Alamofire
import PINCache

class Products: NSObject, NSCoding, Sequence {
    
    var name: String
    private var list: [String]
    var needsSync: Bool
    var count: Int {
        get {
            return list.count
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.list, forKey: "list")
        aCoder.encode(self.needsSync, forKey: "needsSync")
    }
    
    init(name: String) {
        self.name = name
        self.list = []
        self.needsSync = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.list = aDecoder.decodeObject(forKey: "list") as! [String]
        self.needsSync = aDecoder.decodeBool(forKey: "needsSync")
    }
    
    subscript(index: Int) -> String {
        get {
            return self.list[index]
        }
        set(newValue) {
            self.list[index] = newValue
            self.cache()
        }
    }
    
    func contains(_ pid: String) -> Bool {
        return self.list.contains(pid)
    }
    
    func append(_ pid: String) {
        if !self.list.contains(pid) {
            self.list.append(pid)
            self.cache()
        }
    }
    
    func append(_ pids: Set<String>) {
        for pid in pids {
            self.list.append(pid)
        }
        self.cache()
    }
    
    func remove(_ pid: String) {
        if let index = self.list.index(of: pid) {
            self.list.remove(at: index)
            self.cache()
        }
    }
    
    func remove(at index: Int) {
        self.list.remove(at: index)
        self.cache()
    }
    
    func makeIterator() -> Products.Iterator {
        return Iterator(self)
    }
    
    struct Iterator: IteratorProtocol {
        
        let products: Products
        var index = 0
        
        init(_ products: Products) {
            self.products = products
        }
        
        mutating func next() -> String? {
            guard index < products.count
                else { return nil }
            let pid = products[index]
            index += 1
            return pid
        }
        
    }
    
    func cache() {
        PINCache.shared().setObject(self, forKey: self.name)
    }
    
    @discardableResult static func load(name: String, completion: @escaping (Products?) -> Void) -> Bool {
        PINCache.shared().object(forKey: name) { (cache, key, object) in
            completion(object as? Products)
        }
        return PINCache.shared().containsObject(forKey: name)
    }
    
    func sync() {
        if self.needsSync {
            
        }
    }
    
}

class ProductsGroup {
    
    var name: String
    var lenses: Products
    var cameras: Products
    var accessories: Products
    
    init(name: String) {
        self.name = name
        self.lenses = Products(name: "\(name)Lenses")
        self.cameras = Products(name: "\(name)Cameras")
        self.accessories = Products(name: "\(name)Accessories")
        Products.load(name: "\(name)Lenses") { products in
            if products != nil {
                self.lenses = products!
            }
        }
        Products.load(name: "\(name)Cameras") { products in
            if products != nil {
                self.cameras = products!
            }
        }
        Products.load(name: "\(name)Accessories") { products in
            if products != nil {
                self.accessories = products!
            }
        }
    }
    
    subscript(equipmentCategory: Context.EquipmentCategory) -> Products {
        switch equipmentCategory {
        case .lenses:
            return lenses
        case .cameras:
            return cameras
        case .accessories:
            return accessories
        }
    }
    
}

class Settings {
    
    private var _needsSync = UserDefaults.standard.bool(forKey: "SettingsNeedsSync")
    private var _budget = UserDefaults.standard.string(forKey: "SettingsBudget")
    private var _showBudget = UserDefaults.standard.bool(forKey: "SettingsShowBudget")
    var needsSync: Bool {
        get {
            return self._needsSync
        }
        set(newNeedsSync) {
            self._needsSync = newNeedsSync
            UserDefaults.standard.set(self._needsSync, forKey: "SettingsNeedsSync")
        }
    }
    var budget: String! {
        get {
            return self._budget ?? "0"
        }
        set(newBudget) {
            self._budget = newBudget
            UserDefaults.standard.set(self._budget, forKey: "SettingsBudget")
            self.needsSync = true
        }
    }
    var showBudget: Bool {
        get {
            return self._showBudget
        }
        set(newShowBudget) {
            self._showBudget = newShowBudget
            UserDefaults.standard.set(self._showBudget, forKey: "SettingsShowBudget")
            self.needsSync = true
        }
    }
    
}

class User {
    
    private var _token = UserDefaults.standard.string(forKey: "Token")
    private var _username = UserDefaults.standard.string(forKey: "Username")
    private var _nickname = UserDefaults.standard.string(forKey: "Nickname")
    private var _avatar = UserDefaults.standard.string(forKey: "Avatar")
    var settings = Settings()
    var libraries = ProductsGroup(name: "Libraries")
    var wishlist = ProductsGroup(name: "Wishlist")
    var token: String? {
        get {
            return self._token
        }
        set(newToken) {
            self._token = newToken
            UserDefaults.standard.set(self._token, forKey: "Token")
        }
    }
    private(set) var username: String! {
        get {
            return self._username ?? "Username"
        }
        set(newUsername) {
            self._username = newUsername
            UserDefaults.standard.set(self._username, forKey: "Username")
        }
    }
    private(set) var nickname: String! {
        get {
            return self._nickname ?? "Nickname"
        }
        set(newNickname) {
            self._nickname = newNickname
            UserDefaults.standard.set(self._nickname, forKey: "Nickname")
        }
    }
    private(set) var avatar: String! {
        get {
            return self._avatar ?? ""
        }
        set(newAvatar) {
            self._avatar = newAvatar
            UserDefaults.standard.set(self._avatar, forKey: "Avatar")
        }
    }
    
    subscript(category: Context.Category) -> ProductsGroup? {
        switch category {
        case .library:
            return libraries
        case .wishlist:
            return wishlist
        default:
            return nil
        }
    }
    
    func register(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let parameters: Parameters = ["task": "register", "username": username, "password": password]
        Alamofire.request(Server.userUrl, parameters: parameters).responseJSON() { response in
            if let json = response.result.value as? [String : Any] {
                let status = json["status"] as! String
                if status == "success", let userInfo = json["user_info"] as! [String : Any]? {
                    self.token = userInfo["token"] as? String
                    self.username = userInfo["username"] as? String
                    self.nickname = userInfo["nickname"] as? String
                    self.avatar = userInfo["avatar"] as? String
                    self.settings.budget = "\(userInfo["budget"]!)"
                    self.settings.showBudget = userInfo["show_budget"] as! Bool
                    completion(true)
                } else if status == "failure" {
                    print(json["error"]!)
                    completion(false)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let parameters: Parameters = ["task": "login", "username": username, "password": password]
        Alamofire.request(Server.userUrl, parameters: parameters).responseJSON() { response in
            if let json = response.result.value as? [String : Any] {
                let status = json["status"] as! String
                if status == "success", let userInfo = json["user_info"] as! [String : Any]? {
                    self.token = userInfo["token"] as? String
                    self.username = userInfo["username"] as? String
                    self.nickname = userInfo["nickname"] as? String
                    self.avatar = userInfo["avatar"] as? String
                    self.settings.budget = "\(userInfo["budget"]!)"
                    self.settings.showBudget = userInfo["show_budget"] as! Bool
                    completion(true)
                } else if status == "failure" {
                    print(json["error"]!)
                    completion(false)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func logout(completion: () -> Void) {
        self.token = nil
        self.settings.needsSync = false
        self.settings.showBudget = false
        UserDefaults.standard.removeObject(forKey: "Token")
        completion()
    }
    
    func update(nickname: String, completion: @escaping (Bool) -> Void) {
        let parameters: Parameters = ["task": "update_nickname", "token": self.token!, "nickname": nickname]
        Alamofire.request(Server.userInfoUrl, parameters: parameters).responseJSON() { response in
            if let json = response.result.value as? [String : Any] {
                let status = json["status"] as! String
                if status == "success" {
                    self.nickname = nickname
                    completion(true)
                } else if status == "failure" {
                    print(json["error"]!)
                    completion(false)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func update(avatar: String, completion: @escaping (Bool) -> Void) {
        let parameters: Parameters = ["task": "update_avatar", "token": self.token!, "avatar": avatar]
        Alamofire.request(Server.userInfoUrl, parameters: parameters).responseJSON() { response in
            if let json = response.result.value as? [String : Any] {
                let status = json["status"] as! String
                if status == "success" {
                    self.avatar = avatar
                    completion(true)
                } else if status == "failure" {
                    print(json["error"]!)
                    completion(false)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func updatePassword(old: String, new: String, completion: @escaping (Bool) -> Void) {
        let parameters: Parameters = ["task": "update_password", "token": self.token!, "old": old, "new": new]
        Alamofire.request(Server.userInfoUrl, parameters: parameters).responseJSON() { response in
            if let json = response.result.value as? [String : Any] {
                let status = json["status"] as! String
                if status == "success" {
                    completion(true)
                } else if status == "failure" {
                    print(json["error"]!)
                    completion(false)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func syncSettings(completion: ((Bool) -> Void)?) {
        if self.token != nil && self.settings.needsSync {
            let parameters: Parameters = ["task": "sync_settings", "token": self.token!, "budget": self.settings.budget, "show_budget": self.settings.showBudget]
            Alamofire.request(Server.userInfoUrl, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
                if let json = response.result.value as? [String : Any] {
                    let status = json["status"] as! String
                    if status == "success" {
                        self.settings.needsSync = false
                        completion?(true)
                    } else if status == "failure" {
                        print(json["error"]!)
                        completion?(false)
                    } else {
                        completion?(false)
                    }
                }
            }
        }
    }
    
}

let user = User()
