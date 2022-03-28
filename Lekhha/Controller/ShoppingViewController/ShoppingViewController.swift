//
//  ShoppingViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 13/10/20.
//  Copyright © 2020 Longdom. All rights reserved.

import UIKit
import ObjectMapper
import DropDown

class ShoppingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,sendLocalShoppingSearchDetails {
    
    var isSelectAllCheckBoxBtnTapped = Bool()
    var isDeleteBtnTapped = Bool()
    var shoppingDeleteArray = NSMutableArray()
    var isAppLoadedFirstTime = Bool()
    var sideMenuView = SideMenuView()
    var tabStatusStr = ""

    @IBAction func onClickReloadButton(_ sender: UIButton) {
        localSearchShoppingCart=""
        
            self.getShoppingCartListAPI()
        shoppingCartTblView.isHidden=false
        shoppingCartTblView.reloadData()
        
    }
    @IBOutlet var reloadButton: UIButton!
    @IBOutlet weak var selectCheckBoxBtn: UIButton!
    
    @IBAction func selectCheckBoxBtnTap(_ sender: UIButton) {
        
//        isDeleteBtnTapped = false
        
        if(isShoppingCart){
            
            if sender.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
                isSelectAllCheckBoxBtnTapped = true
                sender.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
                
                for i in 0..<shoppingCartResult.count {

                    let dataDict = shoppingCartResult.object(at: i) as? NSDictionary
                    dataDict?.setValue("1", forKey: "isChecked")
                    self.shoppingCartResult.replaceObject(at: i, with: dataDict!)
                    
                    let idStr = dataDict?.value(forKey: "_id") as? String
                    
                        let shoppingDict = NSMutableDictionary()
                        shoppingDict.setValue(idStr, forKey: "id")
                        shoppingDeleteArray.add(shoppingDict)

                    
                }
            }else{
                isSelectAllCheckBoxBtnTapped = false
                sender.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
                
                shoppingDeleteArray.removeAllObjects()
                shoppingDeleteArray = NSMutableArray()
                
                for i in 0..<shoppingCartResult.count {

                    let dataDict = shoppingCartResult.object(at: i) as? NSDictionary
                    dataDict?.setValue("0", forKey: "isChecked")
                    self.shoppingCartResult.replaceObject(at: i, with: dataDict!)
                    
                }
            }
        }else{
            
            if sender.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
                isSelectAllCheckBoxBtnTapped = true
                sender.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
                
                for i in 0..<savedCartResult.count {

                    let dataDict = savedCartResult.object(at: i) as? NSDictionary
                    dataDict?.setValue("1", forKey: "isChecked")
                    self.savedCartResult.replaceObject(at: i, with: dataDict!)
                    
                    let idStr = dataDict?.value(forKey: "_id") as? String
                    
                        let shoppingDict = NSMutableDictionary()
                        shoppingDict.setValue(idStr, forKey: "id")
                        shoppingDeleteArray.add(shoppingDict)

                    
                }
            }else{
                isSelectAllCheckBoxBtnTapped = false
                sender.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
                
                shoppingDeleteArray.removeAllObjects()
                shoppingDeleteArray = NSMutableArray()
                
                for i in 0..<savedCartResult.count {

                    let dataDict = savedCartResult.object(at: i) as? NSDictionary
                    dataDict?.setValue("0", forKey: "isChecked")
                    self.savedCartResult.replaceObject(at: i, with: dataDict!)
                    
                }
            }
        }


        self.shoppingCartTblView.reloadData()
    }
    
    @IBOutlet weak var selectAllBtn: UIButton!
    
    @IBAction func deleteBtnTap(_ sender: UIButton) {
        
        isAppLoadedFirstTime = false
        
        if(isShoppingCart){
            if(isDeleteBtnTapped){
                if(shoppingDeleteArray.count == 0){
//                    self.showAlertWith(title: "Alert !!", message: "Select at least one record to delete")
                    
                    self.productLbl.isHidden = false
                    self.selectCheckBoxBtn.isHidden = true
                    self.selectAllBtn.isHidden = true
                    
                    isDeleteBtnTapped = false
                    isAppLoadedFirstTime = true
                    self.shoppingCartTblView.reloadData()
                    
                }else{
                    deleteShoppingCartListAPI()
                }
                
            }else{
                self.productLbl.isHidden = true
                self.selectCheckBoxBtn.isHidden = false
                self.selectAllBtn.isHidden = false
                
                isDeleteBtnTapped = true
                self.shoppingCartTblView.reloadData()

            }
        }else{
            if(isDeleteBtnTapped){
                
                if(shoppingDeleteArray.count == 0){
                    self.showAlertWith(title: "Alert !!", message: "Select at least one record to delete")
                    
                }else{
                    deleteSavedCartListAPI()

                }
            }else{
                self.productLbl.isHidden = true
                self.selectCheckBoxBtn.isHidden = false
                self.selectAllBtn.isHidden = false
                
                isDeleteBtnTapped = true
                self.shoppingCartTblView.reloadData()

            }
        }
    }
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var consumerConnectBtn: UIButton!
    
    @IBAction func consumerConnectBtnTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConsumerConnectViewController") as! ConsumerConnectViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func vendorConnectBtnTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VendorConnectVC") as! VendorConnectVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBOutlet weak var vendorConnectBtn: UIButton!
    
    //    func sendShoppingLocalSearchDetailsData(ShoppingCartResult dataArray: ShoppingCartResult, statusStr: String) {
        
//    }

    @IBOutlet weak var placeOrderBtn: UIButton!
    
    @IBOutlet weak var tblViewBottomConstant: NSLayoutConstraint!
    
    @IBOutlet weak var lookingForTxtField: UITextField!
    
    var shoppingServiceCntrl = ServiceController()
//    var shoppingCartResult = [ShoppingCartResult]()
//    var savedCartResult = [SavedCartResult]()
    
    var shoppingCartEditResult =  [ShoppingCartResult]()
    var savedCartEditResult = [SavedCartResult]()
    
    var shoppingCartResult = NSMutableArray()
    var savedCartResult = NSMutableArray()

    var localSortView = LocalSortView()
    var searchOrderString = "purchaseDate"
    var sortOrderString = "Ascending"

    var emptyMsgBtn = UIButton()
    var accountID = String()
    
    var prodIdStr:NSString!
    var accIdStr:NSString!
    var purchaseDateStr:NSString!
    var reqQtyStr:NSString!
    var cartIdStr:NSString!
    var savedListIdStr:NSString!
    var vendorIdStr:NSString!

    var isShoppingCart: Bool!
    
    var shoppingAddProductView = ShoppingAddProductView()
    
    @IBOutlet weak var localSearchView: UIView!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var localSearchTF: UITextField!
    @IBOutlet weak var purchaseDateBtn: UIButton!
    @IBOutlet weak var expireDateBtn: UIButton!
    @IBOutlet weak var quantityBtn: UIButton!
    @IBOutlet weak var datesBgView: UIView!
    @IBOutlet weak var quantityBgView: UIView!
    @IBOutlet weak var purchaseDateView: UIView!
    @IBOutlet weak var purchaseDateLabel: UILabel!
    @IBOutlet weak var purchaseDateSelectBtn: UIButton!
    @IBOutlet weak var expireDateView: UIView!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var expireDateSelectBtn: UIButton!
    @IBOutlet weak var stockQuantityBgView: UIView!
    @IBOutlet weak var stockQuantityLabel: UILabel!
    @IBOutlet weak var stockQuantitySelectBtn: UIButton!
    @IBOutlet weak var localSearchApplyBtn: UIButton!
    
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var datesViewHeight: NSLayoutConstraint!
    var isFilter = String()
    var localSerCntrl = ServiceController()
    var filtersDataArray = NSMutableArray()
    
    var datePicker = UIDatePicker()
    let datePickerTwo = UIDatePicker()
    
    // MARK: Create Date Picker Methods
    func createDatePicker() {
        
//        datePicker.maximumDate = Date()
        
        if #available(iOS 13.4, *) {
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = .wheels
                
            } else {
                // Fallback on earlier versions
                datePicker.preferredDatePickerStyle = .wheels
            }
        } else {
            // Fallback on earlier versions
            //            datePicker.preferredDatePickerStyle = .inline
        }
        datePicker.datePickerMode = .date
        startDateTF.inputView = datePicker
        startDateTF.inputAccessoryView = createToolbar()
    }
    // MARK: Create Toolbar Methods
    func createToolbar() -> UIToolbar {
        //toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //done Button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed))
        toolBar.setItems([cancelBtn,doneBtn], animated: true)
        return toolBar
    }
    func createToolbar2() -> UIToolbar {
        //toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //done Button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed2))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed2))
        toolBar.setItems([cancelBtn,doneBtn], animated: true)
        return toolBar
    }
    func createDatePicker2() {
        
//        datePickerTwo.maximumDate = Date()
        
        if #available(iOS 13.4, *) {
            if #available(iOS 14.0, *) {
                datePickerTwo.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
                datePickerTwo.preferredDatePickerStyle = .wheels
            }
        } else {
            // Fallback on earlier versions
            //            datePicker.preferredDatePickerStyle = .inline
        }
        datePickerTwo.datePickerMode = .date
        endDateTF.inputView = datePickerTwo
        endDateTF.inputAccessoryView = createToolbar2()
    }
    var filterDataArray = NSMutableArray()

    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
    
    var filterSortStatus = String()
    var searchFilterStatusStr = String()
    var filterKeyStr = String()
    var moduleKeyStr = String()
    var filterStartDateStr = String()
    var filetEndDateStr = String()
    var isLocalSearch = String()
    var stockQuanStr = String()
    @objc func donePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .none
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "dd/MM/yyyy"
        self.startDateTF.text = dateFormatter1.string(from: datePicker.date)
        self.filterStartDateStr = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    // Cancel Pressed2
    @objc func cancelPressed() {
        self.view.endEditing(true)
    }
    
    // Cancel Pressed2
    @objc func cancelPressed2() {
        self.view.endEditing(true)
    }
    // Done Pressed2
    @objc func donePressed2(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .none
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "dd/MM/yyyy"
        self.endDateTF.text = dateFormatter1.string(from: datePickerTwo.date)
        self.filetEndDateStr = dateFormatter.string(from: datePickerTwo.date)
        self.view.endEditing(true)
    }
   
    @IBAction func localSearchApplyBtnAction(_ sender: Any) {
        
        transparentView.isHidden=true
        if(localSearchTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Please enter a keyword to search")
            return
        }
//        filterLocalSearchApplyAPI()
        filterPopupLocalSearchApplyAPI()
        
    }
    let dropDown = DropDown()
    @IBAction func stockQuantityBtnTap(_ sender: UIButton) {
        
        dropDown.dataSource = ["1-20","20-40","40-80","80-100","Above 100"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.stockQuantityLabel.text = item
            }
    }
    @IBAction func expireDateBtnTap(_ sender: Any) {
    }
    @IBAction func purchaseDateBtnAction(_ sender: Any) {
        
//        showDatePicker()
//        createDatePicker()
    }
    @IBAction func clearBtnAction(_ sender: Any) {
        
        localSearchShoppingCart=""
        localSearchTF.text = ""
        startDateTF.text = ""
        endDateTF.text = ""
//        stockQuantityLabel.text = "1-20"
        filetEndDateStr = ""
        createDatePicker()
        createDatePicker2()
        
        datesBgView.isHidden = true
        quantityBgView.isHidden = true
        datesViewHeight.constant = 30
        
        moduleStatusStr = "shoppingCart"
        
        stockQuantityLabel.text = "1-20"
        
        localSearchView.isHidden = true
        transparentView.isHidden=true
        purchaseDateBtn.layer.cornerRadius = 8
        purchaseDateBtn.layer.borderColor = UIColor.lightGray.cgColor
        purchaseDateBtn.layer.borderWidth = 0.5
        purchaseDateBtn.clipsToBounds = true
        
//        expireDateBtn.layer.cornerRadius = 8
//        expireDateBtn.layer.borderColor = UIColor.lightGray.cgColor
//        expireDateBtn.layer.borderWidth = 0.5
//        expireDateBtn.clipsToBounds = true
        
        quantityBtn.layer.cornerRadius = 8
        quantityBtn.layer.borderColor = UIColor.lightGray.cgColor
        quantityBtn.layer.borderWidth = 0.5
        quantityBtn.clipsToBounds = true
        
        localSearchView.backgroundColor = .white
        localSearchView.layer.cornerRadius = 5.0
        localSearchView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        localSearchView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        localSearchView.layer.shadowRadius = 6.0
        localSearchView.layer.shadowOpacity = 0.7
        
        purchaseDateView.layer.borderColor = UIColor.gray.cgColor
        purchaseDateView.layer.borderWidth = 0.5
        purchaseDateView.layer.cornerRadius = 3
        purchaseDateView.clipsToBounds = true
        
        expireDateView.layer.borderColor = UIColor.gray.cgColor
        expireDateView.layer.borderWidth = 0.5
        expireDateView.layer.cornerRadius = 3
        expireDateView.clipsToBounds = true
        
        stockQuantityBgView.layer.borderColor = UIColor.gray.cgColor
        stockQuantityBgView.layer.borderWidth = 0.5
        stockQuantityBgView.layer.cornerRadius = 3
        stockQuantityBgView.clipsToBounds = true
        
        quantityBgView.isHidden = true
        
        purchaseDateBtn.backgroundColor = .white
        purchaseDateBtn.setTitleColor(.lightGray, for: .normal)
//        expireDateBtn.backgroundColor = .white
//        expireDateBtn.setTitleColor(.lightGray, for: .normal)
        quantityBtn.backgroundColor = .white
        quantityBtn.setTitleColor(.lightGray, for: .normal)
        
        localSearchView.isHidden = true
        transparentView.isHidden=true
        filterStartDateStr = ""
            self.getShoppingCartListAPI()

        
    }
    @IBAction func closeBtnAction(_ sender: Any) {
        
        localSearchView.isHidden = true
        transparentView.isHidden=true
    }
    @IBAction func purchaseBtnAction(_ sender: Any) {
        
        filterKeyStr = "purchaseDate"
        
        datesViewHeight.constant = 100
        datesBgView.isHidden = false
        quantityBgView.isHidden = true
        purchaseDateBtn.backgroundColor = .blue
        purchaseDateBtn.setTitleColor(.white, for: .normal)
//        expireDateBtn.backgroundColor = .white
//        expireDateBtn.setTitleColor(.lightGray, for: .normal)
        quantityBtn.backgroundColor = .white
        quantityBtn.setTitleColor(.lightGray, for: .normal)
    }
    @IBAction func expireDateBtnAction(_ sender: Any) {
        
        filterKeyStr = "expiryDate"
        
        datesViewHeight.constant = 100
        datesBgView.isHidden = false
        quantityBgView.isHidden = true
        purchaseDateBtn.backgroundColor = .white
        purchaseDateBtn.setTitleColor(.lightGray, for: .normal)
       // expireDateBtn.backgroundColor = .blue
       // expireDateBtn.setTitleColor(.white, for: .normal)
        quantityBtn.backgroundColor = .white
        quantityBtn.setTitleColor(.lightGray, for: .normal)
        
    }
    @IBAction func quantityBtnAction(_ sender: Any) {
        
        filterKeyStr = "stockQuantity"
        
        datesViewHeight.constant = 100
        datesBgView.isHidden = true
        quantityBgView.isHidden = false
        purchaseDateBtn.backgroundColor = .white
        purchaseDateBtn.setTitleColor(.lightGray, for: .normal)
//        expireDateBtn.backgroundColor = .white
//        expireDateBtn.setTitleColor(.lightGray, for: .normal)
        quantityBtn.backgroundColor = .blue
        quantityBtn.setTitleColor(.white, for: .normal)
    }
    var moduleStatusStr = String()
   
    func filterPopupLocalSearchApplyAPI()
    {
        
        searchFilterStatusStr = localSearchTF.text ?? ""
        stockQuanStr = stockQuantityLabel.text ?? ""
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        moduleKeyStr = "shoppingCart"

        
        var URLString_loginIndividual = ""
        
        if filterKeyStr == "purchaseDate" {
            
            URLString_loginIndividual = Constants.BaseUrl + LocalSearchFilterUrl + accountID as String + "/\(searchFilterStatusStr)" + "/\(filterKeyStr)" + "/\(filterStartDateStr)" + "/\(filetEndDateStr)" + "/\(moduleKeyStr)"
            
        }
        else if filterKeyStr == "expiryDate" {
            
            URLString_loginIndividual = Constants.BaseUrl + LocalSearchFilterUrl + accountID as String + "/\(searchFilterStatusStr)" + "/\(filterKeyStr)" + "/\(filterStartDateStr)" + "/\(filetEndDateStr)" + "/\(moduleKeyStr)"
        }
        else if filterKeyStr == "stockQuantity" {
            
//            ["1-20","20-40","40-80","80-100","Above 100"]
            
            if stockQuanStr == "1-20"{
                
                stockQuanStr = "1/20"
            }
            else if stockQuanStr == "20-40"{
                
                stockQuanStr = "20/40"
            }
            else if stockQuanStr == "40-80"{
                
                stockQuanStr = "40/80"
            }
            else if stockQuanStr == "80-100"{
                
                stockQuanStr = "80/100"
            }
            else if stockQuanStr == "Above 100"{
                
                stockQuanStr = "100/10000"
            }
            
            URLString_loginIndividual = Constants.BaseUrl + LocalSearchFilterUrl + accountID as String + "/\(searchFilterStatusStr)" + "/\(filterKeyStr)" + "/\(stockQuanStr)" + "/\(moduleKeyStr)"
        }
        else
        {
            URLString_loginIndividual = Constants.BaseUrl + LocalSearchUrl + accountID as String + "/\(searchFilterStatusStr)" + "/shoppingCart"
          
        }
        URLString_loginIndividual = URLString_loginIndividual.replacingOccurrences(of: " ", with: "%20")
        localSearchShoppingCart=URLString_loginIndividual
        
        let urlString = URLString_loginIndividual.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
        localSerCntrl.requestGETURL(strURL:urlString!, success: {(result) in
            
            let dataDict = result as! NSDictionary

                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")

                if(statusCode == 200 ){
                    
//                    var shoppingCartResult = NSMutableArray()
                    var currentInventoryResultt = NSMutableArray()
//                    var openOrdersManagementResult = NSMutableArray()
//                    var orderHistoryManagementresult = NSMutableArray()
                    
                    if(self.moduleStatusStr == "shoppingCart"){
                        currentInventoryResultt = dataDict.value(forKey: "shoppingCartresult") as! NSMutableArray
                        
                        self.shoppingCartResult = currentInventoryResultt
                        self.shoppingCartTblView.reloadData()
                        
                        self.localSearchView.isHidden = true
                        self.transparentView.isHidden=true
                        
                        if(self.shoppingCartResult.count > 0){
                            self.emptyMsgBtn.removeFromSuperview()
                            
                            self.shoppingCartTblView.isHidden = false
                            
                            print(self.accountID)
                            

                        }else{
                            self.shoppingCartTblView.isHidden = true
                            self.showEmptyMsgBtn()
                        }
                    }
                  
       /*         if(shoppingCartResult.count > 0){
                    for i in 0..<shoppingCartResult.count {
                        self.filtersDataArray.add(shoppingCartResult[i])
                    }

                }
                if(currentInventoryResultt.count > 0){
                    for i in 0..<currentInventoryResult.count {
                        self.filtersDataArray.add(currentInventoryResultt[i])
                    }

                }
                if(openOrdersManagementResult.count > 0){
                    for i in 0..<openOrdersManagementResult.count {
                        self.filtersDataArray.add(openOrdersManagementResult[i])
                    }

                }
                if(orderHistoryManagementresult.count > 0){
                    for i in 0..<orderHistoryManagementresult.count {
                        self.filtersDataArray.add(orderHistoryManagementresult[i])
                    }
                }
                    */
                                
                    print("Filters Data is \(self.filtersDataArray)")
                    
//                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                    let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
//                    VC.modalPresentationStyle = .fullScreen
//                    VC.isFilter = "1"
//                    VC.filterDataArray = self.filtersDataArray
//                    self.present(VC, animated: true, completion: nil)

                            }else{
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                            
                        }
                        else {
                            
                            self.showAlertWith(title: "Alert", message: messageResp ?? "")

                        }
                        
                    }) { (error) in
            self.localSearchView.isHidden = true
            self.transparentView.isHidden=true
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        print("Something Went To Wrong...PLrease Try Again Later")
                    }
                }
    
    func filterLocalSearchApplyAPI()
    {
        
        searchFilterStatusStr = localSearchTF.text ?? ""
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        var URLString_loginIndividual = Constants.BaseUrl + LocalSearchUrl + accountID as String + "/\(searchFilterStatusStr)" + "/\(moduleStatusStr)"
        
        URLString_loginIndividual = URLString_loginIndividual.replacingOccurrences(of: " ", with: "%20")

            
        localSerCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
            
            let dataDict = result as! NSDictionary

                        let respVo:LocalSortRespo = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")

                if(statusCode == 200 ){
                    
//                    var shoppingCartResult = [NSMutableArray]()

                    if self.moduleStatusStr == "shoppingCart"{
                           
                        self.filtersDataArray = dataDict.value(forKey: "currentInventoryresult") as! NSMutableArray
                        self.shoppingCartResult = self.filtersDataArray
                        self.shoppingCartTblView.reloadData()
                        
                        self.localSearchView.isHidden = true
                        self.transparentView.isHidden=true
                        
                        if(self.shoppingCartResult.count > 0){
                            self.emptyMsgBtn.removeFromSuperview()
                            
                            self.shoppingCartTblView.isHidden = false
                            
                            print(self.accountID)
                            

                        }else{
                            self.shoppingCartTblView.isHidden = true
                            self.showEmptyMsgBtn()
                        }
//                        self.delegate?.sendLocalSearchDetailsData(dataArray: filtersDataArray, statusStr: "CurrentInventory")

                    }else if(self.moduleStatusStr == "shoppingCart"){
                        
                        self.filtersDataArray = dataDict.value(forKey: "shoppingCartresult") as! NSMutableArray
                    
                    }
                    if(self.moduleStatusStr == "currentInventory"){
                        
                        if(self.filtersDataArray.count == 0){
                            
                            self.showAlertWith(title: "Alert", message: "No data found")
                            return
                        }
                    }else{
                        
                        if(self.filtersDataArray.count == 0){
                            
                            self.showAlertWith(title: "Alert", message: "No data found")
                            return

                        }
                    }
                    self.navigationController?.popViewController(animated: true)

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
    @IBOutlet weak var topHeaderHeightConstraint: NSLayoutConstraint!
    
    func sendShoppingLocalSearchDetailsData(dataArray: NSMutableArray, statusStr: String) {
        
        shoppingCartResult = NSMutableArray()
        shoppingCartResult = dataArray
        
        shoppingCartTblView.reloadData()
    }
    
    @IBAction func menuBtnTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
        
        toggleSideMenuViewWithAnimation()
        
    }
    
    @IBOutlet weak var bottomSortView: UIView!
    @IBAction func addBottomBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddManualTextProductViewController") as! AddManualTextProductViewController
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)
//        self.present(VC, animated: true, completion: nil)

    }
    
    func toggleSideMenuViewWithAnimation() {
            
            let allViewsInXibArray = Bundle.main.loadNibNamed("SideMenuView", owner: self, options: nil)
             sideMenuView = allViewsInXibArray?.first as! SideMenuView
             sideMenuView.frame = CGRect(x: -320, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
             self.view.addSubview(sideMenuView)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
                self.sideMenuView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.view.addSubview(self.sideMenuView)
                
                self.sideMenuView.loadSideMenuView(viewCntrl: self, status: "")

             }, completion: { (finished: Bool) -> Void in

             })
        }

    @IBAction func sortBottomBtnTap(_ sender: Any) {
        toggleLocalSortViewWithAnimation()
    }
    
    @IBOutlet var transparentView: UIView!
    @IBAction func filterBottomBtnTap(_ sender: Any) {
        
        localSearchView.isHidden = false
        transparentView.isHidden=false
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let VC = storyBoard.instantiateViewController(withIdentifier: "LocalSearchViewController") as! LocalSearchViewController
////        VC.isLocalSearch = "1"
//        VC.modalPresentationStyle = .fullScreen
//        VC.moduleStatusStr = "shoppingCart"
//        VC.delegate1 = self
////        self.present(VC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBOutlet weak var shoppingCartTblView: UITableView!
    
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var savedProductsLbl: UILabel!
    @IBOutlet weak var savedProducts: UIButton!
    @IBOutlet weak var shoppingCartLbl: UILabel!
    @IBOutlet weak var shoppingCartBtn: UIButton!
    var customView = UIView()
    

    @IBAction func shoppingCartBtnTap(_ sender: Any) {
        
        productLbl.isHidden = false
        selectCheckBoxBtn.isHidden = true
        selectAllBtn.isHidden = true
        
        isDeleteBtnTapped = false
        isSelectAllCheckBoxBtnTapped = false
        
        placeOrderBtn.isHidden = false
        tblViewBottomConstant.constant = 83
        
        bottomSortView.isHidden = false
        
        shoppingCartResult.removeAllObjects()
        savedCartResult.removeAllObjects()
        shoppingDeleteArray.removeAllObjects()
        
        shoppingCartResult = NSMutableArray()
        savedCartResult = NSMutableArray()
        
        shoppingDeleteArray = NSMutableArray()
        
        shoppingCartBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
        savedProducts.titleLabel?.font = UIFont.init(name: kAppFont, size: 13)

        savedProductsLbl.isHidden = true
        shoppingCartLbl.isHidden = false
        
        isShoppingCart = true
        
        selectCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        
        self.getShoppingCartListAPI()

    }
    
    
    @IBAction func savedProductsBtnTap(_ sender: Any) {
        
        tabStatusStr = "Saving"
        
        placeOrderBtn.isHidden = true
        
        isDeleteBtnTapped = false
        isSelectAllCheckBoxBtnTapped = false
        
        tblViewBottomConstant.constant = 23
        transparentView.isHidden=true
        bottomSortView.isHidden = true
        
        shoppingCartResult.removeAllObjects()
        savedCartResult.removeAllObjects()
        shoppingDeleteArray.removeAllObjects()

        shoppingCartResult = NSMutableArray()
        savedCartResult = NSMutableArray()
        
        shoppingDeleteArray = NSMutableArray()

        shoppingCartBtn.titleLabel?.font = UIFont.init(name: kAppFont, size: 13)
        savedProducts.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)

        savedProductsLbl.isHidden = false
        shoppingCartLbl.isHidden = true
        
        isShoppingCart = false
        
        productLbl.isHidden = false
        selectCheckBoxBtn.isHidden = true
        selectAllBtn.isHidden = true
        
        selectCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)

        self.getSavedProductsListAPI()

        
//        shoppingCartTblView.reloadData()

    }
    
    @IBAction func consumerConnectBtnTap(_ sender: Any) {
        
        
    }
    
    
    @IBAction func vendorConnectBtnTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VendorConnectVC") as! VendorConnectVC
        self.navigationController?.pushViewController(vc, animated: true)
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
    //Filtter View:
    @IBOutlet weak var filtterTopBtn: UIButton!
   
    
    @IBAction func cancelBtnTap(_ sender: UIButton){

        localSortView.backHiddenBtn.isHidden = false
        localSortView.removeFromSuperview()
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isShoppingCart = true
        lookingForTxtField.delegate = self
        isAppLoadedFirstTime = true
        
        tabStatusStr = "Shopping"
        reloadButton.layer.cornerRadius = 15
        reloadButton.clipsToBounds = true
        
        createDatePicker()
        createDatePicker2()
        
        datesBgView.isHidden = true
        quantityBgView.isHidden = true
        datesViewHeight.constant = 30
        
        moduleStatusStr = "shoppingCart"
        
        stockQuantityLabel.text = "1-20"
        
        localSearchView.isHidden = true
        transparentView.isHidden=true
        purchaseDateBtn.layer.cornerRadius = 8
        purchaseDateBtn.layer.borderColor = UIColor.lightGray.cgColor
        purchaseDateBtn.layer.borderWidth = 0.5
        purchaseDateBtn.clipsToBounds = true
        
//        expireDateBtn.layer.cornerRadius = 8
//        expireDateBtn.layer.borderColor = UIColor.lightGray.cgColor
//        expireDateBtn.layer.borderWidth = 0.5
//        expireDateBtn.clipsToBounds = true
        
        quantityBtn.layer.cornerRadius = 8
        quantityBtn.layer.borderColor = UIColor.lightGray.cgColor
        quantityBtn.layer.borderWidth = 0.5
        quantityBtn.clipsToBounds = true
        
        localSearchView.backgroundColor = .white
        localSearchView.layer.cornerRadius = 5.0
        localSearchView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        localSearchView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        localSearchView.layer.shadowRadius = 6.0
        localSearchView.layer.shadowOpacity = 0.7
        
        purchaseDateView.layer.borderColor = UIColor.gray.cgColor
        purchaseDateView.layer.borderWidth = 0.5
        purchaseDateView.layer.cornerRadius = 3
        purchaseDateView.clipsToBounds = true
        
        expireDateView.layer.borderColor = UIColor.gray.cgColor
        expireDateView.layer.borderWidth = 0.5
        expireDateView.layer.cornerRadius = 3
        expireDateView.clipsToBounds = true
        
        stockQuantityBgView.layer.borderColor = UIColor.gray.cgColor
        stockQuantityBgView.layer.borderWidth = 0.5
        stockQuantityBgView.layer.cornerRadius = 3
        stockQuantityBgView.clipsToBounds = true
        
        quantityBgView.isHidden = true
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        shoppingCartTblView.register(UINib(nibName: "ShppingCartTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingCartCell")

        shoppingCartTblView.delegate = self
        shoppingCartTblView.dataSource = self
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: lookingForTxtField.frame.size.width - (35), y: 0, width: 35, height: lookingForTxtField.frame.size.height)
        lookingForTxtField.rightView = paddingView
        lookingForTxtField.rightViewMode = UITextField.ViewMode.always
        
        lookingForTxtField.delegate = self
        
        let filterBtn = UIButton()
        filterBtn.frame = CGRect(x: paddingView.frame.size.width/2 - 12.5, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
        paddingView.addSubview(filterBtn)

        animatingView()
        
//        customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
//
//        let placeOrderBtn = UIButton()
//        placeOrderBtn.frame = CGRect(x:15, y: 5, width: ((customView.frame.size.width) - 30), height: 40)
//        placeOrderBtn.setTitle("Place Order", for: UIControl.State.normal)
//        placeOrderBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
//        placeOrderBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
//        placeOrderBtn.backgroundColor = hexStringToUIColor(hex: "232c51")
//        placeOrderBtn.layer.cornerRadius = 5
//        placeOrderBtn.clipsToBounds = true
//        customView.addSubview(placeOrderBtn)
        
        let addOrderBtn = UIButton()
        addOrderBtn.frame = CGRect(x:customView.frame.size.width/2 + 15, y: 5, width: (customView.frame.size.width/2) - 30, height: 40)
        addOrderBtn.setTitle("Add Product", for: UIControl.State.normal)
        addOrderBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        addOrderBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        addOrderBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
        addOrderBtn.layer.cornerRadius = 5
        addOrderBtn.clipsToBounds = true

//        customView.addSubview(addOrderBtn)
        
//        placeOrderBtn.addTarget(self, action: #selector(placeOrderBtnTap), for: .touchUpInside)

        addOrderBtn.addTarget(self, action: #selector(addProductBtnTap), for: .touchUpInside)

        customView.backgroundColor = hexStringToUIColor(hex: "e7effa")
        
        selectCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        
//        if(isFilter == "1"){
//            shoppingCartTblView.reloadData()
//
//        }else{
//            self.getShoppingCartListAPI()
//
//        }
        
//        shoppingCartTblView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        
        animatingView()

//        if(shoppingCartResult.count > 0){
////            shoppingCartTblView.reloadData()
//
//        }else{
//
//            shoppingCartResult = NSMutableArray()
//            savedCartResult = NSMutableArray()
//
//            self.getShoppingCartListAPI()
//
//        }
        tabStatusStr = "Shopping"
        if(tabStatusStr == "Shopping"){
            self.getShoppingCartListAPI()

        }else{
            self.getSavedProductsListAPI()

        }
    }
    
    @IBAction func placeOrderedBtnTapped(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
              let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingCartSumaryVC") as! ShoppingCartSummaryViewController
        VC.modalPresentationStyle = .fullScreen
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    
    @IBAction func placeOrderBtnTap(_ sender: UIButton) {
        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//              let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingCartSumaryVC") as! ShoppingCartSummaryViewController
//        VC.modalPresentationStyle = .fullScreen
////        self.present(VC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBAction func addProductBtnTap(_ sender: UIButton) {
//        loadAddProductView()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddManualTextProductViewController") as! AddManualTextProductViewController
        VC.modalPresentationStyle = .fullScreen
                    //      self.navigationController?.pushViewController(VC, animated: true)
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBAction func currentInventoryBtnTap(_ sender: UIButton) {
        
    }
    
    @IBAction func ordersHistoryBtnTap(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddManualTextProductViewController") as! AddManualTextProductViewController
        VC.modalPresentationStyle = .fullScreen
        VC.isEditShopping = "OrderHistory"
                    //      self.navigationController?.pushViewController(VC, animated: true)
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

        
    }
    @IBAction func bothAboveBtnTap(_ sender: UIButton) {
        
    }
    @IBAction func barcodeScanBtnTap(_ sender: UIButton) {
        
    }
    
    @IBAction func addProdCancelBtnTap(_ sender: UIButton) {
        shoppingAddProductView.removeFromSuperview()
        
    }
    
    @IBAction func manualTextBtnTap(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddManualTextProductViewController") as! AddManualTextProductViewController
        VC.modalPresentationStyle = .fullScreen
                    //      self.navigationController?.pushViewController(VC, animated: true)
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    func loadAddProductView() {
            
            let allViewsInXibArray = Bundle.main.loadNibNamed("ShoppingAddProductView", owner: self, options: nil)
            shoppingAddProductView = allViewsInXibArray?.first as! ShoppingAddProductView
            shoppingAddProductView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
             self.view.addSubview(shoppingAddProductView)
        
        shoppingAddProductView.currentInventoryBtn.addTarget(self, action: #selector(currentInventoryBtnTap), for: .touchUpInside)
        shoppingAddProductView.orderHistoryBtn.addTarget(self, action: #selector(ordersHistoryBtnTap), for: .touchUpInside)
        shoppingAddProductView.bothAboveBtn.addTarget(self, action: #selector(bothAboveBtnTap), for: .touchUpInside)
        shoppingAddProductView.barCodeBtn.addTarget(self, action: #selector(barcodeScanBtnTap), for: .touchUpInside)
        shoppingAddProductView.manualTxtViewBtn.addTarget(self, action: #selector(manualTextBtnTap), for: .touchUpInside)
        shoppingAddProductView.cancelBtn.addTarget(self, action: #selector(addProdCancelBtnTap), for: .touchUpInside)
            
//            let path = UIBezierPath(roundedRect:shoppingAddProductView.innerLocalSortView.bounds,
//                                    byRoundingCorners:[.topRight, .topLeft],
//                                    cornerRadii: CGSize(width: 20, height:  20))
//
//            let maskLayer = CAShapeLayer()
//
//            maskLayer.path = path.cgPath
//            shoppingAddProductView.innerLocalSortView.layer.mask = maskLayer
            
//            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
//                self.localSortView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//                self.view.addSubview(self.localSortView)
                
    //       self.sideMenuView.loadSideMenuView(viewCntrl: self, status: "")

//             }, completion: { (finished: Bool) -> Void in
////                self.shoppingAddProductView.backHiddenBtn.isHidden = false
//
//             })
    }
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
//        self.view.insertSubview(emptyMsgBtn, belowSubview: self.FiltterView)
        self.view.insertSubview(emptyMsgBtn, belowSubview: self.transparentView)

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
    
    func toggleLocalSortViewWithAnimation() {
        
        sortOrderString = "Ascending"
        searchOrderString = "purchaseDate"
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("LocalSortView", owner: self, options: nil)
        localSortView = allViewsInXibArray?.first as! LocalSortView
        localSortView.frame = CGRect(x: 0, y: self.view.frame.size.height+350, width: self.view.frame.size.width, height: self.view.frame.size.height)
         self.view.addSubview(localSortView)
        
        localSortView.cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        localSortView.applybtn.addTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        
        localSortView.ascendingBtn.addTarget(self, action: #selector(ascendingBtnTap), for: .touchUpInside)
        localSortView.descendingBtn.addTarget(self, action: #selector(descendingBtnTap), for: .touchUpInside)
        
        localSortView.prodQuanYConstant.constant = 25
        localSortView.prodCheckBtnYConstant.constant = 15
        
        localSortView.expiryDateBtn.isHidden = true
        localSortView.expiryDateTxtBtn.isHidden = true
        
        localSortView.purchaseDateBtn.addTarget(self, action: #selector(purchaseDateBtnTap), for: .touchUpInside)
        localSortView.productDateBtn.addTarget(self, action: #selector(productDateBtnTap), for: .touchUpInside)
        localSortView.quantityBtn.addTarget(self, action: #selector(quantityBtnTap), for: .touchUpInside)

        let path = UIBezierPath(roundedRect:localSortView.innerLocalSortView.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 20, height:  20))

        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        localSortView.innerLocalSortView.layer.mask = maskLayer
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.localSortView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.localSortView)
            
//       self.sideMenuView.loadSideMenuView(viewCntrl: self, status: "")

         }, completion: { (finished: Bool) -> Void in
            self.localSortView.backHiddenBtn.isHidden = false

         })
    }
    
   
    
    @IBAction func applyBtnTap(_ sender: UIButton){

        if(sortOrderString == ""){
            self.showAlertWith(title: "Alert", message: "Please select sort order type")
            return

        }else if(searchOrderString == ""){
            self.showAlertWith(title: "Alert", message: "Please select order type")
            return
        }
        
        getLocalSortAPICall()

    }
    
    @IBAction func ascendingBtnTap(_ sender: UIButton){
        
        localSortView.ascendingBtn.setImage(UIImage.init(named: "radio_active"), for: UIControl.State.normal)
        localSortView.descendingBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        
        sortOrderString = "Ascending"

    }
    
    @IBAction func descendingBtnTap(_ sender: UIButton){
        
        localSortView.ascendingBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        localSortView.descendingBtn.setImage(UIImage.init(named: "radio_active"), for: UIControl.State.normal)

        sortOrderString = "Descending"

    }
    
    @IBAction func purchaseDateBtnTap(_ sender: UIButton){

        localSortView.purchaseDateBtn.setImage(UIImage.init(named: "radio_active"), for: UIControl.State.normal)
        localSortView.expiryDateBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        localSortView.productDateBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        localSortView.quantityBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        
        searchOrderString = "purchaseDate"

    }
    
    
    @IBAction func productDateBtnTap(_ sender: UIButton){

        localSortView.purchaseDateBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        localSortView.expiryDateBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        localSortView.productDateBtn.setImage(UIImage.init(named: "radio_active"), for: UIControl.State.normal)
        localSortView.quantityBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        
        searchOrderString = "productName"

    }
    
    @IBAction func quantityBtnTap(_ sender: UIButton){

        localSortView.purchaseDateBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        localSortView.expiryDateBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        localSortView.productDateBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        localSortView.quantityBtn.setImage(UIImage.init(named: "radio_active"), for: UIControl.State.normal)
        
        searchOrderString = "stockQuantity"

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == lookingForTxtField){
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "GlobalSearchViewController") as! GlobalSearchViewController
                        //      self.navigationController?.pushViewController(VC, animated: true)
            VC.modalPresentationStyle = .fullScreen
//            self.present(VC, animated: true, completion: nil)
            self.navigationController?.pushViewController(VC, animated: true)

            textField.resignFirstResponder()

        }
    }

    
    // MARK: - UITableViewDataSource

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if(isShoppingCart){
                return shoppingCartResult.count

            }else{
                return savedCartResult.count

            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartCell", for: indexPath) as! ShppingCartTableViewCell
            
            if(isShoppingCart){

                let dataDict = shoppingCartResult.object(at: indexPath.row) as? NSDictionary
                
                let finalDict = shoppingCartEditResult[indexPath.row]
//                let priceUnitStr = finalDict.priceUnitDetails?[0].priceUnit ?? ""
//                cell.priceUnitLabel.text = priceUnitStr
                
                cell.priceUnitLabel.text = "₹"
                var stockUnitStr=String()
                if finalDict.stockUnitDetails?.count ?? 0>0
                {
                stockUnitStr = finalDict.stockUnitDetails?[0].stockUnitName ?? ""
                }
                cell.unitLbl.text = stockUnitStr

                let productDict = dataDict?.value(forKey: "productdetails") as? NSDictionary
                
                cell.prodIdLbl.text = productDict?.value(forKey: "productUniqueNumber") as? String
                cell.prodNameLbl.text = productDict?.value(forKey: "productName") as? String
                cell.descLbl.text = productDict?.value(forKey: "description") as? String
//                cell.reqQtyLbl.text = String(shoppingCartResult[indexPath.row].requiredQuantity!)
//                cell.unitLbl.text = productDict?.value(forKey: "stockUnit") as? String
                
                let reqQty = dataDict?.value(forKey: "requiredQuantity") as? Double
                cell.reqQtyLbl.text = String(reqQty ?? 0)
                
                let vendorDict = dataDict?.value(forKey: "vendordetails") as? NSDictionary
                let vendorName = vendorDict?.value(forKey: "vendorName") as? String
                
                cell.prefVendorLbl.text = vendorName
                
                let priceStr = productDict?.value(forKey: "price") as? Double
                
//                let priceStr = String(shoppingCartResult[indexPath.row].productDict?.price ?? 0)
                cell.totalPriceLabel.text = String(format:"%.2f", priceStr ?? 0)
                let pricePerUnitLabel = productDict?.value(forKey: "unitPrice") as? Double
                cell.pricePerUnitLbl.text = "\(pricePerUnitLabel ?? 0)"
                
                let purcDate = dataDict?.value(forKey: "plannedPurchasedate") as? String ?? ""
                let convertedPurchaseDate = convertDateFormatter(date: purcDate)

                cell.prefPurchaseDatelbl.text = convertedPurchaseDate
                
                cell.shoppingCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
                cell.shoppingCheckBoxBtn.isHidden = true
                
                let isCheckedStatusStr = dataDict?.value(forKey: "isChecked") as? String

                if(isDeleteBtnTapped){
                    cell.shoppingCheckBoxBtn.isHidden = false
                    
                    if(isCheckedStatusStr == "1"){
                        cell.shoppingCheckBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)

                    }
                
                }else if(isSelectAllCheckBoxBtnTapped){
                    cell.shoppingCheckBoxBtn.isHidden = false
                    cell.shoppingCheckBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
              
                }else if(isSelectAllCheckBoxBtnTapped == false){
                    
                    if(isAppLoadedFirstTime){
                        cell.shoppingCheckBoxBtn.isHidden = true

                    }else{
                        cell.shoppingCheckBoxBtn.isHidden = false

                    }
                    cell.shoppingCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
                    
                }else if(isCheckedStatusStr == "1"){
                    cell.shoppingCheckBoxBtn.isHidden = false
                    cell.shoppingCheckBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)

                }
                
                cell.shoppingCheckBoxBtn.addTarget(self, action: #selector(shoppingCheckBoxBtnTap), for: .touchUpInside)
                cell.shoppingCheckBoxBtn.tag = indexPath.row
                
                
                let attrs = [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                    NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
                    NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

                let attributedString = NSMutableAttributedString(string:"")
                
                let buttonTitleStr = NSMutableAttributedString(string:"Edit", attributes:attrs)
                attributedString.append(buttonTitleStr)
                cell.editBtn.setAttributedTitle(attributedString, for: .normal)

                let prodArray = productDict?.value(forKey: "productImages") as? NSArray
                        
                        if(prodArray?.count ?? 0  > 0){
                            
                                    let dict = prodArray?[0] as! NSDictionary
                                    
                                    let imageStr = dict.value(forKey: "0") as! String
                                    
                                    if !imageStr.isEmpty {
                                        
                                        let imgUrl:String = imageStr
                                        
                                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                                            
                                        let imggg = Constants.BaseImageUrl + trimStr
                                        
                                        let url = URL.init(string: imggg)

                                        cell.imgView?.sd_setImage(with: url , placeholderImage: UIImage(named: "no_image"))
                                        
//                                        cell.imgView?.sd_setImage(with: url, placeholderImage:UIImage(named: "add photo"), options: .refreshCached)
                                        
                                        cell.imgView?.contentMode = UIView.ContentMode.scaleAspectFit
                                        
                                    }
                                    else {
                                        
                                        cell.imgView?.image = UIImage(named: "no_image")
                                    }
                        }else{
                            cell.imgView?.image = UIImage(named: "no_image")

                        }
            }else{
                
                if(savedCartResult.count > 0){
                    
                    let dataDict = savedCartResult.object(at: indexPath.row) as? NSDictionary

                    let productDict = dataDict?.value(forKey: "productdetails") as? NSDictionary
                    
                    let priceArray = dataDict?.value(forKey: "priceUnitDetails") as? NSArray
                    var priceDict=NSDictionary()
                    if priceArray?.count ?? 0>0
                    {
                        priceDict = priceArray?[0] as? NSDictionary ?? NSDictionary()
                    }
                    let priceUnitStr = priceDict.value(forKey: "priceUnit")
                    cell.priceUnitLabel.text = priceUnitStr as? String

                    let stockArray = dataDict?.value(forKey: "stockUnitDetails") as? NSArray
                    var stockDict=NSDictionary()
                    if stockArray?.count ?? 0>0
                    {
                        stockDict = stockArray?[0] as? NSDictionary ?? NSDictionary()
                    }
                    let stockUnitStr = stockDict.value(forKey: "stockUnitName")
                    cell.unitLbl.text = stockUnitStr as? String

                    
                    cell.prodIdLbl.text = productDict?.value(forKey: "productUniqueNumber") as? String
                    cell.prodNameLbl.text = productDict?.value(forKey: "productName") as? String
                    cell.descLbl.text = productDict?.value(forKey: "description") as? String
    //                cell.reqQtyLbl.text = String(shoppingCartResult[indexPath.row].requiredQuantity!)
//                    cell.unitLbl.text = productDict?.value(forKey: "stockUnit") as? String
                    
                    let reqQty = productDict?.value(forKey: "stockQuantity") as? Double
                    cell.reqQtyLbl.text = String(reqQty ?? 0)
                    
                    let vendorDict = dataDict?.value(forKey: "vendordetails") as? NSDictionary
                    let vendorName = vendorDict?.value(forKey: "vendorName") as? String
                    
                    cell.prefVendorLbl.text = vendorName
                    
                    let priceStr = productDict?.value(forKey: "price") as? Double
                    
    //                let priceStr = String(shoppingCartResult[indexPath.row].productDict?.price ?? 0)
                    cell.totalPriceLabel.text = String(format:"%.2f", priceStr ?? 0)
                    let pricePerUnitLabel = productDict?.value(forKey: "unitPrice") as? Double
                    cell.pricePerUnitLbl.text = "\(pricePerUnitLabel ?? 0)"
                    
                    let purcDate = dataDict?.value(forKey: "plannedPurchasedate") as? String ?? ""
                    let convertedPurchaseDate = convertDateFormatter(date: purcDate)

                    cell.prefPurchaseDatelbl.text = convertedPurchaseDate
                    
                    cell.shoppingCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
                    cell.shoppingCheckBoxBtn.isHidden = true
                    
                    let attrs = [
                        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                        NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
                        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

                    let attributedString = NSMutableAttributedString(string:"")
                    
                    let buttonTitleStr = NSMutableAttributedString(string:"Edit", attributes:attrs)
                    attributedString.append(buttonTitleStr)
                    cell.editBtn.setAttributedTitle(attributedString, for: .normal)

                    
                    let prodArray = productDict?.value(forKey: "productImages") as? NSArray
                            
                            if(prodArray?.count ?? 0  > 0){
                                
                                        let dict = prodArray?[0] as! NSDictionary

                                        let imageStr = dict.value(forKey: "0") as! String
                                        
                                        if !imageStr.isEmpty {
                                            
                                            let imgUrl:String = imageStr
                                            
                                            let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                                                
                                            let imggg = Constants.BaseImageUrl + trimStr
                                            
                                            let url = URL.init(string: imggg)

    //                                        cell.imgView?.sd_setImage(with: url , placeholderImage: UIImage(named: "add photo"))
                                            
                                            cell.imgView?.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                                            
                                            cell.imgView?.contentMode = UIView.ContentMode.scaleAspectFit
                                            
                                          }
                                        
                                        else {
                                            
                                            cell.imgView?.image = UIImage(named: "no_image")
                                        }
                            }else{
                                cell.imgView?.image = UIImage(named: "no_image")

                            }
                    
                    cell.shoppingCheckBoxBtn.addTarget(self, action: #selector(shoppingCheckBoxBtnTap), for: .touchUpInside)
                    cell.shoppingCheckBoxBtn.tag = indexPath.row

                    
                    let isCheckedStatusStr = dataDict?.value(forKey: "isChecked") as? String
                    
                    if(isDeleteBtnTapped){
                        cell.shoppingCheckBoxBtn.isHidden = false
                        
                        if(isCheckedStatusStr == "1"){
                            cell.shoppingCheckBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)

                        }
                    
                    }else if(isSelectAllCheckBoxBtnTapped){
                        cell.shoppingCheckBoxBtn.isHidden = false
                        cell.shoppingCheckBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
                  
                    }else if(isSelectAllCheckBoxBtnTapped == false){
                        cell.shoppingCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
                        
                    }else if(isCheckedStatusStr == "1"){
                        cell.shoppingCheckBoxBtn.isHidden = false
                        cell.shoppingCheckBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)

                       }
                    }
                }
            
            cell.editBtn.tag = indexPath.row
            
            cell.moveToCartBtn.addTarget(self, action: #selector(moveToCartBtnTap), for: .touchUpInside)
            cell.editBtn.addTarget(self, action: #selector(editBtnTap), for: .touchUpInside)

            cell.moveToCartBtn.tag = indexPath.row
            cell.saveForLaterBtn.tag = indexPath.row

            cell.saveForLaterBtn.addTarget(self, action: #selector(saveItForLater), for: .touchUpInside)

            if isShoppingCart{
                cell.moveToCartBtn.isHidden = true
                cell.editBtn.isHidden = false
                cell.saveForLaterBtn.isHidden = false
                
            }else{
                cell.moveToCartBtn.isHidden = false
                cell.editBtn.isHidden = false
                cell.saveForLaterBtn.isHidden = true

                }
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330

    }
    
    @objc func savedCheckBoxBtnTap(sender:UIButton){
        
        isSelectAllCheckBoxBtnTapped = false
        
        let dataDict = savedCartResult.object(at: sender.tag) as? NSDictionary
        let idStr = dataDict?.value(forKey: "_id") as? String
        
        if sender.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
            sender.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
            dataDict?.setValue("1", forKey: "isChecked")
            
        }else{
            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
            dataDict?.setValue("0", forKey: "isChecked")

        }
        
        savedCartResult.replaceObject(at: sender.tag, with: dataDict!)
        
        let shoppingDict = NSMutableDictionary()
        
        if(shoppingDeleteArray.count == 0){
            
            shoppingDict.setValue(idStr, forKey: "id")
            shoppingDeleteArray.add(shoppingDict)
      
        }else{
            
            for i in 0..<shoppingDeleteArray.count {
                
                let shoppingDeleteDict = shoppingDeleteArray.object(at: i) as? NSDictionary
                let deleteIdStr = shoppingDeleteDict?.value(forKey: "id") as? String
       
                if(deleteIdStr == idStr){
                    
                    shoppingDeleteArray.removeObject(at: i)
                    return
                 }
               }
            }
    }
    
    @objc func shoppingCheckBoxBtnTap(sender:UIButton){
        
        if(isShoppingCart){
            
            isSelectAllCheckBoxBtnTapped = false
            
            let dataDict = shoppingCartResult.object(at: sender.tag) as? NSDictionary
            let idStr = dataDict?.value(forKey: "_id") as? String
            
            if sender.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
                sender.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
                dataDict?.setValue("1", forKey: "isChecked")
                
            }else{
                sender.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
                dataDict?.setValue("0", forKey: "isChecked")

            }
            
            shoppingCartResult.replaceObject(at: sender.tag, with: dataDict!)
            
            let shoppingDict = NSMutableDictionary()
            
            if(shoppingDeleteArray.count == 0){
                
                shoppingDict.setValue(idStr, forKey: "id")
                shoppingDeleteArray.add(shoppingDict)
          
            }else{
                
                for i in 0..<shoppingDeleteArray.count {
                    
                    let shoppingDeleteDict = shoppingDeleteArray.object(at: i) as? NSDictionary
                    let deleteIdStr = shoppingDeleteDict?.value(forKey: "id") as? String
           
                    if(deleteIdStr == idStr){
                        
                        shoppingDeleteArray.removeObject(at: i)
                        return
                     }else{
                        
                        if(i == shoppingDeleteArray.count - 1){
                            shoppingDict.setValue(idStr, forKey: "id")
                            shoppingDeleteArray.add(shoppingDict)
                            break
                        }
                      }
                   }
                }
          
            } else{
            
            isSelectAllCheckBoxBtnTapped = false
            
            let dataDict = savedCartResult.object(at: sender.tag) as? NSDictionary
            let idStr = dataDict?.value(forKey: "_id") as? String
            
            if sender.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
                sender.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
                dataDict?.setValue("1", forKey: "isChecked")
                
            }else{
                sender.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
                dataDict?.setValue("0", forKey: "isChecked")

            }
            
            savedCartResult.replaceObject(at: sender.tag, with: dataDict!)
            
            let shoppingDict = NSMutableDictionary()
            
            if(shoppingDeleteArray.count == 0){
                
                shoppingDict.setValue(idStr, forKey: "id")
                shoppingDeleteArray.add(shoppingDict)
          
            }else{
                
                for i in 0..<shoppingDeleteArray.count {
                    
                    let shoppingDeleteDict = shoppingDeleteArray.object(at: i) as? NSDictionary
                    let deleteIdStr = shoppingDeleteDict?.value(forKey: "id") as? String
           
                    if(deleteIdStr == idStr){
                        
                        shoppingDeleteArray.removeObject(at: i)
                        return
                    }else{
                        
                        if(i == shoppingDeleteArray.count - 1){
                            shoppingDict.setValue(idStr, forKey: "id")
                            shoppingDeleteArray.add(shoppingDict)
                            break
                        }
                      }
                   }
                }
             }
         }
    
    
    @objc func moveToCartBtnTap(sender: UIButton!){
        
        let dataDict = savedCartResult.object(at: sender.tag) as? NSDictionary
        let prodDict = dataDict?.value(forKey: "productdetails") as? NSDictionary

        prodIdStr = dataDict?.value(forKey: "productId") as? NSString
        accIdStr = dataDict?.value(forKey: "accountId") as? NSString
        
//        let reqQty = savedCartResult[sender.tag].requiredQuantity as Int?
//        reqQtyStr = String(reqQty!) as NSString
//        reqQtyStr = "10"
        
        let reqQty = prodDict?.value(forKey: "stockQuantity") as? Int
        reqQtyStr = String(reqQty ?? 0) as NSString
        
        savedListIdStr = dataDict?.value(forKey: "_id") as? NSString
        vendorIdStr = prodDict?.value(forKey: "vendorId") as? NSString
        
        print(reqQtyStr)
        
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                purchaseDateStr = formatter.string(from: date) as NSString
                
                self.moveToCartAPI()

    }
    
    @objc func editBtnTap(sender: UIButton){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddManualTextProductViewController") as! AddManualTextProductViewController
        VC.modalPresentationStyle = .fullScreen
                    //      self.navigationController?.pushViewController(VC, animated: true)
        
        if(isShoppingCart){
            VC.shoppingCartData = shoppingCartEditResult
            VC.isEditShopping = "ShoppingEdit"

        }else{
            VC.savedCartData = savedCartEditResult
            VC.isEditShopping = "SavingEdit"

        }
        
        VC.indexPos = sender.tag
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @objc func saveItForLater(sender: UIButton!){
        
        let dataDict = shoppingCartResult.object(at: sender.tag) as? NSDictionary
        let prodDict = dataDict?.value(forKey: "productdetails") as? NSDictionary

        prodIdStr = dataDict?.value(forKey: "productId") as? NSString
        accIdStr = dataDict?.value(forKey: "accountId") as? NSString
        
//        let reqQty = savedCartResult[sender.tag].requiredQuantity as Int?
//        reqQtyStr = String(reqQty!) as NSString
//        reqQtyStr = "10"
        
        let reqQty = prodDict?.value(forKey: "stockQuantity") as? Int
        reqQtyStr = String(reqQty ?? 0) as NSString
        
//        reqQtyStr = String(shoppingCartResult[sender.tag].productDict?.stockQuantity) as NSString
        cartIdStr = dataDict?.value(forKey: "_id") as? NSString
        vendorIdStr = prodDict?.value(forKey: "vendorId") as? NSString
        
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                purchaseDateStr = formatter.string(from: date) as NSString
                
                self.saveForLaterAPI()

    }

        func getShoppingCartListAPI() {
            
            shoppingCartResult.removeAllObjects()
            shoppingCartResult = NSMutableArray()
            
            self.emptyMsgBtn.removeFromSuperview()
            
            animatingView()
                    
            activity.startAnimating()
            self.view.isUserInteractionEnabled = false
            
            print("Acc ID is \(accountID)")

            let URLString_loginIndividual = Constants.BaseUrl + ShoppingCartRetrieveUrl + accountID
                                        
                                shoppingServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
                                    
                                    let dataDict = result as? NSDictionary

                                let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                _ = respVo.statusCode
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
//                                    self.shoppingCartTblView.tableFooterView = self.customView
                                    
                                    self.shoppingCartEditResult = respVo.result!
                                    
                                    let dataArray = dataDict?.value(forKey: "result") as? NSArray
                                    
                                    self.view.isUserInteractionEnabled = true

                                    if(dataArray!.count > 0){
                                        
                                        for i in 0..<dataArray!.count {

                                            let dataDict = dataArray?.object(at: i) as? NSDictionary
                                            dataDict?.setValue("0", forKey: "isChecked")
                                            self.shoppingCartResult.add(dataDict!)
                                            
                                        }
                                    }
                                    
                                    
//                                    self.shoppingCartResult = (dataDict?.value(forKey: "result") as? NSMutableArray)!
                                    
                                    if(self.shoppingCartResult.count > 0){
                                        
                                        self.shoppingCartTblView.tableFooterView?.isHidden = false
                                        self.emptyMsgBtn.removeFromSuperview()
                                        
                                        if(self.isDeleteBtnTapped == true){
                                            self.productLbl.isHidden = true

                                            
                                        }else{
                                            self.deleteBtn.isHidden = false
                                            self.productLbl.isHidden = false

                                        }
                                        
                                        self.placeOrderBtn.isHidden = false


                                    }else if(self.shoppingCartResult.count == 0){
                                        self.showEmptyMsgBtn()
                                        self.shoppingCartTblView.tableFooterView?.isHidden = true
                                        
                                        self.deleteBtn.isHidden = true
                                        self.selectAllBtn.isHidden = true
                                        self.productLbl.isHidden = true
                                        
                                        
                                        self.placeOrderBtn.isHidden = true
                                        self.selectCheckBoxBtn.isHidden = true

                                    }
                                    else{
                                        self.shoppingCartTblView.tableFooterView?.isHidden = true
                                    }

                                    self.shoppingCartTblView.reloadData()
                                    
                                }
                                else {
                                    self.view.isUserInteractionEnabled = true
                                    self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                }
                                
                            }) { (error) in
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                print("Something Went To Wrong...PLrease Try Again Later")
                            }
            
            if(self.shoppingCartResult.count == 0){
//                self.showEmptyMsgBtn()
            }
                
                        }
    
    func getSavedProductsListAPI() {
        
        savedCartResult.removeAllObjects()
        savedCartResult = NSMutableArray()
        
        self.emptyMsgBtn.removeFromSuperview()
        
        animatingView()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false

        let URLString_loginIndividual = Constants.BaseUrl + SavedCartRetrieveUrl + accountID
                                    
                            shoppingServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
                                
                                let dataDict = result as? NSDictionary

                            let respVo:SavedCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                self.savedCartEditResult = respVo.result!
                                
                                self.view.isUserInteractionEnabled = true

                                let dataArray = dataDict?.value(forKey: "result") as? NSArray
                                
                                if(dataArray!.count > 0){
                                    
                                    for i in 0..<dataArray!.count {

                                        let dataDict = dataArray?.object(at: i) as? NSDictionary
                                        dataDict?.setValue("0", forKey: "isChecked")
                                        self.savedCartResult.add(dataDict!)
                                        
                                    }
                                }

                                if(self.savedCartResult.count > 0){
                                    self.emptyMsgBtn.removeFromSuperview()
                                    
                                    self.deleteBtn.isHidden = false
//                                    self.selectAllBtn.isHidden = false
//                                    self.productLbl.isHidden = false
                                    
                                    if(self.isDeleteBtnTapped == true){
                                        self.productLbl.isHidden = true

                                    }else{
                                        self.deleteBtn.isHidden = false
                                        self.productLbl.isHidden = false

                                    }

                                }else if(self.savedCartResult.count == 0){
                                    self.showEmptyMsgBtn()
                                    
                                    self.deleteBtn.isHidden = true
                                    self.selectAllBtn.isHidden = true
                                    self.productLbl.isHidden = true
                                    self.selectCheckBoxBtn.isHidden = true

                                }
                                
                                self.shoppingCartTblView.tableFooterView?.isHidden = true
                                self.shoppingCartTblView.reloadData()
                                
                            }
                            else {
                                
                                self.shoppingCartTblView.tableFooterView?.isHidden = true
                                self.shoppingCartTblView.reloadData()
                                
                                if(self.savedCartResult.count == 0){
                                    self.showEmptyMsgBtn()
                                }
                                
                                self.view.isUserInteractionEnabled = true
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
        
        if(self.savedCartResult.count == 0){
//            self.showEmptyMsgBtn()
        }
    }
    
        func saveForLaterAPI() {
            
            activity.startAnimating()
            self.view.isUserInteractionEnabled = false
            
//            reqQtyStr = "10"
            //    {"cartId":"6021033715838164b5997605","accountId":"5fe970c651de0c7206d6175c","productId":"6021033715838164b5997604","vendorId":"6007e4354a885e3bdbe26712","requiredQuantity":62,"plannedPurchasedate":"2021-02-08"}

            let URLString_loginIndividual = Constants.BaseUrl + SaveForLaterUrl
            
            let params_IndividualLogin = ["cartId":cartIdStr as Any,"accountId":accountID,"productId":prodIdStr!,"requiredQuantity":reqQtyStr!,"plannedPurchasedate":purchaseDateStr!,"vendorId":vendorIdStr!] as [String : Any]
                    
                        print(params_IndividualLogin)
                    
                        let postHeaders_IndividualLogin = ["":""]
                        
                        shoppingServiceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                            
                            let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            let statusCode = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                print("Success")

                                if(statusCode == 200 ){
                                    
                                    self.shoppingCartResult = NSMutableArray()
                                    self.savedCartResult = NSMutableArray()
                                    
                                    self.shoppingCartBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
                                    self.savedProducts.titleLabel?.font = UIFont.init(name: kAppFont, size: 13)

                                    self.savedProductsLbl.isHidden = true
                                    self.shoppingCartLbl.isHidden = false
                                    
                                    self.isShoppingCart = true
                                    self.getShoppingCartListAPI()

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

                func moveToCartAPI() {
                    
                    activity.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    
                    let URLString_loginIndividual = Constants.BaseUrl + MoveToCartUrl
                    
                    let params_IndividualLogin = ["accountId":accountID,"productId":prodIdStr!,"requiredQuantity":reqQtyStr!,"plannedPurchasedate":purchaseDateStr!,"savedListId":savedListIdStr!,"vendorId":vendorIdStr!] as [String : Any]
                            
                                print(params_IndividualLogin)
                            
                                let postHeaders_IndividualLogin = ["":""]
                                
                                shoppingServiceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                                    
                                    let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                            
                                    let status = respVo.status
                                    let messageResp = respVo.message
                                    let statusCode = respVo.statusCode
                                    
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                                
                                    if status == "SUCCESS" {
                                        print("Success")

                                        if(statusCode == 200 ){
                                            
                                            self.shoppingCartResult.removeAllObjects()
                                            self.savedCartResult.removeAllObjects()

                                            self.shoppingCartResult = NSMutableArray()
                                            self.savedCartResult = NSMutableArray()

                                            self.shoppingCartBtn.titleLabel?.font = UIFont.init(name: kAppFont, size: 13)
                                            self.savedProducts.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)

                                            self.savedProductsLbl.isHidden = false
                                            self.shoppingCartLbl.isHidden = true
                                            
                                            self.isShoppingCart = false
                                            
                                            sleep(3)
                                            activity.startAnimating()
                                            self.getSavedProductsListAPI()
                                            
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
    
    func getLocalSortAPICall() {
        
        localSortView.backHiddenBtn.isHidden = false
        localSortView.removeFromSuperview()
        
        print(sortOrderString)
        print(searchOrderString)
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false

        let URLString_loginIndividual = Constants.BaseUrl + localSortUrl + accountID as String + "/\(sortOrderString)" + "/\(searchOrderString)" + "/shoppingCart"
        shoppingServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
            
                            let dataDict = result as? NSDictionary
                                        
                            if status == "SUCCESS" {
                                
                                self.shoppingCartResult.removeAllObjects()
                                self.shoppingCartResult = NSMutableArray()
                                
                                let dataArray = dataDict?.value(forKey: "result") as? NSArray
                                self.view.isUserInteractionEnabled = true

                                if(dataArray!.count > 0){
                                    
                                    for i in 0..<dataArray!.count {

                                        let dataDict = dataArray?.object(at: i) as? NSDictionary
                                        dataDict?.setValue("0", forKey: "isChecked")
                                        self.shoppingCartResult.add(dataDict!)
                                        
                                    }
                                }
                                
                                if(self.shoppingCartResult.count > 0){
                                    
                                    self.deleteBtn.isHidden = false
                                    self.selectAllBtn.isHidden = true
                                    self.productLbl.isHidden = false

                                    self.emptyMsgBtn.removeFromSuperview()
                                    self.shoppingCartTblView.reloadData()

                                }else if(self.shoppingCartResult.count == 0){
                                    
                                    self.deleteBtn.isHidden = true
                                    self.selectAllBtn.isHidden = true
                                    self.productLbl.isHidden = true
                                    self.showEmptyMsgBtn()
                                }
                                
                            }
                            else {
                                
                                self.view.isUserInteractionEnabled = true
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
        
        if(self.shoppingCartResult.count == 0){
//            self.showEmptyMsgBtn()
            
        }
    }
    
    func parseDeletedDataDetails(){
        
        let dataArray = shoppingCartResult .mutableCopy() as? NSMutableArray
        
        for i in 0..<shoppingDeleteArray.count {
            
            let deleteDict = shoppingDeleteArray.object(at: i) as? NSDictionary
            let deleteIdStr = deleteDict?.value(forKey: "id") as? String
            
            for j in 0...dataArray!.count  - 1 {
                
                let dataDict = dataArray!.object(at: j) as? NSDictionary
                let idStr = dataDict?.value(forKey: "_id") as? String
                
                if(idStr == deleteIdStr){
                    dataArray!.removeObject(at: j)
                    break
                }
            }
        }
        
        shoppingCartResult = dataArray!
        self.shoppingCartTblView.reloadData()
    }
    
    func parseSavedDeletedDataDetails(){
        
        let dataArray = savedCartResult .mutableCopy() as? NSMutableArray
        
        for i in 0..<shoppingDeleteArray.count {
            
            let deleteDict = shoppingDeleteArray.object(at: i) as? NSDictionary
            let deleteIdStr = deleteDict?.value(forKey: "id") as? String
            
            for j in 0...dataArray!.count  - 1 {
                
                let dataDict = dataArray!.object(at: j) as? NSDictionary
                let idStr = dataDict?.value(forKey: "_id") as? String
                
                if(idStr == deleteIdStr){
                    dataArray!.removeObject(at: j)
                    break
                }
            }
        }
        
        savedCartResult = dataArray!
        self.shoppingCartTblView.reloadData()
        
    }
    
    func deleteSavedCartListAPI() {
        
        print("Delete Array is \(shoppingDeleteArray)")
        
                activity.startAnimating()
                self.view.isUserInteractionEnabled = false
                
                let URLString_loginIndividual = Constants.BaseUrl + savedCartDeleteUrl
                 
//                let params_IndividualLogin = ["":""
//                            ]
                        
           let postHeaders_IndividualLogin = ["":""]
                            
           shoppingServiceCntrl.requestPOSTURLWithArray(strURL: URLString_loginIndividual as NSString, postParams: shoppingDeleteArray as NSArray, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
                                    if(statusCode == 200 ){
                                        
                                        let alert = UIAlertController(title: "Success", message: "Deleted successfully", preferredStyle: UIAlertController.Style.alert)
                                        
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                                            
                                            self.parseSavedDeletedDataDetails()
                                                                       
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                        
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
//            }

            //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
//            var json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
//        } catch {
////            print(error.description)
//        }
    }
    
    func deleteShoppingCartListAPI() {
        
        print("Delete Array is \(shoppingDeleteArray)")
        
                activity.startAnimating()
                self.view.isUserInteractionEnabled = false
                
                let URLString_loginIndividual = Constants.BaseUrl + shoppingCartDeleteUrl
                 
//                let params_IndividualLogin = ["":""
//                            ]
                        
           let postHeaders_IndividualLogin = ["":""]
                            
           shoppingServiceCntrl.requestPOSTURLWithArray(strURL: URLString_loginIndividual as NSString, postParams: shoppingDeleteArray as NSArray, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
                                    if(statusCode == 200 ){
                                        
                                        let alert = UIAlertController(title: "Success", message: "Deleted successfully", preferredStyle: UIAlertController.Style.alert)
                                        
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                                            
                                            self.shoppingDeleteArray.removeAllObjects()
                                            self.shoppingDeleteArray = NSMutableArray()
                                            
                                            self.getShoppingCartListAPI()
                                            
//                                            if(self.isShoppingCart){
//                                                self.parseDeletedDataDetails()

//                                            }else{
//                                                self.parseSavedDeletedDataDetails()
//                                            }
                                                                       
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                        
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
//            }

            //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
//            var json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
//        } catch {
////            print(error.description)
//        }
    }
}
