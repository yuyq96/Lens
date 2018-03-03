//
//  ProductDetailViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ProductDetailViewController: UITableViewController {
    
    var shadowConstraint: NSLayoutConstraint!
    
    var category: String!
    var data: ProductModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 设置NavigationBar阴影
        shadowConstraint = Shadow.add(to: self.tableView)
        
        // 设置TableView风格
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.allowsSelection = false
        
        // 注册复用Cell
        tableView.register(UINib(nibName: "ProductDetailImageCell", bundle: nil), forCellReuseIdentifier: "ProductDetailImageCell")
        tableView.register(UINib(nibName: "ProductDetailBasicCell", bundle: nil), forCellReuseIdentifier: "ProductDetailBasicCell")
        tableView.register(UINib(nibName: "ProductDetailSampleCell", bundle: nil), forCellReuseIdentifier: "ProductDetailSampleCell")
        
        if self.data.detail == nil {
            let parameters: Parameters = ["category": self.category.lowercased(), "pid": self.data.pid]
            Alamofire.request(Server.productUrl, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
//                print(response.result.value ?? "no response result value")
                if let json = response.result.value as? [String : Any], let status = json["status"] as? String {
                    if status == "success", let source = json["source"] as? [String : Any] {
                        self.data.setDetail(image: "https://cdn.dxomark.com/wp-content/uploads/2017/09/Sony-Zeiss-Sonnar-T-FE-55mm-f1.8-ZA-lens-review-Exemplary-performance.jpg", specs: ["Aperture": "\(source["aperture_max"] as! Float)"], samples: ["http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/01_1920x1080.jpg", "http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/02_1920x1080.jpg", "http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/03_1920x1080.jpg", "http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/04_1920x1080.jpg"])
                        OperationQueue.main.addOperation {
                            self.tableView.reloadData()
                        }
                    } else if status == "failure" {
                        print(json["error"]!)
                    }
                }
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.shadowConstraint.constant = self.tableView.contentOffset.y
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailImageCell", for: indexPath) as! ProductDetailImageCell
            if let detail = data.detail {
                cell.productImage.kf.setImage(with: URL(string: detail.image))
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailBasicCell", for: indexPath) as! ProductDetailBasicCell
            cell.productName.text = data.name
            if let detail = data.detail {
                cell.productBasicInfo.text = detail.info
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailSampleCell", for: indexPath) as! ProductDetailSampleCell
            if let detail = data.detail {
                cell.samples = detail.samples
                cell.productSample.reloadData()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 180
        case 1:
            if let detail = data.detail {
                return 44 + CGFloat(detail.specs.count) * 16
            }
        case 2: return 138
        default: return 44
        }
        return 44
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
