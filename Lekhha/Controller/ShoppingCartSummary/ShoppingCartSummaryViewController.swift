//
//  ShoppingCartSummaryViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 16/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper

class ShoppingCartSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func homeBtnTap(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    var shoppingServiceCntrl = ServiceController()
    var accountID = String()
    var shoppingCartResult = [ShoppingCartResult]()
    var prodSelectedArray = NSMutableArray()
    var mainSelectedArray=NSMutableArray()
    
    var vendorIDArray = NSMutableArray()
    var cartIDArray = NSMutableArray()
    var parsedFinalProdArray = NSMutableArray()

    var shoppingCartResultDataArray = NSMutableArray()

    @IBOutlet weak var backBtnTap: UIButton!
    
    
    @IBAction func backBtnTap(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func selectAllBtnTap(_ sender: UIButton) {
        
        vendorIDArray.removeAllObjects()
        vendorIDArray = NSMutableArray()
        
        cartIDArray.removeAllObjects()
        cartIDArray = NSMutableArray()
        
        mainSelectedArray.removeAllObjects()
        mainSelectedArray = NSMutableArray()
        prodSelectedArray.removeAllObjects()
        prodSelectedArray = NSMutableArray()
        
        for i in 0..<shoppingCartResult.count {
            
            var idStr : NSString!
            idStr = shoppingCartResult[i]._id! as NSString

            var vendorIDStr : NSString!
            vendorIDStr = (shoppingCartResult[i].productDict?.vendorId ?? "") as NSString
            
            if shoppingCartResult[i].productDict?.unitPrice as? Float==0.0
            {
                self.priceArray.append(true)
            }
            else
            {
                self.priceArray.append(false)
            }
            
            var prodDict = NSMutableDictionary()
            prodDict = ["cartId": idStr!,"vendorId":vendorIDStr!]
            
//            let dict = prodSelectedArray[i] as! NSMutableDictionary
//            let idInner = dict.value(forKey: "cartId") as! NSString
            prodSelectedArray.add(prodDict)
            mainSelectedArray.add(shoppingCartResult[i])
            vendorIDArray.add(vendorIDStr!)
            cartIDArray.add(idStr!)

        }
        
        summaryTblView.reloadData()
    }
    var priceArray=[Bool]()
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        print(vendorIDArray)
        print(shoppingCartResultDataArray)
        
        let uniqueUnordered = Array(Set(arrayLiteral: vendorIDArray))
        let uniqueOrdered = Array(NSOrderedSet(array: vendorIDArray as! [Any]))
        
        let uniqueUnorderedCartID = Array(Set(arrayLiteral: cartIDArray))
        let uniqueOrderedCartID = Array(NSOrderedSet(array: cartIDArray as! [Any]))

        print(uniqueUnordered)
        print(uniqueOrdered)
        
        if(prodSelectedArray.count == 0){
            self.showAlertWith(title: "ALert", message: "Please select atleast one product")
        }
        if priceArray.contains(true)
        {
            self.view.makeToast("Please enter a preferred price to purchase from the preferred vendor")
        }
        else
        {
        var keyString = [String]()
        var mainDictionary = [String:NSMutableArray]()
        let orderDetails = NSMutableArray()
        let parsedFinalDict = NSMutableDictionary()
        for i in 0..<mainSelectedArray.count {
            
            for j in 0..<shoppingCartResultDataArray.count
            {
                
            let vendorMainDict = mainSelectedArray[i] as! ShoppingCartResult
                let uniqueId=vendorMainDict._id as? String ?? ""
                let vendorDict=shoppingCartResultDataArray[j] as? NSMutableDictionary
                if uniqueId==vendorDict?.value(forKey: "_id") as! String
                {
            var purchaseDate=String()
            var vendorrId=String()
            
            if let productDetails=vendorDict?.value(forKey: "productdetails") as? NSMutableDictionary
            {
                purchaseDate=vendorDict?.value(forKey: "plannedPurchasedate")as? String ?? ""
                vendorrId=productDetails.value(forKey: "vendorId")as? String ?? ""
            }
            let key:String = vendorrId + "&&" + purchaseDate
            if keyString.contains(key)
            {
                let prodDict = vendorDict?.value(forKey: "productdetails") as? NSMutableDictionary
                prodDict?.setValue("Ordered", forKey: "productStatus")
                vendorDict?.setValue(prodDict, forKey: "productdetails")
                vendorDict?.setValue(false, forKey: "isChecked")
                vendorDict?.setValue(vendorDict?.value(forKey: "requiredQuantity"), forKey: "updatingQuantity")
                var addProductArray=NSMutableArray()
                addProductArray=mainDictionary[key] ?? NSMutableArray()
                addProductArray.add(vendorDict)
                mainDictionary[key]=addProductArray
                orderDetails.add(vendorDict)
            }
            else
            {
                keyString.append(key)
                let prodDict = vendorDict?.value(forKey: "productdetails") as? NSMutableDictionary
                prodDict?.setValue("Ordered", forKey: "productStatus")
                vendorDict?.setValue(prodDict, forKey: "productdetails")
                vendorDict?.setValue(false, forKey: "isChecked")
                vendorDict?.setValue(vendorDict?.value(forKey: "requiredQuantity"), forKey: "updatingQuantity")
                let addProductArray=NSMutableArray()
                addProductArray.add(vendorDict)
                mainDictionary[key]=addProductArray
            }
                }
                
            }

        }
        let jsonArray=NSMutableArray()
        for k in 0..<keyString.count
        {
            let jsonObject=NSMutableDictionary()
            let dddd=mainDictionary[keyString[k]] as? NSMutableArray
            jsonObject["vendorId"]=(dddd?[0] as AnyObject).value(forKey: "prefferedVendorId")
            jsonObject["accountId"]=(dddd?[0] as AnyObject).value(forKey: "accountId")
            jsonObject["ordersList"]=dddd
            jsonArray.add(jsonObject)
        }
        print(jsonArray.count)
       parsedFinalProdArray=jsonArray
        print(parsedFinalProdArray)
        self.submitOpenOrdersAPI()
        }
        
    }
    
    @IBOutlet weak var summaryTblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        summaryTblView.register(UINib(nibName: "ShoppingCartTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingCartTableViewCell")

        summaryTblView.delegate = self
        summaryTblView.dataSource = self
        
        animatingView()
        self.getShoppingCartListAPI()
        
//        summaryTblView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectDeselectProductBtnTap(_ sender: UIButton){

        var idStr : NSString!
        idStr = shoppingCartResult[sender.tag]._id! as NSString

        var vendorIDStr : NSString!
        vendorIDStr = (shoppingCartResult[sender.tag].productDict?.vendorId ?? "") as NSString
        
        var prodDict = NSMutableDictionary()
        prodDict = ["cartId": idStr!,"vendorId":vendorIDStr!]
        
        if(prodSelectedArray.count == 0){
            prodSelectedArray.add(prodDict)
            mainSelectedArray.add(shoppingCartResult[sender.tag])
            if shoppingCartResult[sender.tag].productDict?.unitPrice==0.0
            {
                self.priceArray.append(true)
            }
            else
            {
                self.priceArray.append(false)
            }
        }else{
            
            for i in 0..<prodSelectedArray.count {
                
                let dict = prodSelectedArray[i] as! NSMutableDictionary
                let idInner = dict.value(forKey: "cartId") as! NSString
                
                if(idInner == idStr){
                    
                    prodSelectedArray.removeObject(at: i)
                    mainSelectedArray.removeObject(at: i)
                    if shoppingCartResult[sender.tag].productDict?.unitPrice==0.0
                    {
                        self.priceArray.remove(at: i)
                    }
                   
                    break
                    
                }else{
                    
                    if(i == prodSelectedArray.count-1){
                        prodSelectedArray.add(prodDict)
                        mainSelectedArray.add(shoppingCartResult[sender.tag])
                        if shoppingCartResult[sender.tag].productDict?.unitPrice==0.0
                        {
                            self.priceArray.append(true)
                        }
                        else
                        {
                            self.priceArray.append(false)
                        }
                    }
                }
            }
        }
        
        //vendor Data Array
        
        vendorIDArray.add(vendorIDStr!)
        cartIDArray.add(idStr!)
        
//        if(vendorIDArray.count == 0){
//            vendorIDArray.add(prodDict)
//
//               }else{
//
//                   for i in 0..<vendorIDArray.count {
//
//                       let dict = vendorIDArray[i] as! NSMutableDictionary
//                       let idInner = dict.value(forKey: "vendorId") as! NSString
//
//                       if(idInner == vendorIDStr){
//
//                           vendorIDArray.removeObject(at: i)
//                           break
//
//                       }else{
//
//                           if(i == vendorIDArray.count-1){
//                            vendorIDArray.add(prodDict)
//                           }
//                       }
//                   }
//               }

        
//        print(prodSelectedArray)
        summaryTblView.reloadData()

    }
    
    func showSucessMsg()  {
        
                let alertController = UIAlertController(title: "Success", message:"Order placed successfully" , preferredStyle: .alert)
                //to change font of title and message.
                let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
                let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Success", attributes: titleFont)
                let messageAttrString = NSMutableAttributedString(string: "Order placed successfully", attributes: messageFont)
                alertController.setValue(titleAttrString, forKey: "attributedTitle")
                alertController.setValue(messageAttrString, forKey: "attributedMessage")
                
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    let userDefaults = UserDefaults.standard
                    userDefaults.set("Open Orders", forKey: "sideMenuTitle")
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                          let VC = storyBoard.instantiateViewController(withIdentifier: "OpenOrdersVC") as! OpenOrdersViewController
                          VC.modalPresentationStyle = .fullScreen
//                          self.present(VC, animated: true, completion: nil)
                    self.navigationController?.pushViewController(VC, animated: true)

                })
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)

    }
    
    //****************** TableView Delegate Methods*************************//
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCartResult.count
        
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = summaryTblView.dequeueReusableCell(withIdentifier: "ShoppingCartTableViewCell", for: indexPath) as! ShoppingCartTableViewCell
        
        let itemNum:Int = indexPath.row+1
        let StringItemNum = String(itemNum) //Converting j value to tag, so that we can
        
        let vendorDict = shoppingCartResult[indexPath.row].vendordetails as? NSDictionary

        cell.itemNumLbl.text = "ITEM " + StringItemNum
        cell.prodNameLbl.text = shoppingCartResult[indexPath.row].productDict?.productName
        cell.prefVendorLbl.text = vendorDict?.value(forKey: "vendorName") as? String ?? ""
        let priceStr = String(shoppingCartResult[indexPath.row].productDict?.price ?? 0)
        cell.prefPricelbl.text = priceStr
        if priceStr=="0.0" || priceStr=="0"
        {
            cell.unitPriceWarnImage.isHidden=false
        }
        else
        {
            cell.unitPriceWarnImage.isHidden=true
        }
//        cell.prefPricelbl.text = shoppingCartResult[indexPath.row].productDict?.price
        let purcDate = (shoppingCartResult[indexPath.row].plannedPurchasedate) ?? ""
        let convertedPurchaseDate = convertDateFormatter(date: purcDate)
        
        cell.checkBoxBtn.addTarget(self, action: #selector(selectDeselectProductBtnTap), for: .touchUpInside)
        cell.checkBoxBtn.tag = indexPath.row
        
        cell.deleteBtn.addTarget(self, action: #selector(onDeleteBtnTap), for: .touchUpInside)
        
        cell.deleteBtn.tag = indexPath.row

        cell.plannedPuchaseDate.text = convertedPurchaseDate
        
        let idStr = shoppingCartResult[indexPath.row]._id! as NSString
        
        cell.checkBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)

        
        for i in 0..<prodSelectedArray.count {
            
            let dict = prodSelectedArray[i] as! NSMutableDictionary
            let idInner = dict.value(forKey: "cartId") as! NSString
            
            if(idInner == idStr){
                cell.checkBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
                break

            }
        }

            return cell
        
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 210
        
    }

  @IBAction func onDeleteBtnTap(_ sender: UIButton){
    
     shoppingCartResult.remove(at: sender.tag)
     summaryTblView.reloadData()
    
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
    
    func getShoppingCartListAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + ShoppingCartRetrieveUrl + accountID
                                    
        shoppingServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: { [self](result) in

                            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                
                                let dataDict = result as! NSDictionary
                                self.shoppingCartResultDataArray = dataDict.value(forKey: "result") as! NSMutableArray
                                        
                            if status == "SUCCESS" {
                                
                                self.shoppingCartResult = respVo.result!
                                self.summaryTblView.reloadData()
                                
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

    func submitOpenOrdersAPI() {

        let JSONStringFinal : String!
        
        do {

            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: parsedFinalProdArray, options: JSONSerialization.WritingOptions.prettyPrinted)

            //Convert back to string. Usually only do this for debugging

            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
               JSONStringFinal = JSONString
                
                activity.startAnimating()
                self.view.isUserInteractionEnabled = false
                
                let URLString_loginIndividual = Constants.BaseUrl + AddOpenOrdersUrl
                        
                let postHeaders_IndividualLogin = ["":""]
                            
                shoppingServiceCntrl.requestPOSTURLWithArray(strURL: URLString_loginIndividual as NSString, postParams: parsedFinalProdArray as NSArray, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                                
                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
                                    if(statusCode == 200 ){
                                        self.showSucessMsg()
                                        
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

            //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
            var json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]


        } catch {
       
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
