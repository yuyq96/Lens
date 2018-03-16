//
//  TableViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/16.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        self.tableView.backgroundColor = Color.background
        self.tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections - 1 {
            return 16
        }
        return CGFloat.leastNormalMagnitude
    }
    
}
