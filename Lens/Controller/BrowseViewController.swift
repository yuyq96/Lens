//
//  BrowseViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/25.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Kingfisher

class BrowseViewController: UITableViewController, IndicatorInfoProvider {
    
    var tab: String!
    var category: String!
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
        
        switch tab {
        case Context.Tab.equipment:
            switch category {
            case Context.Category.lens:
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Sigma_85mm_F14_DG_HSM_A_Nikon/Marketing_PV/Sigma_85mm_F14_DG_HSM_A_Nikon.png", name: "Sigma 85mm F1.4 DG HSM A Nikon", tags: ["Nikon F", "Full"]))
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Zeiss_Carl_Zeiss_Distagon_T_STAR_Otus_55mm_F14_ZF2_Nikon/Marketing_PV/Zeiss_Carl_Zeiss_Distagon_T_STAR_Otus_55mm_F14_ZF2_Nikon.png", name: "Carl Zeiss Distagon T* Otus 1.4/55 ZF.2 Nikon", tags: ["Nikon F", "Full"]))
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Zeiss_Carl_Zeiss_Apo_Planar_T_Star_Otus_85mm_F14_ZF2_Nikon/Marketing_PV/Zeiss_Carl_Zeiss_Apo_Planar_T_Star_Otus_85mm_F14_ZF2_Nikon.png", name: "Carl Zeiss Distagon T* Otus 1.4/85 ZF.2 Nikon", tags: ["Nikon F", "Full"]))
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Sony_FE_85mm_F14_GM/Marketing_PV/Sony_FE_85mm_F14_GM.png", name: "Sony FE 85mm F1.4 GM", tags: ["Sony E", "Full"]))
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Sony_FE_Carl_Zeiss_Sonnar_T_STAR_55mm_F18/Marketing_PV/Sony_FE_Carl_Zeiss_Sonnar_T_STAR_55mm_F18.png", name: "Sony FE Carl Zeiss Sonnar T* 55mm F1.8 ZA", tags: ["Sony E", "Full"]))
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Zeiss_Carl_Zeiss_Apo_Sonnar_T_Star_F2_135_ZE_Canon/Marketing_PV/Zeiss_Carl_Zeiss_Apo_Sonnar_T_Star_F2_135_ZE_Canon.png", name: "Carl Zeiss Apo Sonnar T* 2/135 ZE Canon", tags: ["Canon EF", "Full"]))
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Zeiss_Carl_Zeiss_Milvus_F14_85mm_ZF2_Nikon/Marketing_PV/Zeiss_Carl_Zeiss_Milvus_F14_85mm_ZF2_Nikon.png", name: "Carl Zeiss Milvus 1.4/85 ZF.2 Nikon", tags: ["Nikon F", "Full"]))
            default: break
            }
        case Context.Tab.news:
            switch category {
            case Context.Category.lens:
                data.append(NewsModel(title: "Sigma 14-24mm F2.8 DG HSM Art", info: "dpreview    Feb.23 2018", content: "Sigma announced pricing and availability for its much-anticipated 14-24mm F2.8 Art lens today, revealing that the ultra-wide zoom will begin shipping mid-March for $1,300 USD.", url: "https://www.dpreview.com/news/0958339925/tokina-unveils-firin-20mm-f2-0-fe-af-autofocus-lens-for-sony-e-mount", image: "https://3.img-dpreview.com/files/p/E~C0x0S2756x2067T200x150~articles/1496020316/pphoto_14_24_28_a018_l_02__1_.jpeg"))
                data.append(NewsModel(title: "Tokina unveils the FíRIN 20mm F2.0 FE AF", info: "dpreview    Feb.22 2018", content: "The Tokina FíRIN 20mm F2 FE AF is a followup to the MF version released in 2016, which adds (you guessed it) autofocus capabilities. Optically, the two lenses are identical.", url: "https://www.dpreview.com/news/0958339925/tokina-unveils-firin-20mm-f2-0-fe-af-autofocus-lens-for-sony-e-mount", image: "https://2.img-dpreview.com/files/p/E~C73x0S444x333T200x150~articles/0958339925/firin20af_1.jpeg"))
                data.append(NewsModel(title: "Leaked: Tokina to announce Opera 50mm F1.4 FF and FíRIN 20mm F2 FE AF lenses", info: "dpreview    Feb.22 2018", content: "The Opera 50mm F1.4 FF is a full-frame lens for Nikon and Canon mounts, while the FíRIN 20mm F2 FE AF for Sony E-Mount replaces the FíRIN 20mm F2 FE MF announced in September of 2016.", url: "https://www.dpreview.com/news/8292208188/leaked-tokina-to-announce-opera-50mm-f1-4-ff-and-firin-20mm-f2-fe-af-lenses", image: "https://2.img-dpreview.com/files/p/E~C0x0S1145x859T200x150~articles/8292208188/tokina_43.jpeg"))
                data.append(NewsModel(title: "Tamron announces 70-210mm F4 Di VC USD for full-frame DSLRs", info: "dpreview    Feb.22 2018", content: "Tamron has announced a full-frame 70-210mm F4 tele-zoom, boasting moisture-resistance, a minimum focus distance of 0.95m/37.4in and up to 5 stops of stabilization – all for $800.", url: "https://www.dpreview.com/news/1546610009/tamron-announces-70-210mm-f4-di-vc-usd-for-full-frame-dslrs", image: "https://1.img-dpreview.com/files/p/E~C0x150S1200x900T200x150~articles/1546610009/tamron_70_210mm_f4.jpeg"))
                data.append(NewsModel(title: "Tamron is working on a 28-75mm F2.8 lens for full-frame Sony mirrorless cameras", info: "dpreview    Feb.22 2018", content: "Details are thin at this point, but the 28-75mm F2.8 Di III RXD will offer \"superb optical performance\" and a moisture-resistant construction.", url: "https://www.dpreview.com/news/4124462928/tamron-is-working-on-a-28-75mm-f2-8-lens-for-full-frame-sony-mirrorless-cameras", image: "https://1.img-dpreview.com/files/p/E~C0x0S1200x900T200x150~articles/4124462928/tamron_28_75_body.jpeg"))
                data.append(NewsModel(title: "Sigma FE 35mm f/1.4 AF Lens", info: "sonyrumors    Jan.18 2018", content: "As rumored before, Sigma will announce their FE lenses for Sony full frame mirrorless cameras around CP+ Show in early March. Now according to leaked weibo from Sigma China (Now deleted), they confirmed a lot of new lenses is coming very soon, Sigma already have many new lenses for Canon and Nikon DSLR cameras, so these upcoming lenses will probably Sigma FE lenses for Sony full frame mirrorless cameras.", url: "https://www.sonyrumors.co/tag/sigma-fe-35mm-f1-4-af-lens/"))
            default: break
            }
        case Context.Tab.libraries:
            switch category {
            case Context.Category.lens:
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Sigma_85mm_F14_DG_HSM_A_Nikon/Marketing_PV/Sigma_85mm_F14_DG_HSM_A_Nikon.png", name: "Sigma 85mm F1.4 DG HSM A Nikon", tags: ["Nikon F", "Full"]))
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Zeiss_Carl_Zeiss_Distagon_T_STAR_Otus_55mm_F14_ZF2_Nikon/Marketing_PV/Zeiss_Carl_Zeiss_Distagon_T_STAR_Otus_55mm_F14_ZF2_Nikon.png", name: "Carl Zeiss Distagon T* Otus 1.4/55 ZF.2 Nikon", tags: ["Nikon F", "Full"]))
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Zeiss_Carl_Zeiss_Apo_Planar_T_Star_Otus_85mm_F14_ZF2_Nikon/Marketing_PV/Zeiss_Carl_Zeiss_Apo_Planar_T_Star_Otus_85mm_F14_ZF2_Nikon.png", name: "Carl Zeiss Distagon T* Otus 1.4/85 ZF.2 Nikon", tags: ["Nikon F", "Full"]))
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Sony_FE_85mm_F14_GM/Marketing_PV/Sony_FE_85mm_F14_GM.png", name: "Sony FE 85mm F1.4 GM", tags: ["Sony E", "Full"]))
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Sony_FE_Carl_Zeiss_Sonnar_T_STAR_55mm_F18/Marketing_PV/Sony_FE_Carl_Zeiss_Sonnar_T_STAR_55mm_F18.png", name: "Sony FE Carl Zeiss Sonnar T* 55mm F1.8 ZA", tags: ["Sony E", "Full"]))
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Zeiss_Carl_Zeiss_Apo_Sonnar_T_Star_F2_135_ZE_Canon/Marketing_PV/Zeiss_Carl_Zeiss_Apo_Sonnar_T_Star_F2_135_ZE_Canon.png", name: "Carl Zeiss Apo Sonnar T* 2/135 ZE Canon", tags: ["Canon EF", "Full"]))
                data.append(ProductModel(hash: "", image: "https://cdn.dxomark.com/dakdata/measures/Optics/Zeiss_Carl_Zeiss_Milvus_F14_85mm_ZF2_Nikon/Marketing_PV/Zeiss_Carl_Zeiss_Milvus_F14_85mm_ZF2_Nikon.png", name: "Carl Zeiss Milvus 1.4/85 ZF.2 Nikon", tags: ["Nikon F", "Full"]))
            default: break
            }
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        // 设置选项卡标题
        return IndicatorInfo(title: category)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tab {
        case Context.Tab.equipment, Context.Tab.libraries, Context.Tab.wishlist:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
            let product = data[indexPath.row] as! ProductModel
            cell.productImage.kf.setImage(with: URL(string: (product.image)))
            cell.nameLabel.text = product.name
            cell.mountButton.setTitle(product.tags[0], for: .normal)
            cell.frameButton.setTitle(product.tags[1], for: .normal)
            if self.tab == Context.Tab.equipment {
                cell.mountButton.isEnabled = true
                cell.frameButton.isEnabled = true
            }
            return cell
        case Context.Tab.news:
            if let imageUrl = (data[indexPath.row] as! NewsModel).image {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell", for: indexPath) as! NewsImageCell
                cell.picture.kf.setImage(with: URL(string: imageUrl))
                cell.title.text = (data[indexPath.row] as! NewsModel).title
                cell.info.text = (data[indexPath.row] as! NewsModel).info
                cell.content.text = (data[indexPath.row] as! NewsModel).content
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
                cell.title.text = (data[indexPath.row] as! NewsModel).title
                cell.info.text = (data[indexPath.row] as! NewsModel).info
                cell.content.text = (data[indexPath.row] as! NewsModel).content
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
        switch tab {
        case Context.Tab.equipment, Context.Tab.libraries, Context.Tab.wishlist:
            let productDetailTableViewController = ProductDetailViewController()
            let detailData = data[indexPath.row] as! ProductModel
            if detailData.detail == nil {
                detailData.setDetail(image: "https://cdn.dxomark.com/wp-content/uploads/2017/09/Sony-Zeiss-Sonnar-T-FE-55mm-f1.8-ZA-lens-review-Exemplary-performance.jpg", specs: ["Aperture: f/1.8", "Focal range (mm): 55", "Filter diameter (mm): 49", "Max diameter (mm): 64", "Mount type: Sony FE", "Stabilization: No", "AF Motor: Stepping motor", "Lenses/Groups: 7/5", "Diaphragm blades: 9", "Length (mm): 71", "Weight (gr): 281"], samples: ["http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/01_1920x1080.jpg", "http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/02_1920x1080.jpg", "http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/03_1920x1080.jpg", "http://www.sonystyle.com.cn/activity/wallpaper/2018/feb/04_1920x1080.jpg"])
            }
            productDetailTableViewController.data = detailData
            productDetailTableViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(productDetailTableViewController, animated: true)
        case Context.Tab.news:
            if let url = (data[indexPath.row] as! NewsModel).url {
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
            tableView.deleteRows(at: [indexPath], with: .fade)
            data.remove(at: indexPath.row)
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
