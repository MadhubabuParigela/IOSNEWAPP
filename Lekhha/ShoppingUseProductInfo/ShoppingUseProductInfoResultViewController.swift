//
//  ShoppingUseProductInfoResultViewController.swift
//  Lekha
//
//  Created by USM on 04/01/21.
//  Copyright © 2021 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper

protocol sendShoppingInfoDetails {
    func shoppingResultDetails(billScanStatus:String,type:String,dataArray:NSMutableArray)
}


class ShoppingUseProductInfoResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var shoppingResDelegate:sendShoppingInfoDetails?

    var myProductArray = NSMutableArray()
    
    var isAddProduct = ""
    
    let currentInventoryArray = NSMutableArray()
    let shoppingCartArray = NSMutableArray()
    var openOrdersArray = NSMutableArray()
    var openOrdersResultArray = NSMutableArray()

    @IBOutlet weak var useProdTblView: UITableView!
    
    var resultDataArray = NSMutableArray()
    
    var accountID = String()
    var serviceCntrl = ServiceController()
    
    var currentInventoryStatusStr = String()
    var shoppingCartttStatusStr = String()
    var openOrdersStatusStr = String()
    var ordersHistoryStatusStr = String()
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        useProdTblView.delegate = self
        useProdTblView.dataSource = self
        
        animatingView()
        
        useProdTblView.register(UINib(nibName: "ShoppingUseProductInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingUseProductInfoTableViewCell")

        if(currentInventoryStatusStr == "CurrentInventory"){
            self.getCurrentInventoryAPI()
            
        }else if(shoppingCartttStatusStr == "ShoppingCart"){
            self.getShoppingCartListAPI()
            
        }else if(openOrdersStatusStr == "OpenOrders"){
            self.getOpenOrdersAPI()
            
        }else if(ordersHistoryStatusStr == "OrdersHistory"){
            self.getOrdersHistoryAPI()
            
        }

        // Do any additional setup after loading the view.
    }
    
    func animatingView(){
        
        self.view.addSubview(activity)
                      
        activity.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = activity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthConstraint = activity.widthAnchor.constraint(equalToConstant: 50)
        let heightConstraint = activity.heightAnchor.constraint(equalToConstant: 50)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myProductArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingUseProductInfoTableViewCell", for: indexPath) as! ShoppingUseProductInfoTableViewCell

//        let productDict = myProductArray[indexPath.row] as! NSDictionary

        let dataDict = myProductArray[indexPath.row] as! NSDictionary
        if let stockQuan = dataDict.value(forKey: "stockQuantity") as? Double {
            cell.stockQuanLbl.text = String(stockQuan)
        }
        else if let stockQuant = dataDict.value(forKey: "stockQuantity") as? Float{
            
            cell.stockQuanLbl.text = String(stockQuant)
        }
        else {
            
            cell.stockQuanLbl.text = dataDict.value(forKey: "stockQuantity") as? String
        }
        
        cell.prodIDLbl.text = dataDict["productUniqueNumber"] as? String
        cell.prodNameLbl.text = dataDict.value(forKey: "productName") as? String
        cell.descLbl.text = dataDict.value(forKey: "description") as? String
        cell.stockUnitLbl.text = dataDict.value(forKey: "stockUnit") as? String
        cell.level1Label.text = dataDict.value(forKey: "storageLocation") as? String
        cell.level2Label.text = dataDict.value(forKey: "storageLocation1") as? String
        cell.level3Label.text = dataDict.value(forKey: "storageLocation2") as? String
        
        let expiryDate = (dataDict.value(forKey: "expiryDate") as? String)
        let convertedExpiryDate = convertDateFormatter(date: expiryDate ?? "")
        cell.expiryDateLbl.text = convertedExpiryDate
        
        cell.selectBtn.addTarget(self, action: #selector(selectBtnTap), for: .touchUpInside)
        cell.selectBtn.tag = indexPath.row
        
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTap), for: .touchUpInside)
        cell.deleteBtn.tag = indexPath.row
        
        let isSelected = dataDict.value(forKey:"isSelected") as! String
        
        if(isSelected == "1"){
            cell.selectBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
        }else{
            cell.selectBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)

        }
    
        var prodSNO = indexPath.row as! Int
        
        prodSNO = prodSNO + 1
        
        cell.prodTitleLbl.text = "Product \(prodSNO)"

        
        let prodArray = dataDict.value(forKey: "productImages") as? NSArray

        if(prodArray?.count ?? 0  > 0){

                    let dict = prodArray?[0] as! NSDictionary
                    
                    let imageStr = dict.value(forKey: "productDisplayImage") as! String
                    
                    if !imageStr.isEmpty {
                        
                        let imgUrl:String = imageStr
                        
                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                            
                        let imggg = Constants.BaseImageUrl + trimStr
                        
                        let url = URL.init(string: imggg)

//                        cell.prodImgView?.sd_setImage(with: url , placeholderImage: UIImage(named: "add photo"))
                        
                        cell.prodImgView?.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                        cell.prodImgView?.contentMode = UIView.ContentMode.scaleAspectFit
                        
                    }
                    else {
                        
                        cell.prodImgView?.image = UIImage(named: "no_image")
                    }
        }else{
            cell.prodImgView?.image = UIImage(named: "no_image")

        }

        
        

        return cell
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320

    }
    
    @objc func deleteBtnTap(sender: UIButton){
        
        if(myProductArray.count <= 1){
            self.showAlertWith(title: "Alert..!!", message: "Minimum one product required")
            
        }else{
            
            myProductArray.removeObject(at: sender.tag)
            self.showAlertWith(title: "Success", message: "Product deleted")
            
            useProdTblView.reloadData()

        }
    }
    
    @objc func selectBtnTap(sender: UIButton!){
      
        let dataDict = myProductArray.object(at:sender.tag) as! NSDictionary
        
        var isSelectStr = dataDict.value(forKey: "isSelected") as! String
        
        if(isSelectStr == "1"){
            isSelectStr = "0"
            
        }else{
            isSelectStr = "1"
        }

        dataDict.setValue(isSelectStr, forKey: "isSelected")
        myProductArray.replaceObject(at: sender.tag, with: dataDict)
        
        useProdTblView.reloadData()
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
            self.navigationController?.pushViewController(VC, animated: true)

        }
    
    @IBAction func SaveBtnTapped(_ sender: Any) {
        
        let finalProdArray = NSMutableArray()
        
        for i in 0..<myProductArray.count {
            
            let dataDict = myProductArray.object(at: i) as! NSDictionary
            let isSelectedStr = dataDict.value(forKey: "isSelected") as! String
            
            
            if(isSelectedStr == "1"){
                finalProdArray.add(dataDict)
                
            }
        }
        
        if(isAddProduct == "1"){
            
//            let VC = AddProductViewController()
//            VC.isBillScan = "1"
//            VC.useRefArray = finalProdArray
            
            self.shoppingResDelegate?.shoppingResultDetails(billScanStatus: "1", type: "BillScan", dataArray: finalProdArray)
            
            self.navigationController?.popViewController(animated: true)
            
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let VC = storyBoard.instantiateViewController(withIdentifier: "AddProductVC") as! AddProductViewController
//            VC.modalPresentationStyle = .fullScreen
//            VC.isBillScan = "1"
//            VC.useRefArray = finalProdArray
//            self.navigationController?.pushViewController(VC, animated: true)

            
        }else{
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "AddManualTextProductViewController") as! AddManualTextProductViewController
            VC.modalPresentationStyle = .fullScreen
            VC.isEditShopping = "UseProductInfo"
            VC.myProductArray = finalProdArray
    //        self.present(VC, animated: true, completion: nil)
            self.navigationController?.pushViewController(VC, animated: true)

        }
    }
    
    // Alert controller
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
            
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            })
    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    
    func getCurrentInventoryAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + CurrentInventoryUrl + accountID as String
        serviceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
            
                           let dataDict = result as! NSDictionary
                           let currentInvRes = dataDict.value(forKey: "result") as! NSArray
                                        
                            if status == "SUCCESS" {
                                
                                if(currentInvRes.count > 0){
                                    for i in 0..<currentInvRes.count {
                                        self.currentInventoryArray.add(currentInvRes[i])
                                    }
                                    
                                    self.parseCurrentInventoryData()
                                }
                                
                                if(self.shoppingCartttStatusStr == "ShoppingCart"){
                                    self.getShoppingCartListAPI()
                                    
                                }else if(self.openOrdersStatusStr == "OpenOrders"){
                                    self.getOpenOrdersAPI()
                                    
                                }else if(self.ordersHistoryStatusStr == "OrdersHistory"){
                                    self.getOrdersHistoryAPI()
                                    
                                }

                            }
                            else {
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
            
                }
    
    
    func getShoppingCartListAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + ShoppingCartRetrieveUrl + accountID
                                    
                            serviceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                
                                let dataDict = result as! NSDictionary
                                let shoppingCartRes = dataDict.value(forKey: "result") as! NSArray
                                        
                            if status == "SUCCESS" {
                                
                                if(shoppingCartRes.count > 0){
                                    for i in 0..<shoppingCartRes.count {
                                        self.shoppingCartArray.add(shoppingCartRes[i])
                                    }
                                    
                                    self.parseShoppingCartData()
                                }
                                
                                if(self.openOrdersStatusStr == "OpenOrders"){
                                    self.getOpenOrdersAPI()
                                    
                                }else if(self.ordersHistoryStatusStr == "OrdersHistory"){
                                    self.getOrdersHistoryAPI()
                                    
                                }
                            }
                            else {
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
                    }
    
    func getOrdersHistoryAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + OrdersHistoryUrl + accountID
                                    
        serviceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:OrdersHistoryRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
            
                          let dataDict = result as! NSDictionary
 
                                        
                            if status == "SUCCESS" {
                                
                                self.openOrdersResultArray = dataDict.value(forKey: "result") as! NSMutableArray

                                if(self.openOrdersResultArray.count > 0){
                                    self.parseOrdersHistoryData()
                                }

                            }
                            else {
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
                    }
    
    func getOpenOrdersAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + OpenOrdersUrl + accountID
                                    
        serviceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:OpenOrdersRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
            
                            let dataDict = result as! NSDictionary
            
                            if status == "SUCCESS" {

                                self.openOrdersArray = dataDict.value(forKey: "result") as! NSMutableArray
                                
                                if(self.openOrdersArray.count > 0){
                                    self.parseOpenOrdersData()
                                }
                                
                            }
                            else {
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
                    }
    
    func parseCurrentInventoryData() {
        
        print("Current Inv is \(currentInventoryArray)")
        
        for i in 0..<currentInventoryArray.count {
           
            var myDict = NSMutableDictionary()
            
    //      var prodImgArray =
            var prodImgDict = NSMutableDictionary()

            let prodImgArray = NSMutableArray()
            
            
            var accountID = String()
            let defaults = UserDefaults.standard
            accountID = (defaults.string(forKey: "accountId") ?? "")
            print(accountID)
            
            var userID = String()
            userID = (defaults.string(forKey: "userID") ?? "")
            print(userID)
            print(prodImgArray)
            
            let dataDict = currentInventoryArray.object(at: i) as! NSDictionary
            
            let prodDetailsDict = dataDict.value(forKey: "productdetails") as! NSDictionary
            
            print(prodDetailsDict)
            
            let productImgArray = prodDetailsDict.value(forKey: "productImages") as? NSArray ?? ["","",""]
            var prodImageDict = NSDictionary()

            if(productImgArray.count > 0){
                prodImageDict = productImgArray[0] as?
                    NSDictionary ?? ["":""]
            }
            
            for i in 0..<3 {

                var prodImageStr = ""
                var prodDataStr = NSData()
                
                
                if(i == 0){
                    prodImageStr = prodImageDict.value(forKey: "0") as? String ?? ""
                    
                
                }else if(i == 1){
                    prodImageStr = prodImageDict.value(forKey: "1") as? String ?? ""

                }else{
                    prodImageStr = prodImageDict.value(forKey: "2") as? String ?? ""

                }
                
                let emptyData = NSData()
                
                let imgUrl:String = prodImageStr as String
                
                let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                    
                let imggg = Constants.BaseImageUrl + trimStr
                
//                let fileUrl = URL(string: imggg)
                
                let url:NSURL = NSURL(string : imggg)!
                //Now use image to create into NSData format
                let imageData:NSData = NSData.init(contentsOf: url as URL) ?? emptyData
                
                let base64ImageStr = imageData.base64EncodedString(options: .lineLength64Characters)

                prodImgDict = ["productImage": base64ImageStr,"productDisplayImage":prodImageStr,"productServerImage":prodImageStr,"isLocalImg":"0"]
                
                prodImgArray.add(prodImgDict)
            }
            
            let prodName = prodDetailsDict.value(forKey: "productName") as! String
            let prodUniqNum = prodDetailsDict.value(forKey: "productUniqueNumber") as! String
            let description = prodDetailsDict.value(forKey: "description") as! String
            
            var stockQuanStr = String()
            if let stockQuan = prodDetailsDict.value(forKey: "stockQuantity") as? Double {
                stockQuanStr = String(stockQuan)
            }
            else if let stockQuant = prodDetailsDict.value(forKey: "stockQuantity") as? Float{
                
                stockQuanStr = String(stockQuant)
            }
            else {
                
                stockQuanStr = prodDetailsDict.value(forKey: "stockQuantity") as? String ?? ""
            }
            let priceUnitDetails=dataDict.value(forKey: "priceUnitDetails")as? NSArray
            var priceUnit=String()
            if priceUnitDetails?.count ?? 0>0
            {
                let priceUnitDetailsDic=priceUnitDetails?[0] as? NSDictionary
                priceUnit=priceUnitDetailsDic?.value(forKey: "priceUnit") as? String ?? ""
            }
            else
            {
                priceUnit = ""
            }
            let storagelocationLevel1=dataDict.value(forKey: "storageLocationLevel1Details")as? NSArray
            let storagelocationLevel2=dataDict.value(forKey: "storageLocationLevel2Details")as? NSArray
            let storagelocationLevel3=dataDict.value(forKey: "storageLocationLevel3Details")as? NSArray
            var storagelocation1=String()
            var storagelocation2=String()
            var storagelocation3=String()
            var storageLocationId=String()
            var storageLocation1Id=String()
            var storageLocation2Id=String()
            
            if storagelocationLevel1?.count ?? 0>0
            {
                let storagelocationLevel1Dic=storagelocationLevel1?[0] as? NSDictionary
                storagelocation1 = storagelocationLevel1Dic?.value(forKey: "slocName") as? String ?? ""
                storageLocationId=storagelocationLevel1Dic?.value(forKey: "_id") as? String ?? ""
            }
            else
            {
                storagelocation1 = ""
            }
            if storagelocationLevel2?.count ?? 0>0
            {
                let storagelocationLevel2Dic=storagelocationLevel2?[0] as? NSDictionary
                storagelocation2 = storagelocationLevel2Dic?.value(forKey: "slocName") as? String ?? ""
                storageLocation1Id=storagelocationLevel2Dic?.value(forKey: "_id") as? String ?? ""
            }
            else
            {
                storagelocation2 = ""
            }
            if storagelocationLevel3?.count ?? 0>0
            {
                let storagelocationLevel3Dic=storagelocationLevel3?[0] as? NSDictionary
                storagelocation3 = storagelocationLevel3Dic?.value(forKey: "slocName") as? String ?? ""
                storageLocation2Id=storagelocationLevel3Dic?.value(forKey: "_id") as? String ?? ""
            }
            else
            {
                storagelocation3 = ""
            }
            var priceStr1 = String()
            if let priceStr = prodDetailsDict.value(forKey: "price") as? Double {
                
                priceStr1 = String(format:"%.2f", priceStr ?? 0)
            }
            else if let priceStr = prodDetailsDict.value(forKey: "price") as? Float{
                priceStr1 = String(format:"%.2f", priceStr ?? 0)
            }
            else {
                priceStr1 = prodDetailsDict.value(forKey: "price") as? String ?? ""
            }
            let stockUnitDetails=dataDict.value(forKey: "stockUnitDetails")as? NSArray
            var stockUnitStr = String()
            var stockUnitId = String()
            if stockUnitDetails?.count ?? 0>0
            {
            let stockUnitDetailsDic=stockUnitDetails?[0] as? NSDictionary
                stockUnitStr = stockUnitDetailsDic?.value(forKey: "stockUnitName") as? String ?? ""
                stockUnitId = stockUnitDetailsDic?.value(forKey: "_id") as? String ?? ""
            }
            else
            {
                stockUnitStr = ""
                stockUnitId = ""
            }
            
            let categoryStr = prodDetailsDict.value(forKey: "category") as! String
            let subCategoryStr = prodDetailsDict.value(forKey: "subCategory") as! String
            let vendorIdStr = prodDetailsDict.value(forKey: "vendorId") as! String
//            let addedUserID = ""
//            let purchaseDate = prodDetailsDict.value(forKey: "purchaseDate") as! String
            
            let currentDate = Date()
            let eventDatePicker = UIDatePicker()
            
            eventDatePicker.datePickerMode = UIDatePicker.Mode.date
            eventDatePicker.minimumDate = currentDate
                   
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let selectedDate = convertDateFormatter(date: prodDetailsDict.value(forKey: "purchaseDate") as? String ?? "")
            var unitPriceStr1=String()
            if let unitPriceStr = prodDetailsDict.value(forKey: "unitPrice") as? Double {
                
                unitPriceStr1 = String(unitPriceStr)
            }
            else if let unitPriceStr = prodDetailsDict.value(forKey: "unitPrice") as? Int {
                unitPriceStr1 = String(unitPriceStr)
            }
            else {
                
                unitPriceStr1 = prodDetailsDict.value(forKey: "unitPrice") as? String ?? ""
            }
            
            let expiryDate = convertDateFormatter(date: prodDetailsDict.value(forKey: "expiryDate") as? String ?? "")
            let orderStr=prodDetailsDict.value(forKey: "orderId") as? String
            myDict  = ["accountId": accountID, "productName": prodName, "productUniqueNumber": prodUniqNum,"description": description,"stockQuantity": stockQuanStr,"stockUnit": stockUnitStr,"stockUnitId":stockUnitId,"price": priceStr1,"category": categoryStr,"subCategory": subCategoryStr,"vendorId": vendorIdStr,"addedByUserId": userID,"productImages": prodImgArray,"purchaseDate":selectedDate,"vendorName":"","storageLocation":storagelocation1,"storageLocation1":storagelocation2,"storageLocation2":storagelocation3,"storageLocationId":storageLocationId,"storageLocation1Id":storageLocation1Id,"storageLocation2Id":storageLocation2Id,"isSelected":"0","expiryDate":expiryDate,"priceUnit":priceUnit,"unitPrice":unitPriceStr1,"orderId":orderStr]
            
            myProductArray.add(myDict)

            useProdTblView.reloadData()
        }
    }
    
    func parseShoppingCartData() {
        
        print("Shopping Cart is\(shoppingCartArray)")
        
        for i in 0..<shoppingCartArray.count {
           
            var myDict = NSMutableDictionary()
            
    //      var prodImgArray =
            var prodImgDict = NSMutableDictionary()

            let prodImgArray = NSMutableArray()
//            for _ in 0..<3 {
//
//                prodImgDict = ["productImage": "","productDisplayImage":"","productServerImage":"","isLocalImg":"1"]
//                prodImgArray.add(prodImgDict)
//            }
            
            var accountID = String()
            let defaults = UserDefaults.standard
            accountID = (defaults.string(forKey: "accountId") ?? "")
            print(accountID)
            
            var userID = String()
            userID = (defaults.string(forKey: "userID") ?? "")
            print(userID)
            print(prodImgArray)
            
            let dataDict = shoppingCartArray.object(at: i) as! NSDictionary
            
            let prodDetailsDict = dataDict.value(forKey: "productdetails") as! NSDictionary
            let productImgArray = prodDetailsDict.value(forKey: "productImages") as? NSArray ?? ["","",""]

            var prodImageDict = NSDictionary()

            if(productImgArray.count > 0){
                prodImageDict = productImgArray[0] as?
                    NSDictionary ?? ["":""]
            }
            
            for i in 0..<3 {

                var prodImageStr = ""
                
                if(i == 0){
                    prodImageStr = prodImageDict.value(forKey: "0") as? String ?? ""
                
                }else if(i == 1){
                    prodImageStr = prodImageDict.value(forKey: "1") as? String ?? ""

                }else{
                    prodImageStr = prodImageDict.value(forKey: "2") as? String ?? ""

                }
                
                let emptyData = NSData()
                
                let imgUrl:String = prodImageStr as String
                
                let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                    
                let imggg = Constants.BaseImageUrl + trimStr
                
//                let fileUrl = URL(string: imggg)
                
                let url:NSURL = NSURL(string : imggg)!
                //Now use image to create into NSData format
                let imageData:NSData = NSData.init(contentsOf: url as URL) ?? emptyData
                
                let base64ImageStr = imageData.base64EncodedString(options: .lineLength64Characters)

                
                prodImgDict = ["productImage": base64ImageStr,"productDisplayImage":prodImageStr,"productServerImage":"","isLocalImg":"0"]

                
                prodImgArray.add(prodImgDict)
            }
            
            let prodName = prodDetailsDict.value(forKey: "productName") as! String
            let prodUniqNum = prodDetailsDict.value(forKey: "productUniqueNumber") as! String
            let description = prodDetailsDict.value(forKey: "description") as! String
            
            var stockQuanStr = String()
            if let stockQuan = prodDetailsDict.value(forKey: "stockQuantity") as? Double {
                stockQuanStr = String(stockQuan)
            }
            else if let stockQuant = prodDetailsDict.value(forKey: "stockQuantity") as? Float{
                
                stockQuanStr = String(stockQuant)
            }
            else {
                
                stockQuanStr = prodDetailsDict.value(forKey: "stockQuantity") as? String ?? ""
            }
            
            var priceStr1 = String()
            if let priceStr = prodDetailsDict.value(forKey: "price") as? Double {
                
                priceStr1 = String(format:"%.2f", priceStr ?? 0)
            }
            else if let priceStr = prodDetailsDict.value(forKey: "price") as? Float{
                priceStr1 = String(format:"%.2f", priceStr ?? 0)
            }
            else {
                priceStr1 = prodDetailsDict.value(forKey: "price") as? String ?? ""
            }
            
            let stockUnitDetails=dataDict.value(forKey: "stockUnitDetails")as? NSArray
            var stockUnitStr = String()
            var stockUnitId = String()
            if stockUnitDetails?.count ?? 0>0
            {
            let stockUnitDetailsDic=stockUnitDetails?[0] as? NSDictionary
                stockUnitStr = stockUnitDetailsDic?.value(forKey: "stockUnitName") as? String ?? ""
                stockUnitId = stockUnitDetailsDic?.value(forKey: "_id") as? String ?? ""
            }
            else
            {
                stockUnitStr = ""
                stockUnitId = ""
            }
            let priceUnitDetails=dataDict.value(forKey: "priceUnitDetails")as? NSArray
            var priceUnit=String()
            if priceUnitDetails?.count ?? 0>0
            {
                let priceUnitDetailsDic=priceUnitDetails?[0] as? NSDictionary
                priceUnit=priceUnitDetailsDic?.value(forKey: "priceUnit") as? String ?? ""
            }
            else
            {
                priceUnit = ""
            }
            let storagelocationLevel1=dataDict.value(forKey: "storageLocationLevel1Details")as? NSArray
            let storagelocationLevel2=dataDict.value(forKey: "storageLocationLevel2Details")as? NSArray
            let storagelocationLevel3=dataDict.value(forKey: "storageLocationLevel3Details")as? NSArray
            var storagelocation1=String()
            var storagelocation2=String()
            var storagelocation3=String()
            var storageLocationId=String()
            var storageLocation1Id=String()
            var storageLocation2Id=String()
            
            if storagelocationLevel1?.count ?? 0>0
            {
                let storagelocationLevel1Dic=storagelocationLevel1?[0] as? NSDictionary
                storagelocation1 = storagelocationLevel1Dic?.value(forKey: "slocName") as? String ?? ""
                storageLocationId=storagelocationLevel1Dic?.value(forKey: "_id") as? String ?? ""
            }
            else
            {
                storagelocation1 = ""
            }
            if storagelocationLevel2?.count ?? 0>0
            {
                let storagelocationLevel2Dic=storagelocationLevel2?[0] as? NSDictionary
                storagelocation2 = storagelocationLevel2Dic?.value(forKey: "slocName") as? String ?? ""
                storageLocation1Id=storagelocationLevel2Dic?.value(forKey: "_id") as? String ?? ""
            }
            else
            {
                storagelocation2 = ""
            }
            if storagelocationLevel3?.count ?? 0>0
            {
                let storagelocationLevel3Dic=storagelocationLevel3?[0] as? NSDictionary
                storagelocation3 = storagelocationLevel3Dic?.value(forKey: "slocName") as? String ?? ""
                storageLocation2Id=storagelocationLevel3Dic?.value(forKey: "_id") as? String ?? ""
            }
            else
            {
                storagelocation3 = ""
            }
            
            let categoryStr = prodDetailsDict.value(forKey: "category") as! String
            let subCategoryStr = prodDetailsDict.value(forKey: "subCategory") as! String
            let vendorIdStr = prodDetailsDict.value(forKey: "vendorId") as! String
//            let addedUserID = ""
            
            let currentDate = Date()
            let eventDatePicker = UIDatePicker()
            
            eventDatePicker.datePickerMode = UIDatePicker.Mode.date
            eventDatePicker.minimumDate = currentDate
                   
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let selectedDate = convertDateFormatter(date: prodDetailsDict.value(forKey: "purchaseDate") as? String ?? "")
            
            let expiryDate = convertDateFormatter(date: prodDetailsDict.value(forKey: "expiryDate") as? String ?? "")
            var unitPriceStr1=String()
            if let unitPriceStr = prodDetailsDict.value(forKey: "unitPrice") as? Double {
                
                unitPriceStr1 = String(unitPriceStr)
            }
            else if let unitPriceStr = prodDetailsDict.value(forKey: "unitPrice") as? Int {
                unitPriceStr1 = String(unitPriceStr)
            }
            else {
                
                unitPriceStr1 = prodDetailsDict.value(forKey: "unitPrice") as? String ?? ""
            }
            let orderStr=prodDetailsDict.value(forKey: "orderId") as? String
            myDict  = ["accountId": accountID, "productName": prodName, "productUniqueNumber": prodUniqNum,"description": description,"stockQuantity": stockQuanStr,"stockUnit": stockUnitStr,"stockUnitId":stockUnitId,"price": priceStr1,"category": categoryStr,"subCategory": subCategoryStr,"vendorId": vendorIdStr,"addedByUserId": userID,"productImages": prodImgArray,"purchaseDate":selectedDate,"vendorName":"","storageLocation":storagelocation1,"storageLocation1":storagelocation2,"storageLocation2":storagelocation3,"storageLocationId":storageLocationId,"storageLocation1Id":storageLocation1Id,"storageLocation2Id":storageLocation2Id,"isSelected":"0","expiryDate":expiryDate,"priceUnit":priceUnit,"unitPrice":unitPriceStr1,"orderId":orderStr]
            
            myProductArray.add(myDict)

        }
        
        useProdTblView.reloadData()

    }
    
    func parseOpenOrdersData() {
        
        for i in 0..<self.openOrdersArray.count {
            
            let dataDict = self.openOrdersArray.object(at: i) as! NSDictionary
            let ordersListArr = dataDict.value(forKey: "ordersList") as! NSArray
            
            for j in 0..<ordersListArr.count {
                
                let innerDataDict = ordersListArr.object(at: j) as! NSDictionary
                
                let prodDetailsDict = innerDataDict.value(forKey: "productdetails") as! NSDictionary
                
                var myDict = NSMutableDictionary()
                
        //      var prodImgArray =
                var prodImgDict = NSMutableDictionary()

                let prodImgArray = NSMutableArray()
//                for _ in 0..<3 {
//
//                    prodImgDict = ["productImage": "","productDisplayImage":"","productServerImage":"","isLocalImg":"1"]
//                    prodImgArray.add(prodImgDict)
//                }
                
                let productImgArray = prodDetailsDict.value(forKey: "productImages") as? NSArray ?? ["","",""]

                var prodImageDict = NSDictionary()

                if(productImgArray.count > 0){
                    prodImageDict = productImgArray[0] as?
                        NSDictionary ?? ["":""]
                }
                
                for i in 0..<3 {

                    var prodImageStr = ""
                    
                    if(i == 0){
                        prodImageStr = prodImageDict.value(forKey: "0") as? String ?? ""
                    
                    }else if(i == 1){
                        prodImageStr = prodImageDict.value(forKey: "1") as? String ?? ""

                    }else{
                        prodImageStr = prodImageDict.value(forKey: "2") as? String ?? ""

                    }
                    
                    let emptyData = NSData()
                    
                    let imgUrl:String = prodImageStr as String
                    
                    let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                        
                    let imggg = Constants.BaseImageUrl + trimStr
                    
    //                let fileUrl = URL(string: imggg)
                    
                    let url:NSURL = NSURL(string : imggg)!
                    //Now use image to create into NSData format
                    let imageData:NSData = NSData.init(contentsOf: url as URL) ?? emptyData
                    
                    let base64ImageStr = imageData.base64EncodedString(options: .lineLength64Characters)

                    prodImgDict = ["productImage": base64ImageStr,"productDisplayImage":prodImageStr,"productServerImage":"","isLocalImg":"0"]

                    
                    prodImgArray.add(prodImgDict)
                }
                
                var accountID = String()
                let defaults = UserDefaults.standard
                accountID = (defaults.string(forKey: "accountId") ?? "")
                print(accountID)
                
                var userID = String()
                userID = (defaults.string(forKey: "userID") ?? "")

                let prodName = prodDetailsDict.value(forKey: "productName") as! String
                let prodUniqNum = prodDetailsDict.value(forKey: "productUniqueNumber") as! String
                let description = prodDetailsDict.value(forKey: "description") as! String
                
                var stockQuanStr = String()
                if let stockQuan = prodDetailsDict.value(forKey: "stockQuantity") as? Double {
                    stockQuanStr = String(stockQuan)
                }
                else if let stockQuant = prodDetailsDict.value(forKey: "stockQuantity") as? Float{
                    
                    stockQuanStr = String(stockQuant)
                }
                else {
                    
                    stockQuanStr = prodDetailsDict.value(forKey: "stockQuantity") as? String ?? ""
                }
                
                var priceStr1 = String()
                if let priceStr = prodDetailsDict.value(forKey: "price") as? Double {
                    
                    priceStr1 = String(format:"%.2f", priceStr ?? 0)
                }
                else if let priceStr = prodDetailsDict.value(forKey: "price") as? Float{
                    priceStr1 = String(format:"%.2f", priceStr ?? 0)
                }
                else {
                    priceStr1 = prodDetailsDict.value(forKey: "price") as? String ?? ""
                }
                var unitPriceStr1=String()
                if let unitPriceStr = prodDetailsDict.value(forKey: "unitPrice") as? Double {
                    
                    unitPriceStr1 = String(unitPriceStr)
                }
                else if let unitPriceStr = prodDetailsDict.value(forKey: "unitPrice") as? Int {
                    unitPriceStr1 = String(unitPriceStr)
                }
                else {
                    
                    unitPriceStr1 = prodDetailsDict.value(forKey: "unitPrice") as? String ?? ""
                }
                let stockUnitDetails=innerDataDict.value(forKey: "stockUnitDetails")as? NSArray
                var stockUnitStr = String()
                var stockUnitId = String()
                if stockUnitDetails?.count ?? 0>0
                {
                let stockUnitDetailsDic=stockUnitDetails?[0] as? NSDictionary
                    stockUnitStr = stockUnitDetailsDic?.value(forKey: "stockUnitName") as? String ?? ""
                    stockUnitId = stockUnitDetailsDic?.value(forKey: "_id") as? String ?? ""
                }
                else
                {
                    stockUnitStr = ""
                    stockUnitId = ""
                }
                let priceUnitDetails=innerDataDict.value(forKey: "priceUnitDetails")as? NSArray
                var priceUnit=String()
                if priceUnitDetails?.count ?? 0>0
                {
                    let priceUnitDetailsDic=priceUnitDetails?[0] as? NSDictionary
                    priceUnit=priceUnitDetailsDic?.value(forKey: "priceUnit") as? String ?? ""
                }
                else
                {
                    priceUnit = ""
                }
                let storagelocationLevel1=innerDataDict.value(forKey: "storageLocationLevel1Details")as? NSArray
                let storagelocationLevel2=innerDataDict.value(forKey: "storageLocationLevel2Details")as? NSArray
                let storagelocationLevel3=innerDataDict.value(forKey: "storageLocationLevel3Details")as? NSArray
                var storagelocation1=String()
                var storagelocation2=String()
                var storagelocation3=String()
                var storageLocationId=String()
                var storageLocation1Id=String()
                var storageLocation2Id=String()
                
                if storagelocationLevel1?.count ?? 0>0
                {
                    let storagelocationLevel1Dic=storagelocationLevel1?[0] as? NSDictionary
                    storagelocation1 = storagelocationLevel1Dic?.value(forKey: "slocName") as? String ?? ""
                    storageLocationId=storagelocationLevel1Dic?.value(forKey: "_id") as? String ?? ""
                }
                else
                {
                    storagelocation1 = ""
                }
                if storagelocationLevel2?.count ?? 0>0
                {
                    let storagelocationLevel2Dic=storagelocationLevel2?[0] as? NSDictionary
                    storagelocation2 = storagelocationLevel2Dic?.value(forKey: "slocName") as? String ?? ""
                    storageLocation1Id=storagelocationLevel2Dic?.value(forKey: "_id") as? String ?? ""
                }
                else
                {
                    storagelocation2 = ""
                }
                if storagelocationLevel3?.count ?? 0>0
                {
                    let storagelocationLevel3Dic=storagelocationLevel3?[0] as? NSDictionary
                    storagelocation3 = storagelocationLevel3Dic?.value(forKey: "slocName") as? String ?? ""
                    storageLocation2Id=storagelocationLevel3Dic?.value(forKey: "_id") as? String ?? ""
                }
                else
                {
                    storagelocation3 = ""
                }
                
                let categoryStr = prodDetailsDict.value(forKey: "category") as! String
                let subCategoryStr = prodDetailsDict.value(forKey: "subCategory") as! String
                let vendorIdStr = prodDetailsDict.value(forKey: "vendorId") as! String
    //            let addedUserID = ""
                let purchaseDate = convertDateFormatter(date: prodDetailsDict.value(forKey: "purchaseDate") as? String ?? "")
                let storageLoc = prodDetailsDict.value(forKey: "storageLocation") as? String ?? ""

                let expiryDate = convertDateFormatter(date: prodDetailsDict.value(forKey: "expiryDate") as? String ?? "")
let orderStr=prodDetailsDict.value(forKey: "orderId") as? String
                
                myDict  = ["accountId": accountID, "productName": prodName, "productUniqueNumber": prodUniqNum,"description": description,"stockQuantity": stockQuanStr,"stockUnit": stockUnitStr,"stockUnitId":stockUnitId,"price": priceStr1,"category": categoryStr,"subCategory": subCategoryStr,"vendorId": vendorIdStr,"addedByUserId": userID,"productImages": prodImgArray,"purchaseDate":purchaseDate ?? "","vendorName":"","storageLocation":storagelocation1,"storageLocation1":storagelocation2,"storageLocation2":storagelocation3,"storageLocationId":storageLocationId,"storageLocation1Id":storageLocation1Id,"storageLocation2Id":storageLocation2Id,"isSelected":"0","expiryDate":expiryDate as Any,"priceUnit":priceUnit,"unitPrice":unitPriceStr1,"orderId":orderStr]
                
                myProductArray.add(myDict)

            }
        }
        
        useProdTblView.reloadData()

    }
    
    func parseOrdersHistoryData() {
        
        for i in 0..<self.openOrdersResultArray.count {
            
            let dataDict = self.openOrdersResultArray.object(at: i) as! NSDictionary
            let ordersListArr = dataDict.value(forKey: "ordersList") as! NSArray
            
            for j in 0..<ordersListArr.count {
                
                let innerDataDict = ordersListArr.object(at: j) as! NSDictionary
                
                let prodDetailsDict = innerDataDict.value(forKey: "productdetails") as! NSDictionary
                
                var myDict = NSMutableDictionary()
                
        //      var prodImgArray =
                var prodImgDict = NSMutableDictionary()

                let prodImgArray = NSMutableArray()
//                for _ in 0..<3 {
//
//                    prodImgDict = ["productImage": "","productDisplayImage":"","productServerImage":"","isLocalImg":"1"]
//                    prodImgArray.add(prodImgDict)
//                }
                
                let productImgArray = prodDetailsDict.value(forKey: "productImages") as? NSArray ?? ["","",""]
                var prodImageDict = NSDictionary()

                if(productImgArray.count > 0){
                    prodImageDict = productImgArray[0] as?
                        NSDictionary ?? ["":""]
                }
                
                for i in 0..<3 {

                    var prodImageStr = ""
                    
                    if(i == 0){
                        prodImageStr = prodImageDict.value(forKey: "0") as? String ?? ""
                    
                    }else if(i == 1){
                        prodImageStr = prodImageDict.value(forKey: "1") as? String ?? ""

                    }else{
                        prodImageStr = prodImageDict.value(forKey: "2") as? String ?? ""

                    }
                    
                    let emptyData = NSData()
                    
                    let imgUrl:String = prodImageStr as String
                    
                    let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                        
                    let imggg = Constants.BaseImageUrl + trimStr
                    
    //                let fileUrl = URL(string: imggg)
                    
                    let url:NSURL = NSURL(string : imggg)!
                    //Now use image to create into NSData format
                    let imageData:NSData = NSData.init(contentsOf: url as URL) ?? emptyData
                    
                    let base64ImageStr = imageData.base64EncodedString(options: .lineLength64Characters)

                    
                    prodImgDict = ["productImage": base64ImageStr,"productDisplayImage":prodImageStr,"productServerImage":"","isLocalImg":"0"]
                    
                    prodImgArray.add(prodImgDict)
                }
                
                var accountID = String()
                let defaults = UserDefaults.standard
                accountID = (defaults.string(forKey: "accountId") ?? "")
                print(accountID)
                
                var userID = String()
                userID = (defaults.string(forKey: "userID") ?? "")

                let prodName = prodDetailsDict.value(forKey: "productName") as! String
                let prodUniqNum = prodDetailsDict.value(forKey: "productUniqueNumber") as! String
                let description = prodDetailsDict.value(forKey: "description") as! String
                
                var stockQuanStr = String()
                if let stockQuan = prodDetailsDict.value(forKey: "stockQuantity") as? Double {
                    stockQuanStr = String(stockQuan)
                }
                else if let stockQuant = prodDetailsDict.value(forKey: "stockQuantity") as? Float{
                    
                    stockQuanStr = String(stockQuant)
                }
                else {
                    
                    stockQuanStr = prodDetailsDict.value(forKey: "stockQuantity") as? String ?? ""
                }
                
                var priceStr1 = String()
                if let priceStr = prodDetailsDict.value(forKey: "price") as? Double {
                    
                    priceStr1 = String(format:"%.2f", priceStr ?? 0)
                }
                else if let priceStr = prodDetailsDict.value(forKey: "price") as? Float{
                    priceStr1 = String(format:"%.2f", priceStr ?? 0)
                }
                else {
                    priceStr1 = prodDetailsDict.value(forKey: "price") as? String ?? ""
                }
                
                let stockUnitDetails=innerDataDict.value(forKey: "stockUnitDetails")as? NSArray
                var stockUnitStr = String()
                var stockUnitId = String()
                if stockUnitDetails?.count ?? 0>0
                {
                let stockUnitDetailsDic=stockUnitDetails?[0] as? NSDictionary
                    stockUnitStr = stockUnitDetailsDic?.value(forKey: "stockUnitName") as? String ?? ""
                    stockUnitId = stockUnitDetailsDic?.value(forKey: "_id") as? String ?? ""
                }
                else
                {
                    stockUnitStr = ""
                    stockUnitId = ""
                }
                let priceUnitDetails=innerDataDict.value(forKey: "priceUnitDetails")as? NSArray
                var priceUnit=String()
                if priceUnitDetails?.count ?? 0>0
                {
                    let priceUnitDetailsDic=priceUnitDetails?[0] as? NSDictionary
                    priceUnit=priceUnitDetailsDic?.value(forKey: "priceUnit") as? String ?? ""
                }
                else
                {
                    priceUnit = ""
                }
                let storagelocationLevel1=innerDataDict.value(forKey: "storageLocationLevel1Details")as? NSArray
                let storagelocationLevel2=innerDataDict.value(forKey: "storageLocationLevel2Details")as? NSArray
                let storagelocationLevel3=innerDataDict.value(forKey: "storageLocationLevel3Details")as? NSArray
                var storagelocation1=String()
                var storagelocation2=String()
                var storagelocation3=String()
                var storageLocationId=String()
                var storageLocation1Id=String()
                var storageLocation2Id=String()
                
                if storagelocationLevel1?.count ?? 0>0
                {
                    let storagelocationLevel1Dic=storagelocationLevel1?[0] as? NSDictionary
                    storagelocation1 = storagelocationLevel1Dic?.value(forKey: "slocName") as? String ?? ""
                    storageLocationId=storagelocationLevel1Dic?.value(forKey: "_id") as? String ?? ""
                }
                else
                {
                    storagelocation1 = ""
                }
                if storagelocationLevel2?.count ?? 0>0
                {
                    let storagelocationLevel2Dic=storagelocationLevel2?[0] as? NSDictionary
                    storagelocation2 = storagelocationLevel2Dic?.value(forKey: "slocName") as? String ?? ""
                    storageLocation1Id=storagelocationLevel2Dic?.value(forKey: "_id") as? String ?? ""
                }
                else
                {
                    storagelocation2 = ""
                }
                if storagelocationLevel3?.count ?? 0>0
                {
                    let storagelocationLevel3Dic=storagelocationLevel3?[0] as? NSDictionary
                    storagelocation3 = storagelocationLevel3Dic?.value(forKey: "slocName") as? String ?? ""
                    storageLocation2Id=storagelocationLevel3Dic?.value(forKey: "_id") as? String ?? ""
                }
                else
                {
                    storagelocation3 = ""
                }
                
                let categoryStr = prodDetailsDict.value(forKey: "category") as! String
                let subCategoryStr = prodDetailsDict.value(forKey: "subCategory") as! String
                let vendorIdStr = prodDetailsDict.value(forKey: "vendorId") as! String
    //            let addedUserID = ""
                let purchaseDate = convertDateFormatter(date: prodDetailsDict.value(forKey: "purchaseDate") as? String ?? "")
                let storageLoc = prodDetailsDict.value(forKey: "storageLocation") as? String ?? ""

                let expiryDate = convertDateFormatter(date: prodDetailsDict.value(forKey: "expiryDate") as? String ?? "")
                var unitPriceStr1=String()
                if let unitPriceStr = prodDetailsDict.value(forKey: "unitPrice") as? Double {
                    
                    unitPriceStr1 = String(unitPriceStr)
                }
                else if let unitPriceStr = prodDetailsDict.value(forKey: "unitPrice") as? Int {
                    unitPriceStr1 = String(unitPriceStr)
                }
                else {
                    
                    unitPriceStr1 = prodDetailsDict.value(forKey: "unitPrice") as? String ?? ""
                }
                
                let orderStr=prodDetailsDict.value(forKey: "orderId") as? String
                myDict  = ["accountId": accountID, "productName": prodName, "productUniqueNumber": prodUniqNum,"description": description,"stockQuantity": stockQuanStr,"stockUnit": stockUnitStr,"stockUnitId":stockUnitId,"price": priceStr1,"category": categoryStr,"subCategory": subCategoryStr,"vendorId": vendorIdStr,"addedByUserId": userID,"productImages": prodImgArray,"purchaseDate":purchaseDate,"vendorName":"","storageLocation":storagelocation1,"storageLocation1":storagelocation2,"storageLocation2":storagelocation3,"storageLocationId":storageLocationId,"storageLocation1Id":storageLocation1Id,"storageLocation2Id":storageLocation2Id,"isSelected":"0","expiryDate":expiryDate,"priceUnit":priceUnit,"unitPrice":unitPriceStr1,"orderId":orderStr]
                
                myProductArray.add(myDict)

            }
        }
        
        print(myProductArray)
        
        useProdTblView.reloadData()

    }
}
