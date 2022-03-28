//
//  VendorOrderDetailsViewController.swift
//  LekhaLatest
//
//  Created by USM on 30/04/21.
//

import UIKit
import ObjectMapper

class VendorOrderDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,sentname {

    @IBOutlet weak var lookingForTF: UITextField!
    var idStr = String()
    var orderStatus = String()
    var checkBoxDataArray = NSMutableArray()
    var orderDataDict = NSDictionary()
    var hiddenBtn = UIButton()
    var updateDetailsView = UIView()
    var selectStatusBtn = UIButton()
    var categoryDataArray = NSArray()
    var deliveryStatusStr = ""
    var selectStatusDataDict = NSDictionary()
    var isActiveStatusStr = ""

    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBOutlet weak var vendorTblView: UITableView!
    var customView = UIView()
    
    var serviceCntrl = ServiceController()
    var accountID = String()
    var orderDetailsArray = NSMutableArray()
    var orderDetailsDict = NSDictionary()
    var emptyMsgBtn =  UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        idStr = "608fdb98387daf4f4c253803"
//        orderStatus = "Approved"
        
        categoryDataArray = ["Delivered","Cancelled"]

        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
                customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
        
                let placeOrderBtn = UIButton()
                placeOrderBtn.frame = CGRect(x:15, y: 5, width: ((customView.frame.size.width - 30)), height: 40)
                placeOrderBtn.setTitle("Accept", for: UIControl.State.normal)
                placeOrderBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
                placeOrderBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
                placeOrderBtn.backgroundColor = hexStringToUIColor(hex: "0f5fee")
                placeOrderBtn.layer.cornerRadius = 5
                placeOrderBtn.clipsToBounds = true
                customView.addSubview(placeOrderBtn)
        
        placeOrderBtn.addTarget(self, action: #selector(acceptOrderBtnTap), for: .touchUpInside)
        
        let acceptBtn = UIButton()
        acceptBtn.frame = CGRect(x:15, y: 5, width: ((customView.frame.size.width - 30)), height: 40)
        placeOrderBtn.setTitle("Accept", for: UIControl.State.normal)
        acceptBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        acceptBtn.setTitleColor(hexStringToUIColor(hex: "0d60ee"), for: UIControl.State.normal)
        acceptBtn.backgroundColor = hexStringToUIColor(hex: "0f5fee")
        acceptBtn.layer.cornerRadius = 5
        acceptBtn.clipsToBounds = true
//        customView.addSubview(acceptBtn)

        vendorTblView.delegate = self
        vendorTblView.dataSource = self
        
        vendorTblView.register(UINib(nibName: "VendorOrderDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "VendorOrderDetailTableViewCell")
        
        self.vendorTblView.tableFooterView = self.customView
//        vendorTblView.reloadData()
        
        if(orderStatus == "Approved"){
            self.vendorTblView.tableFooterView?.isHidden = true
       
        }else if(isActiveStatusStr == "Completed" || isActiveStatusStr == "Cancelled"){
            self.vendorTblView.tableFooterView?.isHidden = true

        }
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: lookingForTF.frame.size.width - (35), y: 0, width: 35, height: lookingForTF.frame.size.height)
        lookingForTF.rightView = paddingView
        lookingForTF.rightViewMode = UITextField.ViewMode.always
        
        
        let filterBtn = UIButton()
        filterBtn.frame = CGRect(x: paddingView.frame.size.width/2 - 12.5, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
        paddingView.addSubview(filterBtn)


        // Do any additional setup after loading the view.
    
}
    
    func sendnamedfields(fieldname: String, idStr: String) {
        
        deliveryStatusStr = fieldname

        selectStatusBtn.setTitle("   \(fieldname)", for: .normal)
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func acceptOrderBtnTap(_ sender: Any) {
        
        if(checkBoxDataArray.count == 0){
            self.showAlertWith(title: "Alert", message: "Please select at least one product")
             return
        }
    
        acceptRequestAPI(prodDataArray: checkBoxDataArray)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.getOrderDetailsAPI()

    }
    
    // MARK: - UITableViewDataSource
    
           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return orderDetailsArray.count
            
           }
           
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               
               let cell = tableView.dequeueReusableCell(withIdentifier: "VendorOrderDetailTableViewCell", for: indexPath) as! VendorOrderDetailTableViewCell
            
            let productDict = orderDetailsArray[indexPath.row] as! NSDictionary
            
            let dataDict = productDict.value(forKey: "productsResult") as! NSDictionary
            
            let stockQuan = productDict.value(forKey: "orderedQunatity") as? Int
            let price = dataDict.value(forKey: "offeredPrice") as? Int

            cell.prodIdLbl.text = dataDict["_id"] as? String
            cell.prodNameLbl.text = dataDict.value(forKey: "productName") as? String
            cell.descLbl.text = dataDict.value(forKey: "description") as? String
            cell.reqQtyLbl.text = String(stockQuan ?? 0)
            cell.stockUnitLbl.text = dataDict.value(forKey: "stockUnit") as? String
            cell.priceLbl.text = String(price ?? 0)
            
            cell.updateDetailsBtn.tag = indexPath.row
            
            cell.updateDetailsBtn.addTarget(self, action: #selector(updateDeliveryStatusBtnTap), for: .touchUpInside)

            cell.checkBoxBtn.addTarget(self, action: #selector(checkBoxBtnTap), for: .touchUpInside)
            
            cell.checkBoxBtn.tag = indexPath.row
            
//            cell.checkBoxBtn.addTarget(self, action: #selector(addToCartBtnTap), for: .touchUpInside)or

            let doorDelivery = dataDict.value(forKey: "doorDelivery") as? Bool
            
            if(doorDelivery == true){
                cell.doorDeliveryLbl.text = "Yes"
                
            }else{
                cell.doorDeliveryLbl.text = "No"

            }
            
            let expiryDate = (dataDict.value(forKey: "updatedDate") as? String) ?? ""
            let convertedExpiryDate = convertServerDateFormatter(date: expiryDate)
            
            if(isActiveStatusStr == "Completed"){
                cell.updateDetailsBtn.isHidden = true
                cell.dateLbl.isHidden = false
                cell.dateTxxtLbl.isHidden = false
                
                cell.dateLbl.text = "Completed Date"
                cell.dateTxxtLbl.text = convertedExpiryDate
                
            }else if(isActiveStatusStr == "Cancelled"){
                cell.updateDetailsBtn.isHidden = true

                cell.dateLbl.isHidden = false
                cell.dateTxxtLbl.isHidden = false
                
                cell.dateLbl.text = "Cancelled Date"
                cell.dateTxxtLbl.text = convertedExpiryDate

            }
            
            let prodArray = dataDict.value(forKey: "vendorProductImages") as? NSArray

            if(prodArray?.count ?? 0  > 0){

                        let dict = prodArray?[0] as! NSDictionary
                        
                        let imageStr = dict.value(forKey: "0") as! String
                        
                        if !imageStr.isEmpty {
                            
                            let imgUrl:String = imageStr
                            
                            let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                                
                            let imggg = Constants.VendorBaseImgUrl + trimStr
                            
//                            let url = URL.init(string: imggg)
                            
//                            let fileUrl = URL(fileURLWithPath: imggg)
                            let fileUrl = URL(string: imggg)

//                            cell.prodImgView?.sd_setImage(with: fileUrl , placeholderImage: UIImage(named: "add photo"))
                            
                            cell.prodImgView?.sd_setImage(with: fileUrl, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                            cell.prodImgView?.contentMode = UIView.ContentMode.scaleAspectFit
                            
                        }
                        
                        else {
                            
                            cell.prodImgView?.image = UIImage(named: "no_image")
                        }
            }else{
                cell.prodImgView?.image = UIImage(named: "no_image")

            }
            
//         cell.update.addTarget(self, action: #selector(addToCartBtnTap), for: .touchUpInside)
            
            if(orderStatus == "Approved"){
                cell.checkBoxBtn.isHidden = true
                cell.updateDetailsBtn.isHidden = false

            }else{
                cell.updateDetailsBtn.isHidden = true
            }
            
            if(isActiveStatusStr == "Completed"){
                cell.checkBoxBtn.isHidden = true
                
            }else if(isActiveStatusStr == "Cancelled"){
                cell.checkBoxBtn.isHidden = true

           }
            
            cell.checkBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
            
            let idString = dataDict.value(forKey: "_id") as? String
            
            for i in 0..<checkBoxDataArray.count {
                
                let prodDataDict = checkBoxDataArray[i] as? NSDictionary
                
                let innerIdStr = prodDataDict?.value(forKey: "productId") as? String
                
                if(innerIdStr == idString){            cell.checkBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
                    
                }
            }
            
               
               return cell
           }
    
    @IBAction func checkBoxBtnTap(_ sender: UIButton) {
        
        let productDict = orderDetailsArray[sender.tag] as! NSDictionary
        let dataDict = productDict.value(forKey: "productsResult") as! NSDictionary

        let idStr = dataDict.value(forKey: "_id") as? String
        
        let prodDataDict = NSMutableDictionary()

        if(checkBoxDataArray.count == 0){
            
            prodDataDict.setValue(idStr, forKey: "productId")
            prodDataDict.setValue(true, forKey: "checked")
            
            checkBoxDataArray.add(prodDataDict)
            
        }else{
            
            for i in 0..<checkBoxDataArray.count {

                let prodDataDict = checkBoxDataArray[i] as? NSDictionary
                let innerIdStr = prodDataDict?.value(forKey: "productId") as? String
                
                if(idStr == innerIdStr){
                    checkBoxDataArray.removeObject(at: i)
                    break
                    
                }else{
                    if(i == checkBoxDataArray.count-1){
//                        checkBoxDataArray.add((idStr ?? "") as String)
                        
                        let innerProdDict = NSMutableDictionary()
                        
                        innerProdDict.setValue(idStr, forKey: "productId")
                        innerProdDict.setValue(true, forKey: "checked")
                        
                        checkBoxDataArray.add(innerProdDict)
                        break
                    }
                }
            }
        }
        
        vendorTblView.reloadData()
    }
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

    }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(isActiveStatusStr == "Active"){
            if(orderStatus == "Approved"){
                return 320

            }else{
                return 270

            }
        }else{
            return 270
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    
    func showSuccessAlertWith(title:String,message:String)
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
                
                self.getOrderDetailsAPI()
               
            })
    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        
        }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 10, y: 0, width: self.view.frame.width - (20), height: 195))
        headerView.backgroundColor = .white
        
        if(orderDetailsDict.count > 0){
            
            let orderIdLbl = UILabel()
            orderIdLbl.frame = CGRect(x: 15, y: 7.5, width: headerView.frame.size.width - (20), height: 23)
            let orderID = orderDetailsDict.value(forKey: "orderId") as? String

            orderIdLbl.text = orderID
            orderIdLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
            orderIdLbl.textColor = hexStringToUIColor(hex: "105fef")
            headerView.addSubview(orderIdLbl)

            let orderIdTxtLbl = UILabel()
            orderIdTxtLbl.frame = CGRect(x: 15, y: orderIdLbl.frame.origin.y+orderIdLbl.frame.size.height+3, width: headerView.frame.size.width - (20), height: 15)
            
//            orderIdTxtLbl.text = orderID
            
            let expiryDate = (orderDetailsDict.value(forKey: "createdDate") as? String) ?? ""
            let convertedExpiryDate = convertServerDateFormatter(date: expiryDate)
            orderIdTxtLbl.text = convertedExpiryDate

            
            orderIdTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            orderIdTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
            headerView.addSubview(orderIdTxtLbl)
            
            let sepLbl = UILabel()
            sepLbl.frame = CGRect(x: 3, y: orderIdTxtLbl.frame.size.height+orderIdTxtLbl.frame.origin.y+8, width: headerView.frame.size.width - (6), height: 1)
            sepLbl.backgroundColor = hexStringToUIColor(hex: "e6effa")
            headerView.addSubview(sepLbl)
            
            let titleHeaderView = UIView()
            titleHeaderView.frame = CGRect(x: 0, y: orderIdTxtLbl.frame.size.height+orderIdTxtLbl.frame.origin.y+(20), width: headerView.frame.size.width, height: 100)
            headerView.addSubview(titleHeaderView)
            
            let stackView = UIStackView()
            stackView.frame = CGRect(x: 10, y: 0, width: headerView.frame.size.width - 20, height: 40)
            stackView.distribution = .fillEqually
            titleHeaderView.addSubview(stackView)
            
            let view1 = UIView()
            view1.frame = CGRect(x: 0, y: 0, width: stackView.frame.size.width/2, height: stackView.frame.size.height)
    //        view1.backgroundColor = .orange
            stackView.addSubview(view1)
            
            let prodCountLbl = UILabel()
            prodCountLbl.frame = CGRect(x: 5, y: 2, width: view1.frame.size.width - (10), height: 15)
            prodCountLbl.text = "Product Count "
            prodCountLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            prodCountLbl.textColor = hexStringToUIColor(hex: "5f829c")
            view1.addSubview(prodCountLbl)

            let prodCountTxtLbl = UILabel()
            prodCountTxtLbl.frame = CGRect(x: 5, y: prodCountLbl.frame.origin.y+prodCountLbl.frame.size.height + 2, width: view1.frame.size.width - (10), height: 17)
            let prodCountArr = orderDetailsDict.value(forKey: "productsList") as? NSArray
            prodCountTxtLbl.text = String(prodCountArr?.count ?? 0)
            prodCountTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
            prodCountTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
            view1.addSubview(prodCountTxtLbl)
            
            let view2 = UIView()
            view2.frame = CGRect(x: view1.frame.origin.x+view1.frame.size.width, y: 0, width: stackView.frame.size.width/2, height: stackView.frame.size.height)
    //        view2.backgroundColor = .gray
            stackView.addSubview(view2)
            
            let accIdLbl = UILabel()
            accIdLbl.frame = CGRect(x: 5, y: 2, width: view2.frame.size.width - (10), height: 15)
            accIdLbl.text = "Account ID"
            accIdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            accIdLbl.textColor = hexStringToUIColor(hex: "5f829c")
            view2.addSubview(accIdLbl)

            let accIdTxtLbl = UILabel()
            accIdTxtLbl.frame = CGRect(x: 5, y: accIdLbl.frame.origin.y+accIdLbl.frame.size.height + 2, width: view2.frame.size.width - (10), height: 17)
            accIdTxtLbl.text = orderDetailsDict.value(forKey: "accountId") as! String
            accIdTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
            accIdTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
            view2.addSubview(accIdTxtLbl)

            
            
            let stackView2 = UIStackView()
            stackView2.frame = CGRect(x: 10, y: stackView.frame.origin.y+stackView.frame.size.height+10, width: headerView.frame.size.width - 20, height: 65)
            stackView2.distribution = .fillEqually
            titleHeaderView.addSubview(stackView2)
            
//            let doorDeliveryLbl = UILabel()
//            doorDeliveryLbl.frame = CGRect(x: 5, y: 2, width: view3.frame.size.width - (10), height: 15)
//            doorDeliveryLbl.text = "Door Delivery"
//            doorDeliveryLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
//            doorDeliveryLbl.textColor = hexStringToUIColor(hex: "5f829c")
//            view3.addSubview(doorDeliveryLbl)
//
//            let doorDeliveryTxtLbl = UILabel()
//            doorDeliveryTxtLbl.frame = CGRect(x: 5, y: doorDeliveryLbl.frame.origin.y+doorDeliveryLbl.frame.size.height + 2, width: headerView.frame.size.width - (10), height: 17)
//            doorDeliveryTxtLbl.text = "Yes"
//            doorDeliveryTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
//            doorDeliveryTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
//            view3.addSubview(doorDeliveryTxtLbl)
            

            
            let view11 = UIView()
            view11.frame = CGRect(x: 0, y: 0, width: stackView.frame.size.width/2, height: stackView.frame.size.height)
    //        view11.backgroundColor = .orange
            stackView2.addSubview(view11)
            
            let orderPriceLbl = UILabel()
            orderPriceLbl.frame = CGRect(x: 5, y: 2, width: view11.frame.size.width - (10), height: 15)
            orderPriceLbl.text = "Order Price "
            orderPriceLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            orderPriceLbl.textColor = hexStringToUIColor(hex: "5f829c")
            view11.addSubview(orderPriceLbl)

            let orderPriceTxtLbl = UILabel()
            orderPriceTxtLbl.frame = CGRect(x: 5, y: orderPriceLbl.frame.origin.y+orderPriceLbl.frame.size.height + 2, width: view2.frame.size.width - (10), height: 17)
            let price = orderDetailsDict.value(forKey: "orderPrice") as? Int
            orderPriceTxtLbl.text = String(price ?? 0)
            orderPriceTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
            orderPriceTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
            view11.addSubview(orderPriceTxtLbl)

            let view22 = UIView()
            view22.frame = CGRect(x: view11.frame.origin.x+view11.frame.size.width, y: 0, width: stackView2.frame.size.width/2, height: stackView.frame.size.height)
    //        view22.backgroundColor = .gray
            stackView2.addSubview(view22)

            let locationDetailsLbl = UILabel()
            locationDetailsLbl.frame = CGRect(x: 5, y: 2, width: view22.frame.size.width - (10), height: 15)
            locationDetailsLbl.text = "Location"
            locationDetailsLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            locationDetailsLbl.textColor = hexStringToUIColor(hex: "5f829c")
            view22.addSubview(locationDetailsLbl)

            let locationDetailsTxtLbl = UILabel()
            locationDetailsTxtLbl.frame = CGRect(x: 5, y: locationDetailsLbl.frame.origin.y+locationDetailsLbl.frame.size.height + 2, width: view22.frame.size.width - (10), height: 42)
            locationDetailsTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
            locationDetailsTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
            view22.addSubview(locationDetailsTxtLbl)
            
            locationDetailsTxtLbl.numberOfLines = 0
            
            let accDetailsDict = orderDetailsDict.value(forKey: "accountDetails") as? NSDictionary
            let addressStr = accDetailsDict?.value(forKey: "address") as? String
            locationDetailsTxtLbl.text = addressStr
            
            let sepView = UIView()
            sepView.frame = CGRect(x: 0, y: stackView2.frame.origin.y+stackView2.frame.size.height+10, width: tableView.frame.size.width, height: 5)
            sepView.backgroundColor = hexStringToUIColor(hex: "e6effa")
            titleHeaderView.addSubview(sepView)

            let acceptBtn = UIButton()
            acceptBtn.frame = CGRect(x:headerView.frame.size.width/2 - 60, y: stackView2.frame.origin.y + stackView2.frame.size.height + 10 , width: 120, height: 40)
            acceptBtn.setTitle("Accept", for: UIControl.State.normal)
            acceptBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            acceptBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
            acceptBtn.backgroundColor = hexStringToUIColor(hex: "232c51")
            acceptBtn.layer.cornerRadius = 5
            acceptBtn.clipsToBounds = true

        }
        
        
//        titleHeaderView.addSubview(acceptBtn)
        
//        let orderID = openOrdersResult[section].orderId ?? "0"
//        orderIdTxtLbl.text = String(orderID)

        return headerView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 195
        
    }
    
    func updateDetailsViewUI()  {
        
        deliveryStatusStr = ""
        
//        hiddenBtn = UIButton()
        hiddenBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)
        
        updateDetailsView = UIView()
        updateDetailsView.frame = CGRect(x: 20, y: self.view.frame.size.height/2-(120), width: self.view.frame.size.width - (40), height: 240)
        updateDetailsView.backgroundColor = UIColor.white
        updateDetailsView.layer.cornerRadius = 10
        updateDetailsView.layer.masksToBounds = true
        self.view.addSubview(updateDetailsView)
        
        //Change Pwd Lbl
        
        let changePwdLbl = UILabel()
        changePwdLbl.frame = CGRect(x: 10, y: 5, width: updateDetailsView.frame.size.width - (60), height: 40)
        changePwdLbl.text = "      Update Delivery Status"
        changePwdLbl.textAlignment = NSTextAlignment.center
        changePwdLbl.font = UIFont.init(name: kAppFontBold, size: 14)
        changePwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        updateDetailsView.addSubview(changePwdLbl)
        
        //Cancel Btn
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: updateDetailsView.frame.size.width - 40, y: 5, width: 40, height: 40)
        cancelBtn.setImage(UIImage.init(named: "cancel"), for: UIControl.State.normal)
        cancelBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        updateDetailsView.addSubview(cancelBtn)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        
        //Seperator Line Lbl
        
        let seperatorLine = UILabel()
        seperatorLine.frame = CGRect(x: 0, y: changePwdLbl.frame.origin.y+changePwdLbl.frame.size.height, width: updateDetailsView.frame.size.width , height: 1)
        seperatorLine.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
        updateDetailsView.addSubview(seperatorLine)
        
        //Current Pwd Lbl

        let currentPwdLbl = UILabel()
        currentPwdLbl.frame = CGRect(x: 10, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: updateDetailsView.frame.size.width - (20), height: 20)
        currentPwdLbl.text = "Status"
        currentPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        currentPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        updateDetailsView.addSubview(currentPwdLbl)

        //Current Pwd TF

        selectStatusBtn.frame = CGRect(x: 10, y: currentPwdLbl.frame.origin.y+currentPwdLbl.frame.size.height+5, width: updateDetailsView.frame.size.width - (20), height: 45)
        selectStatusBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
        selectStatusBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: .normal)
        selectStatusBtn.setTitle("    Select", for: .normal)
        selectStatusBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        selectStatusBtn.addTarget(self, action: #selector(selectStatusBtnTap), for: .touchUpInside)
        updateDetailsView.addSubview(selectStatusBtn)
        
        selectStatusBtn.layer.borderWidth = 1
        selectStatusBtn.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
        selectStatusBtn.layer.cornerRadius = 3
        selectStatusBtn.clipsToBounds = true

        selectStatusBtn.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        selectStatusBtn.layer.cornerRadius = 3
        selectStatusBtn.clipsToBounds = true
        
        let updateBtn = UIButton()
        updateBtn.frame = CGRect(x:updateDetailsView.frame.size.width/2 - (90), y: selectStatusBtn.frame.origin.y+selectStatusBtn.frame.size.height+40, width: 80, height: 40)
        updateBtn.setTitle("CLOSE", for: UIControl.State.normal)
        updateBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        updateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        updateBtn.backgroundColor = hexStringToUIColor(hex: "232c51")
        updateBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)

        updateDetailsView.addSubview(updateBtn)
        
        let submitBtn = UIButton()
        submitBtn.frame = CGRect(x:updateDetailsView.frame.size.width/2 + (10), y: selectStatusBtn.frame.origin.y+selectStatusBtn.frame.size.height+40, width: 80, height: 40)
        submitBtn.setTitle("SUBMIT", for: UIControl.State.normal)
        submitBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        submitBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        submitBtn.backgroundColor = hexStringToUIColor(hex: "0f5fee")
        submitBtn.addTarget(self, action: #selector(submitStatusBtnTap), for: .touchUpInside)

        updateDetailsView.addSubview(submitBtn)


        updateBtn.layer.cornerRadius = 3
        updateBtn.layer.masksToBounds = true
        
    }
    
    @objc func submitStatusBtnTap(sender:UIButton){
        
//        let dataDict =
        
        submitSelectStatusAPI(prodDataDict: selectStatusDataDict)
    }
    
    @objc func cancelBtnTap(sender: UIButton!){
        
        hiddenBtn.removeFromSuperview()
        updateDetailsView.removeFromSuperview()

    }
    
    @objc func selectStatusBtnTap(sender:UIButton){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select Status"
        viewTobeLoad.fields = self.categoryDataArray as! [String]
        viewTobeLoad.categoryIDs = self.categoryDataArray as! [String]
        viewTobeLoad.modalPresentationStyle = .fullScreen
       self.navigationController?.pushViewController(viewTobeLoad, animated: true)

    }
    
    @objc func updateDeliveryStatusBtnTap(sender: UIButton!){
        
        selectStatusDataDict = NSDictionary()
        
        let productDict = orderDetailsArray[sender.tag] as! NSDictionary
                selectStatusDataDict = productDict.value(forKey: "productsResult") as! NSDictionary

        updateDetailsViewUI()
    }

    func getOrderDetailsAPI() {
        
        var statusStr = ""
        
        if(isActiveStatusStr == "Active"){
            statusStr = "Pending"
             
        }else if(isActiveStatusStr == "Completed"){
            statusStr = "Completed"

        }else{
            statusStr = "Cancelled"

        }
        
        orderDetailsArray.removeAllObjects()
        
        orderDetailsArray = NSMutableArray()
        orderDetailsDict = NSMutableDictionary()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + OrderProductDetailsUrl + idStr + "/\(statusStr)"
                            serviceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                let dataDict = result as! NSDictionary
                                
                                self.orderDetailsDict = dataDict.value(forKey: "orderSummary") as! NSDictionary
                                self.orderDetailsArray = dataDict.value(forKey: "productsList") as! NSMutableArray
                                self.vendorTblView.reloadData()
                                
                                if(self.orderDetailsArray.count > 0){
                                    self.emptyMsgBtn.removeFromSuperview()
                                    
                                    print(self.accountID)

                                }else if(self.orderDetailsArray.count == 0){
//                                    self.showEmptyMsgBtn()
                                }
                                
//                                let userId = respVo.result![0].productDict?.accountEmailId
//                                print(userId)
                                
                            }
                            else {
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
        
                       if(self.orderDetailsArray.count == 0){
//                           self.showEmptyMsgBtn()
                    }
                }
    
    
    func submitSelectStatusAPI(prodDataDict:NSDictionary) {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + UpdateOrderDetailsAPI
        let idString = orderDetailsDict.value(forKey: "_id") as? String
        let orderID = orderDetailsDict.value(forKey: "orderId") as! String
        
        let productID = prodDataDict.value(forKey: "_id") as? String
        
        
        let headerData = ["":""]
        
        let params_IndividualLogin = ["_id":idString,"orderId":orderID,"productId":productID,"deliveryStatus":deliveryStatusStr] as [String : Any]
        
        serviceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: headerData as NSDictionary, successHandler: { (result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                self.showAlertWith(title: "Success", message:"Details updated successfully")
                                
                                sleep(3)
                                
                                self.hiddenBtn.removeFromSuperview()
                                self.updateDetailsView.removeFromSuperview()

                                self.getOrderDetailsAPI()

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
    
    func acceptRequestAPI(prodDataArray:NSArray) {
        
//        Accept--- {"_id":"608fc26ac4ce704244ba7cc4","orderStatus":"Approved","productsList":[{"productId":"6089571d41135756a7336b09","checked":true}]}
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + VendorUpdateProductStatusUrl
        let idString = orderDetailsDict.value(forKey: "_id") as? String
        
        let headerData = ["":""]
        
        let params_IndividualLogin = ["_id":idString,"orderStatus":"Approved","productsList":prodDataArray] as [String : Any]
        
        serviceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: headerData as NSDictionary, successHandler: { (result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                self.showAlertWith(title: "Success", message:"Accepted successfully")
                                self.orderStatus = "Approved"
                                self.vendorTblView.tableFooterView?.isHidden = true
                                
                                self.getOrderDetailsAPI()
                                
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


