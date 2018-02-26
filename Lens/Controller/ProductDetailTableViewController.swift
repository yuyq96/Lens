//
//  ProductDetailTableViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class ProductDetailTableViewController: UITableViewController {
    
    let shadow = UIView()
    var shadowY: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 设置TableView风格
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.allowsSelection = false
        
        // 注册复用Cell
        tableView.register(UINib(nibName: "ProductDetailImageCell", bundle: nil), forCellReuseIdentifier: "ProductDetailImageCell")
        tableView.register(UINib(nibName: "ProductDetailBasicCell", bundle: nil), forCellReuseIdentifier: "ProductDetailBasicCell")
        tableView.register(UINib(nibName: "ProductDetailSampleCell", bundle: nil), forCellReuseIdentifier: "ProductDetailSampleCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 恢复导航栏阴影（1）
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 恢复导航栏阴影（2）
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailImageCell", for: indexPath)
            (cell as! ProductDetailImageCell).productImage.image = UIImage(named: "lens_image")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailBasicCell", for: indexPath)
            (cell as! ProductDetailBasicCell).productBasicInfo?.text = "Aperture: f/1.8\nFocal range (mm): 55\nFilter diameter (mm): 49\nMax diameter (mm): 64\nMount type: Sony FE\nStabilization: No\nAF Motor: Stepping motor\nLenses/Groups: 7/5\nDiaphragm blades: 9\nLength (mm): 71\nWeight (gr): 281"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailSampleCell", for: indexPath)
            for _ in 1...4 {
                (cell as! ProductDetailSampleCell).samples.append(UIImage(named: "sample")!)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 180
        case 1: return 42 + 11 * 16
        case 2: return 138
        default: return 44
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
