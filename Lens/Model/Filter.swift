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
    
    var name = ""
    var attribName = ""
    var type = FilterType.option
    var options: [String]!
    var selections: [Bool]!
    var jsonHandlers: [() -> Any]?
    var jsonHandler: ((Any, Any) -> Any)?
    var min: Any!
    var max: Any!
    var defaultMin: Any!
    var defaultMax: Any!
    var count: Int {
        get {
            if type == .option {
                return options.count
            }
            return 0
        }
    }
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
                if self.allSelected {
                    return name
                } else {
                    var text = name
                    var first = true
                    for i in 0..<self.count {
                        if selections[i] {
                            if first {
                                text = text + ": " + NSLocalizedString(options[i], comment: "Options Name")
                                first = false
                            } else {
                                text = text + ", " + NSLocalizedString(options[i], comment: "Options Name")
                            }
                        }
                    }
                    return text
                }
            case .int, .float:
                return "\(name): \(min!) ~ \(max!)"
            }
        }
    }
    var json: [Any]? {
        get {
            switch self.type {
            case .option:
                if allSelected {
                    return nil
                } else if self.jsonHandlers != nil {
                    var ranges = [Any]()
                    for i in 0..<self.count {
                        if self.selections[i] {
                            ranges.append(self.jsonHandlers![i]())
                        }
                    }
                    return [
                        ["bool": ["should": ranges]]
                    ]
                } else {
                    var selectedOptions = [String]()
                    for i in 0..<self.count {
                        if self.selections[i] {
                            selectedOptions.append(self.options[i])
                        }
                    }
                    return [
                        ["terms": [self.attribName: selectedOptions]]
                    ]
                }
            case .int:
                if (self.min as! Int) == (self.defaultMin as! Int) && (self.max as! Int) == (self.defaultMax as! Int) {
                    return nil
                }
                if self.jsonHandler != nil {
                    return [self.jsonHandler!(self.min, self.max)]
                }
                return [
                    ["range": [self.attribName + "_max": ["lte": self.max]]],
                    ["range": [self.attribName + "_min": ["gte": self.min]]]
                ]
            case .float:
                if (self.min as! Float) == (self.defaultMin as! Float) && (self.max as! Float) == (self.defaultMax as! Float) {
                    return nil
                }
                if self.jsonHandler != nil {
                    return [self.jsonHandler!(self.min, self.max)]
                }
                return [
                    ["range": [self.attribName + "_max": ["lte": self.max]]],
                    ["range": [self.attribName + "_min": ["gte": self.min]]]
                ]
            }
        }
    }
    var copy: FilterCopy {
        get {
            switch self.type {
            case .option:
                let copy = FilterCopy(root: self, name: name, attribName: attribName, include: options)
                copy.selections = self.selections
                return copy
            case .int:
                return FilterCopy(root: self, name: name, attribName: attribName, min: defaultMin as! Int, max: defaultMax as! Int, from: min as! Int, to: max as! Int)
            case .float:
                return FilterCopy(root: self, name: name, attribName: attribName, min: defaultMin as! Float, max: defaultMax as! Float, from: min as! Float, to: max as! Float)
            }
        }
    }
    
    init(name: String, attribName: String, include options: [String]) {
        self.name = name
        self.attribName = attribName
        self.type = .option
        self.options = options
        self.selectAll()
    }
    
    convenience init(name: String, attribName: String, include options: [String], jsonHandlers: [() -> Any]) {
        self.init(name: name, attribName: attribName, include: options)
        self.jsonHandlers = jsonHandlers
    }
    
    init(name: String, attribName: String, min defaultMin: Int, max defaultMax: Int) {
        self.name = name
        self.attribName = attribName
        self.type = .int
        self.defaultMin = defaultMin
        self.defaultMax = defaultMax
        self.min = defaultMin
        self.max = defaultMax
    }
    
    convenience init(name: String, attribName: String, min defaultMin: Int, max defaultMax: Int, jsonHandler: @escaping (Any, Any) -> Any) {
        self.init(name: name, attribName: attribName, min: defaultMin, max: defaultMax)
        self.jsonHandler = jsonHandler
    }
    
    init(name: String, attribName: String, min defaultMin: Float, max defaultMax: Float) {
        self.name = name
        self.attribName = attribName
        self.type = .float
        self.defaultMin = defaultMin
        self.defaultMax = defaultMax
        self.min = defaultMin
        self.max = defaultMax
    }
    
    convenience init(name: String, attribName: String, min defaultMin: Float, max defaultMax: Float, jsonHandler: @escaping (Any, Any) -> Any) {
        self.init(name: name, attribName: attribName, min: defaultMin, max: defaultMax)
        self.jsonHandler = jsonHandler
    }
    
    init(name: String, attribName: String, min defaultMin: Int, max defaultMax: Int, from min: Int, to max: Int) {
        self.name = name
        self.attribName = attribName
        self.type = .int
        self.defaultMin = defaultMin
        self.defaultMax = defaultMax
        self.min = min
        self.max = max
    }
    
    init(name: String, attribName: String, min defaultMin: Float, max defaultMax: Float, from min: Float, to max: Float) {
        self.name = name
        self.attribName = attribName
        self.type = .float
        self.defaultMin = defaultMin
        self.defaultMax = defaultMax
        self.min = min
        self.max = max
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
    
}

class FilterCopy: Filter {
    
    private var root: Filter!
    
    init(root: Filter, name: String, attribName: String, include options: [String]) {
        super.init(name: name, attribName: attribName, include: options)
        self.root = root
    }
    
    init(root: Filter, name: String, attribName: String, min: Int, max: Int, from: Int, to: Int) {
        super.init(name: name, attribName: attribName, min: min, max: max, from: from, to: to)
        self.root = root
    }
    
    init(root: Filter, name: String, attribName: String, min: Float, max: Float, from: Float, to: Float) {
        super.init(name: name, attribName: attribName, min: min, max: max, from: from, to: to)
        self.root = root
    }
    
    func save() {
        switch self.type {
        case .option:
            root.selections = self.selections
        case .int, .float:
            root.min = self.min
            root.max = self.max
        }
    }
    
    func clear() {
        switch self.type {
        case .option:
            self.selectAll()
        case .int, .float:
            self.min = self.defaultMin
            self.max = self.defaultMax
        }
    }
    
}
