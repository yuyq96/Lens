//
//  Time.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/18.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation

func timeToCurrentTime(_ timestamp: Int) -> String {
    let timeInterval = Date().timeIntervalSince1970 - TimeInterval(timestamp)
    if timeInterval < 60 {
        if getCurrentLanguage() == "cn" {
            return "刚刚"
        } else {
            return "Less than a minute"
        }
    }
    let mins = Int(timeInterval / 60)
    if mins < 60 {
        if getCurrentLanguage() == "cn" {
            return "\(mins)分钟前"
        } else {
            return "\(mins) minutes before"
        }
    }
    let hours = Int(timeInterval / 3600)
    if hours < 24 {
        if getCurrentLanguage() == "cn" {
            return "\(hours)小时前"
        } else {
            return "\(hours) hours before"
        }
    }
    let days = Int(timeInterval / 3600 / 24)
    if days < 30 {
        if getCurrentLanguage() == "cn" {
            return "\(days)天前"
        } else {
            return "\(days) days before"
        }
    }
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat="yyyy"
    if dateFormatter.string(from: Date()) == dateFormatter.string(from: date) {
        if getCurrentLanguage() == "cn" {
            dateFormatter.dateFormat="MM月dd日"
        } else {
            dateFormatter.dateFormat="MMM.dd"
        }
        return dateFormatter.string(from: date as Date)
    } else {
        if getCurrentLanguage() == "cn" {
            dateFormatter.dateFormat="yyyy年MM月dd日"
        } else {
            dateFormatter.dateFormat="MMM.dd yyyy"
        }
        return dateFormatter.string(from: date as Date)
    }
}
