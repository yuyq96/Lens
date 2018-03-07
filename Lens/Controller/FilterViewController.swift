//
//  FilterViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/5.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {
    
    var browseViewController: BrowseViewController!
    var shadowConstraint: NSLayoutConstraint!
    var keyword: String? {
        get {
            let searchCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SearchCell
            return searchCell.keyword
        }
    }
    var filters: [FilterCopy]!
    
    init(style: UITableViewStyle, browseViewController: BrowseViewController) {
        super.init(style: style)
        self.browseViewController = browseViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        shadowConstraint = Shadow.add(to: self.tableView)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        self.tableView.register(FilterCell.self, forCellReuseIdentifier: "FilterCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.shadowConstraint.constant = self.tableView.contentOffset.y
    }
    
    @objc func confirm(sender: UIBarButtonItem) {
        for filter in self.filters {
            filter.save()
        }
        var filtersJson: [String : [String : [Any]]]?
        for filter in filters {
            if let filterJson = filter.json {
                if filtersJson == nil {
                    filtersJson = ["bool": ["must": []]]
                }
                filtersJson!["bool"]!["must"]!.append(filterJson)
            }
        }
        self.browseViewController.refresh(keyword: keyword, filtered: filtersJson)
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if filters.count == 0 {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.filters.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
            cell.textLabel?.text = self.filters[indexPath.row].text
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let filter = self.filters[indexPath.row]
            switch filter.type {
            case .option:
                let filterOptionsViewController = FilterOptionsViewController(style: .grouped)
                filterOptionsViewController.filter = filter
                self.navigationController?.pushViewController(filterOptionsViewController, animated: true)
            case .int:
                break
            case .float:
                break
            }
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "search"
        case 1:
            return "filters"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == tableView.numberOfSections - 1 {
            let footerView = UIView()
            let confirmButton = UIButton(type: .roundedRect)
            confirmButton.backgroundColor = Color.tint
            confirmButton.layer.cornerRadius = 6
            confirmButton.layer.masksToBounds = true
            confirmButton.setTitle("Confirm", for: .normal)
            confirmButton.setTitleColor(.white, for: .normal)
            confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
            footerView.addSubview(confirmButton)
            confirmButton.translatesAutoresizingMaskIntoConstraints = false
            confirmButton.addConstraint(NSLayoutConstraint(item: confirmButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
            footerView.addConstraints([
                NSLayoutConstraint(item: confirmButton, attribute: .top, relatedBy: .equal, toItem: footerView, attribute: .top, multiplier: 1, constant: 12),
                NSLayoutConstraint(item: confirmButton, attribute: .leading, relatedBy: .equal, toItem: footerView, attribute: .leading, multiplier: 1, constant: 12),
                NSLayoutConstraint(item: confirmButton, attribute: .width, relatedBy: .equal, toItem: footerView, attribute: .width, multiplier: 1, constant: -24)
                ])
            return footerView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 32
        default:
            return 31
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case tableView.numberOfSections - 1:
            return 68
        default:
            return 1
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
