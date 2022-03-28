//
//  ProductSummaryViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 09/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductSummaryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var selectedCategoriesIdArray = NSMutableArray()
    var finalAddProductsArray = NSMutableArray()
    var fromView = String()
    var isSelectAll:Bool = false
    @IBOutlet weak var selectAllBtn: UIButton!
    
    @IBAction func selectAllBtnTap(_ sender: UIButton) {
        
        if isSelectAll == false {
            isSelectAll = true
            
            for i in 0..<myProductsArray.count {

                let dataDict = myProductsArray.object(at:i) as! NSDictionary
                
    //            var isSelectStr = dataDict.value(forKey: "isSelected") as! String
    //
    //            if(isSelectStr == "1"){
    //                isSelectStr = "0"
    //
    //            }else{
    //                isSelectStr = "1"
    //            }

                dataDict.setValue("1", forKey: "isSelected")
                myProductsArray.replaceObject(at: i, with: dataDict)
                
                let catID = dataDict.value(forKey: "itemNumber") as? Int
                selectedCategoriesIdArray.add(catID ?? "")

            }
            summaryTblView.reloadData()
        }
        else{
            isSelectAll = false
            for i in 0..<myProductsArray.count {

                let dataDict = myProductsArray.object(at:i) as! NSDictionary
                
    //            var isSelectStr = dataDict.value(forKey: "isSelected") as! String
    //
    //            if(isSelectStr == "1"){
    //                isSelectStr = "0"
    //
    //            }else{
    //                isSelectStr = "1"
    //            }

                dataDict.setValue("0", forKey: "isSelected")
                myProductsArray.replaceObject(at: i, with: dataDict)
                let catID = dataDict.value(forKey: "itemNumber") as? Int
                selectedCategoriesIdArray.remove(catID ?? "")

            }
            summaryTblView.reloadData()
        }
    }
    
    @IBAction func deleteBtnTap(_ sender: Any) {
        
        
          for i in 0..<myProductsArray.count {

            let dataDict = myProductsArray[i] as! NSDictionary
            let categoryID = dataDict.value(forKey: "categoryId") as! String

            for j in 0..<selectedCategoriesIdArray.count {
        
                let innerCatID = selectedCategoriesIdArray[j] as! String
                
                if(categoryID == innerCatID){
                    myProductsArray.removeObject(at: i)
                    break
                }
            }
            
        }
        
//        print(myProductsArray)
    }
    
    
    @IBAction func homeBtnTapped(_ sender: Any) {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
            self.navigationController?.pushViewController(VC, animated: true)

        }
    
    var productSummaryCntrl = ServiceController()
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func backBtnTap(_ sender: Any) {
        
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }
    func removeProductImage(productArray:NSMutableArray)->NSMutableArray  {
        
        
            var prodArray = NSMutableArray()
            
            prodArray = productArray
            
        
            for j in 0..<prodArray.count {

                var prodDict = NSMutableDictionary()
                prodDict = prodArray[j] as! NSMutableDictionary
                
                prodDict.removeObject(forKey: "productDisplayImage")
                if fromView=="vendor"
                {
                    prodDict.removeObject(forKey: "isLocalImg")
                }
                prodArray.replaceObject(at: j, with: prodDict)
                
            }
          return prodArray
    }
    @IBAction func submitBtnTap(_ sender: Any) {
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        if(selectedCategoriesIdArray.count == 0){
            showAlert(title: "Alert", message: "Please select atleast one product")
            return
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
        }
        
        for i in 0..<selectedCategoriesIdArray.count {
            
            let selectedCatId = selectedCategoriesIdArray.object(at: i) as? Int
            
           
                if fromView=="vendor"
                {
                    for j in 0..<myProductsArray.count {

                        let dataDict = myProductsArray.object(at: j) as! NSDictionary
                        let itemNum = dataDict.value(forKey: "itemNumber") as? Int
                        var datafinalDict=NSMutableDictionary()
                    var prodImgDict = NSMutableDictionary()

                    let prodImgArray = NSMutableArray()
                    for _ in 0..<8 {

                        prodImgDict = ["productImage": ""]
                        prodImgArray.add(prodImgDict)
                    }
                       
                datafinalDict = [
                    "accountId":dataDict.value(forKey: "accountId") as Any,
                     "actualPrice":dataDict.value(forKey: "price"),
                     "actualUnitPrice":dataDict.value(forKey: "unitPrice"),
                    "category":dataDict.value(forKey: "category") as Any,
                    "description":dataDict.value(forKey: "description") as Any,
                    "doorDelivery":dataDict.value(forKey: "doorDelivery") as? Bool ?? false,
                    "expiryDate":dataDict.value(forKey: "expiryDate") as Any,
                    "keyWords":dataDict.value(forKey: "keyWords") as? String ?? "",
                    "offeredPrice":dataDict.value(forKey: "price"),
                    "offeredUnitPrice":dataDict.value(forKey: "offeredUnitPrice") as Any,
                    "orderId":dataDict.value(forKey: "orderId"),
                    "priceUnit":dataDict.value(forKey: "priceUnitId") as Any,
                    "productUniqueId":dataDict.value(forKey: "productUniqueNumber"),
                    "productImages":self.removeProductImage(productArray: dataDict.value(forKey: "productImages") as! NSMutableArray),
                    "productName":dataDict.value(forKey: "productName") as Any,
                    "purchaseDate":dataDict.value(forKey: "purchaseDate") as Any,
                    "stockQuantity":dataDict.value(forKey: "stockQuantity") as Any,
                    "stockUnit":dataDict.value(forKey: "stockUnitId"),
                    "subCategory":dataDict.value(forKey: "subCategory") as Any,
                    "vendor":dataDict.value(forKey: "vendorId") as Any,
                    "vendorProductImages":[],"vendorDetails":dataDict.value(forKey: "vendorDetails") as Any]
                        if dataDict.value(forKey: "storageLocation2Id") as? String == ""
                        {
                        }
                        else
                        {
                            datafinalDict.setValue(dataDict.value(forKey: "storageLocation2Id") as Any, forKey: "storageLocation3")
                        }
                        if dataDict.value(forKey: "storageLocation1Id") as? String == ""
                        {
                        }
                        else
                        {
                            datafinalDict.setValue(dataDict.value(forKey: "storageLocation1Id") as Any, forKey: "storageLocation2")
                        }
                        if dataDict.value(forKey: "storageLocationId") as? String == ""
                        {
                        }
                        else
                        {
                            datafinalDict.setValue(dataDict.value(forKey: "storageLocationId") as Any, forKey: "storageLocation1")
                            datafinalDict.setValue(dataDict.value(forKey: "storageLocationId") as Any, forKey: "storageLocation")
                        }
                if(selectedCatId == itemNum){
                    finalAddProductsArray.add(datafinalDict)
                    break
                    
                }
                    }
                }
                else
                {
                    var finalInventory = NSMutableArray()
                    
                    var prodImgDict = NSMutableDictionary()
                    let prodImgArray = NSMutableArray()
                    for _ in 0..<3 {

                        prodImgDict = ["productImage": ""]
                        prodImgArray.add(prodImgDict)
                    }
                    
                    var mainDictionary = [String:NSMutableArray]()
                    var keyString = [String]()
                    for j in 0..<myProductsArray.count {
                     
                        let selectDict=myProductsArray.object(at: j) as! NSDictionary
                        let vendorID=selectDict.value(forKey: "vendorId")as? String ?? ""
                        let purchaseDate=selectDict.value(forKey: "purchaseDate")as? String ?? ""
                        let orderId=selectDict.value(forKey: "orderId")as? String ?? ""
                        let key:String = vendorID + "&&" + purchaseDate + "&&" + orderId
                        var changedDictionary=NSMutableDictionary()
                        let userDefaults = UserDefaults.standard
                        let userID = userDefaults.value(forKey: "userID") as! String
                        changedDictionary = [
                    "accountId":selectDict.value(forKey: "accountId") as Any,
                    "category":selectDict.value(forKey: "category") as Any,
                    "description":selectDict.value(forKey: "description") as Any,
                    "expiryDate":selectDict.value(forKey: "expiryDate") as Any,
                    "orderId":selectDict.value(forKey: "orderId"),
                    "price":selectDict.value(forKey: "price") as Any,
                    "priceUnit":"616fd4205041085a07d69b1a",
                    "productUniqueNumber":selectDict.value(forKey: "productUniqueNumber"),
                     "productImages":self.removeProductImage(productArray: selectDict.value(forKey: "productImages") as! NSMutableArray),
                    "productName":selectDict.value(forKey: "productName") as Any,
                    "purchaseDate":selectDict.value(forKey: "purchaseDate") as Any,
                    "stockQuantity":selectDict.value(forKey: "stockQuantity") as Any,
                    "stockUnit":selectDict.value(forKey: "stockUnitId"),
//                    "storageLocation":selectDict.value(forKey: "storageLocationId") as Any,
//                    "storageLocation1":selectDict.value(forKey: "storageLocationId") as Any,
//                     "storageLocation2":selectDict.value(forKey: "storageLocation1Id") as Any,
                    "subCategory":selectDict.value(forKey: "subCategory") as Any,
                    "unitPrice":selectDict.value(forKey: "unitPrice") as Any,
                    "productDetailsFound" : false,
                    "uploadType":"manual",
                    "userId":userID as Any,
                    "vendorId":selectDict.value(forKey: "vendorId") as Any,
                    "vendorName":selectDict.value(forKey: "vendorName") as Any]
                        if selectDict.value(forKey: "storageLocation2Id") as? String == ""
                        {
                        }
                        else
                        {
                            changedDictionary.setValue(selectDict.value(forKey: "storageLocation2Id") as Any, forKey: "storageLocation3")
                        }
                        if selectDict.value(forKey: "storageLocation1Id") as? String == ""
                        {
                        }
                        else
                        {
                            changedDictionary.setValue(selectDict.value(forKey: "storageLocation1Id") as Any, forKey: "storageLocation2")
                        }
                        if selectDict.value(forKey: "storageLocationId") as? String == ""
                        {
                        }
                        else
                        {
                            changedDictionary.setValue(selectDict.value(forKey: "storageLocationId") as Any, forKey: "storageLocation1")
                            changedDictionary.setValue(selectDict.value(forKey: "storageLocationId") as Any, forKey: "storageLocation")
                        }
                        if keyString.contains(key)
                        {
                            var addProductArray=NSMutableArray()
                            addProductArray=mainDictionary[key] ?? NSMutableArray()
                            addProductArray.add(changedDictionary)
                            mainDictionary[key]=addProductArray
                        }
                        else
                        {
                            keyString.append(key)
                            let addProductArray=NSMutableArray()
                            addProductArray.add(changedDictionary)
                            mainDictionary[key]=addProductArray
                        }
                    }
                   print(mainDictionary)
                    
                    let jsonArray=NSMutableArray()
                    for k in 0..<keyString.count
                    {
                        let jsonObject=NSMutableDictionary()
                        let dddd=mainDictionary[keyString[k]] as? NSMutableArray
                        jsonObject["vendorId"]=(dddd?[0] as AnyObject).value(forKey: "vendorId")
                        jsonObject["accountId"]=(dddd?[0] as AnyObject).value(forKey: "accountId")
                        jsonObject["addproductList"]=dddd
                        jsonArray.add(jsonObject)
                    }
                    print(jsonArray.count)
                    

                    finalAddProductsArray=jsonArray
                }
            }
        
        
        print("Final Add Arr is\(finalAddProductsArray.count)")
        self.callAddProductsAPI()
    }
    
    var myProductsArray = NSMutableArray()
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var summaryTblView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        myProductsArray = UserDefaults.standard.array(forKey: "ProductArray") as! NSMutableArray
        
//        let data = Data()
        
//        let defaults = UserDefaults.standard
//        let decoded  = defaults.data(forKey: "ProductArray")
//        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded ?? data) as! [NSMutableArray]
//        print(decodedTeams)
        
//        let placesData = UserDefaults.standard.object(forKey: "places") as? NSData
//        let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as! Data) as? [NSMutableArray]
//        print(placesArray as Any)
        
        animatingView()
        
//        let addProdVC = AddProductViewController()
//        myProductsArray = addProdVC.myProductArray

//        let defaults = UserDefaults.standard
//        let array = defaults.object(forKey: "ProductArray") as? [NSMutableArray] ?? [NSMutableArray]()
//        print(array)
        
        myProductsArray = myAppDelegate.myProductsArray
//        print(myProductsArray)
        
        summaryTblView.delegate = self
        summaryTblView.dataSource = self
        summaryTblView.reloadData()

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
    
    //****************** TableView Delegate Methods*************************//
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return myProductsArray.count
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = summaryTblView.dequeueReusableCell(withIdentifier: "ProductSummaryCell", for: indexPath) as! ProductSummaryTableViewCell
        
        let itemNum = indexPath.row + 1 as Int?
//        let stringValue = (String(describing: itemNum))
        
        let dict = myProductsArray[indexPath.row] as! NSDictionary
        
        cell.itemNumLbl.text = String(itemNum!)
        cell.productNameLbl.text = dict.value(forKey: productName) as? String ?? "-"
        cell.orderIdLbl.text = dict.value(forKey: "orderId") as? String ?? "-"
        cell.vendorIdLbl.text = dict.value(forKey: "vendorName") as? String ?? "-"
        
        cell.checkBoxBtn.addTarget(self, action: #selector(selectDeselectProductBtnTap), for: .touchUpInside)
        cell.checkBoxBtn.tag = indexPath.row
        
        let isSelected = dict.value(forKey:"isSelected") as! String
        
        if(isSelected == "1"){
            cell.checkBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
        }else{
            cell.checkBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)

        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    
    }
    
    @IBAction func selectDeselectProductBtnTap(_ sender: UIButton){
        
//        let dataDict = myProductsArray.object(at:sender.tag) as! NSDictionary
//
//        var isSelectStr = dataDict.value(forKey: "isSelected") as! String
//
//        if(isSelectStr == "1"){
//            isSelectStr = "0"
//
//        }else{
//            isSelectStr = "1"
//        }
//
//        dataDict.setValue(isSelectStr, forKey: "isSelected")
//        myProductsArray.replaceObject(at: sender.tag, with: dataDict)
        
        let dict = myProductsArray[sender.tag] as! NSDictionary
        let catID = dict.value(forKey: "itemNumber") as? Int
        
        if sender.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
            sender.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
            selectedCategoriesIdArray.add(catID ?? "")

        }else{
            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
            selectedCategoriesIdArray.remove(catID ?? "")
        }
    }
    
    
    
//    {
//    "accountId": "5f4c8f7e1f782915c50383fd",
//     "productName": "dsfs",
//     "productUniqueNumber": "56498456156496564561564",
//     "description": "sxzczcz",
//     "stockQuantity": "10",
//     "stockUnit": "kgs",
//     "purchaseDate": "2020-08-08",
//     "expiryDate": "2020-08-31",
//     "storageLocation": "dsfs",
//     "borrowed": "yes ",
//     "category": "dfgdg",
//     "subCategory": "sadd",
//     "orderId": "ewewsdf",
//     "vendorId": "sds",
//     "price": "234",
//     "uploadType":"scan",
//     "userId":"5f3a6361a2bab75afd9e9990",thumbNailImage:"base64url"
//     "productImages":[{"productImage":"bas64url"},{"productImage":"bas64url"},{"productImage":"bas64url"}]
//     }

    
    func callAddProductsAPI() {
        
        

                activity.startAnimating()
                self.view.isUserInteractionEnabled = false
        if fromView=="vendor"
        {
                let URLString_loginIndividual = Constants.BaseUrl + addVendorProductUrl
            let postHeaders_IndividualLogin = ["":""]
                productSummaryCntrl.requestPOSTURLWithArray(strURL: URLString_loginIndividual as NSString, postParams: finalAddProductsArray as NSArray, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                                
                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
                                    if(statusCode == 200 ){
                             
                                        self.showSucessMsg()
                                        
                                      // self.showAlertWith(title: "Success", message: "Product added successfully")
                                        
                                    }else{
                                        
                                        self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                        
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
        else
        {
                let URLString_loginIndividual = Constants.BaseUrl + AddCurrentInventoryUrl
                 
                            let params_IndividualLogin = [
                                "" : ""
                            ]
                        
//                            print(params_IndividualLogin)
                        
                            let postHeaders_IndividualLogin = ["":""]
                            
                productSummaryCntrl.requestPOSTURLWithArray(strURL: URLString_loginIndividual as NSString, postParams: finalAddProductsArray as NSArray, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                                
                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    barcodeCurrentList=[String]()
                                    if(statusCode == 200 ){
                             
                                        self.showSucessMsg()
                                        
//                                        self.showAlertWith(title: "Success", message: "Product added successfully")
                                        
                                    }else{
                                        
                                        self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                        
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
//            }

            //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
//            var json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]


//        } catch {
//            print(error.description)
//        }
    }
    
    func showSucessMsg()  {
        
                let alertController = UIAlertController(title: "Success", message:"Product added successfully" , preferredStyle: .alert)
                //to change font of title and message.
                let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
                let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Success", attributes: titleFont)
                let messageAttrString = NSMutableAttributedString(string: "Product added successfully", attributes: messageFont)
                alertController.setValue(titleAttrString, forKey: "attributedTitle")
                alertController.setValue(messageAttrString, forKey: "attributedMessage")
                
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    if self.fromView=="vendor" {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                              let VC = storyBoard.instantiateViewController(withIdentifier: "VendorProductListViewController") as! VendorProductListViewController
                              VC.modalPresentationStyle = .fullScreen
    //                          self.present(VC, animated: true, completion: nil)
                        self.navigationController?.pushViewController(VC, animated: true)
                        
                    }
                    else {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                          let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
                          VC.modalPresentationStyle = .fullScreen
//                          self.present(VC, animated: true, completion: nil)
                    self.navigationController?.pushViewController(VC, animated: true)
                    }
                   
                })
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)

    }
    
    func showAlert(title:String,message:String)  {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)

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


}


