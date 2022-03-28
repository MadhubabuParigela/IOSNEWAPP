//
//  UpdateOpenOrderViewController.swift
//  Lekha
//
//  Created by USM on 08/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown

class UpdateOpenOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, sentname{
    
    var openOrdersArray = NSMutableArray()
    var modifiedDataDict = NSMutableDictionary()
    
//    var modifiedDArr = NSMutableArray()
    
    var sectionPos = Int()
    var indexPos = Int()
    
    let emptyMsgBtn = UIButton()
    
    var tappedProdIDStr = String()
    var orderLevelProdIDStr = String()
    
    let dropDown = DropDown()
    
    func sendnamedfields(fieldname: String, idStr: String) {
        
//        print("before modified arr is \(modifiedDArr)")
        
//        var openOrdersDataArr = openOrdersArray
//        var modifiedDataBeforeArr = modifiedDArr
        
        for i in 0..<openOrdersArray.count {

            let dataDict = openOrdersArray.object(at: i) as! NSMutableDictionary
            
            var orderDetailsArray = NSMutableArray()
            orderDetailsArray = dataDict.value(forKey: "ordersList") as! NSMutableArray
            
            for j in 0..<orderDetailsArray.count {
                
                let orderDetailDict = orderDetailsArray.object(at: j) as! NSMutableDictionary
                
                let prodDetailsDict = orderDetailDict.value(forKey: "productdetails") as! NSMutableDictionary
                
                let prodStatusStr = prodDetailsDict.value(forKey: "_id") as! String
                
                if(prodStatusStr == tappedProdIDStr){
                    
                    if(fieldname == "Received"){
                        prodDetailsDict.setValue("Available", forKey: "productStatus")

                    }else{
                        prodDetailsDict.setValue(fieldname, forKey: "productStatus")

                    }
                    
                    orderDetailDict.setValue(prodDetailsDict, forKey: "productdetails")
                    orderDetailsArray.replaceObject(at: j, with: orderDetailDict)
                    dataDict.setValue(orderDetailsArray, forKey: "ordersList")
                    openOrdersArray.replaceObject(at: i, with: dataDict)

                    break
                }
            }
        }
        
        
        print("Open Orders Array is \(openOrdersArray)")
//        print("Modified Array is \(modifiedDataBeforeArr)")

//        for k in 0..<openOrdersArray.count {
//
//            let dataDictMain = openOrdersArray.object(at: k) as! NSMutableDictionary
//
//            var orderDetailsArray = NSMutableArray()
//            orderDetailsArray = dataDictMain.value(forKey: "ordersList") as! NSMutableArray
//
//            let orderIDStr = dataDictMain.value(forKey: "_id") as! String
//
//            if(orderIDStr == orderLevelProdIDStr){
//                print("Exec")
//
//                let modifiedOrdersListArray = NSMutableArray()
//                let modifiedOthersListArray = NSMutableArray()
//
//                for l in 0..<orderDetailsArray.count {
//
//                    let orderDetailDict = orderDetailsArray.object(at: l) as! NSMutableDictionary
//
//                    let prodDetailsDict = orderDetailDict.value(forKey: "productdetails") as! NSMutableDictionary
//
//                    let prodStatusStr = prodDetailsDict.value(forKey: "productStatus") as! String
//
////                    if(prodStatusStr == tappedProdIDStr){
//
////                        if(fieldname == "Received"){
////                            prodDetailsDict.setValue("Available", forKey: "productStatus")
////
////                        }else{
////                            prodDetailsDict.setValue(fieldname, forKey: "productStatus")
////
////                        }
////
////                        orderDetailDict.setValue(prodDetailsDict, forKey: "productdetails")
////                        orderDetailsArray.replaceObject(at: l, with: orderDetailDict)
//
//                        if(prodStatusStr == "Received" || prodStatusStr == "Cancelled" || prodStatusStr == "Avaialable"){
//                            modifiedOthersListArray.add(orderDetailDict)
//
//                        }else{
//                            modifiedOrdersListArray.add(orderDetailDict)
//                        }
//
////                        openOrdersDataArr.replaceObject(at: k, with: dataDictMain)
////                        break
//
////                         }
//                    }
//
//                dataDictMain.setValue(modifiedOthersListArray, forKey: "otherList")
//                dataDictMain.setValue(modifiedOrdersListArray, forKey: "ordersList")
//
//            print(dataDictMain)
//
//            }
//
//
//            //Change Data in Modified Data Array
//        }
        
//        modifiedDArr = modifiedbackArr
//        openOrdersArray = dataBackUpArray
        
//      openOrdersArray = dataArray as NSMutableArray
//        print(modifiedDArr)
//        print(openOrdersArray)
        updateOrderTblView.reloadData()
//        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)


    }
    
    var openOrdersServiceCntrl = ServiceController()
//    var openOrdersResult = [OpenOrdersResult]()
    
    var categoryDataArray = NSArray()
    
    @IBOutlet weak var updateOrderTblView: UITableView!
    
    @IBAction func backBtnTap(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)

    }
    
    var accountID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        // Do any additional setup after loading the view.
        
        updateOrderTblView.register(UINib(nibName: "UpdateOpenOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "UpdateOpenOrdersTableViewCell")
        
        updateOrderTblView.delegate = self
        updateOrderTblView.dataSource = self
        
        categoryDataArray = ["Ordered","Received","Cancelled"]
        
        animatingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getOpenOrdersAPI()

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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = updateOrderTblView.dequeueReusableCell(withIdentifier: "UpdateOpenOrdersTableViewCell", for: indexPath) as! UpdateOpenOrdersTableViewCell
        
//        var productsList = [OpenOrdersProducts]()
//        productsList = openOrdersArray[indexPath.section].productsList!
        
        var productsList = NSMutableArray()
        
        let dataDict = openOrdersArray.object(at: indexPath.section) as! NSDictionary
        print(dataDict)

        productsList = dataDict.value(forKey: "ordersList") as! NSMutableArray
//        print(productsList)
        
//        if(productsList.count == 0){
//            productsList = dataDict.value(forKey: "otherList") as! NSMutableArray
//
//        }
        
        let prodInnerDict = productsList.object(at: indexPath.row) as? NSDictionary
        let prodDict = prodInnerDict?.value(forKey: "productdetails") as? NSDictionary
        let stockUnitArr = prodInnerDict?.value(forKey: "stockUnitDetails") as? NSArray
        let priceUnitArr = prodInnerDict?.value(forKey: "priceUnitDetails") as? NSArray
        
        let stockUnitStr = stockUnitArr?.object(at: 0) as? NSDictionary
        let stocKstr = stockUnitStr?.value(forKey: "stockUnitName") as? String
        cell.stockUnitTF.text = stocKstr
//        print(productsList)
//        print(prodDict)
        
//        let prodDetails = productsList[indexPath.row].productDetails!
        
        cell.prodIDTF.text = (prodDict?.value(forKey: "productUniqueNumber") as? String)
        cell.prodNameLbl.text = (prodDict?.value(forKey: "productName") as? String)
        cell.descriptionLbl.text = (prodDict?.value(forKey: "description") as? String)
        
        if let orderQuan = prodDict?.value(forKey: "stockQuantity") as? Double
        {
        cell.orderedQtyTF.text = String(orderQuan ?? 0)
        }
        else if let orderQuan = prodDict?.value(forKey: "stockQuantity") as? Float
        {
        cell.orderedQtyTF.text = String(orderQuan ?? 0)
        }
        else
        {
            cell.orderedQtyTF.text = prodDict?.value(forKey: "stockQuantity") as? String
        }
        
//            cell.orderQtyLbl.text = String((productsList[indexPath.row].productDetails?.stockQuantity!)!)
//        let finalDict = productsList[indexPath.row].stockUnitDetails!
        
//            String(prodDict.value(forKey: "stockUnit") as! String)
        let priceUnitStr = priceUnitArr?.object(at: 0) as? NSDictionary
        let pricestr = priceUnitStr?.value(forKey: "priceUnit") as? String
        cell.vendorTF.text = pricestr
        
        if let price = prodDict?.value(forKey: "price") as? Double
        {
        cell.priceTF.text = String(format:"%.2f", price ?? 0.0)
        }
        else if let price = prodDict?.value(forKey: "price") as? Float
        {
        cell.priceTF.text = String(format:"%.2f", price ?? 0.0)
        }
        else
        {
            cell.priceTF.text = prodDict?.value(forKey: "price") as? String
        }
        
        
        let statusStr = prodDict?.value(forKey: "productStatus") as? String
        
        if(statusStr == "Available"){
            cell.statusBtn.setTitle("Received", for: .normal)

        }else{
            cell.statusBtn.setTitle((prodDict?.value(forKey: "productStatus") as? String), for: .normal)

        }
        if let unitprice = prodDict?.value(forKey: "unitPrice") as? Double
        {
            cell.purchaseDataBtn.setTitle(String(unitprice), for: .normal)
        }
        else if let unitprice = prodDict?.value(forKey: "unitPrice") as? Float
        {
            cell.purchaseDataBtn.setTitle(String(unitprice), for: .normal)
        }
        else
        {
            cell.purchaseDataBtn.setTitle(prodDict?.value(forKey: "unitPrice") as? String, for: .normal)
        }

//        let purchaseDate = prodDict?.value(forKey: "purchaseDate") ?? ""
//        let convertedPurchaseDate = convertDateFormatter(date: purchaseDate as? String ?? "")

        
        var prodArray = NSArray()
        
        if(prodDict?.value(forKey: "productImages") == nil){
            
        }else{
            prodArray = (prodDict?.value(forKey: "productImages") as? NSArray)!
        }
        
        
        if(prodArray.count  > 0){
            
                    let dict = prodArray[0] as! NSDictionary
            
            if(dict.value(forKey: "0") != nil){
                
                let imageStr = dict.value(forKey: "0") as? String ?? ""
                
                if !imageStr.isEmpty {
                    
                    let imgUrl:String = imageStr
                    
                    let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                        
                    let imggg = Constants.BaseImageUrl + trimStr
                    
                    let url = URL.init(string: imggg)

//                    cell.profileImgView?.sd_setImage(with: url , placeholderImage: UIImage(named: "add photo"))
                    
                    cell.profileImgView?.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                    
                    cell.profileImgView?.contentMode = UIView.ContentMode.scaleAspectFit
                    
                }
                else {
                    
                    cell.profileImgView?.image = UIImage(named: "no_image")
                }

            }
                    
        }else{
            
            cell.profileImgView?.image = UIImage(named: "no_image")

        }
        
        print(productsList.count)
        print(indexPath.row)
        
        cell.statusBtn.addTarget(self, action: #selector(statusBtnTapped), for: .touchUpInside)

        cell.editDetailsBtn.isHidden = true
        cell.updateOpenOrdersBtn.isHidden = true
        
        if(productsList.count - 1 == indexPath.row){
            print("Executed")
            
//            cell.editDetailsBtn.isHidden = false
            cell.updateOpenOrdersBtn.isHidden = false
            
//            cell.editDetailsBtn.addTarget(self, action: #selector(editDetailsBtnTapped), for: .touchUpInside)
            
            cell.updateOpenOrdersBtn.addTarget(self, action: #selector(updateDetailsBtnTapped), for: .touchUpInside)

        }
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return openOrdersArray.count
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        var productsList = [OpenOrdersProducts]()
//        productsList = openOrdersResult[indexPath.section].productsList!
        
        var productsList = NSMutableArray()
        
        let dataDict = openOrdersArray.object(at: indexPath.section) as! NSDictionary

        productsList = dataDict.value(forKey: "ordersList") as! NSMutableArray
//        print(productsList)

        
        if(productsList.count - 1 == indexPath.row){
            print("Executed")
            return 440
            
        }else{
            return 390
        }
    }

   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 75
       
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        var productsList = [OpenOrdersProducts]()
//        productsList = openOrdersResult[section].productsList!
        if isExpandable[section]==true
        {
        var productsList = NSMutableArray()
        
        let dataDict = openOrdersArray.object(at:section) as! NSDictionary

        productsList = dataDict.value(forKey: "ordersList") as! NSMutableArray
//        print(productsList)

        return productsList.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 75))

        headerView.backgroundColor = UIColor.white
        
        let editBtn = UIButton()
        editBtn.frame = CGRect(x: headerView.frame.size.width - 70, y: 5, width: 60, height: 20)
        headerView.addSubview(editBtn)
        
        editBtn.addTarget(self, action: #selector(editDetailsBtnTapped), for: .touchUpInside)
        editBtn.tag = section
        
        let attrs = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

        let attributedString = NSMutableAttributedString(string:"")

        let buttonTitleStr = NSMutableAttributedString(string:"Edit", attributes:attrs)
        attributedString.append(buttonTitleStr)
        editBtn.setAttributedTitle(attributedString, for: .normal)
        
//      editBtn.setAttributedTitle(attributedString, forState: .Normal)

        let orderIdLbl = UILabel()
        orderIdLbl.frame = CGRect(x: 15, y: 27.5, width: headerView.frame.size.width/3 - (20), height: 15)
        orderIdLbl.text = "Order ID "
        orderIdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        orderIdLbl.textColor = hexStringToUIColor(hex: "105fef")
        headerView.addSubview(orderIdLbl)

        let orderIdTxtLbl = UILabel()
        orderIdTxtLbl.frame = CGRect(x: 15, y: 45, width: headerView.frame.size.width/3 - (20), height: 17)
//        orderIdTxtLbl.text = "45435435454"
        orderIdTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        orderIdTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
        headerView.addSubview(orderIdTxtLbl)
        
        let dataDict = openOrdersArray.object(at: section) as! NSDictionary
        orderIdTxtLbl.text =  String((dataDict.value(forKey: "orderId") as? String)!)
        
        //vendor id lbl
        
        let vendorIdLbl = UILabel()
        vendorIdLbl.frame = CGRect(x: orderIdLbl.frame.size.width+20, y: 27.5, width: headerView.frame.size.width/3 - (20), height: 15)
        vendorIdLbl.text = "Vendor Name "
        vendorIdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        vendorIdLbl.textColor = hexStringToUIColor(hex: "105fef")
        headerView.addSubview(vendorIdLbl)

        let vendorIdTxtLbl = UILabel()
        vendorIdTxtLbl.frame = CGRect(x: orderIdLbl.frame.size.width+20, y: 45, width:headerView.frame.size.width/3 - (20), height: 17)
        vendorIdTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        vendorIdTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
        headerView.addSubview(vendorIdTxtLbl)
        
        vendorIdTxtLbl.text =  (dataDict.value(forKey: "vendorName") as? String)
        
        let dateLabel = UILabel()
        dateLabel.frame = CGRect(x: vendorIdLbl.frame.size.width+orderIdLbl.frame.size.width+20, y: 27.5, width: headerView.frame.size.width/3 - (20), height: 15)
        dateLabel.text = "Purchase Date"
        dateLabel.font = UIFont.init(name: kAppFontMedium, size: 12)
        dateLabel.textColor = hexStringToUIColor(hex: "105fef")
        headerView.addSubview(dateLabel)

        let dateIdTxtLbl = UILabel()
        dateIdTxtLbl.frame = CGRect(x: vendorIdLbl.frame.size.width+orderIdLbl.frame.size.width+20, y: 45, width:headerView.frame.size.width/3 - (20), height: 17)
        dateIdTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        dateIdTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
        
        headerView.addSubview(dateIdTxtLbl)
        
        let productsList = dataDict.value(forKey: "ordersList") as! NSMutableArray

        let prodInnerDict = productsList.object(at: 0) as! NSDictionary
        let prodDict = prodInnerDict.value(forKey: "productdetails") as! NSDictionary
        let vall=prodDict.value(forKey: "purchaseDate")as? String ?? ""
        let valArr=vall.components(separatedBy: "T")
        
        let valAArr=valArr[0].components(separatedBy: "-")
        
         var valString=String()
        if valAArr.count==3
         {
            let aa:String=valAArr[2] + "/"
            valString = aa + valAArr[1] + "/" + valAArr[0]
         }
         else
         {
             valString = ""
         }
        dateIdTxtLbl.text=valString
        let uploadType = prodDict.value(forKey: "uploadType") as? String
        
        if(uploadType == "vendor"){
            editBtn.isHidden = true
        }else{
            editBtn.isHidden = true
        }
        let dropButton = UIButton()
        dropButton.tag=section
        dropButton.frame = CGRect(x: headerView.frame.size.width-50, y: 27.5, width: 30, height: 30)
        dropButton.addTarget(self, action: #selector(dropDoownBtnTap), for: .touchUpInside)
       if isExpandable[section]==true
       {
           dropButton.setImage(UIImage.init(named: "Up"), for: .normal)
       }
       else
       {
           dropButton.setImage(UIImage.init(named: "arrowDown"), for: .normal)
       }
        
       
         headerView.addSubview(dropButton)
        return headerView

    }
    var isExpandable=[Bool]()
    @objc func dropDoownBtnTap(sender:UIButton)
    {
     print("Button Tapped,need to insert (or) DElete Rows In Section\(sender.tag)")
     
     if isExpandable[sender.tag] == true {
         isExpandable[sender.tag]=false
        sender.setImage(UIImage(named: "Up"), for: .normal)
        updateOrderTblView.reloadData()
       }
       else if isExpandable[sender.tag] == false  {
         isExpandable[sender.tag]=true
        sender.setImage(UIImage(named: "arrowDown"), for: .normal)
        updateOrderTblView.reloadData()
            }
         }
    @IBAction func statusBtnTapped(_ sender: UIButton){
        
        let buttonPosition = sender.convert(CGPoint.zero, to: updateOrderTblView)
        let indexPath = updateOrderTblView.indexPathForRow(at: buttonPosition)
        
        sectionPos = indexPath!.section
        indexPos = indexPath!.row
        
//        for i in 0..<openOrdersArray.count {

            let dataDict = openOrdersArray.object(at: sectionPos) as! NSMutableDictionary
        
            orderLevelProdIDStr = dataDict.value(forKey: "_id") as! String
        print(orderLevelProdIDStr)
        
            var orderDetailsArray = NSMutableArray()
            orderDetailsArray = dataDict.value(forKey: "ordersList") as! NSMutableArray
            
//            for j in 0..<orderDetailsArray.count {
                
                let orderDetailDict = orderDetailsArray.object(at: indexPos) as! NSMutableDictionary
                
                let prodDetailsDict = orderDetailDict.value(forKey: "productdetails") as! NSMutableDictionary
                
                tappedProdIDStr = prodDetailsDict.value(forKey: "_id") as! String
//                break
//            }
//        }
        
        print(tappedProdIDStr)
        
        let vendorStatus = orderDetailDict.value(forKey: "vendorApprovalStatus") as? String
        
        if(vendorStatus == "NotRequired"){
            categoryDataArray = ["Ordered","Cancelled","Received"]
            
        }else if(vendorStatus == "Pending"){
            categoryDataArray = ["Ordered","Cancelled"]

        }else if(vendorStatus == "Approved"){
            categoryDataArray = ["Ordered","Cancelled","Received"]

        }
        
        dropDown.dataSource = categoryDataArray as! [String] //4
        
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                
                self?.sendnamedfields(fieldname: item, idStr: "")
            }
        
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
//            viewTobeLoad.delegate1 = self
//            viewTobeLoad.iscountry = false
//            viewTobeLoad.fields = self.categoryDataArray as! [String]
//            viewTobeLoad.categoryIDs = self.categoryDataArray as! [String]
//            viewTobeLoad.headerTitleStr = "Select Status"
//            viewTobeLoad.modalPresentationStyle = .fullScreen
////            self.present(viewTobeLoad, animated: true, completion: nil)
//        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

    }
    
    @IBAction func updateDetailsBtnTapped(_sender: UIButton){
        
//        for k in 0..<openOrdersArray.count {
//
//            let dataDictMain = openOrdersArray.object(at: k) as! NSMutableDictionary
//
//            var orderDetailsArray = NSMutableArray()
//            orderDetailsArray = dataDictMain.value(forKey: "ordersList") as! NSMutableArray
//
//            let orderIDStr = dataDictMain.value(forKey: "_id") as! String
//
//            if(orderIDStr == orderLevelProdIDStr)
//                print("Exec")
//
//                let modifiedOrdersListArray = NSMutableArray()
//                let modifiedOthersListArray = NSMutableArray()
//
//                for l in 0..<orderDetailsArray.count {
//
//                    let orderDetailDict = orderDetailsArray.object(at: l) as! NSMutableDictionary
//
//                    let prodDetailsDict = orderDetailDict.value(forKey: "productdetails") as! NSMutableDictionary
//
//                    let prodStatusStr = prodDetailsDict.value(forKey: "productStatus") as! String
//
////                    if(prodStatusStr == tappedProdIDStr){
//
////                        if(fieldname == "Received"){
////                            prodDetailsDict.setValue("Available", forKey: "productStatus")
////
////                        }else{
////                            prodDetailsDict.setValue(fieldname, forKey: "productStatus")
////
////                        }
////
////                        orderDetailDict.setValue(prodDetailsDict, forKey: "productdetails")
////                        orderDetailsArray.replaceObject(at: l, with: orderDetailDict)
//
//                        if(prodStatusStr == "Received" || prodStatusStr == "Cancelled" || prodStatusStr == "Avaialable"){
//                            modifiedOthersListArray.add(orderDetailDict)
//
//                        }else{
//                            modifiedOrdersListArray.add(orderDetailDict)
//                        }
//
////                        openOrdersDataArr.replaceObject(at: k, with: dataDictMain)
////                        break
//
////                         }
//                    }
//
//                dataDictMain.setValue(modifiedOthersListArray, forKey: "otherList")
//                dataDictMain.setValue(modifiedOrdersListArray, forKey: "ordersList")
//
//                modifiedDataDict = dataDictMain
//                print(modifiedDataDict)
//
//            }
//
////            UpdateOpenOrdersUrl
//            //Change Data in Modified Data Array
//        }
        
        
        
        print("Before Open Order Arr is \(openOrdersArray)")

        let dataOpenArray = openOrdersArray
        
        let buttonPosition = _sender.convert(CGPoint.zero, to: updateOrderTblView)
        let indexPath = updateOrderTblView.indexPathForRow(at: buttonPosition)

        var productsList = NSMutableArray()
        
        let dataDict = dataOpenArray.object(at: indexPath!.section) as! NSDictionary

        productsList = dataDict.value(forKey: "ordersList") as! NSMutableArray
        print(productsList)
        
        let modifiedOrdersListArray = NSMutableArray()
        let modifiedOthersListArray = NSMutableArray()

        for l in 0..<productsList.count {

            let orderDetailDict = productsList.object(at: l) as! NSMutableDictionary

            let prodDetailsDict = orderDetailDict.value(forKey: "productdetails") as! NSMutableDictionary

            let prodStatusStr = prodDetailsDict.value(forKey: "productStatus") as! String

                if(prodStatusStr == "Received" || prodStatusStr == "Cancelled" || prodStatusStr == "Available"){
                    modifiedOthersListArray.add(orderDetailDict)
                    
                }else{
                    modifiedOrdersListArray.add(orderDetailDict)
                }
            }

        dataDict.setValue(modifiedOthersListArray, forKey: "otherList")
        dataDict.setValue(modifiedOrdersListArray, forKey: "ordersList")

        modifiedDataDict = dataDict as! NSMutableDictionary
        print(modifiedDataDict)
        
        print("Open Order Arr is \(openOrdersArray)")
        
        updateOpenOrdersAPI()

    }
    
    @IBAction func editDetailsBtnTapped(_ sender: UIButton){

        let buttonPosition = sender.convert(CGPoint.zero, to: updateOrderTblView)
        let indexPath = updateOrderTblView.indexPathForRow(at: buttonPosition)
        
        var productsList = NSMutableArray()
        
        let dataDict = openOrdersArray.object(at: sender.tag) as! NSDictionary

        productsList = dataDict.value(forKey: "ordersList") as! NSMutableArray
        print(productsList)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "EditOpenOrderViewController") as! EditOpenOrderViewController
        VC.modalPresentationStyle = .fullScreen
        VC.myProductArray = productsList
        VC.openOrdersDict = dataDict
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)


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
    
    func parseOpenOrderDetails() {
        
        //Preparing Other List Array
        
        let dataArray = openOrdersArray
        
//        print(dataArray)
        
        for i in 0..<dataArray.count {

            let dataDict = dataArray.object(at: i) as! NSMutableDictionary
            let otherListArray = NSMutableArray()
            
            var orderDetailsArray = NSMutableArray()
            orderDetailsArray = dataDict.value(forKey: "ordersList") as! NSMutableArray
            
            for j in 0..<orderDetailsArray.count {
                
                let orderDetailDict = orderDetailsArray.object(at: j) as! NSMutableDictionary
                
                let prodDetailsDict = orderDetailDict.value(forKey: "productdetails") as! NSMutableDictionary
                
                let prodStatusStr = prodDetailsDict.value(forKey: "productStatus") as! String
                
                if(prodStatusStr == "Received" || prodStatusStr == "Cancelled"){
                    
                    otherListArray.add(orderDetailDict)
                    orderDetailsArray.removeObject(at: j)
                    
                }
            }
            
            dataDict.setValue(otherListArray, forKey: "otherList")
            dataArray.replaceObject(at: i, with: dataDict)
            
        }
        
//        modifiedDArr = dataArray
//        print(modifiedDArr)
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

    }

    
    func updateOpenOrdersAPI() {
        
        print(modifiedDataDict)
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: modifiedDataDict, options: JSONSerialization.WritingOptions.prettyPrinted)

            
            if let prodImgJSONString = String(data: jsonData, encoding: String.Encoding.utf8) {

                let URLString_loginIndividual = Constants.BaseUrl + UpdateOpenOrdersUrl
                                            
                let postHeaders_IndividualLogin = ["":""]
                
                let dict = convertToDictionary(text: prodImgJSONString)! as [String : Any]
                print(dict)

                openOrdersServiceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: dict as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                                    let respVo:OpenOrdersRespo = Mapper().map(JSON: result as! [String : Any])!
                                                            
                                    let status = respVo.status
                                    let messageResp = respVo.message
                                    _ = respVo.statusCode
                                    
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                    
                                    let dataDict = result as! NSDictionary
                                    print(dataDict)
            
                                    if status == "SUCCESS" {
                                        self.showAlertWith(title: "Success", message: "Details updated successfully")
                                        
                                        self.getOpenOrdersAPI()

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
            
        }
        catch{
            
        }

    }
    
    func getOpenOrdersAPI() {
        
        openOrdersArray.removeAllObjects()
        openOrdersArray = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + OpenOrdersUrl + accountID
                                    
        openOrdersServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:OpenOrdersRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
            
                            let dataDict = result as! NSDictionary
            
//                             print(dataDict)
            
                            self.openOrdersArray = dataDict.value(forKey: "result") as? NSMutableArray ?? NSMutableArray()
            
//                            self.modifiedDArr = dataDict.value(forKey: "result") as! NSMutableArray
            
//            print(self.modifiedDArr)
            
                            if status == "SUCCESS" {
                                
//                               openOrdersArray
//                                self.openOrdersResult = respVo.result!
//                                print(self.openOrdersResult)
//                                self.parseOpenOrderDetails()
                                self.isExpandable=[Bool]()
                                print(self.openOrdersArray)
                                if self.openOrdersArray.count>0
                                {
                                    for i in 0..<self.openOrdersArray.count {
                                        self.isExpandable.append(false)
                                }
                                }
                                self.updateOrderTblView.reloadData()
                                
                                if(self.openOrdersArray.count == 0){
                                    self.showEmptyMsgBtn()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
