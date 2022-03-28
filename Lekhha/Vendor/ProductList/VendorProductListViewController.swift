//
//  VendorProductListViewController.swift
//  LekhaLatest
//
//  Created by USM on 15/04/21.
//

import UIKit
import ObjectMapper
import DropDown

class VendorProductListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var lookingForTF: UITextField!
    @IBOutlet weak var prodListTblView: UITableView!
    
    var sideMenuView = SideMenuView()
    var accountID = String()
    var serviceCntrl = ServiceController()
    var vendorProductsListArray = NSMutableArray()
    
    var emptyMsgBtn = UIButton()
    var productListArray = NSMutableArray()
    var localSortView = LocalSortView()
    
    @IBAction func addProductButton(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "VendorAddProductViewController") as! VendorAddProductViewController
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func sortButton(_ sender: UIButton) {
        toggleLocalSortViewWithAnimation()

    }
    @IBAction func localSearchButton(_ sender: UIButton) {
        localSearchView.isHidden = false
        transparentView.isHidden=false
    }
    @IBAction func menuBtnTapped(_ sender: Any) {
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
    func getLocalSortAPICall() {
        
        localSortView.backHiddenBtn.isHidden = false
        localSortView.removeFromSuperview()
        
        print(sortOrderString)
        print(searchOrderString)
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + GetVendorProductsSortListUrl + accountID as String + "/\(sortOrderString)" + "/\(searchOrderString)"
                            serviceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                if(respVo.result!.count)>0{
                                    
                                    self.vendorProductsListArray = NSMutableArray()
                                    let dataDict = result as! NSDictionary
                                    
                                    self.vendorProductsListArray = dataDict.value(forKey: "result") as! NSMutableArray
                                    self.prodListTblView.reloadData()

                                }
                                
                                if(self.vendorProductsListArray.count > 0){
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
        
        if(self.vendorProductsListArray.count == 0){
//            self.showEmptyMsgBtn()
            
        }
    }
    var isLocalSearch = String()
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
    var stockQuanStr = String()
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
    
   
    @IBOutlet var transparentView: UIView!
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
    func filterPopupLocalSearchApplyAPI() {
        
        searchFilterStatusStr = localSearchTF.text ?? ""
        stockQuanStr = stockQuantityLabel.text ?? ""
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
 
        var URLString_loginIndividual = Constants.BaseUrl + VendorProductLocalSearchListUrl
        
        var jsonObject = [String:AnyObject]()
        jsonObject["accountId"] = accountID as AnyObject
        jsonObject["searchParam"] = self.localSearchTF.text as AnyObject
                jsonObject["filterKey"] = filterKeyStr as AnyObject
        jsonObject["start"] = filterStartDateStr as AnyObject
        jsonObject["end"] = filetEndDateStr as AnyObject

      
        URLString_loginIndividual = URLString_loginIndividual.replacingOccurrences(of: " ", with: "%20")
       // localSearchInventory=URLString_loginIndividual
        
        let urlString = URLString_loginIndividual.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
        let postHeaders_IndividualLogin = ["":""]
        
        serviceCntrl.requestPOSTURL(strURL: urlString as! NSString, postParams: jsonObject as [String:AnyObject] as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

            
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
                        
                        self.vendorProductsListArray = dataDict.value(forKey: "result") as! NSMutableArray
                        self.prodListTblView.reloadData()
                        
                        self.localSearchView.isHidden = true
                        self.transparentView.isHidden=true
                        
                        if(self.vendorProductsListArray.count > 0){
                            self.emptyMsgBtn.removeFromSuperview()
                            
                            self.prodListTblView.isHidden = false
                            
                            print(self.accountID)
                            

                        }else{
                            self.prodListTblView.isHidden = true
                            
                            self.showEmptyMsgBtn()
                        }
                    
                  
       
                                
                    print("Filters Data is \(self.filtersDataArray)")
                    

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
        self.getVendorProductsListAPI()
        prodListTblView.reloadData()
        
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
    var sortOrderString = "Ascending"
    var searchOrderString = "purchaseDate"
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
    
    
    @IBAction func addProdBtnTapped(_ sender: Any) {
        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let VC = storyBoard.instantiateViewController(withIdentifier: "VendorAddProductViewController") as! VendorAddProductViewController
//        VC.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(VC, animated: true)

        
//
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
        createDatePicker()
        createDatePicker2()
        
        transparentView.isHidden=true
        datesBgView.isHidden = true
        quantityBgView.isHidden = true
        datesViewHeight.constant = 30
        
        
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
        print(accountID)
       
        prodListTblView.delegate = self
        prodListTblView.dataSource = self
        
        prodListTblView.register(UINib(nibName: "VendorAddProductTableViewCell", bundle: nil), forCellReuseIdentifier: "VendorAddProductTableViewCell")
        sortOrderString = ""
        searchOrderString = ""
        searchFilterStatusStr = ""
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: lookingForTF.frame.size.width - (35), y: 0, width: 35, height: lookingForTF.frame.size.height)
        lookingForTF.rightView = paddingView
        lookingForTF.rightViewMode = UITextField.ViewMode.always
        
        lookingForTF.delegate = self
        
        let filterBtn = UIButton()
        filterBtn.frame = CGRect(x: paddingView.frame.size.width/2 - 12.5, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
        filterBtn.addTarget(self, action: #selector(onFilterBtnTap), for: .touchUpInside)
        paddingView.addSubview(filterBtn)
        
        if(isFilter == "1"){ //GLOBAL SEARCH
           prodListTblView.reloadData()

        }else{
            if localSearchInventory==""
            {
                self.getVendorProductsListAPI()
            }
            else
            {
                self.filterPopupLocalSearchApplyAPI()
            
            }

        }

//        prodListTblView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    @objc func onFilterBtnTap(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "VendorProductSearchViewController") as! VendorProductSearchViewController
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)

        lookingForTF.resignFirstResponder()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getVendorProductsListAPI()

    }
    
    @IBAction func menuOrderBtnTapped(_ sender: Any) {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == lookingForTF){
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "VendorProductSearchViewController") as! VendorProductSearchViewController
            VC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(VC, animated: true)

            textField.resignFirstResponder()

        }
    }
    
    //****************** TableView Delegate Methods*************************//
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productListArray.count
         
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = prodListTblView.dequeueReusableCell(withIdentifier: "VendorAddProductTableViewCell", for: indexPath) as! VendorAddProductTableViewCell
        
        
        let dataDict = productListArray.object(at: indexPath.row) as? NSDictionary
        
        cell.idLbl.text = dataDict?.value(forKey: "_id") as? String
        cell.prodNameLbl.text = dataDict?.value(forKey: "productName") as? String
        cell.descLbl.text = dataDict?.value(forKey: "description") as? String
        
        let stockQuan = dataDict?.value(forKey: "stockQuantity") as? Int
        cell.stockQtyLbl.text = String(stockQuan ?? 0)

        cell.stockUnitLbl.text = dataDict?.value(forKey: "stockUnit") as? String
        
        let actualPrice = dataDict?.value(forKey: "actualPrice") as? Int
        cell.actualPriceLbl.text = String(actualPrice ?? 0)
        
        let offerPrice = dataDict?.value(forKey: "offeredPrice") as? Int
        cell.offeredPriceLbl.text = String(offerPrice ?? 0)

        let expiryDate = (dataDict?.value(forKey: "expiryDate") as? String) ?? ""
            let convertedExpiryDate = convertServerDateFormatter(date: expiryDate)
            cell.expiryDateLbl.text = convertedExpiryDate

        cell.categoryLbl.text = dataDict?.value(forKey: "category") as? String
        cell.subCategoryLbl.text = dataDict?.value(forKey: "subCategory") as? String
        
        let prodArray = dataDict?.value(forKey: "vendorProductImages") as? NSArray
        
        cell.editProductBtn.addTarget(self, action: #selector(editProdBtnTap), for: .touchUpInside)
        cell.editProductBtn.tag = indexPath.row

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
        
         return cell
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
         
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 335

     }
    
    
    
    @objc func editProdBtnTap(_ sender: UIButton) {

                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                  let VC = storyBoard.instantiateViewController(withIdentifier: "VendorAddProductViewController") as! VendorAddProductViewController
                                  VC.modalPresentationStyle = .fullScreen
                                  VC.isEditVendorProduct = true
                                  VC.editProductDict = (productListArray.object(at: sender.tag) as? NSDictionary)!
        //                          self.present(VC, animated: true, completion: nil)
                            self.navigationController?.pushViewController(VC, animated: true)

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
        //self.view.addSubview(emptyMsgBtn)
        //self.view.sendSubviewToBack(emptyMsgBtn)
        
        self.view.insertSubview(emptyMsgBtn, belowSubview: self.localSearchView)
        self.view.insertSubview(emptyMsgBtn, belowSubview: self.transparentView)
        
    }
    
    
    func getVendorProductsListAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + GetVendorProductsListUrl + accountID as String
        serviceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                let dataDict = result as! NSDictionary
                                
                                self.productListArray = dataDict.value(forKey: "result") as! NSMutableArray
                                self.prodListTblView.reloadData()
                                
                                if(self.productListArray.count > 0){
                                    self.emptyMsgBtn.removeFromSuperview()
                                    
                                    print(self.accountID)

                                }else if(self.productListArray.count == 0){
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
        
                       if(self.productListArray.count == 0){
//                           self.showEmptyMsgBtn()
                    }
            
                }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 210
//
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
