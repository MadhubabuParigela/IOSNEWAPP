//
//  OrderHistoryViewController.swift
//  Lekha
//
//  Created by Mallesh on 10/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown

class OrderHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var lookingForTxtField: UITextField!
    
    var ordersHistoryServcCntrl = ServiceController()
    var ordersHistoryResult = [OrderHistoryResultVo]()
    
    var emptyMsgBtn = UIButton()
    
    @IBAction func onClickReloadButton(_ sender: UIButton) {
        localSearchOrderHistory=""
        self.getOrdersHistoryAPI()
        orderHistoryTblView.reloadData()
    }
    @IBOutlet var reloadButton: UIButton!
    var localSortView = OpenOrdersLocalSortView()
    
    var sortOrderString = String()
    var searchOrderString = String()
    var isExpandable=[Bool]()
    @IBOutlet weak var orderHistoryTblView: UITableView!
    
    var accountID = String()
    var sideMenuView = SideMenuView()


    @IBAction func menuBtnTap(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
        
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

    
    @IBAction func generateReportBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "ReportsVC") as! ReportsVC
        VC.modalPresentationStyle = .fullScreen
//            viewCntrlObj.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBAction func sortBtnTap(_ sender: Any) {
        toggleLocalSortViewWithAnimation()

    }
    
    func toggleLocalSortViewWithAnimation() {
        
        localSortView.removeFromSuperview()
        
        localSortView = OpenOrdersLocalSortView()
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("OpenOrdersLocalSortView", owner: self, options: nil)
        localSortView = allViewsInXibArray?.first as! OpenOrdersLocalSortView
        localSortView.frame = CGRect(x: 0, y: self.view.frame.size.height+350, width: self.view.frame.size.width, height: self.view.frame.size.height)
         self.view.addSubview(localSortView)
        
        localSortView.cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        localSortView.applybtn.addTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        
        localSortView.ascendingBtn.addTarget(self, action: #selector(ascendingBtnTap), for: .touchUpInside)
        localSortView.descendingBtn.addTarget(self, action: #selector(descendingBtnTap), for: .touchUpInside)
        
        localSortView.orderIDBtn.addTarget(self, action: #selector(orderIdBtnTap), for: .touchUpInside)
        localSortView.vendorIDBtn.addTarget(self, action: #selector(vendorIdBtnTap), for: .touchUpInside)

//        let path = UIBezierPath(roundedRect:localSortView.innerLocalSortView.bounds,
//                                byRoundingCorners:[.topRight, .topLeft],
//                                cornerRadii: CGSize(width: 20, height:  20))
//
//        let maskLayer = CAShapeLayer()
//
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
    
    @IBAction func cancelBtnTap(_ sender: UIButton){

        localSortView.backHiddenBtn.isHidden = false
        localSortView.removeFromSuperview()
        
    }
    
    @IBAction func applyBtnTap(_ sender: UIButton){

        if(sortOrderString == ""){
            self.showAlertWith(title: "Alert", message: "Please select sort order type")
            return

        }
        else if(searchOrderString == ""){
            self.showAlertWith(title: "Alert", message: "Please select order Id/ Vendor Id")
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
    
    @IBAction func vendorIdBtnTap(_ sender: UIButton){

        localSortView.orderIDBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        localSortView.vendorIDBtn.setImage(UIImage.init(named: "radio_active"), for: UIControl.State.normal)
        
        searchOrderString = "vendorId"

    }
    
    @IBAction func orderIdBtnTap(_ sender: UIButton){

        localSortView.vendorIDBtn.setImage(UIImage.init(named: "radioInactive"), for: UIControl.State.normal)
        localSortView.orderIDBtn.setImage(UIImage.init(named: "radio_active"), for: UIControl.State.normal)
        
        searchOrderString = "orderId"

    }
    @IBAction func onClickSortButton(_ sender: UIButton) {
    }
    @IBAction func onClickLocalSearchButton(_ sender: UIButton) {
        localSearchView.isHidden = false
        transparentView.isHidden=false
    }
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
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.startDateTF.text = dateFormatter.string(from: datePicker.date)
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
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.endDateTF.text = dateFormatter.string(from: datePickerTwo.date)
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
        
        localSearchTF.text = ""
        startDateTF.text = ""
        endDateTF.text = ""
//        stockQuantityLabel.text = "1-20"
        filetEndDateStr = ""
        localSearchView.isHidden = true
        transparentView.isHidden=true
        filterStartDateStr = ""
            self.getOrdersHistoryAPI()
        
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
    var moduleStatusStr = String()
   
    func filterPopupLocalSearchApplyAPI()
    {
        
        searchFilterStatusStr = localSearchTF.text ?? ""
        stockQuanStr = stockQuantityLabel.text ?? ""
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        moduleKeyStr = "orderHistory"
        
//        http://15.206.193.122:4500/endusers/getLocalSearchFilter/61bc128d5a3c6915fbb648ce/Appy/purchaseDate/2021-01-09/2022-01-09/currentInventory
        
//        http://15.206.193.122:4500/endusers/getLocalSearchFilter/61bc128d5a3c6915fbb648ce/test/stockQuantity/20/40/currentInventory
        
//        http://15.206.193.122:4500/endusers/getLocalSearchFilter/61bc128d5a3c6915fbb648ce/test/expiryDate/2022-01-02/2022-01-09/currentInventory
        
//        http://15.206.193.122:4500/endusers/getLocalSearchFilter/61bc128d5a3c6915fbb648ce/test/stockQuantity/100/10000/currentInventory
        
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
        
        URLString_loginIndividual = URLString_loginIndividual.replacingOccurrences(of: " ", with: "%20")
        localSearchOrderHistory=URLString_loginIndividual
        
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
                                        
                                        if(self.moduleStatusStr == "orderHistory"){
                                            currentInventoryResultt = dataDict.value(forKey: "orderHistoryList") as! NSMutableArray
                                            
                                            self.ordersHistoryResult = currentInventoryResultt as! [OrderHistoryResultVo]
                                            self.orderHistoryTblView.reloadData()
                                            
                                            self.localSearchView.isHidden = true
                                            self.transparentView.isHidden=true
                                            
                                            if(self.ordersHistoryResult.count > 0){
                                                self.emptyMsgBtn.removeFromSuperview()
                                                
                                                self.orderHistoryTblView.isHidden = false
                                                
                                                print(self.accountID)
                                                

                                            }else{
                                                self.orderHistoryTblView.isHidden = true
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
        
    }
    @IBOutlet var transparentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        orderHistoryTblView.delegate = self
        orderHistoryTblView.dataSource = self
        lookingForTxtField.delegate = self
        reloadButton.layer.cornerRadius = 15
        reloadButton.clipsToBounds = true
        createDatePicker()
        createDatePicker2()
        
        datesBgView.isHidden = true
        quantityBgView.isHidden = true
        datesViewHeight.constant = 30
        
        self.transparentView.isHidden=true
        moduleStatusStr = "orderHistory"
        
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
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        orderHistoryTblView.register(UINib(nibName: "OrdersHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersHistoryTableViewCell")

//        orderHistoryTblView.reloadData()
        
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
        getOrdersHistoryAPI()
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
       let headerView = UIView.init(frame: CGRect.init(x: 5, y: 5, width: tableView.frame.width-10, height: 80))
        headerView.backgroundColor = hexStringToUIColor(hex: "ffffff")
        //Order ID
       
        let orderView = UIView()
        orderView.frame = CGRect(x: 0, y: 0, width: headerView.frame.size.width/3, height: 55)
        orderView.backgroundColor = hexStringToUIColor(hex: "ffffff")
       headerView.addSubview(orderView)
      
       
       let textLbl = UILabel()
       textLbl.frame = CGRect(x: 10, y: 10, width: orderView.frame.size.width-10, height: 17)
       textLbl.text = "Order ID"
       textLbl.textColor = hexStringToUIColor(hex: "105fef")
       textLbl.font = UIFont(name: kAppFontMedium, size: 12)
        orderView.addSubview(textLbl)
        
        let orderIDTxtLbl = UILabel()
        orderIDTxtLbl.frame = CGRect(x: 10, y: 28, width: orderView.frame.size.width-10, height: 17)
//        orderIDTxtLbl.text = "4544564564"
        orderIDTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
        orderIDTxtLbl.font = UIFont(name: kAppFontMedium, size: 14)
        orderView.addSubview(orderIDTxtLbl)
        
        orderIDTxtLbl.text =  String(ordersHistoryResult[section].orderId ?? "0")
        
        //Vendor ID
       
        let vendorView = UIView()
        vendorView.frame = CGRect(x: orderView.frame.size.width, y: 0, width: headerView.frame.size.width/3, height: 55)
        vendorView.backgroundColor = hexStringToUIColor(hex: "ffffff")
       headerView.addSubview(vendorView)
       
       let vendorLbl = UILabel()
        vendorLbl.frame = CGRect(x: 10, y: 10, width: vendorView.frame.size.width-10, height: 17)
        vendorLbl.text = "Vendor Name"
        vendorLbl.textColor = hexStringToUIColor(hex: "105fef")
        vendorLbl.font = UIFont(name: kAppFontMedium, size: 12)
      vendorView.addSubview(vendorLbl)
        
        let vendorIDTxtLbl = UILabel()
        vendorIDTxtLbl.frame = CGRect(x: 10, y: 28, width: vendorView.frame.size.width-10, height: 17)
        vendorIDTxtLbl.text = String(ordersHistoryResult[section].vendorName ?? "")
        vendorIDTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
        vendorIDTxtLbl.font = UIFont(name: kAppFontMedium, size: 14)
        vendorView.addSubview(vendorIDTxtLbl)
        
        let dateView = UIView()
        dateView.frame = CGRect(x: vendorView.frame.size.width+orderView.frame.size.width, y: 0, width: headerView.frame.size.width, height: 55)
        dateView.backgroundColor = hexStringToUIColor(hex: "ffffff")
       headerView.addSubview(dateView)
       
       let dateLbl = UILabel()
        dateLbl.frame = CGRect(x: 10, y: 10, width: dateView.frame.size.width-10, height: 17)
        dateLbl.text = "Purchase Date"
        dateLbl.textColor = hexStringToUIColor(hex: "105fef")
        dateLbl.font = UIFont(name: kAppFontMedium, size: 12)
        dateView.addSubview(dateLbl)
        
        
        let dateIDTxtLbl = UILabel()
        dateIDTxtLbl.frame = CGRect(x: 10, y: 28, width: dateView.frame.size.width-10, height: 17)
        let vall=String(ordersHistoryResult[section].purchaseDate ?? "")
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
        dateIDTxtLbl.text = valString
        dateIDTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
        dateIDTxtLbl.font = UIFont(name: kAppFontMedium, size: 14)
        dateView.addSubview(dateIDTxtLbl)
        let dropButton = UIButton()
        dropButton.tag=section
        dropButton.frame = CGRect(x: headerView.frame.size.width-30, y: 10, width: 30, height: 30)
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
        let lineView=UIView()
        lineView.frame = CGRect(x: 10, y: orderView.frame.size.height, width: headerView.frame.size.width - 20, height: 1)
        lineView.backgroundColor = hexStringToUIColor(hex: "eeeeee")
        headerView.addSubview(lineView)
        
        return headerView
   }
    @objc func dropDoownBtnTap(sender:UIButton)
    {
     print("Button Tapped,need to insert (or) DElete Rows In Section\(sender.tag)")
     
     if isExpandable[sender.tag] == true {
         isExpandable[sender.tag]=false
        sender.setImage(UIImage(named: "Up"), for: .normal)
        orderHistoryTblView.reloadData()
       }
       else if isExpandable[sender.tag] == false  {
         isExpandable[sender.tag]=true
        sender.setImage(UIImage(named: "arrowDown"), for: .normal)
        orderHistoryTblView.reloadData()
            }
         }
    //****************** TableView Delegate Methods*************************//
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpandable[section]==true
        {
        var productsList = [OrderListVo]()
        productsList = ordersHistoryResult[section].productsList!
            for i in 0..<productsList.count
            {
                if productsList[i].isExpandableRow==true
                {
                    productsList[i].isExpandableRow=true
                }
                else
                {
                productsList[i].isExpandableRow=false
                }
            }
        return productsList.count
        }
        return 0
     }
     var indexPathRow=IndexPath()
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = orderHistoryTblView.dequeueReusableCell(withIdentifier: "OrdersHistoryTableViewCell", for: indexPath) as! OrdersHistoryTableViewCell
        
        var productsList = [OrderListVo]()
        productsList = ordersHistoryResult[indexPath.section].productsList!
        
        print(productsList)
        
        let prodDetails = productsList[indexPath.row].productdetails!
        
        let stockDetails = productsList[indexPath.row].stockUnitDetails ?? [StockUnitDetailsVo]()
        let storageOneDetails = productsList[indexPath.row].storageLocationLevel1Details!
        let storageTwoDetails = productsList[indexPath.row].storageLocationLevel2Details!
        let storageThreeDetails = productsList[indexPath.row].storageLocationLevel3Details!
        let priceUnitDetails = productsList[indexPath.row].priceUnitDetails ?? [PriceUnitDetailsVo]()
        let productModifiedDetails = productsList[indexPath.row].productModifingDetails!
      
        
        var cellHieight=Int()
        cellHieight=productsList[indexPath.row].cellHeight ?? 0
        
        let sectionView=orderHistorySectionView()
        sectionView.frame=CGRect(x: cell.cellView.frame.origin.x, y: cell.cellView.frame.origin.y, width: cell.frame.size.width, height: 125)
        sectionView.productId.text = prodDetails.productUniqueNumber
        sectionView.productNameL.text = prodDetails.productName
        sectionView.descriptionL.text = prodDetails.description
        sectionView.collapseButtonL.addTarget(self, action: #selector(rowExpandable), for: .touchUpInside)
        if productsList[indexPath.row].isExpandableRow==true
               {
            sectionView.collapseButtonL.setImage(UIImage.init(named: "Up"), for: .normal)
               }
               else
               {
                sectionView.collapseButtonL.setImage(UIImage.init(named: "arrowDown"), for: .normal)
               }
        let prodArray = prodDetails.productImages
        
        if(prodArray?.count ?? 0  > 0){
            
                    let dict = prodArray?[0] as! NSDictionary
                    
                    let imageStr = dict.value(forKey: "0") as! String
                    
                    if !imageStr.isEmpty {
                        
                        let imgUrl:String = imageStr
                        
                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                            
                        let imggg = Constants.BaseImageUrl + trimStr
                        
                        let url = URL.init(string: imggg)

//                        cell.prodImgView?.sd_setImage(with: url , placeholderImage: UIImage(named: "add photo"))
                        
                        sectionView.productImage?.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                        
                        sectionView.productImage?.contentMode = UIView.ContentMode.scaleAspectFit
                        
                    }
                    else {
                        
                        sectionView.productImage?.image = UIImage(named: "no_image")
                    }
        }else{
            
            sectionView.productImage?.image = UIImage(named: "no_image")
        }

        if productsList[indexPath.row].isExpandableRow == true {
        let statusView=UIView()
        statusView.frame=CGRect(x: cell.cellView.frame.origin.x, y: sectionView.frame.size.height-10, width: cell.cellView.frame.size.width, height: CGFloat(cellHieight-125))
            var productHeightCount=Int()
        for i in 0..<productModifiedDetails.count
        {
            let accountInfoDetails:[AccountinfoVo] = productModifiedDetails[i].accountinfo ?? [AccountinfoVo]()
            let userInfoDetails:[UserinfoVo] = productModifiedDetails[i].userinfo ?? [UserinfoVo]()
            var nameLabel=String()
                   if userInfoDetails.count>0
                   {
                       let ffname=userInfoDetails[0].firstName ?? ""
                       let ssname=userInfoDetails[0].lastName ?? ""
                       nameLabel=ffname + " " + ssname
                   }
            if productModifiedDetails[i].changeType=="Add"
            {
               
                let statusCellView=AddOrderHistoryView()
                statusCellView.frame=CGRect(x: statusView.frame.origin.x, y: CGFloat(productHeightCount), width: statusView.frame.size.width, height: 308)
                statusCellView.changeTypeLabel.text=productModifiedDetails[i].changeType
                if accountInfoDetails.count > 0 {
                    statusCellView.companyNameL.text=accountInfoDetails[0].companyName
                }
                
                statusCellView.modifiedDateL.text=productModifiedDetails[i].modifiedDateTime
                statusCellView.userAccountL.text=nameLabel
                statusCellView.orderedQtyL.text="\(prodDetails.stockQuantity ?? 0)"
                if stockDetails.count > 0 {
                    statusCellView.stockUnitL.text=stockDetails[0].stockUnitName
                }
                
                let expiryDate = prodDetails.expiryDate ?? ""
                statusCellView.expiryDateL.text=convertDateFormatter(date: expiryDate)
                if priceUnitDetails.count > 0 {
                    statusCellView.priceUnitL.text=priceUnitDetails[0].priceUnit
                }
                
                statusCellView.priceperstockUnitL.text="\(prodDetails.unitPrice ?? 0)"
                statusCellView.totalPriceL.text=String(format:"%.2f", prodDetails.price ?? 0)
                if storageOneDetails.count != 0 {
                    statusCellView.storageLocation1L.text = storageOneDetails[0].slocName
                }
                else {
                    
                    statusCellView.storageLocation1L.text = ""
                }
                if storageTwoDetails.count != 0 {
                    if let slocTwoObj = storageTwoDetails[0].slocName {
                        statusCellView.storageLocation2L.text = slocTwoObj
                    }
                }
                else {
                    statusCellView.storageLocation2L.text = ""
                }
                if storageThreeDetails.count != 0 {
                    if let slocObjj = storageThreeDetails[0].slocName {
                        statusCellView.storageLocation3L.text = slocObjj
                    }
                }
                else {
                    statusCellView.storageLocation3L.text = ""
                }
                statusCellView.categoryL.text=prodDetails.category
                statusCellView.dataView.layer.borderWidth=1
                if #available(iOS 13.0, *) {
                    statusCellView.dataView.layer.borderColor = CGColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
                } else {
                    // Fallback on earlier versions
                }
                statusCellView.subcategoryL.text=prodDetails.subCategory
                statusView.addSubview(statusCellView)
                print("productHeightCount1",productHeightCount)
                productHeightCount += 308
                print("productHeightCount2",productHeightCount)
            }
            else if productModifiedDetails[i].changeType=="Update"
            {
                    if productModifiedDetails[i].change=="share"
                    {
                        let statusCellView=ShareOrderHistoryView()
                       statusCellView.frame=CGRect(x: statusView.frame.origin.x, y: CGFloat(productHeightCount), width: statusView.frame.size.width, height: 168)
                        statusCellView.changeTypeLabel.text=productModifiedDetails[i].changeType
                        if accountInfoDetails.count > 0 {
                            statusCellView.companyNameL.text=accountInfoDetails[0].companyName
                        }
                        
                           statusCellView.modifiedDateL.text=productModifiedDetails[i].modifiedDateTime
                           statusCellView.userAccountL.text=nameLabel
                        let sharedUserDetails=productModifiedDetails[i].sharedUserDetails
                        let sharedUserArray=sharedUserDetails?["userDetails"]as? [AnyObject] ?? [AnyObject]()
                        if productModifiedDetails[i].shared==true
                        {
                            statusCellView.checkButton.setImage(UIImage(named: "checkBoxActive"), for: .normal)
                        }
                        else
                        {
                            statusCellView.checkButton.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
                        }
                        if productModifiedDetails[i].change=="uncheck-share"
                        {
                            statusCellView.checkButton.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
                        }
                        if let aashared=sharedUserDetails?["sharedQuantity"]as? Float
                        {
                            statusCellView.stockQty.text=String(sharedUserDetails?["sharedQuantity"]as? Float ?? 0)
                        }
                        else if let aashared=sharedUserDetails?["sharedQuantity"]as? Double
                        {
                            statusCellView.stockQty.text=String(sharedUserDetails?["sharedQuantity"]as? Double ?? 0)
                        }
                        else if let aashared=sharedUserDetails?["sharedQuantity"]as? Int
                        {
                            statusCellView.stockQty.text=String(sharedUserDetails?["sharedQuantity"]as? Int ?? 0)
                        }
                        else
                        {
                            statusCellView.stockQty.text=sharedUserDetails?["sharedQuantity"]as? String ?? ""
                        }
                        if stockDetails.count > 0 {
                            statusCellView.stockUnitL.text=stockDetails[0].stockUnitName
                        }
                        var nameLabel=String()
                        if sharedUserArray.count>0
                        {
                            let shareDict=sharedUserArray[0]
                            let ffname=shareDict["firstName"] as? String ?? ""
                            let ssname=shareDict["lastName"] as? String ?? ""
                            nameLabel=ffname + " " + ssname
                        }
                        statusCellView.sharedUserL.text=nameLabel
                        
                           
                           statusCellView.dataView.layer.borderWidth=1
                           if #available(iOS 13.0, *) {
                               statusCellView.dataView.layer.borderColor = CGColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
                           } else {
                               // Fallback on earlier versions
                           }
                           
                           statusView.addSubview(statusCellView)
                        print("productHeightCount1",productHeightCount)
                        productHeightCount += 168
                        print("productHeightCount2",productHeightCount)
                    }
                    else if productModifiedDetails[i].change=="uncheck-share"
                    {
                        let statusCellView=ShareOrderHistoryView()
                       statusCellView.frame=CGRect(x: statusView.frame.origin.x, y: CGFloat(productHeightCount), width: statusView.frame.size.width, height: 118)
                        statusCellView.changeTypeLabel.text=productModifiedDetails[i].changeType
                        if accountInfoDetails.count > 0 {
                            statusCellView.companyNameL.text=accountInfoDetails[0].companyName
                        }
                           statusCellView.modifiedDateL.text=productModifiedDetails[i].modifiedDateTime
                           statusCellView.userAccountL.text=nameLabel
                        let sharedUserDetails=productModifiedDetails[i].sharedUserDetails
                        let sharedUserArray=sharedUserDetails?["userDetails"]as? [AnyObject] ?? [AnyObject]()
                       
                            statusCellView.checkButton.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
                       
                        statusCellView.stockQty.text=String(productModifiedDetails[i].availableStockQuantity ?? 0)
                        if stockDetails.count > 0 {
                            statusCellView.stockUnitL.text=stockDetails[0].stockUnitName
                        }
                        statusCellView.sharedUserView.isHidden=true
                           
                           statusCellView.dataView.layer.borderWidth=1
                           if #available(iOS 13.0, *) {
                               statusCellView.dataView.layer.borderColor = CGColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
                           } else {
                               // Fallback on earlier versions
                           }
                           
                           statusView.addSubview(statusCellView)
                        print("productHeightCount1",productHeightCount)
                        productHeightCount += 118
                        print("productHeightCount2",productHeightCount)
                    }
                   else if productModifiedDetails[i].change=="giveAway" || productModifiedDetails[i].change=="uncheck-giveAway"
                    {
                    let statusCellView=GiveAwayOrderHistoryView()
                   statusCellView.frame=CGRect(x: statusView.frame.origin.x, y: CGFloat(productHeightCount), width: statusView.frame.size.width, height: 115)
                       statusCellView.changeTypeLabel.text=productModifiedDetails[i].changeType
                    if accountInfoDetails.count > 0 {
                        statusCellView.companyNameL.text=accountInfoDetails[0].companyName
                    }
                       statusCellView.modifiedDateL.text=productModifiedDetails[i].modifiedDateTime
                       statusCellView.userAccountL.text=nameLabel
                    if let giveAwayy=productModifiedDetails[i].giveAwayStatus
                    {
                       if giveAwayy == false
                       {
                        statusCellView.checkButton.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
                       }
                        else
                       {
                        statusCellView.checkButton.setImage(UIImage(named: "checkBoxActive"), for: .normal)
                       }
                    }
                    else
                    {
                        statusCellView.checkButton.setImage(UIImage(named: "checkBoxActive"), for: .normal)
                    }
                    if productModifiedDetails[i].change=="uncheck-giveAway"
                    {
                        statusCellView.checkButton.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
                    }
                    statusCellView.stockQty.text=String(productModifiedDetails[i].availableStockQuantity ?? 0)
                    if stockDetails.count > 0{
                        statusCellView.stockUnitL.text=stockDetails[0].stockUnitName
                    }
                    
                       statusCellView.dataView.layer.borderWidth=1
                       if #available(iOS 13.0, *) {
                           statusCellView.dataView.layer.borderColor = CGColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
                       } else {
                           // Fallback on earlier versions
                       }
                      
                       statusView.addSubview(statusCellView)
                    print("productHeightCount1",productHeightCount)
                    productHeightCount += 115
                    print("productHeightCount2",productHeightCount)
                    }
                    else
                    {
                        let statusCellView=UpdateOrderHistoryView()
                       statusCellView.frame=CGRect(x: statusView.frame.origin.x, y: CGFloat(productHeightCount), width: statusView.frame.size.width, height: 190)
                           statusCellView.changeTypeLabel.text=productModifiedDetails[i].changeType
                        if accountInfoDetails.count > 0 {
                            statusCellView.companyNameL.text=accountInfoDetails[0].companyName
                        }
                           
                           statusCellView.modifiedDateL.text=productModifiedDetails[i].modifiedDateTime
                           statusCellView.userAccountL.text=nameLabel
                           statusCellView.availableStockL.text=String(productModifiedDetails[i].availableStockQuantity ?? 0)
                        if stockDetails.count > 0{
                            statusCellView.stockUnitL.text=stockDetails[0].stockUnitName
                        }
                           
                           statusCellView.currentStatusL.text=productModifiedDetails[i].currentProductStatus
                           statusCellView.updatedStockL.text=String(productModifiedDetails[i].changedStockQuantity ?? 0)
                           statusCellView.dataView.layer.borderWidth=1
                           if #available(iOS 13.0, *) {
                               statusCellView.dataView.layer.borderColor = CGColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
                           } else {
                               // Fallback on earlier versions
                           }
                        statusCellView.dateL.text = convertDateFormatter(date: productModifiedDetails[i].statusUpdatedDate ?? "")
//                            productModifiedDetails[i].statusUpdatedDate
                           statusView.addSubview(statusCellView)
                        print("productHeightCount1",productHeightCount)
                        productHeightCount += 190
                        print("productHeightCount2",productHeightCount)
                    }
            
            }
            else
            {
             let statusCellView=UpdateOrderHistoryView()
            statusCellView.frame=CGRect(x: statusView.frame.origin.x, y: CGFloat(productHeightCount), width: statusView.frame.size.width, height: 190)
                statusCellView.changeTypeLabel.text=productModifiedDetails[i].changeType
                if accountInfoDetails.count > 0 {
                    statusCellView.companyNameL.text=accountInfoDetails[0].companyName
                }
                statusCellView.modifiedDateL.text=productModifiedDetails[i].modifiedDateTime
                statusCellView.userAccountL.text=nameLabel
                statusCellView.availableStockL.text=String(productModifiedDetails[i].availableStockQuantity ?? 0)
                if stockDetails.count > 0{
                    statusCellView.stockUnitL.text=stockDetails[0].stockUnitName
                }
                statusCellView.currentStatusL.text=productModifiedDetails[i].currentProductStatus
                statusCellView.updatedStockL.text=String(productModifiedDetails[i].changedStockQuantity ?? 0)
                statusCellView.dataView.layer.borderWidth=1
                if #available(iOS 13.0, *) {
                    statusCellView.dataView.layer.borderColor = CGColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
                } else {
                    // Fallback on earlier versions
                }
                statusCellView.dateL.text = convertDateFormatter(date: productModifiedDetails[i].statusUpdatedDate ?? "")
                statusView.addSubview(statusCellView)
                print("productHeightCount1",productHeightCount)
                productHeightCount += 190
                print("productHeightCount2",productHeightCount)
            }
        
        
       }
        cell.cellView.addSubview(sectionView)
        cell.cellView.addSubview(statusView)
        }
        else
        {
            cell.cellView.addSubview(sectionView)
        }

        return cell
     }
    @objc func rowExpandable(sender:UIButton)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: orderHistoryTblView)
        let indexPath = self.orderHistoryTblView.indexPathForRow(at: buttonPosition)
        var productsList = [OrderListVo]()
        productsList = ordersHistoryResult[indexPath!.section].productsList!
        
        print(productsList)
        if productsList[indexPath!.row].isExpandableRow == true {
            productsList[indexPath!.row].isExpandableRow=false
           orderHistoryTblView.reloadData()
          }
          else if productsList[indexPath!.row].isExpandableRow == false  {
            productsList[indexPath!.row].isExpandableRow=true
           orderHistoryTblView.reloadData()
               }

        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return ordersHistoryResult.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var productsList = [OrderListVo]()
        productsList = ordersHistoryResult[indexPath.section].productsList!
        
        print(productsList)
        if productsList[indexPath.row].isExpandableRow==false
        {
            productsList[indexPath.row].cellHeight = 125
            return 125
        }
        else if productsList[indexPath.row].isExpandableRow==true
        {
            var productModifiedDetails=[ProductModifingDetailsVo]()
             productModifiedDetails = productsList[indexPath.row].productModifingDetails!
            var celllHeight=Int()
            celllHeight = 125
            for i  in 0..<productModifiedDetails.count
            {
            if productModifiedDetails[i].changeType=="Add"
            {
                celllHeight += 308
                productsList[indexPath.row].cellHeight! += 308
            }
            else  if productModifiedDetails[i].changeType=="Update"
            {
                if productModifiedDetails[i].change=="share"
                {
                    celllHeight += 168
                    productsList[indexPath.row].cellHeight! += 168
                }
                else if productModifiedDetails[i].change=="uncheck-share"
                {
                    celllHeight += 118
                    productsList[indexPath.row].cellHeight! += 118
                }
               else if productModifiedDetails[i].change=="giveAway" || productModifiedDetails[i].change=="uncheck-giveAway"
                {
                celllHeight += 115
                productsList[indexPath.row].cellHeight! += 115
                }
                else
                {
                    celllHeight += 190
                    productsList[indexPath.row].cellHeight! += 190
                }
            }
            else
            {
                celllHeight += 190
                productsList[indexPath.row].cellHeight! += 190
            }
            }
            return CGFloat(celllHeight)
        }
        return 0
        
    }

   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
       return 70
       
   }
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

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
    
    func getOrdersHistoryAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + OrdersHistoryUrl + accountID
                                    
        ordersHistoryServcCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:OrderHistoryRespVo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                self.ordersHistoryResult = respVo.result!
                               
                                self.isExpandable=[Bool]()
                                if self.ordersHistoryResult.count>0
                                {
                                    for i in 0..<self.ordersHistoryResult.count {
                                        self.isExpandable.append(false)
                                }
                                }
                                self.orderHistoryTblView.reloadData()
                                if(self.ordersHistoryResult.count == 0){
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
    
    func getLocalSortAPICall() {
        
        localSortView.backHiddenBtn.isHidden = false
        localSortView.removeFromSuperview()
        
        print(sortOrderString)
        print(searchOrderString)
        
        ordersHistoryResult = [OrderHistoryResultVo]()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + localSortUrl + accountID as String + "/\(sortOrderString)" + "/\(searchOrderString)" + "/orderHistory"
        
        ordersHistoryServcCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:OrderHistoryRespVo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                self.ordersHistoryResult = respVo.result!
                                self.isExpandable=[Bool]()
                                if self.ordersHistoryResult.count>0
                                {
                                    for i in 0..<self.ordersHistoryResult.count {
                                        self.isExpandable.append(false)
                                }
                                }
                                self.orderHistoryTblView.reloadData()

                            }
                            else {
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
        
        if(self.ordersHistoryResult.count == 0){
//            self.showEmptyMsgBtn()
            
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

