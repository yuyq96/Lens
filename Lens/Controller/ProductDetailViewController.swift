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
    
    var browseViewController: BrowseViewController!
    var needsRefresh = false
    var shadowConstraint: NSLayoutConstraint!
    
    var tab: Context.Tab!
    var category: Context.Category!
    var product: Product!
    
    var wishlistButton = [UIBarButtonItem]()
    var librariesButton = [UIBarButtonItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 设置NavigationBar阴影
        shadowConstraint = Shadow.add(to: self.tableView)
        
        // 设置NavigationBar按钮
        self.wishlistButton.append(UIBarButtonItem(image: UIImage(named: "wish")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addToWishlist)))
        self.wishlistButton.append(UIBarButtonItem(image: UIImage(named: "wish_s")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(removeFromWishlist)))
        self.librariesButton.append(UIBarButtonItem(image: UIImage(named: "inbox")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addToLibraries)))
        self.librariesButton.append(UIBarButtonItem(image: UIImage(named: "inbox_s")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(removeFromLibraries)))
        if user.libraries[category].contains(product.pid) {
            self.navigationItem.setRightBarButtonItems([self.librariesButton[1]], animated: false)
        } else if user.wishlist[category].contains(product.pid) {
            self.navigationItem.setRightBarButtonItems([self.wishlistButton[1], self.librariesButton[0]], animated: false)
        } else {
            self.navigationItem.setRightBarButtonItems([self.wishlistButton[0], self.librariesButton[0]], animated: false)
        }
        
        // 设置TableView风格
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.allowsSelection = false
        
        // 注册复用Cell
        tableView.register(UINib(nibName: "ProductDetailImageCell", bundle: nil), forCellReuseIdentifier: "ProductDetailImageCell")
        tableView.register(UINib(nibName: "ProductDetailBasicCell", bundle: nil), forCellReuseIdentifier: "ProductDetailBasicCell")
        tableView.register(UINib(nibName: "ProductDetailSampleCell", bundle: nil), forCellReuseIdentifier: "ProductDetailSampleCell")
        
//        if !self.product.loadDetail() {
//            self.refresh()
//        }
        self.product.loadDetail()
        self.refresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (tab! == .libraries || tab! == .wishlist) && self.needsRefresh {
            self.browseViewController.refresh()
        }
    }
    
    func refresh() {
        let parameters: Parameters = ["category": self.category.rawValue.lowercased(), "pid": self.product.pid]
        Alamofire.request(Server.productUrl, method: .post, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
            if let json = response.result.value as? [String : Any], let status = json["status"] as? String {
                if status == "success", let source = json["source"] as? [String : Any] {
                    var specs: [[String]]!
                    switch self.category! {
                    case .lenses:
                        let focal_range_min = source["focal_range_min"] as! Int
                        let focal_range_max = source["focal_range_max"] as! Int
                        var focal_range: String!
                        if focal_range_min == focal_range_max {
                            focal_range = "\(focal_range_min)"
                        } else {
                            focal_range = "\(focal_range_min) ~ \(focal_range_max)"
                        }
                        specs = [["Brand", "Mount Type", "Lens Type", "Lens Size", "Aperture", "Focal range (mm)"], [
                            source["brand"] as! String,
                            source["mount_type"] as! String,
                            source["lens_type"] as! String,
                            source["lens_size"] as! String,
                            "\(source["aperture_max"] as! Float)",
                            focal_range
                        ]]
                    case .cameras:
                        specs = [[], []]
                    case .accessories:
                        specs = [[], []]
                    }
                    self.product.setDetail(image: self.product.image, specs: specs, samples: ["http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/01_1920x1080.jpg", "http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/02_1920x1080.jpg", "http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/03_1920x1080.jpg", "http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/04_1920x1080.jpg"])
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                } else if status == "failure" {
                    print(json["error"]!)
                }
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.shadowConstraint.constant = self.tableView.contentOffset.y
    }
    
    @objc func addToLibraries(sender: UIBarButtonItem) {
        self.needsRefresh = true
        user.wishlist[category].remove(product.pid)
        user.libraries[category].append(product.pid)
        self.navigationItem.setRightBarButtonItems([self.librariesButton[1]], animated: true)
    }
    
    @objc func removeFromLibraries(sender: UIBarButtonItem) {
        self.needsRefresh = true
        user.libraries[category].remove(product.pid)
        self.navigationItem.setRightBarButtonItems([self.wishlistButton[0], self.librariesButton[0]], animated: true)
    }
    
    @objc func addToWishlist(sender: UIBarButtonItem) {
        self.needsRefresh = true
        user.wishlist[category].append(product.pid)
        self.navigationItem.setRightBarButtonItems([self.wishlistButton[1], self.librariesButton[0]], animated: true)
    }
    
    @objc func removeFromWishlist(sender: UIBarButtonItem) {
        self.needsRefresh = true
        user.wishlist[category].remove(product.pid)
        self.navigationItem.setRightBarButtonItems([self.wishlistButton[0], self.librariesButton[0]], animated: true)
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
            if let detail = product.detail {
                cell.productImage.kf.setImage(with: URL(string: detail.image))
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailBasicCell", for: indexPath) as! ProductDetailBasicCell
            cell.productName.text = product.name
            if let detail = product.detail {
                cell.productBasicInfo.text = detail.info
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailSampleCell", for: indexPath) as! ProductDetailSampleCell
            if let detail = product.detail {
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
            if let detail = product.detail {
                return 44 + CGFloat(detail.specs[0].count) * 16
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
