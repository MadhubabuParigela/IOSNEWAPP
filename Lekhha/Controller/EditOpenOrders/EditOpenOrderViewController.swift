//
//  EditOpenOrderViewController.swift
//  Lekha
//
//  Created by USM on 15/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown

class EditOpenOrderViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate , UITextFieldDelegate, sentname, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBAction func editOrddrBtnTap(_ sender: Any) {
        loadNewOrderIDView()
    }
    
    @IBOutlet weak var editOpenOrdersBtnTapped: UIButton!
    @IBAction func saveDetailsBtnTap(_ sender: Any) {
        self.productScrollView.removeFromSuperview()
        var mainArrayValidation=NSMutableArray()
        if myProductArray.count>0
        {

        for i in 0..<myProductArray.count {
            
            let dict = myProductArray[i] as! NSDictionary
            var dataDict = NSMutableDictionary()
            dataDict = dict.value(forKey: "productdetails") as! NSMutableDictionary
            let productNameStr = dataDict.value(forKey: productName) as? String
            var stockQuanStr=String()
            if let stockQuan = dataDict.value(forKey: "stockQuantity") as? Double
            {
                stockQuanStr = String(stockQuan)
            }
            else if let stockQuan = dataDict.value(forKey: "stockQuantity") as? Float
            {
                stockQuanStr = String(stockQuan)
            }
            else
            {
                stockQuanStr = dataDict.value(forKey: "stockQuantity") as? String ?? ""
            }
            var pricePerStockUnitStr=String()
            if let pricePerStockUnit = dataDict.value(forKey: "unitPrice") as? Double
            {
                pricePerStockUnitStr = String(pricePerStockUnit)
            }
            else if let pricePerStockUnit = dataDict.value(forKey: "unitPrice") as? Float
            {
                pricePerStockUnitStr = String(pricePerStockUnit)
            }
            else
            {
                pricePerStockUnitStr = dataDict.value(forKey: "unitPrice") as? String ?? ""
            }

            
            if  (productNameStr == "") && (stockQuanStr == "") && (pricePerStockUnitStr == "") {
            
                dataDict.setValue(true, forKey: "productNameWarn")
                dataDict.setValue(true, forKey: "stockQuantityWarn")
                dataDict.setValue(true, forKey: "unitPriceWarn")
                self.showAlertWith(title: "Alert", message: "Please make sure to fill all product details")
                
            }
            if(productNameStr == "") || (stockQuanStr == "") || (pricePerStockUnitStr == ""){

                if(productNameStr == "")
                {
                dataDict.setValue(true, forKey: "productNameWarn")
            }
            if(stockQuanStr == ""){
                dataDict.setValue(true, forKey: "stockQuantityWarn")

            }
                if(pricePerStockUnitStr == "")
                {
                dataDict.setValue(true, forKey: "unitPriceWarn")
            }
                self.showAlertWith(title: "Alert", message: "Please make sure to fill all product details")
            }
            else if(stockQuanStr == "0"){
                
                dataDict.setValue(true, forKey: "stockQuantityWarn")
            }
            else
            {
                mainArrayValidation.add(dataDict)
            }
         
        }
        }
        
        
        if mainArrayValidation.count==myProductArray.count
        {
            if myProductArray.count>0
            {
                
        self.changesUpdate=false
        removeProductImage()
        callUpdateOpenOrdersAPI()
            }
        }
        else
        {
            self.loadAddProductUI()
        }
    }
    
    var prodImgJPos : Int!
    var prodImgIArrayPos : Int!
    var prodImgTagValue : Int!
    
    let hiddenBtn = UIButton()
    var newOrderIDView = UIView()
    let orderIDTF = UITextField()
    @IBOutlet var purchaseDateLabel: UILabel!
    
    func sendnamedfields(fieldname: String, idStr: String) {
        
        openOrdersDict.setValue(idStr, forKey: "vendorId")
        
        for i in 0..<myProductArray.count {
         
            let dataDict = myProductArray.object(at: i) as! NSDictionary
            let vendorDict = dataDict.value(forKey: "vendordetails") as! NSDictionary
            
            vendorDict.setValue(fieldname, forKey: "vendorName")
            vendorDict.setValue(idStr, forKey: "_id")

            dataDict.setValue(vendorDict, forKey: "vendordetails")
            myProductArray.replaceObject(at: i, with: dataDict)
            
        }
        
        openOrdersDict.setValue(myProductArray, forKey: "ordersList")
        
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        self.loadAddProductUI()
        
    }
    
    let pickerDateView = UIView()
    
    var purchase_ExpiryTagVal : Int!
    var purchase_expiryProductPosLev : Int!
    var purchase_expiryTagValue : Int!

    var picker : UIDatePicker = UIDatePicker()
    
    var categoryDataArray = NSMutableArray()
    var categoryIDArray = NSMutableArray()
    
    @IBOutlet weak var vendorOrderView: UIView!
    @IBOutlet weak var topHeaderView: UIView!
    
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var vendorIDLbl: UILabel!
    
    var editServCntrl = ServiceController()
    var vendorListResult = [VendorListResult]()
    
    var scrollViewYPos : CGFloat!
    
    var myProductArray = NSMutableArray()
    var openOrdersDict = NSDictionary()
    
    var productScrollView = UIScrollView()
    
    var productNameTF = UITextField()
    var productIDTF = UITextField()
    var descriptionTF = UITextView()
    var reqQunatityTF = UITextField()
    var stockUnitTF = UITextField()
    var priceTF = UITextField()
    var totalPriceTF = UITextField()
    var pricePerStockUnitTF = UITextField()
    var categoryDropDown = UIButton()
    var subCategoryDropDown = UIButton()
    var stockUnitDropDown = UIButton()
    var priceUnitDropDown = UIButton()
    var vendorBtn = UIButton()
    var purchaseBtn = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewYPos = 0
        
        orderIDLbl.text = String((openOrdersDict.value(forKey: "orderId") as? String)!)
        vendorIDLbl.text = openOrdersDict.value(forKey: "vendorName") as? String
        purchaseDateLabel.text=convertDateFormatter(date: openOrdersDict.value(forKey: "purchaseDate") as! String)
        
        get_StockUnitMaster_API_Call()
        get_PriceUnit_API_Call()
        getCategoriesDataFromServer()
        changeEditProductImagesData()
        loadAddProductUI()
        
        // Do any additional setup after loading the view.

    }
    var addProdServiceCntrl = ServiceController()
    var selectedCategoryStr = ""
    func getCategoriesDataFromServer()  {
        
        categoryDataArray.removeAllObjects()
        categoryIDArray.removeAllObjects()
        
        categoryDataArray = NSMutableArray()
        categoryIDArray = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

            
                    let URLString_loginIndividual = Constants.BaseUrl + categoriesUrl
                                
                                    
                        addProdServiceCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:CategoryRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                                    
//                            let adminID = respVo.result![0].name! as String
//                            print(adminID)
                                    
                            self.categoryResult = respVo.result!
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {

                                for categoryItems in self.categoryResult {
                                    
                                    self.categoryIDArray.add(categoryItems._id ?? "")
                                    self.categoryDataArray.add(categoryItems.name ?? "")
                                    
                                }
                                if self.categoryResult.count ?? 0>0
                                {
                                self.selectedCategoryStr=respVo.result![0].name ?? ""
                                }
                                self.getSubCategoriesDataFromServer()
                                        
//                                        viewTobeLoad.modalPresentationStyle = .fullScreen
//                                        self.present(viewTobeLoad, animated: true, completion: nil)
                                
                                print(self.categoryDataArray)
                                print(self.categoryIDArray)

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
    var catSubCatArrPosition : Int!
    var catSubCatIndexPosition : Int!
    var catSubCatTagValue : Int!
    var selectedCategoryID : String!
    var subbuttonTap=String()
    var subbuttonTapPositon=Int()
    
    @IBAction func category_SubCategoryBtnTap(_ sender: UIButton) {
        subbuttonTap="tap"
        
        var productArrayPosition = Int()
        var productTagValue=Int()
        let sstag:String = String(sender.tag)
        if sstag.count>5
        {
         productArrayPosition = sender.tag%100
         productTagValue = sender.tag / 100;
         
        }
        else
        {
         productArrayPosition = sender.tag%10
         productTagValue = sender.tag / 10;
            
        }
        subbuttonTapPositon=productArrayPosition
        catSubCatTagValue = sender.tag as Int
        catSubCatArrPosition = productArrayPosition as Int
        catSubCatIndexPosition = productTagValue as Int
        
        let dict = myProductArray[catSubCatArrPosition] as! NSDictionary
        let productDetailsDict=dict.value(forKey: "productdetails")as! NSDictionary
        let selectedCatStr = productDetailsDict.value(forKey: "category") as! String
        
        print(catSubCatIndexPosition as Any,catSubCatTagValue,catSubCatArrPosition)

        if(catSubCatIndexPosition == 3000){
            
            categoryDataArray = NSMutableArray()
            categoryIDArray = NSMutableArray()
//            categoryResult = [CategoryResult]()
            
            for categoryItems in self.categoryResult {
                
                self.categoryDataArray.add(categoryItems.name ?? "")
                self.categoryIDArray.add(categoryItems._id ?? "")

            }
            
//            self.getCategoriesDataFromServer()
            
//            self.getSubCategoriesDataFromServer()
            
            dropDown.dataSource = categoryDataArray as! [String]//4
                dropDown.anchorView = sender //5
                dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
                dropDown.show() //7
                dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
                  guard let _ = self else { return }
    //              sender.setTitle(item, for: .normal) //9
                    self?.categoryDropDown.setTitle(item as String, for: UIControl.State.normal)
                    let selectedId = self?.categoryIDArray[index]
                    productDetailsDict.setValue(item, forKey: "category")
                    productDetailsDict.setValue(selectedId, forKey: "categoryId")
                    dict.setValue(productDetailsDict, forKey: "productdetails")
                    self?.selectedCategoryStr = item
                    self?.selectedCategoryID = selectedId as? String
                    self?.changesUpdate=true
                    self?.getSubCategoriesDataFromServer()
                    self?.loadAddProductUI()
                }
            
        }else if(catSubCatIndexPosition == 3001){
            
            if selectedCategoryStr == ""{
                self.showAlertWith(title: "Alert", message: "Select Category")
           
            }else{
                
                categoryDataArray = NSMutableArray()
                categoryIDArray = NSMutableArray()
//                categoryResult = [CategoryResult]()
                
//                selectedCategoryID = selectedCatStr
//                self.getSubCategoriesDataFromServer()
                
                for categoryItems in self.subCategoryResult {
                    
                    self.categoryDataArray.add(categoryItems.name ?? "")
                    self.categoryIDArray.add(categoryItems._id ?? "")

                }
                dropDown.dataSource = categoryDataArray as! [String]//4
                    dropDown.anchorView = sender //5
                    dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
                    dropDown.show() //7
                    dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
                      guard let _ = self else { return }
        //              sender.setTitle(item, for: .normal) //9
                        self?.subCategoryDropDown.setTitle(item as String, for: UIControl.State.normal)
                        productDetailsDict.setValue(item, forKey: "subCategory")
                        let selecteSubId = self?.categoryIDArray[index]
                        productDetailsDict.setValue(selecteSubId, forKey: "subCategoryId")
                        dict.setValue(productDetailsDict, forKey: "productdetails")
                        self?.changesUpdate=true
                        self?.loadAddProductUI()
                    }
            }
        }
    }
    func getSubCategoriesDataFromServer()  {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        let newString = selectedCategoryStr.replacingOccurrences(of: " ", with: "%20")
                    let URLString_loginIndividual = Constants.BaseUrl + SubCategoriesUrl + newString
                                    
                            addProdServiceCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:SubCategoryRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                                    
//                            let adminID = (respVo.result![0].name ?? "") as String
//                            print(adminID)
                                    
                            self.subCategoryResult = respVo.result!
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {

                                if self.subbuttonTap=="tap"
{
                                    let productArrayPosition : Int = self.subbuttonTapPositon
                                    let dict = self.myProductArray[productArrayPosition] as! NSDictionary
                                    let productDetailsDict=dict.value(forKey: "productdetails")as! NSDictionary
                                    if self.subCategoryResult.count>0
                                    {
                                    productDetailsDict.setValue(respVo.result![0].name, forKey: "subCategory")
                                    productDetailsDict.setValue(respVo.result![0]._id, forKey: "subCategoryId")
                                    dict.setValue(productDetailsDict, forKey: "productdetails")
                                    }
                                    self.subbuttonTap=""
                                    self.loadAddProductUI()
}
                                print(self.categoryDataArray)
                                print(self.categoryIDArray)

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
    var accountID = ""
    // MARK: Get AddressBook API Call
    func get_PriceUnit_API_Call() {
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let urlStr = Constants.BaseUrl + priceUnitUrl
        
        addProdServiceCntrl.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:PriceUnitRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            DispatchQueue.main.async {
                
                let status = respVo.statusCode
                let message = respVo.status
                
                if status == 200 {
                    
                    if message == "SUCCESS" {
                        if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            self.priceUnitsArr = respVo.result!
                            
//                            for obj in self.priceUnitsArr {
//
//                                self.priceUnitNamesArr.append(obj.priceUnit ?? "")
//
//                            }
//                            let priceStr = self.priceUnitNamesArr[0]
//                            self.priceUnitDropDown.setTitle(priceStr, for: .normal)
                        }
                        else {
                            
                        }
                    }
                    }
                }
                else {
//                    self.view.makeToast(message)
                }
            }
        }) { (error) in
//            self.view.makeToast("app.SomethingWentToWrongAlert".localize())
            print("Oops, your connection seems off... Please try again later")
        }
    }
    // MARK: Get AddressBook API Call
    func get_StockUnitMaster_API_Call() {
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let urlStr = Constants.BaseUrl + vendorGetAllStockUnitUrl + accountID
        
        addProdServiceCntrl.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:StockUnitMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            DispatchQueue.main.async {
                
                let status = respVo.STATUS_CODE
                let message = respVo.STATUS_MSG
                
                if status == 200 {
                    if message == "SUCCESS" {
                        if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            
                            self.stockUnitsArr = respVo.result!
                            
                        }
                        else {
                            
                        }
                    }
                    }
                }
                else {
//                    self.view.makeToast(message)
                }
            }
        }) { (error) in
//            self.view.makeToast("app.SomethingWentToWrongAlert".localize())
            print("Oops, your connection seems off... Please try again later")
        }
    }
    func changeEditProductImagesData(){
        
        print(myProductArray)
        
        for j in 0..<myProductArray.count {
            
            var dict = NSMutableDictionary()
            dict = myProductArray[j] as! NSMutableDictionary
            
            let prodDict = dict.value(forKey: "productdetails") as! NSDictionary

            var prodImgDict = NSMutableDictionary()
            let prodImgArray = NSMutableArray()
            
            for _ in 0..<3 {

                prodImgDict = ["productImage": "","productDisplayImage":"","productLocalImg":""]
                prodImgArray.add(prodImgDict)
            }
            
            prodDict.setValue(prodImgArray, forKey: "productImagesUpdateList")
            dict.setValue(prodDict, forKey: "productdetails")
            
            print(dict)
            
            myProductArray.replaceObject(at:j , with: dict)

        }
        
        
        openOrdersDict.setValue(myProductArray, forKey: "ordersList")
        print(myProductArray)

    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.view.endEditing(true)
        if self.changesUpdate==true
        {
            let alert = UIAlertController(title: "Exit", message: "Are you sure you want to exit? Changes will be lost.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"YES", style: .default, handler: { (_) in
               
                        self.navigationController?.popViewController(animated: true)

                
            }))
            
            alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
         myProductArray = NSMutableArray()
         openOrdersDict = NSDictionary()
        self.navigationController?.popViewController(animated: true)
        }
    }
    
    func loadNewOrderIDView(){
        
        getVendorListDataFromServer()
        
        hiddenBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)
        
        newOrderIDView = UIView()
        newOrderIDView.frame = CGRect(x: 20, y: self.view.frame.size.height/2-(120), width: self.view.frame.size.width - (40), height: 380)
        newOrderIDView.backgroundColor = UIColor.white
        newOrderIDView.layer.cornerRadius = 10
        newOrderIDView.layer.masksToBounds = true
        self.view.addSubview(newOrderIDView)
        
        //Change Pwd Lbl
        
        let changePwdLbl = UILabel()
        changePwdLbl.frame = CGRect(x: 10, y: 5, width: newOrderIDView.frame.size.width - (60), height: 0)
//        changePwdLbl.text = "   Enter Order ID"
        changePwdLbl.textAlignment = NSTextAlignment.center
        changePwdLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        changePwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        newOrderIDView.addSubview(changePwdLbl)
        
        //Cancel Btn
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: newOrderIDView.frame.size.width - 40, y: 5, width: 40, height: 0)
//        cancelBtn.setImage(UIImage.init(named: "cancel"), for: UIControl.State.normal)
        cancelBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        newOrderIDView.addSubview(cancelBtn)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        
        //Seperator Line Lbl
        
        let seperatorLine = UILabel()
        seperatorLine.frame = CGRect(x: 0, y: changePwdLbl.frame.origin.y+changePwdLbl.frame.size.height, width: newOrderIDView.frame.size.width , height: 1)
        seperatorLine.backgroundColor = .white
//            hexStringToUIColor(hex: "f2f2f2")
        newOrderIDView.addSubview(seperatorLine)
        
        //Current Pwd Lbl

        let orderIDLbl = UILabel()
        orderIDLbl.frame = CGRect(x: 10, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: newOrderIDView.frame.size.width - (20), height: 20)
        orderIDLbl.text = " Order ID"
        orderIDLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        orderIDLbl.textColor = hexStringToUIColor(hex: "232c51")
        newOrderIDView.addSubview(orderIDLbl)

        //Current Pwd TF

        orderIDTF.frame = CGRect(x: 10, y: orderIDLbl.frame.origin.y+orderIDLbl.frame.size.height+5, width: newOrderIDView.frame.size.width - (20), height: 45)
        orderIDTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        orderIDTF.textColor = hexStringToUIColor(hex: "232c51")
        newOrderIDView.addSubview(orderIDTF)
        
        orderIDTF.text = String((openOrdersDict.value(forKey: "orderId") as? String)!)

        orderIDTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        orderIDTF.layer.cornerRadius = 3
        orderIDTF.clipsToBounds = true

        let currentPwdPaddingView = UIView()
        currentPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: orderIDTF.frame.size.height)
        orderIDTF.leftView = currentPwdPaddingView
        orderIDTF.leftViewMode = UITextField.ViewMode.always
        
        //Purchase Date Pwd Lbl

        let purchaseDateLbl = UILabel()
        purchaseDateLbl.frame = CGRect(x: 10, y: orderIDTF.frame.origin.y+orderIDTF.frame.size.height+15, width: newOrderIDView.frame.size.width - (20), height: 20)
        purchaseDateLbl.text = "Purchase Date"
        purchaseDateLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        purchaseDateLbl.textColor = hexStringToUIColor(hex: "232c51")
        newOrderIDView.addSubview(purchaseDateLbl)

        //Current Pwd TF
        
       let ddate=convertDateFormatter(date: String((openOrdersDict.value(forKey: "purchaseDate") as? String)!))
        purchaseBtn = UIButton()
        purchaseBtn.frame = CGRect(x: 10, y: purchaseDateLbl.frame.origin.y+purchaseDateLbl.frame.size.height+5, width: newOrderIDView.frame.size.width - (20), height: 45)
        purchaseBtn.setTitle(ddate, for: UIControl.State.normal)
        purchaseBtn.contentHorizontalAlignment = .left
        purchaseBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        purchaseBtn.setTitleColor(hexStringToUIColor(hex: "000000"), for: UIControl.State.normal)
        purchaseBtn.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        purchaseBtn.addTarget(self, action: #selector(datePickerBtnTap), for: .touchUpInside)
        
        purchaseBtn.layer.cornerRadius = 5
        let purchaseImage = UIButton()
        purchaseImage.frame = CGRect(x: purchaseBtn.frame.size.width - (20), y: purchaseBtn.frame.origin.y+6, width: 25, height: 25)
        purchaseImage.setImage(UIImage.init(named: "calenderlatest"), for: UIControl.State.normal)
        purchaseImage.addTarget(self, action: #selector(datePickerBtnTap), for: .touchUpInside)
        newOrderIDView.addSubview(purchaseBtn)
        newOrderIDView.addSubview(purchaseImage)
        
        
        //Vendor Lbl

        let vendorLbl = UILabel()
        vendorLbl.frame = CGRect(x: 10, y: purchaseBtn.frame.origin.y+purchaseBtn.frame.size.height+15, width: newOrderIDView.frame.size.width - (20), height: 20)
        vendorLbl.text = " Vendor"
        vendorLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        vendorLbl.textColor = hexStringToUIColor(hex: "232c51")
        newOrderIDView.addSubview(vendorLbl)

        //Vendor TF

        vendorBtn = UIButton()
        
        vendorBtn.frame = CGRect(x: 10, y: vendorLbl.frame.origin.y+vendorLbl.frame.size.height+5, width: newOrderIDView.frame.size.width - (20), height: 45)
        vendorBtn.setTitle(String((openOrdersDict.value(forKey: "vendorName") as? String)!), for: UIControl.State.normal)
        vendorBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        vendorBtn.setTitleColor(hexStringToUIColor(hex: "000000"), for: UIControl.State.normal)
        vendorBtn.contentHorizontalAlignment = .left
        vendorBtn.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        vendorBtn.addTarget(self, action: #selector(vendor_NameBtnTap), for: .touchUpInside)
        
        vendorBtn.layer.cornerRadius = 5
        let vendorNameImage = UIButton()
        vendorNameImage.frame = CGRect(x: vendorBtn.frame.size.width - (20), y: vendorBtn.frame.origin.y+6, width: 25, height: 25)
        vendorNameImage.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
        vendorNameImage.addTarget(self, action: #selector(vendor_NameBtnTap), for: .touchUpInside)
        newOrderIDView.addSubview(vendorBtn)
        newOrderIDView.addSubview(vendorNameImage)
        
        let addVendorMastersBtn = UIButton()
        addVendorMastersBtn.frame = CGRect(x: 10, y: vendorBtn.frame.origin.y+vendorBtn.frame.size.height+5, width: newOrderIDView.frame.size.width/2 - (20), height: 20)
        newOrderIDView.addSubview(addVendorMastersBtn)
        
        addVendorMastersBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        addVendorMastersBtn.addTarget(self, action: #selector(onVendorMastersBtnTap), for: .touchUpInside)
        
        let attrs = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

        let attributedString = NSMutableAttributedString(string:"")

        let buttonTitleStr = NSMutableAttributedString(string:"Vendor Masterslist", attributes:attrs)
        attributedString.append(buttonTitleStr)
        addVendorMastersBtn.setAttributedTitle(attributedString, for: .normal)
        
        let updateBtn = UIButton()
        updateBtn.frame = CGRect(x:newOrderIDView.frame.size.width/2 - (10), y: vendorBtn.frame.origin.y+vendorBtn.frame.size.height+40, width: 130, height: 40)
        updateBtn.setTitle("Cancel", for: UIControl.State.normal)
        updateBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        updateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        updateBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
        updateBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        
        updateBtn.layer.cornerRadius = 5
        newOrderIDView.addSubview(updateBtn)
        
        
        let okBtn = UIButton()
        okBtn.frame = CGRect(x:40, y: vendorBtn.frame.origin.y+vendorBtn.frame.size.height+40, width: 100, height: 40)
        okBtn.setTitle("Ok", for: UIControl.State.normal)
        okBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        okBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        okBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
        okBtn.addTarget(self, action: #selector(orderIDSubmitBtnTap), for: .touchUpInside)
        
        okBtn.layer.cornerRadius = 5
        newOrderIDView.addSubview(okBtn)

    }
    
    @IBAction func vendor_NameBtnTap(_ sender: UIButton) {
        
        var productArrayPosition = Int()
        var productTagValue=Int()
        let sstag:String = String(sender.tag)
        if sstag.count>5
        {
         productArrayPosition = sender.tag%100
         productTagValue = sender.tag / 100;
         
        }
        else
        {
         productArrayPosition = sender.tag%10
         productTagValue = sender.tag / 10;
            
        }
        var vendorNameListArr = [String]()
//        var dict = NSMutableDictionary()
//        dict = myProductArray[productArrayPosition] as? NSMutableDictionary ?? NSMutableDictionary()
        for obj in vendorListResult {
            
            vendorNameListArr.append(obj.vendorName ?? "")
            vendorMastersIdsArr.append(obj._id ?? "")
        }
        
        dropDown.dataSource = vendorNameListArr//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.selectedVendorId = (self?.vendorMastersIdsArr[index])!
                self?.vendorBtn.setTitle(item as String, for: UIControl.State.normal)
                self?.vendorNameStr = item
                self?.openOrdersDict.setValue(item, forKey: "vendorName")
                self?.openOrdersDict.setValue(self?.selectedVendorId, forKey: "vendorId")
                self?.newOrderIDView.removeFromSuperview()
                self?.changesUpdate=true
                self?.loadNewOrderIDView()
                
            }
    }
    var userDefaults=UserDefaults.standard
    @objc func onVendorMastersBtnTap(sender: UIButton){
        if userDefaults.bool(forKey: "vendorManStatus")==false
        {
            self.showAlertWith(title: "Alert", message: "You are not authorized to access this module")
        }
        else
        {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyBoard.instantiateViewController(withIdentifier: "VendorListVC") as! VendorListingViewController
                    VC.modalPresentationStyle = .fullScreen
                    VC.isAddProd = "1"
                    self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @objc func orderIDSubmitBtnTap(_ sender:UIButton){
        
        if(orderIDTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Please enter order ID")
       
        }else{
            
            orderIDLbl.text = orderIDTF.text
            vendorIDLbl.text=vendorBtn.currentTitle
            purchaseDateLabel.text=purchaseBtn.currentTitle
            openOrdersDict.setValue(orderIDTF.text, forKey: "orderId")
            openOrdersDict.setValue(vendorBtn.currentTitle, forKey: "vendorName")
            openOrdersDict.setValue(purchaseBtn.currentTitle, forKey: "purchaseDate")
            self.changesUpdate=true
            hiddenBtn.removeFromSuperview()
            newOrderIDView.removeFromSuperview()
            
        }
    }
    
    @objc func cancelBtnTap(_ sender:UIButton){
        hiddenBtn.removeFromSuperview()
        newOrderIDView.removeFromSuperview()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func removeProductImage()  {
        
        for i in 0..<myProductArray.count {

            let dict = myProductArray[i] as! NSDictionary
            
            let prodDict = dict.value(forKey: "productdetails") as! NSDictionary
            
            var prodArray = NSMutableArray()
            
            prodArray = prodDict.value(forKey: "productImagesUpdateList") as! NSMutableArray
            
            for j in 0..<prodArray.count {

                var prodDict = NSMutableDictionary()
                prodDict = prodArray[j] as! NSMutableDictionary
                
                prodDict .removeObject(forKey: "productDisplayImage")
                prodArray.replaceObject(at: j, with: prodDict)
                
            }
            
            prodDict.setValue(prodArray, forKey: "productImagesUpdateList")
            dict.setValue(prodDict, forKey: "productdetails")
            
            myProductArray.replaceObject(at: i, with: dict)
            openOrdersDict.setValue(myProductArray, forKey: "ordersList")
            
        }
    }
    
    func showSucessMsg(message:String)  {
        
                let alertController = UIAlertController(title: "Success", message:message , preferredStyle: .alert)
                //to change font of title and message.
                let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
                let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Success", attributes: titleFont)
                let messageAttrString = NSMutableAttributedString(string: "Product added successfully", attributes: messageFont)
                alertController.setValue(titleAttrString, forKey: "attributedTitle")
                alertController.setValue(messageAttrString, forKey: "attributedMessage")
                
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                          let VC = storyBoard.instantiateViewController(withIdentifier: "UpdateOpenOrderViewController") as! UpdateOpenOrderViewController
                          VC.modalPresentationStyle = .fullScreen
//                          self.present(VC, animated: true, completion: nil)
                    self.navigationController?.pushViewController(VC, animated: true)

                })
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)

    }
    @objc func stockUnitMastersBtnTap(sender: UIButton){
        if userDefaults.bool(forKey: "vendorManStatus")==false
        {
            self.showAlertWith(title: "Alert", message: "You are not authorized to access this module")
        }
        else
        {
        let storyBoard = UIStoryboard(name: "Vendor", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "StockUnitMasterVC") as! StockUnitMasterVC
        VC.modalPresentationStyle = .fullScreen
//        VC.isAddProd = "1"
        self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    let dropDown = DropDown()
    var stockUnitsArr = [StockUnitMasterResultVo]()
    var priceUnitsArr = [PriceUnitResultVo]()
    var stockUnitIdsArr = [String]()
    var selectedStockId = ""
    var storageLocationIdsArr = [String]()
    var storageLocationParentArr = [String]()
    var selectedStorageId = ""
    var selectedStorageParentId = ""
    var storageLocation1IdsArr = [String]()
    var storageLocation1ParentArr = [String]()
    var selectedStorage1Id = ""
    var selectedStorage1ParentId = ""
    var storageLocation2IdsArr = [String]()
    var storageLocation2ParentArr = [String]()
    var selectedStorage2Id = ""
    var selectedStorage2ParentId = ""
    var vendorMastersIdsArr = [String]()
    var selectedVendorId = ""
    var vendorNameStr = ""
    var dateStr = ""
    var categoryResult = [CategoryResult]()
    var subCategoryResult = [SubCategoryResult]()
    
    @IBAction func stock_UnitBtnTap(_ sender: UIButton) {
        var productArrayPosition = Int()
        var productTagValue=Int()
        let sstag:String = String(sender.tag)
        if sstag.count>5
        {
         productArrayPosition = sender.tag%100
         productTagValue = sender.tag / 100;
         
        }
        else
        {
         productArrayPosition = sender.tag%10
         productTagValue = sender.tag / 10;
            
        }
        var dict = NSMutableDictionary()
        dict = myProductArray[productArrayPosition] as! NSMutableDictionary
        let stockDetailsDict=dict.value(forKey: "stockUnitDetails")as! NSArray
        var stockListArr = [String]()
        
        for obj in stockUnitsArr{
            stockListArr.append(obj.stockUnitName ?? "")
            stockUnitIdsArr.append(obj._id ?? "")
        }
        
        dropDown.dataSource = stockListArr//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.stockUnitDropDown.setTitle(item as String, for: UIControl.State.normal)
                self?.selectedStockId = (self?.stockUnitIdsArr[index])!
               // self?.stockUnitTF.text = item
                if stockDetailsDict.count>0
                {
                (stockDetailsDict[0] as AnyObject).setValue(item, forKey: "stockUnitName")
                (stockDetailsDict[0] as AnyObject).setValue(self?.selectedStockId, forKey: "_id")
                }
                dict.setValue(stockDetailsDict, forKey: "stockUnitDetails")
                self?.changesUpdate=true
                self?.loadAddProductUI()
            }
    }
    @objc func onClickWarnButton()
    {
        self.showAlertWith(title: "Alert", message: "Required")
    }
    func loadAddProductUI() {
        
        print(myProductArray)
        
        productScrollView.removeFromSuperview()
        
        productScrollView.frame = CGRect(x: 0, y: 160, width: self.view.frame.size.width, height: self.view.frame.size.height - ((topHeaderView.frame.size.height)+180))
        productScrollView.backgroundColor = hexStringToUIColor(hex: "e4ecf9")
        self.view.addSubview(productScrollView)
        
        productScrollView.delegate = self
        
        var yValue = CGFloat()
        yValue = 15
        
        for i in 1...myProductArray.count {
            
             productNameTF = UITextField()
             productIDTF = UITextField()
             descriptionTF = UITextView()
             reqQunatityTF = UITextField()
             stockUnitTF = UITextField()
             priceTF = UITextField()
             pricePerStockUnitTF = UITextField()
            totalPriceTF = UITextField()
            
            priceTF.keyboardType = UIKeyboardType.decimalPad
            reqQunatityTF.keyboardType = UIKeyboardType.decimalPad
            pricePerStockUnitTF.keyboardType = UIKeyboardType.decimalPad
           

            let productView = UIView()
            productView.backgroundColor = UIColor.white
            productView.frame = CGRect(x: 15, y: yValue, width: productScrollView.frame.size.width - 30, height: 790)
            productScrollView.addSubview(productView)
            
            productView.layer.cornerRadius = 10
            productView.layer.masksToBounds = true
            
            let dataDict = myProductArray.object(at: i-1) as! NSDictionary
            let prodDetailsDict = dataDict.value(forKey: "productdetails") as!  NSDictionary
           
            let stockUnitDetailsDict = dataDict.value(forKey: "stockUnitDetails") as!  NSArray
            
            //Product Lbl
            
            let Str : String = String(i)
            
            let productLbl = UILabel()
            productLbl.frame = CGRect(x: 10, y: 10, width: productView.frame.size.width - (80), height: 20)
            productLbl.text = "Product " + Str
            productLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
            productLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(productLbl)
            
            //Seperator Line Lbl
            
            let seperatorLine = UILabel()
            seperatorLine.frame = CGRect(x: 10, y: productLbl.frame.origin.y+productLbl.frame.size.height+10, width: productView.frame.size.width - (20), height: 1)
            seperatorLine.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
            productView.addSubview(seperatorLine)
            
            var addProdXValue = CGFloat()
            addProdXValue = 10
            
            var addBtnYValue = CGFloat()
            addBtnYValue = seperatorLine.frame.origin.y+seperatorLine.frame.size.height+75
            
//            let prodArray = prodDetailsDict.value(forKey: "productImages") as! NSMutableArray
            
            let prodUpdateArray = prodDetailsDict.value(forKey: "productImagesUpdateList") as! NSMutableArray
            
//            productImages =                 (
//                                               {
//                               0 = "5fdc2a43313a1928d30d1b19_0";
//                               1 = "5fdc2a43313a1928d30d1b19_1";
//                               2 = "5fdc2a43313a1928d30d1b19_2";
//                           }
//                       );
            
            let prodImgArray = prodDetailsDict.value(forKey: "productImages") as! NSArray
            
            let prodImgDict = prodImgArray.object(at: 0) as! NSDictionary
            
            for j in 1...prodUpdateArray.count {
                
                let productDict = prodUpdateArray.object(at: j-1) as! NSMutableDictionary
                let isProdLocalImg = productDict.value(forKey: "productLocalImg") as! NSString

                //Add Btn

                let addBtn = UIButton()
                addBtn.frame = CGRect(x: addProdXValue, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: 60, height: 60)
                addBtn.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
                
                addBtn.setImage(UIImage.init(named: "plus"), for: UIControl.State.normal)
                addBtn.layer.cornerRadius = 10
                
                addBtn.layer.masksToBounds = true
                productView.addSubview(addBtn)

                addBtn.imageEdgeInsets = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
                
                if(isProdLocalImg == "1"){
                    
                    let prodDisplayImg = productDict.value(forKey: "productDisplayImage") as? UIImage

                       addBtn.setImage(prodDisplayImg, for: .normal)
                            

                    
                }else{
                    
                    let keyValue = String(j-1)
                    
                    let imageStr = prodImgDict.value(forKey: keyValue) as? String ?? ""

                    if !imageStr.isEmpty {

                        let imgUrl:String = imageStr

                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")

                        let imggg = Constants.BaseImageUrl + trimStr

                        let url = URL.init(string: imggg)

                     addBtn.sd_setImage(with: url, for: .normal, completed: nil)

                      }

                    else {

                        addBtn.setImage(UIImage.init(named: "no_image"), for: .normal)

                    }
                }
                
                addBtn.addTarget(self, action: #selector(productImgBtnTap), for: .touchUpInside)
                addProdXValue = addProdXValue + addBtn.frame.size.width+10
                
                let tagValue:Int = j-1
                let StringTagValue = String(tagValue) //Converting j value to tag, so that we can get add product/image  position
                
                let iProdTag = i-1
                let iProdStrValue = String(iProdTag) //Converting i value to tag, so that we can get product insertion position
                
                let mTagValue = 2000 + tagValue //To identify which product clicked
                let mProdStrValue = String(mTagValue)
                
                let idTag : String = mProdStrValue + StringTagValue + iProdStrValue //Appedning all values, first tag value, J Value - product add image position and i Value - product insertion position
                let finalProdTagValue: Int? = Int(idTag)

                addBtn.tag = finalProdTagValue!
                addBtn.contentMode = .scaleToFill
            }

            //Seperator Line 1 Lbl
            
            let seperatorLine1 = UILabel()
            seperatorLine1.frame = CGRect(x: 10, y: addBtnYValue+15, width: productView.frame.size.width - (20), height: 1)
            seperatorLine1.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
            productView.addSubview(seperatorLine1)
            
            //Product ID Lbl
            
            let productIDLbl = UILabel()
            productIDLbl.frame = CGRect(x: 10, y: seperatorLine1.frame.origin.y+seperatorLine1.frame.size.height+15, width: productView.frame.size.width - (20), height: 20)
            productIDLbl.text = "Product ID :"
            productIDLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            productIDLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(productIDLbl)
            
            //Product TF

            productIDTF.frame = CGRect(x: 10, y: productIDLbl.frame.origin.y+productIDLbl.frame.size.height+5, width: productView.frame.size.width - (20), height: 40)
//            productIDTF.text = "676867686"
            productIDTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            productIDTF.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(productIDTF)
            
            productIDTF.layer.borderWidth = 1
            productIDTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            productIDTF.layer.cornerRadius = 3
            productIDTF.clipsToBounds = true
            
            productIDTF.tag = 1000 + i

            let productPaddingView = UIView()
            productPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: productIDTF.frame.size.height)
            productIDTF.leftView = productPaddingView
            productIDTF.leftViewMode = UITextField.ViewMode.always
            
            //Product Name Lbl
            
            let productNameLbl = UILabel()
            productNameLbl.frame = CGRect(x: 10, y: productIDTF.frame.origin.y+productIDTF.frame.size.height+15, width: productView.frame.size.width - (20), height: 20)
            productNameLbl.text = "Product Name :"
            productNameLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            productNameLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(productNameLbl)
            
            //Product Name TF

            productNameTF.frame = CGRect(x: 10, y: productNameLbl.frame.origin.y+productNameLbl.frame.size.height+5, width: productView.frame.size.width - (20), height: 40)
//            productNameTF.text = "fdfdsfdsfd"
            productNameTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            productNameTF.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(productNameTF)
            if prodDetailsDict.value(forKey: "productNameWarn") as? Bool==true
            {
            let productNameAlertButton = UIButton()
            productNameAlertButton.frame = CGRect(x: productNameTF.frame.size.width - 30, y: productNameTF.frame.origin.y+5, width: 30, height: 30)
            productNameAlertButton.setImage(UIImage(named: "warn.png"), for: .normal)
            productNameAlertButton.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
            productView.addSubview(productNameAlertButton)
            }
            productNameTF.layer.borderWidth = 1
            productNameTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            productNameTF.layer.cornerRadius = 3
            productNameTF.clipsToBounds = true

            let productNamePaddingView = UIView()
            productNamePaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: productNameTF.frame.size.height)
            productNameTF.leftView = productNamePaddingView
            productNameTF.leftViewMode = UITextField.ViewMode.always

            //Description Lbl
            
            let descriptionLbl = UILabel()
            descriptionLbl.frame = CGRect(x: 10, y: productNameTF.frame.origin.y+productNameTF.frame.size.height+15, width: productView.frame.size.width - (20), height: 20)
            descriptionLbl.text = "Description :"
            descriptionLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            descriptionLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(descriptionLbl)
            
            //Description Text View

            descriptionTF.frame = CGRect(x: 10, y: descriptionLbl.frame.origin.y+descriptionLbl.frame.size.height+5, width: productView.frame.size.width - (20), height: 80)
//            descriptionTF.text = "fdfdsfdsfd"
            descriptionTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            descriptionTF.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(descriptionTF)
            
            descriptionTF.layer.borderWidth = 1
            descriptionTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            descriptionTF.layer.cornerRadius = 3
            descriptionTF.clipsToBounds = true

            //Req Quantity Lbl
            
            let orderedQuantityLbl = UILabel()
            orderedQuantityLbl.frame = CGRect(x: 10, y: descriptionTF.frame.origin.y+descriptionTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            orderedQuantityLbl.text = "Ordered Qty"
            orderedQuantityLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            orderedQuantityLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(orderedQuantityLbl)
            
            //Product Name TF

            reqQunatityTF.frame = CGRect(x: 10, y: orderedQuantityLbl.frame.origin.y+orderedQuantityLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
//            reqQunatityTF.text = "fdfdsfdsfd"
            reqQunatityTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            reqQunatityTF.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(reqQunatityTF)
            if prodDetailsDict.value(forKey: "stockQuantityWarn") as? Bool==true
            {
            let reqQunatityAlertButton = UIButton()
                reqQunatityAlertButton.frame = CGRect(x: reqQunatityTF.frame.size.width - 30, y: reqQunatityTF.frame.origin.y+5, width: 30, height: 30)
                reqQunatityAlertButton.setImage(UIImage(named: "warn.png"), for: .normal)
                reqQunatityAlertButton.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
            productView.addSubview(reqQunatityAlertButton)
            }
            reqQunatityTF.layer.borderWidth = 1
            reqQunatityTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            reqQunatityTF.layer.cornerRadius = 3
            reqQunatityTF.clipsToBounds = true

            let stockQuanPaddingView = UIView()
            stockQuanPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: reqQunatityTF.frame.size.height)
            reqQunatityTF.leftView = stockQuanPaddingView
            reqQunatityTF.leftViewMode = UITextField.ViewMode.always

            //Stock unit Lbl
            
            let stockunitLbl = UILabel()
            stockunitLbl.frame = CGRect(x: productView.frame.size.width/2+10, y: descriptionTF.frame.origin.y+descriptionTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            stockunitLbl.text = "Stock Unit"
            stockunitLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            stockunitLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(stockunitLbl)
            
            //Stock Unit TF

            stockUnitDropDown = UIButton()
            stockUnitDropDown.frame = CGRect(x: productView.frame.size.width/2+10, y: stockunitLbl.frame.origin.y+stockunitLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
            stockUnitDropDown.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            stockUnitDropDown.layer.borderWidth = 1
            stockUnitDropDown.layer.cornerRadius = 3
            stockUnitDropDown.layer.masksToBounds = true
            let stockUnitImage = UIButton()
            stockUnitImage.frame = CGRect(x: productView.frame.size.width - (40), y: stockUnitDropDown.frame.origin.y+6, width: 25, height: 25)
            stockUnitImage.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
            productView.addSubview(stockUnitImage)
            productView.addSubview(stockUnitDropDown)
            
            
            
            stockUnitDropDown.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            stockUnitDropDown.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            
            stockUnitDropDown.addTarget(self, action: #selector(stock_UnitBtnTap), for: .touchUpInside)
            stockUnitDropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            
            
            let stockUnitMasterListBtn = UIButton()
            stockUnitMasterListBtn.frame = CGRect(x: productView.frame.size.width/2+10, y: stockUnitDropDown.frame.origin.y+stockUnitDropDown.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 20)
            productView.addSubview(stockUnitMasterListBtn)
            
            stockUnitMasterListBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            
            stockUnitMasterListBtn.addTarget(self, action: #selector(stockUnitMastersBtnTap), for: .touchUpInside)
            
            let attrs = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
                NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

            let attributedString = NSMutableAttributedString(string:"")
            
            let buttonTitleStr = NSMutableAttributedString(string:"Stock unit masterlist", attributes:attrs)
            attributedString.append(buttonTitleStr)
            stockUnitMasterListBtn.setAttributedTitle(attributedString, for: .normal)

            //priceUnit Lbl
            
            let priceUnitBtn = UIButton()
            priceUnitBtn.frame = CGRect(x:10, y: reqQunatityTF.frame.origin.y+reqQunatityTF.frame.size.height+30, width: productView.frame.size.width/2 - (20), height: 20)
            priceUnitBtn.setTitle("Price Unit:", for: UIControl.State.normal)
            priceUnitBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            priceUnitBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            productView.addSubview(priceUnitBtn)
            

            priceUnitDropDown = UIButton()
            priceUnitDropDown.frame = CGRect(x: 10, y: priceUnitBtn.frame.origin.y+priceUnitBtn.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
            priceUnitDropDown.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            priceUnitDropDown.layer.borderWidth = 1
            priceUnitDropDown.layer.cornerRadius = 3
            priceUnitDropDown.layer.masksToBounds = true
            let priceUnitImage = UIButton()
            priceUnitImage.frame = CGRect(x: priceUnitDropDown.frame.size.width - (20), y: priceUnitDropDown.frame.origin.y+6, width: 25, height: 25)
            priceUnitImage.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
            productView.addSubview(priceUnitImage)
            productView.addSubview(priceUnitDropDown)
            
            priceUnitDropDown.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            priceUnitDropDown.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            
            priceUnitDropDown.addTarget(self, action: #selector(price_UnitBtnTap), for: .touchUpInside)
            priceUnitDropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
            let pricePerStockUnitLbl = UILabel()
            pricePerStockUnitLbl.frame = CGRect(x: productView.frame.size.width/2+10, y: reqQunatityTF.frame.origin.y+reqQunatityTF.frame.size.height+30, width: productView.frame.size.width/2 - (20), height: 20)
            pricePerStockUnitLbl.text = "Price Per Stock Unit :"
            pricePerStockUnitLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            pricePerStockUnitLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(pricePerStockUnitLbl)
            
            //pricePerStockUnitTF

            pricePerStockUnitTF.frame = CGRect(x:productView.frame.size.width/2+10, y: pricePerStockUnitLbl.frame.origin.y+pricePerStockUnitLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
//            priceTF.text = "87797"
            pricePerStockUnitTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            pricePerStockUnitTF.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(pricePerStockUnitTF)
            if prodDetailsDict.value(forKey: "unitPriceWarn") as? Bool==true
            {
            let pricePerStockAlertButton = UIButton()
            pricePerStockAlertButton.frame = CGRect(x: productView.frame.size.width/2+10 + pricePerStockUnitTF.frame.size.width - 30, y: pricePerStockUnitTF.frame.origin.y+5, width: 30, height: 30)
            pricePerStockAlertButton.setImage(UIImage(named: "warn.png"), for: .normal)
            pricePerStockAlertButton.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
            productView.addSubview(pricePerStockAlertButton)
            }
            pricePerStockUnitTF.layer.borderWidth = 1
            pricePerStockUnitTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            pricePerStockUnitTF.layer.cornerRadius = 3
            pricePerStockUnitTF.clipsToBounds = true

            let pricePerStockUnitPaddingView = UIView()
            pricePerStockUnitPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: pricePerStockUnitTF.frame.size.height)
            pricePerStockUnitTF.leftView = pricePerStockUnitPaddingView
            pricePerStockUnitTF.leftViewMode = UITextField.ViewMode.always
            
            //Total Price Lbl
            
            let totalPriceLbl = UILabel()
            totalPriceLbl.frame = CGRect(x: 10, y: priceUnitDropDown.frame.origin.y+priceUnitDropDown.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            totalPriceLbl.text = "Total Price :"
            totalPriceLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            totalPriceLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(totalPriceLbl)
            
            //Total Price TF

            totalPriceTF.frame = CGRect(x: 10, y: totalPriceLbl.frame.origin.y+totalPriceLbl.frame.size.height+5, width: productView.frame.size.width - (20), height: 40)
//            stockQuantityTF.text = "fdfdsfdsfd"
            totalPriceTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            totalPriceTF.textColor = hexStringToUIColor(hex: "232c51")
            totalPriceTF.backgroundColor = .lightGray
            totalPriceTF.isUserInteractionEnabled = false
            productView.addSubview(totalPriceTF)
            
            totalPriceTF.layer.borderWidth = 1
            totalPriceTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            totalPriceTF.layer.cornerRadius = 3
            totalPriceTF.clipsToBounds = true

            let totalPricePaddingView = UIView()
            totalPricePaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: totalPriceTF.frame.size.height)
            totalPriceTF.leftView = totalPricePaddingView
            totalPriceTF.leftViewMode = UITextField.ViewMode.always
//            //Price Lbl
//            
//            let priceLbl = UILabel()
//            priceLbl.frame = CGRect(x: 10, y: priceUnitDropDown.frame.origin.y+priceUnitDropDown.frame.size.height+15, width: productView.frame.size.width - (20), height: 20)
//            priceLbl.text = "Total Price :"
//            priceLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
//            priceLbl.textColor = hexStringToUIColor(hex: "232c51")
//            productView.addSubview(priceLbl)
//            
//            //Price TF
//
//            priceTF.frame = CGRect(x:10, y: priceLbl.frame.origin.y+priceLbl.frame.size.height+5, width: productView.frame.size.width - (20), height: 40)
////            priceTF.text = "87797"
//            priceTF.font = UIFont.init(name: kAppFontMedium, size: 13)
//            priceTF.textColor = hexStringToUIColor(hex: "232c51")
//            priceTF.isUserInteractionEnabled = false
//            priceTF.backgroundColor = .lightGray
//            productView.addSubview(priceTF)
//            
//            priceTF.layer.borderWidth = 1
//            priceTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
//            priceTF.layer.cornerRadius = 3
//            priceTF.clipsToBounds = true
//
//            let pricePaddingView = UIView()
//            pricePaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: priceTF.frame.size.height)
//            priceTF.leftView = pricePaddingView
//            priceTF.leftViewMode = UITextField.ViewMode.always
//        
//
            priceUnitDropDown.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.left
     
            stockUnitDropDown.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.left
            
            //Category Lbl

            let categoryBtn = UIButton()
            categoryBtn.frame = CGRect(x:10, y: totalPriceTF.frame.origin.y+totalPriceTF.frame.size.height+15, width: 100, height: 20)
            categoryBtn.setTitle("Category", for: UIControl.State.normal)
            categoryBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            categoryBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            productView.addSubview(categoryBtn)
            
    
            
            //sub Category Lbl

            let subCategoryBtn = UIButton()
            subCategoryBtn.frame = CGRect(x:productView.frame.size.width / 2 + 10, y: totalPriceTF.frame.origin.y+totalPriceTF.frame.size.height+15, width: 100, height: 20)
            subCategoryBtn.setTitle("Sub Category", for: UIControl.State.normal)
            subCategoryBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            subCategoryBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            productView.addSubview(subCategoryBtn)

            //Category Drop Down
            
             categoryDropDown = UIButton()
            categoryDropDown.frame = CGRect(x: 10, y: categoryBtn.frame.origin.y+categoryBtn.frame.size.height+5, width: productView.frame.size.width/2 - 20 , height: 40)
            categoryDropDown.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            categoryDropDown.layer.borderWidth = 1
            categoryDropDown.layer.cornerRadius = 3
            categoryDropDown.layer.masksToBounds = true
            let categoryImage = UIButton()
            categoryImage.frame = CGRect(x: categoryDropDown.frame.size.width - (20), y: categoryDropDown.frame.origin.y+6, width: 25, height: 25)
            categoryImage.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
            productView.addSubview(categoryImage)
            productView.addSubview(categoryDropDown)
            
            categoryDropDown.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            categoryDropDown.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            
            categoryDropDown.addTarget(self, action: #selector(category_SubCategoryBtnTap), for: .touchUpInside)
            categoryDropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
            
            //Sub Category Drop Down
            
            subCategoryDropDown = UIButton()
            subCategoryDropDown.frame = CGRect(x: productView.frame.size.width/2 + 10, y: subCategoryBtn.frame.origin.y+subCategoryBtn.frame.size.height+5, width: productView.frame.size.width/2 - 20 , height: 40)
            subCategoryDropDown.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            subCategoryDropDown.layer.borderWidth = 1
            subCategoryDropDown.layer.cornerRadius = 3
            subCategoryDropDown.layer.masksToBounds = true
            let subCategoryImage = UIButton()
            subCategoryImage.frame = CGRect(x: productView.frame.size.width - (40), y: subCategoryDropDown.frame.origin.y+6, width: 25, height: 25)
            subCategoryImage.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
            productView.addSubview(subCategoryImage)
            productView.addSubview(subCategoryDropDown)
            
            subCategoryDropDown.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            subCategoryDropDown.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            
            subCategoryDropDown.addTarget(self, action: #selector(category_SubCategoryBtnTap), for: .touchUpInside)
            subCategoryDropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
            categoryDropDown.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.left
            subCategoryDropDown.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.left
            
          
            yValue = productView.frame.size.height + yValue + 10
            
            productIDTF.delegate = self
            productNameTF.delegate = self
            descriptionTF.delegate = self
            reqQunatityTF.delegate = self
            stockUnitTF.delegate = self
            priceTF.delegate = self
            pricePerStockUnitTF.delegate = self
            totalPriceTF.delegate = self

            let tagValue:Int = i-1
            let StringTagValue = String(tagValue)
            
            let idTag : String = "1000" + StringTagValue
            let idTagValue: Int? = Int(idTag)
            
            let prodNameTag : String = "1001" + StringTagValue
            let prodNameTagValue: Int? = Int(prodNameTag)

            let descriptionTag : String = "1002" + StringTagValue
            let descriptionTagValue: Int? = Int(descriptionTag)

            let reqQuanTag : String = "1003" + StringTagValue
            let reqQuanTagValue: Int? = Int(reqQuanTag)

            let stockUnitTag : String = "1004" + StringTagValue
            let stockUnitTagValue: Int? = Int(stockUnitTag)

            let prefVendorTag : String = "1005" + StringTagValue
            let prefVendorTagValue: Int? = Int(prefVendorTag)
            
            let priceTag : String = "1006" + StringTagValue
            let priceTagValue: Int? = Int(priceTag)
            
            let pricePerStockUnitTag : String = "2001" + StringTagValue
            let pricePerStockUnitValue: Int? = Int(pricePerStockUnitTag)
            
            let totalPriceTag : String = "2002" + StringTagValue
            let totalPriceTagValue: Int? = Int(totalPriceTag)
            
            let plannedPurchaseTag : String = "1007" + StringTagValue
            let plannedPurchaseTagValue: Int? = Int(plannedPurchaseTag)
            let catTag : String = "3000" + StringTagValue
            let catTagValue : Int? = Int(catTag)

            let subCatTag : String = "3001" + StringTagValue
            let subCatTagValue : Int? = Int(subCatTag)
            let priceUnitTag : String = "3005" + StringTagValue
            let priceUnitTagValue : Int? = Int(priceUnitTag)
//            let saveForLaterTag : String = "1008" + StringTagValue
//            let saveForLaterTagValue: Int? = Int(saveForLaterTag)

            
            productIDTF.text = (prodDetailsDict.value(forKey: "productUniqueNumber") as? String)
            productNameTF.text = (prodDetailsDict.value(forKey: "productName") as? String)
            descriptionTF.text = (prodDetailsDict.value(forKey: "description") as? String)
            var stockUnit=String()
            var stockUnitId=String()
            if stockUnitDetailsDict.count==0
            {
                if stockUnitsArr.count>0
                {
                    stockUnit = stockUnitsArr[0].stockUnitName ?? ""
                    stockUnitId=stockUnitsArr[0]._id ?? ""
                }
                prodDetailsDict.setValue(stockUnit, forKey: "stockUnit")
                prodDetailsDict.setValue(stockUnitId, forKey: "stockUnitId")
            }
            else
            {
                let stockDict=stockUnitDetailsDict[0] as! NSDictionary
                stockUnit = stockDict.value(forKey: "stockUnitName")as? String ?? ""
            }
            stockUnitDropDown.setTitle(stockUnit, for: .normal)
            
            var priceUnit=String()
            var priceUnitId=String()
            let priceUnitDetails=dataDict.value(forKey: "priceUnitDetails")as? NSArray ?? NSArray()
            if priceUnitDetails.count==0
            {
                if priceUnitsArr.count>0
                {
                    priceUnit = priceUnitsArr[0].priceUnit ?? ""
                    priceUnitId=priceUnitsArr[0]._id ?? ""
                }
                prodDetailsDict.setValue(priceUnit, forKey: "priceUnit")
                prodDetailsDict.setValue(priceUnitId, forKey: "priceUnitId")
            }
            else
            {
                let priceDict=priceUnitDetails[0] as! NSDictionary
                priceUnit = priceDict.value(forKey: "priceUnit")as? String ?? ""
            }
            priceUnitDropDown.setTitle(priceUnit, for: .normal)
            
            var category=String()
            var categoryId=String()
            if prodDetailsDict.value(forKey: "category") as! String==""
            {
                if categoryResult.count>0
                {
                    category=categoryResult[0].name ?? ""
                    categoryId=categoryResult[0]._id ?? ""
                }
                prodDetailsDict.setValue(category, forKey: "category")
                prodDetailsDict.setValue(categoryId, forKey: "categoryId")
            }
            else
            {
                category = (prodDetailsDict.value(forKey: "category") as? NSString ?? "") as String
            }
            categoryDropDown.setTitle(category, for: .normal)
            var subCategory=String()
            var subCategoryId=String()
            if prodDetailsDict.value(forKey: "subCategory") as! String==""
            {
                if subCategoryResult.count>0
                {
                    subCategory=subCategoryResult[0].name ?? ""
                    subCategoryId=subCategoryResult[0]._id ?? ""
                }
                prodDetailsDict.setValue(subCategory, forKey: "subCategory")
                prodDetailsDict.setValue(subCategoryId, forKey: "subCategoryId")
            }
            else
            {
                subCategory = (prodDetailsDict.value(forKey: "subCategory") as? NSString ?? "") as String
            }
            subCategoryDropDown.setTitle(subCategory, for: .normal)
            
            if let reqQty = prodDetailsDict.value(forKey: "stockQuantity") as? Double
            {
                reqQunatityTF.text = String(reqQty)
            }
            else if let reqQty = prodDetailsDict.value(forKey: "stockQuantity") as? Float
            {
                reqQunatityTF.text = String(reqQty)
            }
            else
            {
                reqQunatityTF.text = prodDetailsDict.value(forKey: "stockQuantity") as? String
            }
            if let price = prodDetailsDict.value(forKey: "price") as? Double
            {
                totalPriceTF.text = String(format:"%.2f", price)
            }
            else if let price = prodDetailsDict.value(forKey: "price") as? Float
            {
                totalPriceTF.text = String(format:"%.2f", price)
            }
            else
            {
                totalPriceTF.text = prodDetailsDict.value(forKey: "price") as? String
            }
            if let pricePerStockUnit = prodDetailsDict.value(forKey: "unitPrice") as? Double
            {
                pricePerStockUnitTF.text = String(pricePerStockUnit)
            }
            else if let pricePerStockUnit = prodDetailsDict.value(forKey: "unitPrice") as? Float
            {
                pricePerStockUnitTF.text = String(pricePerStockUnit)
            }
            else
            {
                pricePerStockUnitTF.text = prodDetailsDict.value(forKey: "unitPrice") as? String
            }
            
            productIDTF.tag   = idTagValue!
            productNameTF.tag = prodNameTagValue!
            descriptionTF.tag = descriptionTagValue!
            reqQunatityTF.tag = reqQuanTagValue!
            stockUnitTF.tag = stockUnitTagValue!
            stockUnitDropDown.tag = stockUnitTagValue!
            priceUnitDropDown.tag = priceUnitTagValue!
            categoryDropDown.tag = catTagValue!
            subCategoryDropDown.tag = subCatTagValue!
            totalPriceTF.tag = totalPriceTagValue!
            priceTF.tag = priceTagValue!
            pricePerStockUnitTF.tag = pricePerStockUnitValue!
        }
       
        
        productScrollView.contentSize = CGSize(width: productScrollView.frame.size.width, height: yValue+300)
        productScrollView.contentOffset = CGPoint(x: 0, y: scrollViewYPos)

    }
    var priceUnitNamesArr = [String]()
    var priceUnitIdsArr = [String]()
    @IBAction func price_UnitBtnTap(_ sender: UIButton) {
        var productArrayPosition = Int()
        var productTagValue=Int()
        let sstag:String = String(sender.tag)
        if sstag.count>5
        {
         productArrayPosition = sender.tag%100
         productTagValue = sender.tag / 100;
         
        }
        else
        {
         productArrayPosition = sender.tag%10
         productTagValue = sender.tag / 10;
            
        }
        var dict = NSMutableDictionary()
         priceUnitNamesArr = [String]()
        for obj in priceUnitsArr {
            priceUnitNamesArr.append(obj.priceUnit ?? "")
            priceUnitIdsArr.append(obj._id ?? "")
        }
        dict = myProductArray[productArrayPosition] as! NSMutableDictionary
        let priceUnitDetails=dict.value(forKey: "priceUnitDetails")as! NSArray
        dropDown.dataSource = priceUnitNamesArr //4
        
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.priceUnitDropDown.setTitle(item as String, for: UIControl.State.normal)
//                self?.priceUnitTF.text = item
                if priceUnitDetails.count>0
                {
                (priceUnitDetails[0] as AnyObject).setValue(item, forKey: "priceUnit")
                let priceUnitID = self?.priceUnitIdsArr[index]
                (priceUnitDetails[0] as AnyObject).setValue(priceUnitID, forKey: "_id")
                }
                
                dict.setValue(priceUnitDetails, forKey: "priceUnitDetails")
                self?.loadAddProductUI()
            }
    }
    @IBAction func onPreferredVendorBtnTapped(_ sender: UIButton) {
        
        categoryDataArray = NSMutableArray()
        categoryIDArray = NSMutableArray()
        
        getVendorListDataFromServer()
        
    }
    
    @IBAction func datePickerBtnTap(_ sender: UIButton) {

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
        
        var productArrayPosition = Int()
        var productTagValue=Int()
        let sstag:String = String(sender.tag)
        if sstag.count>5
        {
         productArrayPosition = sender.tag%100
         productTagValue = sender.tag / 100;
         
        }
        else
        {
         productArrayPosition = sender.tag%10
         productTagValue = sender.tag / 10;
            
        }

        purchase_ExpiryTagVal = sender.tag
        purchase_expiryProductPosLev = productArrayPosition
        purchase_expiryTagValue = productTagValue
        
        print(purchase_ExpiryTagVal,purchase_expiryProductPosLev,purchase_ExpiryTagVal)
        
        let currentDate = Date()
        let eventDatePicker = UIDatePicker()
        
        eventDatePicker.datePickerMode = UIDatePicker.Mode.date
        eventDatePicker.minimumDate = currentDate
               
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let tmpButton = self.view.viewWithTag(purchase_ExpiryTagVal as! Int ) as? UIButton
        tmpButton?.setTitleColor(hexStringToUIColor(hex: "232c51"), for: .normal)
        tmpButton?.setTitle(dateFormatter.string(from: eventDatePicker.date), for: .normal)
        
        self.dateStr = dateFormatter.string(from: eventDatePicker.date)
        self.changesUpdate=true
        
//        var dict = NSMutableDictionary()
//        dict = myProductArray[purchase_expiryProductPosLev] as! NSMutableDictionary
//
//        let productDict = dict.value(forKey: "productdetails") as! NSMutableDictionary

       // if(purchase_expiryTagValue == 1007){ //Purchase Btn
            openOrdersDict.setValue(dateFormatter.string(from: eventDatePicker.date), forKey: "purchaseDate")

        //}
//        else if(purchase_expiryTagValue == 1008){
//            dict.setValue(dateFormatter.string(from: eventDatePicker.date), forKey: "expiryDate")
//
//        }
        
//        dict.setValue(productDict, forKey: "productdetails")
//
//        myProductArray.replaceObject(at:purchase_expiryProductPosLev, with: dict)

    }
    
    @objc func dueDateChanged(sender:UIDatePicker){
        
        print(purchase_ExpiryTagVal)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let selectedDate = dateFormatter.string(from: picker.date)

        let tmpButton = self.view.viewWithTag(purchase_ExpiryTagVal as! Int ) as? UIButton
        tmpButton?.setTitleColor(hexStringToUIColor(hex: "232c51"), for: .normal)
        tmpButton?.setTitle(selectedDate, for: .normal)
        self.changesUpdate=true
//        var dict = NSMutableDictionary()
//        dict = myProductArray[purchase_expiryProductPosLev] as! NSMutableDictionary
//
//        let productDict = dict.value(forKey: "productdetails") as! NSMutableDictionary

       // if(purchase_expiryTagValue == 1007){ //Purchase Btn
            openOrdersDict.setValue(selectedDate, forKey: "purchaseDate")

       // }
//        else if(purchase_expiryTagValue == 1008){
//            dict.setValue(dateFormatter.string(from: eventDatePicker.date), forKey: "expiryDate")
//
//        }
        
//        dict.setValue(productDict, forKey: "productdetails")
//
//        myProductArray.replaceObject(at:purchase_expiryProductPosLev, with: dict)

    }
    
    @objc func doneBtnTap(_ sender: UIButton) {

        hiddenBtn.removeFromSuperview()
        pickerDateView.removeFromSuperview()
        self.newOrderIDView.removeFromSuperview()
        self.loadNewOrderIDView()
        
//        self.loadAddProductUI()
        
    }
    
    func getVendorListDataFromServer() {
        
        categoryIDArray.removeAllObjects()
        categoryDataArray.removeAllObjects()
        
        categoryIDArray = NSMutableArray()
        categoryDataArray = NSMutableArray()
        
        var accountID = String()
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
                activity.startAnimating()
                self.view.isUserInteractionEnabled = true
        
                let URLString_loginIndividual = Constants.BaseUrl + VendorListUrl + accountID as String
                editServCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                                    let respVo:VendorListRespo = Mapper().map(JSON: result as! [String : Any])!
                                                            
                                    let status = respVo.status
                                    let messageResp = respVo.message
                                    _ = respVo.statusCode
                                    
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                                
                                    if status == "SUCCESS" {
                                        
                                        self.vendorListResult = respVo.result!
                                        
                                        for categoryItems in self.vendorListResult {
                                            
                                            self.categoryIDArray.add(categoryItems._id ?? "")
                                            self.categoryDataArray.add(categoryItems.vendorName ?? "")
                                            
                                        }
                                        
                                        if(self.categoryDataArray.count == 0){
                                            
                                            self.showAlertWith(title: "Alert !!", message: "No Vendor available. Please add a vendor before adding a product")
                                            
                                        }else if(self.categoryDataArray.count > 0){

//                                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                                            let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
//                                            viewTobeLoad.delegate1 = self
//                                            viewTobeLoad.iscountry = false
//                                            viewTobeLoad.headerTitleStr = "Select a Subcategory"
//                                            viewTobeLoad.fields = self.categoryDataArray as! [String]
//                                            viewTobeLoad.categoryIDs = self.categoryIDArray as! [String]
//
//                                            viewTobeLoad.modalPresentationStyle = .fullScreen
////                                                self.present(viewTobeLoad, animated: true, completion: nil)
//
//                                    self.navigationController?.pushViewController(viewTobeLoad, animated: true)

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
        
        if(self.vendorListResult.count == 0){
        }

    }
    
    func callUpdateOpenOrdersAPI() {
        
                activity.startAnimating()
                self.view.isUserInteractionEnabled = false
                
                let URLString_loginIndividual = Constants.BaseUrl + EditUpdateOpenOrdersUrl
                 
                            let params_IndividualLogin = [
                                "" : ""
                            ]
                        
//                            print(params_IndividualLogin)
                        
                            let postHeaders_IndividualLogin = ["":""]
                            
        editServCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: openOrdersDict as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
                                    if(statusCode == 200 ){
                             
//            self.showAlertWith(title: "Success", message: "Details updated successfully")
                                        
//                                        self.showAlertWith(title: "Success", message: "Details updated successfully")
                                        
                                        let alert = UIAlertController(title: "Success", message: "Details updated successfully", preferredStyle: UIAlertController.Style.alert)
                                        
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                                            
                                            self.navigationController?.popViewController(animated: true)
                                                                       
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
    var changesUpdate:Bool=false
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var productArrayPosition = Int()
        var productTagValue=Int()
        let sstag:String = String(textField.tag)
        if sstag.count>5
        {
         productArrayPosition = textField.tag%100
         productTagValue = textField.tag / 100;
         
        }
        else
        {
         productArrayPosition = textField.tag%10
         productTagValue = textField.tag / 10;
            
        }
        var dict = NSMutableDictionary()
        dict = myProductArray[productArrayPosition] as! NSMutableDictionary
        let productdetails=dict.value(forKey: "productdetails") as! NSMutableDictionary
        if string=="."
        {
            if textField.text?.contains(".")==true || textField.text==""
            {
                return false
            }
           
        }
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        print(newString)
        
        textField.becomeFirstResponder()
        
        if(productTagValue == 1003){
            if newString != "" {
                let aa=decimalPlaces(stt: newString)
                if aa>3 {
                    
                }
                else
                {
                let stockVal = newString
                productdetails.setValue(false, forKey: "stockQuantityWarn")
                var pricePerStockVal=String()
                if let pricePerStockUnit = productdetails.value(forKey: "unitPrice") as? Double
                {
                    pricePerStockVal = String(pricePerStockUnit)
                }
                else if let pricePerStockUnit = productdetails.value(forKey: "unitPrice") as? Float
                {
                    pricePerStockVal = String(pricePerStockUnit)
                }
                else
                {
                    pricePerStockVal = productdetails.value(forKey: "unitPrice") as? String ?? ""
                }
                let obj1 = Float(stockVal)
                if pricePerStockVal != "" {
                    let obj2 = Float(pricePerStockVal ?? "0")
                    let obj3 = obj1! * obj2!
                    let obj4 = String(format: "%.2f", obj3)
                    productdetails.setValue(newString, forKey: "stockQuantity")
                    productdetails.setValue("\(obj4)", forKey: "price")
                    let tagg="2002"+String(productArrayPosition)
                    let tagInt=Int(tagg)
                    if let txtField = self.view.viewWithTag(tagInt!) as? UITextField, let txt = txtField.text {
                               
                        txtField.text = "\(obj4)"
                        print(txt)
                            }
    
                }
                else {
                    let obj3 = obj1! * 0.0
                    let tagg="2002"+String(productArrayPosition)
                    let tagInt=Int(tagg)
                    if let txtField = self.view.viewWithTag(tagInt!) as? UITextField, let txt = txtField.text {
                               
                        txtField.text = "\(obj3)"
                        print(txt)
                            }
                    productdetails.setValue(newString, forKey: "stockQuantity")
                    productdetails.setValue("\(obj3)", forKey: "price")
                }
            }
            }
            else {
                let tagg="2002"+String(productArrayPosition)
                let tagInt=Int(tagg)
                if let txtField = self.view.viewWithTag(tagInt!) as? UITextField, let txt = txtField.text {
                           
                    txtField.text = "0.0"
                    print(txt)
                        }
                productdetails.setValue(newString, forKey: "stockQuantity")
                productdetails.setValue("0.0", forKey: "price")
            }
            dict.setValue(productdetails, forKey: "productdetails")
            myProductArray.replaceObject(at: productArrayPosition, with: dict)
        }
        if(productTagValue == 2001){ // Price Per Stock Unit
            
            if newString != "" {
                let aa=decimalPlaces(stt: newString)
                if aa>2 {
                    
                }
                else
                {
                productdetails.setValue(false, forKey: "unitPriceWarn")
                var stockVal=String()
                if let reqQty = productdetails.value(forKey: "stockQuantity") as? Double
                {
                    stockVal = String(reqQty)
                }
                else if let reqQty = productdetails.value(forKey: "stockQuantity") as? Float
                {
                    stockVal = String(reqQty)
                }
                else
                {
                    stockVal = productdetails.value(forKey: "stockQuantity") as? String ?? ""
                }
                let pricePerStockVal = newString
                let obj2 = Float(pricePerStockVal)
                if stockVal != ""{
                    let obj1 = Float(stockVal ?? "0")
                    let obj3 = obj1! * obj2!
                    let obj4 = String(format: "%.2f", obj3)
//                    print(String(format: "%.2f", obj3))
                   
                    productdetails.setValue(newString, forKey: "unitPrice")
                    productdetails.setValue("\(obj4)", forKey: "price")
                    let tagg="2002"+String(productArrayPosition)
                    let tagInt=Int(tagg)
                    if let txtField = self.view.viewWithTag(tagInt!) as? UITextField, let txt = txtField.text {
                    print("\(obj4)")
                        print(txtField.text)
                        print(txt)
                        txtField.text = "\(obj4)"
                        print(txt)
                            }
                }
                else {
                   
                        let obj3 = 0.0 * obj2!
                    let tagg="2002"+String(productArrayPosition)
                    let tagInt=Int(tagg)
                    if let txtField = self.view.viewWithTag(tagInt!) as? UITextField, let txt = txtField.text {
                               
                        txtField.text = "\(obj3)"
                        print(txt)
                            }
                    productdetails.setValue(newString, forKey: "unitPrice")
                    productdetails.setValue("\(obj3)", forKey: "price")
                    }
                }
            }
            else {
                let tagg="2002"+String(productArrayPosition)
                let tagInt=Int(tagg)
                if let txtField = self.view.viewWithTag(tagInt!) as? UITextField, let txt = txtField.text {
                           
                    txtField.text = "0.0"
                    print(txt)
                        }
                productdetails.setValue(newString, forKey: "unitPrice")
                productdetails.setValue("0.0", forKey: "price")
            }
            dict.setValue(productdetails, forKey: "productdetails")
            myProductArray.replaceObject(at: productArrayPosition, with: dict)
        }
//        if(productTagValue == 2002){ // Total Price
//
//                let stockVal = stockQuantityTF.text
//                let pricePerStockVal = pricePerStockUnitTF.text
//                let obj1 = Float(stockVal!)
//                let obj2 = Float(pricePerStockVal!)
//                let obj3 = obj1! * obj2!
//                totalPriceTF.text = "\(obj3)"
//
//        }
        if(productTagValue == 1006){ //Price

            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1

            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }

            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        }
        if(productTagValue == 2001){ //Price Per Stock Unit

            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1

            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }

            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        }
        if(productTagValue == 1003){ // Req Quantity

            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1

            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 3
        }
        
        if(productTagValue == 2002){ //Price

            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1

            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }

            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        }
       
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        var productArrayPosition = Int()
        var productTagValue=Int()
        let sstag:String = String(textField.tag)
        if sstag.count>5
        {
         productArrayPosition = textField.tag%100
         productTagValue = textField.tag / 100;
         
        }
        else
        {
         productArrayPosition = textField.tag%10
         productTagValue = textField.tag / 10;
            
        }
         
        print(myProductArray)
        var mainDict = NSMutableDictionary()
        mainDict = myProductArray[productArrayPosition] as! NSMutableDictionary

        var dict = NSMutableDictionary()
        dict = mainDict.value(forKey: "productdetails") as! NSMutableDictionary
        
        print(productArrayPosition)
        print(productTagValue)
        
        if productTagValue == 1000{ //Product ID

            print("Product ID")
            print(textField.tag)

            dict.setValue(textField.text, forKey: "productUniqueNumber")
            mainDict.setValue(dict, forKey: "productdetails")
            myProductArray.replaceObject(at: productArrayPosition, with: mainDict)
        }else if(productTagValue == 1001){ //Product Name

            dict.setValue(textField.text, forKey: "productName")
            dict.setValue(false, forKey: "productNameWarn")
            mainDict.setValue(dict, forKey: "productdetails")
            myProductArray.replaceObject(at: productArrayPosition, with: mainDict)
//           self.loadAddProductUI()
        }else if(productTagValue == 1003){ //Stock Quantity
            dict.setValue(textField.text, forKey: "stockQuantity")
            dict.setValue(false, forKey: "stockQuantityWarn")
            mainDict.setValue(dict, forKey: "productdetails")
            myProductArray.replaceObject(at: productArrayPosition, with: mainDict)
//           self.loadAddProductUI()
        }else if(productTagValue == 1006){ //Price
            dict.setValue(textField.text!, forKey: "price")
            mainDict.setValue(dict, forKey: "productdetails")
            myProductArray.replaceObject(at: productArrayPosition, with: mainDict)
        }
        else if(productTagValue == 2001){ //Price
            dict.setValue(textField.text!  , forKey: "unitPrice")
            dict.setValue(false, forKey: "unitPriceWarn")
            mainDict.setValue(dict, forKey: "productdetails")
            myProductArray.replaceObject(at: productArrayPosition, with: mainDict)
//          self.loadAddProductUI()
        }
        if textField.text==""
        {
//            mainDict.setValue(dict, forKey: "productdetails")
//            myProductArray.replaceObject(at: productArrayPosition, with: mainDict)
        }
        else
        {
            changesUpdate=true
//            mainDict.setValue(dict, forKey: "productdetails")
//            myProductArray.replaceObject(at: productArrayPosition, with: mainDict)
        }
        
        
//        print(myProductArray)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        var productArrayPosition = Int()
        var productTagValue=Int()
        let sstag:String = String(textView.tag)
        if sstag.count>5
        {
         productArrayPosition = textView.tag%100
         productTagValue = textView.tag / 100;
         
        }
        else
        {
         productArrayPosition = textView.tag%10
         productTagValue = textView.tag / 10;
            
        }
        
        var mmdict = NSMutableDictionary()
        mmdict = myProductArray[productArrayPosition] as! NSMutableDictionary
        var dict = NSMutableDictionary()
        dict = mmdict.value(forKey: "productdetails") as! NSMutableDictionary
        print(productArrayPosition)
        print(productTagValue)

        
        if productTagValue == 1002{ //Descritpion

            print("Description")
            print(textView.tag)

            dict.setValue(textView.text, forKey: "description")

        }
        if textView.text==""
        {
            
        }
        else
        {
            changesUpdate=true
        }
        mmdict.setValue(dict, forKey: "productdetails")
        myProductArray.replaceObject(at: productArrayPosition, with: mmdict)

    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewYPos = scrollView.contentOffset.y
    }

    
    @IBAction func productImgBtnTap(_ sender: UIButton){

        var productIArrayPosition = Int()
        var productTagValue = Int()
        var prodJPos = Int()

        let sstag:String = String(sender.tag)
        if sstag.count>6
        {
             productIArrayPosition = sender.tag%100
             productTagValue = sender.tag / 100
             prodJPos = productTagValue%10

        }
        else
        {
             productIArrayPosition = sender.tag%10
             productTagValue = sender.tag / 10;
             prodJPos = productTagValue%10
        }
        print(productIArrayPosition)
        print(productTagValue)
        print(prodJPos)
        
        prodImgIArrayPos = productIArrayPosition
        prodImgJPos = prodJPos
        prodImgTagValue = sender.tag
        
        print(prodImgTagValue)
        
            
            let alert = UIAlertController(title: "Image Selection", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
                self.loadCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
                self.loadGallery()
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))
            
            //uncomment for iPad Support
            //alert.popoverPresentationController?.sourceView = self.view

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            
            if Constants.IS_IPAD {
                            let popoverPresentationController = alert.popoverPresentationController
                            popoverPresentationController?.sourceView = self.view
                            popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width/3 , y: self.view.frame.height/3, width: 0, height: 0)
                            popoverPresentationController?.permittedArrowDirections = .down
                        }

        }
        
        func loadGallery() {
            
            let image = UIImagePickerController()
                    image.delegate=self
                    image.sourceType = .photoLibrary
                    image.allowsEditing=false
                    self.present(image, animated: true){

                    }
        }
        
        func loadCamera() {
            
            let image = UIImagePickerController()
                    image.delegate=self
                    image.sourceType = .camera
                    image.allowsEditing=false
                    self.present(image, animated: true){

                    }
        }
        

    
    
    //Delegate Method in UIImage Picker Controller :

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let imagePick = info[UIImagePickerController.InfoKey.originalImage] {
//                    profileImgView.image = imagePick as? UIImage
       
       print(prodImgTagValue)
       
       let tmpButton = self.view.viewWithTag(prodImgTagValue) as? UIButton
       tmpButton?.setImage(imagePick as! UIImage, for:UIControl.State.normal)
       
       tmpButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

       let imageData: Data? = (imagePick as! UIImage).jpegData(compressionQuality: 0.4)
       let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
       
       var dict = NSMutableDictionary()
       dict = myProductArray[prodImgIArrayPos] as! NSMutableDictionary
        
       let prodDict = dict.value(forKey: "productdetails") as! NSDictionary
       
       var productImgArray = NSMutableArray()
       var  productImgict = NSMutableDictionary()
       
       productImgArray = prodDict.value(forKey: "productImagesUpdateList") as! NSMutableArray
       
       productImgict = productImgArray[prodImgJPos] as! NSMutableDictionary
       productImgict.setValue(imageStr, forKey: "productImage")
       productImgict.setValue(imagePick as! UIImage, forKey: "productDisplayImage")
        
//        if(isEditShopping == "ShoppingEdit"){
       productImgict.setValue("1", forKey: "productLocalImg")

//        }
       
       productImgArray.replaceObject(at:prodImgJPos , with: productImgict)
       prodDict.setValue(productImgArray, forKey: "productImagesUpdateList")
       dict.setValue(prodDict, forKey: "productdetails")
        
//      print(dict)
        myProductArray.replaceObject(at:prodImgIArrayPos , with: dict)

//                    print(myProductArray)
       
//                    prodImgIArrayPos = productIArrayPosition
//                    prodImgJPos = prodJPos
//                    prodImgTagValue = sender.tag

       self.loadAddProductUI()

}
    else{

    //Error Message
    }
    self.dismiss(animated: true, completion: nil)
}
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }

}
