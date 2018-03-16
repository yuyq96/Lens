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
    
    var category: Context.Category!
    var equipmentCategory: Context.EquipmentCategory!
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
        self.shadowConstraint = Shadow.add(to: self.tableView, with: Color.gray)
        
        // 设置NavigationBar按钮
        self.wishlistButton.append(UIBarButtonItem(image: UIImage(named: "wish")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addToWishlist)))
        self.wishlistButton.append(UIBarButtonItem(image: UIImage(named: "wish_s")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(removeFromWishlist)))
        self.librariesButton.append(UIBarButtonItem(image: UIImage(named: "inbox")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addToLibraries)))
        self.librariesButton.append(UIBarButtonItem(image: UIImage(named: "inbox_s")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(removeFromLibraries)))
        if user.libraries[self.equipmentCategory].contains(product.pid) {
            self.navigationItem.setRightBarButtonItems([self.librariesButton[1]], animated: false)
        } else if user.wishlist[self.equipmentCategory].contains(product.pid) {
            self.navigationItem.setRightBarButtonItems([self.wishlistButton[1], self.librariesButton[0]], animated: false)
        } else {
            self.navigationItem.setRightBarButtonItems([self.wishlistButton[0], self.librariesButton[0]], animated: false)
        }
        
        // 设置TableView风格
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = .zero
        self.tableView.allowsSelection = false
        
        // 注册复用Cell
        self.tableView.register(ProductDetailImageCell.self, forCellReuseIdentifier: "ProductDetailImageCell")
        self.tableView.register(ProductDetailBasicCell.self, forCellReuseIdentifier: "ProductDetailBasicCell")
        self.tableView.register(ProductDetailSampleCell.self, forCellReuseIdentifier: "ProductDetailSampleCell")
        
//        if !self.product.loadDetail() {
//            self.refresh()
//        }
        self.product.loadDetail()
        self.refresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (self.category! == .library || self.category! == .wishlist) && self.needsRefresh {
            self.browseViewController.refresh()
        }
    }
    
    func boolText(_ bool: Bool) -> String {
        if bool {
            return NSLocalizedString("Yes", comment: "Yes")
        } else {
            return NSLocalizedString("No", comment: "No")
        }
    }
    
    func refresh() {
        let parameters: Parameters = ["category": self.equipmentCategory.rawValue.lowercased(), "pid": self.product.pid]
        Alamofire.request(Server.productUrl, method: .post, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
            if let json = response.result.value as? [String : Any], let status = json["status"] as? String {
                if status == "success", let source = json["source"] as? [String : Any] {
                    var specs: [KV]!
                    let dformatter = DateFormatter()
                    if getCurrentLanguage() == "cn" {
                        dformatter.dateFormat = "yyyy年MM月"
                    } else {
                        dformatter.dateFormat = "MMM. yyyy"
                    }
                    switch self.equipmentCategory! {
                    case .lenses:
                        let aperture_min = source["aperture_min"] as! Float
                        let aperture_max = source["aperture_max"] as! Float
                        var aperture: String!
                        if aperture_min == aperture_max {
                            aperture = "\(aperture_min)"
                        } else {
                            aperture = "\(aperture_min)-\(aperture_max)"
                        }
                        let focal_range_min = source["focal_range_min"] as! Int
                        let focal_range_max = source["focal_range_max"] as! Int
                        var focal_range: String!
                        if focal_range_min == focal_range_max {
                            focal_range = "\(focal_range_min)"
                        } else {
                            focal_range = "\(focal_range_min)-\(focal_range_max)"
                        }
                        var zoom_type = source["zoom_type"] as! String
                        if zoom_type == "/" {
                            zoom_type = ""
                        }
                        let timeInterval = TimeInterval(source["launch_date"] as! Int)
                        let date = Date(timeIntervalSince1970: timeInterval)
                        specs = [
                            KV(NSLocalizedString("Brand", comment: "Brand"), source["brand"] as! String),
                            KV(NSLocalizedString("Launch Date", comment: "Launch Date"), dformatter.string(from: date)),
                            KV(NSLocalizedString("Mount Type", comment: "Mount Type"), source["mount_type"] as! String),
                            KV(NSLocalizedString("Zoom Type", comment: "Zoom Type"), zoom_type),
                            KV(NSLocalizedString("Aperture", comment: "Aperture"), "f/ " + aperture),
                            KV(NSLocalizedString("Focal range(mm)", comment: "Focal range (mm)"), focal_range),
                            KV(NSLocalizedString("Filter diameter(mm)", comment: "Filter diameter (mm)"), "\(source["filter_diameter"] as! Float)"),
                            KV(NSLocalizedString("Max diameter(mm)", comment: "Max diameter (mm)"), "\(source["max_diameter"] as! Float)"),
                            KV(NSLocalizedString("Stabilization", comment: "Stabilization"), self.boolText(source["stabilization"] as! Bool)),
                            KV(NSLocalizedString("AF Motor", comment: "AF Motor"), source["af_motor"] as! String),
                            KV(NSLocalizedString("Rotating front element", comment: "Rotating front element"), self.boolText(source["rotating_front_element"] as! Bool)),
                            KV(NSLocalizedString("Tripod mount", comment: "Tripod mount"), self.boolText(source["tripod_mount"] as! Bool)),
                            KV(NSLocalizedString("Full-Time manual focus", comment: "Full-Time manual focus"), self.boolText(source["full-time_manual_focus"] as! Bool)),
                            KV(NSLocalizedString("Number of lenses", comment: "Number of lenses"), "\(source["number_of_lenses"] as! Int)"),
                            KV(NSLocalizedString("Number of groups", comment: "Number of groups"), "\(source["number_of_groups"] as! Int)"),
                            KV(NSLocalizedString("Diaphragm blades", comment: "Diaphragm blades"), "\(source["diaphragm_blades"] as! Int)"),
                            KV(NSLocalizedString("Circular aperture", comment: "Circular aperture"), self.boolText(source["circular_aperture"] as! Bool)),
                            KV(NSLocalizedString("Length(mm)", comment: "Length(mm)"), "\(source["length"] as! Float)"),
                            KV(NSLocalizedString("Weight(gr)", comment: "Weight(gr)"), "\(source["weight"] as! Float)"),
                            KV(NSLocalizedString("Color", comment: "Color"), source["color"] as! String)
                        ]
                    case .cameras:
                        let resolution = source["resolution"] as! [String : Any]
                        let sensor_size = source["sensor_size"] as! [String : Any]
                        let iso_latitude = source["iso_latitude"] as! [String : Any]
                        let timeInterval = TimeInterval(source["launch_date"] as! Int)
                        let date = Date(timeIntervalSince1970: timeInterval)
                        specs = [
                            KV(NSLocalizedString("Brand", comment: "Brand"), source["brand"] as! String),
                            KV(NSLocalizedString("Launch Date", comment: "Launch Date"), dformatter.string(from: date)),
                            KV(NSLocalizedString("Mount Type", comment: "Mount Type"), source["mount_type"] as! String),
                            KV(NSLocalizedString("Resolution", comment: "Resolution"), "\(resolution["width"] as! Int) x \(resolution["height"] as! Int)"),
                            KV(NSLocalizedString("Sensor Type", comment: "Sensor Type"), source["sensor_type"] as! String),
                            KV(NSLocalizedString("Sensor Size", comment: "Sensor Size"), "\(sensor_size["width"] as! Float) x \(sensor_size["height"] as! Float)"),
                            KV(NSLocalizedString("ISO latitude", comment: "ISO latitude"), "\(iso_latitude["min"] as! Int) - \(iso_latitude["max"] as! Int)"),
                            KV(NSLocalizedString("Bits per pixel", comment: "Bits per pixel"), "\(source["bits_per_pixel"] as! Float)")
                        ]
                    case .accessories:
                        specs = []
                    }
                    self.product.setDetail(image: source["image"] as! String, specs: specs, samples: ["http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/01_1920x1080.jpg", "http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/02_1920x1080.jpg", "http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/03_1920x1080.jpg", "http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/04_1920x1080.jpg"])
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
        user.wishlist[self.equipmentCategory].remove(product.pid)
        user.libraries[self.equipmentCategory].append(product.pid)
        self.navigationItem.setRightBarButtonItems([self.librariesButton[1]], animated: true)
    }
    
    @objc func removeFromLibraries(sender: UIBarButtonItem) {
        self.needsRefresh = true
        user.libraries[self.equipmentCategory].remove(product.pid)
        self.navigationItem.setRightBarButtonItems([self.wishlistButton[0], self.librariesButton[0]], animated: true)
    }
    
    @objc func addToWishlist(sender: UIBarButtonItem) {
        self.needsRefresh = true
        user.wishlist[self.equipmentCategory].append(product.pid)
        self.navigationItem.setRightBarButtonItems([self.wishlistButton[1], self.librariesButton[0]], animated: true)
    }
    
    @objc func removeFromWishlist(sender: UIBarButtonItem) {
        self.needsRefresh = true
        user.wishlist[self.equipmentCategory].remove(product.pid)
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
                cell.showScore(equipmentCategory: self.equipmentCategory, score: product.dxoScore)
                cell.productImage.kf.setImage(with: URL(string: detail.image))
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailBasicCell", for: indexPath) as! ProductDetailBasicCell
            cell.nameLabel.text = product.name
            if let detail = product.detail {
                cell.attribLabel.attributedText = detail.info
                cell.notifyTableView = {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailSampleCell", for: indexPath) as! ProductDetailSampleCell
            if let detail = product.detail {
                cell.samples = detail.samples
                cell.sampleTableView.reloadData()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 0: return 180
//        case 1:
//            if let detail = product.detail {
//                return 44 + CGFloat(detail.specs[0].count) * 17
//            }
//        case 2: return 138
//        default: return 44
//        }
//        return 44
//    }

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
