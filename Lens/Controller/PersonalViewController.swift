//
//  PersonalViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/25.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class PersonalViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        // 注册复用Cell
        tableView.register(UINib(nibName: "PersonalCell", bundle: nil), forCellReuseIdentifier: "PersonalCell")
        tableView.register(UINib(nibName: "PersonalUserCell", bundle: nil), forCellReuseIdentifier: "PersonalUserCell")
        tableView.register(UINib(nibName: "PersonalBudgetCell", bundle: nil), forCellReuseIdentifier: "PersonalBudgetCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 1
        case 1: return 3
        case 2: return 2
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalUserCell", for: indexPath) as! PersonalUserCell
            cell.username?.text = "Riach"
            cell.userid?.text = "@riach"
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalCell", for: indexPath)
                cell.textLabel?.text = Context.type.libraries
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalCell", for: indexPath)
                cell.textLabel?.text = Context.type.wishlist
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalBudgetCell", for: indexPath) as! PersonalBudgetCell
                cell.textLabel?.text = Context.type.budget
                cell.budget?.text = "****"
                return cell
            default:
                return UITableViewCell()
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalCell", for: indexPath)
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Settings"
            case 1:
                cell.textLabel?.text = "About"
            default:
                break
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 8
        } else {
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        switch indexPath.section {
        case 0:
            break
        case 1:
            switch indexPath.row {
            case 0:
                let librariesViewController = BrowsePagerTabStripViewController()
                librariesViewController.type = Context.type.libraries
                librariesViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(librariesViewController, animated: true)
            case 1:
                let wishlistViewController = BrowsePagerTabStripViewController()
                wishlistViewController.type = Context.type.wishlist
                wishlistViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(wishlistViewController, animated: true)
            default:
                break
            }
        default:
            break
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
