//
//  VendorAddProductViewController.swift
//  LekhaLatest
//
//  Created by USM on 15/04/21.
//

import UIKit
import ObjectMapper
import DropDown
import AVFoundation
import AVKit
import CommonCrypto
import Foundation

class VendorAddProductViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate,sentname,sendDetails,QRCodeReaderViewControllerDelegate,sendPropDetails,sendShoppingInfoDetails, UIScrollViewDelegate,UIImagePickerControllerDelegate & UINavigationControllerDelegate {
   
    func shoppingResultDetails(billScanStatus: String, type: String, dataArray: NSMutableArray) {
        
    }
    
        
    @IBOutlet weak var headerTitleLbl: UILabel!
    var isEditVendorProduct = Bool()
    var editProductDict = NSDictionary()
    var doorDeliveryVal = Bool()
    
    var idString = String()
    
    var servcCntrl = ServiceController()
    let dropDown = DropDown()
    
    var catSubCatArrPosition : Int!
    var catSubCatIndexPosition : Int!
    var catSubCatTagValue : Int!
    
    var selectedCategoryID : String!
    var selectedCategoryStr = ""
    var categoryDataArray = NSMutableArray()
    var categoryIDArray = NSMutableArray()
    typealias FinishedDownload = () -> ()
    var categoryResult = [CategoryResult]()
    var subCategoryResult = [SubCategoryResult]()
    var accountID = ""
    var storageLocationArr = NSMutableArray()
    var storageLocationArr1 = NSMutableArray()
    var storageLocationArr2 = NSMutableArray()
    var stockUnitsArr = [StockUnitMasterResultVo]()
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
    var vendorListResult = [VendorListResult]()
    var vendorDetails = NSMutableArray()
    
    var shoppingInfoAddProdView = ShoppingUseProductInfoView()
    
    var shoppingCurrentInvStatusStr = String()
    var shoppingCartStatusStr = String()
    var shoppingOpenOrdersStatusStr = String()
    var shoppingOrdersHistoryStatusStr = String()
    
    var isBillScan = ""
    
    var previousStatusStr = String()
    var presentStatusStr = String()
    
    let captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet var topHeaderBackgroundViewHeight: NSLayoutConstraint!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet weak var topHeaderBackgroundView: UIView!
    @IBOutlet weak var barCodeView: UIView!
    @IBOutlet weak var billScanView: UIView!
    @IBOutlet weak var ordersView: UIView!
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var barCodeImg: UIImageView!
    @IBOutlet weak var barcodeLbl: UILabel!
    @IBOutlet weak var billScanImg: UIImageView!
    @IBOutlet weak var billScanLbl: UILabel!
    @IBOutlet weak var ordersImg: UIImageView!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var manualImg: UIImageView!
    @IBOutlet weak var manualLbl: UILabel!
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var productScrollView = UIScrollView()
    var scrollViewYPos : CGFloat!
    var myProductArray = NSMutableArray()

    var prodImgJPos : Int!
    var prodImgIArrayPos : Int!
    var prodImgTagValue : Int!
    
    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
    
    var picker : UIDatePicker = UIDatePicker()
    
    var purchase_ExpiryTagVal : Int!
    var purchase_expiryProductPosLev : Int!
    var purchase_expiryTagValue : Int!
    
    var productNameTF = UITextField()
    var productIDTF = UITextField()
    var productIDImage = UIButton()
    var descriptionTF = UITextView()
    var keywordsTF = UITextView()
    var stockQuantityTF = UITextField()
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
    var vendorNameDropDown = UIButton()
    var storageLocationDropDown = UIButton()
    var storageLocation1DropDown = UIButton()
    var storageLocation2DropDown = UIButton()
    
    func sendnamedfields(fieldname:String,idStr:String){
        
        selectedCategoryID = idStr
        
        var dict = NSMutableDictionary()
        dict = myProductArray[catSubCatArrPosition] as! NSMutableDictionary

        if(catSubCatIndexPosition == 3000){ //Category Btn
            dict.setValue(fieldname, forKey: "category")
            dict.setValue(idStr, forKey: "categoryId")
            
            dict.setValue("", forKey: "subCategory")
            dict.setValue("", forKey: "subCategoryId")

        }else if(catSubCatIndexPosition == 3001){
            dict.setValue(fieldname, forKey: "subCategory")
            dict.setValue(fieldname, forKey: "subCategoryId")

        }else if(catSubCatIndexPosition == 3002){
            dict.setValue(idStr, forKey: "vendorId")
            dict.setValue(fieldname, forKey:"vendorName")

        }
        
        myProductArray.replaceObject(at:catSubCatArrPosition, with: dict)
        self.loadAddProductUI()
        
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewYPos = 0

        if isBillScan=="BillScan"
        {
            heightlength=250
        }
        else
        {
        self.addAnEmptyProduct()
        }
        
        if(isEditVendorProduct == true){
            
            headerTitleLbl.text = "Edit Product"
            self.saveButton.isHidden=true
            topHeaderBackgroundView.isHidden=true
            topHeaderBackgroundViewHeight.constant=0
            idString = editProductDict.value(forKey: "_id") as? String ?? ""
            changeEditProductImagesData()
        }
        get_storageLocationMaster_API_Call()
        get_StockUnitMaster_API_Call()
        getVendorListDataFromServer()
        get_PriceUnit_API_Call()
        getCategoriesDataFromServer()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.loadAddProductUI()
//        }
        
       
            
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isBillScan=="BillScan"
        {
            heightlength=250
        }
        else
        {
        }
        get_storageLocationMaster_API_Call()
        get_StockUnitMaster_API_Call()
        getVendorListDataFromServer()
        get_PriceUnit_API_Call()
        getCategoriesDataFromServer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadAddProductUI()
        }

    }
    
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
    
    // MARK: - QRCodeReader Delegate Methods
    var userDefaults=UserDefaults.standard
    func details(titlename: String, type: String, countrycode: String) {
        
    }
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
      
        reader.stopScanning()
                
        dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@",result.value),
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {

        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func parseQRCodeDataWithDict(dataDict:NSDictionary,index:Int,productUniqueID:String,productStatus:Bool)  {
        
        let prodName = dataDict.value(forKey: "brand") as? String ?? ""
        let description = dataDict.value(forKey: "description") as? String ?? ""
        let imagePath = dataDict.value(forKey: "image") as? String ?? ""
        
        let addressDict = dataDict.value(forKey: "gcp") as? NSDictionary ?? NSDictionary()
        let locationStr = addressDict.value(forKey: "city") as? String ?? ""
        let productIdStr = dataDict.value(forKey: "upc_code") as? String ?? ""
        

        
//        if(previousStatusStr == ""){
//
//            myProductArray = NSMutableArray()
//            addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr)
//            loadAddProductUI()
//
//        }else if(previousStatusStr == presentStatusStr){
        self.addBarCodeDetaulsAPI(prodId: productUniqueID ?? "", prodName: prodName ?? "", prodDescription: description ?? "", prodImg: imagePath,productStatus:productStatus)
        addProductWithProdName(productName: prodName, prodDesc: description, imageStr: imagePath, location: locationStr, productIdStr: productUniqueID, index: 0)
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
                              
          servcCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: paramsDict as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                                  
                                  let respVo:AddStockUnitMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
                                                          
                                  let status = respVo.STATUS_MSG
                                  let messageResp = respVo.message
                                  let statusCode = respVo.STATUS_CODE
                                  
                                  
                                  activity.stopAnimating()
                                  self.view.isUserInteractionEnabled = true
                                              
                                  if status == "SUCCESS" {
                                      
                                      if(statusCode == 200 ){
                               
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
    var heightlength:Int=250
    func addProductWithProdName(productName:String,prodDesc:String,imageStr:String,location:String,productIdStr:String,index:Int)   {
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
            for i in 0..<8 {

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
                       "productNameWarn":false,
                       "stockQuantityWarn":false,"offerPriceWarn":false]
            }
            else
            {
                myDict  = ["accountId": accountID, "productName": productName, "productUniqueNumber": productIdStr,"description": prodDesc,"stockQuantity": "1.000","stockUnit": "","purchaseDate": selectedDate,"expiryDate": "","storageLocation": location,"borrowed": "","category": "","subCategory": "","orderId": "","vendorId": "","price": "","uploadType": "","userId": userID,"productImages": prodImgArray,"vendorName":"","isActive":"1","priceUnit": "616fd4205041085a07d69b1a","productDetailsFound": false, "unitPriceWarn":false,
                           "productNameWarn":false,
                           "stockQuantityWarn":false,"offerPriceWarn":false]
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
            for i in 0..<8 {

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
                                  "productNameWarn":false,
                                  "stockQuantityWarn":false,"offerPriceWarn":false]
                       }
                       else
                       {
                           myDict  = ["accountId": accountID, "productName": productName, "productUniqueNumber": productIdStr,"description": prodDesc,"stockQuantity": "1.000","stockUnit": "","purchaseDate": selectedDate,"expiryDate": "","storageLocation": location,"borrowed": "","category": "","subCategory": "","orderId": "","vendorId": "","price": "","uploadType": "","userId": userID,"productImages": prodImgArray,"vendorName":"","isActive":"1","priceUnit": "616fd4205041085a07d69b1a","productDetailsFound": false, "unitPriceWarn":false,
                                      "productNameWarn":false,
                                      "stockQuantityWarn":false,"offerPriceWarn":false]
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
        
            for i in 0..<8 {

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
            
            myDict  = ["accountId": accountID, "productName": productName, "productUniqueNumber": productIdStr,"description": prodDesc,"stockQuantity": "1.000","stockUnit": "","purchaseDate": selectedDate,"expiryDate": "","storageLocation": "","borrowed": "","category": "","subCategory": "","orderId": "","vendorId": "","price": "","uploadType": "","userId": userID,"productImages": prodImgArray,"isActive":"1","vendorName":"","priceUnit": "616fd4205041085a07d69b1a","productDetailsFound": false, "unitPriceWarn":false,
                       "productNameWarn":false,
                       "stockQuantityWarn":false,"offerPriceWarn":false]

            myProductArray.add(myDict)
//
        }
        }
    }
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
                           
                if(prodId == "" && prodName == "" && desc == "" && expiryDate == "" && orderId == "" && price == "" ){
                    
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
    @IBAction func barCodeBtnTap(_ sender: UIButton) {
        var valueQR=String()
        self.heightlength=250
        var productUniqueID=String()
        
        self.removeEmptyObjects{ () -> () in
        
        //        presentStatusStr = "BarCode"
            var productArrayPosition = Int()
//            let sstag:String = String((sender as AnyObject).tag)
//            if sstag.count>5
//            {
//             productArrayPosition = (sender as AnyObject).tag%100
//
//            }
//            else
//            {
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
                            productUniqueID=result.value
                        valueQR=aa
                        let urlStr = Constants.BaseUrl + barCodeDetailsUrl + result.value
                //            "8901207038440"
                        
                        self.servcCntrl.requestGETURL(strURL: urlStr, success: {(result) in
                            
                            let respVo:BarCodeDetailsRespVo = Mapper().map(JSON: result as! [String : Any])!
                            
                            DispatchQueue.main.async {
                                
                                let status = respVo.statusCode
                                let message = respVo.status
                                
                                if status == 200 {
                                    
                                    if message == "SUCCESS" {
                                        if respVo.result != nil {
                                            if respVo.productDetailsFound == true {
                                            self.barCodeDetailsArr = respVo.result
                                            
                //                            self.barCodeDetails()
                                            
                                            let imageee=respVo.result?.productImages?[0].productImage
                                            
                                            self.addProductWithProdName(productName: respVo.result?.productName ?? "", prodDesc: respVo.result?.description ?? "", imageStr: imageee ?? "", location: "", productIdStr: respVo.result?.productUniqueNumber ?? "", index: productArrayPosition )
                                            self.loadAddProductUI()
                                            self.view.makeToast("Product details found")
                                        }
                                        else {
                                          
                                                
                                                
                                                //    var urlString = "https://barcode-lookup.p.rapidapi.com/v2/products?barcode=\(result.value)"
                                                
                                                activity.startAnimating()
                                                self.view.isUserInteractionEnabled = false
                                                           
                                                let SignStr = "\(aa)".hmac(key: "Mc52Q8y3y1Gy0Pt8")
                                                                print("Result is \(SignStr)")

                                                let urlStr = "http://www.digit-eyes.com/gtin/v3_0/?upcCode=\(aa)&language=en&app_key=/8WAVP//X3gQ&signature=\(SignStr)"

                                                                self.servcCntrl.requestGETURL(strURL: urlStr, success: {(result) in
                                                                    activity.stopAnimating()
                                                                    self.view.isUserInteractionEnabled = true
                                                                    let dataDictRes = result as! NSDictionary
                                                                    print("Result Data is \(dataDictRes)")
//                                                                    if dataDictRes.value(forKey: "return_code") as? String == "995" || dataDictRes.value(forKey: "return_code") as? String == "999"
//                                                                    {
//                                                                        activity.stopAnimating()
//                                                                        self.view.isUserInteractionEnabled = true
//                                                                        self.view.makeToast("Product details not found")
//                                                                    }
//                                                                    else
//                                                                    {
                                                                    activity.stopAnimating()
                                                                    self.view.isUserInteractionEnabled = true
                                                        //            self.parseQRCodeDataWithDict(dataDict: dataDictRes)
                                                                    var productStatus=false
                                                                    if let pproduct=dataDictRes.value(forKey: "products") as? NSMutableArray
                                                                    {
                                                                        if pproduct.count>0
                                                                        {
                                                                            productStatus=true
                                                                        }
                                                                        
                                                                    }
                                                                    self.parseQRCodeDataWithDict(dataDict: dataDictRes, index: productArrayPosition, productUniqueID: productUniqueID, productStatus: productStatus)
                                                                    self.view.makeToast("Product details found")
                                                                   // }
                                           
                                                                  
                                                              }) { (error) in
                                                                    activity.stopAnimating()
                                                                  self.view.isUserInteractionEnabled = true
                                                                  print("Something Went To Wrong...PLrease Try Again Later")
                                                                    self.view.makeToast("Product details not found")
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

                                                            self.servcCntrl.requestGETURL(strURL: urlStr, success: {(result) in
                                                                activity.stopAnimating()
                                                                self.view.isUserInteractionEnabled = true
                                                                let dataDictRes = result as! NSDictionary
                                                                print("Result Data is \(dataDictRes)")
//                                                                if dataDictRes.value(forKey: "return_code") as? String == "995" || dataDictRes.value(forKey: "return_code") as? String == "999"
//                                                                {
//                                                                    activity.stopAnimating()
//                                                                    self.view.isUserInteractionEnabled = true
//                                                                    self.view.makeToast("Product details not found")
                                                                //                          , productStatus: <#Bool#>                                      }
//                                                                else
//                                                                {
                                                                activity.stopAnimating()
                                                                self.view.isUserInteractionEnabled = true
                                                    //            self.parseQRCodeDataWithDict(dataDict: dataDictRes)
                                                                var productStatus=false
                                                                if let pproduct=dataDictRes.value(forKey: "products") as? NSMutableArray
                                                                {
                                                                    if pproduct.count>0
                                                                    {
                                                                        productStatus=true
                                                                    }
                                                                    
                                                                }
                                                                self.parseQRCodeDataWithDict(dataDict: dataDictRes, index: productArrayPosition, productUniqueID: productUniqueID, productStatus: productStatus)
                                                                self.view.makeToast("Product details found")
                                                               // }
                                       
                                                              
                                                          }) { (error) in
                                                                activity.stopAnimating()
                                                              self.view.isUserInteractionEnabled = true
                                                              print("Something Went To Wrong...PLrease Try Again Later")
                                                                self.view.makeToast("Product details not found")
                                                          }
                                                                                }
                                }
                                else {
                //                    self.view.makeToast(message)
                                    activity.stopAnimating()
                                                                                                     self.view.isUserInteractionEnabled = true
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
    @IBAction func billScanBtnTap(_ sender: UIButton) {
        self.removeEmptyObjects{ () -> () in
            addProductArray=myProductArray
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let VC = storyBoard.instantiateViewController(withIdentifier: "ViewController1") as! ViewController1
        VC.modalPresentationStyle = .fullScreen
//    self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    @IBAction func ordersBtnTap(_ sender: UIButton) {
        
        loadAddProductView()
    }
    @IBAction func manualBtnTap(_ sender: UIButton) {
        
        presentStatusStr = "Manual"
        
        if(previousStatusStr == ""){
            myProductArray = NSMutableArray()
            addAnEmptyProduct()
            loadAddProductUI()
            
        }else if(previousStatusStr == presentStatusStr){
//            addAnEmptyProduct()
//            loadAddProductUI()

        }else{
            
            myProductArray = NSMutableArray()
            addAnEmptyProduct()
            loadAddProductUI()

        }
        
        previousStatusStr = presentStatusStr
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
        VC.isAddProduct = "1"
        VC.currentInventoryStatusStr = shoppingCurrentInvStatusStr
        VC.shoppingCartttStatusStr = shoppingCartStatusStr
        VC.openOrdersStatusStr = shoppingOpenOrdersStatusStr
        VC.ordersHistoryStatusStr = shoppingOrdersHistoryStatusStr
        VC.shoppingResDelegate = self
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


    
    func sendPropertyDetails(data: NSArray, idStr: String) {
        self.loadAddProductUI()
        
    }
    
    func addAnEmptyProduct() {
        self.storageLocationArr.removeAllObjects()
        self.storageLocationArr1.removeAllObjects()
        self.storageLocationArr2.removeAllObjects()
        self.get_storageLocationMaster_API_Call()
        var myDict = NSMutableDictionary()
        
//        var prodImgArray =
        var prodImgDict = NSMutableDictionary()

        let prodImgArray = NSMutableArray()
        for _ in 0..<8 {

            prodImgDict = ["productImage": "","productDisplayImage":"","isLocalImg":"1"]
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

        
    /*    myDict  = ["accountId": accountID, "productName": "", "productUniqueNumber": "","description": "","stockQuantity": "","stockUnit": "","purchaseDate": selectedDate,"expiryDate": "","storageLocation": "","borrowed": "","category": "","subCategory": "","categoryId": "","subCategoryId": "","orderId": "","vendorId": "","price": "","uploadType": "","userId": userID,"productImages": prodImgArray,"isActive":"0","unitPrice":""]
        
        */
        
        myDict = ["accountId":accountID ?? "",
                      "actualPrice": "",
                      "actualUnitPrice": "",
                      "category": "",
                      "description": "",
                      "doorDelivery": "false",
                      "expiryDate": "",
                      "keyWords":"",
                      "offeredPrice": "",
                      "offeredUnitPrice": "",
                      "orderId": "",
                      "priceUnit": "",
                      "storageLocation": "",
                      "storageLocation1": "",
                      "storageLocation2": "",
                      "productUniqueNumber": "",
                      "productImages":prodImgArray,
                      "productName":"",
                      "purchaseDate": "",
                      "stockQuantity": "",
                      "stockUnit": "",
                      "subCategory": "",
                      "unitPrice":"",
                      "unitPriceWarn":false,
                      "productNameWarn":false,
                      "stockQuantityWarn":false,
                      "offerPriceWarn":false,
                      "vendor": "","vendorName": "","vendorProductImages":prodImgArray]

        
        myProductArray.add(myDict)
        
    }
    
    func changeEditProductImagesData(){
        
        var dict = NSMutableDictionary()
        dict = myProductArray[0] as? NSMutableDictionary ?? NSMutableDictionary()
        
        var productImgArray = NSMutableArray()
        
        productImgArray = dict.value(forKey: "productImages") as! NSMutableArray
        
        let prodArray = editProductDict.value(forKey: "vendorProductImages") as? NSArray
        
        for i in 0..<8 {
            
            var  productImgict = NSMutableDictionary()
            
            if(prodArray?.count ?? 0  > 0){
                
                if(i == 0){
                    
                    let dict = prodArray?[0] as? NSDictionary
                    let imageStr = dict?.value(forKey: "0") as! String
                    
                    productImgict = productImgArray[0] as! NSMutableDictionary
                    productImgict.setValue("", forKey: "productImage")
                    productImgict.setValue("", forKey: "productDisplayImage")
                    productImgict.setValue(imageStr, forKey: "productServerImage")

                }else if(i == 1){
                    
                    let dict = prodArray?[0] as! NSDictionary
                    let imageStr = dict.value(forKey: "1") as! String
                    
                    productImgict = productImgArray[1] as! NSMutableDictionary
                    productImgict.setValue("", forKey: "productImage")
                    productImgict.setValue("", forKey: "productDisplayImage")
                    productImgict.setValue(imageStr, forKey: "productServerImage")

                    
                }else{
                    
                    let dict = prodArray?[0] as! NSDictionary
                    let imageStr = dict.value(forKey: "\(i)") as! String
                    
                    productImgict = productImgArray[i] as! NSMutableDictionary
                    productImgict.setValue("", forKey: "productImage")
                    productImgict.setValue("", forKey: "productDisplayImage")
                    productImgict.setValue(imageStr, forKey: "productServerImage")

                }
                
                productImgArray.replaceObject(at:i, with: productImgict)
                print(productImgArray)

            }
        }
        
//        ["accountId": accountID, "productName": "","description": "","keyWords":"","stockQuantity": "","stockUnit": "","expiryDate": "","category": "","subCategory": "","categoryId": "","subCategoryId": "","actualPrice": "","offeredPrice": "","productImages": prodImgArray]
        
        print(editProductDict)
        
        let offeredPriceIn = editProductDict.value(forKey: "offeredPrice") as? Double ?? 0
        let offeredPriceStr = "\(offeredPriceIn)"
        let offeredPricePerUnit = editProductDict.value(forKey: "offeredUnitPrice") as? Double ?? 0
        let offeredPricePerUnitStr = "\(offeredPricePerUnit)"
        
        let actualPriceIn = editProductDict.value(forKey: "actualPrice") as? Double ?? 0
        let actualPriceStr = "\(actualPriceIn)"
        
        let stockQuanIn = editProductDict.value(forKey: "stockQuantity") as? Int ?? 0
        let stockQtyStr = "\(stockQuanIn)"
        
        let stockUnitDetails = editProductDict.value(forKey: "stockUnitDetails") as? NSArray
        var stockUnitStr=String()
        if stockUnitDetails!.count>0
        {
            let stockUnitDictionary = stockUnitDetails![0] as? [String:AnyObject]
            stockUnitStr=stockUnitDictionary!["stockUnitName"]as! String
        }
        else
        {
            stockUnitStr=""
        }
        let priceUnitDetails = editProductDict.value(forKey: "priceUnitDetails") as? NSArray
        var priceUnitStr=String()
        if priceUnitDetails!.count>0
        {
            let priceUnitDictionary = priceUnitDetails![0] as? [String:AnyObject]
            priceUnitStr=priceUnitDictionary!["priceUnit"]as! String
        }
        else
        {
            priceUnitStr=""
        }
        let vendorDetails = editProductDict.value(forKey: "vendorDetails") as? NSArray
        var vendorDetailsStr=String()
        if vendorDetails!.count>0
        {
            let vendorDetailsDictionary = vendorDetails![0] as? [String:AnyObject]
            vendorDetailsStr=vendorDetailsDictionary!["vendorName"]as! String
        }
        else
        {
            vendorDetailsStr=""
        }

        dict.setValue(vendorDetailsStr, forKey: "vendor")
        dict.setValue(editProductDict.value(forKey: "productName"), forKey: "productName")
        dict.setValue(editProductDict.value(forKey: "productUniqueNumber"), forKey: "productUniqueNumber")
        dict.setValue(editProductDict.value(forKey: "description"), forKey: "description")
        dict.setValue(editProductDict.value(forKey: "keyWords"), forKey: "keyWords")
        dict.setValue(stockQtyStr, forKey: "stockQuantity")
        dict.setValue(stockUnitStr, forKey: "stockUnit")
        dict.setValue(offeredPricePerUnitStr, forKey: "offeredUnitPrice")
        dict.setValue(offeredPriceStr, forKey: "unitPrice")
        dict.setValue(editProductDict.value(forKey: "category"), forKey: "category")
        dict.setValue(editProductDict.value(forKey: "subCategory"), forKey: "subCategory")
        dict.setValue(editProductDict.value(forKey: "categoryId"), forKey: "categoryId")
        dict.setValue(editProductDict.value(forKey: "subCategoryId"), forKey: "subCategoryId")
        dict.setValue(editProductDict.value(forKey:"doorDelivery"), forKey: "doorDelivery")
        dict.setValue(priceUnitStr, forKey: "priceUnit")
        
        selectedCategoryID = editProductDict.value(forKey: "categoryId") as? String

        let purcDate = editProductDict.value(forKey: "purchaseDate") ?? ""
//        let convertedPurchaseDate = convertDateFormatter(date: purcDate)
        let expDate = editProductDict.value(forKey: "expiryDate") ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let convertedDate1 = dateFormatter.date(from: purcDate as! String)
        let convertedDate = dateFormatter.date(from: expDate as! String)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)
      
        let timeStamp1 = dateFormatter.string(from: convertedDate1!)
        dict.setValue(timeStamp, forKey: "expiryDate")
        dict.setValue(timeStamp1, forKey: "purchaseDate")

        dict.setValue(productImgArray, forKey: "productImages")
        myProductArray.replaceObject(at:0 , with: dict)
        
        print(myProductArray)

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
       
       let productArrayPosition : Int = sender.tag%10
       let productTagValue:Int = sender.tag / 10;

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

       }else if(purchase_expiryTagValue == 1008){
           dict.setValue(dateFormatter.string(from: eventDatePicker.date), forKey: "expiryDate")

       }
       
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

       }else if(purchase_expiryTagValue == 1008){
           dict.setValue(selectedDate, forKey: "expiryDate")

       }
       
       myProductArray.replaceObject(at:purchase_expiryProductPosLev, with: dict)

   }
   
   @objc func doneBtnTap(_ sender: UIButton) {

       hiddenBtn.removeFromSuperview()
       pickerDateView.removeFromSuperview()
       
       self.loadAddProductUI()
       
   }
    @objc func deleteBtnTap(_ sender: UIButton) {
        myProductArray.removeObject(at: sender.tag)
        self.showAlertWith(title: "Success", message: "Product deleted")

        loadAddProductUI()
        
    }
    var fromButton=String()
    @IBAction func productIdSearchBtnTap(_ sender: UIButton) {
        self.productIDTF.resignFirstResponder()
        fromButton="search"
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            var productArrayPosition = Int()
            let sstag:String = String(sender.tag)
            if sstag.count>5
            {
             productArrayPosition = sender.tag%100
             
            }
            else
            {
             productArrayPosition = sender.tag%10
                
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
            
            self.view.makeToast("Please enter Product Id")
        }
        else {
            
            self.get_barCodeDetails_API_Call(index: productArrayPosition,productId:productID)
            
        }
        }
    }
    var barCodeDetailsArr:BarCodeDetailsResultVo?
    // MARK: Get AddressBook API Call
        func get_barCodeDetails_API_Call(index:Int,productId:String) {
        
          
            
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let productIdStr = productId ?? ""
        
        print(productIdStr)
        
        let urlStr = Constants.BaseUrl + barCodeDetailsUrl + productIdStr
//            "8901207038440"
        
        servcCntrl.requestGETURL(strURL: urlStr, success: {(result) in
            
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
                                                        
                           
                                self.barCodeThirdPartyAPI(index: index,productId: productId)
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
           //self.view.makeToast("app.SomethingWentToWrongAlert".localize())
            self.view.makeToast("Product details not found")
            print("Oops, your connection seems off... Please try again later")
        }
    }
    func barCodeThirdPartyAPI(index:Int,productId:String){
        
        let productIdStr = productIDTF.text ?? ""
//            "8901207038440"
        
        let SignStr = "\(productIdStr)".hmac(key: "Mc52Q8y3y1Gy0Pt8")
//        print("Result is \(SignStr)")
        
        let urlStr = "http://www.digit-eyes.com/gtin/v3_0/?upcCode=\(productIdStr)&language=en&app_key=/8WAVP//X3gQ&signature=\(SignStr)"
        
//        String url = "https://www.digit-eyes.com/gtin/v3_0/?upcCode=" + Upc + "&language=en&app_key=" + BARCODE_APP_KEY + "&signature=" + getsignature(Upc);
//        let urlStr = ""
        
        self.servcCntrl.requestGETURL(strURL: urlStr, success: {(result) in
            
            let dataDictRes = result as! NSDictionary
            print("Result Data is \(dataDictRes)")
//            if dataDictRes.value(forKey: "return_code") as? String == "995" || dataDictRes.value(forKey: "return_code") as? String == "999"
//            {
//                activity.stopAnimating()
//                self.view.isUserInteractionEnabled = true
//                self.view.makeToast("Product details not found")
//            }
//            else
//            {
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
//            self.parseQRCodeDataWithDict(dataDict: dataDictRes)
            var productStatus=false
            if let pproduct=dataDictRes.value(forKey: "products") as? NSMutableArray
            {
                if pproduct.count>0
                {
                    productStatus=true
                }
                
            }
            self.parseBarCodeDataWithDict(dataDict: dataDictRes, index: index, productUniqueId: productIdStr, productStatus: productStatus)
            self.view.makeToast("Product details found")
           // }

          
      }) { (error) in
          
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.view.makeToast("Product details not found")
          print("Something Went To Wrong...PLrease Try Again Later")
      }
    }
    func parseBarCodeDataWithDict(dataDict:NSDictionary,index:Int,productUniqueId:String,productStatus:Bool)  {
        
        let prodName = dataDict.value(forKey: "brand") as? String ?? ""
        let description = dataDict.value(forKey: "description") as? String ?? ""
        let imagePath = dataDict.value(forKey: "image") as? String ?? ""
        
//        let addressDict = dataDict.value(forKey: "gcp") as? NSDictionary
//        let locationStr = addressDict?.value(forKey: "city") as? String ?? ""
        let productIdStr = dataDict.value(forKey: "upc_code") as? String ?? ""
        
//        self.productNameTF.text = prodName
//        self.productIDTF.text = productIdStr
//        self.descriptionTF.text = description
        self.addBarCodeDetaulsAPI(prodId: productUniqueId ?? "", prodName: prodName ?? "", prodDescription: description ?? "", prodImg: imagePath,productStatus:productStatus)
        self.addProductWithProdName(productName: prodName ?? "", prodDesc: description ?? "", imageStr: imagePath, location: "", productIdStr: productUniqueId ?? "", index: index )
        self.loadAddProductUI()
        
    }
    func loadAddProductUI() {
        
        productScrollView.removeFromSuperview()
        print("self.heightlength",self.heightlength)
        productScrollView = UIScrollView()
        if(isEditVendorProduct == true)
            {
            productScrollView.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: self.view.frame.size.height+50)
            productScrollView.backgroundColor = hexStringToUIColor(hex: "e4ecf9")
            }
        else
        {
        productScrollView.frame = CGRect(x: 0, y: CGFloat(self.heightlength), width: self.view.frame.size.width, height: self.view.frame.size.height - (topHeaderBackgroundView.frame.size.height)+50)
        productScrollView.backgroundColor = hexStringToUIColor(hex: "e4ecf9")
        }
        self.view.addSubview(productScrollView)
        
        productScrollView.delegate = self
        
        var yValue = CGFloat()
        yValue = 15
        
        if(myProductArray.count > 0){
            
        }
        
        for i in 1...myProductArray.count {
            
             productNameTF = UITextField()
             productIDTF = UITextField()
             descriptionTF = UITextView()
             keywordsTF = UITextView()
             stockQuantityTF = UITextField()
             //stockUnitTF = UITextField()
             priceTF = UITextField()
             offerPriceTF = UITextField()
             //priceUnitTF = UITextField()
             pricePerStockUnitTF = UITextField()
             totalPriceTF = UITextField()
             //storageLocationTF = UITextField()
             //vendorNameTF = UITextField()
             orderIdTF = UITextField()
            
            priceTF.keyboardType = UIKeyboardType.decimalPad
            stockQuantityTF.keyboardType = UIKeyboardType.numberPad

            let productView = UIView()
            productView.backgroundColor = UIColor.white
            productView.frame = CGRect(x: 15, y: yValue, width: productScrollView.frame.size.width - 30, height: 1000)
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
            
            let deleteBtn = UIButton()
            deleteBtn.frame = CGRect(x: productView.frame.size.width - (40), y: 10, width: 25, height: 25)
            deleteBtn.setImage(UIImage.init(named: "deleteBlue"), for: UIControl.State.normal)
            deleteBtn.addTarget(self, action: #selector(deleteBtnTap), for: .touchUpInside)
            productView.addSubview(deleteBtn)
            
            //Seperator Line Lbl
            
            let seperatorLine = UILabel()
            seperatorLine.frame = CGRect(x: 10, y: productLbl.frame.origin.y+productLbl.frame.size.height+10, width: productView.frame.size.width - (20), height: 1)
            seperatorLine.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
            productView.addSubview(seperatorLine)
            
            var addProdXValue = CGFloat()
            addProdXValue = 10
            
            var addBtnYValue = CGFloat()
            addBtnYValue = seperatorLine.frame.origin.y+seperatorLine.frame.size.height+75
            
            let productMainDict = myProductArray.object(at: i-1) as! NSMutableDictionary
            let prodArray = productMainDict.value(forKey: "productImages") as! NSMutableArray
            
            let prodImgScrollView = UIScrollView()
            prodImgScrollView.frame = CGRect(x: 10, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: productView.frame.size.width - 20, height: 60)
            prodImgScrollView.showsHorizontalScrollIndicator = false
            productView.addSubview(prodImgScrollView)
            
            for j in 1...prodArray.count {
                
                let productDict = prodArray.object(at: j-1) as! NSMutableDictionary
                
                let prodImgStr = productDict.value(forKey: "productImage") as? NSString

                //Add Btn

                let addBtn = UIButton()
                addBtn.frame = CGRect(x: addProdXValue, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: 60, height: 60)
                addBtn.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
                
                let isLocalImage = productDict.value(forKey: "isLocalImg") as? String
                
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
                    
                }else if(isLocalImage == "BillScan"){
                    
                    var imageStr = ""
                        let prodImgStr1 = productDict.value(forKey: "productDisplayImage") as? String ?? ""

                    if prodImgStr1 == "" {
                        
                        imageStr = productDict.value(forKey: "productImage") as? String ?? ""
                    }
                    else {
                        
                        imageStr = prodImgStr1
                    }
                        let imgUrl:String = imageStr
                        
                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                        let imggg = trimStr
                        
                        let fileUrl = URL(string: imggg)
                        addBtn.sd_setImage(with: fileUrl, for: .normal, completed: nil)
                   
                }else{
                    
                    if prodImgStr == "" {
                        addBtn.setImage(UIImage.init(named: "plus"), for: UIControl.State.normal)
                        addBtn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

                    }else{
                        
                        let prodImg = productDict.value(forKey: "productDisplayImage") as? UIImage
                        addBtn.setImage(prodImg, for: UIControl.State.normal)
                    }
                }
                
                addBtn.layer.cornerRadius = 10
                addBtn.layer.masksToBounds = true
                productView.addSubview(addBtn)
                
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
            
            prodImgScrollView.contentSize = CGSize(width: addProdXValue, height: 60)
            
            //Seperator Line 1 Lbl
            
            let seperatorLine1 = UILabel()
            seperatorLine1.frame = CGRect(x: 10, y: prodImgScrollView.frame.origin.y+prodImgScrollView.frame.size.height+15, width: productView.frame.size.width - (20), height: 1)
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
            
            productNameTF.layer.borderWidth = 1
            productNameTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            productNameTF.layer.cornerRadius = 3
            productNameTF.clipsToBounds = true

            let productNamePaddingView = UIView()
            productNamePaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: productNameTF.frame.size.height)
            productNameTF.leftView = productNamePaddingView
            productNameTF.leftViewMode = UITextField.ViewMode.always
            if productMainDict.value(forKey: "productNameWarn") as? Bool==true
            {
            let productNameAlertButton = UIButton()
            productNameAlertButton.frame = CGRect(x: productNameTF.frame.size.width - 30, y: productNameTF.frame.origin.y+5, width: 30, height: 30)
            productNameAlertButton.setImage(UIImage(named: "warn.png"), for: .normal)
            productNameAlertButton.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
            productView.addSubview(productNameAlertButton)
            }
            //Description Lbl
            
            let descriptionLbl = UILabel()
            descriptionLbl.frame = CGRect(x: 10, y: productNameTF.frame.origin.y+productNameTF.frame.size.height+15, width: productView.frame.size.width - (20), height: 20)
            descriptionLbl.text = "Product Description :"
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

//            let descPaddingView = UIView()
//            descPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: productNameTF.frame.size.height)
//            descriptionTF.leftView = descPaddingView
//            descriptionTF.leftViewMode = UITextField.ViewMode.always
            
            //Description Lbl
            
            let keywordsLbl = UILabel()
            keywordsLbl.frame = CGRect(x: 10, y: descriptionTF.frame.origin.y+descriptionTF.frame.size.height+15, width: productView.frame.size.width - (20), height: 20)
            keywordsLbl.text = "Product Keywords :"
            keywordsLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            keywordsLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(keywordsLbl)
            
            //Description Text View

            keywordsTF.frame = CGRect(x: 10, y: keywordsLbl.frame.origin.y+keywordsLbl.frame.size.height+5, width: productView.frame.size.width - (20), height: 80)
//            descriptionTF.text = "fdfdsfdsfd"
            keywordsTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            keywordsTF.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(keywordsTF)
            
            keywordsTF.layer.borderWidth = 1
            keywordsTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            keywordsTF.layer.cornerRadius = 3
            keywordsTF.clipsToBounds = true

            //Stock Quantity Lbl
            
            let stockQuantityLbl = UILabel()
            stockQuantityLbl.frame = CGRect(x: 10, y: keywordsTF.frame.origin.y+keywordsTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            stockQuantityLbl.text = "Stock Quantity :"
            stockQuantityLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            stockQuantityLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(stockQuantityLbl)
            
            //Product Name TF

            stockQuantityTF.frame = CGRect(x: 10, y: stockQuantityLbl.frame.origin.y+stockQuantityLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
//            stockQuantityTF.text = "fdfdsfdsfd"
            stockQuantityTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            stockQuantityTF.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(stockQuantityTF)
            if productMainDict.value(forKey: "stockQuantityWarn") as? Bool==true
            {
            let stockQuantityAlertButton = UIButton()
            stockQuantityAlertButton.frame = CGRect(x: stockQuantityTF.frame.size.width - 30, y: stockQuantityTF.frame.origin.y+5, width: 30, height: 30)
            stockQuantityAlertButton.setImage(UIImage(named: "warn.png"), for: .normal)
            stockQuantityAlertButton.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
            productView.addSubview(stockQuantityAlertButton)
            }
            stockQuantityTF.layer.borderWidth = 1
            stockQuantityTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            stockQuantityTF.layer.cornerRadius = 3
            stockQuantityTF.clipsToBounds = true

            let stockQuanPaddingView = UIView()
            stockQuanPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: stockQuantityTF.frame.size.height)
            stockQuantityTF.leftView = stockQuanPaddingView
            stockQuantityTF.leftViewMode = UITextField.ViewMode.always

            //Stock unit Lbl
            
//            let stockunitLbl = UILabel()
//            stockunitLbl.frame = CGRect(x: productView.frame.size.width/2+10, y: keywordsTF.frame.origin.y+keywordsTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
//            stockunitLbl.text = "Stock Unit :"
//            stockunitLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
//            stockunitLbl.textColor = hexStringToUIColor(hex: "232c51")
//            productView.addSubview(stockunitLbl)
            
            //Stock Unit TF
                        
//            stockUnitTF.frame = CGRect(x: productView.frame.size.width/2+10, y: stockunitLbl.frame.origin.y+stockunitLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
//            stockUnitTF.text = "NA"
//            stockUnitTF.font = UIFont.init(name: kAppFontMedium, size: 13)
//            stockUnitTF.textColor = hexStringToUIColor(hex: "232c51")
//            productView.addSubview(stockUnitTF)
//
//            stockUnitTF.layer.borderWidth = 1
//            stockUnitTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
//            stockUnitTF.layer.cornerRadius = 3
//            stockUnitTF.clipsToBounds = true
//
//            let stockUnitPaddingView = UIView()
//            stockUnitPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: stockUnitTF.frame.size.height)
//            stockUnitTF.leftView = stockUnitPaddingView
//            stockUnitTF.leftViewMode = UITextField.ViewMode.always
            
            //Stock unit Lbl
            let stockUnitBtn = UIButton()
            stockUnitBtn.frame = CGRect(x:productView.frame.size.width / 2 + 10, y: keywordsTF.frame.origin.y+keywordsTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
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
            
            let attrs = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
                NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

            let attributedString = NSMutableAttributedString(string:"")
            
            let buttonTitleStr = NSMutableAttributedString(string:"Stock unit masterlist", attributes:attrs)
            attributedString.append(buttonTitleStr)
            stockUnitMasterListBtn.setAttributedTitle(attributedString, for: .normal)
            
            
            //Expiry Date Lbl
            
            let expiryDateLbl = UILabel()
            expiryDateLbl.frame = CGRect(x: productView.frame.size.width/2+10, y: stockUnitMasterListBtn.frame.origin.y+stockUnitMasterListBtn.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            expiryDateLbl.text = "Expiry Date :"
            expiryDateLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            expiryDateLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(expiryDateLbl)
            
            //Expiry Date TF

            let expiryDateTF = UIButton()
            expiryDateTF.frame = CGRect(x: productView.frame.size.width/2+10, y: expiryDateLbl.frame.origin.y+expiryDateLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
            expiryDateTF.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
            expiryDateTF.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            let expiryImage = UIButton()
            expiryImage.frame = CGRect(x: productView.frame.size.width - (40), y: expiryDateTF.frame.origin.y+6, width: 25, height: 25)
            expiryImage.setImage(UIImage.init(named: "calenderlatest"), for: UIControl.State.normal)
            productView.addSubview(expiryImage)
            productView.addSubview(expiryDateTF)
            
            expiryDateTF.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
            expiryDateTF.layer.borderWidth = 1
            expiryDateTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            expiryDateTF.layer.cornerRadius = 3
            expiryDateTF.clipsToBounds = true
            
//            purchaseDateTF.addTarget(self, action: #selector(datePickerBtnTap), for: .touchUpInside)
            expiryDateTF.addTarget(self, action: #selector(datePickerBtnTap), for: .touchUpInside)
           
            
    /*        let addVendorMastersBtn = UIButton()
            addVendorMastersBtn.frame = CGRect(x: 10, y: stockUnitTF.frame.origin.y+stockUnitTF.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 20)
            productView.addSubview(addVendorMastersBtn)
            
            addVendorMastersBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            
            addVendorMastersBtn.addTarget(self, action: #selector(onVendorMastersBtnTap), for: .touchUpInside)
            
            let attrs = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
                NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

            let attributedString = NSMutableAttributedString(string:"")
            
            let buttonTitleStr = NSMutableAttributedString(string:"Stock unit masterlist", attributes:attrs)
            attributedString.append(buttonTitleStr)
            addVendorMastersBtn.setAttributedTitle(attributedString, for: .normal)
            
            */

            //Price Lbl
            
            let purchaseDateLbl = UILabel()
            purchaseDateLbl.frame = CGRect(x: 10, y: stockQuantityTF.frame.origin.y+stockQuantityTF.frame.size.height+40, width: productView.frame.size.width/2 - (20), height: 20)
            purchaseDateLbl.text = "Purchase Date :"
            purchaseDateLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            purchaseDateLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(purchaseDateLbl)
            
            let purchaseDateTF = UIButton()
            purchaseDateTF.frame = CGRect(x:10, y: purchaseDateLbl.frame.origin.y+purchaseDateLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
            purchaseDateTF.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
            purchaseDateTF.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            let purchaseImage = UIButton()
            purchaseImage.frame = CGRect(x: purchaseDateTF.frame.size.width - (20), y: purchaseDateTF.frame.origin.y+6, width: 25, height: 25)
            purchaseImage.setImage(UIImage.init(named: "calenderlatest"), for: UIControl.State.normal)
            productView.addSubview(purchaseImage)
            productView.addSubview(purchaseDateTF)
            
            purchaseDateTF.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            purchaseDateTF.layer.borderWidth = 1
            purchaseDateTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            purchaseDateTF.layer.cornerRadius = 3
            purchaseDateTF.clipsToBounds = true
            
            purchaseDateTF.addTarget(self, action: #selector(datePickerBtnTap), for: .touchUpInside)
          
            //priceUnit Lbl
            
            let priceUnitBtn = UIButton()
            priceUnitBtn.frame = CGRect(x:10, y: purchaseDateTF.frame.origin.y+purchaseDateTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            priceUnitBtn.setTitle("Price Unit:", for: UIControl.State.normal)
            priceUnitBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            priceUnitBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            productView.addSubview(priceUnitBtn)
            
//            let priceUnitLbl = UILabel()
//            priceUnitLbl.frame = CGRect(x: 10, y: purchaseDateTF.frame.origin.y+purchaseDateTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
//            priceUnitLbl.text = "Price Unit :"
//            priceUnitLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
//            priceUnitLbl.textColor = hexStringToUIColor(hex: "232c51")
//            productView.addSubview(priceUnitLbl)
            
//            //Price Unit TF
//
//            priceUnitTF.frame = CGRect(x: 10, y: priceUnitLbl.frame.origin.y+priceUnitLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
//            priceUnitTF.text = "$"
//            priceUnitTF.font = UIFont.init(name: kAppFontMedium, size: 13)
//            priceUnitTF.textColor = hexStringToUIColor(hex: "232c51")
//            productView.addSubview(priceUnitTF)
//
//            priceUnitTF.layer.borderWidth = 1
//            priceUnitTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
//            priceUnitTF.layer.cornerRadius = 3
//            priceUnitTF.clipsToBounds = true

//            let priceUnitPaddingView = UIView()
//            priceUnitPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: priceUnitTF.frame.size.height)
//            priceUnitTF.leftView = priceUnitPaddingView
//            priceUnitTF.leftViewMode = UITextField.ViewMode.always
//
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
            
           
            
            //Total Price Lbl
            
            let totalPriceLbl = UILabel()
            totalPriceLbl.frame = CGRect(x: 10, y: priceUnitDropDown.frame.origin.y+priceUnitDropDown.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            totalPriceLbl.text = "Total Price :"
            totalPriceLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            totalPriceLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(totalPriceLbl)
            
            //Total Price TF

            totalPriceTF.frame = CGRect(x: 10, y: totalPriceLbl.frame.origin.y+totalPriceLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
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
            
            
            //offerPriceLbl Lbl
            
            let pricePerStockUnitLbl = UILabel()
            pricePerStockUnitLbl.frame = CGRect(x: productView.frame.size.width/2+10, y: expiryDateTF.frame.origin.y+expiryDateTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            pricePerStockUnitLbl.text = "Price Per Stock Unit :"
            pricePerStockUnitLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            pricePerStockUnitLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(pricePerStockUnitLbl)
            
            //offerPriceLbl TF

            pricePerStockUnitTF.frame = CGRect(x: productView.frame.size.width/2+10, y: pricePerStockUnitLbl.frame.origin.y+pricePerStockUnitLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
//            offerPriceTF.text = "Hydd"
            pricePerStockUnitTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            pricePerStockUnitTF.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(pricePerStockUnitTF)
            if productMainDict.value(forKey: "unitPriceWarn") as? Bool==true
            {
            let pricePerStockAlertButton = UIButton()
            pricePerStockAlertButton.frame = CGRect(x: productView.frame.size.width/2+pricePerStockUnitTF.frame.size.width - 30, y: pricePerStockUnitTF.frame.origin.y+5, width: 30, height: 30)
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
            
            
            
            //Storage Location Lbl
            let storageLocationBtn = UIButton()
            storageLocationBtn.frame = CGRect(x: 10, y: totalPriceTF.frame.origin.y+totalPriceTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            storageLocationBtn.setTitle("Storage Location", for: UIControl.State.normal)
            storageLocationBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            storageLocationBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            productView.addSubview(storageLocationBtn)
//            let storageLocationLbl = UILabel()
//            storageLocationLbl.frame = CGRect(x: 10, y: totalPriceTF.frame.origin.y+totalPriceTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
//            storageLocationLbl.text = "Storage Location :"
//            storageLocationLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
//            storageLocationLbl.textColor = hexStringToUIColor(hex: "232c51")
//            productView.addSubview(storageLocationLbl)
            
            //storageLocationTF TF

//            storageLocationTF.frame = CGRect(x: 10, y: storageLocationLbl.frame.origin.y+storageLocationLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
//            storageLocationTF.text = "NA"
//            storageLocationTF.font = UIFont.init(name: kAppFontMedium, size: 13)
//            storageLocationTF.textColor = hexStringToUIColor(hex: "232c51")
//            productView.addSubview(storageLocationTF)
//
//            storageLocationTF.layer.borderWidth = 1
//            storageLocationTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
//            storageLocationTF.layer.cornerRadius = 3
//            storageLocationTF.clipsToBounds = true
//
//            let storageLocationPaddingView = UIView()
//            storageLocationPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: storageLocationTF.frame.size.height)
//            storageLocationTF.leftView = storageLocationPaddingView
//            storageLocationTF.leftViewMode = UITextField.ViewMode.always
//
            storageLocationDropDown = UIButton()
            storageLocationDropDown.frame = CGRect(x: 10, y: storageLocationBtn.frame.origin.y+storageLocationBtn.frame.size.height+5, width: productView.frame.size.width/3 - (30), height: 40)
            storageLocationDropDown.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            storageLocationDropDown.layer.borderWidth = 1
            storageLocationDropDown.layer.cornerRadius = 3
            storageLocationDropDown.layer.masksToBounds = true
            let storageLocationImage = UIButton()
            storageLocationImage.frame = CGRect(x: storageLocationDropDown.frame.size.width - (20), y: storageLocationDropDown.frame.origin.y+6, width: 25, height: 25)
            storageLocationImage.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
            productView.addSubview(storageLocationImage)
            productView.addSubview(storageLocationDropDown)
            
            storageLocationDropDown.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            storageLocationDropDown.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            
            storageLocationDropDown.addTarget(self, action: #selector(storage_LocationBtnTap), for: .touchUpInside)
            storageLocationDropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
            let storageLocationMasterListBtn = UIButton()
            storageLocationMasterListBtn.frame = CGRect(x: 10, y: storageLocationDropDown.frame.origin.y+storageLocationDropDown.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 20)
                   productView.addSubview(storageLocationMasterListBtn)
                   
            storageLocationMasterListBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                   
            storageLocationMasterListBtn.addTarget(self, action: #selector(onstorageLocationMastersBtnTap), for: .touchUpInside)
                   
                   let storageAttrs = [
                       NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                       NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
                       NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

                   let storageAttributedString = NSMutableAttributedString(string:"")
                   
                   let storageButtonTitleStr = NSMutableAttributedString(string:"Storage location masterlist", attributes:storageAttrs)
            storageAttributedString.append(storageButtonTitleStr)
            storageLocationMasterListBtn.setAttributedTitle(storageAttributedString, for: .normal)
            
            
            //Storage Location1 Lbl
           
            storageLocation1DropDown = UIButton()
            storageLocation1DropDown.frame = CGRect(x: storageLocationDropDown.frame.size.width + 30, y: storageLocationBtn.frame.origin.y+storageLocationBtn.frame.size.height+5, width: productView.frame.size.width/3 - (30), height: 40)
            storageLocation1DropDown.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            storageLocation1DropDown.layer.borderWidth = 1
            storageLocation1DropDown.layer.cornerRadius = 3
            storageLocation1DropDown.layer.masksToBounds = true
            let storageLocation1Image = UIButton()
            storageLocation1Image.frame = CGRect(x: storageLocationDropDown.frame.size.width + storageLocation1DropDown.frame.size.width , y: storageLocation1DropDown.frame.origin.y+6, width: 25, height: 25)
            storageLocation1Image.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
            productView.addSubview(storageLocation1Image)
            productView.addSubview(storageLocation1DropDown)
            
            storageLocation1DropDown.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            storageLocation1DropDown.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            
            storageLocation1DropDown.addTarget(self, action: #selector(storage_Location1BtnTap), for: .touchUpInside)
            storageLocation1DropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
           
            //Storage Location2 Lbl
            
            storageLocation2DropDown = UIButton()
            storageLocation2DropDown.frame = CGRect(x: storageLocationDropDown.frame.size.width + storageLocation1DropDown.frame.size.width + 50, y: storageLocationBtn.frame.origin.y+storageLocationBtn.frame.size.height+5, width: productView.frame.size.width/3 - (30), height: 40)
            storageLocation2DropDown.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            storageLocation2DropDown.layer.borderWidth = 1
            storageLocation2DropDown.layer.cornerRadius = 3
            storageLocation2DropDown.layer.masksToBounds = true
            let storageLocation2Image = UIButton()
            storageLocation2Image.frame = CGRect(x: productView.frame.size.width - (70), y: storageLocation2DropDown.frame.origin.y+6, width: 25, height: 25)
            storageLocation2Image.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
            productView.addSubview(storageLocation2Image)
            productView.addSubview(storageLocation2DropDown)
            
            storageLocation2DropDown.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            storageLocation2DropDown.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            
            storageLocation2DropDown.addTarget(self, action: #selector(storage_Location2BtnTap), for: .touchUpInside)
            storageLocation2DropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
           
            //Price TF

      /*      priceTF.frame = CGRect(x: 10, y: priceLbl.frame.origin.y+priceLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
//            priceTF.text = "87797"
            priceTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            priceTF.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(priceTF)
            
            priceTF.layer.borderWidth = 1
            priceTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            priceTF.layer.cornerRadius = 3
            priceTF.clipsToBounds = true
            
            priceTF.addTarget(self, action: #selector(datePickerBtnTap), for: .touchUpInside)

            let pricePaddingView = UIView()
            pricePaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: priceTF.frame.size.height)
            priceTF.leftView = pricePaddingView
            priceTF.leftViewMode = UITextField.ViewMode.always
            
            */
            
            //offerPriceLbl Lbl
            
            let offerPriceLbl = UILabel()
            offerPriceLbl.frame = CGRect(x: productView.frame.size.width/2+10, y: pricePerStockUnitTF.frame.origin.y+pricePerStockUnitTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            offerPriceLbl.text = "Offered Price per unit :"
            offerPriceLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            offerPriceLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(offerPriceLbl)
            
            //offerPriceLbl TF

            offerPriceTF.frame = CGRect(x: productView.frame.size.width/2+10, y: offerPriceLbl.frame.origin.y+offerPriceLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
//            offerPriceTF.text = "Hydd"
            offerPriceTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            offerPriceTF.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(offerPriceTF)
            if productMainDict.value(forKey: "unitPriceWarn") as? Bool==true
            {
            let pricePerStockAlertButton = UIButton()
            pricePerStockAlertButton.frame = CGRect(x: productView.frame.size.width/2+offerPriceTF.frame.size.width - 30, y: offerPriceTF.frame.origin.y+5, width: 30, height: 30)
            pricePerStockAlertButton.setImage(UIImage(named: "warn.png"), for: .normal)
            pricePerStockAlertButton.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
            productView.addSubview(pricePerStockAlertButton)
            }
            offerPriceTF.layer.borderWidth = 1
            offerPriceTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            offerPriceTF.layer.cornerRadius = 3
            offerPriceTF.clipsToBounds = true

            let stockLocPaddingView = UIView()
            stockLocPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: offerPriceTF.frame.size.height)
            offerPriceTF.leftView = stockLocPaddingView
            offerPriceTF.leftViewMode = UITextField.ViewMode.always
            
           
            
            //Purchase Date Lbl
            
//            let purchaseDateLbl = UILabel()
//            purchaseDateLbl.frame = CGRect(x: 10, y: offerPriceTF.frame.origin.y+offerPriceTF.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
//            purchaseDateLbl.text = "Purchase Date :"
//            purchaseDateLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
//            purchaseDateLbl.textColor = hexStringToUIColor(hex: "232c51")
//            productView.addSubview(purchaseDateLbl)
//
//            //Purchase Date TF
//
//            let purchaseDateTF = UIButton()
//
//            purchaseDateTF.frame = CGRect(x:10, y: purchaseDateLbl.frame.origin.y+purchaseDateLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
//            purchaseDateTF.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
//            purchaseDateTF .setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
//            productView.addSubview(purchaseDateTF)
//
//            purchaseDateTF.layer.borderWidth = 1
//            purchaseDateTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
//            purchaseDateTF.layer.cornerRadius = 3
//            purchaseDateTF.clipsToBounds = true
//
//            purchaseDateTF.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
            //Category Check box
            
            let categoryCheckBtn = UIButton()
            categoryCheckBtn.frame = CGRect(x: 10, y: storageLocationMasterListBtn.frame.origin.y+storageLocationMasterListBtn.frame.size.height+12, width: 25, height: 25)
            categoryCheckBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
//            productView.addSubview(categoryCheckBtn)
            
            categoryCheckBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            
            //Category Lbl

            let categoryBtn = UIButton()
            categoryBtn.frame = CGRect(x:10, y: storageLocationMasterListBtn.frame.origin.y+storageLocationMasterListBtn.frame.size.height+15, width: 100, height: 20)
            categoryBtn.setTitle("Category", for: UIControl.State.normal)
            categoryBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            categoryBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            productView.addSubview(categoryBtn)
            
            //Sub Category Check box
            
            let subCategoryCheckBtn = UIButton()
            subCategoryCheckBtn.frame = CGRect(x: productView.frame.size.width / 2 + 10, y: storageLocationMasterListBtn.frame.origin.y+storageLocationMasterListBtn.frame.size.height+12, width: 25, height: 25)
            subCategoryCheckBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
//            productView.addSubview(subCategoryCheckBtn)
            
            subCategoryCheckBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            
            //sub Category Lbl

            let subCategoryBtn = UIButton()
            subCategoryBtn.frame = CGRect(x:productView.frame.size.width / 2 + 10, y: storageLocationMasterListBtn.frame.origin.y+storageLocationMasterListBtn.frame.size.height+15, width: 100, height: 20)
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
            
           
            

            //Vendor Name Lbl
            
            let vendorNameBtn = UIButton()
            vendorNameBtn.frame = CGRect(x: 10, y: categoryDropDown.frame.origin.y+categoryDropDown.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            vendorNameBtn.setTitle("Vendor Name :", for: UIControl.State.normal)
            vendorNameBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            vendorNameBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            productView.addSubview(vendorNameBtn)

            vendorNameDropDown = UIButton()
            vendorNameDropDown.frame = CGRect(x: 10, y: vendorNameBtn.frame.origin.y+vendorNameBtn.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
            vendorNameDropDown.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            vendorNameDropDown.layer.borderWidth = 1
            vendorNameDropDown.layer.cornerRadius = 3
            vendorNameDropDown.layer.masksToBounds = true
            let vendorNameImage = UIButton()
            vendorNameImage.frame = CGRect(x: vendorNameDropDown.frame.size.width - (20), y: vendorNameDropDown.frame.origin.y+6, width: 25, height: 25)
            vendorNameImage.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
            productView.addSubview(vendorNameImage)
            productView.addSubview(vendorNameDropDown)
            
            vendorNameDropDown.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            vendorNameDropDown.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            
            vendorNameDropDown.addTarget(self, action: #selector(vendor_NameBtnTap), for: .touchUpInside)
            vendorNameDropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
            
            let vendortMasterListBtn = UIButton()
            vendortMasterListBtn.frame = CGRect(x: 10, y: vendorNameDropDown.frame.origin.y+vendorNameDropDown.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 20)
            productView.addSubview(vendortMasterListBtn)
            
            vendortMasterListBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            
            vendortMasterListBtn.addTarget(self, action: #selector(onVendorListMastersBtnTap), for: .touchUpInside)
            
            let vendorAttrs = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
                NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

            let vendorAttributedString = NSMutableAttributedString(string:"")
            
            let vendorButtonTitleStr = NSMutableAttributedString(string:"Vendor masterlist", attributes:vendorAttrs)
            vendorAttributedString.append(vendorButtonTitleStr)
            vendortMasterListBtn.setAttributedTitle(vendorAttributedString, for: .normal)
            
            //Borrowed Check box
            
            let borrowedCheckBtn = UIButton()
            borrowedCheckBtn.frame = CGRect(x: 10, y: vendorNameDropDown.frame.origin.y+vendorNameDropDown.frame.size.height+45, width: 30, height: 30)
//                CGRect(x: 10, y: subCategoryDropDown.frame.origin.y+subCategoryDropDown.frame.size.height+12, width: 25, height: 25)
            borrowedCheckBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
            borrowedCheckBtn.addTarget(self, action: #selector(doorDeliveryBtnTap), for: .touchUpInside)
            productView.addSubview(borrowedCheckBtn)
            
            borrowedCheckBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            
            //Borrowed Date Lbl

            let borrowedTitleBtn = UIButton()
            borrowedTitleBtn.frame = CGRect(x:borrowedCheckBtn.frame.origin.x+borrowedCheckBtn.frame.size.width+5, y: vendorNameDropDown.frame.origin.y+vendorNameDropDown.frame.size.height+50, width: 250, height: 20)
            borrowedTitleBtn.setTitle("Door Delivery", for: UIControl.State.normal)
            borrowedTitleBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            borrowedTitleBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            productView.addSubview(borrowedTitleBtn)

            
            //Order ID  Lbl
            
            let orderIDLbl = UILabel()
            orderIDLbl.frame = CGRect(x: productView.frame.size.width/2 + 10, y: subCategoryDropDown.frame.origin.y+subCategoryDropDown.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            orderIDLbl.text = "Order Id :"
            orderIDLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            orderIDLbl.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(orderIDLbl)
            
            //orderIdTF TF
            orderIdTF.frame = CGRect(x: productView.frame.size.width/2 + 10, y: orderIDLbl.frame.origin.y+orderIDLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
//            stockQuantityTF.text = "fdfdsfdsfd"
            orderIdTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            orderIdTF.textColor = hexStringToUIColor(hex: "232c51")
            productView.addSubview(orderIdTF)
            
            orderIdTF.layer.borderWidth = 1
            orderIdTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            orderIdTF.layer.cornerRadius = 3
            orderIdTF.clipsToBounds = true

            let orderIdPaddingView = UIView()
            orderIdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: orderIdTF.frame.size.height)
            orderIdTF.leftView = orderIdPaddingView
            orderIdTF.leftViewMode = UITextField.ViewMode.always
            
            //Preferred Vendor Lbl
            
            let preferredVendorLbl = UILabel()
            preferredVendorLbl.frame = CGRect(x: 10, y: subCategoryDropDown.frame.origin.y+subCategoryDropDown.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            preferredVendorLbl.text = "Preferred Vendor :"
            preferredVendorLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            preferredVendorLbl.textColor = hexStringToUIColor(hex: "232c51")
//            productView.addSubview(preferredVendorLbl)
            
            //Preferred Vendor
            
            let preferredVendorBtn = UIButton()

            preferredVendorBtn.frame = CGRect(x:10, y: preferredVendorLbl.frame.origin.y+preferredVendorLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
            preferredVendorBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
            preferredVendorBtn .setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
//            productView.addSubview(preferredVendorBtn)
            
            preferredVendorBtn.layer.borderWidth = 1
            preferredVendorBtn.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            preferredVendorBtn.layer.cornerRadius = 3
            preferredVendorBtn.clipsToBounds = true
            
            preferredVendorBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
            preferredVendorBtn.setImage(UIImage(named: "dropDownArrow"), for: .normal)
            
//            preferredVendorBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: (preferredVendorBtn.imageView?.frame.size.width)!)
            
            preferredVendorBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: preferredVendorBtn.frame.size.width-16, bottom: 10, right: 5)

//            preferredVendorBtn.addTarget(self, action: #selector(onPreferredVendorBtnTapped), for: .touchUpInside)

            //Price Lbl
            
            let orderIdLbl = UILabel()
            orderIdLbl.frame = CGRect(x: productView.frame.size.width/2+10, y: subCategoryDropDown.frame.origin.y+subCategoryDropDown.frame.size.height+15, width: productView.frame.size.width/2 - (20), height: 20)
            orderIdLbl.text = "Order Id :"
            orderIdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
            orderIdLbl.textColor = hexStringToUIColor(hex: "232c51")
//            productView.addSubview(orderIdLbl)
            
            //Order ID TF

          let orderIDTF = UITextField()
            orderIDTF.frame = CGRect(x: productView.frame.size.width/2+10, y: orderIdLbl.frame.origin.y+orderIdLbl.frame.size.height+5, width: productView.frame.size.width/2 - (20), height: 40)
//            priceTF.text = "87797"
            orderIDTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            orderIDTF.textColor = hexStringToUIColor(hex: "232c51")
//            productView.addSubview(orderIDTF)
            
            orderIDTF.layer.borderWidth = 1
            orderIDTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            orderIDTF.layer.cornerRadius = 3
            orderIDTF.clipsToBounds = true

            orderIDTF.delegate = self
            
            let orderPaddingView = UIView()
            orderPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: orderIDTF.frame.size.height)
            orderIDTF.leftView = orderPaddingView
            orderIDTF.leftViewMode = UITextField.ViewMode.always

            stockUnitBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            categoryBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            subCategoryBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            priceUnitBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            vendorNameBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            storageLocationBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            borrowedTitleBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            categoryDropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            stockUnitDropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            subCategoryDropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            priceUnitDropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            vendorNameDropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            storageLocationDropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            storageLocation1DropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            storageLocation2DropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            preferredVendorBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            
            if(isEditVendorProduct == true){
            //Add Product

            let addProductBtn1 = UIButton()
            addProductBtn1.frame = CGRect(x:productView.frame.size.width/2-(60), y: borrowedTitleBtn.frame.origin.y+borrowedTitleBtn.frame.size.height+(60), width: 120, height: 40)
            addProductBtn1.setTitle("SUBMIT", for: UIControl.State.normal)
            addProductBtn1.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
           addProductBtn1.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
            addProductBtn1.backgroundColor = hexStringToUIColor(hex: "105fef")
            addProductBtn1.layer.cornerRadius = 5
            addProductBtn1.layer.masksToBounds = true
            productView.addSubview(addProductBtn1)
            
            addProductBtn1.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
                
                productView.frame = CGRect(x: 15, y: yValue, width: productScrollView.frame.size.width - 30, height: addProductBtn1.frame.origin.y+addProductBtn1.frame.size.height+15)
                addProductBtn1.addTarget(self, action: #selector(saveBtnTap), for: .touchUpInside)
            
            }
            else
            {
                let addProductBtn1 = UIButton()
                addProductBtn1.frame = CGRect(x:productView.frame.size.width/2-(60), y: borrowedTitleBtn.frame.origin.y+borrowedTitleBtn.frame.size.height+(60), width: 120, height: 40)
//                addProductBtn1.setTitle("SUBMIT", for: UIControl.State.normal)
//                addProductBtn1.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
//               addProductBtn1.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
//                addProductBtn1.backgroundColor = hexStringToUIColor(hex: "105fef")
                addProductBtn1.layer.cornerRadius = 5
                addProductBtn1.layer.masksToBounds = true
                productView.addSubview(addProductBtn1)
                
                addProductBtn1.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
                
                productView.frame = CGRect(x: 15, y: yValue, width: productScrollView.frame.size.width - 30, height: addProductBtn1.frame.origin.y+addProductBtn1.frame.size.height+15)
                addProductBtn1.addTarget(self, action: #selector(saveBtnTap), for: .touchUpInside)
            }
           
            
            yValue = productView.frame.size.height + yValue + 10
            
            purchaseDateTF.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            expiryDateTF.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                
            productIDTF.delegate = self
            productNameTF.delegate = self
            descriptionTF.delegate = self
            stockQuantityTF.delegate = self
            //stockUnitTF.delegate = self
            priceTF.delegate = self
            offerPriceTF.delegate = self
            keywordsTF.delegate = self
           
            //priceUnitTF.delegate = self
            pricePerStockUnitTF.delegate = self
            totalPriceTF.delegate = self
            //storageLocationTF.delegate = self
            //vendorNameTF.delegate = self
            orderIdTF.delegate = self
            

            let tagValue:Int = i-1
            let StringTagValue = String(tagValue)
            
            let idTag : String = "1000" + StringTagValue
            let idTagValue: Int? = Int(idTag)
            
            let prodNameTag : String = "1001" + StringTagValue
            let prodNameTagValue: Int? = Int(prodNameTag)

            let descriptionTag : String = "1002" + StringTagValue
            let descriptionTagValue: Int? = Int(descriptionTag)

            let stockQuanTag : String = "1003" + StringTagValue
            let stockQuanTagValue: Int? = Int(stockQuanTag)
            
            let pricePerStockUnitTag : String = "2001" + StringTagValue
            let pricePerStockUnitTagValue: Int? = Int(pricePerStockUnitTag)

            let stockUnitTag : String = "1004" + StringTagValue
            let stockUnitTagValue: Int? = Int(stockUnitTag)

            let priceTag : String = "1005" + StringTagValue
            let priceTagValue: Int? = Int(priceTag)
            
            let storageTag : String = "1006" + StringTagValue
            let storageTagValue: Int? = Int(storageTag)
            
            let purchaseTag : String = "1007" + StringTagValue
            let purchaseTagValue: Int? = Int(purchaseTag)
            
            let expiryTag : String = "1008" + StringTagValue
            let expiryTagValue: Int? = Int(expiryTag)
            
            let catTag : String = "3000" + StringTagValue
            let catTagValue : Int? = Int(catTag)

            let subCatTag : String = "3001" + StringTagValue
            let subCatTagValue : Int? = Int(subCatTag)
            
            let vendorTag : String = "3002" + StringTagValue
            let vendorTagValue : Int? = Int(vendorTag)

            let orderIDTag : String = "3003" + StringTagValue
            let orderIDTagValue : Int? = Int(orderIDTag)
            
            let keywordTag : String = "3004" + StringTagValue
            let keywordTagValue : Int? = Int(keywordTag)
            
            let doorDeliveryTag : String = "4001" + StringTagValue
            let doorDeliveryTagValue : Int? = Int(doorDeliveryTag)
            
            orderIdTF.delegate = self
            
            let priceUnitTag : String = "3005" + StringTagValue
            let priceUnitTagValue : Int? = Int(priceUnitTag)
            
            let totalPriceTag : String = "3006" + StringTagValue
            let totalPriceTagValue : Int? = Int(totalPriceTag)
            
            let storageLocationTag : String = "3007" + StringTagValue
            let storageLocationTagValue : Int? = Int(storageLocationTag)
            
            let vendorNameTag : String = "3008" + StringTagValue
            let vendorNameTagValue : Int? = Int(vendorNameTag)
            
            let orderIdTag : String = "3009" + StringTagValue
            let orderIdTagValue : Int? = Int(orderIdTag)
            
            let storageLocation1Tag : String = "3010" + StringTagValue
            let storageLocation1TagValue : Int? = Int(storageLocation1Tag)
            
            let storageLocation2Tag : String = "3011" + StringTagValue
            let storageLocation2TagValue : Int? = Int(storageLocation2Tag)
            
           
            
       /*     [{"accountId":"61780acf0679a76022739c25","actualPrice":3481.0,"actualUnitPrice":59.0,"category":"NA","description":"","doorDelivery":true,"expiryDate":"29/10/2021","keyWords":"","offeredPrice":5723.0,"offeredUnitPrice":97.0,"orderId":"xvxv","priceUnit":"616fd3e25041085a07d69b18","productId":"hddggd","productImages":[{"productImage":" "},{"productImage":" "},{"productImage":" "},{"productImage":" "},{"productImage":" "},{"productImage":" "},{"productImage":" "},{"productImage":" "}],"productName":"test prod","purchaseDate":"29/10/2021","stockQuantity":59.0,"stockUnit":"61780acf0679a76022739c26","storageLocation":"61780acf0679a76022739c27","subCategory":"NA","vendor":"61780d8e36c8ad623c0d0733","vendorProductImages":[]}]
            
            */

            
            
            let productID = productMainDict.value(forKey: "productUniqueNumber") as? NSString ?? ""
            let productName = productMainDict.value(forKey: "productName") as? NSString ?? ""
            let prodDesc = productMainDict.value(forKey: "description") as? NSString ?? ""
            let keywords = productMainDict.value(forKey: "keyWords") as? NSString ?? ""
            var stockUnit=String()
            var stockUnitId=String()

            if productMainDict.value(forKey: "stockUnit") as! String==""
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
            if productMainDict.value(forKey: "purchaseDate") as! String==""
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
            let expiryDate = productMainDict.value(forKey: "expiryDate") as? NSString ?? ""
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
            
            
            var stockQunatity = productMainDict.value(forKey: "stockQuantity") as? NSString ?? ""
            var price =  productMainDict.value(forKey: "actualPrice") as? NSString ?? ""
            let totalprice =  productMainDict.value(forKey: "price") as? NSString ?? ""
            let pricePerStockUnit =  productMainDict.value(forKey: "unitPrice") as? NSString ?? ""
            
            let offeredPrice =  productMainDict.value(forKey: "offeredPrice") as? NSString ?? ""
            doorDeliveryVal = productMainDict.value(forKey: "doorDelivery") as? Bool ?? false
            let doorDelValuee = productMainDict.value(forKey: "doorDelivery") as? Bool ?? false
            var storageLocationStr=String()
            var storageLocationIdStr=String()
            var storageLocationStr2=String()
            var storageLocation2IdStr=String()
            var storageLocationStr1=String()
            var storageLocation1IdStr=String()
            if productMainDict.value(forKey: "storageLocation") as? String==""
            {
                
                if storageLocationArr.count>0
                {
                    let dictt1=storageLocationArr[0] as? NSDictionary
                    storageLocationStr=dictt1?.value(forKey: "slocName")as? String ?? ""
                    storageLocationIdStr = dictt1?.value(forKey: "_id")as? String ?? ""
                }
                productMainDict.setValue(storageLocationStr, forKey: "storageLocation")
                productMainDict.setValue(storageLocationIdStr, forKey: "storageLocationId")
                productMainDict.setValue(0, forKey: "storageLocationIndex")
                storageLocationStr1=""
                storageLocation1IdStr = ""
                if storageLocationArr1.count>0
                {
                    let dictt2=storageLocationArr1[0] as? NSDictionary
                    storageLocationStr1=dictt2?.value(forKey: "slocName")as? String ?? ""
                    storageLocation1IdStr = dictt2?.value(forKey: "_id")as? String ?? ""
                }
                productMainDict.setValue(storageLocationStr1, forKey: "storageLocation1")
                productMainDict.setValue(storageLocation1IdStr, forKey: "storageLocation1Id")
                storageLocationStr2=""
                storageLocation2IdStr = ""
                if storageLocationArr2.count>0
                {
                    let dictt3=storageLocationArr2[0] as? NSDictionary
                    storageLocationStr2=dictt3?.value(forKey: "slocName")as? String ?? ""
                    storageLocation2IdStr = dictt3?.value(forKey: "_id")as? String ?? ""
                }
                productMainDict.setValue(storageLocationStr2, forKey: "storageLocation2")
                productMainDict.setValue(storageLocation2IdStr, forKey: "storageLocation2Id")
            }
            else
            {
                if storageLocationArr.count>0
                {
                    let dictt1=storageLocationArr[0] as? NSDictionary
                    if dictt1?.value(forKey: "slocName")as? String==productMainDict.value(forKey: "storageLocation") as? String
                    {
                        storageLocationStr = (productMainDict.value(forKey: "storageLocation") as? NSString ?? "") as String
                    }
                    else
                    {
                    if productMainDict.value(forKey: "storageLocationIndex")as? Int==0
                    {
                    
                        let dictt1=storageLocationArr[0] as? NSDictionary
                        storageLocationStr=dictt1?.value(forKey: "slocName")as? String ?? ""
                        storageLocationIdStr = dictt1?.value(forKey: "_id")as? String ?? ""
                        productMainDict.setValue(storageLocationStr, forKey: "storageLocation")
                        productMainDict.setValue(storageLocationIdStr, forKey: "storageLocationId")
                        productMainDict.setValue(0, forKey: "storageLocationIndex")
                        if storageLocationArr1.count>0
                        {
                            let dictt2=storageLocationArr1[0] as? NSDictionary
                            storageLocationStr1=dictt2?.value(forKey: "slocName")as? String ?? ""
                            storageLocation1IdStr = dictt2?.value(forKey: "_id")as? String ?? ""
                        }
                        productMainDict.setValue(storageLocationStr1, forKey: "storageLocation1")
                        productMainDict.setValue(storageLocation1IdStr, forKey: "storageLocation1Id")
                        if storageLocationArr2.count>0
                        {
                            let dictt3=storageLocationArr2[0] as? NSDictionary
                            storageLocationStr2=dictt3?.value(forKey: "slocName")as? String ?? ""
                            storageLocation2IdStr = dictt3?.value(forKey: "_id")as? String ?? ""
                        }
                        productMainDict.setValue(storageLocationStr2, forKey: "storageLocation2")
                        productMainDict.setValue(storageLocation2IdStr, forKey: "storageLocation2Id")
                    }
                    
                    else
                    {
                        storageLocationStr = (productMainDict.value(forKey: "storageLocation") as? NSString ?? "") as String
                    }
                    }
                }
                else
                {
                    storageLocationStr = (productMainDict.value(forKey: "storageLocation") as? NSString ?? "") as String
                }
                
            }
            
            if productMainDict.value(forKey: "storageLocation1") as? String==""
            {
                
//                    if storageLocationArr1.count>0
//                    {
//                        let dictt2=storageLocationArr1[0] as? NSDictionary
//                        storageLocationStr1=dictt2?.value(forKey: "slocName")as? String ?? ""
//                        storageLocation1IdStr = dictt2?.value(forKey: "_id")as? String ?? ""
//                    }
//                    productMainDict.setValue(storageLocationStr1, forKey: "storageLocation1")
//                    productMainDict.setValue(storageLocation1IdStr, forKey: "storageLocation1Id")
                storageLocationStr1 = (productMainDict.value(forKey: "storageLocation1") as? NSString ?? "") as String
            }
            else
            {
                storageLocationStr1 = (productMainDict.value(forKey: "storageLocation1") as? NSString ?? "") as String
            }
           
            if productMainDict.value(forKey: "storageLocation2") as? String==""
            {
                
//                    if storageLocationArr2.count>0
//                    {
//                        let dictt3=storageLocationArr2[0] as? NSDictionary
//                        storageLocationStr2=dictt3?.value(forKey: "slocName")as? String ?? ""
//                        storageLocation2IdStr = dictt3?.value(forKey: "_id")as? String ?? ""
//                    }
//                    productMainDict.setValue(storageLocationStr2, forKey: "storageLocation2")
//                    productMainDict.setValue(storageLocation2IdStr, forKey: "storageLocation2Id")
                storageLocationStr2 = (productMainDict.value(forKey: "storageLocation2") as? NSString ?? "") as String
            }
            else
            {
                storageLocationStr2 = (productMainDict.value(forKey: "storageLocation2") as? NSString ?? "") as String
            }
            var vendorStr=String()
            var vendorStrID=String()
            
            if productMainDict.value(forKey: "vendorName") as? String==""
            {
                if vendorListResult.count>0
                {
                    vendorStr=vendorListResult[0].vendorName ?? ""
                    vendorStrID=vendorListResult[0]._id ?? ""
                    self.vendorDetails=NSMutableArray()
                    let vendorDict=[
                        "accountEmailId": vendorListResult[0].accountEmailId,
                        "accountId": vendorListResult[0].accountId,
                        "canEdit": vendorListResult[0].canEdit,
                        "category": vendorListResult[0].category,
                        "dateOfCreation": vendorListResult[0].dateOfCreation,
                        "_id": vendorListResult[0]._id,
                        "status": vendorListResult[0].status,
                        "subCategory": vendorListResult[0].subCategory,
                        "vendorCompany": vendorListResult[0].vendorCompany,
                        "vendorDescription": vendorListResult[0].vendorDescription,
                        "vendorName": vendorListResult[0].vendorName] as [String : Any]
                    self.vendorDetails.add(vendorDict)
                }
                productMainDict.setValue(vendorStr, forKey: "vendorName")
                productMainDict.setValue(vendorStrID, forKey: "vendorId")
            }
            else
            {
                vendorStr = (productMainDict.value(forKey: "vendorName") as? NSString ?? "") as String
            }
            let orderIdStr = productMainDict.value(forKey: "orderId") as? NSString ?? ""
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
            let offeredUnitPriceStr = productMainDict.value(forKey: "offeredUnitPrice") as? NSString ?? ""
            
            
            if(doorDelValuee == true){
                borrowedCheckBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
                
            }else{
                borrowedCheckBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)

            }
            
//            if(isEditVendorProduct == true){
//
//                let stockQunatity1 = productMainDict.value(forKey: "stockQuantity")
//                stockQunatity = stockQunatity1 as? String as! NSString
//
//                let price1 = productMainDict.value(forKey: "offredPrice")
//                price = (price1 as? String! as NSString) as String as NSString
//
////                let offeredPrice1 = productMainDict.value(forKey: "offeredPrice") as? NSString ?? ""
////                offeredPrice = offeredPrice1 as? String as! NSString
//
//            }

            let preferredVendorStr =  productMainDict.value(forKey: "vendor") as? NSString ?? ""
            
            let orderIDStr =  productMainDict.value(forKey: "orderId") as? NSString ?? ""

           // priceUnitTF.text = priceUnitStr as String
            pricePerStockUnitTF.text = pricePerStockUnit as String
            totalPriceTF.text = totalprice as String
            //storageLocationTF.text = storageLocationStr as String
            //vendorNameTF.text = vendorStr as String
            orderIdTF.text = orderIdStr as String
            
            productIDTF.text = productID as String
            productNameTF.text = productName as String
            descriptionTF.text = prodDesc as String
            keywordsTF.text = keywords as String
            stockQuantityTF.text = stockQunatity as String
            //stockUnitTF.text = stockUnit as String
            priceTF.text = price as String
            offerPriceTF.text = offeredUnitPriceStr as String
            purchaseDateTF.setTitle(purchaseDate as String, for: UIControl.State.normal)
            expiryDateTF.setTitle(expiryDate as String, for: UIControl.State.normal)
            categoryDropDown.setTitle(category as String, for: UIControl.State.normal)
            subCategoryDropDown.setTitle(subCategory as String, for: UIControl.State.normal)
            
            stockUnitDropDown.setTitle(stockUnit as String, for: UIControl.State.normal)
            priceUnitDropDown.setTitle(priceUnit as String, for: UIControl.State.normal)
            storageLocationDropDown.setTitle(storageLocationStr as String, for: UIControl.State.normal)
            storageLocation1DropDown.setTitle(storageLocationStr1 as String, for: UIControl.State.normal)
            storageLocation2DropDown.setTitle(storageLocationStr2 as String, for: UIControl.State.normal)
            vendorNameDropDown.setTitle(vendorStr as String, for: UIControl.State.normal)
            preferredVendorBtn.setTitle(preferredVendorStr as String, for: UIControl.State.normal)
            orderIDTF.text = orderIDStr as String

            preferredVendorBtn.contentMode = UIControl.ContentMode.left
            
            priceUnitDropDown.tag = priceUnitTagValue!
            pricePerStockUnitTF.tag = pricePerStockUnitTagValue!
            totalPriceTF.tag = totalPriceTagValue!
            storageLocationDropDown.tag = storageLocationTagValue!
            storageLocation1DropDown.tag = storageLocation1TagValue!
            storageLocation2DropDown.tag = storageLocation2TagValue!
            
            vendorNameDropDown.tag = vendorNameTagValue!
            orderIdTF.tag = orderIdTagValue!
            
            productIDTF.tag   = idTagValue!
            productNameTF.tag = prodNameTagValue!
            descriptionTF.tag = descriptionTagValue!
            stockQuantityTF.tag = stockQuanTagValue!
            pricePerStockUnitTF.tag = pricePerStockUnitTagValue!
            stockUnitDropDown.tag = stockUnitTagValue!
            priceTF.tag = priceTagValue!
            offerPriceTF.tag = storageTagValue!
            
            purchaseDateTF.tag = purchaseTagValue!
            expiryDateTF.tag = expiryTagValue!
            
            categoryDropDown.tag = catTagValue!
            subCategoryDropDown.tag = subCatTagValue!
            
            preferredVendorBtn.tag = vendorTagValue!
            orderIDTF.tag = orderIDTagValue!
            keywordsTF.tag = keywordTagValue!
            borrowedCheckBtn.tag = doorDeliveryTagValue!

        }
        
        if(isEditVendorProduct == true){
            productScrollView.contentSize = CGSize(width: productScrollView.frame.size.width, height: yValue+200)
        }
        else
        {
        //Add Product

        let addProductBtn = UIButton()
        addProductBtn.frame = CGRect(x:10, y: yValue, width: 120, height: 40)
        addProductBtn.setTitle("Add Product", for: UIControl.State.normal)
        addProductBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        addProductBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        addProductBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
        addProductBtn.layer.cornerRadius = 5
        addProductBtn.layer.masksToBounds = true
        productScrollView.addSubview(addProductBtn)
        
        addProductBtn.addTarget(self, action: #selector(addProductBtnTap), for: .touchUpInside)
        addProductBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
            productScrollView.contentSize = CGSize(width: productScrollView.frame.size.width, height: yValue+400)
        }
        
        
        productScrollView.contentOffset = CGPoint(x: 0, y: scrollViewYPos)

        animatingView()
        
//        productScrollView.contentSize = CGSize(width: productScrollView.frame.size.width, height: yValue+200)
//        productScrollView.contentOffset = CGPoint(x: 0, y: scrollViewYPos)
        
    }
    @objc func onClickWarnButton()
    {
        self.showAlertWith(title: "Alert", message: "Required")
    }
    @objc func addProductBtnTap(sender: UIButton!){
        
        if(myProductArray.count > 19){
            
            self.showAlertWith(title: "Alert !!", message: "Cannot add more than 20 products at a time")
            return
        }
        self.addAnEmptyProduct()
        self.loadAddProductUI()
        
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
                            self.storageLocationArr1.removeAllObjects()
                            self.storageLocationArr2.removeAllObjects()
                            if self.storageLocationArr.count>0
                            {
                                let aaaa=self.storageLocationArr[0] as! NSDictionary
                            self.hierachyLevel = "2"
                             self.parentLocation = aaaa.value(forKey: "slocName")as? String ?? ""
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
                                    self.parentLocation = aaaa.value(forKey: "slocName")as? String ?? ""
                                }
                                
                                if self.buttonTap=="tap"
                                {
                                    var dict = NSMutableDictionary()
                                    let productArrayPosition : Int = self.buttonPosition
                                var storageLocArr = [String]()
                                    dict = self.myProductArray[productArrayPosition] as! NSMutableDictionary
                                    if self.storageLocationArr1.count>0
                                    {
                                        let aaaa=self.storageLocationArr1[0] as! NSDictionary
                                    dict.setValue(aaaa.value(forKey: "slocName")as? String ?? "", forKey: "storageLocation1")
                                dict.setValue(aaaa.value(forKey: "_id")as? String ?? "", forKey: "storageLocation1Id")
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
                                var dict = NSMutableDictionary()
                                let productArrayPosition : Int = self.buttonPosition
                            var storageLocArr = [String]()
                                dict = self.myProductArray[productArrayPosition] as! NSMutableDictionary
                              
                                    let aaaa=self.storageLocationArr2[0] as! NSDictionary
                            dict.setValue(aaaa.value(forKey: "slocName")as? String ?? "", forKey: "storageLocation2")
                            dict.setValue(aaaa.value(forKey: "_id")as? String ?? "", forKey: "storageLocation2Id")
                                }
                                if self.buttonTap=="tap"
                                {
                                    var dict = NSMutableDictionary()
                                    let productArrayPosition : Int = self.buttonPosition
                                var storageLocArr = [String]()
                                    dict = self.myProductArray[productArrayPosition] as! NSMutableDictionary
                                    if self.storageLocationArr2.count>0
                                    {
                                        let aaaa=self.storageLocationArr2[0] as! NSDictionary
                                dict.setValue(aaaa.value(forKey: "slocName")as? String ?? "", forKey: "storageLocation2")
                                dict.setValue(aaaa.value(forKey: "_id")as? String ?? "", forKey: "storageLocation2Id")
                                    }
                                    self.buttonTap=""
                                }
                            }
                           
                            
                            self.loadAddProductUI()
                              
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
                            self.loadAddProductUI()
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
                
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        print(accountID)
                       
        let URLString_loginIndividual = Constants.BaseUrl + VendorMasterListUrl + accountID as String
                                    
        servcCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

            let respVo:VendorListRespo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.statusCode
            let message = respVo.status
            
            if status == 200 {
                if message == "SUCCESS" {
                    if respVo.result != nil {
                    if respVo.result!.count > 0 {
                        
                        self.vendorListResult = respVo.result!
                        self.vendorDetails=NSMutableArray()
                        let vendorDict=[
                            "accountEmailId": self.vendorListResult[0].accountEmailId,
                            "accountId": self.vendorListResult[0].accountId,
                            "canEdit": self.vendorListResult[0].canEdit,
                            "category": self.vendorListResult[0].category,
                            "dateOfCreation": self.vendorListResult[0].dateOfCreation,
                            "_id": self.vendorListResult[0]._id,
                            "status": self.vendorListResult[0].status,
                            "subCategory": self.vendorListResult[0].subCategory,
                            "vendorCompany": self.vendorListResult[0].vendorCompany,
                            "vendorDescription": self.vendorListResult[0].vendorDescription,
                            "vendorName": self.vendorListResult[0].vendorName] as [String : Any]
                        self.vendorDetails.add(vendorDict)
                    }
                    else {
                        
                    }
                }
                }
            }
            else {
                self.view.makeToast(message)
            }
                               
        }) { (error) in
                                    
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
                                
        }
    
    }
    
    @IBAction func doorDeliveryBtnTap(_ sender: UIButton) {
        
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

        
        if (sender.currentImage!.isEqual(UIImage(named: "checkBoxInactive"))) {
            sender.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
            dict.setValue(true, forKey: "doorDelivery")

        }else{
            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
            dict.setValue(false, forKey: "doorDelivery")

        }
        
        myProductArray.replaceObject(at: productArrayPosition, with: dict)
        
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
    
    @objc func onVendorListMastersBtnTap(sender: UIButton){
        
//                    let storyBoard = UIStoryboard(name: "Vendor", bundle: nil)
//                    let VC = storyBoard.instantiateViewController(withIdentifier: "VendorMastersVC") as! VendorMastersVC
//                    VC.modalPresentationStyle = .fullScreen
////                    VC.isAddProd = "1"
//                    self.navigationController?.pushViewController(VC, animated: true)
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
    
    @objc func onstorageLocationMastersBtnTap(sender: UIButton){
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
       var  productImgict = NSMutableDictionary()
       
       productImgArray = dict.value(forKey: "productImages") as! NSMutableArray
       
       productImgict = productImgArray[prodImgJPos] as! NSMutableDictionary
       productImgict.setValue(imageStr, forKey: "productImage")
       productImgict.setValue(imagePick as! UIImage, forKey: "productDisplayImage")
        productImgict.setValue("1", forKey: "isLocalImg")

//        if(ised == "ShoppingEdit"){
            productImgict.setValue("", forKey: "productServerImage")

//        }
       
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveBtnTap(_ sender: Any) {
        

            updateProductAPI()
            
       
    }
    // MARK: Get AddressBook API Call
    func get_PriceUnit_API_Call() {
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let urlStr = Constants.BaseUrl + priceUnitUrl
        
        servcCntrl.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:PriceUnitRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            DispatchQueue.main.async {
                
                let status = respVo.statusCode
                let message = respVo.status
                
                if status == 200 {
                    
                    if message == "SUCCESS" {
                        if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            self.priceUnitsArr = respVo.result!

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
    var priceUnitNamesArr = [String]()
    var priceUnitIdsArr = [String]()
    var priceUnitsArr = [PriceUnitResultVo]()
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
        priceUnitIdsArr = [String]()
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
                self?.stockUnitDropDown.setTitle(item as String, for: UIControl.State.normal)
                self?.selectedStockId = (self?.stockUnitIdsArr[index])!
               // self?.stockUnitTF.text = item
                dict.setValue(item, forKey: "stockUnit")
                dict.setValue(self?.selectedStockId, forKey: "stockUnitId")
                dict.setValue(index, forKey: "stockUnitIndex")
                self?.loadAddProductUI()
            }
    }
    var hierachyLevel=String()
    @IBAction func storage_LocationBtnTap(_ sender: UIButton) {
        buttonTap="tap"
        
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
        buttonPosition=productArrayPosition
        var storageLocArr = [String]()
       storageLocationIdsArr=[String]()
        storageLocationParentArr=[String]()
        var dict = NSMutableDictionary()
        dict = myProductArray[productArrayPosition] as! NSMutableDictionary
        
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
                self?.storageLocationDropDown.setTitle(item as String, for: UIControl.State.normal)
                self?.selectedStorageId = (self?.storageLocationIdsArr[index])!
//                self?.selectedStorageParentId = (self?.storageLocationParentArr[index])!
//                self?.storageLocationTF.text = item
                dict.setValue(item, forKey: "storageLocation")
                dict.setValue(self?.selectedStorageId, forKey: "storageLocationId")
                dict.setValue(index, forKey: "storageLocationIndex")
                dict.setValue("", forKey: "storageLocation1")
                dict.setValue("", forKey: "storageLocation1Id")
                dict.setValue("", forKey: "storageLocation2")
                dict.setValue("", forKey: "storageLocation2Id")
                self?.hierachyLevel="2"
                self?.parentLocation=item
                self?.storageLocationArr1.removeAllObjects()
                self?.storageLocationArr2.removeAllObjects()
                self?.get_StorageLocationByParentLocation_API_Call()
                self?.loadAddProductUI()
            }
    }
    @IBAction func storage_Location1BtnTap(_ sender: UIButton) {
        
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
        var storageLocArr = [String]()
        var storageLocation1IdsArr = [String]()
        var storageLocation1ParentArr = [String]()
        var dict = NSMutableDictionary()
        dict = myProductArray[productArrayPosition] as! NSMutableDictionary
        
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
                self?.storageLocation1DropDown.setTitle(item as String, for: UIControl.State.normal)
                self?.selectedStorage1Id = (self?.storageLocationIdsArr[index]) ?? ""
//                self?.selectedStorage1ParentId = (self?.storageLocation1ParentArr[index])!
//                self?.storageLocationTF.text = item
                dict.setValue(item, forKey: "storageLocation1")
                dict.setValue(self?.selectedStorage1Id, forKey: "storageLocation1Id")
                dict.setValue("", forKey: "storageLocation2")
                dict.setValue("", forKey: "storageLocation2Id")
                self?.hierachyLevel="3"
                self?.parentLocation=self?.selectedStorage1ParentId ?? ""
                self?.get_StorageLocationByParentLocation_API_Call()
                self?.loadAddProductUI()
            }
    }
    @IBAction func storage_Location2BtnTap(_ sender: UIButton) {
        
        var productArrayPosition = Int()
        var productTagValue=Int()
        let sstag:String = String(sender.tag)
        if sstag.count>5
        {
         productArrayPosition = sender.tag%100
         productTagValue = sender.tag / 100
         
        }
        else
        {
         productArrayPosition = sender.tag%10
         productTagValue = sender.tag / 10
            
        }
        var storageLocArr = [String]()
        var storageLocation2IdsArr = [String]()
        var storageLocation2ParentArr = [String]()
        var dict = NSMutableDictionary()
        dict = myProductArray[productArrayPosition] as! NSMutableDictionary
        
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
                self?.storageLocation2DropDown.setTitle(item as String, for: UIControl.State.normal)
                self?.selectedStorage2Id = (self?.storageLocationIdsArr[index])!
//                self?.selectedStorage2ParentId = (self?.storageLocation2ParentArr[index])!
//                self?.storageLocationTF.text = item
                dict.setValue(item, forKey: "storageLocation2")
                dict.setValue(self?.selectedStorage2Id, forKey: "storageLocation2Id")
                self?.loadAddProductUI()
            }
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
        vendorMastersIdsArr=[String]()
        var dict = NSMutableDictionary()
        dict = myProductArray[productArrayPosition] as! NSMutableDictionary
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
                self?.vendorDetails=NSMutableArray()
                let vendorDict=[
                    "accountEmailId": self?.vendorListResult[index].accountEmailId,
                    "accountId": self?.vendorListResult[index].accountId,
                    "canEdit": self?.vendorListResult[index].canEdit,
                    "category": self?.vendorListResult[index].category,
                    "dateOfCreation": self?.vendorListResult[index].dateOfCreation,
                    "_id": self?.vendorListResult[index]._id,
                    "status": self?.vendorListResult[index].status,
                    "subCategory": self?.vendorListResult[index].subCategory,
                    "vendorCompany": self?.vendorListResult[index].vendorCompany,
                    "vendorDescription": self?.vendorListResult[index].vendorDescription,
                    "vendorName": self?.vendorListResult[index].vendorName] as [String : Any]
                self?.vendorDetails.add(vendorDict)
                self?.loadAddProductUI()
            }
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
var buttonTap=String()
    var buttonPosition=Int()
    @IBAction func productImgBtnTap(_ sender: UIButton){
        
        let productIArrayPosition : Int = sender.tag%10
        let productTagValue:Int = sender.tag / 10;
        let prodJPos = productTagValue%10
        
        print(productIArrayPosition)
        print(productTagValue)
        print(prodJPos)
        
        prodImgIArrayPos = productIArrayPosition
        prodImgJPos = prodJPos
        prodImgTagValue = sender.tag
        
//     print(prodImgTagValue)
        
        loadActionSheet()
        
//        let image=UIImagePickerController()
//                image.delegate=self
//                image.sourceType = .photoLibrary
//                image.allowsEditing=false
//                self.present(image, animated: true){
//
//                }
        
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        
        //        myProductArray
                self.productScrollView.removeFromSuperview()
                var mainArrayValidation=NSMutableArray()
                if myProductArray.count>0
                {
                for i in 0..<myProductArray.count {

                    let dataDict = myProductArray[i] as! NSDictionary

                    let productUniqueNum = dataDict.value(forKey: productUniqueNumber) as? String ?? ""
                    let productNameStr = dataDict.value(forKey: productName) as? String ?? ""
                    let descStr = dataDict.value(forKey: prodDescription) as? String ?? ""
                    let stockQuanStr = dataDict.value(forKey: stockQuantity) as? String ?? ""
                    let stockUnitStr = dataDict.value(forKey: stockUnit) as? String
                    let priceStr = dataDict.value(forKey: price) as? String ?? ""
                    let locationStr = dataDict.value(forKey: storageLocation) as? String
                    let purchaseDateStr = dataDict.value(forKey: purchaseDate) as? String
                    let expiryDateStr = dataDict.value(forKey: expiryDate) as? String ?? ""
                    let categoryStr = dataDict.value(forKey: category) as? String
                    let subcategoryStr = dataDict.value(forKey: subCategory) as? String
                    let orderIdStr = dataDict.value(forKey: orderId) as? String ?? ""
                    let pricePerStockUnitStr = dataDict.value(forKey: unitPrice) as? String ?? ""
                    let offerPriceUnitStr = dataDict.value(forKey: offerPriceUnit) as? String ?? ""

                    
                    if  (productNameStr == "") && (stockQuanStr == "") && (pricePerStockUnitStr == "") && (offerPriceUnitStr == "") {
                    
                        dataDict.setValue(true, forKey: "unitPriceWarn")
                        dataDict.setValue(true, forKey: "productNameWarn")
                        dataDict.setValue(true, forKey: "stockQuantityWarn")
                        dataDict.setValue(true, forKey: "offerPriceWarn")
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
                        if(pricePerStockUnitStr == ""){
                            dataDict.setValue(true, forKey: "unitPriceWarn")
                        }
                        if(offerPriceUnitStr == ""){
                            dataDict.setValue(true, forKey: "offerPriceWarn")
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
                    self.loadAddProductUI()
                    
                    if mainArrayValidation.count==myProductArray.count
                    {
                    print(myProductArray)
                        if myProductArray.count>0
                        {
                       // removeProductImage()
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                          let VC = storyBoard.instantiateViewController(withIdentifier: "PoductSummaryVC") as! ProductSummaryViewController
                    VC.modalPresentationStyle = .fullScreen
                            VC.fromView="vendor"
                    for i in 0..<myProductArray.count {

                        let dataDict = myProductArray.object(at: i) as! NSDictionary
                        dataDict.setValue(i+1, forKey: "itemNumber")
                        dataDict.setValue("0", forKey: "isSelected")
                        dataDict.setValue(vendorDetails, forKey: "vendorDetails")
                        myProductArray.replaceObject(at: i, with: dataDict)
                        
                    }
                    
                    
                    myAppDelegate.myProductsArray = myProductArray
            //        self.present(VC, animated: true, completion: nil)
                    self.navigationController?.pushViewController(VC, animated: true)
                    }
                    else
                    {
                        self.view.makeToast("Please add atleast one product")
                    }
                    }
                }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        textField.resignFirstResponder()
        return true
        
    }
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
        
        textField.becomeFirstResponder()
    
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
                    dict.setValue("\(obj3)", forKey: "price")
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
                        dict.setValue("\(obj3)", forKey: "price")
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
                dict.setValue("0.0", forKey: "price")
            }
           
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
        if(productTagValue == 1005){ //Price

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
        if(productTagValue == 1003){ // Stock Quantity

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
        dict = myProductArray[productArrayPosition] as! NSMutableDictionary

        print(productArrayPosition)
        print(productTagValue)
        
//        "actualPrice": "","offeredPrice"
        
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
        }
        else if(productTagValue == 3004){ //keyWords
            dict.setValue(textField.text, forKey: "keyWords")
            myProductArray.replaceObject(at: productArrayPosition, with: dict)
        }
        else if(productTagValue == 1003){ //Stock Quantity
            dict.setValue(textField.text, forKey: "stockQuantity")
            dict.setValue(false, forKey: "stockQuantityWarn")
            myProductArray.replaceObject(at: productArrayPosition, with: dict)
            self.loadAddProductUI()
        }

        else if(productTagValue == 1005){ //Price
            dict.setValue(textField.text, forKey: "actualPrice")
            myProductArray.replaceObject(at: productArrayPosition, with: dict)
        }else if(productTagValue == 1006){ //offeredUnitPrice
            dict.setValue(textField.text, forKey: "offeredUnitPrice")
            dict.setValue(false, forKey: "offerPriceWarn")
            myProductArray.replaceObject(at: productArrayPosition, with: dict)
            self.loadAddProductUI()
        }else if(productTagValue == 3003){ //Order ID
            dict.setValue(textField.text, forKey: "orderId")
            myProductArray.replaceObject(at: productArrayPosition, with: dict)
        }
        else if(productTagValue == 3009){ //Order ID
            dict.setValue(textField.text, forKey: "orderId")
            myProductArray.replaceObject(at: productArrayPosition, with: dict)
        }

        else if(productTagValue == 3006){ //3006
            dict.setValue(textField.text, forKey: "actualPrice")
            myProductArray.replaceObject(at: productArrayPosition, with: dict)
        }
        else if(productTagValue == 2001){ // Price Per Stock Unit
            dict.setValue(textField.text, forKey: "unitPrice")
            dict.setValue(false, forKey: "unitPriceWarn")
            myProductArray.replaceObject(at: productArrayPosition, with: dict)
            self.loadAddProductUI()
        }
        
        
//        print(myProductArray)
        
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
        dict = myProductArray[productArrayPosition] as! NSMutableDictionary

        print(productArrayPosition)
        print(productTagValue)

        
        if productTagValue == 1002{ //Product ID

            print("Product ID")
            print(textView.tag)

            dict.setValue(textView.text, forKey: "description")

        }else if(productTagValue == 3004){ //Product ID
                    
                    print("Product ID")
                    print(textView.tag)

                    dict.setValue(textView.text, forKey: "keyWords")

                }
        
        myProductArray.replaceObject(at: productArrayPosition, with: dict)

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
                    
//                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                          let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingVC") as! ShoppingViewController
//                          VC.modalPresentationStyle = .fullScreen
////                          self.present(VC, animated: true, completion: nil)
//                    self.navigationController?.pushViewController(VC, animated: true)
                    
                    self.navigationController?.popViewController(animated: true)

                   
                })
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)

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

                                if self.subbuttonTap=="tap"
{
                                    let productArrayPosition : Int = self.subbuttonTapPositon
                                    let dict = self.myProductArray[productArrayPosition] as! NSDictionary
                                    if respVo.result?.count ?? 0>0
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
    
    func getCategoriesDataFromServer()  {
        
        categoryDataArray.removeAllObjects()
        categoryIDArray.removeAllObjects()
        
        categoryDataArray = NSMutableArray()
        categoryIDArray = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

            
                    let URLString_loginIndividual = Constants.BaseUrl + categoriesUrl
                                
                                    
                        servcCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

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
                                if respVo.result?.count ?? 0>0
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
    
    func updateProductAPI()  {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
                
        let URLString_loginIndividual =  Constants.BaseUrl + VendorProductsUpdateUrl
        
        let dataDict = myProductArray.object(at: 0) as? NSDictionary
        
        let accountId = dataDict?.value(forKey: "accountId") as? String
        let productName = dataDict?.value(forKey: "productName") as? String
        let description = dataDict?.value(forKey: "description") as? String
        let keywords = dataDict?.value(forKey: "keyWords") as? String
        let stockQuantity = dataDict?.value(forKey: "stockQuantity") as? String
        var stockUnit=String()
        if dataDict?.value(forKey: "stockUnit") as! String==""
        {
            if stockUnitsArr.count>0
            {
                stockUnit=stockUnitsArr[0]._id ?? ""
            }
        }
        else
        {
            for i in 0..<stockUnitsArr.count {
                if dataDict?.value(forKey: "stockUnit") as! String==stockUnitsArr[i].stockUnitName ?? ""
                {
                    stockUnit = stockUnitsArr[i]._id ?? ""
                    break
                }
            }
            
        }
        let expiryDate = dataDict?.value(forKey: "expiryDate") as? String
        let purchaseDate = dataDict?.value(forKey: "purchaseDate") as? String
        let category = dataDict?.value(forKey: "category") as? String
        let subCategory = dataDict?.value(forKey: "subCategory") as? String
        let actualPrice = dataDict?.value(forKey: "actualPrice") as? String
        let actualUnitPrice = dataDict?.value(forKey: "actualUnitPrice") as? String
        let offeredPrice = dataDict?.value(forKey: "offeredPrice") as? String
        let offeredUnitPrice = dataDict?.value(forKey: "offeredUnitPrice") as? String
        let doorDelivery = dataDict?.value(forKey: "doorDelivery") as? Bool
        var storageLocationStr=String()
        if dataDict?.value(forKey: "storageLocation") as? String==""
        {
            if storageLocationArr.count>0
            {
                let dictt1=storageLocationArr[0] as? NSDictionary
                storageLocationStr=dictt1?.value(forKey: "_id")as? String ?? ""
            }
        }
        else
        {
            for i in 0..<storageLocationArr.count {
                let dictt1=storageLocationArr[0] as? NSDictionary
                if dataDict?.value(forKey: "storageLocation") as? String==dictt1?.value(forKey: "slocName")as? String ?? ""
                {
                    storageLocationStr = dictt1?.value(forKey: "_id")as? String ?? ""
                    break
                }
            }
            
        }
        var storageLocationStr1=String()
        if dataDict?.value(forKey: "storageLocation1") as! String==""
        {
                storageLocationStr1=storageLocationStr
        }
        else
        {
            for i in 0..<storageLocationArr1.count {
                let dictt1=storageLocationArr[0] as? NSDictionary
                if dataDict?.value(forKey: "storageLocation1") as? String==dictt1?.value(forKey: "slocName")as? String ?? ""
                {
                    storageLocationStr = dictt1?.value(forKey: "_id")as? String ?? ""
                    break
                }
            }
            
        }
        var vendorStr=String()
        if dataDict?.value(forKey: "vendor") as! String==""
        {
            if vendorListResult.count>0
            {
                vendorStr=vendorListResult[0]._id ?? ""
            }
        }
        else
        {
            for i in 0..<vendorListResult.count {
                if dataDict?.value(forKey: "vendor") as! String==vendorListResult[i].vendorName ?? ""
                {
                    vendorStr = vendorListResult[i]._id ?? ""
                    break
                }
            }
            
        }
        let orderIdStr = dataDict?.value(forKey: "orderId") as? NSString ?? ""
        let priceUnitStr = "616fd4205041085a07d69b1a"
        var prodImgDict = NSMutableDictionary()

        let prodImgArray = NSMutableArray()
        for _ in 0..<8 {

            prodImgDict = ["productImage": ""]
            prodImgArray.add(prodImgDict)
        }
        let params_IndividualLogin : NSDictionary = ["_id" : idString ,
                                "accountId" : accountId ?? "",
                                "actualPrice":actualPrice ?? "",
                                "actualUnitPrice":actualUnitPrice ?? "",
                                "category":category ?? "",
                                "description":description ?? "",
                                "doorDelivery":doorDelivery ?? false,
                                "expiryDate":expiryDate ?? "",
                                "keyWords":keywords ?? "",
                                "offeredPrice":offeredPrice ?? "",
                                "offeredUnitPrice":offeredUnitPrice ?? "",
                                "orderId":orderIdStr ,
                                "priceUnit":priceUnitStr ,
                                "productUniqueNumber":productId ,
                                "productImages":prodImgArray ,
                                "productName":productName ?? "",
                                "purchaseDate":purchaseDate ?? "" ,
                                "stockQuantity":stockQuantity ?? "",
                                "stockUnit":stockUnit ?? "",
                                "storageLocation":storageLocationStr ,
                                "storageLocation1": storageLocationStr1 ,
                                "subCategory":subCategory ?? "",
                                "vendor":vendorStr ,"vendorProductImages":[]]
        
//                            print(params_IndividualLogin)
                        
                            let postHeaders_IndividualLogin = ["":""]
        
        servcCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                                
                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
                                    if(statusCode == 200 ){
                             
                                        self.showSucessMsg(message: "Product updated successfully")
                                        self.navigationController?.popViewController(animated: true)
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

    }
    
  /*  [{"accountId":"61780acf0679a76022739c25","actualPrice":3481.0,"actualUnitPrice":59.0,"category":"NA","description":"","doorDelivery":true,"expiryDate":"29/10/2021","keyWords":"","offeredPrice":5723.0,"offeredUnitPrice":97.0,"orderId":"xvxv","priceUnit":"616fd3e25041085a07d69b18","productId":"hddggd","productImages":[{"productImage":" "},{"productImage":" "},{"productImage":" "},{"productImage":" "},{"productImage":" "},{"productImage":" "},{"productImage":" "},{"productImage":" "}],"productName":"test prod","purchaseDate":"29/10/2021","stockQuantity":59.0,"stockUnit":"61780acf0679a76022739c26","storageLocation":"61780acf0679a76022739c27","subCategory":"NA","vendor":"61780d8e36c8ad623c0d0733","vendorProductImages":[]}]
    
    */
  
    
    func callAddProductsAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
                
        let URLString_loginIndividual =  Constants.BaseUrl + AddVendorProductUrl
        
//        vendorUsers/vendorproducts_multipleadd
        
        let dataDict = myProductArray.object(at: 0) as? NSDictionary
        
        let accountId = dataDict?.value(forKey: "accountId") as? String
        let productName = dataDict?.value(forKey: "productName") as? String
        let description = dataDict?.value(forKey: "description") as? String
        let keywords = dataDict?.value(forKey: "keyWords") as? String
        let stockQuantity = dataDict?.value(forKey: "stockQuantity") as? String
        let stockUnit = dataDict?.value(forKey: "stockUnit") as? String
        let expiryDate = dataDict?.value(forKey: "expiryDate") as? String
        let purchaseDate = dataDict?.value(forKey: "purchaseDate") as? String
        let category = dataDict?.value(forKey: "category") as? String
        let subCategory = dataDict?.value(forKey: "subCategory") as? String
        let actualPrice = dataDict?.value(forKey: "actualPrice") as? String
        let actualUnitPrice = dataDict?.value(forKey: "actualUnitPrice") as? String
        let offeredPrice = dataDict?.value(forKey: "offeredPrice") as? String
        let offeredUnitPrice = dataDict?.value(forKey: "offeredUnitPrice") as? String
        let prodImgArray = dataDict?.value(forKey: "productImages") as? NSArray
        let doorDelivery = dataDict?.value(forKey: "doorDelivery") as? Bool
        
        let storageLocationStr = dataDict?.value(forKey: "storageLocation") as? NSString ?? ""
        let storageLocationStr1 = dataDict?.value(forKey: "storageLocation1") as? NSString ?? ""
        let storageLocationStr2 = dataDict?.value(forKey: "storageLocation2") as? NSString ?? ""
        
        let vendorStr = dataDict?.value(forKey: "vendor") as? NSString ?? ""
        let orderIdStr = dataDict?.value(forKey: "orderId") as? NSString ?? ""
        let priceUnit = dataDict?.value(forKey: "priceUnit") as? NSString ?? ""
        let offeredUnitPriceStr = dataDict?.value(forKey: "offeredUnitPrice") as? NSString ?? ""
        let productId = dataDict?.value(forKey: "productUniqueNumber") as? NSString ?? ""
        
                            let params_IndividualLogin = [
                                "accountId" : accountId ?? "",
                                "productName" : productName ?? "",
                                "description":description ?? "",
                                "keyWords":keywords ?? "",
                                "stockQuantity":stockQuantity ?? "",
                                "stockUnit":stockUnit ?? "",
                                "expiryDate":expiryDate ?? "",
                                "category":category ?? "",
                                "subCategory":subCategory ?? "",
                                "actualPrice":actualPrice ?? "",
                                "offeredPrice":offeredPrice ?? "",
                                "doorDelivery":doorDelivery! as Bool,
                                "productImages":prodImgArray,
                                "storageLocation":storageLocationStr,
                                "storageLocation1": storageLocationStr1,
                                "storageLocation2": storageLocationStr2,
                                "vendor":vendorStr,
                                "orderId":orderIdStr,
                                "priceUnit":priceUnit,
                                "offeredUnitPrice":offeredUnitPriceStr
                                
                            ] as [String : Any]
        
        let params = ["accountId":accountId ?? "",
                      "actualPrice":actualPrice ?? "",
                      "actualUnitPrice":actualUnitPrice,
                      "category":category ?? "",
                      "description":description ?? "",
                      "doorDelivery":doorDelivery! as Bool,
                      "expiryDate":expiryDate ?? "",
                      "keyWords":keywords ?? "",
                      "offeredPrice":offeredPrice ?? "",
                      "offeredUnitPrice":offeredUnitPrice,
                      "orderId":orderIdStr,
                      "priceUnit":priceUnit,
                      "productUniqueNumber":productId,
                      "productImages":prodImgArray,
                      "productName":productName ?? "",
                      "purchaseDate":purchaseDate ?? "",
                      "stockQuantity":stockQuantity ?? "",
                      "stockUnit":stockUnit ?? "",
                      "storageLocation":storageLocationStr,
                      "storageLocation1": storageLocationStr1,
                      "storageLocation2": storageLocationStr2,
                      "subCategory":subCategory ?? "",
                      "vendor":vendorStr,"vendorProductImages":[]] as [String : Any]
                        
                            let postHeaders_IndividualLogin = ["":""]
        
        servcCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                                
                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
                                    if(statusCode == 200 ){
                             
                                        self.showSucessMsg(message: "Product added successfully")
                                        
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
//            print(error.description)
//        }
    }
    
}

