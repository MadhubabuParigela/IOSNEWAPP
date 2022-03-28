//
//  PropertiesShowVC1.swift
//  Lekhha
//
//  Created by Swapna Nimma on 23/01/22.
//

import UIKit
import ObjectMapper
import AVFoundation
import AVKit
import CommonCrypto
import Foundation
import DropDown

protocol sendPropDetails1 {
    func sendPropertyDetails(data:NSArray,idStr:String)
    
}

class PropertiesShowVC1: UIViewController, UIScrollViewDelegate, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    var myProductsArray =  NSMutableArray()
//    var dataScrollView = UIScrollView()
    var isSelectAll = "0"
    
    var delegate:sendPropDetails1?
    
    @IBAction func onClickBillDateTF(_ sender: UITextField) {
        
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
        picker.frame = CGRect(x:0.0, y:50, width:pickerDateView.frame.size.width, height:300)
        // you probably don't want to set background color as black
        // picker.backgroundColor = UIColor.blackColor()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        pickerDateView.addSubview(picker)
        
        let productArrayPosition : Int = sender.tag%10

        purchase_ExpiryTagVal = sender.tag
        purchase_expiryProductPosLev = productArrayPosition
        
        print(purchase_ExpiryTagVal)
        
        let currentDate = Date()
        let eventDatePicker = UIDatePicker()
        
        eventDatePicker.datePickerMode = UIDatePicker.Mode.date
        eventDatePicker.minimumDate = currentDate
               
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        let tmpButton = self.view.viewWithTag(purchase_ExpiryTagVal as! Int ) as? UIButton
        tmpButton?.setTitleColor(hexStringToUIColor(hex: "232c51"), for: .normal)
        tmpButton?.setTitle(dateFormatter.string(from: eventDatePicker.date), for: .normal)
        
        self.billDateTF.text=dateFormatter.string(from: eventDatePicker.date)
       

    }
    @IBOutlet weak var billNumberTF: UITextField!
    @IBOutlet weak var billDateTF: UITextField!
    @IBOutlet weak var storeLocationTF: UITextField!
    
    @IBOutlet weak var checkBtn1: UIButton!
    @IBOutlet weak var checkBtn2: UIButton!
    @IBOutlet weak var checkBtn3: UIButton!
    
    @IBOutlet weak var itemNameTF1: UITextField!
    @IBOutlet weak var itemNameTF2: UITextField!
   
    @IBOutlet weak var quantityTF1: UITextField!
    @IBOutlet weak var quantityTF2: UITextField!
    
    @IBOutlet weak var priceTF1: UITextField!
    @IBOutlet weak var priceTF2: UITextField!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    var SelectDataDic = [NSMutableDictionary]()
    
    var itemNameArr = [UITextField]()
    var quantityArr = [UITextField]()
    var priceArr = [UITextField]()
    var accountID = ""
    var servcCntrl = ServiceController()
    var addProdSerCntrl = ServiceController()
    
var hierachyLevel=String()
    var addProdServiceCntrl = ServiceController()
    var categoryResult = [CategoryResult]()
    var subCategoryResult = [SubCategoryResult]()
    var vendorListResult = [VendorListResult]()
    var catSubCatArrPosition : Int!
    var catSubCatIndexPosition : Int!
    var catSubCatTagValue : Int!
    
    var selectedCategoryID : String!

    var categoryDataArray = NSMutableArray()
    var categoryIDArray = NSMutableArray()
    let dropDown = DropDown()
    var storageLocationArr = [GetStorageLocationMasterResultVo]()
    var storageLocationArr1 = [GetStorageLocationMasterResultVo]()
    var storageLocationArr2 = [GetStorageLocationMasterResultVo]()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.billNumberTF.layer.cornerRadius = 5
        self.billNumberTF.layer.borderWidth = 1
        self.billNumberTF.layer.borderColor = #colorLiteral(red: 0.3411408365, green: 0.3412021399, blue: 0.3411277831, alpha: 1)
        self.billNumberTF.layer.masksToBounds = true
        
//        self.storeLocationTF.layer.cornerRadius = 5
//        self.storeLocationTF.layer.borderWidth = 1
//        self.storeLocationTF.layer.borderColor = #colorLiteral(red: 0.3411408365, green: 0.3412021399, blue: 0.3411277831, alpha: 1)
//        self.storeLocationTF.layer.masksToBounds = true

        self.billDateTF.layer.cornerRadius = 5
        self.billDateTF.layer.borderWidth = 1
        self.billDateTF.layer.borderColor = #colorLiteral(red: 0.3411408365, green: 0.3412021399, blue: 0.3411277831, alpha: 1)
        self.billDateTF.layer.masksToBounds = true
                  
        self.doneBtn.layer.cornerRadius = 10
        self.doneBtn.layer.borderWidth = 1
        self.doneBtn.layer.borderColor = #colorLiteral(red: 0.8830919862, green: 0.8905512691, blue: 0.9012110829, alpha: 1)
        self.doneBtn.layer.masksToBounds = true
        
        self.warnButton.isHidden=true
        
           // Retrieve array
                let defaults = UserDefaults.standard
                let myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        
               print("Saved Array is \(myarray)")

                    for i in 0..<myarray.count {
                        self.SelectDataDic.append(["data":myarray[i]])
                    }

                  //  self.TV_Prog.reloadData()
             
                 print(SelectDataDic)
        
               print("Usedefaults Array: \(myarray)")
        
//        let defaults = UserDefaults.standard
        let billNumStr = defaults.value(forKey: "BillNumber") as? String
        let billDateStr = defaults.value(forKey: "BillDate") as? String

        billNumberTF.text = billNumStr
        billDateTF.text = billDateStr

//        defaults.set(billNumStr, forKey: "BillNumber")
//        defaults.set(billDateStr, forKey: "BillDate")
//                                self.billNumberTF.text! = myarray[4]
//                                self.billDateTF.text! = myarray[5]
//                                self.storeLocationTF.text! = myarray[3]

                     let line = myarray[0]
        let m = line.replacingOccurrences(of: "\n", with: " ", options: [.caseInsensitive, .regularExpression])
                 let lineItems = m.split(separator: " ", omittingEmptySubsequences: false)
                     // ["a", "b", "c", "", "d"]
                     print("lineItems:....\(lineItems)")
        
//        itemNameTF1.text = String(lineItems[0])
//        itemNameTF2.text = String(lineItems[1])
        

        
        
                   let line1 = myarray[1]
        let m1 = line1.replacingOccurrences(of: "\n", with: " ", options: [.caseInsensitive, .regularExpression])
            let lineItems1 = m1.split(separator: " ", omittingEmptySubsequences: false)
                            // ["a", "b", "c", "", "d"]
                 print("lineItems:....\(lineItems1)")
          
//              quantityTF1.text = String(lineItems1[0])
//              quantityTF2.text = String(lineItems1[1])
        
            let line2 = myarray[2]
                   var m2 = line2.replacingOccurrences(of: "\n", with: " ", options: [.caseInsensitive, .regularExpression])
                   let lineItems2 = m2.split(separator: " ", omittingEmptySubsequences: false)
                                   // ["a", "b", "c", "", "d"]
                        print("lineItems:....\(lineItems2)")
        
//              priceTF1.text = String(lineItems2[0])
//              priceTF2.text = String(lineItems2[1])
        
        
        
//
//        itemNameArr = [itemNameTF1,itemNameTF2]
//        quantityArr = [quantityTF1,quantityTF2]
//        priceArr = [priceTF1,priceTF2]
//
//        for (index, element) in itemNameArr.enumerated() {
//
//            element.text = (String(lineItems[index]))
//
//            print(itemNameArr)
//
//            for (i,j) in quantityArr.enumerated() {
//                j.text = (String(lineItems1[index]))
//
//                print(itemNameArr)
//            }
//
//            for (a,b) in priceArr.enumerated() {
//                b.text = (String(lineItems2[index]))
//
//                print(quantityArr)
//            }
//
//        }
//
          // Do any additional setup after loading the view.
        
        dataScrollView.delegate = self
        mainScrollView.delegate=self
//                if #available(iOS 11.0, *) {
//                    self.dataScrollView.contentInsetAdjustmentBehavior = .never
//                    self.mainScrollView.contentInsetAdjustmentBehavior = .never
//
//                }else{
//                    self.automaticallyAdjustsScrollViewInsets = false
//                }
        self.tableView=UITableView()
        self.tableView.delegate=self
        self.tableView.dataSource=self
        self.tableView.register(UINib(nibName: "PropertiesShowTableViewCell", bundle: nil), forCellReuseIdentifier: "PropertiesShowTableViewCell")
        self.tableView.reloadData()
       }
        override func viewWillLayoutSubviews()
        {
            super.viewWillLayoutSubviews();
            //        scViewHeight.constant = 1200
           // self.dataScrollView.contentSize.height = self.dataScrollView.frame.size.height // Or whatever you want it to be.]
//           self.backVieww.frame.size.height=1500
//            //self.backVieww.layoutIfNeeded()
//            self.mainScrollView.contentSize.height=self.backVieww.frame.size.height
        }
    @IBOutlet weak var backVieww: UIView!
    @IBOutlet weak var billNumView: UIView!
    
    @IBOutlet weak var billDateView: UIView!
    var picker : UIDatePicker = UIDatePicker()
    var useRefArray = NSMutableArray()

    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
    
    var purchase_ExpiryTagVal : Int!
    var purchase_expiryProductPosLev : Int!
    var purchase_expiryTagValue : Int!
    @objc func dueDateChanged(sender:UIDatePicker){
        
        print(purchase_ExpiryTagVal)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: picker.date)

        let tmpButton = self.view.viewWithTag(purchase_ExpiryTagVal as! Int ) as? UIButton
        tmpButton?.setTitleColor(hexStringToUIColor(hex: "232c51"), for: .normal)
        tmpButton?.setTitle(selectedDate, for: .normal)
        
        self.billDateTF.text=selectedDate

    }
    @IBAction func onClickWarnButton1(_ sender: UIButton) {
        self.showAlertWith(title: "Alert", message: "Please enter date in DD/MM/YYYY")
    }
    
    @IBOutlet var warnButton: UIButton!
    @objc func doneBtnTap(_ sender: UIButton) {

        hiddenBtn.removeFromSuperview()
        pickerDateView.removeFromSuperview()
        
        
    }
    @IBAction func billDateCalendarButton(_ sender: UIButton) {
        
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
        picker.frame = CGRect(x:0.0, y:50, width:pickerDateView.frame.size.width, height:300)
        // you probably don't want to set background color as black
        // picker.backgroundColor = UIColor.blackColor()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        pickerDateView.addSubview(picker)
        
        let productArrayPosition : Int = sender.tag%10

        purchase_ExpiryTagVal = sender.tag
        purchase_expiryProductPosLev = productArrayPosition
        
        print(purchase_ExpiryTagVal)
        
        let currentDate = Date()
        let eventDatePicker = UIDatePicker()
        
        eventDatePicker.datePickerMode = UIDatePicker.Mode.date
        eventDatePicker.minimumDate = currentDate
               
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        let tmpButton = self.view.viewWithTag(purchase_ExpiryTagVal as! Int ) as? UIButton
        tmpButton?.setTitleColor(hexStringToUIColor(hex: "232c51"), for: .normal)
        tmpButton?.setTitle(dateFormatter.string(from: eventDatePicker.date), for: .normal)
        self.billDateTF.text=dateFormatter.string(from: eventDatePicker.date)
       

    }
    var subbuttonTap=String()
    var subbuttonTapPositon=Int()
    var selectedCategoryStr = ""
    var dict = NSMutableDictionary()
    @IBAction func onClickVendorButton(_ sender: UIButton) {
        let productArrayPosition : Int = 0
        let productTagValue:Int = 0
        var vendorNameListArr = [String]()
        
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
                self?.vendotButton.setTitle(item as String, for: UIControl.State.normal)
                self?.dict.setValue(item, forKey: "vendorName")
                self?.dict.setValue(self?.selectedVendorId, forKey: "vendorId")
                
            }
    }
    @IBOutlet var vendotButton: UIButton!
    @IBAction func onClickVendorMasterList(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "VendorListVC") as! VendorListingViewController
        VC.modalPresentationStyle = .fullScreen
        VC.isAddProd = "1"
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func getVendorListDataFromServer() {
    
        
        var accountID = String()
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
                activity.startAnimating()
                self.view.isUserInteractionEnabled = true
        
//        accountID = "5f8970b099c2f076c8c54af6"
        
                let URLString_loginIndividual = Constants.BaseUrl + VendorListUrl + accountID as String
        addProdServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                                    let respVo:VendorListRespo = Mapper().map(JSON: result as! [String : Any])!
                                                            
                                    let status = respVo.status
                                    let messageResp = respVo.message
                                    _ = respVo.statusCode
                                    
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                                
                                    if status == "SUCCESS" {
                                        
                                        self.vendorListResult = respVo.result!
                                        self.vendotButton.setTitle(respVo.result?[0].vendorName, for: .normal)
                 
                                        self.dict.setValue(respVo.result?[0].vendorName, forKey: "vendorName")
                                        self.dict.setValue(respVo.result?[0]._id, forKey: "vendorId")
                                    }
                                    else {
                                        
                                        self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                        
                                    }
                                    
                                }) { (error) in
                                    
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                    print("Something Went To Wrong...PLrease Try Again Later")
                                }
        
//        if(self.vendorListResult.count == 0){
//
//        }

    }
    
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
                                self.categoryButton.setTitle(respVo.result![0].name ?? "", for: UIControl.State.normal)
                                self.dict.setValue(respVo.result![0].name ?? "", forKey: "category")
                                self.dict.setValue(respVo.result![0]._id ?? "", forKey: "categoryId")
                                self.selectedCategoryID = respVo.result![0]._id ?? ""
                                self.selectedCategoryStr=respVo.result![0].name ?? ""
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
    
    func getSubCategoriesDataFromServer()  {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        let newString = selectedCategoryStr.replacingOccurrences(of: " ", with: "%20")
                    let URLString_loginIndividual = Constants.BaseUrl + SubCategoriesUrl + newString
                                    
                            servcCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

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


                                    self.subCategoryButton.setTitle(respVo.result![0].name, for: .normal)
                                    self.dict.setValue(respVo.result![0].name, forKey: "subCategory")
                                    self.dict.setValue(respVo.result![0]._id, forKey: "subCategoryId")
                                    self.subbuttonTap=""

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
    @IBAction func onClickStockUnitButton(_ sender: UIButton) {
       
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
                self?.stockUnitButton.setTitle(item as String, for: UIControl.State.normal)
                self?.selectedStockId = (self?.stockUnitIdsArr[index])!
               // self?.stockUnitTF.text = item
                self?.dict.setValue(item, forKey: "stockUnit")
                self?.dict.setValue(self?.selectedStockId, forKey: "stockUnitId")
                
            }
    }
    @IBOutlet var stockUnitButton: UIButton!
    @IBAction func onClickStockUnitMasterList(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Vendor", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "StockUnitMasterVC") as! StockUnitMasterVC
        VC.modalPresentationStyle = .fullScreen
//        VC.isAddProd = "1"
        self.navigationController?.pushViewController(VC, animated: true)
    }
    var priceUnitNamesArr = [String]()
    var priceUnitIdsArr = [String]()
    @IBAction func onClickPriceUnitButton(_ sender: UIButton) {
        
         priceUnitNamesArr = [String]()
        for obj in priceUnitsArr {
            priceUnitNamesArr.append(obj.priceUnit ?? "")
            priceUnitIdsArr.append(obj._id ?? "")
        }
        dropDown.dataSource = priceUnitNamesArr //4
        
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.priceUnitButton.setTitle(item as String, for: UIControl.State.normal)
//                self?.priceUnitTF.text = item
                self?.dict.setValue(item, forKey: "priceUnit")
                let priceUnitID = self?.priceUnitIdsArr[index]
                self?.dict.setValue(priceUnitID, forKey: "priceUnitId")
                
            }
    }
    @IBOutlet var priceUnitButton: UIButton!
    @IBAction func onClickCategoryButton(_ sender: UIButton) {
        subbuttonTap="tap"
        
      
        
        let selectedCatStr = dict.value(forKey: "category") as? String
        
        print(catSubCatIndexPosition as Any,catSubCatTagValue,catSubCatArrPosition)

        if(sender.tag == 3000){
            
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
                    self?.categoryButton.setTitle(item as String, for: UIControl.State.normal)
                    let selectedId = self?.categoryIDArray[index]
                    self?.dict.setValue(item, forKey: "category")
                    self?.dict.setValue(selectedId, forKey: "categoryId")
                    self?.selectedCategoryStr = item
                    self?.selectedCategoryID = selectedId as? String
                    self?.getSubCategoriesDataFromServer()
                    
                }
            
        }else if(sender.tag == 3001){
            
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
                        self?.subCategoryButton.setTitle(item as String, for: UIControl.State.normal)
                        self?.dict.setValue(item, forKey: "subCategory")
                        let selecteSubId = self?.categoryIDArray[index]
                        self?.dict.setValue(selecteSubId, forKey: "subCategoryId")
                        
                    }
            }
        }
    }
    var buttonTap=String()
        var buttonPosition=Int()
    @IBOutlet var categoryButton: UIButton!
    @IBAction func onClickSubCtegoryButton(_ sender: UIButton) {
        subbuttonTap="tap"
        
       
        
        let selectedCatStr = dict.value(forKey: "category") as? String
        
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
                    self?.categoryButton.setTitle(item as String, for: UIControl.State.normal)
                    let selectedId = self?.categoryIDArray[index]
                    self?.dict.setValue(item, forKey: "category")
                    self?.dict.setValue(selectedId, forKey: "categoryId")
                    self?.selectedCategoryStr = item
                    self?.selectedCategoryID = selectedId as? String
                    self?.getSubCategoriesDataFromServer()
                    
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
                        self?.subCategoryButton.setTitle(item as String, for: UIControl.State.normal)
                        self?.dict.setValue(item, forKey: "subCategory")
                        let selecteSubId = self?.categoryIDArray[index]
                        self?.dict.setValue(selecteSubId, forKey: "subCategoryId")
                        
                    }
            }
        }
    }
    @IBOutlet var subCategoryButton: UIButton!
    @IBAction func onClickStorageLocation1Button(_ sender: UIButton) {
        buttonTap="tap"
    var storageLocArr=[String]()
        for obj in storageLocationArr {
            if obj.hierachyLevel == 1 {
                
                storageLocArr.append(obj.slocName ?? "")
                storageLocationIdsArr.append(obj._id ?? "")
                storageLocationParentArr.append(obj.parentLocation ?? "")
            }
            
        }
        
        dropDown.dataSource = storageLocArr//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.storageLocation1Button.setTitle(item as String, for: UIControl.State.normal)
                self?.selectedStorageId = (self?.storageLocationIdsArr[index])!
                self?.storageLocation2Button.setTitle("", for: UIControl.State.normal)
                self?.storageLocation3Button.setTitle("", for: UIControl.State.normal)
//                self?.selectedStorageParentId = (self?.storageLocationParentArr[index])!
//                self?.storageLocationTF.text = item
                self?.dict.setValue(item, forKey: "storageLocation")
                self?.dict.setValue(self?.selectedStorageId, forKey: "storageLocationId")
                self?.dict.setValue("", forKey: "storageLocation1")
                self?.dict.setValue("", forKey: "storageLocation1Id")
                self?.dict.setValue("", forKey: "storageLocation2")
                self?.dict.setValue("", forKey: "storageLocation2Id")
                self?.hierachyLevel="2"
                self?.parentLocation=item
                self?.storageLocationArr1.removeAll()
                self?.storageLocationArr2.removeAll()
                self?.get_StorageLocationByParentLocation_API_Call()
                
            }
    }
    @IBOutlet var storageLocation1Button: UIButton!
    @IBAction func onClickStorageLocation2Button(_ sender: UIButton) {
        
    
        var storageLocArr = [String]()
        var storageLocation1IdsArr = [String]()
        var storageLocation1ParentArr = [String]()

        for obj in storageLocationArr1 {
            
            storageLocArr.append(obj.slocName ?? "")
            storageLocation1IdsArr.append(obj._id ?? "")
            storageLocation1ParentArr.append(obj.parentLocation ?? "")
        }
        
        dropDown.dataSource = storageLocArr//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.storageLocation2Button.setTitle(item as String, for: UIControl.State.normal)
                self?.selectedStorage1Id = (self?.storageLocationIdsArr[index])!
//                self?.selectedStorage1ParentId = (self?.storageLocation1ParentArr[index])!
//                self?.storageLocationTF.text = item
                self?.dict.setValue(item, forKey: "storageLocation1")
                self?.dict.setValue(self?.selectedStorage1Id, forKey: "storageLocation1Id")
                self?.dict.setValue("", forKey: "storageLocation2")
                self?.dict.setValue("", forKey: "storageLocation2Id")
                self?.hierachyLevel="3"
                self?.parentLocation=self?.selectedStorage1ParentId ?? ""
                self?.get_StorageLocationByParentLocation_API_Call()
                
            }
    }
    @IBOutlet var storageLocation2Button: UIButton!
    @IBAction func onClickStorageLocation3Button(_ sender: UIButton) {
        var storageLocArr = [String]()
        var storageLocation2IdsArr = [String]()
        var storageLocation2ParentArr = [String]()
        
        for obj in storageLocationArr2 {
            
            storageLocArr.append(obj.slocName ?? "")
            storageLocation2IdsArr.append(obj._id ?? "")
            storageLocation2ParentArr.append(obj.parentLocation ?? "")
        }
        
        dropDown.dataSource = storageLocArr//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.storageLocation3Button.setTitle(item as String, for: UIControl.State.normal)
                self?.selectedStorage2Id = (self?.storageLocationIdsArr[index])!
//                self?.selectedStorage2ParentId = (self?.storageLocation2ParentArr[index])!
//                self?.storageLocationTF.text = item
                self?.dict.setValue(item, forKey: "storageLocation2")
                self?.dict.setValue(self?.selectedStorage2Id, forKey: "storageLocation2Id")
                
            }
    }
    @IBOutlet var storageLocation3Button: UIButton!
    
    @IBAction func onClickStorageMasterButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Vendor", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "StorageLocationMasterVC") as! StorageLocationMasterVC
        VC.modalPresentationStyle = .fullScreen
//                    VC.isAddProd = "1"
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBOutlet var storageButton: UIButton!
    // MARK: Get AddressBook API Call
    func get_PriceUnit_API_Call() {
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let urlStr = Constants.BaseUrl + priceUnitUrl
        
        addProdSerCntrl.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:PriceUnitRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            DispatchQueue.main.async {
                
                let status = respVo.statusCode
                let message = respVo.status
                
                if status == 200 {
                    
                    if message == "SUCCESS" {
                        if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            self.priceUnitsArr = respVo.result!
                            self.priceUnitButton.setTitle(respVo.result![0].priceUnit ?? "" ,for: UIControl.State.normal)
            //                self?.priceUnitTF.text = item
                            self.dict.setValue(respVo.result![0].priceUnit ?? "", forKey: "priceUnit")
                            self.dict.setValue(respVo.result![0]._id ?? "", forKey: "priceUnitId")
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
        
        servcCntrl.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:StockUnitMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            DispatchQueue.main.async {
                
                let status = respVo.STATUS_CODE
                let message = respVo.STATUS_MSG
                
                if status == 200 {
                    if message == "SUCCESS" {
                        if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            
                            self.stockUnitsArr = respVo.result!
                            self.stockUnitButton.setTitle(respVo.result![0].stockUnitName ?? "", for: UIControl.State.normal)
                            self.dict.setValue(respVo.result![0].stockUnitName ?? "", forKey: "stockUnit")
                            self.dict.setValue(respVo.result![0]._id ?? "", forKey: "stockUnitId")
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
    func get_storageLocationMaster_API_Call() {
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let urlStr = Constants.BaseUrl + vendorGetStorageLocationUrl + accountID
        
        servcCntrl.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:GetStorageLocationMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            DispatchQueue.main.async {
                
                let status = respVo.STATUS_CODE
                let message = respVo.STATUS_MSG
                
                if status == 200 {
                    if message == "SUCCESS" {
                        if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            
                            self.storageLocationArr = respVo.result!
                            self.storageLocation1Button.setTitle(respVo.result![0].slocName ?? "", for: UIControl.State.normal)
                            self.dict.setValue(respVo.result![0].slocName ?? "", forKey: "storageLocation")
                            self.dict.setValue(respVo.result![0]._id ?? "", forKey: "storageLocationId")
                            self.dict.setValue("", forKey: "storageLocation1")
                            self.dict.setValue("", forKey: "storageLocation1Id")
                            self.dict.setValue("", forKey: "storageLocation2")
                            self.dict.setValue("", forKey: "storageLocation2Id")
                            self.hierachyLevel = "2"
                            self.parentLocation = respVo.result![0].slocName ?? ""
                            self.get_StorageLocationByParentLocation_API_Call()
                        }
                        else {
                            
                        }
                    }
                    }
                }
                else {
                    self.view.makeToast(message)
                }
            }
        }) { (error) in
//            self.view.makeToast("app.SomethingWentToWrongAlert".localize())
            print("Oops, your connection seems off... Please try again later")
        }
    }
    var myProductArray=NSMutableArray()
    var parentLocation=String()
    // MARK: Get Storage Location Master API Call
      func get_StorageLocationByParentLocation_API_Call() {
       
          let defaults = UserDefaults.standard
          accountID = (defaults.string(forKey: "accountId") ?? "")
        let newString = parentLocation.replacingOccurrences(of: " ", with: "%20")
          let urlStr = Constants.BaseUrl + getAllStorageLocationByParentUrl + "\(hierachyLevel)/" + "\(newString)/" + accountID
          
          servcCntrl.requestGETURL(strURL: urlStr, success: {(result) in
              
              let respVo:GetStorageLocationMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
              
              DispatchQueue.main.async {
                  
                  let status = respVo.STATUS_CODE
                  let message = respVo.STATUS_MSG
                  
                  if status == 200 {
                      if message == "SUCCESS" {
                          if respVo.result != nil {
                          if respVo.result!.count > 0 {
                            
                            if self.hierachyLevel=="2"
                              {
                                self.storageLocationArr1.removeAll()
                              self.storageLocationArr1 = respVo.result!
                                self.hierachyLevel = "3"
                                self.parentLocation = respVo.result![0].slocName ?? ""
                                self.storageLocation2Button.setTitle(respVo.result![0].slocName ?? "", for: .normal)
                                if self.buttonTap=="tap"
                                {
                                  
                                    self.dict.setValue(respVo.result![0].slocName ?? "", forKey: "storageLocation1")
                                    self.dict.setValue(respVo.result![0]._id ?? "", forKey: "storageLocation1Id")
                                }
                                self.get_StorageLocationByParentLocation_API_Call()
                                
                              }
                            else if self.hierachyLevel=="3"
                            {
                                self.storageLocationArr2.removeAll()
                                self.storageLocationArr2 = respVo.result!
                                self.storageLocation3Button.setTitle(respVo.result![0].slocName ?? "", for: .normal)
                                if self.buttonTap=="tap"
                                {
                                   
                                    self.dict.setValue(respVo.result![0].slocName ?? "", forKey: "storageLocation2")
                                    self.dict.setValue(respVo.result![0]._id ?? "", forKey: "storageLocation2Id")
                                    self.buttonTap=""
                                }
                            }
                           
                            
                              
                          }
                          else {
                            if self.hierachyLevel=="2" {
                                
                                self.storageLocationArr1.removeAll()
                                self.buttonTap=""
                            }
                            else if self.hierachyLevel=="3" {
                                
                                self.storageLocationArr2.removeAll()
                                self.buttonTap=""
                            }
                          }
                      }
                      }
                  }
                  else {
                      self.view.makeToast(message)
                  }
              }
          }) { (error) in
  //            self.view.makeToast("app.SomethingWentToWrongAlert".localize())
              print("Oops, your connection seems off... Please try again later")
          }
      }

    override func viewDidAppear(_ animated: Bool) {
             super.viewDidAppear(animated)
        
//        loadScrollViewData()

         }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        
        get_storageLocationMaster_API_Call()
        get_StockUnitMaster_API_Call()
        getVendorListDataFromServer()
        get_PriceUnit_API_Call()
        getCategoriesDataFromServer()
        getSubCategoriesDataFromServer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadScrollViewData()
        }
        
       }
    
    @IBAction func onTappedDoneBtn(_ sender: Any) {
  

        let selectedDataArray = NSMutableArray()
        for i in 0..<myProductsArray.count {
            let dataDict = myProductsArray.object(at: i) as? NSDictionary
        let isActiveStr = dataDict?.value(forKey: "isActive") as? String
        
        if(isActiveStr == "0"){
//                myProductsArray.removeObject(at: i)
//                break
        }else{
            selectedDataArray.add(dataDict!)
        }
        }
        let finalArray=NSMutableArray()
        let mainAddProductArray=addProductArray
        if selectedDataArray.count>0
        {
            
            let completeProductCount=selectedDataArray.count+mainAddProductArray.count
            if completeProductCount>20
            {
                    let ccount=String(20-mainAddProductArray.count)
                    self.view.makeToast("You can select only "+"\(ccount)"+" product(s) in this cycle of bill scan ")
                }
            else
            {
                
            finalArray.addObjects(from: mainAddProductArray as! [Any])
            
        for i in 0..<selectedDataArray.count {
            let dataDict = selectedDataArray.object(at: i) as? NSDictionary
            
            if let stockInt = Float(dataDict?.value(forKey: "stockQuantity")as? String ?? "")
            {
                dataDict?.setValue(false, forKey: "stockwarn")
            if selectedBillPriceScan=="Price Per Unit"
            {
                if let unitPriceInt = Float(dataDict?.value(forKey: "unitPrice")as? String ?? "")
                {
                    let stockQuan:Float=Float(dataDict?.value(forKey: "stockQuantity")as? String ?? "") ?? 0
                    let pricePer:Float=Float(dataDict?.value(forKey: "unitPrice")as? String ?? "") ?? 0
                    let pprice=stockQuan * pricePer
                    dataDict?.setValue(String(format:"%.2f", pprice), forKey: "price")
                    dataDict?.setValue(false, forKey: "unitPricewarn")
                }
                else
                {
                    dataDict?.setValue(true, forKey: "unitPricewarn")
                    self.showAlertWith(title: "Alert", message: "Please enter valid Integer value")
                    self.loadScrollViewData()
                }
            }
            else
            {
                if let priceInt = Float(dataDict?.value(forKey: "price")as? String ?? "")
                {
                    let stockQuan:Float=Float(dataDict?.value(forKey: "stockQuantity")as? String ?? "") ?? 0
                    let pricePer:Float=Float(dataDict?.value(forKey: "price")as? String ?? "") ?? 0
                    if stockQuan != 0 || pricePer != 0
                    {
                    let pprice=pricePer / stockQuan
                    dataDict?.setValue(String(format:"%.2f", pprice), forKey: "unitPrice")
                    }
                    dataDict?.setValue(false, forKey: "pricewarn")
                }
                else
                {
                    dataDict?.setValue(true, forKey: "pricewarn")
                    self.showAlertWith(title: "Alert", message: "Please enter valid Integer value")
                    self.loadScrollViewData()
                }
            }
            
            dataDict?.setValue(dict.value(forKey: "stockUnit"), forKey: "stockUnit")
            dataDict?.setValue(dict.value(forKey: "stockUnitId"), forKey: "stockUnitId")
            dataDict?.setValue(dict.value(forKey: "vendorName"), forKey: "vendorName")
            dataDict?.setValue(dict.value(forKey: "vendorId"), forKey: "vendorId")
            dataDict?.setValue(dict.value(forKey: "category"), forKey: "category")
            dataDict?.setValue(dict.value(forKey: "categoryId"), forKey: "categoryId")
            dataDict?.setValue(dict.value(forKey: "subCategory"), forKey: "subCategory")
            dataDict?.setValue(dict.value(forKey: "subCategoryId"), forKey: "subCategoryId")
            dataDict?.setValue(dict.value(forKey: "storageLocation"), forKey: "storageLocation")
            dataDict?.setValue(dict.value(forKey: "storageLocationId"), forKey: "storageLocationId")
            dataDict?.setValue(dict.value(forKey: "storageLocation1"), forKey: "storageLocation1")
            dataDict?.setValue(dict.value(forKey: "storageLocation1Id"), forKey: "storageLocation1Id")
            dataDict?.setValue(dict.value(forKey: "storageLocation2"), forKey: "storageLocation2")
            dataDict?.setValue(dict.value(forKey: "storageLocation2Id"), forKey: "storageLocation2Id")
            dataDict?.setValue(dict.value(forKey: "priceUnit"), forKey: "priceUnit")
            dataDict?.setValue(dict.value(forKey: "priceUnitId"), forKey: "priceUnitId")
                dataDict?.setValue(billDateTF.text, forKey: "purchaseDate")
                dataDict?.setValue(billNumberTF.text, forKey: "orderId")
        
                
                finalArray.add(dataDict)
                print("Final Arr is \(finalArray.count)")
        
       // self.delegate?.sendPropertyDetails(data:selectedDataArray, idStr: "")

        }
            else
            {
                // "stockwarn":false,"unitPricewarn":false,"pricewarn":false
                dataDict?.setValue(true, forKey: "stockwarn")
                if let unitPriceInt = Float(dataDict?.value(forKey: "unitPrice")as? String ?? "")
                {
                    dataDict?.setValue(false, forKey: "unitPricewarn")
                }
                else
                {
                    dataDict?.setValue(true, forKey: "unitPricewarn")
                }
                if let priceInt = Float(dataDict?.value(forKey: "price")as? String ?? "")
                {
                    dataDict?.setValue(false, forKey: "pricewarn")
                }
                else
                {
                    dataDict?.setValue(true, forKey: "pricewarn")
                }
                self.showAlertWith(title: "Alert", message: "Please enter valid Integer value")
                self.loadScrollViewData()
            }
        }
                if billDateTF.text != ""
                {
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "dd/MM/yyyy"

                    if dateFormatterGet.date(from: billDateTF.text ?? "") != nil
                    {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyBoard.instantiateViewController(withIdentifier: "AddProductVC") as! AddProductViewController
        //        VC.modalPresentationStyle = .fullScreen
        //        self.present(VC, animated: true, completion: nil)
                VC.isBillScan = "BillScan"
                
                        VC.myProductArray = finalArray
                self.navigationController?.pushViewController(VC, animated: true)
                    }
                        else {
                        self.warnButton.isHidden=false
                    }
                }
                else
                {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "AddProductVC") as! AddProductViewController
    //        VC.modalPresentationStyle = .fullScreen
    //        self.present(VC, animated: true, completion: nil)
            VC.isBillScan = "BillScan"
            
                    VC.myProductArray = finalArray
            self.navigationController?.pushViewController(VC, animated: true)
                }
        }
        }
        else
        {
            self.showAlertWith(title: "Alert", message: "Please select products")
        }
        
       
    }
    
    var isSelected:Bool?
    
    @IBAction func onTapped_CheckBtn(_ sender: Any) {
   
       if checkBtn1.isSelected {
        self.checkBtn1.isSelected = false
        
        checkBtn2.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
        checkBtn3.setImage(UIImage(named: "checkBoxInactive"), for: .normal)

        }
        else  {
            self.checkBtn1.isSelected = true
        
        checkBtn2.setImage(UIImage(named: "checkBoxActive"), for: .normal)
        checkBtn3.setImage(UIImage(named: "checkBoxActive"), for: .normal)

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
    
    @IBAction func onTap_BackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func checkBoxBtnTap(_ sender: UIButton)  {
        
        var dict = NSMutableDictionary()
        dict = myProductsArray[sender.tag] as! NSMutableDictionary
        
        if sender.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
            sender.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
            dict.setValue("1", forKey: "isActive")
            
        }else{
            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
            dict.setValue("0", forKey: "isActive")

        }
        
        myProductsArray.replaceObject(at: sender.tag, with: dict)

    }
    
    @objc func checkBoxAllBtnTap(_ sender: UIButton){
        
        for j in 0..<myProductsArray.count {
            
            let dataDict = myProductsArray.object(at: j) as? NSDictionary

            if(isSelectAll == "0"){
                dataDict?.setValue("1", forKey: "isActive")
                myProductsArray.replaceObject(at: j, with: dataDict!)
                
            }else{
                dataDict?.setValue("0", forKey: "isActive")
                myProductsArray.replaceObject(at: j, with: dataDict!)

            }
        }
        
        if(isSelectAll == "0"){
            isSelectAll = "1"
            
        }else{
            isSelectAll = "0"
        }
        
        loadScrollViewData()
        
        
        
        
//        if(isSelectAll == "0"){
//            sender.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
//            isSelectAll = "1"
//
//        }else{
//            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
//            isSelectAll = "0"
//        }
        
//        if sender.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
//            sender.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
//
//        }else{
//            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
//
//        }
        
    }
    @IBOutlet var mainScrollView: UIScrollView!
    
     var dataScrollView = UIScrollView()
    @IBOutlet var backViewHeight: NSLayoutConstraint!
    func loadScrollViewData() {
        
       dataScrollView.removeFromSuperview()
        
        dataScrollView = UIScrollView()
        dataScrollView.frame = CGRect(x: 0, y: self.storageButton.frame.origin.y+self.storageButton.frame.size.height+20, width: self.view.frame.size.width, height: 100)
////        dataScrollView.backgroundColor = hexStringToU10IColor(hex: "0078fa")
        dataScrollView.bounces = false
        
       
       // dataScrollView.backgroundColor = .orange
        
        var xValue = 0
        var yValue = 0
        
        for j in 0...myProductsArray.count {
                
                xValue = 685
                                
                yValue = yValue + 40
            }
        dataScrollView.frame.size.height=CGFloat(yValue)
        dataScrollView.contentSize = CGSize(width: xValue, height: yValue)
      
        self.tableView.frame=CGRect(x: 0, y: 0, width: xValue, height: yValue)
        dataScrollView.addSubview(tableView)
        tableView.reloadData()
        backVieww.addSubview(dataScrollView)
        self.backViewHeight.constant += CGFloat(yValue)
        //contentView.frame.size.height =  self.backViewHeight.constant
      //  mainScrollView.frame.size.height = backVieww.frame.size.height
        }
    
    @objc func onClickWarnButton()
    {
        self.showAlertWith(title: "Alert", message: "Please enter valid Integer value")
    }
    @IBOutlet var dataView: UIView!
    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var productTagValue = Int()
        
        var productArrayPosition = Int()
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
        dict = myProductsArray[productArrayPosition] as! NSMutableDictionary
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
       

        print(productArrayPosition)
        print(productTagValue)
        if(productTagValue == 1001){ //Product Name
            let aa=decimalPlaces(stt: newString)
            if aa>2 {
                return false
            }
            else
            {
            if selectedBillPriceScan=="Price Per Unit"
            {
                textField.text=newString
               // dict.setValue(newString, forKey: "unitPrice")
            }
            else
            {
                textField.text=newString
                //dict.setValue(newString, forKey: "price")
            }
            }
        }
        if(productTagValue == 1002){
            let aa=decimalPlaces(stt: newString)
            if aa>3 {
               return false
            }
            else
            {
            textField.text=newString
            //dict.setValue(newString, forKey: "stockQuantity")
            }
        }
   /*   if(productTagValue == 1001){ //Price Per Stock Unit

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
        if(productTagValue == 1002){ // Stock Quantity

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
*/

        return true
   }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        var productTagValue = Int()
        
        var productArrayPosition = Int()
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
        dict = myProductsArray[productArrayPosition] as! NSMutableDictionary

        print(productArrayPosition)
        print(productTagValue)
       
//        if productTagValue == 1000{ //Product ID
//
//            print("Product ID")
//            print(textField.tag)
//
//            dict.setValue(textField.text, forKey: "productName")
//
//        }else
        if(productTagValue == 1001){ //Product Name
            
            if selectedBillPriceScan=="Price Per Unit"
            {
                dict.setValue(textField.text, forKey: "unitPrice")
                if let unitPriceInt = Float(dict.value(forKey: "unitPrice")as? String ?? "")
                {
                    dict.setValue(false, forKey: "unitPricewarn")
                }
                else
                {
                    dict.setValue(true, forKey: "unitPricewarn")
                }
            }
            else
            {
               dict.setValue(textField.text, forKey: "price")
                if let priceInt = Float(dict.value(forKey: "price")as? String ?? "")
                {
                    dict.setValue(false, forKey: "pricewarn")
                }
                else
                {
                    dict.setValue(true, forKey: "pricewarn")
                }
            }
            

        }else if(productTagValue == 1002){ //Stock Quantity
            
            dict.setValue(textField.text, forKey: "stockQuantity")
            if let stockInt = Float(dict.value(forKey: "stockQuantity")as? String ?? "")
            {
                dict.setValue(false, forKey: "stockwarn")
            }
            else
            {
                dict.setValue(true, forKey: "stockwarn")
            }
            
        }
//        if textField=billDateTF
//        {
//            if billDateTF.text !=
//        }
        myProductsArray.replaceObject(at: productArrayPosition, with: dict)
        print(myProductsArray)
        self.loadScrollViewData()
        
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProductsArray.count+1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertiesShowTableViewCell", for: indexPath) as! PropertiesShowTableViewCell
        
        
        if indexPath.row==0
        {
            cell.nameTextView.text="Item Name"
            cell.nameTextView.isUserInteractionEnabled=false
            if selectedBillPriceScan=="Price Per Unit"
            {
            cell.priceTF.text="Price Per Unit"
            }
            else
            {
                cell.priceTF.text="Total Price"
            }
            cell.priceTF.isUserInteractionEnabled=false
            cell.quantityTF.text="Quantity"
            cell.quantityTF.isUserInteractionEnabled=false
            cell.checkButton.addTarget(self, action: #selector(checkBoxAllBtnTap), for: .touchUpInside)
            
            if(isSelectAll == "0"){
                cell.checkButton.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
           
            }else{
                cell.checkButton.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
            }
           
                cell.priceWarn.isUserInteractionEnabled=false
                cell.quantityWarn.isUserInteractionEnabled=false
                cell.priceWarn.isHidden=true
                cell.quantityWarn.isHidden=true
          
        }
        if indexPath.row>0
        {
            let dataDict=myProductsArray[indexPath.row - 1]as? NSDictionary
            cell.nameTextView.text=dataDict?.value(forKey: "productName") as? String
            cell.nameTextView.isUserInteractionEnabled=true
            cell.nameTextView.tag=Int("1000" + String(indexPath.row-1)) ?? 0
            if selectedBillPriceScan=="Price Per Unit"
            {
                if let pp=dataDict?.value(forKey: "unitPrice") as? String
                {
                cell.priceTF.text=pp
                }
                else if let pp=dataDict?.value(forKey: "unitPrice") as? Float
                {
                    cell.priceTF.text=String(pp)
                }
            }
            else
            {
                if let pp=dataDict?.value(forKey: "price") as? String
                {
                cell.priceTF.text=pp
                }
                else if let pp=dataDict?.value(forKey: "price") as? Float
                {
                    cell.priceTF.text=String(pp)
                }
            }
            cell.priceTF.tag = Int("1001" + String(indexPath.row-1)) ?? 0
            cell.priceTF.isUserInteractionEnabled=true
            cell.priceTF.delegate=self
            if let pp=dataDict?.value(forKey: "stockQuantity") as? String
            {
            cell.quantityTF.text=pp
            }
            else if let pp=dataDict?.value(forKey: "stockQuantity") as? Float
            {
                cell.quantityTF.text=String(pp)
            }
            cell.quantityTF.tag=Int("1002" + String(indexPath.row-1)) ?? 0
            cell.quantityTF.isUserInteractionEnabled=true
            cell.quantityTF.delegate=self
            cell.checkButton.addTarget(self, action: #selector(checkBoxBtnTap), for: .touchUpInside)
            cell.checkButton.tag = indexPath.row - 1
            let isActiveStr = dataDict?.value(forKey: "isActive") as? String
            
            if(isActiveStr == "1"){
                cell.checkButton.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
            }
            else
            {
                cell.checkButton.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
            }
            if dataDict?.value(forKey: "unitPricewarn")as? Bool==false
            {
                cell.priceWarn.isUserInteractionEnabled=false
                cell.quantityWarn.isUserInteractionEnabled=false
                cell.priceWarn.isHidden=true
                cell.quantityWarn.isHidden=true
            }
            else
            {
                cell.priceWarn.isUserInteractionEnabled=true
                cell.quantityWarn.isUserInteractionEnabled=true
                cell.priceWarn.isHidden=false
                cell.quantityWarn.isHidden=false
            cell.priceWarn.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
            cell.quantityWarn.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
            }
        }
         return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        var productTagValue = Int()
        
        var productArrayPosition = Int()
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
        
        var dict = NSMutableDictionary()
        dict = myProductsArray[productArrayPosition] as! NSMutableDictionary

        print(productArrayPosition)
        print(productTagValue)
       
        if productTagValue == 1000{ //Product ID

            print("Product ID")
            print(textView.tag)

            dict.setValue(textView.text, forKey: "productName")

        }
    }
    }
