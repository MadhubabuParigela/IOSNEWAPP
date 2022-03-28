//
//  ProperitesStoreVC.swift
//  TextRecognizProg
//
//  Created by apple on 2/19/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class ProperitesStoreVC: UIViewController,UITextFieldDelegate {
    
    var prodCount = 0
    
    var selectedImg = UIImage()
    
    @IBOutlet weak var selectCountTF: UITextField!
    @IBOutlet weak var propertiesCountLbl: UILabel!
    
    var myProductArray = NSMutableArray()
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var TV_Prog: UITableView!
    
    var myPropLBlArr:[String]=[]
    var tempArr:[String]=[]
    var imageToLoad = UIImage()
   
    var buttonsArr = ["Product Names","Price","Quantity"]
    
    var selectedData:String = ""
    var rowNumber = Int()
    
    @IBOutlet var priceBackgroudView: UIView!
    @IBOutlet var PriceView: UIView!
    @IBAction func onClickPricePerUnit(_ sender: Any) {
        selectedBillPriceScan="Price Per Unit"
        self.priceperUnitButton.setImage(UIImage(named: "radio_active"), for: .normal)
        self.totalPriceButton.setImage(UIImage(named: "radioInactive"), for: .normal)
    }
    @IBOutlet var totalPriceButton: UIButton!
    @IBAction func onClicktotalPtice(_ sender: Any) {
        selectedBillPriceScan="Total Price"
        self.priceperUnitButton.setImage(UIImage(named: "radioInactive"), for: .normal)
        self.totalPriceButton.setImage(UIImage(named: "radio_active"), for: .normal)
    }
    @IBOutlet var priceperUnitButton: UIButton!
    @IBAction func onClickCancelButton(_ sender: Any) {
        selectedBillPriceScan=""
        self.PriceView.isHidden=true
        self.priceBackgroudView.isHidden=true
    }
  


    @IBAction func onClickOKButton(_ sender: Any) {
        self.PriceView.isHidden=true
        self.priceBackgroudView.isHidden=true
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "MyCropVC") as! MyCropVC
         
         VC.cropSelectedImage = selectedImg
        
        VC.delegate = self
     //   VC.dataToBeSent = selectedData
       // VC.myBtn = rowNumber
        let indexPath = IndexPath(row: rowNumber, section: 0)
        let cell:MyTV_Cell = TV_Prog.cellForRow(at: indexPath) as! MyTV_Cell
        VC.myBtn = cell.checkBtn
         //   Save array
         let defaults = UserDefaults.standard
         defaults.set(tempArr, forKey: "SavedStringArray")
         
         let myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
         print(myarray.count)
         
       self.navigationController?.pushViewController(VC, animated: true)
    }
    var propertiesArr:[String] = ["","","","","",""]
    
    @IBAction func billDateButton(_ sender: Any) {
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

      
             TV_Prog.delegate = self
             TV_Prog.dataSource = self
        
        selectCountTF.delegate = self
        self.PriceView.isHidden=true
        self.priceBackgroudView.isHidden=true
             
             self.TV_Prog.allowsMultipleSelection = true
             self.TV_Prog.allowsMultipleSelectionDuringEditing = true
             
             var nib = UINib(nibName: "MyTV_Cell", bundle: nil)
             TV_Prog.register(nib, forCellReuseIdentifier: "MyTV_Cell")
           
                nextBtn.layer.cornerRadius = 10
                nextBtn.layer.borderWidth = 1
                nextBtn.layer.borderColor = #colorLiteral(red: 0.8830919862, green: 0.8905512691, blue: 0.9012110829, alpha: 1)
        
             let line = "Jira220 Sugar90 Snacks  Mushrooms"
               let lineItems = line.split(separator: " ", omittingEmptySubsequences: false)
                         // ["a", "b", "c", "", "d"]
                         print(lineItems)
        
//          self.propertiesCountLbl.text = "\(propertiesArr.count)"

        // Do any additional setup after loading the view.
        
         }
    

    @IBAction func onTapped_NextBtn(_ sender: Any) {
  
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let VC = storyBoard.instantiateViewController(withIdentifier: "PropertyStoreBillViewController") as! PropertyStoreBillViewController
         
        VC.myProductsArray = myProductArray
        VC.selectedImg = selectedImg
        print(myProductArray.count)
        
        if(myProductArray.count == 0){
            self.showAlertWith(title: "Alert", message: "Please select product details")

        }else{
            tempArr.removeAll()
            tempArr = myPropLBlArr
       
            print(propertiesArr)
        
            if propertiesArr[0].isEmpty==true
            {
                self.showAlertWith(title: "Alert", message: "Please select Product Names")
            }
            else
            {
            tempArr.insert(propertiesArr[0], at: 0)
            }
            if propertiesArr[1].isEmpty==true
            {
                self.showAlertWith(title: "Alert", message: "Please select Product Price")
            }
            else
            {
            tempArr.insert(propertiesArr[1], at: 1)
            }
            if propertiesArr[2].isEmpty==true
            {
                self.showAlertWith(title: "Alert", message: "Please select Product Quantity")
            }
            else
            {
            tempArr.insert(propertiesArr[2], at: 2)
            }
           
//            tempArr.insert(propertiesArr[3], at: 3)
//            tempArr.insert(propertiesArr[4], at: 4)
//            tempArr.insert(propertiesArr[5], at: 5)
          
            print(tempArr.count)
            
            print(tempArr)
            
           
            
          DispatchQueue.main.async {
            self.TV_Prog.reloadData()
            
        }
            
            let defaults = UserDefaults.standard
            defaults.set(tempArr, forKey: "SavedStringArray")

        
      self.navigationController?.pushViewController(VC, animated: true)
        
     //  print(tempArr)
     //   Save array
       

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
    
    @IBAction func OKBtnTapped(_ sender: Any) {
        
        let count = Int(selectCountTF.text ?? "0") as! Int
        
        if(selectCountTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Please enter product count")
            
        }
//        else if( count > 10){
//            self.showAlertWith(title: "Alert", message: "Please enter product count less than 10")
//
//        }
        else{
            
            prodCount = Int(selectCountTF.text!) ?? 0

            for _ in 0..<prodCount {
                
                var myDict = NSMutableDictionary()
                
                var prodImgDict = NSMutableDictionary()

                let prodImgArray = NSMutableArray()
                for _ in 0..<3 {
                    
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

                
                myDict  = ["accountId": accountID,"actualPrice":"","actualUnitPrice":"","productName": "", "productUniqueNumber": "","description": "","stockQuantity": "","stockUnit": "","stockUnitId":"","purchaseDate": selectedDate,"expiryDate": "","storageLocation": "","borrowed": "","category": "","subCategory": "","categoryId": "","subCategoryId": "","orderId": "","vendorId": "","unitPrice": "","uploadType": "","userId": userID,"productImages": prodImgArray,"isActive":"0","doorDelivery":false,"keyWords":"","offeredPrice":"","offeredUnitPrice":"","priceUnit":"","priceUnitId":"","stockUnitId":"","storageLocation1":"","storageLocation2":"","storageLocationId":"","storageLocation1Id":"","storageLocation2Id":"","vendorName":"","stockwarn":false,"unitPricewarn":false,"pricewarn":false]
               
                myProductArray.add(myDict)

            }
        }
    }
    
    func addProdInfo()  {
        
        self.myProductArray=NSMutableArray()
        prodCount = Int(selectCountTF.text!) ?? 0

        for _ in 0..<prodCount {
            
            var myDict = NSMutableDictionary()
            
            var prodImgDict = NSMutableDictionary()

            let prodImgArray = NSMutableArray()
            for _ in 0..<3 {
                
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
            
            myDict  = ["accountId": accountID,"actualPrice":"","actualUnitPrice":"","productName": "", "productUniqueNumber": "","description": "","stockQuantity": "","stockUnit": "","stockUnitId":"","purchaseDate": selectedDate,"expiryDate": "","storageLocation": "","borrowed": "","category": "","subCategory": "","categoryId": "","subCategoryId": "","orderId": "","vendorId": "","unitPrice": "","uploadType": "","userId": userID,"productImages": prodImgArray,"isActive":"0","doorDelivery":false,"keyWords":"","offeredPrice":"","offeredUnitPrice":"","priceUnit":"","priceUnitId":"","stockUnitId":"","storageLocation1":"","storageLocation2":"","storageLocationId":"","storageLocation1Id":"","storageLocation2Id":"","vendorName":"","stockwarn":false,"unitPricewarn":false,"pricewarn":false]
            myProductArray.add(myDict)

        }
    }
    
    @IBAction func onTap_BackBtn(_ sender: Any) {
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
}


extension ProperitesStoreVC:UITableViewDelegate,UITableViewDataSource,MyDataSendingDelegate {
    
     func numberOfSections(in tableView: UITableView) -> Int {
          return 1
       }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return buttonsArr.count
      }
         
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
      var cell = TV_Prog.dequeueReusableCell(withIdentifier: "MyTV_Cell", for: indexPath) as! MyTV_Cell
        
//        print("Prop Arr is \(propertiesArr)")
//        print("Butt Arr is \(buttonsArr)")
//  cell.tag = indexPath.row
        
          cell.checkBtn.tag = indexPath.row
          cell.myLbl.text = buttonsArr[indexPath.row]
        
          cell.myArrLbl.text = propertiesArr[indexPath.row]
      
            return cell
       
        }

      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 90
        }
    
   
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(prodCount <= 0){
            self.showAlertWith(title: "Alert", message: "Please enter product count")
            return
        }
     
        var tag = indexPath.row
        
        let cell:MyTV_Cell = TV_Prog.cellForRow(at: indexPath) as! MyTV_Cell
        
        rowNumber = indexPath.row
        
        selectedData = propertiesArr[rowNumber]
        if buttonsArr[indexPath.row]=="Price"
        {
            selectedBillPriceScan=""
            self.PriceView.isHidden=false
            self.priceBackgroudView.isHidden=false
        }
        else
        {
        
       
//            if cell.checkBtn.currentImage==UIImage(named: "checkBoxActive")
//            {
//                cell.checkBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
//                cell.checkBtn.setBackgroundImage(UIImage(named: "checkBoxInactive"), for: .normal)
//            }
//            else
//            {
       let storyBoard = UIStoryboard(name: "Main", bundle: nil)
       let VC = storyBoard.instantiateViewController(withIdentifier: "MyCropVC") as! MyCropVC
        
        VC.cropSelectedImage = selectedImg
       
       VC.delegate = self
    //   VC.dataToBeSent = selectedData
       VC.myBtn = cell.checkBtn
        
        //   Save array
        let defaults = UserDefaults.standard
        defaults.set(tempArr, forKey: "SavedStringArray")
        
        let myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        print(myarray.count)
        
      self.navigationController?.pushViewController(VC, animated: true)
            }
       // }
     }
   
   func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

      //print("Is Called")
       return true
    
   }
   
   // Delegate Method
    
     func sendDataToFirstViewController(myData: String) {
        
        print("Row Num is \(rowNumber)")
        
        let myDataArry = myData.components(separatedBy: "\n") as NSArray
        print(myDataArry)

        parseSelectedBillScanData(parseArray: myDataArry)
        
       propertiesArr[rowNumber] = myData
        
        [propertiesArr[rowNumber]].count
        
    print("\([propertiesArr[rowNumber]].count)")
        
        var countArr = NSMutableArray()
        
        countArr.add([propertiesArr[rowNumber]])
        
        
    //   print("My Text Array: \(propertiesArr[rowNumber]),Index: \(rowNumber))")
       
       TV_Prog.reloadData()
       
    }
    
    func parseSelectedBillScanData(parseArray:NSArray)  {
        
        if(prodCount <= parseArray.count){
        
            for i in 0..<myProductArray.count {

                let parsedStr = parseArray.object(at: i) as? String
                
                var dict = NSMutableDictionary()
                dict = myProductArray[i] as! NSMutableDictionary
                
                if(rowNumber == 0){
                    dict.setValue(parsedStr, forKey: "productName")
                    
                }else if(rowNumber == 1){
                    if selectedBillPriceScan=="Price Per Unit"
                    {
                    dict.setValue(parsedStr, forKey: "unitPrice")
                    }
                    else
                    {
                        dict.setValue(parsedStr, forKey: "price")
                    }

                }else if(rowNumber == 2){
                    dict.setValue(parsedStr, forKey: "stockQuantity")

                }
                
                myProductArray.replaceObject(at: i, with: dict)
            }
            
            print("Parsed My Prod Arr is \(myProductArray)")
      
        }
        
        
        else{

            for i in 0..<parseArray.count {

//                if(i <= myProductArray.count){

                    let parsedStr = parseArray.object(at: i) as! String

                    var dict = NSMutableDictionary()
                    dict = myProductArray[i] as! NSMutableDictionary

                    if(rowNumber == 0){
                        dict.setValue(parsedStr, forKey: "productName")

                    }else if(rowNumber == 1){
                        if selectedBillPriceScan=="Price Per Unit"
                        {
                        dict.setValue(parsedStr, forKey: "unitPrice")
                        }
                        else
                        {
                            dict.setValue(parsedStr, forKey: "price")
                        }

                    }else if(rowNumber == 2){
                        dict.setValue(parsedStr, forKey: "stockQuantity")

                    }

                    myProductArray.replaceObject(at: i, with: dict)
//                }

            }

            print("Parsed My Prod Arr is \(myProductArray)")

        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == selectCountTF){
            prodCount = Int(selectCountTF.text!) ?? 0
            if(prodCount <= 0){
                self.showAlertWith(title: "Alert", message: "Please enter product count")
                return
            }
            else
         {
            addProdInfo()
         }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
   
   

