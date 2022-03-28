//
//  EditUpdateInventoryViewController.swift
//  Lekha
//
//  Created by USM on 03/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown

protocol updateCurrentInventory {
    func updateCurrentInventoryDetails(fieldname:NSDictionary,idStr:String)
}
class EditUpdateInventoryViewController: UIViewController,sentname,sendDetails,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var pricePerWarn: UIButton!
    @IBOutlet var productNameWarn: UIButton!
    var nameWarn:Bool=false
    var pricePerWarnD:Bool=false
    @IBOutlet weak var vendorMastersBtn: UIButton!
    @IBOutlet weak var productChangeHistoryLbl: UILabel!
    
    @IBOutlet weak var scrollViewHeightConstant: NSLayoutConstraint!
    var delegate:updateCurrentInventory?
    var userDefaults=UserDefaults.standard
    @IBAction func vendorMasterBtnTapped(_ sender: Any) {
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
    
    @IBAction func homeBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
        self.navigationController?.pushViewController(VC, animated: true)

    }
    func sendnamedfields(fieldname: String, idStr: String) {
        
        if(isCategory == "1"){
            
            selectedCatStr = fieldname
            selectedCategoryID = fieldname
            categoryBtn.setTitle(fieldname, for: .normal)
            
            subCategoryBtn.setTitle("", for: .normal)
            
        }else{
            subCategoryBtn.setTitle(fieldname, for: .normal)

        }
        
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }
    
    func details(titlename: String, type: String, countrycode: String) {
        
    }
    

    @IBOutlet weak var prodImg1: UIButton!
    @IBOutlet weak var prodImg2: UIButton!
    @IBOutlet weak var prodImg3: UIButton!
    let dropDown = DropDown()
    @IBOutlet weak var prodIDTF: UITextField!
    @IBOutlet weak var prodNameTF: UITextField!
    @IBOutlet weak var prodDescTF: UITextView!
    @IBOutlet weak var stockQtyTF: UITextField!
    @IBOutlet weak var stockUnitTF: UITextField!
    @IBOutlet var stockUnitButton: UIButton!
    var servcCntrl = ServiceController()
    @IBAction func stockUnitMaster(_ sender: UIButton) {
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
    var addProdServiceCntrl = ServiceController()
    var dict = NSMutableDictionary()
    @IBAction func onClickStockUnitButton(_ sender: UIButton) {
        let productArrayPosition : Int = sender.tag%10
        let productTagValue:Int = sender.tag / 10;
        var stockListArr = [String]()
        stockUnitIdsArr=[String]()
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
    var priceUnitNamesArr = [String]()
    var priceUnitsArr = [PriceUnitResultVo]()
    var priceUnitIdsArr = [String]()
    @IBOutlet var priceUnitButton: UIButton!
    @IBAction func onClickpriceUnitButton(_ sender: UIButton) {
        let productArrayPosition : Int = sender.tag%10
        let productTagValue:Int = sender.tag / 10;
         priceUnitNamesArr = [String]()
        priceUnitIdsArr = [String]()
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
//                self?.priceUnitTF.text = ite
                self?.dict.setValue(item, forKey: "priceUnit")
                let priceUnitID = self?.priceUnitIdsArr[index]
                self?.dict.setValue(priceUnitID, forKey: "priceUnitId")
            }
    }
    // MARK: Get AddressBook API Call
    func get_PriceUnit_API_Call() {
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let urlStr = Constants.BaseUrl + priceUnitUrl
        
        editServiceCntrl.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:PriceUnitRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            DispatchQueue.main.async {
                
                let status = respVo.statusCode
                let message = respVo.status
                
                if status == 200 {
                    
                    if message == "SUCCESS" {
                        if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            self.priceUnitsArr = respVo.result!
                            
                            for obj in self.priceUnitsArr {

                                self.dict.setValue(obj.priceUnit, forKey: "priceUnit")
                                self.dict.setValue(obj._id, forKey: "priceUnitId")

                            }
    //                        let priceStr = self.priceUnitNamesArr[0]
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
    @IBOutlet weak var expiryDateBtn: UIButton!
   
    @IBOutlet weak var purchaseDateBtn: UIButton!
    
    @IBOutlet weak var storageLocTF: UITextField!
    @IBOutlet var storageLocButton: UIButton!
    var buttonTap=String()
        var buttonPosition=Int()
            
    @IBAction func onClickstorageLocButton(_ sender: UIButton) {
        buttonTap="tap"
        
        var productArrayPosition = Int()
        var productTagValue=Int()
     
         productArrayPosition = sender.tag%10
         productTagValue = sender.tag / 10;
            
     
        buttonPosition=productArrayPosition
        var storageLocArr = [String]()
       storageLocationIdsArr=[String]()
        storageLocationParentArr=[String]()
       
        for obj in storageLocationArr {
            let ddict=obj as? NSDictionary
            if ddict?.value(forKey: "hierachyLevel")as? Int == 1 {
                
                storageLocArr.append(ddict?.value(forKey:"slocName")as? String ?? "")
                storageLocationIdsArr.append(ddict?.value(forKey:"_id")as? String ?? "")
                storageLocationParentArr.append(ddict?.value(forKey:"parentLocation")as? String ?? "")
            }
            
        }
        
        dropDown.dataSource = storageLocArr//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.storageLocButton.setTitle(item as String, for: UIControl.State.normal)
                self?.selectedStorageId = (self?.storageLocationIdsArr[index])!
                self?.selectedStorageParentId = (self?.storageLocationParentArr[index])!
//                self?.storageLocationTF.text = item
                self?.dict.setValue(item, forKey: "storageLocation")
                self?.dict.setValue(self?.selectedStorageId, forKey: "storageLocationId")
                self?.dict.setValue("", forKey: "storageLocation1")
                self?.dict.setValue("", forKey: "storageLocation1Id")
                self?.dict.setValue("", forKey: "storageLocation2")
                self?.dict.setValue("", forKey: "storageLocation2Id")
                self?.storageLoc1Button.setTitle("", for: UIControl.State.normal)
                self?.storageLoc2Button.setTitle("", for: UIControl.State.normal)
                self?.hierachyLevel="2"
                self?.parentLocation=item
                self?.storageLocationArr1.removeAllObjects()
                self?.storageLocationArr2.removeAllObjects()
                self?.get_StorageLocationByParentLocation_API_Call()
            }
    }
    @IBAction func storageLocationMaster(_ sender: UIButton) {
        if userDefaults.bool(forKey: "vendorManStatus")==false
        {
            self.showAlertWith(title: "Alert", message: "You are not authorized to access this module")
        }
        else
        {
        let storyBoard = UIStoryboard(name: "Vendor", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "StorageLocationMasterVC") as! StorageLocationMasterVC
        VC.modalPresentationStyle = .fullScreen
//                    VC.isAddProd = "1"
        self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    @IBOutlet var storageLoc1Button: UIButton!
    @IBAction func onClickstorageLoc1Button(_ sender: UIButton) {
     
       
        let productArrayPosition : Int = sender.tag%10
        let productTagValue:Int = sender.tag / 10;
        var storageLocArr = [String]()
        var storageLocation1IdsArr = [String]()
        var storageLocation1ParentArr = [String]()
        
        for obj in storageLocationArr1 {
            let ddict=obj as? NSDictionary
            storageLocArr.append(ddict?.value(forKey:"slocName")as? String ?? "")
            storageLocation1IdsArr.append(ddict?.value(forKey:"_id")as? String ?? "")
            storageLocation1ParentArr.append(ddict?.value(forKey:"parentLocation")as? String ?? "")
        }
        
        dropDown.dataSource = storageLocArr//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.storageLoc1Button.setTitle(item as String, for: UIControl.State.normal)
                self?.selectedStorage1Id = (self?.storageLocationIdsArr[index])!
                self?.selectedStorage1ParentId = (self?.storageLocation1ParentArr[index])!
//                self?.storageLocationTF.text = item
                self?.dict.setValue(item, forKey: "storageLocation1")
                self?.dict.setValue(self?.selectedStorage1Id, forKey: "storageLocation1Id")
                self?.hierachyLevel="3"
                self?.parentLocation=self?.selectedStorage1ParentId ?? ""
                self?.get_StorageLocationByParentLocation_API_Call()
        
            }
    }
    @IBOutlet var storageLoc2Button: UIButton!
    @IBAction func onClickstorageLoc2Button(_ sender: UIButton) {
        
        let productArrayPosition : Int = sender.tag%10
        let productTagValue:Int = sender.tag / 10;
        var storageLocArr = [String]()
        var storageLocation2IdsArr = [String]()
        var storageLocation2ParentArr = [String]()
        for obj in storageLocationArr2 {
            let ddict=obj as? NSDictionary
            storageLocArr.append(ddict?.value(forKey:"slocName")as? String ?? "")
            storageLocation2IdsArr.append(ddict?.value(forKey:"_id")as? String ?? "")
            storageLocation2ParentArr.append(ddict?.value(forKey:"parentLocation")as? String ?? "")
        }
        
        dropDown.dataSource = storageLocArr//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.storageLoc2Button.setTitle(item as String, for: UIControl.State.normal)
                self?.selectedStorage2Id = (self?.storageLocationIdsArr[index])!
                self?.selectedStorage2ParentId = (self?.storageLocation2ParentArr[index])!
//                self?.storageLocationTF.text = item
                self?.dict.setValue(item, forKey: "storageLocation2")
                self?.dict.setValue(self?.selectedStorage2Id, forKey: "storageLocation2Id")
                
            }
    }
    @IBOutlet weak var categoryBtn: UIButton!
   
    @IBOutlet weak var subCategoryBtn: UIButton!
   
    @IBOutlet weak var orderIDTF: UITextField!
    @IBOutlet weak var vendorIDTF: UITextField!
    @IBOutlet var vendorIDButton: UIButton!
    @IBAction func onClickvendorIDButton(_ sender: UIButton) {
        
        let productArrayPosition : Int = sender.tag%10
        let productTagValue:Int = sender.tag / 10;
        var vendorNameListArr = [String]()
        vendorMastersIdsArr=[String]()
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
                self?.vendorIDButton.setTitle(item as String, for: UIControl.State.normal)
                self?.dict.setValue(item, forKey: "vendor")
                self?.dict.setValue(self?.selectedVendorId, forKey: "vendorId")
            }
    }
    @IBOutlet weak var borrowedCheckBtn: UIButton!
    @IBOutlet weak var sharedCheckBtn: UIButton!
    @IBOutlet weak var pricePerStockUnitTF: UITextField!
    @IBOutlet weak var totalPriceTF: UITextField!
    
    @IBOutlet var modifiedTableHeight: NSLayoutConstraint!
    
    var editServiceCntrl = ServiceController()
    var prodIDStr = String()
    var editInventoryResult = [EditInventoryResult]()
    
    var prodModifyArray = NSMutableArray()
    
    var productID = String()
    
    var categoryResult = [CategoryResult]()
    var subCategoryResult = [SubCategoryResult]()
    
    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
    var picker : UIDatePicker = UIDatePicker()
    
    var isExpiryDate = String()
    var selectedCategoryID =  String()
    var isCategory = String()
    var selectedCatStr = String()
    var prodImgStr = String()
    
    var accountID = String()
    
    var categoryDataArray = NSMutableArray()
    var categoryIDArray = NSMutableArray()
    
    var prodImgArray = NSMutableArray()
    var storageLocationArr = NSMutableArray()
    var storageLocationArr1 = NSMutableArray()
    var storageLocationArr2 = NSMutableArray()
    var stockUnitsArr = [StockUnitMasterResultVo]()
    var vendorListResult = [VendorListResult]()
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
    
    @IBOutlet weak var productChangeHistTblView: UITableView!


    @IBAction func prod1ImgBtnTapped(_ sender: Any) {
        
        prodImgStr = "1"
        self.loadActionSheet()
    }
    
    @IBAction func prod2ImgBtnTapped(_ sender: Any) {
        prodImgStr = "2"
        
        self.loadActionSheet()
    }
    
    @IBAction func prod3ImgBtnTapped(_ sender: Any) {
        
        prodImgStr = "3"

        self.loadActionSheet()

    }
    func loadActionSheet()  {
        
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                 
                 if let imagePick = info[UIImagePickerController.InfoKey.originalImage] {
                    
                    let imageData: Data? = (imagePick as! UIImage).jpegData(compressionQuality: 0.4)
                    let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
                    
                    let myProdDict = NSMutableDictionary()
                    
                    if(prodImgStr == "1"){
                        prodImg1.setImage(imagePick as? UIImage, for: .normal)
                        
                        myProdDict.setValue(imageStr, forKey: "productImage")
                        prodImgArray.replaceObject(at: 0, with: myProdDict)

                    }else if(prodImgStr == "2"){
                        prodImg2.setImage(imagePick as? UIImage, for: .normal)
                        
                        myProdDict.setValue(imageStr, forKey: "productImage")
                        prodImgArray.replaceObject(at: 1, with: myProdDict)


                    }else{
                        prodImg3.setImage(imagePick as? UIImage, for: .normal)

                        myProdDict.setValue(imageStr, forKey: "productImage")
                        prodImgArray.replaceObject(at: 2, with: myProdDict)

                    }

             }
                 else{

                 //Error Message
                 }
//                 self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

        }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
       if(prodNameTF.text == ""){
        self.nameWarn=true
        self.productNameWarn.isHidden=false
        }
       else
       {
        self.nameWarn=false
        self.productNameWarn.isHidden=true
       }
        if(pricePerStockUnitTF.text == ""){
            self.pricePerWarnD=true
            self.pricePerWarn.isHidden=false

        }
        else
        {
            self.pricePerWarnD=false
            self.pricePerWarn.isHidden=true
        }
        if self.nameWarn==true || self.pricePerWarnD==true
            {
            
        }
        else{
            UpdateCurrentInventoryDataAPI()
            
        }
    }
    
    @IBAction func expiryDateBtnTapped(_ sender: Any) {
        isExpiryDate = "1"
        datePickerView()
        
    }
    
    @IBAction func purchaseDateBtnTapped(_ sender: Any) {
        isExpiryDate = "0"
        datePickerView()

    }
    var catSubCatArrPosition : Int!
    var catSubCatIndexPosition : Int!
    var catSubCatTagValue : Int!
    var subbuttonTap=String()
    var subbuttonTapPositon=Int()
    
    @IBAction func categoryBtnTapped(_ sender: UIButton) {
        
        let productArrayPosition : Int = sender.tag%10
        let productTagValue:Int = sender.tag / 10;

        catSubCatTagValue = sender.tag as Int
        catSubCatArrPosition = productArrayPosition as Int
        catSubCatIndexPosition = productTagValue as Int
        subbuttonTap="tap"
            
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
                    self?.categoryBtn.setTitle(item as String, for: UIControl.State.normal)
                    let selectedId = self?.categoryIDArray[index]
                    self?.dict.setValue(item, forKey: "category")
                    self?.dict.setValue(selectedId, forKey: "categoryId")
                    self?.selectedCategoryStr = item
                    self?.selectedCategoryID = (selectedId as? String)!
                    self?.getSubCategoriesDataFromServer()
                }
            
    }
    
    @IBAction func subCategoryBtnTapped(_ sender: UIButton) {
        
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
                    self?.subCategoryBtn.setTitle(item as String, for: UIControl.State.normal)
                    self?.dict.setValue(item, forKey: "subCategory")
                    let selecteSubId = self?.categoryIDArray[index]
                    self?.dict.setValue(selecteSubId, forKey: "subCategoryId")
                }
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productChangeHistoryLbl.isHidden = true
        productChangeHistTblView.isHidden = true
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        isExpiryDate = ""
        selectedCatStr = ""
        
        var prodImgDict = NSMutableDictionary()
        
        for _ in 0..<3 {

            prodImgDict = ["productImage": ""]
            prodImgArray.add(prodImgDict)
        }

        productChangeHistTblView.delegate = self
        productChangeHistTblView.dataSource = self
        
        pricePerStockUnitTF.delegate = self
        prodNameTF.delegate = self
        totalPriceTF.delegate = self
        stockQtyTF.delegate = self
        totalPriceTF.isUserInteractionEnabled = false
        stockQtyTF.isUserInteractionEnabled = false
        self.productNameWarn.isHidden=true
        self.pricePerWarn.isHidden=true
        self.productNameWarn.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
        self.pricePerWarn.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
        animatingView()
        
       
        get_storageLocationMaster_API_Call()
        get_StockUnitMaster_API_Call()
        getVendorListDataFromServer()
        get_PriceUnit_API_Call()
        getCategoriesDataFromServer()
        
        let nibName1 = UINib(nibName: "EditHistoryTableViewCell", bundle: nil)
        productChangeHistTblView.register(nibName1, forCellReuseIdentifier: "EditHistoryTableViewCell")
        let headerNib = UINib.init(nibName: "ProductSectionTableViewCell", bundle: nil)
        productChangeHistTblView.register(headerNib, forHeaderFooterViewReuseIdentifier: "ProductSectionTableViewCell")
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getEditDetailsAPI()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
             
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
        
        if textField == self.stockQtyTF {
            
            if newString != "" {
                let aa=decimalPlaces(stt: newString)
                if aa>3 {
                    
                }
                else
                {
                let stockVal = newString
                let pricePerStockVal = pricePerStockUnitTF.text
                let obj1 = Float(stockVal)
                if pricePerStockVal != "" {
                    let obj2 = Float(pricePerStockVal ?? "0")
                    let obj3 = obj1! * obj2!
                    let obj4 = String(format: "%.2f", obj3)
                    totalPriceTF.text = "\(obj4)"
//                    dict.setValue(priceTF.text, forKey: "price")
                }
                else {
                    let obj3 = obj1! * 0.0
                    totalPriceTF.text = "\(obj3)"
//                    dict.setValue(priceTF.text, forKey: "price")
                }
                }
            }
            else {
                totalPriceTF.text = ""
//                dict.setValue(priceTF.text, forKey: "price")
            }
        }
        if textField == self.pricePerStockUnitTF { // Price Per Stock Unit
            if newString != "" {
                let aa=decimalPlaces(stt: newString)
                if aa>2 {
                    
                }
                else
                {
                let stockVal = stockQtyTF.text
                let pricePerStockVal = newString
                let obj2 = Float(pricePerStockVal)
                if stockVal != ""{
                    let obj1 = Float(stockVal ?? "0")
                    let obj3 = obj1! * obj2!
                    let obj4 = String(format: "%.2f", obj3)
//                    print(String(format: "%.2f", obj3))
                    totalPriceTF.text = "\(obj4)"
//                    dict.setValue(priceTF.text, forKey: "price")
                }
                else {
                    let obj3 = 0.0 * obj2!
                    totalPriceTF.text = "\(obj3)"
//                    dict.setValue(priceTF.text, forKey: "price")
                }
                }
            }
            else {
                totalPriceTF.text = ""
//                dict.setValue(priceTF.text, forKey: "price")
            }
        }

        if textField == self.totalPriceTF {  //Price

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
        if textField == pricePerStockUnitTF{  //Price Per Stock Unit

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
        if textField == stockQtyTF{ //Price

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
        
        return true
    }
    @objc func onClickWarnButton()
    {
        self.showAlertWith(title: "Alert", message: "Required")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        if textField==self.prodNameTF
        {
            if(prodNameTF.text == ""){
             
             }
            else
            {
             self.nameWarn=false
             self.productNameWarn.isHidden=true
            }
        }
        if textField==self.pricePerStockUnitTF
        {
             if(pricePerStockUnitTF.text == ""){
             
             }
             else
             {
                 self.pricePerWarnD=false
                 self.pricePerWarn.isHidden=true
             }
        }
    }
    func updateInventoryData()  {
        
        prodIDTF.text = editInventoryResult[0].productDict?.productUniqueNumber
        prodNameTF.text = editInventoryResult[0].productDict?.productName
        prodDescTF.text = editInventoryResult[0].productDict?.description
        
        let stockQuan = editInventoryResult[0].stockQuantity ?? 0
        stockQtyTF.text = String(stockQuan)
        
        let pricePerStockUnit = editInventoryResult[0].productDict?.unitPrice ?? 0
        pricePerStockUnitTF.text = String(pricePerStockUnit)
        
       
        
        let stockUnit = editInventoryResult[0].stockUnitArray
        if stockUnit!.count>0
        {
        let stockUnitDictA = stockUnit?[0]
        let stockUnitDict = stockUnitDictA
        let stockuu:NSDictionary = stockUnitDict as! NSDictionary
        let aa:String=String(describing: stockuu.value(forKey: "stockUnitName")!)
            let aaid:String=String(describing: stockuu.value(forKey: "_id")!)
        stockUnitButton.setTitle(aa, for: .normal)
            self.dict.setValue(aaid, forKey: "stockUnitId")
        }
        else
        {
            if stockUnitsArr.count>0
            {
               let stockUnit = stockUnitsArr[0].stockUnitName ?? ""
                let stockUnitId=stockUnitsArr[0]._id ?? ""
                self.dict.setValue(stockUnit, forKey: "stockUnit")
                self.dict.setValue(stockUnitId, forKey: "stockUnitId")
                stockUnitButton.setTitle(stockUnit, for: .normal)
            }
            else
            {
                stockUnitButton.setTitle("", for: .normal)
            }
            
        }
        let totalPrice = Float(stockQuan) * Float(pricePerStockUnit)
        totalPriceTF.text = String(format:"%.2f", totalPrice ?? 0)
        
        let priceUnit = editInventoryResult[0].priceUnitArray
        if priceUnit!.count>0
        {
        let priceUnitDictA = priceUnit?[0]
        let priceUnitDict = priceUnitDictA
        let priceuu:NSDictionary = priceUnitDict as! NSDictionary
        let priceUnitDictaa:String=String(describing: priceuu.value(forKey: "priceUnit")!)
            let priceUnitDictaaid:String=String(describing: priceuu.value(forKey: "_id")!)
        priceUnitButton.setTitle(priceUnitDictaa, for: UIControl.State.normal)
            self.dict.setValue(priceUnitDictaaid, forKey: "priceUnitId")
        }
        else
        {
            if priceUnitsArr.count>0
            {
                let priceUnit = priceUnitsArr[0].priceUnit ?? ""
                let priceUnitId = priceUnitsArr[0]._id ?? ""
            
                self.dict.setValue(priceUnit, forKey: "priceUnit")
                self.dict.setValue(priceUnitId, forKey: "priceUnitId")
            priceUnitButton.setTitle(priceUnit, for: UIControl.State.normal)
            }
            else
            {
                priceUnitButton.setTitle("", for: UIControl.State.normal)
            }
        }
        
        let expiryDate = (editInventoryResult[0].productDict?.expiryDate) ?? ""
        if expiryDate==""
        {
            expiryDateBtn.setTitle("", for: .normal)
        }
        else
        {
        let convertedExpiryDate = convertDateFormatter(date: expiryDate)
        
        expiryDateBtn.setTitle(convertedExpiryDate, for: .normal)
        }
        let purchaseDate = (editInventoryResult[0].productDict?.purchaseDate)
        let convertedPurchaseDate = convertDateFormatter(date: purchaseDate ?? "")
        purchaseDateBtn.setTitle(convertedPurchaseDate, for: .normal)
        
        let vendorDetailsDict = editInventoryResult[0].vendorDict as? NSDictionary
        var vendorStr=String()
        var vendorStrID=String()
        
        if vendorDetailsDict?.value(forKey: "vendorName") as? String==""
        {
            if vendorListResult.count>0
            {
                vendorStr=vendorListResult[0].vendorName ?? ""
                vendorStrID=vendorListResult[0]._id ?? ""
            
                self.dict.setValue(vendorStr, forKey: "vendorName")
                self.dict.setValue(vendorStrID, forKey: "vendorId")
                vendorIDButton.setTitle(vendorStr, for: .normal)
            }
        }
        else
        {
            vendorIDButton.setTitle(vendorDetailsDict?.value(forKey: "vendorName") as? String, for: .normal)
        }
        let storageLocation = editInventoryResult[0].storageLocationArray
        if storageLocation!.count>0
        {
        let storageLocationA = storageLocation?[0]
        let storageLocationDict = storageLocationA
        let storageLocationuu:NSDictionary = storageLocationDict as! NSDictionary
        let storageLocationDictaa:String=String(describing: storageLocationuu.value(forKey: "slocName")!)
            let storageLocationDictId:String=String(describing: storageLocationuu.value(forKey: "_id")!)
        storageLocButton.setTitle(storageLocationDictaa, for: UIControl.State.normal)
            self.dict.setValue(storageLocationDictId, forKey: "storageLocationId")
        }
        else
        {
            if storageLocationArr.count>0
            {
                let dictt1=storageLocationArr[0] as? NSDictionary
                let storageLocationStr=dictt1?.value(forKey: "slocName")as? String ?? ""
                let storageLocationIdStr = dictt1?.value(forKey: "_id")as? String ?? ""
            
                self.dict.setValue(storageLocationStr, forKey: "storageLocation")
                self.dict.setValue(storageLocationIdStr, forKey: "storageLocationId")
            storageLocButton.setTitle(storageLocationStr, for: UIControl.State.normal)
            }
            else
            {
                storageLocButton.setTitle("", for: UIControl.State.normal)
            }
        }
        
        let storageLocation1 = editInventoryResult[0].storageLocation1Array
        if storageLocation1!.count>0
        {
        let storageLocationA1 = storageLocation1?[0]
        let storageLocationDict1 = storageLocationA1
        let storageLocationuu1:NSDictionary = storageLocationDict1 as! NSDictionary
        let storageLocationDictaa1:String=String(describing: storageLocationuu1.value(forKey: "slocName")!)
        storageLoc1Button.setTitle(storageLocationDictaa1, for: UIControl.State.normal)
            let storageLocationDictId:String=String(describing: storageLocationuu1.value(forKey: "_id")!)
            self.dict.setValue(storageLocationDictId, forKey: "storageLocation1Id")
        }
        else
        {
            if storageLocationArr1.count>0
            {
                let dictt1=storageLocationArr1[0] as? NSDictionary
                let storageLocationStr1=dictt1?.value(forKey: "slocName")as? String ?? ""
                let storageLocation1IdStr = dictt1?.value(forKey: "_id")as? String ?? ""
             
                self.dict.setValue(storageLocationStr1, forKey: "storageLocation1")
                self.dict.setValue(storageLocation1IdStr, forKey: "storageLocation1Id")
            storageLoc1Button.setTitle(storageLocationStr1, for: UIControl.State.normal)
        }
        else
        {
            storageLoc1Button.setTitle("", for: UIControl.State.normal)
        }
        
        }
        
        let storageLocation2 = editInventoryResult[0].storageLocation2Array
        if storageLocation2!.count>0
        {
        let storageLocationA2 = storageLocation2?[0]
        let storageLocationDict2 = storageLocationA2
        let storageLocationuu2:NSDictionary = storageLocationDict2 as! NSDictionary
        let storageLocationDictaa2:String=String(describing: storageLocationuu2.value(forKey: "slocName")!)
        storageLoc2Button.setTitle(storageLocationDictaa2, for: UIControl.State.normal)
            let storageLocationDictId:String=String(describing: storageLocationuu2.value(forKey: "_id")!)
            self.dict.setValue(storageLocationDictId, forKey: "storageLocation2Id")
        }
        else
        {
            if storageLocationArr2.count>0
            {
                let dictt1=storageLocationArr2[0] as? NSDictionary
                let storageLocationStr2=dictt1?.value(forKey: "slocName")as? String ?? ""
                let storageLocation2IdStr = dictt1?.value(forKey: "_id")as? String ?? ""
               
                self.dict.setValue(storageLocationStr2, forKey: "storageLocation2")
                self.dict.setValue(storageLocation2IdStr, forKey: "storageLocation2Id")
                storageLoc2Button.setTitle(storageLocationStr2, for: UIControl.State.normal)
            }
            else
            {
                storageLoc2Button.setTitle("", for: UIControl.State.normal)
            }
        }
        
        
        
        var category=String()
        var categoryId=String()
        if editInventoryResult[0].productDict?.category==""
        {
            if categoryResult.count>0
            {
                category=categoryResult[0].name ?? ""
                categoryId=categoryResult[0]._id ?? ""
            
                self.dict.setValue(category, forKey: "category")
                self.dict.setValue(categoryId, forKey: "categoryId")
            categoryBtn.setTitle(editInventoryResult[0].productDict?.category, for: .normal)
            }
            else
            {
                categoryBtn.setTitle("", for: .normal)
            }
        }
        else
        {
            categoryBtn.setTitle(editInventoryResult[0].productDict?.category, for: .normal)
        }
        
        var subCategory=String()
        var subCategoryId=String()
        if editInventoryResult[0].productDict?.subCategory==""
        {
            if subCategoryResult.count>0
            {
                subCategory=subCategoryResult[0].name ?? ""
                subCategoryId=subCategoryResult[0]._id ?? ""
            
                self.dict.setValue(subCategory, forKey: "subCategory")
                self.dict.setValue(subCategoryId, forKey: "subCategoryId")
            subCategoryBtn.setTitle(subCategory, for: .normal)
            }
            else
            {
                subCategoryBtn.setTitle("", for: .normal)
            }
        }
        else
        {
            subCategoryBtn.setTitle(editInventoryResult[0].productDict?.subCategory, for: .normal)
        }
        orderIDTF.text = editInventoryResult[0].productDict?.orderId
        

        let borrowedStatus = editInventoryResult[0].isBorrowed as? Bool
        
        selectedCategoryID = (editInventoryResult[0].productDict?.category)!

        if borrowedStatus == true
        {
            borrowedCheckBtn.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
        }else{
            borrowedCheckBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)

        }
       
       
        let sharedStatus = editInventoryResult[0].shared as? Bool

        if(sharedStatus == true)
        {
            sharedCheckBtn.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
        }else{
            sharedCheckBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)

        }
        let attrs = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

        let attributedString = NSMutableAttributedString(string:"")
        
        let buttonTitleStr = NSMutableAttributedString(string:"Vendor Masters", attributes:attrs)
        attributedString.append(buttonTitleStr)
        vendorMastersBtn.setAttributedTitle(attributedString, for: .normal)
        
        let prodArray = editInventoryResult[0].productDict?.productImages
        
        if(prodArray?.count ?? 0  > 0){
            
                    let dict = prodArray?[0] as! NSDictionary
                    
                    let imageStr = dict.value(forKey: "0") as? String
                    let imageStr1 = dict.value(forKey: "1") as? String
                    let imageStr2 = dict.value(forKey: "2") as? String
                    
            //prod img 1
            
            if ((imageStr?.isEmpty) != nil) {
                        
                let imgUrl:String = imageStr ?? ""
                        
                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                            
                        let imggg = Constants.BaseImageUrl + trimStr
                        
                        let url = URL.init(string: imggg)
                        
                        prodImg1.sd_setImage(with: url, for: UIControl.State.normal, completed: nil)
                        
                    }
                    else {
                        prodImg1.imageView?.image = UIImage(named: "no_image")
                    }
            
            //prod img 1
            
            if ((imageStr1?.isEmpty) != nil) {
                        
                let imgUrl:String = imageStr1 ?? ""

                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                            
                        let imggg = Constants.BaseImageUrl + trimStr
                        
                        let url = URL.init(string: imggg)
                        
                        prodImg2.sd_setImage(with: url, for: UIControl.State.normal, completed: nil)
                        
                    }
                    else {
                        prodImg2.imageView?.image = UIImage(named: "no_image")
                    }
            
            //prod img 2
            
            if ((imageStr2?.isEmpty) != nil) {
                        
                let imgUrl:String = imageStr2 ?? ""

                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                            
                        let imggg = Constants.BaseImageUrl + trimStr
                        
                        let url = URL.init(string: imggg)
                        
                        prodImg3.sd_setImage(with: url, for: UIControl.State.normal, completed: nil)
                        
                    }
                    else {
                        prodImg3.imageView?.image = UIImage(named: "no_image")
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

        if(isExpiryDate == "1"){ //Purchase Btn
            expiryDateBtn.setTitle(result, for: .normal)

        }else{
            purchaseDateBtn.setTitle(result, for: .normal)

        }
   }
    @IBAction func editBorrowLabel(_ sender: Any) {
    }
    
   @objc func dueDateChanged(sender:UIDatePicker){
       
       let dateFormatter = DateFormatter()
       
       dateFormatter.dateFormat = "dd/MM/yyyy"
       let selectedDate = dateFormatter.string(from: picker.date)

       if(isExpiryDate == "1"){ //Purchase Btn
        expiryDateBtn.setTitle(selectedDate, for: .normal)
        
       }else {
        purchaseDateBtn.setTitle(selectedDate, for: .normal)

       }
   }
   
   @objc func doneBtnTap(_ sender: UIButton) {

       hiddenBtn.removeFromSuperview()
       pickerDateView.removeFromSuperview()
       
   }
    
    func getEditDetailsAPI()  {

            activity.startAnimating()
            self.view.isUserInteractionEnabled = true

            let URLString_loginIndividual = Constants.BaseUrl + GetCurrentInventopryUrl + prodIDStr
            editServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                                let respVo:EditInventoryRespo = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                _ = respVo.message
                                _ = respVo.statusCode
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
                                    if(respVo.result!.count)>0{
                                        self.editInventoryResult = respVo.result!
                                        self.getModifiedListAPI()
                                        self.updateInventoryData()
                                    }
                                }
                                else {
                                    
                                }
                                
                            }) { (error) in
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                print("Something Went To Wrong...PLrease Try Again Later")
                            }
    }
    
    //****************** TableView Delegate Methods*************************//
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = productChangeHistTblView.dequeueReusableHeaderFooterView(withIdentifier: "ProductSectionTableViewCell") as! ProductSectionTableViewCell
       
        let modificationDictionary=self.mainHistoryArray[section].productModifingEditDetails as? ProductModifingDetailsVo
        let userinfo=modificationDictionary?.userinfo ?? [UserinfoVo]()
        let accountinfo=modificationDictionary?.accountinfo ?? [AccountinfoVo]()
        
        headerView.updateTypeL.text=modificationDictionary?.changeType
        if accountinfo.count > 0 {
        headerView.companyNameL.text=accountinfo[0].companyName
        }
        headerView.createdDateL.text=modificationDictionary?.modifiedDateTime
        headerView.collapseButton.tag=section
        headerView.collapseButton.addTarget(self, action: #selector(dropDoownBtnTap), for: .touchUpInside)
        if isExpandable[section] == true {
            headerView.collapseButton.setImage(UIImage(named: "Up"), for: .normal)
        }
        else{
            headerView.collapseButton.setImage(UIImage(named: "arrowDown"), for: .normal)
        }
        var nameLabel=String()
        if userinfo.count>0
        {
            let ffname=userinfo[0].firstName ?? ""
            let ssname=userinfo[0].lastName ?? ""
            nameLabel=ffname + " " + ssname
        }
        headerView.userNameL.text=nameLabel
        
        return headerView
   }
    var isExpandable=[Bool]()
    var mainHistoryArray=[ProductChangesList]()
    @objc func dropDoownBtnTap(sender:UIButton)
    {
     print("Button Tapped,need to insert (or) DElete Rows In Section\(sender.tag)")
     
     if isExpandable[sender.tag] == true {
         isExpandable[sender.tag]=false
        self.modifiedTableHeight.constant -= 372
        sender.setImage(UIImage(named: "Up"), for: .normal)
        productChangeHistTblView.reloadData()
       }
       else if isExpandable[sender.tag] == false  {
         isExpandable[sender.tag]=true
        self.modifiedTableHeight.constant += 372
        sender.setImage(UIImage(named: "arrowDown"), for: .normal)
        productChangeHistTblView.reloadData()
            }
         }
    //****************** TableView Delegate Methods*************************//
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var productsList = [ProductChangesList]()
        productsList = mainHistoryArray
        if isExpandable[section]==true
        {
        return 1
        }
        return 0
     }
     var indexPathRow=IndexPath()
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var productsList = [ProductChangesList]()
        productsList = mainHistoryArray
        
        print(productsList)
        
        let prodDetails = productsList[indexPath.section].productdetails!
        
        let stockDetails = productsList[indexPath.section].stockUnitDetails!
        let storageOneDetails = productsList[indexPath.section].storageLocationLevel1Details!
        let storageTwoDetails = productsList[indexPath.section].storageLocationLevel2Details!
        let storageThreeDetails = productsList[indexPath.section].storageLocationLevel3Details!
        let priceUnitDetails = productsList[indexPath.section].priceUnitDetails!
        let productModifiedDetails = productsList[indexPath.section].productModifingEditDetails!
      
        
        var cellHieight=Int()
        cellHieight=productsList[indexPath.section].cellHeight ?? 0
      
            let cell = productChangeHistTblView.dequeueReusableCell(withIdentifier: "EditHistoryTableViewCell", for: indexPath) as! EditHistoryTableViewCell
            
            cell.mainView.layer.borderColor=UIColor.black.cgColor
            cell.mainView.layer.borderWidth=0.5
            let prodArray = prodDetails.productImages
            
            if(prodArray?.count ?? 0  > 0){
                
                        let dict = prodArray?[0] as! NSDictionary
                        
                        let imageStr = dict.value(forKey: "0") as! String
                        
                        if !imageStr.isEmpty {
                            
                            let imgUrl:String = imageStr
                            
                            let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                                
                            let imggg = Constants.BaseImageUrl + trimStr
                            
                            let url = URL.init(string: imggg)

                            
                            cell.oroductImage?.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                            
                            cell.oroductImage?.contentMode = UIView.ContentMode.scaleAspectFit
                            
                        }
                        else {
                            
                            cell.oroductImage?.image = UIImage(named: "no_image")
                        }
            }else{
                
                cell.oroductImage?.image = UIImage(named: "no_image")
            }
            
            cell.productId.text=prodDetails.productUniqueNumber
            cell.productName.text=prodDetails.productName
            cell.productDesc.text=prodDetails.description
            cell.stockQtyL.text=String(productsList[indexPath.section].stockQuantity ?? 0)
        let stockQuu=productsList[indexPath.section].stockQuantity ?? 0
        if stockDetails.count > 0 {
            cell.stocckUnitL.text=stockDetails[0].stockUnitName
        }
        else
        {
            cell.stocckUnitL.text==""
        }
            
        let expiryDate = convertDateFormatter(date: prodDetails.expiryDate ?? "")
        if expiryDate==""
        {
            cell.expiryDateL.text=""
        }
        else
        {
        
            cell.expiryDateL.text=expiryDate
        }
        if priceUnitDetails.count > 0 {
            cell.priceUnitL.text=priceUnitDetails[0].priceUnit
        }
        else
        {
            cell.priceUnitL.text=""
        }
            cell.pricePerStockLabel.text=String(prodDetails.unitPrice ?? 0)
        let unitPPrice=prodDetails.unitPrice ?? 0
        let obj3=stockQuu * unitPPrice
        cell.totalPriceLabel.text=String(format:"%.2f", obj3)
            if storageOneDetails.count != 0 {
            cell.storageLevel1Label.text=storageOneDetails[0].slocName
            }
            else
            {
                cell.storageLevel1Label.text=""
            }
            if storageTwoDetails.count != 0 {
            cell.storageLevel2Label.text=storageTwoDetails[0].slocName
            }
            else
            {
                cell.storageLevel2Label.text=""
            }
            if storageThreeDetails.count != 0 {
            cell.storageLevel3Label.text=storageThreeDetails[0].slocName
            }
            else
            {
                cell.storageLevel3Label.text=""
            }
            cell.categoryLabel.text=prodDetails.category
            cell.subCategoryLabel.text=prodDetails.subCategory
            return cell
       
        
     }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainHistoryArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var productsList = [ProductChangesList]()
        productsList = mainHistoryArray
        
        print(productsList)
      
        if isExpandable[indexPath.section] == true
        {
            var celllHeight=Int()
     
                celllHeight = 372
                productsList[indexPath.section].cellHeight = celllHeight
          
            return CGFloat(celllHeight)
        }
        return 0
        
    }

   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
       return 65
       
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
                                    self.dict.setValue(respVo.result![0].name, forKey: "category")
                                    self.dict.setValue(respVo.result![0]._id, forKey: "categoryId")
                                    
                                }
                                if self.categoryResult.count>0
                                {
                                self.selectedCategoryStr=respVo.result![0].name ?? ""
                                }
                                else
                                {
                                    self.selectedCategoryStr=""
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
    var selectedCategoryStr = ""
   
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

                                if self.subbuttonTap=="tap"
{
                                    if self.subCategoryResult.count>0
                                    {
                                    self.dict.setValue(respVo.result![0].name, forKey: "subCategory")
                                    self.dict.setValue(respVo.result![0]._id, forKey: "subCategoryId")
                                    self.subbuttonTap=""
                                    self.subCategoryBtn.setTitle((respVo.result![0].name ?? "") as String, for: UIControl.State.normal)
                                    }
                                    else
                                    {
                                    self.dict.setValue("", forKey: "subCategory")
                                    self.dict.setValue("", forKey: "subCategoryId")
                                    self.subbuttonTap=""
                                    self.subCategoryBtn.setTitle("", for: UIControl.State.normal)
                                    }
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
    
    func UpdateCurrentInventoryDataAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        do {
            
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: prodImgArray, options: JSONSerialization.WritingOptions.prettyPrinted)

            //Convert back to string. Usually only do this for debugging

            if let prodImgJSONString = String(data: jsonData, encoding: String.Encoding.utf8) {

            let URLString_loginIndividual = Constants.BaseUrl + UpdateCurrentInventoryUrl
            
            let userDefaults = UserDefaults.standard
            let userID = userDefaults.value(forKey: "userID") as! String
               
                var prodImgDict = NSMutableDictionary()
                let prodImgArray = NSMutableArray()
                for _ in 0..<3 {

                    prodImgDict = ["productImage": ""]
                    prodImgArray.add(prodImgDict)
                }
                
                var productDetailsDict=NSDictionary()
                if editInventoryResult.count>0
                {
                    productDetailsDict = editInventoryResult[0].productDict as? NSDictionary ?? NSDictionary()
                }
                var expirry=String()
                if expiryDateBtn.currentTitle=="" || expiryDateBtn.currentTitle==nil
                {
                    expirry=" "
                }
                else
                {
                    expirry=expiryDateBtn.currentTitle!
                }
               var params_IndividualLogin=NSMutableDictionary()
                 params_IndividualLogin =
                    ["_id": prodIDStr,
                     "accountEmailId": editInventoryResult[0].productDict?.accountEmailId,
                "accountId": accountID,
                "addedByUserId": editInventoryResult[0].productDict?.addedByUserId,
                "availableStockQuantity": 0.0,
                "isBorrowed": false,
                "category": categoryBtn.currentTitle!,
                "changedStockQuantity": 0.0,
                "description": prodDescTF.text,
                "expiryDate": expirry,
                "giveAwayStatus": false,
                "id": 0,
                "isLent": false,
                "orderId": orderIDTF.text!,
                "price": totalPriceTF.text!,
                "priceUnit": self.dict.value(forKey: "priceUnitId") as? String,
                "productImages": prodImgArray,
                "productManuallyAddOrAutoMovedDate": editInventoryResult[0].productDict?.productManuallyAddOrAutoMovedDate,
                "productName": prodNameTF.text!,
                "productStatus": editInventoryResult[0].productDict?.productStatus,
                "productUniqueNumber": prodIDTF.text!,
                "purchaseDate": purchaseDateBtn.currentTitle!,
                "shared": false,
                "status": true,
                "stockQuantity": stockQtyTF.text!,
                "stockUnit": self.dict.value(forKey: "stockUnitId") as? String,
//                "storageLocation1": self.dict.value(forKey: "storageLocationId") as? String,
//                "storageLocation2": self.dict.value(forKey: "storageLocation1Id") as? String,
//                "storageLocation3": "",
                "subCategory": subCategoryBtn.currentTitle!,
                "unitPrice": pricePerStockUnitTF.text!,
                "uploadType": "manual",
                "vendorId": self.dict.value(forKey: "vendorId") as? String]
                
                if self.dict.value(forKey: "storageLocation2Id") as? String == ""
                {
                }
                else
                {
                    params_IndividualLogin["storageLocation3"]=self.dict.value(forKey: "storageLocation2Id") as Any
                }
                if self.dict.value(forKey: "storageLocation1Id") as? String == ""
                {
                }
                else
                {
                    params_IndividualLogin["storageLocation2"]=self.dict.value(forKey: "storageLocation1Id") as Any
                }
                if self.dict.value(forKey: "storageLocationId") as? String == ""
                {
                }
                else
                {
                    params_IndividualLogin["storageLocation1"]=self.dict.value(forKey: "storageLocationId") as Any
                    params_IndividualLogin["storageLocation"]=self.dict.value(forKey: "storageLocationId") as Any
                }
//                        print(params_IndividualLogin)
                    
                        let postHeaders_IndividualLogin = ["":""]
                        
                        editServiceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSMutableDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                            
                            let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            let statusCode = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                if(statusCode == 200 ){
                                    
               //self.showAlertWith(title: "Success", message: "Details updated successfully")

                                    let alert = UIAlertController(title: "Success", message: "Details updated successfully", preferredStyle: UIAlertController.Style.alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in

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
            }

        }catch {
            
        }
    }
    
    func getModifiedListAPI()  {

            activity.startAnimating()
            self.view.isUserInteractionEnabled = true

            let URLString_loginIndividual = Constants.BaseUrl + ModifiedProductHistoryUrl + productID
        
            editServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                                let respVo:OrderHistoryRespVo = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                _ = respVo.message
                                _ = respVo.statusCode
                
                let dataDict = result as! NSDictionary
                
                self.prodModifyArray = dataDict.value(forKey: "result") as! NSMutableArray
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    let mainArray=respVo.resultHistory ?? [ProductChangesList]()
                                    self.mainHistoryArray = [ProductChangesList]()
                                    self.isExpandable=[Bool]()
                                    self.modifiedTableHeight.constant = 0
                                    if mainArray.count>0
                                    {
                                        for i in 0..<mainArray.count {
                                            self.isExpandable.append(false)
                                            let productModifiedDetails = mainArray[i].productModifingEditDetails
                                            if productModifiedDetails?.change=="add-currentinventory"
                                            {
                                                
                                            }
                                            else
                                            {
                                                self.mainHistoryArray.append(mainArray[i])
                                                self.modifiedTableHeight.constant += 80
                                            }
                                            self.productChangeHistoryLbl.isHidden=false
                                            self.productChangeHistTblView.isHidden = false
                                    }
                                    }
                                    
                                    self.productChangeHistTblView.reloadData()
                                   
                                }
                                else {
                                    
                                }
                                
                            }) { (error) in
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                print("Something Went To Wrong...PLrease Try Again Later")
                            }
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
                            if self.stockUnitsArr.count>0
                            {
                                self.dict.setValue(self.stockUnitsArr[0].stockUnitName, forKey: "stockUnit")
                            self.dict.setValue(self.stockUnitsArr[0]._id, forKey: "stockUnitId")
                            }
                            else
                            {
                                self.dict.setValue("", forKey: "stockUnit")
                            self.dict.setValue("", forKey: "stockUnitId")
                            }
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
                            let resultObj:[String:Any]=result as? [String:Any] ?? [String:Any]()
                            let resultArr:NSMutableArray=resultObj["result"]as? NSMutableArray ?? NSMutableArray()
                            self.storageLocationArr = resultArr
                            if self.storageLocationArr.count>0
                            {
                                let aaaa=self.storageLocationArr[0] as! NSDictionary
                            self.dict.setValue(aaaa.value(forKey: "slocName")as? String ?? "", forKey: "storageLocation")
                            self.dict.setValue(aaaa.value(forKey: "_id")as? String ?? "", forKey: "storageLocationId")
                            self.hierachyLevel = "2"
                            self.parentLocation = aaaa.value(forKey: "slocName")as? String ?? ""
                                self.storageLocButton.setTitle(aaaa.value(forKey: "slocName")as? String ?? "", for: .normal)
                            self.get_StorageLocationByParentLocation_API_Call()
                            }
                        }
                        else {
                            
                        }
                    }
                        else
                        {
                           let resultObj:[String:Any]=result as? [String:Any] ?? [String:Any]()
                           let resultArr:NSMutableArray=resultObj["result"]as? NSMutableArray ?? NSMutableArray()
                            resultArr.compactMap{ $0 }
                            for i in 0..<resultArr.count
                            {
                                if let aaaaa=resultArr[i] as? NSDictionary
                                {
                                    let aaaa=resultArr[i] as! NSDictionary
                                self.storageLocationArr.add(aaaa)
                                    
                                }
                               
                            }
                            if self.storageLocationArr.count>0
                            {
                                let aaaa=self.storageLocationArr[0] as! NSDictionary
                                self.hierachyLevel = "2"
                                self.parentLocation = aaaa.value(forKey: "slocName")as? String ?? ""
                                self.storageLocButton.setTitle(aaaa.value(forKey: "slocName")as? String ?? "", for: .normal)
                                self.get_StorageLocationByParentLocation_API_Call()
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
    var parentLocation=String()
    var hierachyLevel=String()
    
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
                              self.storageLocationArr1.removeAllObjects()
                            let resultObj:[String:Any]=result as? [String:Any] ?? [String:Any]()
                            let resultArr:NSMutableArray=resultObj["result"]as? NSMutableArray ?? NSMutableArray()
                            self.storageLocationArr1 = resultArr
                            if self.storageLocationArr1.count>0
                            {
                                let aaaa=self.storageLocationArr1[0] as! NSDictionary
                              self.hierachyLevel = "3"
                                self.storageLoc1Button.setTitle(aaaa.value(forKey: "slocName")as? String ?? "", for: .normal)
                              self.parentLocation = aaaa.value(forKey: "slocName")as? String ?? ""
                                self.dict.setValue(aaaa.value(forKey: "slocName")as? String ?? "", forKey: "storageLocation1")
                                self.dict.setValue(aaaa.value(forKey: "_id")as? String ?? "", forKey: "storageLocation1Id")
                            }
                              if self.buttonTap=="tap"
                              {
                                if self.storageLocationArr1.count>0
                                {
                                    let aaaa=self.storageLocationArr1[0] as! NSDictionary
                                self.dict.setValue(aaaa.value(forKey: "slocName")as? String ?? "", forKey: "storageLocation1")
                                self.dict.setValue(aaaa.value(forKey: "_id")as? String ?? "", forKey: "storageLocation1Id")
                                }
                              }
                              self.get_StorageLocationByParentLocation_API_Call()
                              
                            }
                          else if self.hierachyLevel=="3"
                          {
                              self.storageLocationArr2.removeAllObjects()
                            let resultObj:[String:Any]=result as? [String:Any] ?? [String:Any]()
                            let resultArr:NSMutableArray=resultObj["result"]as? NSMutableArray ?? NSMutableArray()
                            self.storageLocationArr2 = resultArr
                            if self.storageLocationArr2.count>0
                            {
                                if self.storageLocationArr2.value(forKey: "hierachyLevel")as? Int == 3
                                {
                                let aaaa=self.storageLocationArr2[0] as! NSDictionary
                                self.dict.setValue(aaaa.value(forKey: "slocName")as? String ?? "", forKey: "storageLocation2")
                                self.dict.setValue(aaaa.value(forKey: "_id")as? String ?? "", forKey: "storageLocation2Id")
                                self.storageLoc2Button.setTitle(aaaa.value(forKey: "slocName")as? String ?? "", for: .normal)
                                }
                                else
                                {
                                let aaaa=self.storageLocationArr2[0] as! NSDictionary
                                self.dict.setValue("", forKey: "storageLocation2")
                                self.dict.setValue("", forKey: "storageLocation2Id")
                                self.storageLoc2Button.setTitle("", for: .normal)
                                }
                            }
                              if self.buttonTap=="tap"
                              {
                              var storageLocArr = [String]()
                                  
                                if self.storageLocationArr2.count>0
                                {
                                    let aaaa=self.storageLocationArr2[0] as! NSDictionary
                                    self.dict.setValue(aaaa.value(forKey: "slocName")as? String ?? "", forKey: "storageLocation2")
                                    self.dict.setValue(aaaa.value(forKey: "_id")as? String ?? "", forKey: "storageLocation2Id")
                                }
                                  self.buttonTap=""
                              }
                          }
                        }
                        else {
                          if self.hierachyLevel=="2" {
                              
                              self.storageLocationArr1.removeAllObjects()
                              self.buttonTap=""
                          }
                          else if self.hierachyLevel=="3" {
                              
                              self.storageLocationArr2.removeAllObjects()
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
    func getVendorListDataFromServer() {
        
        categoryDataArray.removeAllObjects()
        categoryIDArray.removeAllObjects()
        
        categoryDataArray = NSMutableArray()
        categoryIDArray = NSMutableArray()
        
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
                                        for obj in self.vendorListResult
                                        {
                                            self.dict.setValue(obj.vendorName, forKey: "vendorName")
                                            self.dict.setValue(obj._id, forKey: "vendorId")
                                          
                                        }
                                        
//
//                                        if(self.categoryDataArray.count == 0){
//
////                                            self.showAlertWith(title: "Alert !!", message: "No Vendor available. Please add a vendor before adding a product")
//
//                                        }else if(self.categoryDataArray.count > 0){
//
//                                            self.vendorListResult = respVo.result!
//
//                                        }
                                        
//                                                viewTobeLoad.modalPresentationStyle = .fullScreen
//                                                self.present(viewTobeLoad, animated: true, completion: nil)
                                        
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
    

}
