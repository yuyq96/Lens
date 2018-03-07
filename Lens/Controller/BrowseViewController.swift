//
//  BrowseViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/25.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import XLPagerTabStrip

class BrowseViewController: UITableViewController, IndicatorInfoProvider {
    
    var tab: Context.Tab!
    var category: Context.Category!
    var keyword: String?
    var filters = [Filter]()
    var ids = [String]()
    var data: [Any?]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        // 注册复用Cell
        self.tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        self.tableView.register(UINib(nibName: "NewsImageCell", bundle: nil), forCellReuseIdentifier: "NewsImageCell")
        
        switch self.category! {
        case .lenses:
            filters.append(Filter(name: "Brand", include: ["Canon", "Carl Zeiss", "Fujifilm", "Kenko Tokina", "Konica Minolta", "Leica", "Lensbaby", "Lomography", "Mitakon", "Nikon", "Noktor", "Olympus", "Panasonic", "Pentax", "Ricoh", "Samyung", "Schneider Kreuznach", "Sigma", "Sony", "Tamron", "Tokina", "Voigtlander", "YI"]))
            filters.append(Filter(name: "Mount Type", include: ["Canon EF", "Canon EF-M", "Canon EF-S", "Compact", "Composor Pro", "Four Thirds", "Fujifilm G", "Fujifilm X", "Leica M", "Leica S", "Leica T", "Mamiya 645 AF", "Nikon 1 CX", "Nikon F DX", "Nikon F FX", "Pentax KAF", "Pentax Q", "Samsung NX", "Samsung NX-M", "Sigma SA", "Sony Alpha", "Sony Alpha DT", "Sony E", "Sony FE"]))
            filters.append(Filter(name: "Lens Type", include: ["Zoom", "Prime"]))
            filters.append(Filter(name: "Lens Size", include: ["super wide-angle", "wide-angle", "standard", "telephoto", "super telephoto"]))
            filters.append(Filter(name: "Focal Range", from: 1, to: 1500))
            filters.append(Filter(name: "Aperture", from: 0.95, to: 45))
        case .cameras:
            filters.append(Filter(name: "Brand", include: ["Canon", "Casio", "DJI", "DxO", "GoPro", "Hasselblad", "Konica Minolta", "Fujifilm", "Leaf", "Leica", "Mamiya", "Nikon", "Nokia", "Olympus", "Panasonic", "Pentax", "Phase One", "Ricoh", "Samsung", "Sigma", "Sony", "YI", "YUNEEC"]))
            filters.append(Filter(name: "Mount Type", include: ["Canon EF", "Canon EF-M", "Canon EF-S", "Compact", "Composor Pro", "Four Thirds", "Fujifilm G", "Fujifilm X", "Leica M", "Leica S", "Leica T", "Mamiya 645 AF", "Nikon 1 CX", "Nikon F DX", "Nikon F FX", "Pentax KAF", "Pentax Q", "Samsung NX", "Samsung NX-M", "Sigma SA", "Sony Alpha", "Sony Alpha DT", "Sony E", "Sony FE"]))
            filters.append(Filter(name: "Sensor Format", include: ["Full Frame", "Medium Format", "APS-H", "APS-C", "4/3\"", "1\"", "2/3\"", "1/1.7\"", "1/2.3\""]))
            filters.append(Filter(name: "Lens Size", include: ["super wide-angle", "wide-angle", "standard", "telephoto", "super telephoto"]))
            filters.append(Filter(name: "Resolution(M)", from: 1.0, to: 100.0))
        default:
            break
        }
        
        self.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        // 设置选项卡标题
        return IndicatorInfo(title: self.category.rawValue)
    }
    
    func refresh() {
        self.ids = []
        self.data = []
        switch self.tab! {
        case .equipment:
            var parameters: Parameters = ["category": self.category.rawValue.lowercased()]
            if keyword != nil {
                parameters["keyword"] = keyword!
            }
            var filtersJson: [String : [String : [Any]]]?
            for filter in self.filters {
                if let filterJson = filter.json {
                    if filtersJson == nil {
                        filtersJson = ["bool": ["must": []]]
                    }
                    filtersJson!["bool"]!["must"]!.append(filterJson)
                }
            }
            if filtersJson != nil {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: filtersJson!, options: [])
                    let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
                    parameters["filters"] = jsonString
                } catch { }
            }
            Alamofire.request(Server.productUrl, method: .post, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
                if let json = response.result.value as? [String : Any], let status = json["status"] as? String {
                    if status == "success", let hits = json["hits"] as? [[String : Any]] {
                        for hit in hits {
                            if let pid = hit["_id"] as? String {
                                self.ids.append(pid)
                                if let source = hit["_source"] as? [String : Any] {
                                    switch self.category! {
                                    case .lenses:
                                        let product = Product(pid: pid, image: source["preview"] as! String, name: source["name"] as! String, tags: [source["mount_type"] as! String])
                                        product.cache()
                                        self.data.append(product)
                                    case .cameras:
                                        let product = Product(pid: pid, image: source["preview"] as! String, name: source["name"] as! String, tags: [source["mount_type"] as! String])
                                        product.cache()
                                        self.data.append(product)
                                    case .accessories:
                                        let product = Product(pid: pid, image: source["preview"] as! String, name: source["name"] as! String, tags: [])
                                        product.cache()
                                        self.data.append(product)
                                    }
                                    
                                }
                            }
                        }
                        OperationQueue.main.addOperation {
                            self.tableView.reloadData()
                        }
                    } else if status == "failure" {
                        print(json["error"]!)
                    }
                }
            }
        case .news:
            switch self.category! {
            case .lenses:
                let parameters: Parameters = ["category": self.category.rawValue.lowercased()]
                Alamofire.request(Server.newsUrl, method: .post, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
                    if let json = response.result.value as? [String : Any], let status = json["status"] as? String {
                        if status == "success", let hits = json["hits"] as? [[String : Any]] {
                            for hit in hits {
                                if let source = hit["_source"] as? [String : Any] {
                                    self.ids.append("")
                                    self.data.append(News(title: source["title"] as! String, source: source["source"] as! String, timestamp: source["timestamp"] as! String, content: source["content"] as! String, link: source["link"] as! String, image: source["image"] as! String))
                                }
                            }
                            OperationQueue.main.addOperation {
                                self.tableView.reloadData()
                            }
                        } else if status == "failure" {
                            print(json["error"]!)
                        }
                    }
                }
            default: break
            }
        case .libraries:
            for pid in user.libraries[self.category!] {
                self.ids.append(pid)
                self.data.append(nil)
            }
            self.tableView.reloadData()
        case .wishlist:
            for pid in user.wishlist[self.category!] {
                self.ids.append(pid)
                self.data.append(nil)
            }
            self.tableView.reloadData()
        default: break
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ids.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.tab! {
        case .equipment, .libraries, .wishlist:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
            // product已加载
            if let product = data[indexPath.row] as? Product {
                cell.productImage.kf.setImage(with: URL(string: (product.image)))
                cell.nameLabel.text = product.name
                cell.tagButton.setTitle(product.tags[0], for: .normal)
                if self.tab == Context.Tab.equipment {
                    cell.tagButton.isEnabled = true
                }
            } else {
                // product未加载
                let id = self.ids[indexPath.row]
                // 尝试从缓存中加载
                if !Product.load(pid: id, completion: { product in
                    self.data[indexPath.row] = product
                    OperationQueue.main.addOperation {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }) {
                    // 缓存加载失败，从服务器获取并缓存
                    let parameters: Parameters = ["category": self.category.rawValue.lowercased(), "pid": id]
                    Alamofire.request(Server.productUrl, method: .post, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
                        if let json = response.result.value as? [String : Any], let status = json["status"] as? String {
                            if status == "success", let source = json["source"] as? [String : Any] {
                                let product = Product(pid: id, image: source["preview"] as! String, name: source["name"] as! String, tags: [source["mount_type"] as! String])
                                product.cache()
                                self.data[indexPath.row] = product
                                OperationQueue.main.addOperation {
                                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                            } else if status == "failure" {
                                print(json["error"]!)
                            }
                        }
                    }
                }
            }
            return cell
        case .news:
            if let news = data[indexPath.row] as? News {
                if news.image != "" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell", for: indexPath) as! NewsImageCell
                    cell.picture.kf.setImage(with: URL(string: news.image))
                    cell.title.text = news.title
                    cell.info.text = news.info
                    cell.content.text = news.content
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
                    cell.title.text = news.title
                    cell.info.text = news.info
                    cell.content.text = news.content
                    return cell
                }
            }
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        switch self.tab! {
        case .equipment, .libraries, .wishlist:
            let productDetailTableViewController = ProductDetailViewController()
            productDetailTableViewController.browseViewController = self
            productDetailTableViewController.product = data[indexPath.row] as! Product
            productDetailTableViewController.tab = self.tab
            productDetailTableViewController.category = self.category
            productDetailTableViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(productDetailTableViewController, animated: true)
        case .news:
            let url = (data[indexPath.row] as! News).link
            if url != "" {
                let newsDetailViewController = WebViewController()
                newsDetailViewController.urlString = url
                newsDetailViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(newsDetailViewController, animated: true)
            }
        default:
            return
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tab == Context.Tab.libraries || tab == Context.Tab.wishlist {
            return true
        }
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ids.remove(at: indexPath.row)
            data.remove(at: indexPath.row)
            switch self.tab! {
            case .libraries:
                user.libraries[self.category].remove(at: indexPath.row)
            case .wishlist:
                user.wishlist[self.category].remove(at: indexPath.row)
            default: break
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

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
