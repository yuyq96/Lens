//
//  UserModel.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/28.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation

class UserModel {
    
    class Products {
        
        var lens: [String]!
        var camera: [String]!
        var accessories: [String]!
        
    }
    
    class Settings {
        
        private var _showBudget = UserDefaults.standard.bool(forKey: "ShowBudget")
        var showBudget: Bool {
            get {
                return _showBudget
            }
            set(newShowBudget) {
                _showBudget = newShowBudget
                UserDefaults.standard.set(_showBudget, forKey: "ShowBudget")
            }
        }
        
    }
    
    var id = UserDefaults.standard.string(forKey: "UserID")
    private var _name = UserDefaults.standard.string(forKey: "UserName")
    var name: String? {
        get {
            return _name
        }
        set(newName) {
            _name = newName
            UserDefaults.standard.set(_name, forKey: "UserName")
        }
    }
    private var _avatar = UserDefaults.standard.string(forKey: "UserAvatar")
    var avatar: String? {
        get {
            return _avatar
        }
        set(newAvatar) {
            _avatar = newAvatar
            UserDefaults.standard.set(_avatar, forKey: "UserAvatar")
        }
    }
    private var _budget = UserDefaults.standard.string(forKey: "UserBudget")
    var budget: String? {
        get {
            return _budget
        }
        set(newBudget) {
            _budget = newBudget
            UserDefaults.standard.set(_budget, forKey: "UserBudget")
        }
    }
    var settings = Settings()
    var libraries: Products!
    var wishlist: Products!
    
    func register(id: String, passwd: String) -> Bool {
        return login(id: id, passwd: passwd)
    }
    
    func login(id: String, passwd: String) -> Bool {
        self.id = id
        self.name = id
        self.avatar = ""
        self.budget = "0"
        self.libraries = Products()
        self.wishlist = Products()
        
        UserDefaults.standard.set(user.id, forKey: "UserID")
        
        return true
    }
    
    func logout() {
        self.id = nil
        self.name = ""
        self.avatar = ""
        self.budget = "0"
        self.settings.showBudget = false
        
        UserDefaults.standard.removeObject(forKey: "UserID")
    }
    
}

let user = UserModel()
