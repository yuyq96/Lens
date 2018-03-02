//
//  UserModel.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/28.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation
import Alamofire

class UserModel {
    
    let url = "http://115.159.208.82:443/lens/user"
    private var _token = UserDefaults.standard.string(forKey: "Token")
    private var _username = UserDefaults.standard.string(forKey: "Username")
    private var _nickname = UserDefaults.standard.string(forKey: "Nickname")
    private var _avatar = UserDefaults.standard.string(forKey: "Avatar")
    var settings = Settings()
    var libraries: Products!
    var wishlist: Products!
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
    
    class Products {
        
        var lens: [String]!
        var camera: [String]!
        var accessories: [String]!
        
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
    
    func register(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let parameters: Parameters = ["task": "register", "username": username, "password": password]
        Alamofire.request(self.url, parameters: parameters).responseJSON() { response in
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
        Alamofire.request(self.url, parameters: parameters).responseJSON() { response in
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
        Alamofire.request("\(self.url)/info", parameters: parameters).responseJSON() { response in
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
        Alamofire.request("\(self.url)/info", parameters: parameters).responseJSON() { response in
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
        Alamofire.request("\(self.url)/info", parameters: parameters).responseJSON() { response in
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
        if self.settings.needsSync {
            let parameters: Parameters = ["task": "sync_settings", "token": self.token!, "budget": self.settings.budget, "show_budget": self.settings.showBudget]
            Alamofire.request("\(self.url)/info", parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
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

let user = UserModel()
