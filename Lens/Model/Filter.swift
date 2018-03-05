//
//  Filter.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/5.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import Foundation

class Filter {
    
    enum FilterType {
        case option
        case int
        case float
    }
    
    var name: String!
    var type: FilterType!
    var options: [String]!
    var selections: [Bool]!
    var int_min: Int!
    var int_max: Int!
    var float_min: Float!
    var float_max: Float!
    var allSelected: Bool {
        get {
            for selection in selections {
                if !selection {
                    return false
                }
            }
            return true
        }
    }
    var allDisselected: Bool {
        get {
            for selection in selections {
                if selection {
                    return false
                }
            }
            return true
        }
    }
    var text: String {
        get {
            switch self.type {
            case .option:
                var text = name!
                var first = true
                var allSelected = true
                for i in 0..<self.options.count {
                    if selections[i] {
                        if first {
                            text = text + ": " + options[i]
                            first = false
                        } else {
                            text = text + ", " + options[i]
                        }
                    } else {
                        allSelected = false
                    }
                }
                if allSelected {
                    return name
                } else {
                    return text
                }
            case .int:
                return "\(name!): \(int_min!) ~ \(int_max!)"
            case .float:
                return "\(name!): \(float_min!) ~ \(float_max!)"
            default:
                return name
            }
        }
    }
    
    init(name: String, include options: [String]) {
        self.name = name
        self.type = .option
        self.options = options
        self.selectAll()
    }
    
    init(name: String, from min: Int, to max: Int) {
        self.name = name
        self.type = .int
        self.int_min = min
        self.int_max = max
    }
    
    init(name: String, from min: Float, to max: Float) {
        self.name = name
        self.type = .float
        self.float_min = min
        self.float_max = max
    }
    
    func selectAll() {
        self.selections = []
        for _ in 0..<self.options.count {
            self.selections.append(true)
        }
    }
    
    func disselectAll() {
        self.selections = []
        for _ in 0..<self.options.count {
            self.selections.append(false)
        }
    }
    
    func transferToTerms() {
        
    }
    
}
