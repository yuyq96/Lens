//
//  BrowseTableViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/25.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BrowseTableViewController: UITableViewController, IndicatorInfoProvider {
    
    var type: String!
    var info: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        // 注册复用Cell
        tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        tableView.register(UINib(nibName: "PictureNewsCell", bundle: nil), forCellReuseIdentifier: "PictureNewsCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        // 设置选项卡标题
        return IndicatorInfo(title: info)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if type == "News" {
            cell = tableView.dequeueReusableCell(withIdentifier: "PictureNewsCell")!
            (cell as! PictureNewsCell).newsImage?.image = UIImage(named: "userhead")
            (cell as! PictureNewsCell).newsTitle?.text = "Sigma 14-24mm F2.8 DG HSM Art"
            (cell as! PictureNewsCell).newsInfo?.text = "dpreview    Feb.23 2018"
            (cell as! PictureNewsCell).newsContent?.text = "When Sigma announced the 14-24mm F2.8 DG HSM Art lens, the company held off on sharing pricing or availability. Fortunately, Sigma didn't make us wait long, revealing today that the ultra-wide angle zoom will ship in mid-March for the very reasonable price of $1,300."
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell")!
            (cell as! ProductCell).productImage?.image = UIImage(named: "userhead")
            (cell as! ProductCell).productName?.text = "Sigma 85mm F1.4 DG HSM A Nikon"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case "Equipment":
            navigationController?.pushViewController(ProductDetailTableViewController(), animated: true)
        case "News":
            let newsDetailViewController = NewsDetailViewController()
            newsDetailViewController.urlString = "https://www.dpreview.com/"
            navigationController?.pushViewController(newsDetailViewController, animated: true)
        default:
            return
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
