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
    var data: [Any] = []

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
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        // 注册复用Cell
        tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        tableView.register(UINib(nibName: "NewsImageCell", bundle: nil), forCellReuseIdentifier: "NewsImageCell")
        
        switch self.tab! {
        case .equipment:
            switch self.category! {
            case .lenses:
                let parameters: Parameters = ["category": "lenses"]
                Alamofire.request(Server.productUrl, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
//                    print(response.result.value ?? "no response result value")
                    if let json = response.result.value as? [String : Any], let status = json["status"] as? String {
                        if status == "success", let hits = json["hits"] as? [[String : Any]] {
                            for hit in hits {
                                if let source = hit["_source"] as? [String : Any] {
                                    self.data.append(Product(pid: hit["_id"] as! String, image: source["preview"] as! String, name: source["name"] as! String, tags: [source["mount_type"] as! String, "Full Frame"]))
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
        case .news:
            switch self.category! {
            case .lenses:
                let parameters: Parameters = ["category": "lenses"]
                Alamofire.request(Server.newsUrl, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
//                    print(response.result.value ?? "no response result value")
                    if let json = response.result.value as? [String : Any], let status = json["status"] as? String {
                        if status == "success", let hits = json["hits"] as? [[String : Any]] {
                            for hit in hits {
                                if let source = hit["_source"] as? [String : Any] {
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
            switch self.category! {
            case .lenses:
                for pid in user.libraries.lenses {
                    let parameters: Parameters = ["category": "lenses", "pid": pid]
                    Alamofire.request(Server.productUrl, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
//                        print(response.result.value ?? "no response result value")
                        if let json = response.result.value as? [String : Any], let status = json["status"] as? String {
                            if status == "success", let source = json["source"] as? [String : Any] {
                                self.data.append(Product(pid: pid, image: source["preview"] as! String, name: source["name"] as! String, tags: [source["mount_type"] as! String, "Full Frame"]))
                                OperationQueue.main.addOperation {
                                    self.tableView.reloadData()
                                }
                            } else if status == "failure" {
                                print(json["error"]!)
                            }
                        }
                    }
                }
            default: break
            }
        case .wishlist:
            switch self.category! {
            case .lenses:
                for pid in user.wishlist[.lenses] {
                    let parameters: Parameters = ["category": "lenses", "pid": pid]
                    Alamofire.request(Server.productUrl, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
//                        print(response.result.value ?? "no response result value")
                        if let json = response.result.value as? [String : Any], let status = json["status"] as? String {
                            if status == "success", let source = json["source"] as? [String : Any] {
                                self.data.append(Product(pid: pid, image: source["preview"] as! String, name: source["name"] as! String, tags: [source["mount_type"] as! String, "Full Frame"]))
                                OperationQueue.main.addOperation {
                                    self.tableView.reloadData()
                                }
                            } else if status == "failure" {
                                print(json["error"]!)
                            }
                        }
                    }
                }
            default: break
            }
        default: break
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.tab! {
        case .equipment, .libraries, .wishlist:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
            let product = data[indexPath.row] as! Product
            cell.productImage.kf.setImage(with: URL(string: (product.image)))
            cell.nameLabel.text = product.name
            cell.mountButton.setTitle(product.tags[0], for: .normal)
            cell.frameButton.setTitle(product.tags[1], for: .normal)
//            if self.tab == Context.Tab.equipment {
//                cell.mountButton.isEnabled = true
//                cell.frameButton.isEnabled = true
//            }
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
            productDetailTableViewController.data = data[indexPath.row] as! Product
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
