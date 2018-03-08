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
import MJRefresh
import XLPagerTabStrip

class BrowseViewController: UITableViewController, IndicatorInfoProvider {
    
    var header: MJRefreshNormalHeader!
    var footer: MJRefreshBackStateFooter?
    
    var tab: Context.Tab!
    var category: Context.Category!
    var keyword: String?
    var filters = [Filter]()
    var ids = [String]()
    var data = [Any?]()

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
        
        // 下拉刷新
        self.header = MJRefreshNormalHeader(refreshingBlock: {
            self.refresh()
        })
        self.header.lastUpdatedTimeKey = "\(self.tab!.rawValue)_\(self.category!.rawValue)"
        self.header.setTitle("PULL DOWN TO REFRESH", for: .idle)
        self.header.setTitle("RELEASE TO REFRESH", for: .pulling)
        self.header.setTitle("LOADING", for: .refreshing)
        self.header.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(date: self.header.lastUpdatedTime)
        self.header.lastUpdatedTimeText = { date in
            return self.lastUpdatedTimeText(date: date)
        }
        self.header.stateLabel.font = UIFont.systemFont(ofSize: 15)
        self.header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 14)
        self.tableView.mj_header = self.header
        if self.tab! == .equipment || self.tab! == .news {
            self.footer = MJRefreshBackStateFooter(refreshingBlock: {
                self.loadMore()
            })
            self.footer?.setTitle("PULL UP TO LOAD MORE", for: .idle)
            self.footer?.setTitle("RELEASE TO LOAD MORE", for: .pulling)
            self.footer?.setTitle("LOADING", for: .refreshing)
            self.footer?.setTitle("NO MORE DATA", for: .noMoreData)
            self.footer?.stateLabel.font = UIFont.systemFont(ofSize: 14)
            self.tableView.mj_footer = self.footer
        }
        
        // 注册复用Cell
        self.tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        self.tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        self.tableView.register(UINib(nibName: "NewsImageCell", bundle: nil), forCellReuseIdentifier: "NewsImageCell")
        
        switch self.category! {
        case .lenses:
            filters.append(Filter(name: "Brand", include: ["Canon", "Carl Zeiss", "Fujifilm", "Kenko Tokina", "Konica Minolta", "Leica", "Lensbaby", "Lomography", "Mitakon", "Nikon", "Noktor", "Olympus", "Panasonic", "Pentax", "Ricoh", "Samyang", "Schneider Kreuznach", "Sigma", "Sony", "Tamron", "Tokina", "Voigtlander", "YI"]))
            filters.append(Filter(name: "Mount Type", include: ["Canon EF", "Canon EF-M", "Canon EF-S", "Compact", "Composor Pro", "Four Thirds", "Fujifilm G", "Fujifilm X", "Leica M", "Leica S", "Leica T", "Mamiya 645 AF", "Nikon 1 CX", "Nikon F DX", "Nikon F FX", "Pentax KAF", "Pentax Q", "Samsung NX", "Samsung NX-M", "Sigma SA", "Sony Alpha", "Sony Alpha DT", "Sony E", "Sony FE"]))
            filters.append(Filter(name: "Zoom Type", include: ["Zoom", "Prime"]))
            filters.append(Filter(name: "Lens Size", include: ["Super Wide-angle", "Wide-angle", "Wtandard", "Telephoto", "Tuper Telephoto"]))
            filters.append(Filter(name: "Focal Range", min: 1, max: 1500))
            filters.append(Filter(name: "Aperture", min: 0.95, max: 45))
        case .cameras:
            filters.append(Filter(name: "Brand", include: ["Canon", "Casio", "DJI", "DxO", "GoPro", "Hasselblad", "Konica Minolta", "Fujifilm", "Leaf", "Leica", "Mamiya", "Nikon", "Nokia", "Olympus", "Panasonic", "Pentax", "Phase One", "Ricoh", "Samsung", "Sigma", "Sony", "YI", "YUNEEC"]))
            filters.append(Filter(name: "Mount Type", include: ["Canon EF", "Canon EF-M", "Canon EF-S", "Compact", "Composor Pro", "Four Thirds", "Fujifilm G", "Fujifilm X", "Leica M", "Leica S", "Leica T", "Mamiya 645 AF", "Nikon 1 CX", "Nikon F DX", "Nikon F FX", "Pentax KAF", "Pentax Q", "Samsung NX", "Samsung NX-M", "Sigma SA", "Sony Alpha", "Sony Alpha DT", "Sony E", "Sony FE"]))
            filters.append(Filter(name: "Sensor Format", include: ["Full Frame", "Medium Format", "APS-H", "APS-C", "4/3\"", "1\"", "2/3\"", "1/1.7\"", "1/2.3\""]))
            filters.append(Filter(name: "Resolution(M)", min: 1.0, max: 100.0))
        default:
            break
        }
        
        // 开始加载
        switch self.tab! {
        case .equipment, .news:
            self.tableView.mj_header.beginRefreshing()
        default:
            self.refresh()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func lastUpdatedTimeText(date: Date?) -> String {
        if date == nil {
            return "Last Updated: No record"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            return "Last Updated: \(dateFormatter.string(from: date!)) \(timeFormatter.string(from: date!))"
        }
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
        self.loadMore(from: 0)
    }
    
    func loadMore() {
        self.loadMore(from: self.data.count)
    }
    
    private func loadMore(from: Int) {
        switch self.tab! {
        case .equipment:
            var parameters: Parameters = [
                "category": self.category.rawValue.lowercased(),
                "keyword": keyword ?? "",
                "from": from
            ]
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
                self.header.endRefreshing()
                if let json = response.result.value as? [String : Any], let status = json["status"] as? String {
                    if status == "success", let hits = json["hits"] as? [[String : Any]] {
                        if hits.count == 0 {
                            self.footer?.endRefreshingWithNoMoreData()
                            if from == 0 {
                                OperationQueue.main.addOperation {
                                    self.header.endRefreshing()
                                    self.ids.removeAll()
                                    self.data.removeAll()
                                    self.tableView.reloadData()
                                }
                            }
                        } else {
                            var ids = [String]()
                            var data = [Any?]()
                            for hit in hits {
                                if let pid = hit["_id"] as? String {
                                    ids.append(pid)
                                    if let source = hit["_source"] as? [String : Any] {
                                        switch self.category! {
                                        case .lenses:
                                            let product = Product(pid: pid, image: source["small_image"] as! String, name: source["name"] as! String, dxoScore: source["dxo_score"] as! Int, tags: [source["mount_type"] as! String])
                                            product.cache()
                                            data.append(product)
                                        case .cameras:
                                            let product = Product(pid: pid, image: source["preview"] as! String, name: source["name"] as! String, dxoScore: source["dxo_score"] as! Int, tags: [source["mount_type"] as! String])
                                            product.cache()
                                            data.append(product)
                                        case .accessories:
                                            let product = Product(pid: pid, image: source["preview"] as! String, name: source["name"] as! String, dxoScore: source["dxo_score"] as! Int, tags: [])
                                            product.cache()
                                            data.append(product)
                                        }
                                        
                                    }
                                }
                            }
                            if from == 0 {
                                OperationQueue.main.addOperation {
                                    self.ids = ids
                                    self.data = data
                                    self.tableView.reloadData()
                                }
                            } else {
                                var rows = [IndexPath]()
                                for i in from..<(from + data.count) {
                                    rows.append(IndexPath(row: i, section: 0))
                                }
                                OperationQueue.main.addOperation {
                                    self.ids.append(contentsOf: ids)
                                    self.data.append(contentsOf: data)
                                    self.tableView.insertRows(at: rows, with: .automatic)
                                }
                            }
                            self.footer?.endRefreshing()
                        }
                    } else if status == "failure" {
                        print(json["error"]!)
                        self.footer?.endRefreshing()
                    }
                }
            }
        case .news:
            let parameters: Parameters = [
                "category": self.category.rawValue.lowercased(),
                "from": from
            ]
            Alamofire.request(Server.newsUrl, method: .post, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
                self.header.endRefreshing()
                if let json = response.result.value as? [String : Any], let status = json["status"] as? String {
                    if status == "success", let hits = json["hits"] as? [[String : Any]] {
                        if hits.count == 0 {
                            self.footer?.endRefreshingWithNoMoreData()
                            if from == 0 {
                                OperationQueue.main.addOperation {
                                    self.header.endRefreshing()
                                    self.ids.removeAll()
                                    self.data.removeAll()
                                    self.tableView.reloadData()
                                }
                            }
                        } else {
                            var ids = [String]()
                            var data = [Any?]()
                            for hit in hits {
                                if let source = hit["_source"] as? [String : Any] {
                                    ids.append("")
                                    data.append(News(title: source["title"] as! String, source: source["source"] as! String, timestamp: source["timestamp"] as! String, content: source["content"] as! String, link: source["link"] as! String, image: source["image"] as! String))
                                }
                            }
                            if from == 0 {
                                OperationQueue.main.addOperation {
                                    self.ids = ids
                                    self.data = data
                                    self.tableView.reloadData()
                                }
                            } else {
                                var rows = [IndexPath]()
                                for i in from..<(from + data.count) {
                                    rows.append(IndexPath(row: i, section: 0))
                                }
                                OperationQueue.main.addOperation {
                                    self.ids.append(contentsOf: ids)
                                    self.data.append(contentsOf: data)
                                    self.tableView.insertRows(at: rows, with: .automatic)
                                }
                            }
                            self.footer?.endRefreshing()
                        }
                    } else if status == "failure" {
                        print(json["error"]!)
                        self.footer?.endRefreshing()
                    }
                }
            }
        case .library, .wishlist:
            self.ids.removeAll()
            self.data.removeAll()
            for pid in user[self.tab!]![self.category!] {
                self.ids.append(pid)
                self.data.append(nil)
            }
            self.header.endRefreshing()
            self.tableView.reloadData()
        default: break
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.tab! {
        case .equipment, .library, .wishlist:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
            // product已加载
            if let product = data[indexPath.row] as? Product {
                cell.productImage.kf.setImage(with: URL(string: (product.image)))
                cell.nameLabel.text = product.name
                cell.clearTags()
                cell.add(tag: product.tags[0])
                if user.libraries[self.category].contains(product.pid) {
                    cell.add(tag: "Library", tint: true)
                } else if user.wishlist[self.category].contains(product.pid) {
                    cell.add(tag: "Wishlist", tint: true)
                }
                cell.show(score: product.dxoScore)
//                if self.tab == Context.Tab.equipment {
//                    cell.tagButton.isEnabled = true
//                }
            } else {
                // product未加载(Libraries/Wishlist)
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
                                let product = Product(pid: id, image: source["small_image"] as! String, name: source["name"] as! String, dxoScore: source["dxo_score"] as! Int, tags: [source["mount_type"] as! String])
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
        case .equipment, .library, .wishlist:
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
        if self.tab == .library || self.tab == .wishlist {
            return true
        }
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.ids.remove(at: indexPath.row)
            self.data.remove(at: indexPath.row)
            switch self.tab! {
            case .library:
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

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let list = user[self.tab]![self.category]
        let fromRow = fromIndexPath.row
        let toRow = to.row
        let tempId = self.ids[fromRow]
        let tempData = self.data[fromRow]
        let temp = list[fromRow]
        if fromRow < toRow {
            for i in fromRow..<toRow {
                list[i] = list[i + 1]
                self.ids[i] = self.ids[i + 1]
                self.data[i] = self.data[i + 1]
            }
        } else {
            for i in (toRow..<fromRow).reversed() {
                list[i + 1] = list[i]
                self.ids[i + 1] = self.ids[i]
                self.data[i + 1] = self.data[i]
            }
        }
        self.ids[toRow] = tempId
        self.data[toRow] = tempData
        list[toRow] = temp
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if tab == .library || tab == .wishlist {
            return true
        }
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
