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

class BrowseViewController: TableViewController, IndicatorInfoProvider {
    
    var setFilterd: ((Bool) -> Void)?
    
    var header: MJRefreshNormalHeader!
    var footer: MJRefreshBackStateFooter?
//    var shadowConstraint: NSLayoutConstraint?
    
    var category: Context.Category!
    var equipmentCategory: Context.EquipmentCategory?
    var exploreCategory: Context.ExploreCategory?
    var keyword: String?
    var filters = [Filter]()
    var ids = [String]()
    var data = [Any?]()
    
    var filtered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 下拉刷新
        self.header = MJRefreshNormalHeader(refreshingBlock: {
            self.refresh()
        })
        self.header.lastUpdatedTimeKey = "\(self.category!.rawValue)_\(self.equipmentCategory?.rawValue ?? "all")"
        if getCurrentLanguage() == "en" {
            self.header.setTitle("PULL DOWN TO REFRESH", for: .idle)
            self.header.setTitle("RELEASE TO REFRESH", for: .pulling)
            self.header.setTitle("LOADING", for: .refreshing)
            self.header.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(date: self.header.lastUpdatedTime)
            self.header.lastUpdatedTimeText = { date in
                return self.lastUpdatedTimeText(date: date)
            }
            self.header.stateLabel.font = UIFont.systemFont(ofSize: 15)
            self.header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 14)
        }
        self.tableView.mj_header = self.header
        if self.category! == .equipment || self.category! == .explore {
            self.footer = MJRefreshBackStateFooter(refreshingBlock: {
                self.loadMore()
            })
            if getCurrentLanguage() == "en" {
                self.footer?.setTitle("PULL UP TO LOAD MORE", for: .idle)
                self.footer?.setTitle("RELEASE TO LOAD MORE", for: .pulling)
                self.footer?.setTitle("LOADING", for: .refreshing)
                self.footer?.setTitle("NO MORE DATA", for: .noMoreData)
                self.footer?.stateLabel.font = UIFont.systemFont(ofSize: 14)
            }
            self.tableView.mj_footer = self.footer
        }
        
        // 注册复用Cell
        self.tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        self.tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        self.tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        self.tableView.register(UINib(nibName: "NewsImageCell", bundle: nil), forCellReuseIdentifier: "NewsImageCell")
        
        switch self.category! {
        case .equipment:
            // 设置可选过滤方式
            switch self.equipmentCategory! {
            case .lenses:
                filters.append(Filter(name: NSLocalizedString("Brand", comment: "Brand"), attribName: "brand", include: ["Canon", "Carl Zeiss", "Fujifilm", "Kenko Tokina", "Konica Minolta", "Leica", "Lensbaby", "Lomography", "Mitakon", "Nikon", "Noktor", "Olympus", "Panasonic", "Pentax", "Ricoh", "Samyang", "Schneider Kreuznach", "Sigma", "Sony", "Tamron", "Tokina", "Voigtlander", "YI"]))
                filters.append(Filter(name: NSLocalizedString("Mount Type", comment: "Mount Type"), attribName: "mount_type", include: ["Canon EF", "Canon EF-M", "Canon EF-S", "Compact", "Composor Pro", "Four Thirds", "Fujifilm G", "Fujifilm X", "Leica M", "Leica S", "Leica T", "Mamiya 645 AF", "Nikon 1 CX", "Nikon F DX", "Nikon F FX", "Pentax KAF", "Pentax Q", "Samsung NX", "Samsung NX-M", "Sigma SA", "Sony Alpha", "Sony Alpha DT", "Sony E", "Sony FE"]))
                filters.append(Filter(name: NSLocalizedString("Zoom Type", comment: "Zoom Type"), attribName: "zoom_type", include: ["Zoom", "Prime"], jsonHandlers: [
                    {
                        return ["script": ["script": [
                            "source": "doc['focal_range_min'].value != doc['focal_range_max'].value",
                            "lang": "painless"
                            ]]]
                    },
                    {
                        return ["script": ["script": [
                            "source": "doc['focal_range_min'].value == doc['focal_range_max'].value",
                            "lang": "painless"
                            ]]]
                    }
                    ]))
                filters.append(Filter(name: NSLocalizedString("Lens Size", comment: "Lens Size"), attribName: "lens_size", include: ["Super Wide-angle", "Wide-angle", "Standard", "Telephoto", "Super Telephoto"], jsonHandlers: [
                    {return ["range": ["focal_range_min": ["lte": 20]]]},
                    {return ["range": ["focal_range_min": ["lte": 35]]]},
                    {return ["range": ["focal_range_min": ["lte": 85], "focal_range_max": ["gte": 35]]]},
                    {return ["range": ["focal_range_max": ["gte": 85]]]},
                    {return ["range": ["focal_range_max": ["gte": 180]]]}
                    ]))
                filters.append(Filter(name: NSLocalizedString("Focal Range", comment: "Focal Range"), attribName: "focal_range", min: 1, max: 1500))
                filters.append(Filter(name: NSLocalizedString("Aperture", comment: "Aperture"), attribName: "aperture", min: 0.95, max: 45))
            case .cameras:
                filters.append(Filter(name: NSLocalizedString("Brand", comment: "Brand"), attribName: "brand", include: ["Canon", "Casio", "DJI", "DxO", "GoPro", "Hasselblad", "Konica Minolta", "Fujifilm", "Leaf", "Leica", "Mamiya", "Nikon", "Nokia", "Olympus", "Panasonic", "Pentax", "Phase One", "Ricoh", "Samsung", "Sigma", "Sony", "YI", "YUNEEC"]))
                filters.append(Filter(name: NSLocalizedString("Mount Type", comment: "Mount Type"), attribName: "mount_type", include: ["Canon EF", "Canon EF-M", "Canon EF-S", "Compact", "Composor Pro", "Four Thirds", "Fujifilm G", "Fujifilm X", "Leica M", "Leica S", "Leica T", "Mamiya 645 AF", "Nikon 1 CX", "Nikon F DX", "Nikon F FX", "Pentax KAF", "Pentax Q", "Samsung NX", "Samsung NX-M", "Sigma SA", "Sony Alpha", "Sony Alpha DT", "Sony E", "Sony FE"]))
                filters.append(Filter(name: NSLocalizedString("Sensor Format", comment: "Sensor Format"), attribName: "sensor_format", include: ["Full Frame", "Medium Format", "APS-H", "APS-C", "4/3\"", "1\"", "2/3\"", "1/1.7\"", "1/2.3\""]))
                filters.append(Filter(name: NSLocalizedString("Resolution(M)", comment: "Resolution(M)"), attribName: "resolution", min: 1.0, max: 100.0, jsonHandler: { (min, max) in
                    return ["script": ["script": [
                        ["source": "doc['resolution.width'].value * doc['resolution.height'].value / 1000000 > \(min)", "lang": "painless"],
                        ["source": "doc['resolution.width'].value * doc['resolution.height'].value / 1000000 < \(max)", "lang": "painless"]
                        ]]]
                }))
            default:
                break
            }
        case .explore:
            switch self.exploreCategory! {
            case .articles, .reviews:
                self.tableView.separatorStyle = .none
            case .news:
                break
            }
        case .library, .wishlist:
//            self.shadowConstraint = Shadow.add(to: self.tableView)
            break
        }
        
        // 开始加载
        self.refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.category == .equipment {
            self.tableView.reloadData()
        }
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.shadowConstraint?.constant = self.tableView.contentOffset.y
//    }
    
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
        switch self.category! {
        case .equipment, .library, .wishlist:
            return IndicatorInfo(title: NSLocalizedString(self.equipmentCategory!.rawValue, comment: "second title"))
        case .explore:
            return IndicatorInfo(title: NSLocalizedString(self.exploreCategory!.rawValue, comment: "second title"))
        }
    }
    
    func refresh() {
        self.loadMore(from: 0)
    }
    
    func loadMore() {
        self.loadMore(from: self.data.count)
    }
    
    private func loadMore(from: Int) {
        switch self.category! {
        case .equipment:
            var parameters: Parameters = [
                "category": self.equipmentCategory!.rawValue.lowercased(),
                "keyword": keyword ?? "",
                "from": from
            ]
            var filtersJson = [Any]()
            for filter in self.filters {
                if let filterJson = filter.json {
                    filtersJson.append(contentsOf: filterJson)
                }
            }
            if filtersJson.count != 0 {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: ["bool": ["must": filtersJson]], options: [])
                    let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
                    parameters["filters"] = jsonString
                } catch { }
            }
            if filtersJson.count != 0 || (self.keyword != nil && self.keyword != "") {
                self.filtered = true
            } else {
                self.filtered = false
            }
            self.setFilterd?(self.filtered)
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
                                        switch self.equipmentCategory! {
                                        case .lenses:
                                            let product = Product(pid: pid, image: source["small_image"] as! String, name: source["name"] as! String, dxoScore: source["dxo_score"] as! Int, tags: [source["mount_type"] as! String])
                                            product.cache()
                                            data.append(product)
                                        case .cameras:
                                            let product = Product(pid: pid, image: source["small_image"] as! String, name: source["name"] as! String, dxoScore: source["dxo_score"] as! Int, tags: [source["mount_type"] as! String])
                                            product.cache()
                                            data.append(product)
                                        case .accessories:
                                            let product = Product(pid: pid, image: source["small_image"] as! String, name: source["name"] as! String, dxoScore: source["dxo_score"] as! Int, tags: [])
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
        case .explore:
            let parameters: Parameters = [
                "category": self.exploreCategory!.rawValue.lowercased(),
                "from": from
            ]
            Alamofire.request(Server.exploreUrl, method: .post, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
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
                                    data.append(News(title: source["title"] as! String, source: source["source"] as! String, timestamp: source["timestamp"] as! Int, content: source["content"] as? String, link: source["link"] as! String, image: source["image"] as! String))
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
                                var sections = IndexSet()
                                if self.exploreCategory == .news {
                                    for i in from..<(from + data.count) {
                                        rows.append(IndexPath(row: i, section: 0))
                                    }
                                } else {
                                    sections = IndexSet(integersIn: Range<IndexSet.Element>(NSRange(location: from, length: data.count))!)
                                }
                                OperationQueue.main.addOperation {
                                    self.ids.append(contentsOf: ids)
                                    self.data.append(contentsOf: data)
                                    self.tableView.insertSections(sections, with: .automatic)
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
            for pid in user[self.category!]![self.equipmentCategory!] {
                self.ids.append(pid)
                self.data.append(nil)
            }
            self.header.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.category == .explore && (self.exploreCategory == .articles || self.exploreCategory == .reviews) {
            return self.data.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.category == .explore && (self.exploreCategory == .articles || self.exploreCategory == .reviews) {
            return 1
        }
        return self.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.category! {
        case .equipment, .library, .wishlist:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
            // product已加载
            if let product = data[indexPath.row] as? Product {
                cell.productImage.kf.setImage(with: URL(string: (product.image)))
                cell.nameLabel.text = product.name
                cell.clearTags()
                for tag in product.tags {
                    cell.add(tag: tag)
                }
                if user.libraries[self.equipmentCategory!].contains(product.pid) {
                    cell.add(tag: "✓", tint: true)
//                    cell.add(tag: NSLocalizedString("In Library", comment: "In Library"), tint: true)
                } else if user.wishlist[self.equipmentCategory!].contains(product.pid) {
                    cell.add(tag: "♥︎", tint: true)
//                    cell.add(tag: NSLocalizedString("In Wishlist", comment: "In Wishlist"), tint: true)
                }
                cell.show(score: product.dxoScore)
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
                    let parameters: Parameters = ["category": self.equipmentCategory!.rawValue.lowercased(), "pid": id]
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
        case .explore:
            switch self.exploreCategory! {
            case .articles, .reviews:
                let news = data[indexPath.section] as! News
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
                cell.selectionStyle = .none
                cell.coverImageView.kf.setImage(with: URL(string: news.image))
                cell.titleLabel.text = news.title
                cell.sourceLabel.text = news.source
//                let timeInterval = TimeInterval(news.timestamp)
//                let date = Date(timeIntervalSince1970: timeInterval)
//                let dformatter = DateFormatter()
//                if getCurrentLanguage() == "cn" {
//                    dformatter.dateFormat = "YYYY年MM月dd日"
//                } else {
//                    dformatter.dateFormat = "YYYY MMM.dd"
//                }
                cell.timeLabel.text = news.time
                return cell
            case .news:
                let news = data[indexPath.row] as! News
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
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        switch self.category! {
        case .equipment, .library, .wishlist:
            let productDetailTableViewController = ProductDetailViewController()
            productDetailTableViewController.browseViewController = self
            productDetailTableViewController.product = data[indexPath.row] as! Product
            productDetailTableViewController.category = self.category
            productDetailTableViewController.equipmentCategory = self.equipmentCategory
            productDetailTableViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(productDetailTableViewController, animated: true)
        case .explore:
            var num = 0
            switch self.exploreCategory! {
            case .articles, .reviews:
                num = indexPath.section
            case .news:
                num = indexPath.row
            }
            let news = data[num] as! News
            let url = news.link
            if url != "" {
                let newsDetailViewController = WebViewController()
                newsDetailViewController.urlString = url
                newsDetailViewController.hidesBottomBarWhenPushed = true
                newsDetailViewController.title = news.source
                navigationController?.pushViewController(newsDetailViewController, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.category == .library || self.category == .wishlist {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.ids.remove(at: indexPath.row)
            self.data.remove(at: indexPath.row)
            switch self.category! {
            case .library:
                user.libraries[self.equipmentCategory!].remove(at: indexPath.row)
            case .wishlist:
                user.wishlist[self.equipmentCategory!].remove(at: indexPath.row)
            default: break
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let list = user[self.category]![self.equipmentCategory!]
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
        if self.category == .library || self.category == .wishlist {
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

