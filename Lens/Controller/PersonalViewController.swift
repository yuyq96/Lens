//
//  PersonalViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/25.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit
import Kingfisher

class PersonalViewController: UITableViewController {
    
    let shadow = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 设置NavigationBar阴影
        self.shadow.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        self.shadow.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5)
        self.tableView.addSubview(shadow)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        // 注册复用Cell
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "PersonalUserCell", bundle: nil), forCellReuseIdentifier: "PersonalUserCell")
        tableView.register(UINib(nibName: "PersonalBudgetCell", bundle: nil), forCellReuseIdentifier: "PersonalBudgetCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = self.tableView.contentOffset.y
        self.shadow.frame = CGRect(x: 0, y: offset, width: UIScreen.main.bounds.width, height: 0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            if user.token == nil {
                return 2
            } else {
                return 1
            }
        case 1: return 3
        case 2: return 2
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if user.token == nil {
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
                    cell.label?.text = "Login"
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
                    cell.label?.text = "Register"
                    return cell
                default: return UITableViewCell()
                }
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalUserCell", for: indexPath) as! PersonalUserCell
                if user.avatar == "" {
                    cell.avatarImageView?.image = UIImage(named: "avatar")
                } else {
                    cell.avatarImageView?.kf.setImage(with: URL(string: user.avatar))
                }
                cell.nicknameLabel?.text = user.nickname
                cell.usernameLabel?.text = "@" + user.username
                return cell
            }
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
                cell.label?.text = Context.Tab.libraries
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
                cell.label?.text = Context.Tab.wishlist
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalBudgetCell", for: indexPath) as! PersonalBudgetCell
                cell.label?.text = Context.Tab.budget
                cell.budget?.text = "****"
                if user.settings.showBudget == true {
                    cell.budget?.text = user.settings.budget
                }
                return cell
            default: return UITableViewCell()
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
            switch indexPath.row {
            case 0:
                cell.label?.text = "Settings"
            case 1:
                cell.label?.text = "About"
            default: break
            }
            return cell
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 8
        } else {
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        switch indexPath.section {
        case 0:
            if user.token == nil {
                switch indexPath.row {
                case 0:
                    let alertController = UIAlertController(title: "Login", message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                        let username = alertController.textFields?.first?.text
                        let passwd = alertController.textFields?.last?.text
                        user.login(username: username!, password: passwd!) { result in
                            if result {
                                tableView.reloadData()
                            } else {
                                // TODO
                            }
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(confirmAction)
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = "username"
                    })
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.isSecureTextEntry = true
                        textField.placeholder = "password"
                    })
                    self.present(alertController, animated: true, completion: nil)
                case 1:
                    let alertController = UIAlertController(title: "Register", message: "Please input username and password", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                        let id = alertController.textFields?.first?.text
                        let passwd = alertController.textFields?.last?.text
                        user.register(username: id!, password: passwd!) { result in
                            if result {
                                tableView.reloadData()
                            } else {
                                // TODO
                            }
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(confirmAction)
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = "username"
                    })
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.isSecureTextEntry = true
                        textField.placeholder = "password"
                    })
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.isSecureTextEntry = true
                        textField.placeholder = "password again"
                    })
                    self.present(alertController, animated: true, completion: nil)
                default: break
                }
            } else {
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let changeNameAction = UIAlertAction(title: "Change Nickname", style: .default, handler: { (action) in
                    let alertController = UIAlertController(title: "Change Nickname", message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                        if let nickname = alertController.textFields?.first?.text {
                            user.update(nickname: nickname) { result in
                                if result {
                                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                } else {
                                    // TODO
                                }
                            }
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(confirmAction)
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = "new nickname"
                    })
                    self.present(alertController, animated: true, completion: nil)
                })
                let changeAvatarAction = UIAlertAction(title: "Change Avatar", style: .default, handler: { (action) in
                    // TODO
                })
                let changePassAction = UIAlertAction(title: "Change Password", style: .default, handler: { (action) in
                    let alertController = UIAlertController(title: "Change Password", message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                        if let oldPass = alertController.textFields?.first?.text,
                            let newPass = alertController.textFields?.last?.text {
                            user.updatePassword(old: oldPass, new: newPass) { result in
                                if !result {
                                    // TODO
                                }
                            }
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(confirmAction)
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = "old password"
                    })
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = "new password"
                    })
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = "new password again"
                    })
                    self.present(alertController, animated: true, completion: nil)
                })
                let logoutAction = UIAlertAction(title: "Logout", style: .destructive, handler: { (action) in
                    user.logout() {
                        tableView.reloadData()
                    }
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(changeNameAction)
                alertController.addAction(changeAvatarAction)
                alertController.addAction(changePassAction)
                alertController.addAction(logoutAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        case 1:
            if user.token == nil {
                let alertController = UIAlertController(title: "Login first", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                    let username = alertController.textFields?.first?.text
                    let passwd = alertController.textFields?.last?.text
                    user.login(username: username!, password: passwd!) { result in
                        if result {
                            tableView.reloadData()
                        } else {
                            // TODO
                        }
                    }
                })
                alertController.addAction(cancelAction)
                alertController.addAction(confirmAction)
                alertController.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "username"
                })
                alertController.addTextField(configurationHandler: { (textField) in
                    textField.isSecureTextEntry = true
                    textField.placeholder = "password"
                })
                self.present(alertController, animated: true, completion: nil)
            } else {
                switch indexPath.row {
                case 0:
                    let librariesViewController = BrowsePagerTabStripViewController()
                    librariesViewController.tab = Context.Tab.libraries
                    librariesViewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.navigationBar.shadowImage = UIImage()
                    navigationController?.pushViewController(librariesViewController, animated: true)
                case 1:
                    let wishlistViewController = BrowsePagerTabStripViewController()
                    wishlistViewController.tab = Context.Tab.wishlist
                    wishlistViewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.navigationBar.shadowImage = UIImage()
                    navigationController?.pushViewController(wishlistViewController, animated: true)
                case 2:
                    let alertController = UIAlertController(title: "Budget", message: "Please input your budget", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                        if let budget = alertController.textFields?.last?.text {
                            if budget != "" {
                                user.settings.budget = budget
                                user.syncSettings(completion: nil)
                                tableView.reloadData()
                            }
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(confirmAction)
                    alertController.addTextField(configurationHandler: { (textField) in
                        textField.keyboardType = .decimalPad
                        textField.placeholder = user.settings.budget
                        user.syncSettings(completion: nil)
                        textField.addTarget(self, action: #selector(self.budgetTextFieldChanged(textField:)), for: .editingChanged)
                    })
                    self.present(alertController, animated: true, completion: nil)
                default:
                    break
                }
            }
        case 2:
            switch indexPath.row {
            case 0:
                let settingsViewController = SettingsViewController(style: .grouped)
                settingsViewController.hidesBottomBarWhenPushed = true
                settingsViewController.navigationItem.title = "Settings"
                navigationController?.pushViewController(settingsViewController, animated: true)
            case 1:
                let aboutViewController = WebViewController()
                aboutViewController.hidesBottomBarWhenPushed = true
                aboutViewController.navigationItem.title = "About"
                aboutViewController.urlString = "https://github.com/archie-yu/Lens"
                navigationController?.pushViewController(aboutViewController, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
    
    @objc func budgetTextFieldChanged(textField: UITextField) {
        if let oldText = textField.text {
            var newText = ""
            for char in oldText {
                if "0123456789".contains(char) {
                    newText.append(char)
                }
            }
            textField.text = newText
        }
    }
    
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if viewController == self {
//            self.navigationController?.navigationBar.shadowImage = nil
//        }
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
