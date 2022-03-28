//
//  AddManualTextProductViewController.swift
//  Lekha
//
//  Created by USM on 10/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import AVFoundation
import AVKit
import CommonCrypto
import Foundation
import DropDown
import Toast_Swift


class AddManualTextProductViewController: UIViewController,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate,sentname,sendDetails,sendShoppingInfoDetails,QRCodeReaderViewControllerDelegate {
    var userDefaults=UserDefaults.standard
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {

        reader.stopScanning()
                
        dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@",result.value),
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

           // self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)

    }
    
    
    @IBOutlet weak var topHeaderBackView: UIView!
    
    var selectedCategoryID : String!

    var ordersHistoryResult = [OrdersHistoryResult]()
    var categoryResult = [CategoryResult]()
    var subCategoryResult = [SubCategoryResult]()
    
    var shoppingCurrentInvStatusStr = String()
    var shoppingCartStatusStr = String()
    var shoppingOpenOrdersStatusStr = String()
    var shoppingOrdersHistoryStatusStr = String()
    
    var shoppingInfoAddProdView = ShoppingUseProductInfoView()
    
    var productNameTF = UITextField()
    var productIDTF = UITextField()
    var productIDImage=UIButton()
    var descriptionTF = UITextView()
    var reqQunatityTF = UITextField()
    //    var stockUnitTF = UITextField()
        var priceTF = UITextField()
        var offerPriceTF = UITextField()
        //var priceUnitTF = UITextField()
        var pricePerStockUnitTF = UITextField()
        var totalPriceTF = UITextField()
       // var storageLocationTF = UITextField()
        //var vendorNameTF = UITextField()
        var orderIdTF = UITextField()
        var categoryDropDown = UIButton()
        var subCategoryDropDown = UIButton()
        var stockUnitDropDown = UIButton()
        var priceUnitDropDown = UIButton()
    var purchaseDateTF=UIButton()
        var vendorNameDropDown = UIButton()
        var storageLocationDropDown = UIButton()
        var storageLocation1DropDown = UIButton()
        var storageLocation2DropDown = UIButton()
    var hierachyLevel=String()
    
    let tostM = ToastManager.self
    
    @IBOutlet weak var addProdBtn: UIButton!
    
    @IBOutlet weak var headerTitleLbl: UILabel!
    
    @IBAction func saveForLaterBtnTapped(_ sender: UIButton){
        
        let productMainDict = myProductArray.object(at: sender.tag) as! NSDictionary
                
        let productName = productMainDict.value(forKey: "productName") as? NSString ?? ""
        
        if productName == "" {
            self.showAlertWith(title: "Alert", message: "Please enter product name")
            return
        }
        else {
            saveForLaterAPIWithTag(tagValue: (sender as AnyObject).tag)
        }       
    }
   
    @IBAction func saveBtnTapped(_ sender: Any) {
//        self.removeEmptyObjects()
        self.productScrollView.removeFromSuperview()
        var mainArrayValidation=NSMutableArray()
        if myProductArray.count>0
        {

        for i in 0..<myProductArray.count {
            
            let dataDict = myProductArray[i] as! NSDictionary

            let productUniqueNum = dataDict.value(forKey: productUniqueNumber) as? String
            let productNameStr = dataDict.value(forKey: productName) as? String
            let descStr = dataDict.value(forKey: prodDescription) as? String
            let stockQuanStr = dataDict.value(forKey: stockQuantity) as? String
            let priceStr = dataDict.value(forKey: price) as? String
            let purchaseDateStr = dataDict.value(forKey: purchaseDate) as? String
            let categoryStr = dataDict.value(forKey: category) as? String
            let subcategoryStr = dataDict.value(forKey: subCategory) as? String
            let pricePerStockUnitStr = dataDict.value(forKey: unitPrice) as? String ?? ""

            
            if  (productNameStr == "") && (stockQuanStr == "") {
            
                dataDict.setValue(true, forKey: "productNameWarn")
                dataDict.setValue(true, forKey: "stockQuantityWarn")
                self.showAlertWith(title: "Alert", message: "Please make sure to fill all product details")
                
            }
            if(productNameStr == "") || (stockQuanStr == ""){

                if(productNameStr == "")
                {
                dataDict.setValue(true, forKey: "productNameWarn")
            }
            if(stockQuanStr == ""){
                dataDict.setValue(true, forKey: "stockQuantityWarn")

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
        
        self.loadAddProductUI()
        
        if mainArrayValidation.count==myProductArray.count
        {
            if myProductArray.count>0
            {
        removeProductImage()
        
        if(isEditShopping == "ShoppingEdit" || isEditShopping == "SavingEdit"){
            callEditShoppingProductsAPI()
            
        }else if(isEditShopping == "OrderHistory"){
            
        }else{

            callAddProductsAPI()
        }
            }
        }
    }
    
    var previousStatusStr = String()
    var presentStatusStr = String()
    
    let captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                         AVMetadataObject.ObjectType.code39,
                                         AVMetadataObject.ObjectType.code39Mod43,
                                         AVMetadataObject.ObjectType.code93,
                                         AVMetadataObject.ObjectType.code128,
                                         AVMetadataObject.ObjectType.ean8,
                                         AVMetadataObject.ObjectType.ean13,
                                         AVMetadataObject.ObjectType.aztec,
                                         AVMetadataObject.ObjectType.pdf417,
                                         AVMetadataObject.ObjectType.itf14,
                                         AVMetadataObject.ObjectType.dataMatrix,
                                         AVMetadataObject.ObjectType.interleaved2of5,
                                         AVMetadataObject.ObjectType.qr]
    
    
    @IBOutlet weak var previewView: QRCodeReaderView! {
        didSet {
            previewView.setupComponents(with: QRCodeReaderViewControllerBuilder {
                $0.reader                 = reader
                $0.showTorchButton        = false
                $0.showSwitchCameraButton = false
                $0.showCancelButton       = false
                $0.showOverlayView        = true
                $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
            })
        }
    }
    
    lazy var reader: QRCodeReader = QRCodeReader()

    lazy var readerVC: QRCodeReaderViewController = {
        
    let builder = QRCodeReaderViewControllerBuilder {
        $0.reader                  = QRCodeReader(metadataObjectTypes: supportedCodeTypes, captureDevicePosition: .back)
        $0.showTorchButton         = true
        $0.preferredStatusBarStyle = .lightContent
        $0.showOverlayView         = true
        $0.rectOfInterest          = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        
        $0.reader.stopScanningWhenCodeIsFound = false
    }
    
    return QRCodeReaderViewController(builder: builder)
}()
   
    // MARK: - Actions

    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
    //        if let url = URL(string: UIApplicationOpenSettingsURLString) {
    //           if UIApplication.shared.canOpenURL(url) {
    //              _ =  UIApplication.shared.open(url, options: [:], completionHandler: nil)
    //           }
    //        }
            
            switch error.code {
            
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
            
           }
        
        }
    
    func removeProductImage()  {
        
        for i in 0..<myProductArray.count {

            let dict = myProductArray[i] as! NSDictionary
            var prodArray = NSMutableArray()
            
            prodArray = dict.value(forKey: "productImages") as! NSMutableArray
            
            for j in 0..<prodArray.count {

                var prodDict = NSMutableDictionary()
                prodDict = prodArray[j] as! NSMutableDictionary
                if prodDict.value(forKey: "productImage") as? String == ""
                {
                prodArray.replaceObject(at: j, with: NSMutableDictionary())
                }
                else
                {
                    prodDict.removeObject(forKey: "productDisplayImage")
                    prodArray.replaceObject(at: j, with: prodDict)
                    
                }
                
            }
            
            dict.setValue(prodArray, forKey: "productImages")
            myProductArray.replaceObject(at: i, with: dict)
        }
    }
    
    func sendnamedfields(fieldname: String, idStr: String) {
        
        var dict = NSMutableDictionary()
        dict = myProductArray[catSubCatArrPosition] as! NSMutableDictionary

        if(catSubCatIndexPosition == 1005){ //Category Btn
            dict.setValue(idStr, forKey: "vendorId")
            dict.setValue(fieldname, forKey:"vendorName")
        }
        else if(catSubCatIndexPosition == 3000){ //Category Btn
            dict.setValue(fieldname, forKey: "category")
//            dict.setValue(idStr, forKey: "categoryId")
            
            dict.setValue("", forKey: "subCategory")
//            dict.setValue("", forKey: "subCategoryId")

        }else if(catSubCatIndexPosition == 3001){
            dict.setValue(fieldname, forKey: "subCategory")
//            dict.setValue(fieldname, forKey: "subCategoryId")

        }
        
        myProductArray.replaceObject(at:catSubCatArrPosition, with: dict)
        self.loadAddProductUI()
        
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)


    }
    
    func details(titlename: String, type: String, countrycode: String) {
        
    }
    
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        //        self.dismiss(animated: true, completion: nil)
                self.view.endEditing(true)
        if(isEditShopping == "ShoppingEdit" || isEditShopping == "SavingEdit"){
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
                if myProductArray.count>0
                {
                for i in 0..<myProductArray.count {

                    let dataDict = myProductArray[i] as! NSDictionary

                    let productNameStr = dataDict.value(forKey: productName) as? String ?? ""
                    let descStr = dataDict.value(forKey: prodDescription) as? String ?? ""
                    let stockQuanStr = dataDict.value(forKey: stockQuantity) as? String ?? ""
                    let expiryDateStr = dataDict.value(forKey: expiryDate) as? String ?? ""
                    let orderIdStr = dataDict.value(forKey: orderId) as? String ?? ""
                    let pricePerStockUnitStr = dataDict.value(forKey: unitPrice) as? String ?? ""
                    if(productNameStr == "" && descStr == "" && stockQuanStr == "" && expiryDateStr == "" && orderIdStr == "" && pricePerStockUnitStr == "" ){
                       
                       
                            
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                  let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingVC") as! ShoppingViewController
                                  VC.modalPresentationStyle = .fullScreen
        //                          self.present(VC, animated: true, completion: nil)
                            self.navigationController?.pushViewController(VC, animated: true)
                            
                       
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Exit", message: "Are you sure you want to exit? All the data will be lost.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title:"YES", style: .default, handler: { (_) in
                            
                           
                                
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                      let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingVC") as! ShoppingViewController
                                      VC.modalPresentationStyle = .fullScreen
            //                          self.present(VC, animated: true, completion: nil)
                                self.navigationController?.pushViewController(VC, animated: true)
                                
                         

                            
                        }))
                        
                        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                }
                else{
                    self.navigationController?.popViewController(animated: true)

                }
        }
                
            }
    
    @IBAction func homeBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @objc func addProdBtnTapped(_ sender: Any) {
        
        if(myProductArray.count > 19){
            
            self.showAlertWith(title: "Alert !!", message: "Cannot add more than 20 products at a time")
            return
        }
        
        self.addAnEmptyProduct()
        self.loadAddProductUI()

    }
    
    @IBOutlet weak var topMenuView: UIView!
    var myProductArray = NSMutableArray()
    var productScrollView = UIScrollView()
    var scrollViewYPos : CGFloat!

    var vendorListResult = [VendorListResult]()
    var shoppingCartData = [ShoppingCartResult]()
    var savedCartData = [SavedCartResult]()
    var indexPos = Int()
    
    var isEditShopping = String()
    
    var prodImgJPos : Int!
    var prodImgIArrayPos : Int!
    var prodImgTagValue : Int!
    
    var catSubCatArrPosition : Int!
    var catSubCatIndexPosition : Int!
    var catSubCatTagValue : Int!
    
    var selectedVendrorID : String!
    
    var idStr = String()
    var prodIDStr = String()
    var vendorIDStr = String()
    
    var categoryDataArray = NSMutableArray()
    var categoryIDArray = NSMutableArray()
    
    var addProdSerCntrl = ServiceController()
    
    var picker : UIDatePicker = UIDatePicker()
    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
    
    var purchase_ExpiryTagVal : Int!
    var purchase_expiryProductPosLev : Int!
    var purchase_expiryTagValue : Int!
//    var stockUnitDropDown = UIButton()
    var stockUnitsArr = [StockUnitMasterResultVo]()
    var priceUnitsArr = [PriceUnitResultVo]()
    var barCodeDetailsArr:BarCodeDetailsResultVo?
    var stockUnitIdsArr = [String]()
    var selectedStockId = ""
    let dropDown = DropDown()
    
    var accountID = ""
    
    var priceUnitNamesArr = [String]()
    var priceUnitIdsArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewYPos = 0
        barcodeShoppingList=[String]()
        shoppingCurrentInvStatusStr = ""
        shoppingCartStatusStr = ""
        shoppingOpenOrdersStatusStr = ""
        shoppingOrdersHistoryStatusStr = ""
        
        if(isEditShopping == "UseProductInfo"){
            
            
        }else if(isEditShopping == "ShoppingEdit" ){
            headerTitleLbl.text = "Shopping Cart Edit"
//            addProdBtn.isHidden = true
            
            addAnEmptyProduct()
            changeEditProductImagesData()
            
            idStr = shoppingCartData[indexPos]._id!
            prodIDStr = shoppingCartData[indexPos].productId!
            vendorIDStr = (shoppingCartData[indexPos].productDict?.vendorId)!

            topHeaderBackView.isHidden = true
            animatingView()
            
            if(myProductArray.count > 0){
                loadAddProductUI()

            }
            
        }else if(isEditShopping == "SavingEdit"){
            
            headerTitleLbl.text = "Saved Cart Edit"
//            addProdBtn.isHidden = true
            
            addAnEmptyProduct()
            changeSavedEditChangeEditProductImagesData()
            
            idStr = savedCartData[indexPos]._id!
            prodIDStr = savedCartData[indexPos].productId!
            vendorIDStr = (savedCartData[indexPos].productDict?.vendorId)!

            topHeaderBackView.isHidden = true
            animatingView()
            
            if(myProductArray.count > 0){
                loadAddProductUI()

            }

            
        }else if(isEditShopping == "OrderHistory"){
            
            headerTitleLbl.text = "Orders History"
//            addProdBtn.isHidden = true
            
            self.getOrdersHistoryAPI()
            
            
        }else{
            heightlength=250
            addAnEmptyProduct()
            get_StockUnitMaster_API_Call()
//            getVendorListDataFromServer()
            
            getCategoriesDataFromServer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadAddProductUI()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        
        shoppingInfoAddProdView.removeFromSuperview()
        
        get_StockUnitMaster_API_Call()
        getVendorListDataFromServer()
        get_PriceUnit_API_Call()

        getCategoriesDataFromServer()
        if(isEditShopping == "UseProductInfo"){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadAddProductUI()
            }
            }else if(isEditShopping == "ShoppingEdit" ){
        }else if(isEditShopping == "SavingEdit"){
        }else if(isEditShopping == "OrderHistory"){
        }
        else
        {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadAddProductUI()
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
    func get_barCodeDetails_API_Call(index:Int,productId:String) {
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let productIdStr = productId
        
        print(productIdStr)
        
        let urlStr = Constants.BaseUrl + barCodeDetailsUrl + productIdStr
//            "8901207038440"
        
        addProdSerCntrl.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:BarCodeDetailsRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            DispatchQueue.main.async {
                
                let status = respVo.statusCode
                let message = respVo.status
                
                if status == 200 {
                    
                    if message == "SUCCESS" {
                        if respVo.result != nil {
                                                        
                            if respVo.productDetailsFound == true {
                                                        self.barCodeDetailsArr = respVo.result
                                                        activity.stopAnimating()
                                                        self.view.isUserInteractionEnabled = true
                            //                            self.barCodeDetails()
                                                        
                            //                            self.productNameTF.text = respVo.result?.productName ?? ""
                            //                            self.productIDTF.text = respVo.result?.productUniqueNumber ?? ""
                            //                            self.descriptionTF.text = respVo.result?.description ?? ""
                                                        let imageee=respVo.result?.productImages?[0].productImage
                                                        self.addProductWithProdName(productName: respVo.result?.productName ?? "", prodDesc: respVo.result?.description ?? "", imageStr: imageee ?? "", location: "", productIdStr: respVo.result?.productUniqueNumber ?? "", index: index )
                                                        self.loadAddProductUI()
                                                        self.view.makeToast("Product details found")
                                                        }
                                                        else
                                                        {
                                                            self.barCodeThirdPartyAPI(index: index,productId: productId)
                                                        }

                        }
                        else {
                                                         
                                self.barCodeThirdPartyAPI(index: index, productId: productId)
                            
                        }
                    }
                }
                else {
                   self.view.makeToast(message)
                }
            }
        }) { (error) in
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.view.makeToast("Product details not found")
//            self.view.makeToast("app.SomethingWentToWrongAlert".localize())
            print("Oops, your connection seems off... Please try again later")
        }
    }
    
    func barCodeThirdPartyAPI(index:Int,productId:String){
        
        let productIdStr = productId ?? ""
//            "8901207038440"
        
        let SignStr = "\(productIdStr)".hmac(key: "Mc52Q8y3y1Gy0Pt8")
//        print("Result is \(SignStr)")
        
        let urlStr = "http://www.digit-eyes.com/gtin/v3_0/?upcCode=\(productIdStr)&language=en&app_key=/8WAVP//X3gQ&signature=\(SignStr)"
        
//        String url = "https://www.digit-eyes.com/gtin/v3_0/?upcCode=" + Upc + "&language=en&app_key=" + BARCODE_APP_KEY + "&signature=" + getsignature(Upc);
//        let urlStr = ""
        
        self.addProdSerCntrl.requestGETURL(strURL: urlStr, success: {(result) in
            
            let dataDictRes = result as! NSDictionary
            print("Result Data is \(dataDictRes)")
            let resspVo:BarCodeRespVo = Mapper().map(JSON: result as! [String : Any])!
//            if dataDictRes.value(forKey: "return_code") as? String == "995"
//                       {
//                           activity.stopAnimating()
//                           self.view.isUserInteractionEnabled = true
//                           self.view.makeToast("Product details not found")
//                       }
//                       else
//                       {
                       activity.stopAnimating()
                       self.view.isUserInteractionEnabled = true
            var productStatus=false
            if let pproduct=dataDictRes.value(forKey: "products") as? NSMutableArray
            {
                if pproduct.count>0
                {
                    productStatus=true
                }
                
            }
            self.parseBarCodeDataWithDict(dataDict: resspVo, index: index,productUniqueId:productIdStr, productStatus: productStatus)
                        self.view.makeToast("Product details found")
                                 // }

          
      }) { (error) in
          
            activity.stopAnimating()
                      self.view.isUserInteractionEnabled = true
                      self.view.makeToast("Product details not found")
          print("Something Went To Wrong...PLrease Try Again Later")
      }
    }
    func addBarCodeDetaulsAPI(prodId:String,prodName:String,prodDescription:String,prodImg:String,productStatus:Bool) {
          
                  activity.startAnimating()
                  self.view.isUserInteractionEnabled = false
                  
                  let URLString_loginIndividual = Constants.BaseUrl + "endUsers/barcode_details_add"
          
          let defaults = UserDefaults.standard
          accountID = (defaults.string(forKey: "accountId") ?? "")
          let userDefaults = UserDefaults.standard
          let userID = userDefaults.value(forKey: "userID") as! String
          
          let imagesArr = ["productImage":prodImg]
              
        var paramsDict=NSDictionary()
       
                              paramsDict = [
                                  "accountId":accountID,
                                  "addedByUserId":userID,"description":prodDescription,
                                  "productUniqueNumber":prodId,
                                  "barcode_id":prodId,
                                  "productImages":[imagesArr],
                                  "storageLocation":"SAHIBABAD",
                                  "userId":userID,
                                  "productName":prodName,
                                  "productDetailsFound":productStatus ] as NSDictionary
        
                                 
                              let postHeaders_IndividualLogin = ["":""]
                              
          addProdSerCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: paramsDict as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                                  
                                  let respVo:AddStockUnitMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
                                                          
                                  let status = respVo.STATUS_MSG
                                  let messageResp = respVo.message
                                  let statusCode = respVo.STATUS_CODE
                                  
                                  
                                  activity.stopAnimating()
                                  self.view.isUserInteractionEnabled = true
                                              
                                  if status == "SUCCESS" {
                                      
                                      if(statusCode == 200 ){
                                        
                                        
                                        if productStatus == false {
                                            
                                            self.tostM.shared.duration = 6
                                            self.view.makeToast("Product details not found")
                                        }
                                        else {
                                            self.tostM.shared.duration = 6
                                            self.view.makeToast("Product details found")
                                        }
                               
                                         // self.showSucessMsg(message: messageResp ?? "")
                                                                                  
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
    func parseBarCodeDataWithDict(dataDict:BarCodeRespVo,index:Int,productUniqueId:String,productStatus:Bool)  {
        
        if dataDict.products != nil {
            if dataDict.products!.count > 0 {
                self.view.makeToast("Product details found")
            let obj = dataDict.products?[0]
            let prodName = obj?.brand ?? ""
            let description = obj?.description ?? ""
            let imagePath = obj?.image ?? ""
            let productIdStr = obj?.upc_code ?? ""
            
            self.addBarCodeDetaulsAPI(prodId: productUniqueId ?? "", prodName: prodName ?? "", prodDescription: description ?? "", prodImg: imagePath,productStatus:productStatus)
            self.addProductWithProdName(productName: prodName ?? "", prodDesc: description ?? "", imageStr: imagePath, location: "", productIdStr: productUniqueId ?? "", index: index )
            self.loadAddProductUI()
            }
            else {
                self.view.makeToast("Product details not found")
                let prodName = ""
                let description = ""
                let imagePath = ""
                let locationStr = ""
                self.addBarCodeDetaulsAPI(prodId: productUniqueId ?? "", prodName: prodName ?? "", prodDescription: description ?? "", prodImg: imagePath,productStatus:false)
                addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr, productIdStr: productUniqueId, index: 0)
                loadAddProductUI()
            }
        }
        else {
            self.view.makeToast("Product details not found")
            let prodName = ""
            let description = ""
            let imagePath = ""
            let locationStr = ""
            self.addBarCodeDetaulsAPI(prodId: productUniqueId ?? "", prodName: prodName ?? "", prodDescription: description ?? "", prodImg: imagePath,productStatus:false)
            addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr, productIdStr: productUniqueId, index: 0)
            loadAddProductUI()
        }

        
//        let prodName = dataDict.value(forKey: "brand") as? String ?? ""
//        let description = dataDict.value(forKey: "description") as? String ?? ""
//        let imagePath = dataDict.value(forKey: "image") as? String ?? ""
        
//        let addressDict = dataDict.value(forKey: "gcp") as? NSDictionary
//        let locationStr = addressDict?.value(forKey: "city") as? String ?? ""
//        let productIdStr = dataDict.value(forKey: "upc_code") as? String ?? ""
        
//        self.productNameTF.text = prodName
//        self.productIDTF.text = productIdStr
//        self.descriptionTF.text = description
//        self.addBarCodeDetaulsAPI(prodId: productUniqueId ?? "", prodName: prodName ?? "", prodDescription: description ?? "", prodImg: imagePath, productStatus: productStatus)
//        self.addProductWithProdName(productName: prodName ?? "", prodDesc: description ?? "", imageStr: imagePath, location: "", productIdStr: productUniqueId ?? "", index: index )
//        self.loadAddProductUI()
//        self.removeEmptyObjects()
        
    }
    
    func barCodeDetails()  {
                
        let prodName = barCodeDetailsArr?.productName ?? ""
        let description = barCodeDetailsArr?.description ?? ""
        let imagePath =  barCodeDetailsArr?.productImages![0].productImage ?? ""
        
        let productIdStr =  barCodeDetailsArr?.productUniqueNumber ?? ""

        
//        if(previousStatusStr == ""){
//
//            myProductArray = NSMutableArray()
//            addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr)
//            loadAddProductUI()
//
//        }else if(previousStatusStr == presentStatusStr){
            
        addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: "", productIdStr: productIdStr, index: 0)
            loadAddProductUI()
            
//        }else{
//
//            myProductArray = NSMutableArray()
//            addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr)
//            loadAddProductUI()
//
//        }
        
        previousStatusStr = presentStatusStr

    }
    
    // MARK: Get AddressBook API Call
    func get_StockUnitMaster_API_Call() {
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let urlStr = Constants.BaseUrl + vendorGetAllStockUnitUrl + accountID
        
        addProdSerCntrl.requestGETURL(strURL: urlStr, success: {(result) in
            
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
    
    func shoppingResultDetails(billScanStatus: String, type: String, dataArray: NSMutableArray) {
        
        if(dataArray.count > 0){
            
            for i in 0..<dataArray.count {
                
                let dataDict = dataArray.object(at: i) as? NSDictionary
                myProductArray.add(dataDict!)
            }
        }
        
        loadAddProductUI()

    }
    
    func addAnEmptyProduct() {
       
        var myDict = NSMutableDictionary()
        
//      var prodImgArray =
        var prodImgDict = NSMutableDictionary()

        let prodImgArray = NSMutableArray()
        
        for _ in 0..<3 {

            prodImgDict = ["productImage": "","productDisplayImage":"","productServerImage":"","isLocalImg":"1"]
            prodImgArray.add(prodImgDict)
        }
        
        var accountID = String()
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        print(accountID)
        
        var userID = String()
        userID = (defaults.string(forKey: "userID") ?? "")
        print(userID)
        print(prodImgArray)
        
        let currentDate = Date()
        let eventDatePicker = UIDatePicker()
        
        eventDatePicker.datePickerMode = UIDatePicker.Mode.date
        eventDatePicker.minimumDate = currentDate
               
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let selectedDate = dateFormatter.string(from: eventDatePicker.date)
        
        myDict  = ["accountId": accountID, "productName": "", "productUniqueNumber": "","description": "","stockQuantity": "1.000","stockUnit": "","price": "","category": "","subCategory": "","vendorId": "","addedByUserId": userID,"productImages": prodImgArray,"purchaseDate":selectedDate,"vendorName":"","priceUnit": "616fd4205041085a07d69b1a",
                   "productDetailsFound": false,"unitPrice":"0", "unitPriceWarn":false,
                   "productNameWarn":false,
                   "stockQuantityWarn":false,"userId":userID]
        
        myProductArray.add(myDict)
        
    }
    
    func changeSavedEditChangeEditProductImagesData(){
        
        var dict = NSMutableDictionary()
        dict = myProductArray[0] as? NSMutableDictionary ?? NSMutableDictionary()
        var savedDict:SavedCartResult=savedCartData[indexPos] as! SavedCartResult
        var productImgArray = NSMutableArray()
        
        productImgArray = dict.value(forKey: "productImages") as! NSMutableArray
        
        let prodArray = savedCartData[indexPos].productDict?.productImages
        
        for i in 0..<3 {
            
            var  productImgict = NSMutableDictionary()
            
            if(prodArray?.count ?? 0  > 0){
                
                if(i == 0){
                    
                    let dict = prodArray?[0] as! NSDictionary
                    let imageStr = dict.value(forKey: "0") as! String
                    
                    let emptyData = NSData()
                    let imgUrl:String = imageStr as String
                    let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                    let imggg = Constants.BaseImageUrl + trimStr
                    let url:NSURL = NSURL(string : imggg)!
                    //Now use image to create into NSData format
                    let imageData:NSData = NSData.init(contentsOf: url as URL) ?? emptyData
                    let base64ImageStr = imageData.base64EncodedString(options: .lineLength64Characters)

                    
                    productImgict = productImgArray[0] as? NSMutableDictionary ?? NSMutableDictionary()
                    productImgict.setValue(base64ImageStr, forKey: "productImage")
                    productImgict.setValue("", forKey: "productDisplayImage")
                    productImgict.setValue(imageStr, forKey: "productServerImage")

                }else if(i == 1){
                    
                    let dict = prodArray?[0] as? NSDictionary
                    let imageStr = dict?.value(forKey: "1") as! String
                    
                    let emptyData = NSData()
                    let imgUrl:String = imageStr as String
                    let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                    let imggg = Constants.BaseImageUrl + trimStr
                    let url:NSURL = NSURL(string : imggg)!
                    //Now use image to create into NSData format
                    let imageData:NSData = NSData.init(contentsOf: url as URL) ?? emptyData
                    let base64ImageStr = imageData.base64EncodedString(options: .lineLength64Characters)

                    
                    productImgict = productImgArray[1] as! NSMutableDictionary
                    productImgict.setValue(base64ImageStr, forKey: "productImage")
                    productImgict.setValue("", forKey: "productDisplayImage")
                    productImgict.setValue(imageStr, forKey: "productServerImage")

                    
                }else{
                    
                    let dict = prodArray?[0] as? NSDictionary
                    let imageStr = dict?.value(forKey: "2") as! String
                    
                    let emptyData = NSData()
                    let imgUrl:String = imageStr as String
                    let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                    let imggg = Constants.BaseImageUrl + trimStr
                    let url:NSURL = NSURL(string : imggg)!
                    //Now use image to create into NSData format
                    let imageData:NSData = NSData.init(contentsOf: url as URL) ?? emptyData
                    let base64ImageStr = imageData.base64EncodedString(options: .lineLength64Characters)

                    productImgict = productImgArray[2] as! NSMutableDictionary
                    productImgict.setValue(base64ImageStr, forKey: "productImage")
                    productImgict.setValue("", forKey: "productDisplayImage")
                    productImgict.setValue(imageStr, forKey: "productServerImage")

                }
                
                productImgArray.replaceObject(at:i, with: productImgict)
                print(productImgArray)

            }
        }
        
//        productIDTF.text = shoppingCartData[indexPos].productDict?.productUniqueNumber!
//        productNameTF.text = shoppingCartData[indexPos].productDict?.productName!
//        descriptionTF.text =       shoppingCartData[indexPos].productDict?.description!
//        reqQunatityTF.text = String(shoppingCartData[indexPos].requiredQuantity!)
//        stockUnitTF.text = shoppingCartData[indexPos].productDict?.stockUnit!
//        vendorNameDropDown.setTitle(shoppingCartData[indexPos].productDict?.productName, for: .normal)
//        priceTF.text = shoppingCartData[indexPos].productDict?.price!
//
//        let purcDate = (shoppingCartData[indexPos].plannedPurchasedate)!
//        let convertedPurchaseDate = convertDateFormatter(date: purcDate)
//
//        purchaseDateTF.setTitle(convertedPurchaseDate, for: .normal)

        
//        myDict  = ["accountId": accountID, "productName": "", "productUniqueNumber": "","description": "","stockQuantity": "","stockUnit": "","price": "","vendorId": "","addedByUserId": userID,"productImages": prodImgArray,"purchaseDate":"","vendorName":""]
        
        dict.setValue(savedCartData[indexPos].productDict?.productName, forKey: "productName")
        dict.setValue(savedCartData[indexPos].productDict?.productUniqueNumber, forKey: "productUniqueNumber")
        dict.setValue(savedCartData[indexPos].productDict?.description, forKey: "description")
        dict.setValue(String((savedCartData[indexPos].productDict?.stockQuantity) ?? 0), forKey: "stockQuantity")
        if savedCartData[indexPos].stockUnitDetails?.count ?? 0>0
        {
        dict.setValue(savedCartData[indexPos].stockUnitDetails?[0].stockUnitName, forKey: "stockUnit")
        dict.setValue(savedCartData[indexPos].stockUnitDetails?[0]._id, forKey: "stockUnitId")
        }
        else
        {
        dict.setValue("", forKey: "stockUnit")
        dict.setValue("", forKey: "stockUnitId")
        }
        dict.setValue(String((savedCartData[indexPos].productDict?.price) ?? 0), forKey: "price")
        dict.setValue(savedCartData[indexPos].productDict?.vendorId, forKey: "vendorId")
        dict.setValue(savedCartData[indexPos].productDict?.category, forKey: "category")
        dict.setValue(savedCartData[indexPos].productDict?.subCategory, forKey: "subCategory")
        dict.setValue(String((savedCartData[indexPos].productDict?.unitPrice) ?? 0), forKey: "unitPrice")
       
        let vendorDict = (savedCartData[indexPos].vendordetails)
        let vendorName = vendorDict?.value(forKey: "vendorName")
        
        dict.setValue(vendorName, forKey: "vendorName")
        
        selectedCategoryID = (savedCartData[indexPos].productDict?.category)

        let purcDate = (savedCartData[indexPos].plannedPurchasedate) ?? ""

//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "dd/MM/yyyy'T'HH:mm:ss.SSSZ"
//
//       let convertedDate = dateFormatter.date(from: purcDate)
//
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//
//        if(convertedDate == nil){
//            dict.setValue("", forKey: "purchaseDate")
//
//        }else{
//            let timeStamp = dateFormatter.string(from: convertedDate!)
//            dict.setValue(timeStamp, forKey: "purchaseDate")
//
//        }
        
        dict.setValue(purcDate, forKey: "purchaseDate")
        dict.setValue(productImgArray, forKey: "productImages")
        myProductArray.replaceObject(at:0 , with: dict)
        
        print(myProductArray)

    }
    
    func changeEditProductImagesData(){
        
        var dict = NSMutableDictionary()
        dict = myProductArray[0] as? NSMutableDictionary ?? NSMutableDictionary()
        
        var productImgArray = NSMutableArray()
        
        productImgArray = dict.value(forKey: "productImages") as! NSMutableArray
        
        let prodArray = shoppingCartData[indexPos].productDict?.productImages
        
        for i in 0..<3 {
            
            var  productImgict = NSMutableDictionary()
            
            if(prodArray?.count ?? 0  > 0){
                
                if(i == 0){
                    
                    let dict = prodArray?[0] as? NSDictionary
                    let imageStr = dict?.value(forKey: "0") as! String
                    
                    let emptyData = NSData()
                    let imgUrl:String = imageStr as String
                    let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                    let imggg = Constants.BaseImageUrl + trimStr
                    let url:NSURL = NSURL(string : imggg)!
                    //Now use image to create into NSData format
                    let imageData:NSData = NSData.init(contentsOf: url as URL) ?? emptyData
                    let base64ImageStr = imageData.base64EncodedString(options: .lineLength64Characters)

                    
                    productImgict = productImgArray[0] as? NSMutableDictionary ?? NSMutableDictionary()
                    productImgict.setValue(base64ImageStr, forKey: "productImage")
                    productImgict.setValue("", forKey: "productDisplayImage")
                    productImgict.setValue(imageStr, forKey: "productServerImage")

                }else if(i == 1){
                    
                    let dict = prodArray?[0] as? NSDictionary
                    let imageStr = dict?.value(forKey: "1") as! String
                    
                    let emptyData = NSData()
                    let imgUrl:String = imageStr as String
                    let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                    let imggg = Constants.BaseImageUrl + trimStr
                    let url:NSURL = NSURL(string : imggg)!
                    //Now use image to create into NSData format
                    let imageData:NSData = NSData.init(contentsOf: url as URL) ?? emptyData
                    let base64ImageStr = imageData.base64EncodedString(options: .lineLength64Characters)

                    
                    productImgict = productImgArray[1] as! NSMutableDictionary
                    productImgict.setValue(base64ImageStr, forKey: "productImage")
                    productImgict.setValue("", forKey: "productDisplayImage")
                    productImgict.setValue(imageStr, forKey: "productServerImage")

                    
                }else{
                    
                    let dict = prodArray?[0] as? NSDictionary
                    let imageStr = dict?.value(forKey: "2") as! String
                    
                    let emptyData = NSData()
                    let imgUrl:String = imageStr as String
                    let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                    let imggg = Constants.BaseImageUrl + trimStr
                    let url:NSURL = NSURL(string : imggg)!
                    //Now use image to create into NSData format
                    let imageData:NSData = NSData.init(contentsOf: url as URL) ?? emptyData
                    let base64ImageStr = imageData.base64EncodedString(options: .lineLength64Characters)
                    
                    productImgict = productImgArray[2] as! NSMutableDictionary
                    productImgict.setValue(base64ImageStr, forKey: "productImage")
                    productImgict.setValue("", forKey: "productDisplayImage")
                    productImgict.setValue(imageStr, forKey: "productServerImage")

                }
                
                productImgArray.replaceObject(at:i, with: productImgict)
                print(productImgArray)

            }
        }
        
//        productIDTF.text = shoppingCartData[indexPos].productDict?.productUniqueNumber!
//        productNameTF.text = shoppingCartData[indexPos].productDict?.productName!
//        descriptionTF.text =       shoppingCartData[indexPos].productDict?.description!
//        reqQunatityTF.text = String(shoppingCartData[indexPos].requiredQuantity!)
//        stockUnitTF.text = shoppingCartData[indexPos].productDict?.stockUnit!
//        vendorNameDropDown.setTitle(shoppingCartData[indexPos].productDict?.productName, for: .normal)
//        priceTF.text = shoppingCartData[indexPos].productDict?.price!
//
//        let purcDate = (shoppingCartData[indexPos].plannedPurchasedate)!
//        let convertedPurchaseDate = convertDateFormatter(date: purcDate)
//
//        purchaseDateTF.setTitle(convertedPurchaseDate, for: .normal)

        
//        myDict  = ["accountId": accountID, "productName": "", "productUniqueNumber": "","description": "","stockQuantity": "","stockUnit": "","price": "","vendorId": "","addedByUserId": userID,"productImages": prodImgArray,"purchaseDate":"","vendorName":""]
        
        dict.setValue(shoppingCartData[indexPos].productDict?.productName, forKey: "productName")
        dict.setValue(shoppingCartData[indexPos].productDict?.productUniqueNumber, forKey: "productUniqueNumber")
        dict.setValue(shoppingCartData[indexPos].productDict?.description, forKey: "description")
        dict.setValue(String((shoppingCartData[indexPos].requiredQuantity) ?? 0), forKey: "stockQuantity")
        if shoppingCartData[indexPos].stockUnitDetails?.count ?? 0>0
        {
        dict.setValue(shoppingCartData[indexPos].stockUnitDetails?[0].stockUnitName, forKey: "stockUnit")
       
        dict.setValue(shoppingCartData[indexPos].stockUnitDetails?[0]._id, forKey: "stockUnitId")
        }
        else
        {
        dict.setValue("", forKey: "stockUnit")
       
        dict.setValue("", forKey: "stockUnitId")
        }
        dict.setValue(String((shoppingCartData[indexPos].productDict?.price) ?? 0), forKey: "price")
        dict.setValue(shoppingCartData[indexPos].productDict?.vendorId, forKey: "vendorId")
        dict.setValue(shoppingCartData[indexPos].productDict?.category, forKey: "category")
        dict.setValue(shoppingCartData[indexPos].productDict?.subCategory, forKey: "subCategory")
        dict.setValue(String((shoppingCartData[indexPos].productDict?.unitPrice) ?? 0), forKey: "unitPrice")
        if shoppingCartData[indexPos].priceUnitDetails?.count ?? 0>0
        {
        dict.setValue(shoppingCartData[indexPos].priceUnitDetails?[0].priceUnit, forKey: "priceUnit")
        }
        else
        {
        dict.setValue("", forKey: "priceUnit")
        }
        
        let vendorDict = (shoppingCartData[indexPos].vendordetails)
        let vendorName = vendorDict?.value(forKey: "vendorName")
        
        dict.setValue(vendorName, forKey: "vendorName")
        
        selectedCategoryID = (shoppingCartData[indexPos].productDict?.category)

        let purcDate = (shoppingCartData[indexPos].plannedPurchasedate) ?? ""
//        let convertedPurchaseDate = convertDateFormatter(date: purcDate)

//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "dd/MM/yyyy'T'HH:mm:ss.SSSZ"
//
//    let convertedDate = dateFormatter.date(from: purcDate)
//
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//        let timeStamp = dateFormatter.string(from: convertedDate!)

        dict.setValue(purcDate, forKey: "purchaseDate")

        dict.setValue(productImgArray, forKey: "productImages")
        myProductArray.replaceObject(at:0 , with: dict)
        
        print(myProductArray)

    }
    
    func changeOrdersHistoryData(){
        
        for j in 0..<ordersHistoryResult.count{
            
            var productsList = [OrdersHistoryProducts]()
            productsList = ordersHistoryResult[j].productsList!

            for k in 0..<productsList.count{
                
                let prodDict = NSMutableDictionary()
                
                let prodDetails = productsList[k].productDetails!

                let prodArray = prodDetails.productImages

                let prodImgArray = NSMutableArray()

                for i in 0..<3 {
                    
                    let  productImgict = NSMutableDictionary()
                    
                    if(prodArray?.count ?? 0  > 0){
                        
                        if(i == 0){
                            
                            let dict = prodArray?[0] as? NSDictionary
                            let imageStr = dict?.value(forKey: "0") as! String
                            
                            productImgict.setValue("", forKey: "productImage")
                            productImgict.setValue("", forKey: "productDisplayImage")
                            productImgict.setValue(imageStr, forKey: "productServerImage")

                        }else if(i == 1){
                            
                            let dict = prodArray?[0] as? NSDictionary
                            let imageStr = dict?.value(forKey: "1") as! String
                            
                            productImgict.setValue("", forKey: "productImage")
                            productImgict.setValue("", forKey: "productDisplayImage")
                            productImgict.setValue(imageStr, forKey: "productServerImage")

                            
                        }else{
                            
                            let dict = prodArray?[0] as? NSDictionary
                            let imageStr = dict?.value(forKey: "2") as! String
                            
                            productImgict.setValue("", forKey: "productImage")
                            productImgict.setValue("", forKey: "productDisplayImage")
                            productImgict.setValue(imageStr, forKey: "productServerImage")

                        }
                        
                        prodImgArray.add(productImgict)

                    }else{
                        
                        productImgict.setValue("", forKey: "productImage")
                        productImgict.setValue("", forKey: "productDisplayImage")
                        productImgict.setValue("", forKey: "productServerImage")

                        prodImgArray.add(productImgict)

                    }
                }
                
                prodDict.setValue(prodDetails.productName, forKey: "productName")
                prodDict.setValue(prodDetails.productUniqueNumber, forKey: "productUniqueNumber")
                prodDict.setValue(prodDetails.description, forKey: "description")
                prodDict.setValue(prodDetails.stockQuantity, forKey: "stockQuantity")
                prodDict.setValue(prodDetails.stockUnit, forKey: "stockUnit")
                prodDict.setValue(String((prodDetails.price)!), forKey: "price")
                prodDict.setValue(prodDetails.vendorId, forKey: "vendorId")
                prodDict.setValue("616fd4205041085a07d69b1a", forKey: "priceUnit")
                prodDict.setValue(false, forKey: "productDetailsFound")

                let purcDate = (prodDetails.purchaseDate)!
                let convertedPurchaseDate = convertDateFormatter(date: purcDate)

                prodDict.setValue(convertedPurchaseDate, forKey: "purchaseDate")

                prodDict.setValue(prodImgArray, forKey: "productImages")
                myProductArray.add(prodDict)
                
            }
        }
        
        if(myProductArray.count > 0){
            loadAddProductUI()

        }
        
        print(myProductArray)
        
    }
    @IBAction func manualBtnTapped(_ sender: Any) {
    }
   
    @IBAction func barCodeBtnTapped(_ sender: Any) {
        fromButton="barcode"
        var valueQR=String()
        self.heightlength=250
        var productUniqueID=String()
        self.removeEmptyObjects{ () -> () in
            var productArrayPosition = Int()
//                       let sstag:String = String((sender as AnyObject).tag)
//                       if sstag.count>5
//                       {
//                        productArrayPosition = (sender as AnyObject).tag%100
//
//                       }
//                       else
//                       {
                        productArrayPosition = self.myProductArray.count-1
                           
                      // }
                           print(productArrayPosition)
        guard checkScanPermissions() else { return }

        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               =  self

        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                let aa:String=result.value
               
                if valueQR != aa
                                       {
                                           print(true)
                                       
                               print("Completion with result: \(result.value) of type \(result.metadataType)")
                                       valueQR=aa
                    productUniqueID=result.value
                    activity.startAnimating()
                     self.view.isUserInteractionEnabled = false
                let urlStr = Constants.BaseUrl + barCodeDetailsUrl + result.value
        //            "8901207038440"
                
                self.addProdSerCntrl.requestGETURL(strURL: urlStr, success: {(result) in
                    
                    let respVo:BarCodeDetailsRespVo = Mapper().map(JSON: result as! [String : Any])!
                    
                    DispatchQueue.main.async {
                        
                        let status = respVo.statusCode
                        let message = respVo.status
                        
                        if status == 200 {
                            
                            if message == "SUCCESS" {
                                if respVo.result != nil {
                                    if respVo.productDetailsFound == true {
                                    self.barCodeDetailsArr = respVo.result
      
                                    let imageee=respVo.result?.productImages?[0].productImage
                                    self.addProductWithProdName(productName: respVo.result?.productName ?? "", prodDesc: respVo.result?.description ?? "", imageStr: imageee ?? "", location: "", productIdStr: respVo.result?.productUniqueNumber ?? "", index: productArrayPosition )
                                    self.loadAddProductUI()
                                    activity.stopAnimating()
                                     self.view.isUserInteractionEnabled = true
                                    self.view.makeToast("Product details found")
                                }
                                else {
                                                                
                                        activity.startAnimating()
                                        self.view.isUserInteractionEnabled = false
                                   
//    var urlString = "https://barcode-lookup.p.rapidapi.com/v2/products?barcode=\(result.value)"
           
                                        let SignStr = "\(aa)".hmac(key: "Mc52Q8y3y1Gy0Pt8")
                print("Result is \(SignStr)")

                                        let urlStr = "http://www.digit-eyes.com/gtin/v3_0/?upcCode=\(aa)&language=en&app_key=/8WAVP//X3gQ&signature=\(SignStr)"

                self.addProdSerCntrl.requestGETURL(strURL: urlStr, success: {(result) in

                    let dataDictRes = result as! NSDictionary
                    print("Result Data is \(dataDictRes)")
                    let resspVo:BarCodeRespVo = Mapper().map(JSON: result as! [String : Any])!
//                    if dataDictRes.value(forKey: "return_code") as? String == "995" || dataDictRes.value(forKey: "return_code") as? String == "999"
//                                                                                      {
//                                                  activity.stopAnimating()
//                                                  self.view.isUserInteractionEnabled = true
//                                                  self.view.makeToast("Product details not found")
//                                              }
//                                              else
//                                              {
                                              activity.stopAnimating()
                                              self.view.isUserInteractionEnabled = true
                    var productStatus=false
                    if let pproduct=dataDictRes.value(forKey: "products") as? NSMutableArray
                    {
                        if pproduct.count>0
                        {
                            productStatus=true
                        }
                        
                    }
                    self.parseQRCodeDataWithDict(dataDict: resspVo, productUniqueId: productUniqueID, productStatus: productStatus)
//                                                self.view.makeToast("Product details found")
                                                                           //}
                  
              }) { (error) in
                  
                    activity.stopAnimating()
                                             self.view.isUserInteractionEnabled = true
                                             print("Something Went To Wrong...PLrease Try Again Later")

                  print("Something Went To Wrong...PLrease Try Again Later")
              }
                                    
                                     
                                }
                            }
                                else
                                {
                                    
                                    
                                    //    var urlString = "https://barcode-lookup.p.rapidapi.com/v2/products?barcode=\(result.value)"
                                    activity.startAnimating()
                                                                                  self.view.isUserInteractionEnabled = false
                                    
                                    let SignStr = "\(aa)".hmac(key: "Mc52Q8y3y1Gy0Pt8")
                                                    print("Result is \(SignStr)")

                                    let urlStr = "http://www.digit-eyes.com/gtin/v3_0/?upcCode=\(aa)&language=en&app_key=/8WAVP//X3gQ&signature=\(SignStr)"

                                                    self.addProdSerCntrl.requestGETURL(strURL: urlStr, success: {(result) in

                                                        let dataDictRes = result as! NSDictionary
                                                        print("Result Data is \(dataDictRes)")
                                                        let resspVo:BarCodeRespVo = Mapper().map(JSON: result as! [String : Any])!
//                                                        if dataDictRes.value(forKey: "return_code") as? String == "995" || dataDictRes.value(forKey: "return_code") as? String == "999"
//                                                                                                                           {
//                                                                                                                               activity.stopAnimating()
//                                                                                                                               self.view.isUserInteractionEnabled = true
//                                                                                                                               self.view.makeToast("Product details not found")
//                                                                                                                           }
//                                                                                                                           else
//                                                                                                                           {
                                                                                                                           activity.stopAnimating()
                                                                                                                           self.view.isUserInteractionEnabled = true
                                                        var productStatus=false
                                                        if let pproduct=dataDictRes.value(forKey: "products") as? NSMutableArray
                                                        {
                                                            if pproduct.count>0
                                                            {
                                                                productStatus=true
                                                            }
                                                            
                                                        }
                                                        self.parseQRCodeDataWithDict(dataDict: resspVo, productUniqueId: productUniqueID, productStatus: productStatus)
//                                                                                                                            self.view.makeToast("Product details found")
                                                                                                                                                                                                //}
                                                      
                                                  }) { (error) in
                                                      
                                                        activity.stopAnimating()
                                                                                                                         self.view.isUserInteractionEnabled = true
                                                                                                                         print("Something Went To Wrong...PLrease Try Again Later")
                                                                                                                           self.view.makeToast("Product details not found")

                                                  }
                                                                        }
                        }
                        else {
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
        //                    self.view.makeToast(message)
                            self.view.makeToast("Product details not found")
                        }
                    }
                    }
                }) { (error) in
                    activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
        //            self.view.makeToast("app.SomethingWentToWrongAlert".localize())
                    self.view.makeToast("Product details not found")
                    print("Oops, your connection seems off... Please try again later")
                }
            }
                
                }
            
               }

        present(readerVC, animated: true, completion: nil)
        }
    }
    
    func parseQRCodeDataWithDict(dataDict:BarCodeRespVo,productUniqueId:String,productStatus:Bool)  {
        
        if dataDict.products != nil {
           if dataDict.products!.count > 0 {
               self.view.makeToast("Product details found")
               let obj = dataDict.products?[0]
               let prodName = obj?.brand ?? ""
               let description = obj?.description ?? ""
               let imagePath = obj?.image ?? ""
               let addressDict = obj?.gcp
               let locationStr = obj?.manufacturer?.value(forKey: "city") as? String ?? ""
               let productIdStr = obj?.upc_code ?? ""
               
               self.addBarCodeDetaulsAPI(prodId: productUniqueId ?? "", prodName: prodName ?? "", prodDescription: description ?? "", prodImg: imagePath,productStatus:productStatus)
               addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr, productIdStr: productUniqueId, index: 0)
               loadAddProductUI()
           }
           else {
               self.view.makeToast("Product details not found")
               let prodName = ""
               let description = ""
               let imagePath = ""
               let locationStr = ""
               self.addBarCodeDetaulsAPI(prodId: productUniqueId ?? "", prodName: prodName ?? "", prodDescription: description ?? "", prodImg: imagePath,productStatus:false)
               addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr, productIdStr: productUniqueId, index: 0)
               loadAddProductUI()
           }
       }
        else {
           self.view.makeToast("Product details not found")
           let prodName = ""
           let description = ""
           let imagePath = ""
           let locationStr = ""
           self.addBarCodeDetaulsAPI(prodId: productUniqueId ?? "", prodName: prodName ?? "", prodDescription: description ?? "", prodImg: imagePath,productStatus:false)
           addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr, productIdStr: productUniqueId, index: 0)
           loadAddProductUI()
        }
        
//        let prodName = dataDict.value(forKey: "brand") as? String ?? ""
//        let description = dataDict.value(forKey: "description") as? String ?? ""
//        let imagePath = dataDict.value(forKey: "image") as? String ?? ""
//
//        let addressDict = dataDict.value(forKey: "gcp") as? NSDictionary ?? NSDictionary()
//        let locationStr = addressDict.value(forKey: "city") as? String ?? ""
//        let productIdStr = dataDict.value(forKey: "upc_code") as? String ?? ""

        //        self.addBarCodeDetaulsAPI(prodId: productUniqueId ?? "", prodName: prodName ?? "", prodDescription: description ?? "", prodImg: imagePath, productStatus: productStatus)
        //        addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr, productIdStr: productUniqueId, index: 0)
        //            loadAddProductUI()
        
//        if(previousStatusStr == ""){
//
//            myProductArray = NSMutableArray()
//            addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr)
//            loadAddProductUI()
//
//        }else if(previousStatusStr == presentStatusStr){
//        self.addBarCodeDetaulsAPI(prodId: productUniqueId ?? "", prodName: prodName ?? "", prodDescription: description ?? "", prodImg: imagePath, productStatus: productStatus)
//        addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr, productIdStr: productUniqueId, index: 0)
//            loadAddProductUI()
            
//        }else{
//
//            myProductArray = NSMutableArray()
//            addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr)
//            loadAddProductUI()
//
//        }
        
        previousStatusStr = presentStatusStr

    }
    
    func addProductWithProdName(productName:String,prodDesc:String,imageStr:String,location:String,productIdStr:String,index:Int)  {
        if(myProductArray.count > 19){
            
            self.showAlertWith(title: "Alert !!", message: "Cannot add more than 20 products at a time")
            return
        }
        else
        {
        self.heightlength=250
        let emptyData = NSData()
        
        let url:NSURL = NSURL(string : imageStr)!
        //Now use image to create into NSData format
        let imageData:NSData = NSData.init(contentsOf: url as URL) ?? emptyData
        
        let base64ImageStr = imageData.base64EncodedString(options: .lineLength64Characters)

        
        if(myProductArray.count == 1){
            
            let dataDict = myProductArray.object(at: 0) as? NSDictionary

            var myDict = NSMutableDictionary()

    //        var prodImgArray =
            var prodImgDict = NSMutableDictionary()

            let prodImgArray = NSMutableArray()
            for i in 0..<3 {

                if(i == 0){
                    prodImgDict = ["productImage": base64ImageStr,"productDisplayImage":imageStr,"isLocalImg":"BillScan"]
                    prodImgArray.add(prodImgDict)

                }else{
                    prodImgDict = ["productImage": "","productDisplayImage":"","isLocalImg":"1"]
                    prodImgArray.add(prodImgDict)

                }
            }

            var accountID = String()
            let defaults = UserDefaults.standard
            accountID = (defaults.string(forKey: "accountId") ?? "")
            print(accountID)

            var userID = String()
            userID = (defaults.string(forKey: "userID") ?? "")
            print(userID)
            print(prodImgArray)

            let currentDate = Date()
            let eventDatePicker = UIDatePicker()

            eventDatePicker.datePickerMode = UIDatePicker.Mode.date
            eventDatePicker.minimumDate = currentDate

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"

            let selectedDate = dateFormatter.string(from: eventDatePicker.date)


            
            if fromButton=="search"
                      {
                      
                      myDict  = ["accountId": accountID, "productName": productName, "productUniqueNumber": productIdStr,"description": prodDesc,"stockQuantity": "1.000","stockUnit": "","purchaseDate": selectedDate,"expiryDate": "","storageLocation": location,"borrowed": "","category": "","subCategory": "","orderId": "","vendorId": "","price": "","uploadType": "","userId": userID,"productImages": prodImgArray,"vendorName":"","isActive":"1","priceUnit": "616fd4205041085a07d69b1a","productDetailsFound": false, "unitPriceWarn":false,
                                 "productNameWarn":false,"unitPrice":"0",
                                 "stockQuantityWarn":false]
                      }
                      else
                      {
                        myDict  = ["accountId": accountID, "productName": productName, "productUniqueNumber": productIdStr,"description": prodDesc,"stockQuantity": "1.000","stockUnit": "","purchaseDate": selectedDate,"expiryDate": "","storageLocation": location,"borrowed": "","category": "","subCategory": "","orderId": "","vendorId": "","price": "","uploadType": "","userId": userID,"productImages": prodImgArray,"vendorName":"","isActive":"1","priceUnit": "616fd4205041085a07d69b1a","productDetailsFound": false, "unitPriceWarn":false,"unitPrice":"0",
                                     "productNameWarn":false,
                                     "stockQuantityWarn":false]
                      }


//            myProductArray.add(myDict)
            
                            let prodName = dataDict?.value(forKey: "productName") as? String ?? ""
                            let prodID = dataDict?.value(forKey: "productUniqueNumber") as? String ?? ""
                            let desc = dataDict?.value(forKey: "description") as? String ?? ""
                            let stockQuantity = dataDict?.value(forKey: "stockQuantity") as? String ?? ""
                            let stockUnit = dataDict?.value(forKey: "stockUnit") as? String
                            let expiryDate = dataDict?.value(forKey: "expiryDate") as? String ?? ""
                            let storageLocation = dataDict?.value(forKey: "storageLocation") as? String ?? ""
                            let category = dataDict?.value(forKey: "category") as? String
                            let subCategory = dataDict?.value(forKey: "subCategory") as? String
                            let orderId = dataDict?.value(forKey: "orderId") as? String ?? ""
                            let vendorId = dataDict?.value(forKey: "vendorId") as? String ?? ""
                            let price = dataDict?.value(forKey: "price") as? String ?? ""
                            let priceUnit = dataDict?.value(forKey: "priceUnit") as? String
                            let productDetailsValue = dataDict?.value(forKey: "productDetailsFound") as? String
if fromButton=="search"
{
               
    myDict.setValue(stockQuantity, forKey: "stockQuantity")
    myDict.setValue(orderId, forKey: "orderId")
    myDict.setValue(expiryDate, forKey: "expiryDate")
    myDict.setValue(price, forKey: "price")
    myDict.setValue(dataDict?.value(forKey: "unitPrice") as? String ?? "", forKey: "unitPrice")
    
                if(prodName == "" && desc == "" && expiryDate == "" && orderId == "" && price == "" ){

                    myProductArray.replaceObject(at: 0, with: myDict)

                }else{
                    myProductArray.replaceObject(at: 0, with: myDict)

                }
    fromButton=""
}
            else
{
    if(prodName == "" && prodID == "" && desc == "" && expiryDate == "" && orderId == "" && price == "" ){

        myProductArray.replaceObject(at: 0, with: myDict)

    }else{
        myProductArray.add(myDict)

    }
}
           }
        else if myProductArray.count>1
        {
            
            let dataDict = myProductArray.object(at: index) as? NSDictionary

            var myDict = NSMutableDictionary()

    //        var prodImgArray =
            var prodImgDict = NSMutableDictionary()

            let prodImgArray = NSMutableArray()
            for i in 0..<3 {

                if(i == 0){
                    prodImgDict = ["productImage": base64ImageStr,"productDisplayImage":imageStr,"isLocalImg":"BillScan"]
                    prodImgArray.add(prodImgDict)

                }else{
                    prodImgDict = ["productImage": "","productDisplayImage":"","isLocalImg":"1"]
                    prodImgArray.add(prodImgDict)

                }
            }

            var accountID = String()
            let defaults = UserDefaults.standard
            accountID = (defaults.string(forKey: "accountId") ?? "")
            print(accountID)

            var userID = String()
            userID = (defaults.string(forKey: "userID") ?? "")
            print(userID)
            print(prodImgArray)

            let currentDate = Date()
            let eventDatePicker = UIDatePicker()

            eventDatePicker.datePickerMode = UIDatePicker.Mode.date
            eventDatePicker.minimumDate = currentDate

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"

            let selectedDate = dateFormatter.string(from: eventDatePicker.date)


            
            if fromButton=="search"
                       {
                       
                       myDict  = ["accountId": accountID, "productName": productName, "productUniqueNumber": productIdStr,"description": prodDesc,"stockQuantity": "1.000","stockUnit": "","purchaseDate": selectedDate,"expiryDate": "","storageLocation": location,"borrowed": "","category": "","subCategory": "","orderId": "","vendorId": "","price": "","uploadType": "","userId": userID,"productImages": prodImgArray,"vendorName":"","isActive":"1","priceUnit": "616fd4205041085a07d69b1a","productDetailsFound": false,"unitPrice":"0", "unitPriceWarn":false,
                                  "productNameWarn":false,
                                  "stockQuantityWarn":false]
                       }
                       else
                       {
                           myDict  = ["accountId": accountID, "productName": productName, "productUniqueNumber": productIdStr,"description": prodDesc,"stockQuantity": "1.000","stockUnit": "","purchaseDate": selectedDate,"expiryDate": "","storageLocation": location,"borrowed": "","category": "","subCategory": "","orderId": "","vendorId": "","price": "","uploadType": "","userId": userID,"productImages": prodImgArray,"vendorName":"","isActive":"1","priceUnit": "616fd4205041085a07d69b1a","productDetailsFound": false, "unitPriceWarn":false,"unitPrice":"0",
                                      "productNameWarn":false,
                                      "stockQuantityWarn":false]
                       }

//            myProductArray.add(myDict)
            
                            let prodName = dataDict?.value(forKey: "productName") as? String ?? ""
                            let prodID = dataDict?.value(forKey: "productUniqueNumber") as? String ?? ""
                            let desc = dataDict?.value(forKey: "description") as? String ?? ""
                            let stockQuantity = dataDict?.value(forKey: "stockQuantity") as? String ?? ""
                            let stockUnit = dataDict?.value(forKey: "stockUnit") as? String ?? ""
                            let expiryDate = dataDict?.value(forKey: "expiryDate") as? String ?? ""
                            let storageLocation = dataDict?.value(forKey: "storageLocation") as? String ?? ""
                            let category = dataDict?.value(forKey: "category") as? String ?? ""
                            let subCategory = dataDict?.value(forKey: "subCategory") as? String ?? ""
                            let orderId = dataDict?.value(forKey: "orderId") as? String ?? ""
                            let vendorId = dataDict?.value(forKey: "vendorId") as? String ?? ""
                            let price = dataDict?.value(forKey: "price") as? String ?? ""
                            let priceUnit = dataDict?.value(forKey: "priceUnit") as? String
                            let productDetailsValue = dataDict?.value(forKey: "productDetailsFound") as? String
            if fromButton=="search"
            {
                myDict.setValue(stockQuantity, forKey: "stockQuantity")
                   myDict.setValue(orderId, forKey: "orderId")
                   myDict.setValue(expiryDate, forKey: "expiryDate")
                   myDict.setValue(price, forKey: "price")
                   myDict.setValue(dataDict?.value(forKey: "unitPrice") as? String ?? "", forKey: "unitPrice")
                   
                               if(prodName == "" && desc == "" && expiryDate == "" && orderId == "" && price == "" ){

                                   myProductArray.replaceObject(at: index, with: myDict)

                               }else{
                                   myProductArray.replaceObject(at: index, with: myDict)

                               }
                fromButton=""
            }
            else
            {
                if(prodName == "" && prodID == "" && desc == "" && expiryDate == "" && orderId == "" && price == "" ){

                    myProductArray.replaceObject(at: index, with: myDict)

                }else{
                    myProductArray.add(myDict)

                }
            }
           }
        else{

        var myDict = NSMutableDictionary()

    //        var prodImgArray =
            var prodImgDict = NSMutableDictionary()

            let prodImgArray = NSMutableArray()
        
            for i in 0..<3 {

                if(i == 0){
                    prodImgDict = ["productImage": imageStr,"productDisplayImage":"","isLocalImg":"BillScan"]
                    prodImgArray.add(prodImgDict)

                }else{
                    prodImgDict = ["productImage": "","productDisplayImage":"","isLocalImg":"1"]
                    prodImgArray.add(prodImgDict)
                }
            }

            var accountID = String()
            let defaults = UserDefaults.standard
            accountID = (defaults.string(forKey: "accountId") ?? "")
            print(accountID)

            var userID = String()
            userID = (defaults.string(forKey: "userID") ?? "")
            print(userID)
            print(prodImgArray)

            let currentDate = Date()
            let eventDatePicker = UIDatePicker()

            eventDatePicker.datePickerMode = UIDatePicker.Mode.date
            eventDatePicker.minimumDate = currentDate

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"

            let selectedDate = dateFormatter.string(from: eventDatePicker.date)

//            myDict  = ["accountId": accountID, "productName": productName, "productUniqueNumber": productIdStr,"description": prodDesc,"stockQuantity": "","stockUnit": "","purchaseDate": selectedDate,"expiryDate": "","storageLocation": location,"borrowed": "","category": "","subCategory": "","categoryId": "","subCategoryId": "","orderId": "","vendorId": "","price": "","uploadType": "","userId": userID,"productImages": prodImgArray,"isActive":"1","priceUnit": "616fd4205041085a07d69b1a","productDetailsFound": false]
            
            myDict  = ["accountId": accountID, "productName": productName, "productUniqueNumber": productIdStr,"description": prodDesc,"stockQuantity": "1.000","stockUnit": "","purchaseDate": selectedDate,"expiryDate": "","storageLocation": "","borrowed": "","category": "","subCategory": "","orderId": "","vendorId": "","price": "","vendorName":"","uploadType": "","userId": userID,"productImages": prodImgArray,"isActive":"1","priceUnit": "616fd4205041085a07d69b1a","productDetailsFound": false, "unitPriceWarn":false,
                       "productNameWarn":false,"unitPrice":"0",
                       "stockQuantityWarn":false,]

            myProductArray.add(myDict)
//
        }
        }
    }

    
    @IBAction func useProfInfoBtnTapped(_ sender: Any) {
        loadAddProductView()
        
    }
    @IBAction func onClickVenderConnect(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Vendor", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "VendorConnectSearchViewController") as! VendorConnectSearchViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func loadAddProductView() {
        
        shoppingCurrentInvStatusStr = ""
        shoppingCartStatusStr = ""
        shoppingOpenOrdersStatusStr = ""
        shoppingOrdersHistoryStatusStr = ""
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("ShoppingUseProductInfoView", owner: self, options: nil)
        shoppingInfoAddProdView = allViewsInXibArray?.first as! ShoppingUseProductInfoView
        shoppingInfoAddProdView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
             self.view.addSubview(shoppingInfoAddProdView)
        
        shoppingInfoAddProdView.currentInvCheckBoxBtn.addTarget(self, action: #selector(currentInventoryCheckBoxBtnTap), for: .touchUpInside)
        shoppingInfoAddProdView.shoppingCartCheckBoxBtn.addTarget(self, action: #selector(shoppingCartCheckBoxBtnTap), for: .touchUpInside)
        shoppingInfoAddProdView.openOrdersCheckBoxBtn.addTarget(self, action: #selector(openOrdersCheckBoxBtnTap), for: .touchUpInside)
        shoppingInfoAddProdView.ordersHistoryCheckBoxBtn.addTarget(self, action: #selector(ordersHistoryCheckBoxBtnTap), for: .touchUpInside)
        
        shoppingInfoAddProdView.submitBtn.addTarget(self, action: #selector(shoppingProdSubmitBtnTap), for: .touchUpInside)
        shoppingInfoAddProdView.cancelBtn.addTarget(self, action: #selector(shoppingProdCancelBtnTapped), for: .touchUpInside)

    }
    
    @IBAction func shoppingProdSubmitBtnTap(_  sender: UIButton){
        
        shoppingInfoAddProdView.removeFromSuperview()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingUseProductInfoResultViewController") as! ShoppingUseProductInfoResultViewController
        VC.modalPresentationStyle = .fullScreen
        
        VC.currentInventoryStatusStr = shoppingCurrentInvStatusStr
        VC.shoppingCartttStatusStr = shoppingCartStatusStr
        VC.openOrdersStatusStr = shoppingOpenOrdersStatusStr
        VC.ordersHistoryStatusStr = shoppingOrdersHistoryStatusStr
        
        self.navigationController?.pushViewController(VC, animated: true)
//        self.present(VC, animated: true, completion: nil)

    }

    
    @IBAction func shoppingProdCancelBtnTapped(_  sender: UIButton){
        shoppingInfoAddProdView.removeFromSuperview()
    }
    
    @IBAction func currentInventoryCheckBoxBtnTap(_ sender: UIButton) {
        
        if shoppingCurrentInvStatusStr == ""{
            sender.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
            shoppingCurrentInvStatusStr = "CurrentInventory"

        }else{
            
            shoppingCurrentInvStatusStr = ""
            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)

        }
    }
    @IBAction func shoppingCartCheckBoxBtnTap(_ sender: UIButton) {
        
        if shoppingCartStatusStr == ""{
            sender.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
            shoppingCartStatusStr = "ShoppingCart"

        }else{
            
            shoppingCartStatusStr = ""
            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)

        }
    }
    @IBAction func openOrdersCheckBoxBtnTap(_ sender: UIButton) {

        if shoppingOpenOrdersStatusStr == ""{
            sender.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
            shoppingOpenOrdersStatusStr = "OpenOrders"

        }else{
            
            shoppingOpenOrdersStatusStr = ""
            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
        }
    }
    
    
    @IBAction func ordersHistoryCheckBoxBtnTap(_ sender: UIButton) {

        if shoppingOrdersHistoryStatusStr == ""{
            sender.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
            shoppingOrdersHistoryStatusStr = "OrdersHistory"

        }else{
            
            shoppingOrdersHistoryStatusStr = ""
            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
        }
    }

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
        dropDown.dataSource = priceUnitNamesArr //4
        
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.priceUnitDropDown.setTitle(item as String, for: UIControl.State.normal)
//                self?.priceUnitTF.text = item
                dict.setValue(item, forKey: "priceUnit")
                let priceUnitID = self?.priceUnitIdsArr[index]
                dict.setValue(priceUnitID, forKey: "priceUnitId")
                self?.loadAddProductUI()
            }
    }
    var vendorMastersIdsArr = [String]()
    var selectedVendorId = ""
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
        var dict = NSMutableDictionary()
        dict = myProductArray[productArrayPosition] as? NSMutableDictionary ?? NSMutableDictionary()
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
                self?.vendorNameDropDown.setTitle(item as String, for: UIControl.State.normal)
                dict.setValue(item, forKey: "vendorName")
                dict.setValue(self?.selectedVendorId, forKey: "vendorId")
                self?.loadAddProductUI()
            }
    }
    @objc func onClickWarnButton()
    {
        self.showAlertWith(title: "Alert", message: "Required")
    }
    func loadAddProductUI() {
        
        productScrollView.removeFromSuperview()
        
        productScrollView = UIScrollView()
        
        if(isEditShopping == "ShoppingEdit"){
            productScrollView.frame = CGRect(x: 0, y: 110, width: self.view.frame.size.width, height: self.view.frame.size.height + 130)

        }else if(isEditShopping == "SavingEdit"){
            productScrollView.frame = CGRect(x: 0, y: 110, width: self.view.frame.size.width, height: self.view.frame.size.height + 130)

        }
        else{
            productScrollView.frame = CGRect(x: 0, y: CGFloat(self.heightlength), width: self.view.frame.size.width, height: self.view.frame.size.height - (topHeaderBackView.frame.size.height)+90)

        }
        
        productScrollView.backgroundColor = hexStringToUIColor(hex: "e4ecf9")
        self.view.addSubview(productScrollView)
        
        productScrollView.delegate = self
        
        var yValue = CGFloat()
        yValue = 15
        
        if(myProductArray.count > 0){
            
            for i in 1...myProductArray.count {
                
                 productNameTF = UITextField()
                 productIDTF = UITextField()
                 descriptionTF = UITextView()
                 reqQunatityTF = UITextField()
//                 stockUnitTF = UITextField()
                 priceTF = UITextField()
                 pricePerStockUnitTF = UITextField()
                 totalPriceTF = UITextField()
                
                pricePerStockUnitTF.keyboardType = UIKeyboardType.decimalPad
                reqQunatityTF.keyboardType = UIKeyboardType.decimalPad

                let productView = UIView()
                productView.backgroundColor = UIColor.white
                productView.frame = CGRect(x: 15, y: yValue, width: productScrollView.frame.size.width - 30, height: 880)
                productScrollView.addSubview(productView)
                
                productView.layer.cornerRadius = 10
                productView.layer.masksToBounds = true
                
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
                
                if(isEditShopping == "ShoppingEdit"){

                }else if(isEditShopping == "SavingEdit"){
                }
                else
                {
                let deleteBtn = UIButton()
                deleteBtn.frame = CGRect(x: productView.frame.size.width - 50, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: 40, height: 40)
                deleteBtn.setImage(UIImage.init(named: "deleteBlue"), for: .normal)
                deleteBtn.addTarget(self, action: #selector(deleteProdBtnTap), for: .touchUpInside)
                deleteBtn.tag = i-1
                deleteBtn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                productView.addSubview(deleteBtn)
                }
                
                var addProdXValue = CGFloat()
                addProdXValue = 10
                
                var addBtnYValue = CGFloat()
                addBtnYValue = seperatorLine.frame.origin.y+seperatorLine.frame.size.height+75
                
                let productMainDict = myProductArray.object(at: i-1) as! NSMutableDictionary
                let prodArray = productMainDict.value(forKey: "productImages") as! NSMutableArray
                
                for j in 1...prodArray.count {
                    
                    let productDict = prodArray.object(at: j-1) as! NSMutableDictionary
                    let prodImgStr = productDict.value(forKey: "productImage") as? String ?? ""

                    //Add Btn

                    let addBtn = UIButton()
                    addBtn.frame = CGRect(x: addProdXValue, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: 60, height: 60)
                    addBtn.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
                    
                    addBtn.setImage(UIImage.init(named: "plus"), for: UIControl.State.normal)
                    addBtn.layer.cornerRadius = 10
                    addBtn.layer.masksToBounds = true
                    productView.addSubview(addBtn)
                    
                    addBtn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                    
                    if(isEditShopping == "ShoppingEdit" || isEditShopping == "OrderHistory" || isEditShopping  == "SavingEdit"){
                        
    //                    let prodArray = shoppingCartData[indexPos].productDict?.productImages
                               
    //                           if(prodArray?.count ?? 0  > 0){
                                   
                                         let dict = prodArray[j-1] as! NSDictionary
                                           
                                           let imageStr = dict.value(forKey: "productServerImage") as! String
                                
                                           if !imageStr.isEmpty {
                                               
                                               let imgUrl:String = imageStr
                                               
                                               let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                                                   
                                               let imggg = Constants.BaseImageUrl + trimStr
                                               
                                               let url = URL.init(string: imggg)
                                            
                                              addBtn.sd_setImage(with: url, for: .normal, completed: nil)
                                            
                                              addBtn.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

                                             }
                                           
                                           else {
                                            
                                            let prodImg = productDict.value(forKey: "productImage") as! String
                                            
                                            let prodDisplayImg = productDict.value(forKey: "productDisplayImage") as? UIImage
                                            
                                            if prodImg == ""{
                                               
                                            }else{
                                                
                                               addBtn.setImage(prodDisplayImg, for: .normal)
                                                    
                                              }
                                           }

                        
                    }else if(isEditShopping == "UseProductInfo"){
                        
                        let isLocalImage = productDict.value(forKey: "isLocalImg") as! String
                        
                        if(isLocalImage == "0"){ //Which we got from Scanner - QR Code / OCR
                            
                            if prodImgStr == "" {
                                addBtn.setImage(UIImage.init(named: "plus"), for: UIControl.State.normal)
                                addBtn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

                            }else{
                                
                                //                        let url = URL.init(string: prodImgStr as String)
                                                        let prodSerStr = productDict.value(forKey: "productDisplayImage") as? String ?? ""
                                                        
                                                        let imgUrl:String = prodSerStr
                                                        
                                                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                                                            
                                                        let imggg = Constants.BaseImageUrl + trimStr
                                                        
                                                        let fileUrl = URL(string: imggg)
                                                        addBtn.sd_setImage(with: fileUrl, for: .normal, completed: nil)

                                                    }
                            
                        }else{
                            
                            if prodImgStr == "" {
                                addBtn.setImage(UIImage.init(named: "plus"), for: UIControl.State.normal)
                                addBtn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

                            }else{
                                
                                let prodImg = productDict.value(forKey: "productDisplayImage") as? UIImage
                                addBtn.setImage(prodImg, for: UIControl.State.normal)
                            }
                        }
                        
                    }
                    else{
                        
                        let isLocalImage = productDict.value(forKey: "isLocalImg") as! String
                        
                        if(isLocalImage == "0"){ //Which we got from Scanner - QR Code / OCR
                            
                            if prodImgStr == "" {
                                addBtn.setImage(UIImage.init(named: "plus"), for: UIControl.State.normal)
                                addBtn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

                            }else if(isLocalImage == "BillScan"){
                                
                                let imgUrl:String = prodImgStr as String
                                
                                let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                let imggg = trimStr
                                
                                let fileUrl = URL(string: imggg)
                                addBtn.sd_setImage(with: fileUrl, for: .normal, completed: nil)
                                
                            }
                            else{
                                
                                let url = URL.init(string: prodImgStr as String)

        //                        cell.prodImgView?.sd_setImage(with: url , placeholderImage: UIImage(named: "add photo"))
                                
                                addBtn.sd_setImage(with: url, for: .normal, completed: nil)

                            }
                            
                        }else{
                            
                            if prodImgStr == "" {
                                addBtn.setImage(UIImage.init(named: "plus"), for: UIControl.State.normal)
                                addBtn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

                            } else if(isLocalImage == "BillScan"){
                                
                                let imgUrl:String = productDict.value(forKey: "productDisplayImage") as? String ?? ""
                                
                                let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                let imggg = trimStr
                                
                                let fileUrl = URL(string: imggg)
                                addBtn.sd_setImage(with: fileUrl, for: .normal, completed: nil)
                                
                            }
                            else{
                                
                                let prodImg = productDict.value(forKey: "productDisplayImage") as? UIImage
                                addBtn.setImage(prodImg, for: UIControl.State.normal)
                            }
                        }
                        
    //                    if prodImgStr == "" {
    //                        addBtn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    //
    //                    }else{
    //
    //                        let prodImg = productDict.value(forKey: "productDisplayImage") as? UIImage
    //                        addBtn.setImage(prodImg, for: UIControl.State.normal)
    //                    }
                        
                        
                        addBtn.layer.cornerRadius = 10
                        addBtn.layer.masksToBounds = true
                        productView.addSubview(addBtn)

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
                 productIDImage = UIButton()
                productIDImage.frame = CGRect(x: productView.frame.size.width - (40), y: productIDTF.frame.origin.y+6, width: 25, height: 25)
                productIDImage.setImage(UIImage.init(named: "search"), for: UIControl.State.normal)
                productIDImage.addTarget(self, action: #selector(productIdSearchBtnTap), for: .touchUpInside)
                productView.addSubview(productIDTF)
                productView.addSubview(productIDImage)
                
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
                if productMainDict.value(forKey: "productNameWarn") as? Bool==true
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
                
                let reqQuantityLbl = UILabel()
                reqQuantityLbl.frame = CGRect(x: 10, y: descriptionTF.frame.origin.y+descriptionTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
                reqQuantityLbl.text = "Required Quantity :"
                reqQuantityLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                reqQuantityLbl.textColor = hexStringToUIColor(hex: "232c51")
                productView.addSubview(reqQuantityLbl)
                
                //Req Quantity TF

                reqQunatityTF.frame = CGRect(x: 10, y: reqQuantityLbl.frame.origin.y+reqQuantityLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
    //            reqQunatityTF.text = "fdfdsfdsfd"
                reqQunatityTF.font = UIFont.init(name: kAppFontMedium, size: 13)
                reqQunatityTF.textColor = hexStringToUIColor(hex: "232c51")
                productView.addSubview(reqQunatityTF)
                
                if productMainDict.value(forKey: "stockQuantityWarn") as? Bool==true
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
                
          /*      let stockunitLbl = UILabel()
                stockunitLbl.frame = CGRect(x: productView.frame.size.width/2+10, y: descriptionTF.frame.origin.y+descriptionTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
                stockunitLbl.text = "Stock Unit :"
                stockunitLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                stockunitLbl.textColor = hexStringToUIColor(hex: "232c51")
                productView.addSubview(stockunitLbl)
                
                //Stock Unit TF

                stockUnitTF.frame = CGRect(x: productView.frame.size.width/2+10, y: stockunitLbl.frame.origin.y+stockunitLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
    //            stockUnitTF.text = "76"
                stockUnitTF.font = UIFont.init(name: kAppFontMedium, size: 13)
                stockUnitTF.textColor = hexStringToUIColor(hex: "232c51")
                productView.addSubview(stockUnitTF)
                
                stockUnitTF.layer.borderWidth = 1
                stockUnitTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                stockUnitTF.layer.cornerRadius = 3
                stockUnitTF.clipsToBounds = true

                let stockUnitPaddingView = UIView()
                stockUnitPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: stockUnitTF.frame.size.height)
                stockUnitTF.leftView = stockUnitPaddingView
                stockUnitTF.leftViewMode = UITextField.ViewMode.always
                */
                
                //Stock unit Lbl
                let stockUnitBtn = UIButton()
                stockUnitBtn.frame = CGRect(x:productView.frame.size.width / 2 + 10, y: descriptionTF.frame.origin.y+descriptionTF.frame.size.height+15, width: 70, height: 20)
                stockUnitBtn.setTitle("Stock Unit :", for: UIControl.State.normal)
                stockUnitBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
                stockUnitBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
                productView.addSubview(stockUnitBtn)
                
                
                stockUnitDropDown = UIButton()
                stockUnitDropDown.frame = CGRect(x: productView.frame.size.width/2+10, y: stockUnitBtn.frame.origin.y+stockUnitBtn.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
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
                stockUnitDropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                
                let stockUnitMasterListBtn = UIButton()
                stockUnitMasterListBtn.frame = CGRect(x: productView.frame.size.width/2+10, y: stockUnitDropDown.frame.origin.y+stockUnitDropDown.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 20)
                productView.addSubview(stockUnitMasterListBtn)
                
                stockUnitMasterListBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                
                stockUnitMasterListBtn.addTarget(self, action: #selector(stockUnitMastersBtnTap), for: .touchUpInside)
                
                let attrstock = [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                    NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
                    NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

                let attributedStockString = NSMutableAttributedString(string:"")
                
                let buttonTitleStockStr = NSMutableAttributedString(string:"Stock unit masterlist", attributes:attrstock)
                attributedStockString.append(buttonTitleStockStr)
                stockUnitMasterListBtn.setAttributedTitle(attributedStockString, for: .normal)
                
                
                //Purchase Date Lbl
                
                let purchaseDateLbl = UILabel()
                purchaseDateLbl.frame = CGRect(x: 10, y: stockUnitMasterListBtn.frame.origin.y+stockUnitMasterListBtn.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
                purchaseDateLbl.text = "Planned Purchase Date :"
                purchaseDateLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                purchaseDateLbl.textColor = hexStringToUIColor(hex: "232c51")
                productView.addSubview(purchaseDateLbl)
                
                //Purchase Date TF
                
                purchaseDateTF = UIButton()
                purchaseDateTF.frame = CGRect(x:10, y: purchaseDateLbl.frame.origin.y+purchaseDateLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
                purchaseDateTF.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
                purchaseDateTF.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
                let purchaseImage = UIButton()
                purchaseImage.frame = CGRect(x: purchaseDateTF.frame.size.width - (20), y: purchaseDateTF.frame.origin.y+6, width: 25, height: 25)
                purchaseImage.setImage(UIImage.init(named: "calenderlatest"), for: UIControl.State.normal)
                productView.addSubview(purchaseImage)
                productView.addSubview(purchaseDateTF)
                
                purchaseDateTF.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
                
                purchaseDateTF.layer.borderWidth = 1
                purchaseDateTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                purchaseDateTF.layer.cornerRadius = 3
                purchaseDateTF.clipsToBounds = true
                
                purchaseDateTF.addTarget(self, action: #selector(datePickerBtnTap), for: .touchUpInside)
                
                //priceUnit Lbl
                
                let priceUnitBtn = UIButton()
                priceUnitBtn.frame = CGRect(x: productView.frame.size.width / 2 + 10, y: stockUnitMasterListBtn.frame.origin.y+stockUnitMasterListBtn.frame.size.height+15, width: 70, height: 20)
                priceUnitBtn.setTitle("Price Unit:", for: UIControl.State.normal)
                priceUnitBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
                priceUnitBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
                productView.addSubview(priceUnitBtn)
                

                priceUnitDropDown = UIButton()
                priceUnitDropDown.frame = CGRect(x: productView.frame.size.width / 2 + 10, y: priceUnitBtn.frame.origin.y+priceUnitBtn.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
                priceUnitDropDown.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                priceUnitDropDown.layer.borderWidth = 1
                priceUnitDropDown.layer.cornerRadius = 3
                priceUnitDropDown.layer.masksToBounds = true
                let priceUnitImage = UIButton()
                priceUnitImage.frame = CGRect(x: productView.frame.size.width - (40), y: priceUnitDropDown.frame.origin.y+6, width: 25, height: 25)
                priceUnitImage.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
                productView.addSubview(priceUnitImage)
                productView.addSubview(priceUnitDropDown)
                
                priceUnitDropDown.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
                priceUnitDropDown.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
                
                priceUnitDropDown.addTarget(self, action: #selector(price_UnitBtnTap), for: .touchUpInside)
                priceUnitDropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                
                //Price Per Stock Unit Lbl
                
                let pricePerStockUnitLbl = UILabel()
                pricePerStockUnitLbl.frame = CGRect(x: 10, y: purchaseDateTF.frame.origin.y+purchaseDateTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
                pricePerStockUnitLbl.text = "Preffered Price per Unit :"
                pricePerStockUnitLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                pricePerStockUnitLbl.textColor = hexStringToUIColor(hex: "232c51")
                productView.addSubview(pricePerStockUnitLbl)
                
                //price Per Stock Unit TF

                pricePerStockUnitTF.frame = CGRect(x: 10, y: pricePerStockUnitLbl.frame.origin.y+pricePerStockUnitLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
    //            reqQunatityTF.text = "fdfdsfdsfd"
                pricePerStockUnitTF.font = UIFont.init(name: kAppFontMedium, size: 13)
                pricePerStockUnitTF.textColor = hexStringToUIColor(hex: "232c51")
                productView.addSubview(pricePerStockUnitTF)
                if productMainDict.value(forKey: "unitPriceWarn") as? Bool==true
                {
                let pricePerStockAlertButton = UIButton()
                pricePerStockAlertButton.frame = CGRect(x: pricePerStockUnitTF.frame.size.width - 30, y: pricePerStockUnitTF.frame.origin.y+5, width: 30, height: 30)
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
                
                //Category Check box
                
                let categoryCheckBtn = UIButton()
                categoryCheckBtn.frame = CGRect(x: 10, y: pricePerStockUnitTF.frame.origin.y+pricePerStockUnitTF.frame.size.height+12, width: 25, height: 25)
                categoryCheckBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
    //            productView.addSubview(categoryCheckBtn)
                
                categoryCheckBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                
                //Category Lbl

                let categoryBtn = UIButton()
                categoryBtn.frame = CGRect(x:10, y: pricePerStockUnitTF.frame.origin.y+pricePerStockUnitTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
                categoryBtn.setTitle("Category", for: UIControl.State.normal)
//                categoryBtn.backgroundColor = .yellow
                categoryBtn.contentHorizontalAlignment = .left
                categoryBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
                categoryBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
                productView.addSubview(categoryBtn)
                
                //Sub Category Check box
                
                let subCategoryCheckBtn = UIButton()
                subCategoryCheckBtn.frame = CGRect(x: productView.frame.size.width / 2 + 10, y: pricePerStockUnitTF.frame.origin.y+pricePerStockUnitTF.frame.size.height+12, width: 25, height: 25)
                subCategoryCheckBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
    //            productView.addSubview(subCategoryCheckBtn)
                
                subCategoryCheckBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                
                //sub Category Lbl

                let subCategoryBtn = UIButton()
                subCategoryBtn.frame = CGRect(x:productView.frame.size.width / 2 + 10, y: pricePerStockUnitTF.frame.origin.y+pricePerStockUnitTF.frame.size.height+15, width: 90, height: 20)
                subCategoryBtn.setTitle("Sub Category", for: UIControl.State.normal)
                subCategoryBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
                subCategoryBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
                productView.addSubview(subCategoryBtn)


                //Category Drop Down
                
                categoryDropDown = UIButton()
                categoryDropDown.frame = CGRect(x: 10, y: subCategoryBtn.frame.origin.y+subCategoryBtn.frame.size.height+5, width: productView.frame.size.width/2 - 20 , height: 40)
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


                //Preferred Vendor Lbl
                
                let preferredVendorLbl = UILabel()
                preferredVendorLbl.frame = CGRect(x: 10, y: categoryDropDown.frame.origin.y+categoryDropDown.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
                preferredVendorLbl.text = "Preffered Vendor :"
                preferredVendorLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                preferredVendorLbl.textColor = hexStringToUIColor(hex: "232c51")
                productView.addSubview(preferredVendorLbl)
                
                //Preferred Vendor
                
                vendorNameDropDown = UIButton()

                vendorNameDropDown.frame = CGRect(x:10, y: preferredVendorLbl.frame.origin.y+preferredVendorLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
                vendorNameDropDown.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
                vendorNameDropDown.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
                let vendorNameImage = UIButton()
                vendorNameImage.frame = CGRect(x: vendorNameDropDown.frame.size.width - (20), y: vendorNameDropDown.frame.origin.y+6, width: 25, height: 25)
                vendorNameImage.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
                productView.addSubview(vendorNameImage)
                productView.addSubview(vendorNameDropDown)
                
                vendorNameDropDown.layer.borderWidth = 1
                vendorNameDropDown.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                vendorNameDropDown.layer.cornerRadius = 3
                vendorNameDropDown.clipsToBounds = true
                vendorNameDropDown.addTarget(self, action: #selector(vendor_NameBtnTap), for: .touchUpInside)
                vendorNameDropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                
                let addVendorMastersBtn = UIButton()
                addVendorMastersBtn.frame = CGRect(x: 10, y: vendorNameDropDown.frame.origin.y+vendorNameDropDown.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 20)
                productView.addSubview(addVendorMastersBtn)
                
                addVendorMastersBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                
                addVendorMastersBtn.addTarget(self, action: #selector(onVendorMastersBtnTap), for: .touchUpInside)
                
                let attrs = [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                    NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
                    NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

                let attributedString = NSMutableAttributedString(string:"")

                let buttonTitleStr = NSMutableAttributedString(string:"Vendor Masters", attributes:attrs)
                attributedString.append(buttonTitleStr)
                addVendorMastersBtn.setAttributedTitle(attributedString, for: .normal)

                //Price Lbl
                
                let priceLbl = UILabel()
                priceLbl.frame = CGRect(x: productView.frame.size.width/2+10, y: priceUnitDropDown.frame.origin.y+priceUnitDropDown.frame.size.height+15, width: 80, height: 20)
                priceLbl.text = "Total Price :"
                priceLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                priceLbl.textColor = hexStringToUIColor(hex: "232c51")
                productView.addSubview(priceLbl)
                
                //Price TF

                priceTF.frame = CGRect(x: productView.frame.size.width/2+10, y: priceLbl.frame.origin.y+priceLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
    //            priceTF.text = "87797"
                priceTF.font = UIFont.init(name: kAppFontMedium, size: 13)
                priceTF.textColor = hexStringToUIColor(hex: "232c51")
                priceTF.backgroundColor = .lightGray
                priceTF.isUserInteractionEnabled = false
                productView.addSubview(priceTF)
                
                priceTF.layer.borderWidth = 1
                priceTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                priceTF.layer.cornerRadius = 3
                priceTF.clipsToBounds = true

                let pricePaddingView = UIView()
                pricePaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: priceTF.frame.size.height)
                priceTF.leftView = pricePaddingView
                priceTF.leftViewMode = UITextField.ViewMode.always

               
                
                //Save For Later
                
                let saveForLater = UIButton()

                saveForLater.frame = CGRect(x:productView.frame.size.width/2+10, y: subCategoryDropDown.frame.origin.y+subCategoryDropDown.frame.size.height+35, width: productView.frame.size.width/2 - (20), height: 40)
                saveForLater.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
                saveForLater .setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
                saveForLater.setTitleColor(hexStringToUIColor(hex:"ffffff"), for: .normal)
                productView.addSubview(saveForLater)
                
                saveForLater.titleLabel?.text = "SAVE FOR LATER"
                
                if(isEditShopping == "ShoppingEdit" || isEditShopping == "SavingEdit"){
//                    stockunitLbl.text = "Stock Unit :"
                    priceLbl.text = "Preferred Price :"
                }

                
                saveForLater.setTitle("SAVE FOR LATER", for: UIControl.State.normal)
                saveForLater.addTarget(self, action: #selector(saveForLaterBtnTapped), for: .touchUpInside)
                
                vendorNameDropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)

                saveForLater.backgroundColor = hexStringToUIColor(hex: "0d60ee")
                saveForLater.layer.cornerRadius = 5

                yValue = productView.frame.size.height + yValue + 10
                
                productIDTF.delegate = self
                productNameTF.delegate = self
                descriptionTF.delegate = self
                reqQunatityTF.delegate = self
                pricePerStockUnitTF.delegate = self
//                stockUnitTF.delegate = self
                priceTF.delegate = self

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
                
                let pricePerUnitTag : String = "2001" + StringTagValue
                let pricePerUnitValue: Int? = Int(pricePerUnitTag)
                let totalPriceTag : String = "2002" + StringTagValue
                let totalPriceTagValue: Int? = Int(totalPriceTag)
                let stockUnitTag : String = "1004" + StringTagValue
                let stockUnitTagValue: Int? = Int(stockUnitTag)

                let prefVendorTag : String = "1005" + StringTagValue
                let prefVendorTagValue: Int? = Int(prefVendorTag)
                
                let priceTag : String = "1006" + StringTagValue
                let priceTagValue: Int? = Int(priceTag)
                
                let plannedPurchaseTag : String = "1007" + StringTagValue
                let plannedPurchaseTagValue: Int? = Int(plannedPurchaseTag)
                
                let catTag : String = "3000" + StringTagValue
                let catTagValue : Int? = Int(catTag)

                let subCatTag : String = "3001" + StringTagValue
                let subCatTagValue : Int? = Int(subCatTag)
                let priceUnitTag : String = "3005" + StringTagValue
                let priceUnitTagValue : Int? = Int(priceUnitTag)
                
                let productSearchTag : String = "3006" + StringTagValue
                let productSearchTagValue : Int? = Int(productSearchTag)
                
               
    //          let saveForLaterTag : String = "1008" + StringTagValue
    //          let saveForLaterTagValue: Int? = Int(saveForLaterTag)

                productIDTF.tag   = idTagValue!
                productNameTF.tag = prodNameTagValue!
                descriptionTF.tag = descriptionTagValue!
                reqQunatityTF.tag = reqQuanTagValue!
                pricePerStockUnitTF.tag = pricePerUnitValue!
                stockUnitDropDown.tag=stockUnitTagValue!
                vendorNameDropDown.tag = prefVendorTagValue!
                priceTF.tag = priceTagValue!
                purchaseDateTF.tag = plannedPurchaseTagValue!
                saveForLater.tag = i-1
                
                priceUnitDropDown.tag = priceUnitTagValue!
                totalPriceTF.tag = totalPriceTagValue!
                categoryDropDown.tag = catTagValue!
                subCategoryDropDown.tag = subCatTagValue!
                productIDImage.tag=productSearchTagValue!
                
                let productID = productMainDict.value(forKey: "productUniqueNumber") as? NSString ?? ""
                let productName = productMainDict.value(forKey: "productName") as? NSString ?? ""
                let prodDesc = productMainDict.value(forKey: "description") as? NSString ?? ""
                var stockQunatity = String()
                if productMainDict.value(forKey: "stockQuantity") as? String=="" || productMainDict.value(forKey: "stockQuantity") as? String=="0"
                {
                    stockQunatity="1.000"
                }
                else
                {
                    stockQunatity=productMainDict.value(forKey: "stockQuantity") as? String ?? "1.000"
                }
//                let stockUnit = productMainDict.value(forKey: "stockUnit") as? NSString ?? ""
                let price =  productMainDict.value(forKey: "price") as? NSString ?? ""
                //let preferredVendorStr =  productMainDict.value(forKey: "vendorName") as? NSString ?? ""
               // let purchaseDate =  productMainDict.value(forKey: "purchaseDate") as? NSString ?? ""
//                let category = productMainDict.value(forKey: "category") as? NSString ?? ""
//                let subCategory = productMainDict.value(forKey: "subCategory") as? NSString ?? ""
                var stockUnit=String()
                var stockUnitId=String()
               
                if productMainDict.value(forKey: "stockUnit") as? String==""
                {
                    if stockUnitsArr.count>0
                    {
                        stockUnit = stockUnitsArr[0].stockUnitName ?? ""
                        stockUnitId=stockUnitsArr[0]._id ?? ""
                    }
                    productMainDict.setValue(stockUnit, forKey: "stockUnit")
                    productMainDict.setValue(stockUnitId, forKey: "stockUnitId")
                    productMainDict.setValue(0, forKey: "stockUnitIndex")
                }
                else
                {
                    if stockUnitsArr.count>0
                    {
                        if productMainDict.value(forKey: "stockUnitIndex")as? Int==0
                        {
                         stockUnit = stockUnitsArr[0].stockUnitName ?? ""
                         stockUnitId = stockUnitsArr[0]._id ?? ""
                            productMainDict.setValue(stockUnit, forKey: "stockUnit")
                            productMainDict.setValue(stockUnitId, forKey: "stockUnitId")
                            productMainDict.setValue(0, forKey: "stockUnitIndex")
                        }
                        else
                        {
                            stockUnit = (productMainDict.value(forKey: "stockUnit") as? NSString ?? "") as String
                        }
                    
                    }
                    else
                    {
                    stockUnit = (productMainDict.value(forKey: "stockUnit") as? NSString ?? "") as String
                    }
                }
                
                var purchaseDate=String()
                if productMainDict.value(forKey: "purchaseDate") as? String==""
                {
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let selectedDate = dateFormatter.string(from: Date.init())
                   
                    purchaseDate=selectedDate
                }
                else
                {
                    purchaseDate = (productMainDict.value(forKey: "purchaseDate") as? NSString ?? "") as String
                }
                productMainDict.setValue(purchaseDate, forKey: "purchaseDate")
               
                var category=String()
                var categoryId=String()
                if productMainDict.value(forKey: "category") as! String==""
                {
                    if categoryResult.count>0
                    {
                        category=categoryResult[0].name ?? ""
                        categoryId=categoryResult[0]._id ?? ""
                    }
                    productMainDict.setValue(category, forKey: "category")
                    productMainDict.setValue(categoryId, forKey: "categoryId")
                }
                else
                {
                    category = (productMainDict.value(forKey: "category") as? NSString ?? "") as String
                }
                
                var priceperUnit=NSString()
                if productMainDict.value(forKey: "unitPrice") as? String==""
                {
                    priceperUnit="0"
                }
                else
                {
                priceperUnit=productMainDict.value(forKey: "unitPrice") as? NSString ?? "0"
                }
                var subCategory=String()
                var subCategoryId=String()
                if productMainDict.value(forKey: "subCategory") as! String==""
                {
                    if subCategoryResult.count>0
                    {
                        subCategory=subCategoryResult[0].name ?? ""
                        subCategoryId=subCategoryResult[0]._id ?? ""
                    }
                    productMainDict.setValue(subCategory, forKey: "subCategory")
                    productMainDict.setValue(subCategoryId, forKey: "subCategoryId")
                }
                else
                {
                    subCategory = (productMainDict.value(forKey: "subCategory") as? NSString ?? "") as String
                }
                
                var vendorStr=String()
                var vendorStrID=String()
                
                if productMainDict.value(forKey: "vendorName") as? String==""
                {
                    if vendorListResult.count>0
                    {
                        vendorStr=vendorListResult[0].vendorName ?? ""
                        vendorStrID=vendorListResult[0]._id ?? ""
                    }
                    productMainDict.setValue(vendorStr, forKey: "vendorName")
                    productMainDict.setValue(vendorStrID, forKey: "vendorId")
                }
                else
                {
                    vendorStr = (productMainDict.value(forKey: "vendorName") as? NSString ?? "") as String
                }
                
                var priceUnit = String()
                var priceUnitId = String()
                if productMainDict.value(forKey: "priceUnit") as? String=="" || productMainDict.value(forKey: "priceUnit") as? String=="616fd4205041085a07d69b1a"
                {
                    
                    if priceUnitsArr.count>0
                    {
                        priceUnit = priceUnitsArr[0].priceUnit ?? ""
                        priceUnitId = priceUnitsArr[0]._id ?? ""
                    }
                    productMainDict.setValue(priceUnit, forKey: "priceUnit")
                    productMainDict.setValue(priceUnitId, forKey: "priceUnitId")
                    
                }
                else
                {
                    priceUnit = (productMainDict.value(forKey: "priceUnit") as? NSString ?? "") as String
                }
                

                productIDTF.text = productID as String
                productNameTF.text = productName as String
                descriptionTF.text = prodDesc as String
                reqQunatityTF.text = stockQunatity as String
                pricePerStockUnitTF.text=priceperUnit as String
                stockUnitDropDown.setTitle(stockUnit as String, for: .normal)
                priceTF.text = price as String
                
                purchaseDateTF.setTitle(purchaseDate as String, for: UIControl.State.normal)
                categoryDropDown.setTitle(category as String, for: UIControl.State.normal)
                subCategoryDropDown.setTitle(subCategory as String, for: UIControl.State.normal)
                
                stockUnitDropDown.setTitle(stockUnit as String, for: UIControl.State.normal)
             priceUnitDropDown.setTitle(priceUnit as String, for: UIControl.State.normal)
               
                vendorNameDropDown.setTitle(vendorStr as String, for: UIControl.State.normal)


                vendorNameDropDown.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.left

                purchaseDateTF.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.left
                
                categoryDropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                
                subCategoryDropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                stockUnitDropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                priceUnitDropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left

                if(isEditShopping == "ShoppingEdit" ){
                    
                    let vendorDict = shoppingCartData[indexPos].vendordetails
                    let vendorNameStr = vendorDict?.value(forKey: "vendorName") as? String
                    
                    saveForLater.isHidden = true
                   // let stockunitdetails=shoppingCartData[indexPos].stockUnitDetails?.first?.stockUnitName
//                    productIDTF.text = shoppingCartData[indexPos].productDict?.productUniqueNumber!
//                    productNameTF.text = shoppingCartData[indexPos].productDict?.productName!
//                    descriptionTF.text =       shoppingCartData[indexPos].productDict?.description!
//                    reqQunatityTF.text = String(shoppingCartData[indexPos].requiredQuantity!)
//                    stockUnitDropDown.setTitle(stockunitdetails as? String, for: .normal)
                    
//                    if shoppingCartData[indexPos].productDict?.unitPrice != nil {
//                        pricePerStockUnitTF.text = String((shoppingCartData[indexPos].productDict?.unitPrice!)!)
//                    }
                    
                    
                    
    //                vendorNameDropDown.setTitle(vendorNameStr, for: .normal)
//                    priceUnitDropDown.setTitle(shoppingCartData[indexPos].priceUnitDetails?.first?.priceUnit, for: .normal)
//                    let priceStr = String(shoppingCartData[indexPos].productDict?.price ?? 0)
//                    priceTF.text = priceStr
                    
    //                let purcDate = (shoppingCartData[indexPos].plannedPurchasedate)!
    //                let convertedPurchaseDate = convertDateFormatter(date: purcDate)
    //
    //                purchaseDateTF.setTitle(convertedPurchaseDate, for: .normal)
                    
                    let purcDate = productMainDict.value(forKey: "purchaseDate")!
                    let convertedPurchaseDate = convertDateFormatter(date: purcDate as? String ?? "")
                    
                    if(convertedPurchaseDate == "" || convertedPurchaseDate == nil){
                        let vall=productMainDict.value(forKey: "purchaseDate") as? String
                        let valArr=vall?.components(separatedBy: "-")
                        var valString=String()
                        if valArr?.count==3
                        {
                            let aa:String=valArr![2] + "/"
                            valString = aa + valArr![1] + "/" + valArr![0]
                        }
                        else
                        {
                            valString = productMainDict.value(forKey: "purchaseDate") as? String ?? ""
                        }
                        purchaseDateTF.setTitle(valString, for: .normal)

                    }else{
                        purchaseDateTF.setTitle(convertedPurchaseDate, for: .normal)

                    }
                    


                }else if(isEditShopping == "SavingEdit"){
                    
                    let vendorDict = savedCartData[indexPos].vendordetails
                    let vendorNameStr = vendorDict?.value(forKey: "vendorName") as? String
                    
                    saveForLater.isHidden = true
                  //  let stockunitdetails=savedCartData[indexPos].stockUnitDetails?.first?.stockUnitName
//                    productIDTF.text = savedCartData[indexPos].productDict?.productUniqueNumber!
//                    productNameTF.text = savedCartData[indexPos].productDict?.productName!
//                    descriptionTF.text =       savedCartData[indexPos].productDict?.description!
//                    reqQunatityTF.text = String(savedCartData[indexPos].requiredQuantity!)
//                    //stockUnitDropDown.setTitle(stockunitdetails as? String, for: .normal)
//
//    //                vendorNameDropDown.setTitle(vendorNameStr, for: .normal)
//                    if savedCartData[indexPos].productDict?.unitPrice != nil {
//                        pricePerStockUnitTF.text = String((savedCartData[indexPos].productDict?.unitPrice!)!)
//                    }
                   // let priceStr = String(savedCartData[indexPos].productDict?.price ?? 0)
                   // priceTF.text = priceStr
                   
                    let purcDate = productMainDict.value(forKey: "purchaseDate")!
                    let convertedPurchaseDate = convertDateFormatter(date: purcDate as? String ?? "")
                    
                    if(convertedPurchaseDate == "" || convertedPurchaseDate == nil){
                        purchaseDateTF.setTitle(purcDate as! String, for: .normal)

                    }else{
                        purchaseDateTF.setTitle(convertedPurchaseDate, for: .normal)

                    }
                }
                
                if(isEditShopping == "UseProductInfo"){
                    
                    let purcDate = productMainDict.value(forKey: "purchaseDate")!
                    let convertedPurchaseDate = convertDateFormatter(date: purcDate as? String ?? "")
                    
                    if(convertedPurchaseDate == "" || convertedPurchaseDate == nil){
                        purchaseDateTF.setTitle(purcDate as! String, for: .normal)

                    }else{
                        purchaseDateTF.setTitle(convertedPurchaseDate, for: .normal)

                    }
                }
            }
        }
        
        if isEditShopping == "ShoppingEdit" || isEditShopping == "SavingEdit"
        {
        
        }
        else
        {
        //Add Product

        let addProductBtn = UIButton()
        addProductBtn.frame = CGRect(x:15, y: yValue, width: 120, height: 40)
        addProductBtn.setTitle("Add Product", for: UIControl.State.normal)
        addProductBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        addProductBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        addProductBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
        addProductBtn.layer.cornerRadius = 5
        addProductBtn.layer.masksToBounds = true
        productScrollView.addSubview(addProductBtn)
        
        addProductBtn.addTarget(self, action: #selector(addProdBtnTapped), for: .touchUpInside)
        addProductBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        }
        productScrollView.contentSize = CGSize(width: productScrollView.frame.size.width, height: yValue+300)
        productScrollView.contentOffset = CGPoint(x: 0, y: scrollViewYPos)
        
        animatingView()

    }
    var fromButton=String()
    @IBAction func productIdSearchBtnTap(_ sender: UIButton) {
        self.productIDTF.resignFirstResponder()
        fromButton="search"
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
            let tagg="1000"+String(productArrayPosition)
            let tagInt=Int(tagg)
            var productID=String()
            if let txtField = self.view.viewWithTag(tagInt!) as? UITextField, let txt = txtField.text {
                        print(txt)
                productID=txt
                    }
        //let productArrayPosition : Int = sender.tag%10
        
        print(sender.tag,productArrayPosition)
            
        if productID == "" {
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.view.makeToast("Please enter Product Id")
        }
        else {
            self.get_barCodeDetails_API_Call(index: productArrayPosition, productId: productID ?? "")
            
        }
        
        }
//        barCodeThirdPartyAPI()
    }
    
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
                dict.setValue(item, forKey: "stockUnit")
               dict.setValue(self?.selectedStockId, forKey: "stockUnitId")
                dict.setValue(index, forKey: "stockUnitIndex")
                self?.loadAddProductUI()
            }
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
    
    @IBAction func deleteProdBtnTap(_ sender: UIButton){
        
//        if(myProductArray.count <= 1){
//            self.showAlertWith(title: "Alert..!!", message: "Minimum one product required")
//
//        }else{
            
            myProductArray.removeObject(at: sender.tag)
            loadAddProductUI()
//        }
    }
    typealias FinishedDownload = () -> ()
    func removeEmptyObjects(completed: FinishedDownload)
    {
        var mainArray=myProductArray
                let finalArrayObject=NSMutableArray()
                var mainArrayIndex=[Int]()
                for i in 0..<mainArray.count
                {
                    
                    let dataDict = mainArray.object(at: i) as? NSDictionary


                    let prodId = dataDict?.value(forKey: "productUniqueNumber") as? String ?? ""
                                    let prodName = dataDict?.value(forKey: "productName") as? String ?? ""
                                    let desc = dataDict?.value(forKey: "description") as? String ?? ""
                                    let stockQuantity = dataDict?.value(forKey: "stockQuantity") as? String ?? ""
                                    let expiryDate = dataDict?.value(forKey: "expiryDate") as? String ?? ""
                                    let orderId = dataDict?.value(forKey: "orderId") as? String ?? ""
                                    let price = dataDict?.value(forKey: "price") as? String ?? ""
                                   
                        if(prodId == "" && prodName == "" && desc == "" && stockQuantity == "" && expiryDate == "" && orderId == "" && price == "" ){
                            
                            mainArrayIndex.append(i)
                        }
                    else
                        {
                            finalArrayObject.add(dataDict)
                        }
                    
                }
               myProductArray=finalArrayObject
                self.loadAddProductUI()
                completed()
    }
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
        let selectedCatStr = dict.value(forKey: "category") as! String
        
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
                    dict.setValue(item, forKey: "category")
                    dict.setValue(selectedId, forKey: "categoryId")
                    self?.selectedCategoryStr = item
                    self?.selectedCategoryID = selectedId as? String
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
                        dict.setValue(item, forKey: "subCategory")
                        let selecteSubId = self?.categoryIDArray[index]
                        dict.setValue(selecteSubId, forKey: "subCategoryId")
                        self?.loadAddProductUI()
                    }
            }
        }
    }
    
    @IBAction func onvendorNameDropDownTapped(_ sender: UIButton) {
        
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

        catSubCatTagValue = sender.tag as Int
        catSubCatArrPosition = productArrayPosition as Int
        catSubCatIndexPosition = productTagValue as Int
        
        let dict = myProductArray[catSubCatArrPosition] as! NSDictionary
        _ = dict.value(forKey: "vendorId") as! String
        
//        print(catSubCatIndexPosition as Any,catSubCatTagValue,catSubCatArrPosition)

        if(catSubCatIndexPosition == 1005){
            
            categoryDataArray = NSMutableArray()
            categoryIDArray = NSMutableArray()
            vendorListResult = [VendorListResult]()
            
            self.getVendorListDataFromServer()
            
        }
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
        
        var dict = NSMutableDictionary()
        dict = myProductArray[purchase_expiryProductPosLev] as! NSMutableDictionary

        if(purchase_expiryTagValue == 1007){ //Purchase Btn
            dict.setValue(dateFormatter.string(from: eventDatePicker.date), forKey: "purchaseDate")

        }
//        else if(purchase_expiryTagValue == 1008){
//            dict.setValue(dateFormatter.string(from: eventDatePicker.date), forKey: "expiryDate")
//
//        }
        
        myProductArray.replaceObject(at:purchase_expiryProductPosLev, with: dict)


   }
   
   @objc func dueDateChanged(sender:UIDatePicker){
       
       print(purchase_ExpiryTagVal)
       
       let dateFormatter = DateFormatter()
       
       dateFormatter.dateFormat = "dd/MM/yyyy"
       let selectedDate = dateFormatter.string(from: picker.date)

       let tmpButton = self.view.viewWithTag(purchase_ExpiryTagVal as! Int ) as? UIButton
       tmpButton?.setTitleColor(hexStringToUIColor(hex: "232c51"), for: .normal)
       tmpButton?.setTitle(selectedDate, for: .normal)
       
       var dict = NSMutableDictionary()
       dict = myProductArray[purchase_expiryProductPosLev] as! NSMutableDictionary

       if(purchase_expiryTagValue == 1007){ //Purchase Btn
           dict.setValue(selectedDate, forKey: "purchaseDate")

       }
       
       myProductArray.replaceObject(at:purchase_expiryProductPosLev, with: dict)

   }
   
   @objc func doneBtnTap(_ sender: UIButton) {

       hiddenBtn.removeFromSuperview()
       pickerDateView.removeFromSuperview()
       
       self.loadAddProductUI()
       
   }
    var heightlength:Int=250
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollViewYPos = scrollView.contentOffset.y
    if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0)
            {
                print("scrolled up")
                //show the collection view here
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn],
                              animations: {
                                if(self.isEditShopping == "ShoppingEdit"){
                                    self.productScrollView.frame = CGRect(x: 0, y: 110, width: self.view.frame.size.width, height: self.view.frame.size.height + 130)

                                }else if(self.isEditShopping == "SavingEdit"){
                                    self.productScrollView.frame = CGRect(x: 0, y: 110, width: self.view.frame.size.width, height: self.view.frame.size.height + 130)
                                }
                                else{
                                   
                                self.heightlength=250
                                self.productScrollView.frame = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height - (self.topHeaderBackView.frame.size.height)+90)
                                self.topViewHeight.constant = 140
                                }
               }, completion: nil)
        if(self.isEditShopping == "ShoppingEdit"){
            self.topHeaderBackView.isHidden = true
        }else if(self.isEditShopping == "SavingEdit"){
            self.topHeaderBackView.isHidden = true
        }
        else
        {
        self.topHeaderBackView.isHidden = false
        }
            }
            else
            {
                print("scrolled down")
                //hide the collection view here
                UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut],
                                       animations: {
                                        if(self.isEditShopping == "ShoppingEdit"){
                                            self.productScrollView.frame = CGRect(x: 0, y: 110, width: self.view.frame.size.width, height: self.view.frame.size.height + 130)

                                        }else if(self.isEditShopping == "SavingEdit"){
                                            self.productScrollView.frame = CGRect(x: 0, y: 110, width: self.view.frame.size.width, height: self.view.frame.size.height + 130)
                                        }
                                        else{
                                        self.heightlength=104
                                        self.productScrollView.frame = CGRect(x: 0, y: 104, width: self.view.frame.size.width, height: self.view.frame.size.height - (self.topHeaderBackView.frame.size.height)+90)
                                        self.topViewHeight.constant = 0
                                        }
                        },  completion: {(_ completed: Bool) -> Void in
                            if(self.isEditShopping == "ShoppingEdit"){
                                self.topHeaderBackView.isHidden = true
                            }else if(self.isEditShopping == "SavingEdit"){
                                self.topHeaderBackView.isHidden = true
                            }
                            else
                            {
                            self.topHeaderBackView.isHidden = true
                            }
            })
            }
}
    @IBOutlet var topViewHeight: NSLayoutConstraint!
    

    
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
                                        
                                        
                                        
                                        if(self.categoryDataArray.count == 0){
                                            
//                                            self.showAlertWith(title: "Alert !!", message: "No Vendor available. Please add a vendor before adding a product")
                                            
                                        }else if(self.categoryDataArray.count > 0){
                                            
                                            self.vendorListResult = respVo.result!

                                        }
                                        
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
        
        self.loadActionSheet()
        
//        let image=UIImagePickerController()
//                image.delegate=self
//                image.sourceType = .photoLibrary
//                image.allowsEditing=false
//                self.present(image, animated: true){
//
//                }
        
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

    
    //Delegate Method in UIImage Picker Controller :

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let imagePick = info[UIImagePickerController.InfoKey.originalImage] {
//  profileImgView.image = imagePick as? UIImage
       
       print(prodImgTagValue)
       
       let tmpButton = self.view.viewWithTag(prodImgTagValue) as? UIButton
       tmpButton?.setImage(imagePick as! UIImage, for:UIControl.State.normal)
       
       tmpButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

       let imageData: Data? = (imagePick as! UIImage).jpegData(compressionQuality: 0.4)
       let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
       
       var dict = NSMutableDictionary()
       dict = myProductArray[prodImgIArrayPos] as! NSMutableDictionary
       
       var productImgArray = NSMutableArray()
       var productImgict = NSMutableDictionary()
       
       productImgArray = dict.value(forKey: "productImages") as! NSMutableArray
       
       productImgict = productImgArray[prodImgJPos] as! NSMutableDictionary
       productImgict.setValue(imageStr, forKey: "productImage")
       productImgict.setValue(imagePick as! UIImage, forKey: "productDisplayImage")
        productImgict.setValue("1", forKey: "isLocalImg")

        if(isEditShopping == "ShoppingEdit" || isEditShopping == "SavingEdit"){
            productImgict.setValue("", forKey: "productServerImage")

        }
       
       productImgArray.replaceObject(at:prodImgJPos , with: productImgict)
       dict.setValue(productImgArray, forKey: "productImages")
        
       
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
           
           if(productTagValue == 1003){
               
               if newString != "" {
                let aa=decimalPlaces(stt: newString)
                if aa>3 {
                    
                }
                else
                {
                   let stockVal = newString
                   dict.setValue(false, forKey: "stockQuantityWarn")
                   let pricePerStockVal = dict.value(forKey: "unitPrice") as? String
                   let obj1 = Float(stockVal)
                   if pricePerStockVal != "" {
                       let obj2 = Float(pricePerStockVal ?? "0")
                       let obj3 = obj1! * obj2!
                       let obj4 = String(format: "%.2f", obj3)
                       dict.setValue(newString, forKey: "stockQuantity")
                       dict.setValue("\(obj4)", forKey: "price")
                       let tagg="1006"+String(productArrayPosition)
                       let tagInt=Int(tagg)
                       if let txtField = self.view.viewWithTag(tagInt!) as? UITextField, let txt = txtField.text {
                                  
                           txtField.text = "\(obj4)"
                           print(txt)
                               }
                   }
                   else {
                       let obj3 = obj1! * 0.0
                       let tagg="1006"+String(productArrayPosition)
                       let tagInt=Int(tagg)
                       if let txtField = self.view.viewWithTag(tagInt!) as? UITextField, let txt = txtField.text {
                                  
                           txtField.text = "\(obj3)"
                           print(txt)
                               }
                    dict.setValue(newString, forKey: "stockQuantity")
                       dict.setValue("\(obj3)", forKey: "price")
                   }
                }
               }
               else {
                   let tagg="1006"+String(productArrayPosition)
                   let tagInt=Int(tagg)
                   if let txtField = self.view.viewWithTag(tagInt!) as? UITextField, let txt = txtField.text {
                              
                       txtField.text = "0.0"
                       print(txt)
                           }
                dict.setValue(newString, forKey: "stockQuantity")
                   dict.setValue("0.0", forKey: "price")
               }
               
           }
           if(productTagValue == 2001){ // Price Per Stock Unit
               
               if newString != "" {
                let aa=decimalPlaces(stt: newString)
                if aa>2 {
                    
                }
                else
                {
                   dict.setValue(false, forKey: "unitPriceyWarn")
                   let stockVal = dict.value(forKey: "stockQuantity") as? String
                   let pricePerStockVal = newString
                   let obj2 = Float(pricePerStockVal)
                   if stockVal != ""{
                       let obj1 = Float(stockVal ?? "0")
                       let obj3 = obj1! * obj2!
                       let obj4 = String(format: "%.2f", obj3)
   //                    print(String(format: "%.2f", obj3))
                      
                       dict.setValue(newString, forKey: "unitPrice")
                       dict.setValue("\(obj4)", forKey: "price")
                       let tagg="1006"+String(productArrayPosition)
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
                           let tagg="1006"+String(productArrayPosition)
                           let tagInt=Int(tagg)
                           if let txtField = self.view.viewWithTag(tagInt!) as? UITextField, let txt = txtField.text {
                                      
                               txtField.text = "\(obj3)"
                               print(txt)
                                   }
                    dict.setValue(newString, forKey: "unitPrice")
                           dict.setValue("\(obj3)", forKey: "price")
                       }
                }
               }
               else {
                   let tagg="1006"+String(productArrayPosition)
                   let tagInt=Int(tagg)
                   if let txtField = self.view.viewWithTag(tagInt!) as? UITextField, let txt = txtField.text {
                              
                       txtField.text = "0.0"
                       print(txt)
                           }
                dict.setValue(newString, forKey: "unitPrice")
                   dict.setValue("0.0", forKey: "price")
               }
              
           }
           
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
           if(productTagValue == 1003){ //req Quantity

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
           if(productTagValue == 2001){ // Price Per Unit

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
           
           var dict = NSMutableDictionary()
           dict = myProductArray[productArrayPosition] as! NSMutableDictionary

           print(productArrayPosition)
           print(productTagValue)
           
           if productTagValue == 1000{ //Product ID
               
               print("Product ID")
               print(textField.tag)
               dict.setValue(textField.text, forKey: "productUniqueNumber")
               myProductArray.replaceObject(at: productArrayPosition, with: dict)

           }else if(productTagValue == 1001){ //Product Name
               dict.setValue(textField.text, forKey: "productName")
               dict.setValue(false, forKey: "productNameWarn")
               myProductArray.replaceObject(at: productArrayPosition, with: dict)
               self.loadAddProductUI()
           }else if(productTagValue == 1003){ //Stock Quantity
               dict.setValue(textField.text, forKey: "stockQuantity")
               dict.setValue(false, forKey: "stockQuantityWarn")
               myProductArray.replaceObject(at: productArrayPosition, with: dict)
               self.loadAddProductUI()
           }else if(productTagValue == 1004){ //Stock Unit
               dict.setValue(textField.text, forKey: "stockUnit")
               myProductArray.replaceObject(at: productArrayPosition, with: dict)

           }else if(productTagValue == 1006){ //Price
               dict.setValue(textField.text, forKey: "price")
               myProductArray.replaceObject(at: productArrayPosition, with: dict)

           }
           else if(productTagValue == 2001){ // Price Per Stock Unit
               dict.setValue(textField.text, forKey: "unitPrice")
               dict.setValue(false, forKey: "unitPriceWarn")
               myProductArray.replaceObject(at: productArrayPosition, with: dict)
               self.loadAddProductUI()
              
           }
       
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
        
        var dict = NSMutableDictionary()
        dict = myProductArray[productArrayPosition] as! NSMutableDictionary

        print(productArrayPosition)
        print(productTagValue)

        
        if productTagValue == 1002{ //Descritpion

            print("Description")
            print(textView.tag)

            dict.setValue(textView.text, forKey: "description")

        }
        
        myProductArray.replaceObject(at: productArrayPosition, with: dict)

    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func showSucessMsg(message:String)  {
        
                let alertController = UIAlertController(title: "Success", message:message , preferredStyle: .alert)
                //to change font of title and message.
                let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
                let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Success", attributes: titleFont)
                let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
                alertController.setValue(titleAttrString, forKey: "attributedTitle")
                alertController.setValue(messageAttrString, forKey: "attributedMessage")
                
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                          let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingVC") as! ShoppingViewController
                          VC.modalPresentationStyle = .fullScreen
//                          self.present(VC, animated: true, completion: nil)
                    self.navigationController?.pushViewController(VC, animated: true)
                    
//                    self.navigationController?.popViewController(animated: true)

                   
                })
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)

    }
    var addProdServiceCntrl = ServiceController()
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
                                if self.categoryResult.count>0
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
    var selectedCategoryStr = ""
    var servcCntrl = ServiceController()
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
                                    let productArrayPosition : Int = self.subbuttonTapPositon
                                    let dict = self.myProductArray[productArrayPosition] as! NSDictionary
                                    if self.subCategoryResult.count>0
                                    {
                                    dict.setValue(respVo.result![0].name, forKey: "subCategory")
                                    dict.setValue(respVo.result![0]._id, forKey: "subCategoryId")
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
    
    func saveForLaterAPIWithTag(tagValue:Int) {
            
        var accountID = String()
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        print(accountID)
        
        removeProductImage()
        
        let productMainDict = myProductArray.object(at: tagValue) as! NSDictionary
        
        let productID = productMainDict.value(forKey: "productUniqueNumber") as? NSString ?? ""
        let productName = productMainDict.value(forKey: "productName") as? NSString ?? ""
        let prodDesc = productMainDict.value(forKey: "description") as? NSString ?? ""
        let stockQunatity = productMainDict.value(forKey: "stockQuantity") as? NSString ?? ""
        let stockUnit = productMainDict.value(forKey: "stockUnitId") as? NSString ?? ""
        let price =  productMainDict.value(forKey: "price") as? NSString ?? ""
        let preferredVendorIdStr =  productMainDict.value(forKey: "vendorId") as? NSString ?? ""
        let category =  productMainDict.value(forKey: "category") as? NSString ?? ""
        let subCategory =  productMainDict.value(forKey: "subCategory") as? NSString ?? ""
        let purchaseDate =  productMainDict.value(forKey: "purchaseDate") as? NSString ?? ""
        let prodImgArray =  productMainDict.value(forKey: "productImages") as? NSArray
        let pricePerStockUnit =  productMainDict.value(forKey: "unitPrice") as? NSString ?? ""
        let priceUnit =  productMainDict.value(forKey: "priceUnitId") as? NSString ?? ""
        let userId =  productMainDict.value(forKey: "userId") as? NSString ?? ""
        
        
//        print(imageJsonString)
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
//        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String

                let URLString_loginIndividual = Constants.BaseUrl + AddSaveForLaterShoppingCartProductUrl
        
                    let params_IndividualLogin = [
                        "accountId":accountID ,
                        "productUniqueNumber":productID,
                        "category":category,
                        "priceUnit":priceUnit,
                        "productName": productName,
                        "description": prodDesc,
                        "stockQuantity": stockQunatity,
                        "productDetailsFound":false,
                        "subCategory":subCategory,
                        "userId":userId,
                        "stockUnit": stockUnit,
                        "price": price,
                        "unitPrice": pricePerStockUnit,
                        "vendorId": preferredVendorIdStr,
                        "purchaseDate": purchaseDate,
                        "productImages": prodImgArray as Any,] as [String : Any]
                
//                    print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
                    addProdSerCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
//                      let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            
                        self.showSucessMsg(message: "Product added succesfully")
                            
//            self.showAlertWith(title: "Success", message: "Profile details updated successfully")
                            
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

    func callAddProductsAPI() {
        
//        let JSONStringFinal : String!
        
//        do {

            //Convert to Data
//            let jsonData = try JSONSerialization.data(withJSONObject: myProductArray, options: JSONSerialization.WritingOptions.prettyPrinted)

            //Convert back to string. Usually only do this for debugging
//            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
//               print(JSONString)
//               JSONStringFinal = JSONString
//                print(JSONStringFinal)
                
                activity.startAnimating()
                self.view.isUserInteractionEnabled = false
                
                let URLString_loginIndividual = Constants.BaseUrl + AddShoppingCartProductUrl
                 
                            let params_IndividualLogin = [
                                "" : ""
                            ]
        let defaults = UserDefaults.standard
        var userID = String()
        userID = (defaults.string(forKey: "userID") ?? "")
        let mainArray=NSMutableArray()
        for i in 0..<myProductArray.count
        {
            let dictt=myProductArray[i] as! NSDictionary
            var mainDictionary=NSDictionary()
            mainDictionary=[
                "description" : dictt.value(forKey: "description") as? String,
                "stockUnit" : dictt.value(forKey: "stockUnitId") as? String,
                "productUniqueNumber" : dictt.value(forKey: "productUniqueNumber") as? String,
                "category" : dictt.value(forKey: "category") as? String,
                "addedByUserId" : dictt.value(forKey: "addedByUserId") as? String,
                "priceUnit" : "616fd4205041085a07d69b1a",
                "productName" : dictt.value(forKey: "productName") as? String,
                "vendorName" : dictt.value(forKey: "vendorName") as? String,
                "price" : dictt.value(forKey: "price") as? String,
                "accountId" : dictt.value(forKey: "accountId") as? String,
                "subCategory" : dictt.value(forKey: "subCategory") as? String,
                "purchaseDate" : dictt.value(forKey: "purchaseDate") as? String,
                "productImages" : dictt.value(forKey: "productImages") as? NSArray,
                "productDetailsFound" : dictt.value(forKey: "productDetailsFound") as? Bool ?? false,
                "unitPrice" : dictt.value(forKey: "unitPrice") as? String,
                "vendorId" : dictt.value(forKey: "vendorId") as? String,
                "stockQuantity" : dictt.value(forKey: "stockQuantity") as? String,"userId":userID]
        
            mainArray.add(mainDictionary)
        }
        myProductArray=mainArray
                        
                            let postHeaders_IndividualLogin = ["":""]
                            
                addProdSerCntrl.requestPOSTURLWithArray(strURL: URLString_loginIndividual as NSString, postParams: myProductArray as NSArray, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                                
                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
                                    if(statusCode == 200 ){
                             
                                        self.showSucessMsg(message: "Product added succesfully")
                                        
//                                        self.showAlertWith(title: "Success", message: "Product added successfully")
                                        
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
    
    func callEditShoppingProductsAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
//        do {
            
            var dict = NSMutableDictionary()
        dict = myProductArray[0] as? NSMutableDictionary ?? NSMutableDictionary()
            
            var productImgArray = NSMutableArray()
            
            productImgArray = dict.value(forKey: "productImages") as! NSMutableArray
            
            let prodNameStr = dict.value(forKey: "productName") as! String
            let descStr = dict.value(forKey: "description") as! String
            let priceStr = dict.value(forKey: "price") as! String
            let stockQuan = dict.value(forKey: "stockQuantity") as! String
            let stockUnit = dict.value(forKey: "stockUnitId") as! String
            let purchaseDate = dict.value(forKey: "purchaseDate") as! String
            let productUniqNum = dict.value(forKey: "productUniqueNumber") as! String
            let category = dict.value(forKey: "category") as? String
            let subCatagory = dict.value(forKey: "subCategory") as! String
            let vendorId = dict.value(forKey: "vendorId") as! String
            let unitPrice = dict.value(forKey: "unitPrice") as! String
            let priceUnit = dict.value(forKey: "priceUnit") as! String
//            let productDetailsValue = dict.value(forKey: "productDetailsFound") as! String
            
            //Convert to Data
//            let jsonData = try JSONSerialization.data(withJSONObject: productImgArray, options: JSONSerialization.WritingOptions.prettyPrinted)

            //Convert back to string. Usually only do this for debugging

//            if let prodImgJSONString = String(data: jsonData, encoding: String.Encoding.utf8) {

            let URLString_loginIndividual = Constants.BaseUrl + ShoppingCartUpdateUrl
            
            let userDefaults = UserDefaults.standard
            let userID = userDefaults.value(forKey: "userID") as! String
            
                var accountID = String()
                accountID = (userDefaults.string(forKey: "accountId") ?? "")
                print(accountID)
                
        let params_IndividualLogin = ["_id":idStr,"productId":prodIDStr,"purchaseDate":purchaseDate as Any,"productUniqueNumber":productUniqNum,"productName":prodNameStr,"description":descStr,"stockQuantity":stockQuan,"stockUnit":stockUnit,"price":priceStr,"addedByUserId":userID,"accountId":accountID,"category":category as Any,"subCategory":subCatagory,"productImages":productImgArray,"vendorId":vendorId,"unitPrice":unitPrice,"priceUnit": "616fd4205041085a07d69b1a","productDetailsFound": false] as [String : Any]
                    
//                print(params_IndividualLogin)
                    
                        let postHeaders_IndividualLogin = ["":""]
                        
                addProdSerCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                            
                            let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            let statusCode = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                if(statusCode == 200 ){
                                    
//                     self.showAlertWith(title: "Success", message: "Details updated successfully")
                                    self.showSucessMsg(message: "Details updated successfully")

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
//                   }

//        }catch {
//
//        }
    }
    
    func getOrdersHistoryAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let userDefaults = UserDefaults.standard
        
        var accountID = String()
        accountID = (userDefaults.string(forKey: "accountId") ?? "")
        print(accountID)

        let URLString_loginIndividual = Constants.BaseUrl + OrdersHistoryUrl + accountID
                                    
        addProdSerCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:OrdersHistoryRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                self.ordersHistoryResult = respVo.result!
                                self.changeOrdersHistoryData()

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

