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
    var searchCell: SearchCell!
    
    var keyword: String?
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
        
        // 设置NavigationBar阴影
        self.shadowConstraint = Shadow.add(to: self.tableView)
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear)), animated: false)
        
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        self.tableView.register(FilterCell.self, forCellReuseIdentifier: "FilterCell")
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.shadowConstraint.constant = self.tableView.contentOffset.y
    }
    
    @objc func confirm(_ sender: UIButton) {
        self.browseViewController.keyword = self.searchCell.keyword
        for filter in self.filters {
            filter.save()
        }
        self.browseViewController.refresh()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clear(_ sender: UIButton) {
        self.keyword = nil
        self.searchCell.keyword = nil
        for filter in self.filters {
            filter.clear()
        }
        self.tableView.reloadData()
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
            self.searchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
            if let keyword = self.keyword {
                self.searchCell.keyword = keyword
            }
            return self.searchCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
            cell.textLabel?.text = self.filters[indexPath.row].text
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    private func beginSettingFilter(filter: Filter, message: String? = nil, min oldMin: Any? = nil, max oldMax: Any? = nil, completionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: filter.name, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            if filter.type == .int {
                if let min = Int(alertController.textFields![0].text!), let max = Int(alertController.textFields![1].text!) {
                    let defaultMin = filter.defaultMin as! Int
                    let defaultMax = filter.defaultMax as! Int
                    if min > max {
                        return self.beginSettingFilter(filter: filter, message: "⚠️ Minimum is greater than maximum", min: min, max: max)
                    } else if min < defaultMin {
                        return self.beginSettingFilter(filter: filter, message: "⚠️ Minimum should not less than \(defaultMin)", max: max)
                    } else if max > defaultMax {
                        return self.beginSettingFilter(filter: filter, message: "⚠️ Maximum should not greater than \(defaultMax)", min: min)
                    }
                    filter.min = min
                    filter.max = max
                    completionHandler?()
                } else {
                    return self.beginSettingFilter(filter: filter, message: "⚠️ Wrong value")
                }
            } else if filter.type == .float {
                if let min = Float(alertController.textFields![0].text!), let max = Float(alertController.textFields![1].text!) {
                    let defaultMin = filter.defaultMin as! Float
                    let defaultMax = filter.defaultMax as! Float
                    if min > max {
                        return self.beginSettingFilter(filter: filter, message: "⚠️ Minimum is greater than maximum", min: min, max: max)
                    } else if min < defaultMin {
                        return self.beginSettingFilter(filter: filter, message: "⚠️ Minimum should not less than \(defaultMin)", max: max)
                    } else if max > defaultMax {
                        return self.beginSettingFilter(filter: filter, message: "⚠️ Maximum should not greater than \(defaultMax)", min: min)
                    }
                    filter.min = min
                    filter.max = max
                    completionHandler?()
                } else {
                    return self.beginSettingFilter(filter: filter, message: "⚠️ Wrong value")
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.keyboardType = .decimalPad
            if oldMin != nil {
                textField.text = "\(oldMin!)"
            } else {
                textField.text = "\(filter.min!)"
            }
            let hint = UITextView()
            hint.text = ">="
            hint.font = textField.font
            hint.sizeToFit()
            hint.backgroundColor = Color.translucent
            textField.leftView = hint
            textField.leftViewMode = .always
            textField.placeholder = "\(filter.defaultMin!)"
            print(hint.frame)
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.keyboardType = .decimalPad
            if oldMax != nil {
                textField.text = "\(oldMax!)"
            } else {
                textField.text = "\(filter.max!)"
            }
            let hint = UITextView()
            hint.text = "<="
            hint.font = textField.font
            hint.sizeToFit()
            hint.backgroundColor = Color.translucent
            textField.leftView = hint
            textField.leftViewMode = .always
            textField.placeholder = "\(filter.defaultMax!)"
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let filter = self.filters[indexPath.row]
            switch filter.type {
            case .option:
                let filterOptionsViewController = FilterOptionsViewController(style: .grouped)
                filterOptionsViewController.filter = filter
                filterOptionsViewController.completionHandler = {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                self.navigationController?.pushViewController(filterOptionsViewController, animated: true)
            case .int, .float:
                self.beginSettingFilter(filter: filter) {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
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
