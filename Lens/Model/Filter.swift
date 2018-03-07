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
    var type = FilterType.option
    var options: [String]!
    var selections: [Bool]!
    var min: Any!
    var max: Any!
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
                                text = text + ": " + options[i]
                                first = false
                            } else {
                                text = text + ", " + options[i]
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
    var json: [String : [String : [Any]]]? {
        get {
            switch self.type {
            case .option:
                if allSelected {
                    return nil
                } else {
                    var terms = [[String : [String : String]]]()
                    for i in 0..<self.count {
                        if self.selections[i] {
                            terms.append(["term": [self.name.lowercased().replacingOccurrences(of: " ", with: "_"): self.options[i]]])
                        }
                    }
                    return ["bool": ["should": terms]]
                }
            case .int, .float:
                return nil
            }
        }
    }
    var copy: FilterCopy {
        get {
            switch self.type {
            case .option:
                let copy = FilterCopy(root: self, name: name, include: options)
                copy.selections = self.selections
                return copy
            case .int:
                return FilterCopy(root: self, name: name, from: min as! Int, to: max as! Int)
            case .float:
                return FilterCopy(root: self, name: name, from: min as! Float, to: max as! Float)
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
        self.min = min
        self.max = max
    }
    
    init(name: String, from min: Float, to max: Float) {
        self.name = name
        self.type = .float
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
    
    init(root: Filter, name: String, include options: [String]) {
        super.init(name: name, include: options)
        self.root = root
    }
    
    init(root: Filter, name: String, from min: Int, to max: Int) {
        super.init(name: name, from: min, to: max)
        self.root = root
    }
    
    init(root: Filter, name: String, from min: Float, to max: Float) {
        super.init(name: name, from: min, to: max)
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
    
}
