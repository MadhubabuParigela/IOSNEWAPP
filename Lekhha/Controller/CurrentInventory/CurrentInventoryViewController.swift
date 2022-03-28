//
//  CurrentInventoryViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 25/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage
import DropDown

class CurrentInventoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,sendLocalSearchDetails,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var collectionview: UICollectionView!
    var cellId = "Cell"
    var timer:Timer? = Timer()
    var topBannerResultArray = NSMutableArray()
    var giveAwayVal = Int()
    
    func sendLocalSearchDetailsData(dataArray: NSMutableArray, statusStr: String) {
        
        if(dataArray.count > 0){
            
            self.currentInventoryResult = NSMutableArray()
            
            self.currentInventoryResult = dataArray
            currentInventoryTblView.reloadData()
        }
        
    }
    
    @IBOutlet weak var currentInventoryTblView: UITableView!
    
    var giveAwayBool = Bool()
    
//    var prodImgDict = NSDictionary()
    var addToCartImgsArray = NSMutableArray()
    
    @IBOutlet weak var lookingForTxtField: UITextField!
    
    var picker : UIDatePicker = UIDatePicker()
    
    var filterDataArray = NSMutableArray()
    var isFilter = NSString()

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
    
    @IBOutlet weak var addBottomLbl: UILabel!
    @IBOutlet weak var updateBottomLbl: UILabel!
    @IBOutlet weak var sortBottomLbl: UILabel!
    @IBOutlet weak var filterBottomLbl: UILabel!
    
    @IBOutlet weak var addBottomBtn: UIButton!
    @IBOutlet weak var updateBottomBtn: UIButton!
    @IBOutlet weak var sortBtnTap: UIButton!
    @IBOutlet weak var filterBottomBtn: UIButton!
    
    //Filtter View:
    @IBOutlet weak var filtterTopBtn: UIButton!
    
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
    
    @IBOutlet weak var reloadBtn: UIButton!
    
    let dropDown = DropDown() //2
    var moduleStatusStr = String()
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
    
    @IBAction func reloadBtnAction(_ sender: Any) {
        localSearchInventory=""
        currentInventoryResult.removeAllObjects()
        self.getCurrentInventoryAPI()
        currentInventoryTblView.reloadData()
    }
    @IBAction func localSearchApplyBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        transparentView.isHidden=true
        if(localSearchTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Please enter a keyword to search")
            return
        }
//        filterLocalSearchApplyAPI()
        filterPopupLocalSearchApplyAPI()
        
    }
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
        
        localSearchInventory=""
        localSearchTF.text = ""
        startDateTF.text = ""
        endDateTF.text = ""
//        stockQuantityLabel.text = "1-20"
        filetEndDateStr = ""
        filterStartDateStr = ""
       
        createDatePicker()
        createDatePicker2()
        datesBgView.isHidden = true
        quantityBgView.isHidden = true
        datesViewHeight.constant = 30
        
        moduleStatusStr = "currentInventory"
        
        stockQuantityLabel.text = "1-20"
  
        purchaseDateBtn.layer.cornerRadius = 8
        purchaseDateBtn.layer.borderColor = UIColor.lightGray.cgColor
        purchaseDateBtn.layer.borderWidth = 0.5
        purchaseDateBtn.clipsToBounds = true
        
        expireDateBtn.layer.cornerRadius = 8
        expireDateBtn.layer.borderColor = UIColor.lightGray.cgColor
        expireDateBtn.layer.borderWidth = 0.5
        expireDateBtn.clipsToBounds = true
        
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
        purchaseDateBtn.backgroundColor = .white
        purchaseDateBtn.setTitleColor(.lightGray, for: .normal)
        expireDateBtn.backgroundColor = .white
        expireDateBtn.setTitleColor(.lightGray, for: .normal)
        quantityBtn.backgroundColor = .white
        quantityBtn.setTitleColor(.lightGray, for: .normal)
        
        quantityBgView.isHidden = true
        localSearchView.isHidden = true
        transparentView.isHidden=true
        self.getCurrentInventoryAPI()
        currentInventoryTblView.reloadData()
        
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
        expireDateBtn.backgroundColor = .white
        expireDateBtn.setTitleColor(.lightGray, for: .normal)
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
        expireDateBtn.backgroundColor = .blue
        expireDateBtn.setTitleColor(.white, for: .normal)
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
        expireDateBtn.backgroundColor = .white
        expireDateBtn.setTitleColor(.lightGray, for: .normal)
        quantityBtn.backgroundColor = .blue
        quantityBtn.setTitleColor(.white, for: .normal)
    }
    
    func filterPopupLocalSearchApplyAPI() {
        
        searchFilterStatusStr = localSearchTF.text ?? ""
        stockQuanStr = stockQuantityLabel.text ?? ""
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        moduleKeyStr = "currentInventory"
        

        
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
            URLString_loginIndividual = Constants.BaseUrl + LocalSearchUrl + accountID as String + "/\(searchFilterStatusStr)" + "/currentInventory"
          
        }
        
        URLString_loginIndividual = URLString_loginIndividual.replacingOccurrences(of: " ", with: "%20")
        localSearchInventory=URLString_loginIndividual
        
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
                    
                    if(self.moduleStatusStr == "currentInventory"){
                        currentInventoryResultt = dataDict.value(forKey: "currentInventoryresult") as! NSMutableArray
                        
                        self.currentInventoryResult = currentInventoryResultt
                        self.currentInventoryTblView.reloadData()
                        
                        self.localSearchView.isHidden = true
                        self.transparentView.isHidden=true
                        
                        if(self.currentInventoryResult.count > 0){
                            self.emptyMsgBtn.removeFromSuperview()
                            
                            self.currentInventoryTblView.isHidden = false
                            
                            print(self.accountID)
                            
                            self.getBannners()

                        }else{
                            self.currentInventoryTblView.isHidden = true
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
    
    func filterLocalSearchApplyAPI() {
        
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

                    if self.moduleStatusStr == "currentInventory"{
                           
                        self.filtersDataArray = dataDict.value(forKey: "currentInventoryresult") as! NSMutableArray
                        self.currentInventoryResult = self.filtersDataArray
                        self.currentInventoryTblView.reloadData()
                        
                        self.localSearchView.isHidden = true
                        self.transparentView.isHidden=true
                        
                        if(self.currentInventoryResult.count > 0){
                            self.emptyMsgBtn.removeFromSuperview()
                            
                            self.currentInventoryTblView.isHidden = false
                            
                            print(self.accountID)
                            
                            self.getBannners()

                        }else{
                            self.currentInventoryTblView.isHidden = true
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
    
    
    var FiltterView = BottomView()
    
    var sortOrderString = "Ascending"
    var searchOrderString = "purchaseDate"
    
    var shoppingAddProductView = ShoppingAddProductView()
    
    func roundedButtonForFiltterView(){
        
        //  currentInventoryBtn:
        FiltterView.currentInventoryBtn.layer.cornerRadius = 15
        FiltterView.currentInventoryBtn.layer.borderColor = #colorLiteral(red: 0.8275570273, green: 0.8275765181, blue: 0.8275660276, alpha: 1)
        FiltterView.currentInventoryBtn.layer.borderWidth = 0.5
        
        //  shippingCartBtn:
        FiltterView.shippingCartBtn.layer.cornerRadius = 15
        FiltterView.shippingCartBtn.layer.borderColor = #colorLiteral(red: 0.8275570273, green: 0.8275765181, blue: 0.8275660276, alpha: 1)
        FiltterView.shippingCartBtn.layer.borderWidth = 0.5
        
        //  openOrderBtn:
        FiltterView.openOrderBtn.layer.cornerRadius = 15
        FiltterView.openOrderBtn.layer.borderColor = #colorLiteral(red: 0.8275570273, green: 0.8275765181, blue: 0.8275660276, alpha: 1)
        FiltterView.openOrderBtn.layer.borderWidth = 0.5
        
        //  orderHistoryBtn:
        FiltterView.orderHistoryBtn.layer.cornerRadius = 15
        FiltterView.orderHistoryBtn.layer.borderColor = #colorLiteral(red: 0.8275570273, green: 0.8275765181, blue: 0.8275660276, alpha: 1)
        FiltterView.orderHistoryBtn.layer.borderWidth = 0.5
        
        //  orderHistoryBtn:
//        FiltterView.startDateBtn.layer.cornerRadius = 15
        FiltterView.startDateBtn.layer.borderColor = #colorLiteral(red: 0.8275570273, green: 0.8275765181, blue: 0.8275660276, alpha: 1)
        FiltterView.startDateBtn.layer.borderWidth = 0.5
        
        //  orderHistoryBtn:
//        FiltterView.endDateBtn.layer.cornerRadius = 15
        FiltterView.endDateBtn.layer.borderColor = #colorLiteral(red: 0.8275570273, green: 0.8275765181, blue: 0.8275660276, alpha: 1)
        FiltterView.endDateBtn.layer.borderWidth = 0.5

    }
    
    @IBAction func addBottomBtnTap(_ sender: Any) {
        
//        addBottomLbl.isHidden = false
//        updateBottomLbl.isHidden = true
//        sortBottomLbl.isHidden = true
//        filterBottomLbl.isHidden = true
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddProductVC") as! AddProductViewController
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)
//        self.present(VC, animated: true, completion: nil)

    }
    
    @IBAction func updateBottomBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "UpdateInventoryVC") as! UpdateInventoryViewController
        VC.modalPresentationStyle = .fullScreen
        VC.updateInventoryDataArray = currentInventoryResult
        self.navigationController?.pushViewController(VC, animated: true)
        
//        self.present(VC, animated: true, completion: nil)
        
//        addBottomLbl.isHidden = true
//        updateBottomLbl.isHidden = false
//        sortBottomLbl.isHidden = true
//        filterBottomLbl.isHidden = true

    }
    
    @IBAction func sortBottomBtnTap(_ sender: Any) {
        
//        addBottomLbl.isHidden = true
//        updateBottomLbl.isHidden = true
//        sortBottomLbl.isHidden = false
//        filterBottomLbl.isHidden = true
        
        toggleLocalSortViewWithAnimation()
        
    }
    
    @IBAction func filterBottomBtnTap(_ sender: Any) {
        
//        addBottomLbl.isHidden = true
//        updateBottomLbl.isHidden = true
//        sortBottomLbl.isHidden = true
//        filterBottomLbl.isHidden = false
        
        localSearchView.isHidden = false
        transparentView.isHidden=false
        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let VC = storyBoard.instantiateViewController(withIdentifier: "LocalSearchViewController") as! LocalSearchViewController
////        VC.isLocalSearch = "1"
//        VC.modalPresentationStyle = .fullScreen
//        VC.moduleStatusStr = "currentInventory"
//        VC.delegate = self
//
////        self.present(VC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(VC, animated: true)

        
    }
    
    @IBOutlet var transparentView: UIView!
    @IBAction func FiltterTopBtnTap(_ sender: Any) {
        
        filtterTopBtn.isHidden = false
        toggleBottomSortViewWithAnimation()
        
    }
    
    var currentInventoryService = ServiceController()
    var currentInventoryResult = NSMutableArray()
    
    var sideMenuView = SideMenuView()
    var localSortView = LocalSortView()
    var emptyMsgBtn = UIButton()
    
    var accountID = String()
    
    var prodIdStr:NSString!
    var accIdStr:NSString!
    var purchaseDateStr:NSString!
    var reqQtyStr:NSString!
    var savedListStr:NSString!

    @IBAction func notificationBtnTap(_ sender: Any) {
       
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        VC.modalPresentationStyle = .fullScreen
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }

    @IBAction func addProductInventoryBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddProductVC") as! AddProductViewController
        VC.modalPresentationStyle = .fullScreen
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }

    func showAlertGiveAwayWith(title:String,message:String)
        {
            let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
            //to change font of title and message.
            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
            alertController.setValue(titleAttrString, forKey: "attributedTitle")
            alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
//        var returnBoolVal = Bool()
            
            let alertAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
                
//                returnBoolVal = false
                
            })
        
        let alertAction1 = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            
            let productDict = self.currentInventoryResult[self.giveAwayVal] as! NSDictionary
            
            let dataDict = productDict.value(forKey: "productdetails") as! NSDictionary
            self.prodIdStr = productDict.value(forKey: "productId") as? NSString

            let giveAway = dataDict.value(forKey: "giveAwayStatus") as? Bool

            self.giveAwayBool = false
            
            dataDict.setValue(self.giveAwayBool, forKey: "giveAwayStatus")
            productDict.setValue(dataDict, forKey: "productdetails")
            
            self.currentInventoryResult.replaceObject(at: self.giveAwayVal, with: productDict)
            self.currentInventoryTblView.reloadData()
            
            self.giveAwayStatusAPI()

           
        })

            alertController.addAction(alertAction)
           alertController.addAction(alertAction1)

        self.present(alertController, animated: true, completion: nil)
//        return returnBoolVal
        
        }
    
    @IBAction func menuBtnTap(_ sender: Any) {
       toggleSideMenuViewWithAnimation()

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
        
        localSortView.purchaseDateBtn.addTarget(self, action: #selector(purchaseDateBtnTap), for: .touchUpInside)
        localSortView.expiryDateBtn.addTarget(self, action: #selector(expiryDateBtnTap), for: .touchUpInside)
        localSortView.productDateBtn.addTarget(self, action: #selector(productDateBtnTap), for: .touchUpInside)
        localSortView.quantityBtn.addTarget(self, action: #selector(quantityBtnTap), for: .touchUpInside)

//        let path = UIBezierPath(roundedRect:localSortView.innerLocalSortView.bounds,
//                                byRoundingCorners:[.topRight, .topLeft],
//                                cornerRadii: CGSize(width: 20, height:  20))
//
//        let maskLayer = CAShapeLayer()

//        maskLayer.path = path.cgPath
//        localSortView.innerLocalSortView.layer.mask = maskLayer
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.localSortView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.localSortView)
            
//       self.sideMenuView.loadSideMenuView(viewCntrl: self, status: "")

         }, completion: { (finished: Bool) -> Void in
            self.localSortView.backHiddenBtn.isHidden = false

         })
    }
    
    
     func toggleBottomSortViewWithAnimation() {
            
            let allViewsInXibArray = Bundle.main.loadNibNamed("BottomView", owner: self, options: nil)
            FiltterView = allViewsInXibArray?.first as! BottomView
            FiltterView.frame = CGRect(x: 0, y: self.view.frame.size.height+350, width: self.view.frame.size.width, height: self.view.frame.size.height)
             self.view.addSubview(FiltterView)
            
            FiltterView.xMarkBtn.addTarget(self, action: #selector(x_markButtonTap(_:)), for: .touchUpInside)
        
//        FiltterView.transactionByBtn.addTarget(self, action: #selector(x_markButtonTap(_:)), for: .touchUpInside)

        FiltterView.xMarkBtn.addTarget(self, action: #selector(x_markButtonTap(_:)), for: .touchUpInside)
        
        FiltterView.startDateBtn.addTarget(self, action: #selector(startdateBtnTapped(_:)), for: .touchUpInside)

        FiltterView.endDateBtn.addTarget(self, action: #selector(enddateBtnTapped(_:)), for: .touchUpInside)
        
        FiltterView.currentInventoryBtn.addTarget(self, action: #selector(currentInventoryBtnTapped(_:)), for: .touchUpInside)

        FiltterView.shippingCartBtn.addTarget(self, action: #selector(shoppingCartBtnTapped(_:)), for: .touchUpInside)

        FiltterView.openOrderBtn.addTarget(self, action: #selector(openOrdersBtnTapped(_:)), for: .touchUpInside)

        FiltterView.orderHistoryBtn.addTarget(self, action: #selector(ordersHistoryBtnTapped(_:)), for: .touchUpInside)

        FiltterView.applyBtn.addTarget(self, action: #selector(filterApplyBtnTapped(_:)), for: .touchUpInside)

            let path = UIBezierPath(roundedRect:FiltterView.cardView.bounds,
                                    byRoundingCorners:[.topRight, .topLeft],
                                    cornerRadii: CGSize(width: 20, height:  20))

            let maskLayer = CAShapeLayer()

            maskLayer.path = path.cgPath
            FiltterView.cardView.layer.mask = maskLayer
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
                self.FiltterView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.view.addSubview(self.FiltterView)
                
                self.roundedButtonForFiltterView()
                
       //     self.sideMenuView.loadSideMenuView(viewCntrl: self, status: "")

             }, completion: { (finished: Bool) -> Void in
                self.FiltterView.backHiddenBtn.isHidden = false

             })
        }
        
       @objc func x_markButtonTap(_ sender: UIButton){
            FiltterView.backHiddenBtn.isHidden = false
            FiltterView.removeFromSuperview()
        }
    
    @objc func startdateBtnTapped(_ sender :UIButton){
        filterSortStatus = "1"
        datePickerView()
        
    }
    
    @objc func enddateBtnTapped(_ sender :UIButton){
        filterSortStatus = "0"
        datePickerView()
        
    }
    
    @objc func filterApplyBtnTapped(_ sender:UIButton){
        
        if(filterStartDateStr == "" || filterStartDateStr == nil){
            self.showAlertWith(title: "ALert", message: "Please select start date")
            return
            
        }else if(filetEndDateStr == "" || filetEndDateStr == nil){
            self.showAlertWith(title: "ALert", message: "Please select end date")
            return

        }else{
            filterApplyAPI()
        }
    }
    
    @objc func currentInventoryBtnTapped(_ sender :UIButton){
        
        FiltterView.currentInventoryBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")
        FiltterView.shippingCartBtn.backgroundColor = UIColor.clear
        FiltterView.openOrderBtn.backgroundColor = UIColor.clear
        FiltterView.orderHistoryBtn.backgroundColor = UIColor.clear

    }
    
    @objc func shoppingCartBtnTapped(_ sender :UIButton){
        
        FiltterView.currentInventoryBtn.backgroundColor = UIColor.clear
        FiltterView.shippingCartBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")
        FiltterView.openOrderBtn.backgroundColor = UIColor.clear
        FiltterView.orderHistoryBtn.backgroundColor = UIColor.clear

    }
    
    @objc func openOrdersBtnTapped(_ sender :UIButton){

        FiltterView.currentInventoryBtn.backgroundColor = UIColor.clear
        FiltterView.shippingCartBtn.backgroundColor = UIColor.clear; FiltterView.openOrderBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")
        FiltterView.orderHistoryBtn.backgroundColor = UIColor.clear

    }
    
    @objc func ordersHistoryBtnTapped(_ sender :UIButton){
        
        FiltterView.currentInventoryBtn.backgroundColor = UIColor.clear
        FiltterView.shippingCartBtn.backgroundColor = UIColor.clear; FiltterView.openOrderBtn.backgroundColor = UIColor.clear;        FiltterView.orderHistoryBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")

    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == lookingForTxtField){
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "GlobalSearchViewController") as! GlobalSearchViewController
                        //      self.navigationController?.pushViewController(VC, animated: true)
            VC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(VC, animated: true)
            
            textField.resignFirstResponder()

        }
    }
    
    
    func datePickerView()  {
        
       pickerDateView.removeFromSuperview()
       hiddenBtn.removeFromSuperview()
       picker.removeFromSuperview()
       
       hiddenBtn.frame = CGRect (x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
       hiddenBtn.backgroundColor = UIColor.black
       hiddenBtn.alpha = 0.5
       self.view.addSubview(hiddenBtn)
       
       pickerDateView.frame = CGRect(x: 0, y: self.view.frame.size.height - 350, width: self.view.frame.size.width, height: 350)
       pickerDateView.backgroundColor = UIColor.white
       self.view.addSubview(pickerDateView)
       
       let doneBtn = UIButton()
       doneBtn.frame = CGRect(x: pickerDateView.frame.size.width - 100, y: 10, width: 80, height: 30)
       doneBtn.setTitle("Done", for: UIControl.State.normal)
       doneBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
       doneBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
       doneBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
       doneBtn.addTarget(self, action: #selector(doneBtnTap), for: .touchUpInside)
       pickerDateView.addSubview(doneBtn)
       
       //Seperator Line 1 Lbl
       
       let seperatorLine1 = UILabel()
       seperatorLine1.frame = CGRect(x: 0, y: doneBtn.frame.size.height+doneBtn.frame.origin.y, width: pickerDateView.frame.size.width , height: 1)
       seperatorLine1.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
       pickerDateView.addSubview(seperatorLine1)

       picker = UIDatePicker()
       picker.datePickerMode = UIDatePicker.Mode.date
       picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
//        let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
       picker.frame = CGRect(x:0.0, y:50, width:self.view.frame.size.width, height:300)
       // you probably don't want to set background color as black
       // picker.backgroundColor = UIColor.blackColor()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }

       pickerDateView.addSubview(picker)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)

        if(filterSortStatus == "1"){ //Purchase Btn
            FiltterView.startDateBtn.setTitle(result, for: .normal)
            filterStartDateStr = result

        }else{
            
            FiltterView.endDateBtn.setTitle(result, for: .normal)
            filetEndDateStr = result

        }
   }
   
   @objc func dueDateChanged(sender:UIDatePicker){
       
       let dateFormatter = DateFormatter()
       
       dateFormatter.dateFormat = "dd/MM/yyyy"
       let selectedDate = dateFormatter.string(from: picker.date)

       if(filterSortStatus == "1"){ //Purchase Btn
        FiltterView.startDateBtn.setTitle(selectedDate, for: .normal)
        filterStartDateStr = selectedDate
        
       }else if(filterSortStatus == "0"){
        FiltterView.endDateBtn.setTitle(selectedDate, for: .normal)
        filetEndDateStr = selectedDate

       }
   }
   
   @objc func doneBtnTap(_ sender: UIButton) {

       hiddenBtn.removeFromSuperview()
       pickerDateView.removeFromSuperview()
       
   }

    
    @IBAction func cancelBtnTap(_ sender: UIButton){

        localSortView.backHiddenBtn.isHidden = false
        localSortView.removeFromSuperview()
        
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
    
    @IBAction func expiryDateBtnTap(_ sender: UIButton){

        localSortView.purchaseDateBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        localSortView.expiryDateBtn.setImage(UIImage.init(named: "radio_active"), for: UIControl.State.normal)
        localSortView.productDateBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        localSortView.quantityBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        
        searchOrderString = "expiryDate"

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
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadBtn.layer.cornerRadius = 15
        reloadBtn.clipsToBounds = true
        
        createDatePicker()
        createDatePicker2()
        
        transparentView.isHidden=true
        datesBgView.isHidden = true
        quantityBgView.isHidden = true
        datesViewHeight.constant = 30
        
        moduleStatusStr = "currentInventory"
        
        stockQuantityLabel.text = "1-20"
        
        localSearchView.isHidden = true
        
      
        purchaseDateBtn.layer.cornerRadius = 8
        purchaseDateBtn.layer.borderColor = UIColor.lightGray.cgColor
        purchaseDateBtn.layer.borderWidth = 0.5
        purchaseDateBtn.clipsToBounds = true
        
        expireDateBtn.layer.cornerRadius = 8
        expireDateBtn.layer.borderColor = UIColor.lightGray.cgColor
        expireDateBtn.layer.borderWidth = 0.5
        expireDateBtn.clipsToBounds = true
        
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
                
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        let userDefaults = UserDefaults.standard
        userDefaults.set("Current Inventory", forKey: "sideMenuTitle")
        userDefaults.synchronize()
        print("Current Filter data is \(filterDataArray)")
        
        sortOrderString = ""
        searchOrderString = ""
        searchFilterStatusStr = ""
        
        lookingForTxtField.delegate = self
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        print(accountID)
        
        currentInventoryTblView.delegate = self
        currentInventoryTblView.dataSource = self
        
        animatingView()
        
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(CurrentInventoryViewController.autoScrollBannerSlider), userInfo: nil, repeats: true)
        }
    
        if(isFilter == "1"){ //GLOBAL SEARCH
           currentInventoryTblView.reloadData()

        }else{
            if localSearchInventory==""
            {
                self.getCurrentInventoryAPI()
            }
            else
            {
                self.filterPopupLocalSearchApplyAPI()
            }
        }
        deviceInfo_updateAPI()
        // Do any additional setup after loading the view.
    }
    
    func deviceInfo_updateAPI() {
        
        let defaults = UserDefaults.standard
        var userID = String()
        userID = (defaults.string(forKey: "userID") ?? "")
        
        let URLString_loginIndividual = Constants.BaseUrl + "endusers/deviceInfo_update/\(userID)"
                
        let modelName = UIDevice.modelName
        print("modelName:\(modelName)")
        let deviceVersion = UIDevice.current.systemVersion
        print("deviceVersion:\(deviceVersion)")
//        let typeVendor = UIDevice.current.identifierForVendor
//        print("typeVendor:\(typeVendor)")
        let type = UIDevice.current.type
        print("type:\(type)")
        let name = UIDevice.current.name
        print("name:\(name)")
//        let model = UIDevice.current.model
//        print("model:\(model)")
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let appVersionStr = appVersion ?? ""
        print("appVersionStr:\(appVersionStr)")
        let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let buildVersionStr = appBuild ?? ""
        print("buildVersionStr:\(buildVersionStr)")
        
        let deviceInfoDict = ["appVersion":appVersionStr,"basebandVersion":deviceVersion,"buildNo":buildVersionStr,"deviceName":name,"kernelVersion":deviceVersion,"lattitude":"NA","longitude":"NA","manufacture":"APPLE","model":modelName,"osVersion":deviceVersion,"serial":"unknown"] as [String : Any]
                        
        let params_IndividualLogin = ["loginDeviceInfo":deviceInfoDict]
        print(params_IndividualLogin)
        let postHeaders_IndividualLogin = ["":""]
        
        currentInventoryService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
            
            let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            if statusCode == 200 {
                if status == "SUCCESS" {
//                    self.view.makeToast(messageResp)
                }
                else {
//                    self.view.makeToast(messageResp)
                }
            }
            else {
                self.view.makeToast(messageResp)
            }
                        
        }) { (error) in
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
        }
    }
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        //self.view.addSubview(emptyMsgBtn)
        //self.view.sendSubviewToBack(emptyMsgBtn)
        
        self.view.insertSubview(emptyMsgBtn, belowSubview: self.FiltterView)
        self.view.insertSubview(emptyMsgBtn, belowSubview: self.transparentView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topBannerResultArray.count
   
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        
        let dataDict = topBannerResultArray.object(at: indexPath.item) as? NSDictionary
        let imagePath = dataDict?.value(forKey: "filePath") as? String
        
        let imgUrl:String = imagePath ?? ""
        
        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                            
        let imggg = Constants.BannnerBaseImgUrl + trimStr
        
        let fileUrl = URL(string: imggg)
        
        cell.bannerImgView?.sd_setImage(with: fileUrl, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)
        
//        cell.bannerImgView.image = UIImage.init(named: "nature")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: 170)

    }
    
    @objc func autoScrollBannerSlider() {
        DispatchQueue.main.async {
            if self.topBannerResultArray.count > 1
            {
                let visibleItems = self.collectionview.indexPathsForVisibleItems
                if visibleItems.count > 0 {
                    let currentItemIndex: IndexPath? = visibleItems[0]
                    if currentItemIndex?.item == self.topBannerResultArray.count - 1 {
                        let nexItem = IndexPath(item: 0, section: 0)
                        self.collectionview.scrollToItem(at: nexItem, at: .centeredHorizontally, animated: true)
                    } else {
                        let nexItem = IndexPath(item: (currentItemIndex?.item ?? 0) + 1, section: 0)
                        self.collectionview.scrollToItem(at: nexItem, at: .centeredHorizontally, animated: true)
                    }
                }
            }
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print(currentInventoryResult)
        if localSearchInventory==""
        {
        if(currentInventoryResult.count > 0){
//            currentInventoryTblView.reloadData()
            self.getCurrentInventoryAPI()
            
        }else{
            
            self.getCurrentInventoryAPI()
            
        }
        }
        else
        {
            self.filterPopupLocalSearchApplyAPI()
        }
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 210))
     
//        let imgView = UIImageView()
//        imgView.frame = CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: 170)
//        imgView.image = UIImage.init(named: "homeBackground")
//        headerView.addSubview(imgView)
     
     // Create an instance of UICollectionViewFlowLayout since you cant
     // Initialize UICollectionView without a layout
     let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
     layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
     layout.itemSize = CGSize(width: view.frame.width, height: 210)
     layout.scrollDirection = .horizontal

     collectionview = UICollectionView(frame: CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: 170), collectionViewLayout: layout)
     collectionview.dataSource = self
     collectionview.delegate = self
//        collectionview.registerClass("BannerCollectionViewCell", forCellWithReuseIdentifier: "BannerCollectionViewCell")
     collectionview.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
     collectionview.showsVerticalScrollIndicator = false
     collectionview.showsHorizontalScrollIndicator = false
     
     collectionview.backgroundColor = hexStringToUIColor(hex:"ecf2fb")
     headerView.addSubview(collectionview)

     
        let view = UIView()
      view.frame = CGRect(x: 0, y: 170, width: headerView.frame.size.width, height: 40)
//           view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
     view.backgroundColor = hexStringToUIColor(hex: "e7effa")
//        view.backgroundColor = UIColor.yellow
     headerView.addSubview(view)
     
     let textLbl = UILabel()
     textLbl.frame = CGRect(x: 10, y: 0, width: view.frame.size.width-10, height: 40)
     if(isFilter == "1"){
         textLbl.text = "Global Search"

     }else{
         textLbl.text = "Current Inventory"
     }

     textLbl.textColor = hexStringToUIColor(hex: "484e6d")
     textLbl.font = UIFont(name: kAppFontBold, size: 15)
     view.addSubview(textLbl)

      return headerView
 }
    
    //****************** TableView Delegate Methods*************************//
    @IBOutlet var borrowLentLabel: UILabel!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if(isFilter == "1"){
//            return filterDataArray.count
            
//        }else{
            return currentInventoryResult.count

//        }
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = currentInventoryTblView.dequeueReusableCell(withIdentifier: "CurrentInventoryCell", for: indexPath) as! CurrentInventoryTableViewCell
        
//        if(isFilter == "1"){ //Global Search
//
//            let productDict = filterDataArray[indexPath.row] as! NSDictionary
//            let dataDict = productDict.value(forKey: "productdetails") as! NSDictionary
//            let stockQuan = dataDict.value(forKey: "stockQuantity") as! Int
//
//            cell.prodIDLbl.text = productDict["productId"] as? String
//            cell.prodNameLbl.text = dataDict.value(forKey: "productName") as? String
//            cell.desccriptionLbl.text = dataDict.value(forKey: "description") as? String
//            cell.stockQtyLbl.text = String(stockQuan)
//            cell.stockUnitLbl.text = dataDict.value(forKey: "stockUnit") as? String
//            cell.storageLoclbl.text = dataDict.value(forKey: "storageLocation") as? String
//
//            let expiryDate = (dataDict.value(forKey: "expiryDate") as? String)!
//            let convertedExpiryDate = convertDateFormatter(date: expiryDate)
//            cell.expDateLbl.text = convertedExpiryDate
//
//            let borrowedStatus = dataDict.value(forKey: "borrowed") as? String
//
//            if borrowedStatus == "yes"
//            {
//                cell.borrowedChckBox.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
//            }else{
//                cell.borrowedChckBox.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
//
//            }
//
//            let prodArray = dataDict.value(forKey: "productImages") as? NSArray
//
//            if(prodArray?.count ?? 0  > 0){
//
//                        let dict = prodArray?[0] as! NSDictionary
//
//                        let imageStr = dict.value(forKey: "0") as! String
//
//                        if !imageStr.isEmpty {
//
//                            let imgUrl:String = imageStr
//
//                            let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
//
//                            let imggg = Constants.BaseImageUrl + trimStr
//
//                            let url = URL.init(string: imggg)
//
//                            cell.prodImgView?.sd_setImage(with: url , placeholderImage: UIImage(named: "add photo"))
//                            cell.prodImgView?.contentMode = UIView.ContentMode.scaleAspectFit
//
//                        }
//                        else {
//
//                            cell.prodImgView?.image = UIImage(named: "add photo")
//                        }
//            }else{
//                cell.prodImgView?.image = UIImage(named: "add photo")
//
//            }
//
//            cell.addToCartBtn.isHidden = true
//            cell.seperatorLine.isHidden = true
//            cell.checkboxBtn.isHidden = true
//            cell.checkBoxLbl.isHidden = true
            
//        }else{
            
            let productDict = currentInventoryResult[indexPath.row] as! NSDictionary

            let dataDict = productDict.value(forKey: "productdetails") as! NSDictionary
        var stockQQu=Float()
        if let stockQuan = productDict.value(forKey: "stockQuantity") as? Double {
            cell.stockQtyLbl.text = String(format:"%.3f",stockQuan)
            stockQQu=Float(stockQuan)
        }
        else if let stockQuant = productDict.value(forKey: "stockQuantity") as? Float{
            
            cell.stockQtyLbl.text = String(format:"%.3f",stockQuant)
            stockQQu=stockQuant
        }
        else {
            
            cell.stockQtyLbl.text = productDict.value(forKey: "stockQuantity") as? String
            stockQQu=Float(productDict.value(forKey: "stockQuantity") as? String ?? "") ?? 0
        }
        let stockUnitDetails=productDict.value(forKey: "stockUnitDetails")as? NSArray
        let priceUnitDetails=productDict.value(forKey: "priceUnitDetails")as? NSArray
        let storagelocationLevel1=productDict.value(forKey: "storageLocationLevel1Details")as? NSArray
        let storagelocationLevel2=productDict.value(forKey: "storageLocationLevel2Details")as? NSArray
        let storagelocationLevel3=productDict.value(forKey: "storageLocationLevel3Details")as? NSArray
        if stockUnitDetails?.count ?? 0>0
        {
        let stockUnitDetailsDic=stockUnitDetails?[0] as? NSDictionary
            cell.stockUnitLbl.text = stockUnitDetailsDic?.value(forKey: "stockUnitName") as? String
        }
        else
        {
            cell.stockUnitLbl.text = ""
        }
        if priceUnitDetails?.count ?? 0>0
        {
            let priceUnitDetailsDic=priceUnitDetails?[0] as? NSDictionary
            cell.priceUnitLabel.text=priceUnitDetailsDic?.value(forKey: "priceUnit") as? String
        }
        else
        {
            cell.priceUnitLabel.text = ""
        }
        if storagelocationLevel1?.count ?? 0>0
        {
            let storagelocationLevel1Dic=storagelocationLevel1?[0] as? NSDictionary
            cell.storageLoclbl.text = storagelocationLevel1Dic?.value(forKey: "slocName") as? String
        }
        else
        {
            cell.storageLoclbl.text = ""
        }
        if storagelocationLevel2?.count ?? 0>0
        {
            let storagelocationLevel2Dic=storagelocationLevel2?[0] as? NSDictionary
            cell.level2Label.text = storagelocationLevel2Dic?.value(forKey: "slocName") as? String
        }
        else
        {
            cell.level2Label.text = ""
        }
        if storagelocationLevel3?.count ?? 0>0
        {
            let storagelocationLevel3Dic=storagelocationLevel3?[0] as? NSDictionary
            cell.level3Label.text = storagelocationLevel3Dic?.value(forKey: "slocName") as? String
        }
        else
        {
            cell.level3Label.text = ""
        }
            cell.prodIDLbl.text = dataDict["productUniqueNumber"] as? String
            cell.prodNameLbl.text = dataDict.value(forKey: "productName") as? String
            cell.desccriptionLbl.text = dataDict.value(forKey: "description") as? String
            
        
         var unitPPrice=Float()
        if let unitPriceStr = dataDict.value(forKey: "unitPrice") as? Double {
            
            cell.pricePerStockUnitLabel.text = String(unitPriceStr)
            unitPPrice=Float(unitPriceStr)
        }
        else if let unitPriceStr = dataDict.value(forKey: "unitPrice") as? Float {
            cell.pricePerStockUnitLabel.text = String(unitPriceStr)
            unitPPrice=unitPriceStr
        }
        else {
            
            cell.pricePerStockUnitLabel.text = dataDict.value(forKey: "unitPrice") as? String
            unitPPrice=Float(dataDict.value(forKey: "unitPrice") as? String ?? "") ?? 0
        }
        
            let obj3=stockQQu * unitPPrice
            cell.totalPriceLabel.text = String(format:"%.2f", obj3 ?? 0)
       
            let expiryDate = (dataDict.value(forKey: "expiryDate") as? String) ?? ""
        if expiryDate==""
        {
            cell.expDateLbl.text = ""
        }
        else
        {
            let convertedExpiryDate = convertServerDateFormatter(date: expiryDate)
            cell.expDateLbl.text = convertedExpiryDate
        }

        let borrowedStatus = productDict.value(forKey: "isBorrowed") as? Bool
       
            if borrowedStatus == true
            {
                if let borroeLent=productDict.value(forKey: "borrowLentDetails")as? NSDictionary{
                    let quan=borroeLent.value(forKey: "quantity") as? String ?? ""
                    cell.borrowLentLabel.text="Borrow(Qty:" + quan + ")"
                }
                cell.borrowedChckBox.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
            }else{
                cell.borrowedChckBox.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)

            }
        let sharedStatus = productDict.value(forKey: "shared") as? Bool

        if(sharedStatus == true)
        {
            cell.shareCheckButton.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
        }else{
            cell.shareCheckButton.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)

        }
        
        let giveAway = dataDict.value(forKey: "giveAwayStatus") as? Bool

        if(giveAway == true){
            cell.checkboxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
            
        }else{
            cell.checkboxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)

        }
        cell.checkboxBtn.addTarget(self, action: #selector(giveAwayCheckBoBtnTapped), for: .touchUpInside)
        
        cell.checkboxBtn.tag = indexPath.row
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(onEditDetailsBtnTap), for: .touchUpInside)
            let prodArray = dataDict.value(forKey: "productImages") as? NSArray

            if(prodArray?.count ?? 0  > 0){

                        let dict = prodArray?[0] as! NSDictionary
                        let imageStr = dict.value(forKey: "0") as! String
                        if !imageStr.isEmpty {
                            let imgUrl:String = imageStr
                            let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                            let imggg = Constants.BaseImageUrl + trimStr
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
            
            cell.addToCartBtn.addTarget(self, action: #selector(addToCartBtnTap), for: .touchUpInside)
            cell.addToCartBtn.tag = indexPath.row

//        }
        
         return cell
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        if(isFilter == "1"){
//            return 265
//
//        }else{
            return 426

//        }
     }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if topBannerResultArray.count>0
//        {
        return 210
//        }else
//        {
//            return 50
//        }
        
    }
    
    func moveToCartAlert(){
        
        let alert = UIAlertController(title: "Success", message: "Added to cart succesfully", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingVC") as! ShoppingViewController
                                        VC.modalPresentationStyle = .fullScreen
            //                            self.present(VC, animated: true, completion: nil)
                                        self.navigationController?.pushViewController(VC, animated: true)

                                        
        }))
        self.present(alert, animated: true, completion: nil)

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
    
    @objc func giveAwayCheckBoBtnTapped(sender: UIButton){
        
        giveAwayVal = sender.tag
        
        let productDict = currentInventoryResult[sender.tag] as! NSDictionary
        
        let dataDict = productDict.value(forKey: "productdetails") as! NSDictionary
        prodIdStr = productDict.value(forKey: "productId") as? NSString

        let giveAway = dataDict.value(forKey: "giveAwayStatus") as? Bool
        
        if(giveAway == true){
//            giveAwayBool = false
//            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
            
        showAlertGiveAwayWith(title: "Alert", message: "Do you really want to remove the product from Give Away list ? If yes, any bids received will be declined")
            
//            if(returnedVal == true){
//
//                dataDict.setValue(false, forKey: "giveAwayStatus")
//                productDict.setValue(dataDict, forKey: "productdetails")
//
//                currentInventoryResult.replaceObject(at: sender.tag, with: productDict)
//                currentInventoryTblView.reloadData()
//
//                giveAwayStatusAPI()
//
//            }
//            else{
//
//            }

        }else{
            
            giveAwayBool = true
            
            dataDict.setValue(giveAwayBool, forKey: "giveAwayStatus")
            productDict.setValue(dataDict, forKey: "productdetails")
            
            currentInventoryResult.replaceObject(at: sender.tag, with: productDict)
            currentInventoryTblView.reloadData()
            
            giveAwayStatusAPI()

        }
    }
    
    @objc func addToCartBtnTap(sender: UIButton!){
        
//        var accIdStr:NSString!
//        var purchaseDateStr:NSString!
//        var reqQtyStr:NSString!
        
        var prodImgDict = NSDictionary()
        addToCartImgsArray = NSMutableArray()
        
        let productDict = currentInventoryResult[sender.tag] as! NSDictionary
        
        let dataDict = productDict.value(forKey: "productdetails") as! NSDictionary
        
        prodIdStr = productDict.value(forKey: "productId") as? NSString
        accIdStr = dataDict.value(forKey: "accountId") as? NSString
        
        let reqQty = dataDict.value(forKey: "stockQuantity") as? Int ?? 0
        
        reqQtyStr = String(reqQty) as NSString
        
//        reqQtyStr = String(format: "%@", currentInventoryResult[sender.tag].productDict?.stockQuantity ?? "0") as NSString
        
        savedListStr = (productDict.value(forKey: "_id") ?? 0) as? NSString
        
        print(prodIdStr!,accIdStr!,reqQtyStr!,savedListStr!)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        purchaseDateStr = formatter.string(from: date) as NSString
        
//        let dataArray = dataDict.value(forKey: "productImages") as! NSArray
//        prodImgDict = dataArray.object(at: 0) as! NSDictionary
//        for i in 0..<3 {
//
//            var imgStr = ""
//
//            if(i == 0){
//                imgStr = prodImgDict.value(forKey: "0") as? String ?? ""
//
//            }
//            else if(i == 1){
//                imgStr = prodImgDict.value(forKey: "1") as? String ?? ""
//
//            }else if(i == 2){
//                imgStr = prodImgDict.value(forKey: "2") as? String ?? ""
//
//            }
//
//            if(imgStr == ""){
//
//                var addProdImgDict = NSMutableDictionary()
//                addProdImgDict = ["productImage":""]
//
//                addToCartImgsArray.add(addProdImgDict)
//
//
//            }else{
//
//                let imggg = Constants.BaseImageUrl + imgStr
//    //            let url = URL.init(string: imggg)
//
//                let url:NSURL = NSURL(string : imggg)!
//                let imageData:NSData = NSData.init(contentsOf: url as URL)!
//
//                let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
//
//                var addProdImgDict = NSMutableDictionary()
//                addProdImgDict = ["productImage":strBase64]
//
//                addToCartImgsArray.add(addProdImgDict)
//
//            }
//
//
//
//        }
        

        
        
//        purchaseDateStr = result as NSString
        self.addToCartAPICall()
    }
    @objc func onEditDetailsBtnTap(sender:UIButton){
        
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyBoard.instantiateViewController(withIdentifier: "EditUpdateInventoryViewController") as! EditUpdateInventoryViewController
                VC.modalPresentationStyle = .fullScreen
        //      self.navigationController?.pushViewController(VC, animated: true)
        
        let productDict = currentInventoryResult[sender.tag] as! NSDictionary
        VC.prodIDStr = productDict.value(forKey: "_id") as! String
        VC.productID = productDict.value(forKey: "productId") as! String
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }
    func getCurrentInventoryAPI() {
        
        currentInventoryResult.removeAllObjects()
        currentInventoryResult = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

//        sleep(3)
        
        let URLString_loginIndividual = Constants.BaseUrl + CurrentInventoryUrl + accountID as String
                            currentInventoryService.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                let dataDict = result as! NSDictionary
                                
                                self.currentInventoryResult = dataDict.value(forKey: "result") as! NSMutableArray
                                self.currentInventoryTblView.reloadData()
                                
                                if(self.currentInventoryResult.count > 0){
                                    self.emptyMsgBtn.removeFromSuperview()
                                    
                                    self.currentInventoryTblView.isHidden = false
                                    
                                    print(self.accountID)
                                    
                                    self.getBannners()

                                }else{
                                    self.currentInventoryTblView.isHidden = true
                                    self.showEmptyMsgBtn()
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
        
                       if(self.currentInventoryResult.count == 0){
//                           self.showEmptyMsgBtn()
                    }
            
                }

    func giveAwayStatusAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false

        let URLString_loginIndividual = Constants.BaseUrl + UpdateGiveAwayStatusUrl
        
        let params_IndividualLogin = ["accountId":accountID,"productId":prodIdStr!,"giveAwayStatus":giveAwayBool] as [String : Any]
                
                    let postHeaders_IndividualLogin = ["":""]
                    
                    currentInventoryService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")
                            
                            self.showAlertWith(title: "Success", message: messageResp ?? "")
                            
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
    
    func addToCartAPICall() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
//        reqQtyStr = "10"
        
        let URLString_loginIndividual = Constants.BaseUrl + AddToCartUrl
        
//        accountId": "5fe970c651de0c7206d6175c",
//            "productId": "602657fd178e4517caba8c97",
//            "productImages": [
//                {
//                    "productImage": ""
//                },
//                {
//                    "productImage": ""
//                },
//                {
//                    "productImage": ""
//                }
//            ],
//            "purchaseDate": "2021-02-16"
        
        let params_IndividualLogin = ["accountId":accountID,"productId":prodIdStr!,"purchaseDate":purchaseDateStr as Any] as [String : Any]
        
//        let params_IndividualLogin = ["accountId":"5f6d80e4950eaf1c4bfea973","productId":"5f87ee5a48722c01ad5394c8","requiredQuantity":reqQtyStr!,"plannedPurchasedate":"2020-10-15"]
                
//                    print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
                    currentInventoryService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")

                            if(statusCode == 200 ){
                                
                                self.moveToCartAlert()
                                
//                                self.showAlertWith(title: "Success", message: "Added to cart succesfully")
                                

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
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + localSortUrl + accountID as String + "/\(sortOrderString)" + "/\(searchOrderString)" + "/currentInventory"
                            currentInventoryService.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                if(respVo.result!.count)>0{
                                    
                                    self.currentInventoryResult = NSMutableArray()
                                    let dataDict = result as! NSDictionary
                                    
                                    self.currentInventoryResult = dataDict.value(forKey: "result") as! NSMutableArray
                                    self.currentInventoryTblView.reloadData()

                                }
                                
                                if(self.currentInventoryResult.count > 0){
                                    self.emptyMsgBtn.removeFromSuperview()

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
        
        if(self.currentInventoryResult.count == 0){
//            self.showEmptyMsgBtn()
            
        }
    }
    
    
    func SortFilterAPICall() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + FilterSortUrl + accountID as String + "/\(sortOrderString)" + "/\(searchOrderString)"
                            currentInventoryService.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                if(respVo.result!.count)>0{
                                    
                                    let dataDict = result as! NSDictionary
                                    
                                    self.currentInventoryResult = dataDict.value(forKey: "result") as! NSMutableArray
                                    self.currentInventoryTblView.reloadData()

                                }
                                
                                if(self.currentInventoryResult.count > 0){
                                    self.emptyMsgBtn.removeFromSuperview()

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
        
        if(self.currentInventoryResult.count == 0){
//            self.showEmptyMsgBtn()
            
        }
    }
    
    func filterApplyAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
//        http://35.154.239.192:4500/endusers/getGlobalSearchFilter/:accountid/:searchParam/:fromdate/:toDate
        
        let URLString_loginIndividual = Constants.BaseUrl + FilterSortUrl + accountID as String + "/\(searchFilterStatusStr)" + "/\(filterStartDateStr)" + "/\(filetEndDateStr)"
            
        currentInventoryService.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")

                            if(statusCode == 200 ){
                                

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
    
    func getBannners(){
    
    activity.startAnimating()
    self.view.isUserInteractionEnabled = true
    
    print("Acc ID is \(accountID)")
        let defaults = UserDefaults.standard
        var userID = String()
        userID = (defaults.string(forKey: "userID") ?? "")

    let URLString_loginIndividual = Constants.BaseUrl + BannnersUrl + "\(accountID)/" + "\(userID)"
                                
    currentInventoryService.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                        let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        _ = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            
                            let dataDict = result as? NSDictionary
                            
                            self.topBannerResultArray = dataDict?.value(forKey: "result")  as! NSMutableArray
                            
                            if(self.topBannerResultArray.count > 0){
                                self.collectionview.reloadData()
                                
                            }
                            
                            print("Banners is \(self.topBannerResultArray)")
                            
                        }else {
                            
                            self.showAlertWith(title: "Alert", message: messageResp ?? "")
                        }
                        
                    }) { (error) in
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        print("Something Went To Wrong...PLrease Try Again Later")
                    }
        
    }

    
}

