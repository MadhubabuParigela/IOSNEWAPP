//
//  SideMenuView.swift
//  Lekha
//
//  Created by Mallesh Kurva on 22/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class SideMenuView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    var titleArray = NSMutableArray()
    var imagesArray = NSMutableArray()
    
    @IBOutlet weak var emailIDLbl: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    var viewCntrlObj = UIViewController()
    
    @IBAction func logoutBtnTap(_ sender: Any) {
//        logout()
        showAlertWith(title: "Alert", message: "Are you sure to logout ?")
    }
    
    func logout()  {
        
        self.removeFromSuperview()
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(false, forKey: "isLoggedIn")
        userDefaults.synchronize()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
        VC.modalPresentationStyle = .fullScreen
       // self.viewCntrlObj.present(VC, animated: true, completion: nil)
        
        self.viewCntrlObj.navigationController?.pushViewController(VC, animated: true)

    }
    
    func showAlertWith(title:String,message:String)
        {
            let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
            //to change font of title and message.
            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
            alertController.setValue(titleAttrString, forKey: "attributedTitle")
            alertController.setValue(messageAttrString, forKey: "attributedMessage")
            
            let alertAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
            })
        
        let alertAction1 = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.logout()
           
        })

    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
           alertController.addAction(alertAction1)

        viewCntrlObj.present(alertController, animated: true, completion: nil)
        
        }
    func showAlertWith1(title:String,message:String)
        {
            let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
            //to change font of title and message.
            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
            alertController.setValue(titleAttrString, forKey: "attributedTitle")
            alertController.setValue(messageAttrString, forKey: "attributedMessage")
            
            let alertAction = UIAlertAction(title: "ok", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
            })
        
            alertController.addAction(alertAction)

        viewCntrlObj.present(alertController, animated: true, completion: nil)
        
        }
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    func loadSideMenuView(viewCntrl:UIViewController,status:String)  {
        
            let modulePermissionDict = UserDefaults.standard.value(forKey: "modulePermissions") as! NSDictionary
            print(modulePermissionDict)
        
//        ["Home","Current Inventory","Shopping Cart","Give Away","Open Orders","Order History","Vendor Masters","Notifications","Approvals","My Accounts","Reports"]
 
//        ["home","currentInventory","shoppingCart","giveAway","openOrders","ordersHistory","vendorMasters","notifications","approval","myAccounts","reports"]
        let userDefaults = UserDefaults.standard
        let currentInventoryStatus = modulePermissionDict.value(forKey: "currentInventory_management") as? Bool ?? true
        userDefaults.set(currentInventoryStatus, forKey: "currentInventoryStatus")
        let openOrdersManStatus = modulePermissionDict.value(forKey: "openOrders_management") as? Bool ?? true
        userDefaults.set(openOrdersManStatus, forKey: "openOrdersManStatus")
        let orderHistoryManStatus = modulePermissionDict.value(forKey: "orderHistory_management") as? Bool ?? true
        userDefaults.set(orderHistoryManStatus, forKey: "orderHistoryManStatus")
        let shoppingCartManStatus = modulePermissionDict.value(forKey: "shoppingCart_management") as? Bool ?? true
        userDefaults.set(shoppingCartManStatus, forKey: "shoppingCartManStatus")
        let vendorManStatus = modulePermissionDict.value(forKey: "master_data") as? Bool ?? true
        userDefaults.set(vendorManStatus, forKey: "vendorManStatus")
        let giveAwayStatus = modulePermissionDict.value(forKey: "give_away") as? Bool ?? true
        userDefaults.set(giveAwayStatus, forKey: "giveAwayStatus")
        let vendorConnectStatus = modulePermissionDict.value(forKey: "vendor_connect") as? Bool ?? true
        userDefaults.set(vendorConnectStatus, forKey: "vendorConnectStatus")
        let consumerConnectStatus = modulePermissionDict.value(forKey: "consumer_connect") as? Bool ?? true
        userDefaults.set(consumerConnectStatus, forKey: "consumerConnectStatus")
        let borrowLentStatus = modulePermissionDict.value(forKey: "borrow_lent") as? Bool ?? true
        userDefaults.set(borrowLentStatus, forKey: "borrowLentStatus")
        let shareStatus = modulePermissionDict.value(forKey: "share") as? Bool ?? true
        userDefaults.set(shareStatus, forKey: "shareStatus")
        let reportsStatus = modulePermissionDict.value(forKey: "report") as? Bool ?? true
        userDefaults.set(reportsStatus, forKey: "reportsStatus")
        //Adding titles and images

        titleArray.add("Home")
        imagesArray.add("home")
        
        let userID = userDefaults.value(forKey: "userID") as! String
        let primaryU = userDefaults.value(forKey: "primaryUser") as? String ?? ""
        print(userID,primaryU)
        
        let isconsumerStatus = userDefaults.string(forKey: "consumerStatus")
        
        if(isconsumerStatus == "0"){

            titleArray = ["Home","Product Management","My Orders","Vendor Masters","Notifications","Account Settings","Reports"]
            imagesArray = ["currentInventory","shoppingCart","openOrders","vendorMasters","notifications","myAccounts","reports"]

        }else{
            
           
                
                titleArray.add("Current Inventory")
                imagesArray.add("currentInventory")

            titleArray.add("Give Away")
            imagesArray.add("giveAway")
            
                titleArray.add("Shopping Cart")
                imagesArray.add("shoppingCart")

         
                titleArray.add("Open Orders")
                imagesArray.add("openOrders")

                titleArray.add("Order History")
                imagesArray.add("ordersHistory")

                titleArray.add("Vendor Masters")
                imagesArray.add("vendorMasters")

            titleArray.add("Consumer Connect")
            imagesArray.add("vendorMasters")
 
            
            titleArray.add("Notifications")
            imagesArray.add("notifications")
            
            if primaryU=="Yes"
            {
            titleArray.add("Account Approvals")
            imagesArray.add("approval")
            }
            
            titleArray.add("Account Settings")
            imagesArray.add("myAccounts")
           
            titleArray.add("Reports")
            imagesArray.add("reports")
            

            
        }
        
//        userDefaults.set(fieldname, forKey: "accountEmail")
        
        let emailStr = userDefaults.value(forKey: "accountEmail") as! String
            
//      let URLString_loginIndividual = MyAccImgUrl  + userID

        var imageStr = MyAccImgUrl + userID
        
//        let userDefaults = UserDefaults.standard
//        let isconsumerStatus = userDefaults.string(forKey: "consumerStatus")

        if(isconsumerStatus == "0"){
            let accountID = (userDefaults.string(forKey: "accountId") ?? "")
            imageStr = VendorMyAccImgUrl + accountID
        }

                if !imageStr.isEmpty {

                    let imgUrl:String = imageStr

                    let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")

                    var imggg = MyAccImgUrl + userID
                    
                    if(isconsumerStatus == "0"){
                       let accountID = (userDefaults.string(forKey: "accountId") ?? "")
                        imggg = VendorMyAccImgUrl + accountID
                    }
                    
                    DispatchQueue.main.async {
                    let url = URL.init(string: imggg)

//                        self.profileImgView.sd_setImage(with: url, placeholderImage:UIImage(named: "add photo"), options: .refreshCached)
                        
                        self.profileImgView.sd_setImage(with: url, completed: nil)
                        
//                        [self.profileImgView setImageWithURL:[NSURL URLWithString:url]
//                                  placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]
//                                           options:SDWebImageRefreshCached];

                        
                        self.profileImgView.contentMode = UIView.ContentMode.scaleAspectFill

                    }
                }
                else {
                    profileImgView.image = UIImage(named: "add photo")
                }

        

        viewCntrlObj = viewCntrl
        
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        
        logoutBtn.layer.borderColor = hexStringToUIColor(hex: "ffffff").cgColor
        logoutBtn.layer.borderWidth = 1.0
        logoutBtn.layer.cornerRadius = 10
        logoutBtn.clipsToBounds = true

//      fullName
        
        let fullNameStr = userDefaults.value(forKey: "fullName") ?? ""
        let emailIDStr = userDefaults.value(forKey: "emailAddress") ?? ""
        
//        DispatchQueue.main.async {
            self.fullNameLbl.text = fullNameStr as? String
            self.emailIDLbl.text = emailIDStr as? String

//        }
        
        
        sideMenuTableView.reloadData()
        
    }
    
    @IBAction func sideMenuBtnTap(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
             self.frame = CGRect(x: -320
                , y: 0,width: self.frame.size.width ,height: self.frame.size.height)
         }, completion: { (finished: Bool) -> Void in
            
               self.removeFromSuperview()

         })

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//       let cell = sideMenuTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")

        cell.backgroundColor = hexStringToUIColor(hex: "105FEF")
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50)
//        view.backgroundColor = UIColor.clear
        cell.contentView.addSubview(view)
        
        let iconImg = UIImageView()
        iconImg.frame = CGRect(x: 20, y: view.frame.size.height/2-(10)
            , width: 20, height: 20)
//        iconImg.backgroundColor = UIColor.green
        iconImg.image = UIImage.init(named: imagesArray.object(at: indexPath.row) as! String)
        view.addSubview(iconImg)
        
        let titleLbl = UILabel()
        titleLbl.frame = CGRect(x: iconImg.frame.size.width+iconImg.frame.origin.x+(10), y: 1.5
            , width: view.frame.size.width-(iconImg.frame.size.width+45), height: view.frame.size.height)
        view.addSubview(titleLbl)
        titleLbl.text = titleArray[indexPath.row] as? String
        titleLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        titleLbl.textColor = hexStringToUIColor(hex: "ffffff")
//        titleLbl.backgroundColor = UIColor.green
        
        let touchBtn = UIButton()
        touchBtn.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        touchBtn.addTarget(self, action: #selector(onSelectBtnTap), for: .touchUpInside)
        touchBtn.setTitle(titleArray[indexPath.row] as? String, for: .normal)
        touchBtn.setTitleColor(.clear, for: .normal)
        view.addSubview(touchBtn)
        
        return cell

    }
    
    @objc func onSelectBtnTap(sender:UIButton){
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String
        print(userID)
        
        let isconsumerStatus = userDefaults.string(forKey: "consumerStatus")
        let isSideMenuStatus = userDefaults.string(forKey: "sideMenuTitle")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        
        if(isconsumerStatus == "0"){
            
            if(sender.currentTitle == "Home"){
                if isSideMenuStatus=="Home"
                {
                    
                }
                else
                {
                    if userDefaults.bool(forKey: "currentInventoryStatus")==false
                    {
                        self.showAlertWith1(title: "Alert", message: "You are not authorized to access this module")
                    }
                    else
                    {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "VendorOrdersViewController") as! VendorOrdersViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    }
                }
            }
            
           else if(sender.currentTitle == "Product Management"){
            if isSideMenuStatus=="Product Management"
            {
                
            }
            else
            {
                
                userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "VendorProductListViewController") as! VendorProductListViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                
            }

            }else if(sender.currentTitle == "My Orders"){
                if isSideMenuStatus=="My Orders"
                {
                    
                }
                else
                {
                    
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "SideMenuMyOrdersViewController") as! SideMenuMyOrdersViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    
                }
            }
            else if(sender.currentTitle == "Vendor Masters"){
                if isSideMenuStatus=="Vendor Masters"
                {
                    
                }
                else
                {
                    if userDefaults.bool(forKey: "vendorManStatus")==false
                    {
                        self.showAlertWith(title: "Alert", message: "You are not authorized to access this module")
                    }
                    else
                    {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "VendorListVC") as! VendorListingViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    }
                }
            }
            else if(sender.currentTitle == "Account Settings"){
                if isSideMenuStatus=="Account Settings"
                {
                    
                }
                else
                {
                   
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                    let VC = storyBoard.instantiateViewController(withIdentifier: "VendorAccountVC") as! VendorAccountVC
                    VC.modalPresentationStyle = .fullScreen
        //            viewCntrlObj.present(VC, animated: true, completion: nil)
                    viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    
                }
//
            }else if(sender.currentTitle == "Reports"){
                if isSideMenuStatus=="Reports"
                {
                    
                }
                else
                {
                    if userDefaults.bool(forKey: "reportsStatus")==false
                    {
                        self.showAlertWith1(title: "Alert", message: "You are not authorized to access this module")
                    }
                    else
                    {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "ReportsVC") as! ReportsVC
                VC.modalPresentationStyle = .fullScreen
                VC.pageStatusStr = "VendorReports"
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    }
                }

            }else if(sender.currentTitle == "Notifications"){
                if isSideMenuStatus=="Notifications"
                {
                    
                }
                else
                {
                    
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    
                }
            }
            
        }else{
            
            if(sender.currentTitle == "Home"){
                if isSideMenuStatus=="Home"
                {
                    
                }
                else
                {
                    if userDefaults.bool(forKey: "currentInventoryStatus")==false
                    {
                        self.showAlertWith1(title: "Alert", message: "You are not authorized to access this module")
                    }
                    else
                    {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    }
                }

            }else if(sender.currentTitle == "Current Inventory"){
                if isSideMenuStatus=="Current Inventory"
                {
                    
                }
                else
                {
                   
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    
                }
                
            }else if(sender.currentTitle == "Shopping Cart"){
                if isSideMenuStatus=="Shopping Cart"
                {
                    
                }
                else
                {
                    if userDefaults.bool(forKey: "shoppingCartManStatus")==false
                    {
                        self.showAlertWith1(title: "Alert", message: "You are not authorized to access this module")
                    }
                    else
                    {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingVC") as! ShoppingViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    }
                }
            }
            else if(sender.currentTitle == "Give Away"){
                if isSideMenuStatus=="Give Away"
                {
                    
                }
                else
                {
                    if userDefaults.bool(forKey: "giveAwayStatus")==false
                    {
                        self.showAlertWith1(title: "Alert", message: "You are not authorized to access this module")
                    }
                    else
                    {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "GiveAwayVC") as! GiveAwayViewController
                VC.modalPresentationStyle = .fullScreen
//                VC.headerTitleStr = "GiveAway"
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    }
                }
            }
            else if(sender.currentTitle == "Open Orders"){
                if isSideMenuStatus=="Open Orders"
                {
                    
                }
                else
                {
                    if userDefaults.bool(forKey: "openOrdersManStatus")==false
                    {
                        self.showAlertWith1(title: "Alert", message: "You are not authorized to access this module")
                    }
                    else
                    {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "OpenOrdersVC") as! OpenOrdersViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    }
                }
            }else if(sender.currentTitle == "Order History"){
                if isSideMenuStatus=="Order History"
                {
                    
                }
                else
                {
                    if userDefaults.bool(forKey: "orderHistoryManStatus")==false
                    {
                        self.showAlertWith1(title: "Alert", message: "You are not authorized to access this module")
                    }
                    else
                    {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "OrderHistoryVC") as! OrderHistoryViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    }
                }
            }else if(sender.currentTitle == "Vendor Masters"){
                if isSideMenuStatus=="Vendor Masters"
                {
                    
                }
                else
                {
                    if userDefaults.bool(forKey: "vendorManStatus")==false
                    {
                        self.showAlertWith1(title: "Alert", message: "You are not authorized to access this module")
                    }
                    else
                    {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "VendorListVC") as! VendorListingViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    }
                }
            }
            else if(sender.currentTitle == "Consumer Connect"){
                if isSideMenuStatus=="Consumer Connect"
                {
                    
                }
                else
                {
                    if userDefaults.bool(forKey: "consumerConnectStatus")==false
                    {
                        self.showAlertWith1(title: "Alert", message: "You are not authorized to access this module")
                    }
                    else
                    {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "ConsumerConnectViewController") as! ConsumerConnectViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    }
                }
            }
            else if(sender.currentTitle == "Notifications"){
                
//                let VC = storyBoard.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
//                VC.modalPresentationStyle = .fullScreen
//    //            viewCntrlObj.present(VC, animated: true, completion: nil)
//                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                if isSideMenuStatus=="Notifications"
                {
                    
                }
                else
                {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                }
            }else if(sender.currentTitle == "Account Approvals"){
                if isSideMenuStatus=="Account Approvals"
                {
                    
                }
                else
                {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "ApprovalsVC") as! ApprovalsViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                }
            }else if(sender.currentTitle == "Account Settings"){
                if isSideMenuStatus=="Account Settings"
                {
                    
                }
                else
                {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "MyAccountVC") as! MyAccountsViewController
                VC.modalPresentationStyle = .fullScreen
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                }
            }else if(sender.currentTitle == "Reports"){
                if isSideMenuStatus=="Reports"
                {
                    
                }
                else
                {
                    if userDefaults.bool(forKey: "reportsStatus")==false
                    {
                        self.showAlertWith1(title: "Alert", message: "You are not authorized to access this module")
                    }
                    else
                    {
                    userDefaults.set(sender.currentTitle, forKey: "sideMenuTitle")
                let VC = storyBoard.instantiateViewController(withIdentifier: "ReportsVC") as! ReportsVC
                VC.modalPresentationStyle = .fullScreen
                VC.pageStatusStr = "ConsumerReports"
    //            viewCntrlObj.present(VC, animated: true, completion: nil)
                viewCntrlObj.navigationController?.pushViewController(VC, animated: true)
                    }
                }
            }
        }
        
        userDefaults.synchronize()
        self.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50

    }
}

