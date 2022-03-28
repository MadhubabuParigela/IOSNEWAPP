//
//  OpenOrdersViewController.swift
//  Lekha
//
//  Created by USM on 23/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown

class OpenOrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var isExpandable=[Bool]()
    @IBOutlet weak var lookingForTxtField: UITextField!
    var sideMenuView = SideMenuView()
    @IBAction func onClickReloadButton(_ sender: UIButton) {
        localSearchOpenOrders=""
        self.getOpenOrdersAPI()
        openOrdersTblView.reloadData()
    }
    @IBOutlet var reloadButton: UIButton!
    @IBAction func updateBtnTapped(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "UpdateOpenOrderViewController") as! UpdateOpenOrderViewController
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)
//        self.present(VC, animated: true, completion: nil)

    }

    @IBAction func addOrderBtnTapped(_ sender: Any) {
    }
    
    var openOrdersServiceCntrl = ServiceController()
    var openOrdersResult = [OpenOrdersResult]()
    var accountID = String()
    var sortOrderString = String()
    var searchOrderString = String()
    
    var localSortView = OpenOrdersLocalSortView()
    
    let emptyMsgBtn = UIButton()

    @IBAction func menuBtnTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)

        toggleSideMenuViewWithAnimation()
    }
    @objc func dropDoownBtnTap(sender:UIButton)
    {
     print("Button Tapped,need to insert (or) DElete Rows In Section\(sender.tag)")
     
     if isExpandable[sender.tag] == true {
         isExpandable[sender.tag]=false
        sender.setImage(UIImage(named: "Up"), for: .normal)
        openOrdersTblView.reloadData()
       }
       else if isExpandable[sender.tag] == false  {
         isExpandable[sender.tag]=true
        sender.setImage(UIImage(named: "arrowDown"), for: .normal)
        openOrdersTblView.reloadData()
            }
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

    
    @IBAction func onClickLocalSearchButton(_ sender: UIButton) {
        localSearchView.isHidden = false
        transparentView.isHidden=false
    }
    @IBOutlet weak var openOrdersTblView: UITableView!
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
        self.view.endEditing(true)
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
            self.getOpenOrdersAPI()
        
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
        
        moduleKeyStr = "openOrders"
        
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
        localSearchOpenOrders=URLString_loginIndividual
        
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
                                        
                                        if(self.moduleStatusStr == "openOrders"){
                                            currentInventoryResultt = dataDict.value(forKey: "operordersList") as! NSMutableArray
                                            
                                            self.openOrdersResult = currentInventoryResultt as! [OpenOrdersResult]
                                            self.openOrdersTblView.reloadData()
                                            
                                            self.localSearchView.isHidden = true
                                            self.transparentView.isHidden=true
                                            
                                            if(self.openOrdersResult.count > 0){
                                                self.emptyMsgBtn.removeFromSuperview()
                                                
                                                self.openOrdersTblView.isHidden = false
                                                
                                                print(self.accountID)
                                                

                                            }else{
                                                self.openOrdersTblView.isHidden = true
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
        
        openOrdersTblView.delegate = self
        openOrdersTblView.dataSource = self
        lookingForTxtField.delegate = self
        reloadButton.layer.cornerRadius = 15
        reloadButton.clipsToBounds = true
        createDatePicker()
        createDatePicker2()
        self.transparentView.isHidden=true
        datesBgView.isHidden = true
        quantityBgView.isHidden = true
        datesViewHeight.constant = 30
        
        moduleStatusStr = "openOrders"
        
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
        
        openOrdersTblView.register(UINib(nibName: "OpenOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OpenOrdersTableViewCell")
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: lookingForTxtField.frame.size.width - (35), y: 0, width: 35, height: lookingForTxtField.frame.size.height)
        lookingForTxtField.rightView = paddingView
        lookingForTxtField.rightViewMode = UITextField.ViewMode.always
        
        lookingForTxtField.delegate = self
        
        let filterBtn = UIButton()
        filterBtn.frame = CGRect(x: paddingView.frame.size.width/2 - 12.5, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
        paddingView.addSubview(filterBtn)


//        openOrdersTblView.reloadData()
        animatingView()

        getOpenOrdersAPI()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        getOpenOrdersAPI()
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
    
    
    @IBAction func addProdBottomBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingVC") as! ShoppingViewController
        VC.modalPresentationStyle = .fullScreen
//            viewCntrlObj.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBAction func updateBottomBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "UpdateOpenOrderViewController") as! UpdateOpenOrderViewController
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)
//        self.present(VC, animated: true, completion: nil)

    }
    
    @IBAction func sortBottomBtnTap(_ sender: Any) {
        toggleLocalSortViewWithAnimation()
    }
    
    func toggleLocalSortViewWithAnimation() {
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == lookingForTxtField){
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "GlobalSearchViewController") as! GlobalSearchViewController
            VC.modalPresentationStyle = .fullScreen
//            self.present(VC, animated: true, completion: nil)
            self.navigationController?.pushViewController(VC, animated: true)
            
            textField.resignFirstResponder()

        }
    }
    
    // MARK: - UITableViewDataSource
    
           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if isExpandable[section]==true
            {
            var productsList = [OpenOrdersProducts]()
            productsList = openOrdersResult[section].productsList!
            
            return productsList.count
            }
            return 0
           }
           
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               
               let cell = tableView.dequeueReusableCell(withIdentifier: "OpenOrdersTableViewCell", for: indexPath) as! OpenOrdersTableViewCell
            
            var productsList = [OpenOrdersProducts]()
            productsList = openOrdersResult[indexPath.section].productsList!
            
//            print(productsList)
            
            let prodDetails = productsList[indexPath.row].productDetails!
            cell.idLbl.text = prodDetails.productUniqueNumber
            cell.prodNameLbl.text = prodDetails.productName
            cell.descriptionLbl.text = prodDetails.description
            cell.orderQtyLbl.text = String(prodDetails.stockQuantity ?? 0)
            
            let unitPriceStr = prodDetails.unitPrice
            
            cell.pricePerStockUnitLabel.text = "\(unitPriceStr ?? 0)"
            
//            cell.orderQtyLbl.text = String((productsList[indexPath.row].productDetails?.stockQuantity!)!)
            var stockUnitStr = String()
            if productsList[indexPath.row].stockUnitDetails?.count ?? 0>0
            {
             stockUnitStr = productsList[indexPath.row].stockUnitDetails?[0].stockUnitName ?? ""
            }
            cell.orderUnitLbl.text = stockUnitStr
//            cell.vendorNameLbl.text = "TEST"
            
//            let vendorDict = productsList[indexPath.row].vendordetails!
//            let vendorName = vendorDict.value(forKey: "vendorName") as? String
            
//            cell.vendorNameLbl.text = vendorName
            let price = prodDetails.price
            
            cell.priceLbl.text = String(format:"%.2f", price ?? 0)
            cell.statusLbl.text = prodDetails.productStatus

            let purchaseDate = prodDetails.purchaseDate ?? ""
            let convertedPurchaseDate = convertDateFormatter(date: purchaseDate)

            cell.purchaseDateLbl.text = convertedPurchaseDate
            
            let prodArray = prodDetails.productImages
            
            if(prodArray?.count ?? 0  > 0){
                
                let dict = prodArray?[0] as! NSDictionary
                
                if(dict.value(forKey: "0") != nil){
                   
                    let imageStr = dict.value(forKey: "0") as! String
                    
                    if !imageStr.isEmpty {
                        
                        let imgUrl:String = imageStr
                        
                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                            
                        let imggg = Constants.BaseImageUrl + trimStr
                        
                        let url = URL.init(string: imggg)

//                        cell.imgView?.sd_setImage(with: url , placeholderImage: UIImage(named: "add photo"))
                        
                        cell.imgView?.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                        
                        cell.imgView?.contentMode = UIView.ContentMode.scaleAspectFit
                  
                    }else {
                        
                        cell.imgView?.image = UIImage(named: "no_image")
                    }
                }
            }else{
                cell.imgView?.image = UIImage(named: "no_image")

            }
               
               return cell
           }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 255

       }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return openOrdersResult.count
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
          let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 90))
        
        headerView.backgroundColor = UIColor.white
        let editBtn = UIButton()
        editBtn.frame = CGRect(x: headerView.frame.size.width - 70, y: 10, width: 60, height: 20)
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
        
        let orderIdLbl = UILabel()
        orderIdLbl.frame = CGRect(x: 15, y: 35, width: headerView.frame.size.width/3 - (20), height: 15)
        orderIdLbl.text = "Order ID "
        orderIdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        orderIdLbl.textColor = hexStringToUIColor(hex: "105fef")
        headerView.addSubview(orderIdLbl)

        let orderIdTxtLbl = UILabel()
        orderIdTxtLbl.frame = CGRect(x: 15, y: orderIdLbl.frame.origin.y+orderIdLbl.frame.size.height+5, width: headerView.frame.size.width/3 - (20), height: 17)
//        orderIdTxtLbl.text = "45435435454"
        orderIdTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        orderIdTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
        headerView.addSubview(orderIdTxtLbl)

//        let transactionID = openOrdersResult[section]._id
//        print(transactionID)
        
//        orderIdTxtLbl.text =  String(openOrdersResult[section]._id!)
        
       

        //vendor id lbl
        
        let vendorIdLbl = UILabel()
        vendorIdLbl.frame = CGRect(x: orderIdLbl.frame.size.width + 10, y: 35, width: headerView.frame.size.width/3 - (20), height: 15)
        vendorIdLbl.text = "Vendor Name "
        vendorIdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        vendorIdLbl.textColor = hexStringToUIColor(hex: "105fef")
        headerView.addSubview(vendorIdLbl)

        let vendorIdTxtLbl = UILabel()
        vendorIdTxtLbl.frame = CGRect(x: orderIdLbl.frame.size.width+10, y: vendorIdLbl.frame.origin.y+vendorIdLbl.frame.size.height+5, width:headerView.frame.size.width/3 - (20), height: 17)
        vendorIdTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        vendorIdTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
        headerView.addSubview(vendorIdTxtLbl)
        
//        vendorIdTxtLbl.text =  String(openOrdersResult[section].vendorName)
        
       

        let dateLbl = UILabel()
        dateLbl.frame = CGRect(x: vendorIdLbl.frame.size.width+orderIdLbl.frame.size.width + 10, y: 35, width: headerView.frame.size.width/3 - (20), height: 17)
         dateLbl.text = "Purchase Date"
         dateLbl.textColor = hexStringToUIColor(hex: "105fef")
         dateLbl.font = UIFont(name: kAppFontMedium, size: 12)
        headerView.addSubview(dateLbl)
         
         
         let dateIDTxtLbl = UILabel()
         dateIDTxtLbl.frame = CGRect(x: vendorIdLbl.frame.size.width+orderIdLbl.frame.size.width + 10, y: dateLbl.frame.origin.y+dateLbl.frame.size.height+5, width: headerView.frame.size.width/3 - (20), height: 17)
       
         dateIDTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
         dateIDTxtLbl.font = UIFont(name: kAppFontMedium, size: 14)
        headerView.addSubview(dateIDTxtLbl)
         let dropButton = UIButton()
         dropButton.tag=section
         dropButton.frame = CGRect(x: headerView.frame.size.width-50, y: 35, width: 30, height: 30)
         dropButton.addTarget(self, action: #selector(dropDoownBtnTap), for: .touchUpInside)
        if isExpandable[section]==true
        {
            dropButton.setImage(UIImage.init(named: "Up"), for: .normal)
        }
        else
        {
            dropButton.setImage(UIImage.init(named: "arrowDown"), for: .normal)
        }
        var productsList=NSMutableArray()
        if localSearchOpenOrders==""
        {
            let orderID = openOrdersResult[section].orderId ?? "0"
            orderIdTxtLbl.text = String(orderID)
            vendorIdTxtLbl.text =  openOrdersResult[section].vendorName
            let vall=String(openOrdersResult[section].purchaseDate ?? "")
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
            productsList = openOrdersResult[section].orderList ?? NSMutableArray()
        }
        else
        {
            //productsList = openOrdersResult[section] as? NSDictionary ?? NSDictionary()
//            let orderID = openOrdersResult[section].orderId ?? "0"
//            orderIdTxtLbl.text = String(orderID)
           // vendorIdTxtLbl.text =  openOrdersResult[section].vendorName
//            let vall=String(openOrdersResult[section].purchaseDate ?? "")
//             let valArr=vall.components(separatedBy: "T")
//             let valAArr=valArr[0].components(separatedBy: "-")
//             var valString=String()
//             if valAArr.count==3
//             {
//                 let aa:String=valAArr[2] + "/"
//                 valString = aa + valAArr[1] + "/" + valAArr[0]
//             }
//             else
//             {
//                 valString = ""
//             }
//             dateIDTxtLbl.text = valString
        }
        let prodInnerDict = productsList[0] as? NSDictionary
        let prodDict = prodInnerDict!.value(forKey: "productdetails") as! NSDictionary
        let uploadType = prodDict.value(forKey: "uploadType") as? String
        
        if(uploadType == "vendor"){
            editBtn.isHidden = true
        }else{
            editBtn.isHidden = false
        }
          headerView.addSubview(dropButton)
        
        return headerView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 90
        
    }
    @objc func editDetailsBtnTapped(_ sender: UIButton){

        let buttonPosition = sender.convert(CGPoint.zero, to: openOrdersTblView)
        let indexPath = openOrdersTblView.indexPathForRow(at: buttonPosition)
        
        var productsList = NSMutableArray()
        
        let dataDict = openOrdersArray[sender.tag] as! NSDictionary

        productsList = openOrdersResult[sender.tag].orderList as! NSMutableArray
        print(productsList)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "EditOpenOrderViewController") as! EditOpenOrderViewController
        VC.modalPresentationStyle = .fullScreen
        VC.myProductArray=NSMutableArray()
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
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

    }
    var openOrdersArray=NSMutableArray()
    func getOpenOrdersAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + OpenOrdersUrl + accountID
                                    
        openOrdersServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:OpenOrdersRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
            
            let dataDict = result as! NSDictionary
            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                self.openOrdersArray = dataDict.value(forKey: "result") as! NSMutableArray
                                self.openOrdersResult = respVo.result!
                                self.isExpandable=[Bool]()
                                print(self.openOrdersResult)
                                if self.openOrdersResult.count>0
                                {
                                    for i in 0..<self.openOrdersResult.count {
                                        self.isExpandable.append(false)
                                }
                                }
                                if(self.openOrdersResult.count == 0){
                                    self.showEmptyMsgBtn()
                                }
                                
                                self.openOrdersTblView.reloadData()

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
        
        openOrdersResult = [OpenOrdersResult]()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
//        http://35.154.239.192:4500/endusers/get_by_accountid/sorting/5fe9604a3daf421753be0a65/Descending/orderId/openOrders

        let URLString_loginIndividual = Constants.BaseUrl + localSortUrl + accountID as String + "/\(sortOrderString)" + "/\(searchOrderString)" + "/openOrders"
        
        openOrdersServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:OpenOrdersRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                self.openOrdersResult = respVo.result!
//                                print(self.openOrdersResult)
                                
                                if(self.openOrdersResult.count == 0){
                                    self.showEmptyMsgBtn()
                                }
                                
                                self.openOrdersTblView.reloadData()
                                
                            }
                            else {
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
        
//        if(self.openOrdersResult.count == 0){
//            self.showEmptyMsgBtn()
//
//        }
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
