//
//  SearchCell.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/5.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class SearchCell: BasicCell, UISearchBarDelegate {
    
    private let searchBar = UISearchBar()
    var keyword: String? {
        get {
            return self.searchBar.text
        }
        set(newKeyword) {
            self.searchBar.text = newKeyword
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.returnKeyType = .done
        self.searchBar.enablesReturnKeyAutomatically = false
        self.searchBar.delegate = self
        self.contentView.addSubview(self.searchBar)
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.searchBar, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.searchBar, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.searchBar, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.searchBar, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
