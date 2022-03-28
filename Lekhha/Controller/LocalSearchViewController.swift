//
//  LocalSearchViewController.swift
//  LekhaLatest
//
//  Created by USM on 18/02/21.
//

import UIKit
import ObjectMapper

protocol sendLocalSearchDetails {
    func sendLocalSearchDetailsData(dataArray:NSMutableArray,statusStr:String)
}

protocol sendLocalShoppingSearchDetails {
    func sendShoppingLocalSearchDetailsData(dataArray:NSMutableArray,statusStr:String)
}


class LocalSearchViewController: UIViewController,UITextFieldDelegate,sentname {
    
    var delegate:sendLocalSearchDetails?
    var delegate1:sendLocalShoppingSearchDetails?
    
    func sendnamedfields(fieldname: String, idStr: String) {
        
        if(moduleStatusStr == "currentInventory"){
            localSortBottomView.stockQuanTF.text = fieldname
            localSortBottomView.stockQuanTF.resignFirstResponder()

        }else{
            localShoppingBottomView.stockQunaTF.text = fieldname
            localShoppingBottomView.stockQunaTF.resignFirstResponder()

        }
        
        let dataArray = fieldname.components(separatedBy: "-") as? NSArray
        
        if(fieldname == "Above 100"){
            filterStartDateStr = "100"
            filetEndDateStr = "10000"

        }else{
            filterStartDateStr = dataArray?.firstObject as! String
            filetEndDateStr = dataArray?.lastObject as! String
            
        }

        print(filterStartDateStr)
        print(filetEndDateStr)
        
        self.navigationController?.popViewController(animated: true)

    }
    
    var permissionStatusArray = NSArray()
    var statusArray = NSArray()
    
    var localSortBottomView = LocalBottomView()
    var localShoppingBottomView = ShoppingLocalBottomView()
    
    @IBOutlet weak var lookingForTxtField: UITextField!
    
    var filterSortStatus = String()
    var searchFilterStatusStr = String()
    var filterStartDateStr = String()
    var filetEndDateStr = String()
    var stockQuanStr = String()
    var filterBtnTxtStr = ""
    
    
    let filtersDataArray = NSMutableArray()
    
   var currentInvenFilterStatus = ""
    var shoppingCartFilterStatus = ""
    
    var picker : UIDatePicker = UIDatePicker()

    
    let hiddenBtn = UIButton()
    let pickerDateView = UIView()

    
//    var localSortBottomView = LocalBottomView()

    var moduleStatusStr = String()
    var localSerCntrl = ServiceController()
    
    var accountID = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusArray = ["0-20","20-40","40-60","60-80","80-100","Above 100"]
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
//        filterStartDateStr = "NULL"
//        filetEndDateStr = "NULL"
//        stockQuanStr = "NULL"

        let paddingView = UIView()
        paddingView.frame = CGRect(x: lookingForTxtField.frame.size.width - (35), y: 0, width: 35, height: lookingForTxtField.frame.size.height)
        lookingForTxtField.rightView = paddingView
        lookingForTxtField.rightViewMode = UITextField.ViewMode.always
        
        lookingForTxtField.delegate = self
        
        let filterBtn = UIButton()
        filterBtn.frame = CGRect(x: paddingView.frame.size.width/2 - 12.5, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
        paddingView.addSubview(filterBtn)
        
        filterBtn.addTarget(self, action: #selector(filterBtnTapped), for: .touchUpInside)

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
            self.navigationController?.pushViewController(VC, animated: true)

        }
    
    @IBAction func filterBtnTapped(_ sender: UIButton){
        
        if(lookingForTxtField.text == ""){
            self.showAlertWith(title: "Alert", message: "Please enter looking for data")
            return

        }
        
        lookingForTxtField.resignFirstResponder()
        
        if(moduleStatusStr == "currentInventory"){
            toggleLocalSortViewWithAnimation()

        }else{
            toggleShoppingCartViewWithAnimation()
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if(textField == localSortBottomView.stockQuanTF || textField == localShoppingBottomView.stockQunaTF){
        
        textField.resignFirstResponder()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select"
        viewTobeLoad.fields = self.statusArray as! [String]
        viewTobeLoad.categoryIDs = self.statusArray as! [String]
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

        }
        
    }
    
    
    @IBAction func applyBtnTapped(_ sender: Any) {
        
        if(lookingForTxtField.text == ""){
            self.showAlertWith(title: "Alert", message: "Please enter looking for data")
            return
        }
        
            filterLocalSearchApplyAPI()
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }
    
    func toggleShoppingCartViewWithAnimation() {

        let allViewsInXibArray = Bundle.main.loadNibNamed("ShoppingLocalBottomView", owner: self, options: nil)
        localShoppingBottomView = allViewsInXibArray?.first as! ShoppingLocalBottomView
        localShoppingBottomView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
         self.view.addSubview(localShoppingBottomView)
        
        localShoppingBottomView.cancelBtn.addTarget(self, action: #selector(localShoppingSortCancelBtnTapped), for: .touchUpInside)
        
        localShoppingBottomView.plannedPurchaseDateBtn.addTarget(self, action: #selector(localShoppingSortPurchaseDateBtnTap), for: .touchUpInside)

//        localShoppingBottomView.endDateBtn.addTarget(self, action: #selector(localShoppingSortEndDateBtnTap), for: .touchUpInside)
        
        localShoppingBottomView.quantityBtn.addTarget(self, action: #selector(localShoppingQuanBtnTap), for: .touchUpInside)
    
        localShoppingBottomView.startDate.addTarget(self, action: #selector(localShoppingStartdateBtnTapped(_:)), for: .touchUpInside)

        localShoppingBottomView.endDateBtn.addTarget(self, action: #selector(localShoppingEnddateBtnTapped(_:)), for: .touchUpInside)
    

        localShoppingBottomView.applyBtn.addTarget(self, action: #selector(localShoppingFilterApplyBtnTapped(_:)), for: .touchUpInside)
        
        localShoppingBottomView.stockQunaTF.delegate = self

    
//        let path = UIBezierPath(roundedRect:localSortBottomView.cardView.bounds,
//                                byRoundingCorners:[.topRight, .topLeft],
//                                cornerRadii: CGSize(width: 20, height:  20))
//
//        let maskLayer = CAShapeLayer()
//
//        maskLayer.path = path.cgPath
//        localSortBottomView.cardView.layer.mask = maskLayer
        
        localShoppingBottomView.startDateView.isHidden = true
        localShoppingBottomView.endDateView.isHidden = true
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.localShoppingBottomView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.localShoppingBottomView)
            

         }, completion: { (finished: Bool) -> Void in
            self.localShoppingBottomView.hiddenBackBtutton.isHidden = false

         })


    }
    
    func toggleLocalSortViewWithAnimation() {
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("LocalBottomView", owner: self, options: nil)
        localSortBottomView = allViewsInXibArray?.first as! LocalBottomView
        localSortBottomView.frame = CGRect(x: 0, y: self.view.frame.size.height+350, width: self.view.frame.size.width, height: self.view.frame.size.height)
         self.view.addSubview(localSortBottomView)
        
        localSortBottomView.cancelBtn.addTarget(self, action: #selector(localSortCancelBtnTapped), for: .touchUpInside)
        
        localSortBottomView.purchaseDateBtn.addTarget(self, action: #selector(localSortPurchaseDateBtnTap), for: .touchUpInside)

        localSortBottomView.expiryDateBtn.addTarget(self, action: #selector(localSortEndDateBtnTap), for: .touchUpInside)
        
        localSortBottomView.quantityBtn.addTarget(self, action: #selector(localQuanBtnTap), for: .touchUpInside)
    
        localSortBottomView.startDateBtn.addTarget(self, action: #selector(startdateBtnTapped(_:)), for: .touchUpInside)

        localSortBottomView.endDateBtn.addTarget(self, action: #selector(enddateBtnTapped(_:)), for: .touchUpInside)
    

        localSortBottomView.applyBtn.addTarget(self, action: #selector(filterApplyBtnTapped(_:)), for: .touchUpInside)
        
        localSortBottomView.stockQuanTF.delegate = self

    
//        let path = UIBezierPath(roundedRect:localSortBottomView.cardView.bounds,
//                                byRoundingCorners:[.topRight, .topLeft],
//                                cornerRadii: CGSize(width: 20, height:  20))
//
//        let maskLayer = CAShapeLayer()
//
//        maskLayer.path = path.cgPath
//        localSortBottomView.cardView.layer.mask = maskLayer
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.localSortBottomView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.localSortBottomView)
            

         }, completion: { (finished: Bool) -> Void in
            self.localSortBottomView.backHiddenBtn.isHidden = false

         })
        
       }
    
    @objc func localShoppingSortCancelBtnTapped(sender:UIButton){
        localShoppingBottomView.hiddenBackBtutton.isHidden = false
        localShoppingBottomView.removeFromSuperview()

    }
    
    @objc func localShoppingSortPurchaseDateBtnTap(sender:UIButton){
        
        filterBtnTxtStr = "purchaseDate"
        
        localShoppingBottomView.startDateView.isHidden = false
        localShoppingBottomView.endDateView.isHidden = false
        
        localShoppingBottomView.stockQunaTF.isHidden = true
        
        localShoppingBottomView.plannedPurchaseDateBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")
        localShoppingBottomView.quantityBtn.backgroundColor = UIColor.clear
        localShoppingBottomView.quantityBtn.backgroundColor = UIColor.clear
        
        localShoppingBottomView.plannedPurchaseDateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        localShoppingBottomView.quantityBtn.setTitleColor(.gray, for: .normal)


    }
    
//    @objc func localShoppingSortEndDateBtnTap(sender:UIButton){
//
//        filterBtnTxtStr = "expiryDate"
//
//        localShoppingBottomView.startDateview.isHidden = false
//        localShoppingBottomView.endDateView.isHidden = false
//
//        localShoppingBottomView.stockQunaTF.isHidden = true
//
//        localShoppingBottomView.plannedPurchaseDateBtn.backgroundColor = UIColor.clear
//        localShoppingBottomView.quantityBtn.backgroundColor = UIColor.clear
//
//        localShoppingBottomView.plannedPurchaseDateBtn.setTitleColor(.gray, for: .normal)
//        localShoppingBottomView.quantityBtn.setTitleColor(.gray, for: .normal)
//
//    }
    
    @objc func localShoppingQuanBtnTap(sender:UIButton){

        filterBtnTxtStr = "stockQuantity"
        
        localShoppingBottomView.startDateView.isHidden = true
        localShoppingBottomView.endDateView.isHidden = true
        
        localShoppingBottomView.stockQunaTF.isHidden = false
        
        localShoppingBottomView.stockQunaTF.keyboardType = .numberPad
        
        localShoppingBottomView.quantityBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")
        localShoppingBottomView.plannedPurchaseDateBtn.backgroundColor = UIColor.clear

        localShoppingBottomView.quantityBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        localShoppingBottomView.plannedPurchaseDateBtn.setTitleColor(.gray, for: .normal)

        
    }
    
    @objc func localShoppingStartdateBtnTapped(_ sender :UIButton){
        
        filterSortStatus = "1"
       
       let currentDate = Date()
       let eventDatePicker = UIDatePicker()
       
       eventDatePicker.datePickerMode = UIDatePicker.Mode.date
       eventDatePicker.minimumDate = currentDate
              
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd/MM/yyyy"
       
       let result = dateFormatter.string(from: currentDate)
       
//       if(isLocalSearch == "1"){

           if(filterSortStatus == "1"){ //Purchase Btn
               localShoppingBottomView.startDate.setTitle(result, for: .normal)
               filterStartDateStr = result

           }else if(filterSortStatus == "0"){
            localShoppingBottomView.endDateBtn.setTitle(result, for: .normal)
               filetEndDateStr = result

           }
       
        datePickerView()
        
    }
    
    @objc func localShoppingEnddateBtnTapped(_ sender :UIButton){
        filterSortStatus = "0"
        datePickerView()
        
    }
    
    //Local Sort Current Inventory
    
    @objc func localSortCancelBtnTapped(sender:UIButton){
        localSortBottomView.backHiddenBtn.isHidden = false
        localSortBottomView.removeFromSuperview()
    }

    @objc func localSortPurchaseDateBtnTap(sender:UIButton){
        
        filterBtnTxtStr = "purchaseDate"
        
        localSortBottomView.startDateView.isHidden = false
        localSortBottomView.endDateView.isHidden = false
        
        localSortBottomView.stockQuanTF.isHidden = true
        
        localSortBottomView.purchaseDateBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")
        localSortBottomView.expiryDateBtn.backgroundColor = UIColor.clear
        localSortBottomView.quantityBtn.backgroundColor = UIColor.clear
        
        localSortBottomView.purchaseDateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        localSortBottomView.expiryDateBtn.setTitleColor(.gray, for: .normal)
        localSortBottomView.quantityBtn.setTitleColor(.gray, for: .normal)


    }
    
    @objc func localSortEndDateBtnTap(sender:UIButton){
        
        filterBtnTxtStr = "expiryDate"
        
        localSortBottomView.startDateView.isHidden = false
        localSortBottomView.endDateView.isHidden = false
        
        localSortBottomView.stockQuanTF.isHidden = true
        
        localSortBottomView.expiryDateBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")
        localSortBottomView.purchaseDateBtn.backgroundColor = UIColor.clear
        localSortBottomView.quantityBtn.backgroundColor = UIColor.clear

        localSortBottomView.expiryDateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        localSortBottomView.purchaseDateBtn.setTitleColor(.gray, for: .normal)
        localSortBottomView.quantityBtn.setTitleColor(.gray, for: .normal)

        
    }
    @objc func localQuanBtnTap(sender:UIButton){
        
        filterBtnTxtStr = "stockQuantity"
        
        localSortBottomView.startDateView.isHidden = true
        localSortBottomView.endDateView.isHidden = true
        
        localSortBottomView.stockQuanTF.isHidden = false
        
        localSortBottomView.stockQuanTF.keyboardType = .numberPad
        
        localSortBottomView.quantityBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")
        localSortBottomView.purchaseDateBtn.backgroundColor = UIColor.clear
        localSortBottomView.expiryDateBtn.backgroundColor = UIColor.clear

        localSortBottomView.quantityBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        localSortBottomView.purchaseDateBtn.setTitleColor(.gray, for: .normal)
        localSortBottomView.expiryDateBtn.setTitleColor(.gray, for: .normal)

    }
    
    @objc func localShoppingFilterApplyBtnTapped(_ sender:UIButton){
        
        if(filterBtnTxtStr == ""){
            
            self.showAlertWith(title: "Alert", message: "Please select start date")
            return
            
        }else{
            
            if(filterBtnTxtStr == ""){
                
                if(filterStartDateStr == "" ){
                    self.showAlertWith(title: "Alert", message: "Please select start date")
                    return
                    
                }else if(filetEndDateStr == "" ){
                    self.showAlertWith(title: "Alert", message: "Please select end date")
                    return

                }
            }else{
                if(filterBtnTxtStr == "stockQuantity"){
                   
                   if(moduleStatusStr == "currentInventory"){
                       stockQuanStr = localSortBottomView.stockQuanTF.text ?? ""

                   }else{
                       stockQuanStr = localShoppingBottomView.stockQunaTF.text ?? ""

                   }
              
                if(stockQuanStr == ""){
                    self.showAlertWith(title: "Alert", message: "Please enter stock quantity")
                    return

                }
            }
            
//             else{
                 filterPopupLocalSearchApplyAPI()

//               }
            }
            
//            else{
                
     //           if(isLocalSearch == "1"){
//                    filterPopupLocalSearchApplyAPI()
     //           }else{
     //               filterApplyAPI()
     //           }
//            }
        }
    }
    
    @objc func filterApplyBtnTapped(_ sender:UIButton){
     
       if(filterStartDateStr == "purchaseDate" ){
           self.showAlertWith(title: "Alert", message: "Please select start date")
           return
           
       }else if(filetEndDateStr == "" ){
           self.showAlertWith(title: "Alert", message: "Please select end date")
           return

       }else if(filterBtnTxtStr == "stockQuantity"){
        
        stockQuanStr = localSortBottomView.stockQuanTF.text ?? ""
      
        if(stockQuanStr == ""){
            self.showAlertWith(title: "Alert", message: "Please enter stock quantity")
            return

        }else{
            filterPopupLocalSearchApplyAPI()

          }
       }
       
       else{
           
//           if(isLocalSearch == "1"){
               filterPopupLocalSearchApplyAPI()
//           }else{
//               filterApplyAPI()
//           }
       }

    }
    
    @objc func startdateBtnTapped(_ sender :UIButton){
        
        filterSortStatus = "1"
       
       let currentDate = Date()
       let eventDatePicker = UIDatePicker()
       
       eventDatePicker.datePickerMode = UIDatePicker.Mode.date
       eventDatePicker.minimumDate = currentDate
              
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd/MM/yyyy"
       
       let result = dateFormatter.string(from: currentDate)
       
//       if(isLocalSearch == "1"){

           if(filterSortStatus == "1"){ //Purchase Btn
               localSortBottomView.startDateBtn.setTitle(result, for: .normal)
               filterStartDateStr = result

           }else if(filterSortStatus == "0"){
               localSortBottomView.endDateBtn.setTitle(result, for: .normal)
               filetEndDateStr = result

           }

//       }else{
//           if(filterSortStatus == "1"){ //Purchase Btn
//               FiltterView.startDateBtn.setTitle(result, for: .normal)
//               filterStartDateStr = result
//
//           }else{
//
//               FiltterView.endDateBtn.setTitle(result, for: .normal)
//               filetEndDateStr = result
//
//           }
//       }
       
        datePickerView()
        
    }
    
    @objc func enddateBtnTapped(_ sender :UIButton){
        filterSortStatus = "0"
        datePickerView()
        
    }
    
    func filterPopupLocalSearchApplyAPI() {
        
        searchFilterStatusStr = lookingForTxtField.text ?? ""
        
        if(moduleStatusStr == "currentInventory"){
            stockQuanStr = localSortBottomView.stockQuanTF.text ?? ""

        }else{
            stockQuanStr = localShoppingBottomView.stockQunaTF.text ?? ""

        }
        
        var searchString = ""
        var stockQuanString = ""

        if(searchFilterStatusStr != ""){
            searchString = "/\(searchFilterStatusStr)"
        }
        
        
//        if(stockQuanStr != ""){
//            stockQuanString = "/\(stockQuanStr)"
//        }

        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let URLString_loginIndividual = Constants.BaseUrl + LocalSearchFilterUrl + accountID as String + searchString + stockQuanString + "/\(filterBtnTxtStr)" + "/\(filterStartDateStr)" + "/\(filetEndDateStr)" + "/\(moduleStatusStr)"
        
//        http://35.154.239.192:4500/endusers/getLocalSearchFilter/6038d1fd7b1e1c45acf9a21c/h/purchaseDate/2021-03-22/2021-03-22/currentInventory
        
        var urlString = URLString_loginIndividual.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        urlString = urlString?.replacingOccurrences(of: " ", with: "%20")

            
        localSerCntrl.requestGETURL(strURL:urlString!, success: {(result) in
            
            let dataDict = result as! NSDictionary

            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!

                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")

                if(statusCode == 200 ){
                    
                    var shoppingCartResult = NSMutableArray()
                    var currentInventoryResult = NSMutableArray()
                    var openOrdersManagementResult = NSMutableArray()
                    var orderHistoryManagementresult = NSMutableArray()
                    
                    if(self.moduleStatusStr == "currentInventory"){
                        currentInventoryResult = dataDict.value(forKey: "currentInventoryresult") as! NSMutableArray
                    }
                    
//                    var shoppingResult = [ShoppingCartResult]()
                    
                    if(self.moduleStatusStr == "shoppingCart"){
                        
//                        shoppingResult = respVo.shoppingCartresult!
                        
                        shoppingCartResult = dataDict.value(forKey: "shoppingCartresult") as! NSMutableArray
                        
                        for i in 0..<shoppingCartResult.count {
                            self.filtersDataArray.add(shoppingCartResult[i])
                        }


//                         currentInventoryResult = dataDict.value(forKey: "shoppingCartresult") as! NSMutableArray

                    }
                    
                    
//                    if(self.openOrdersFilterStatus == "openOrders"){
//                         openOrdersManagementResult = dataDict.value(forKey: "openOrdersManagementresult") as! NSMutableArray
//
//                    }
//
//                    if(self.ordersHistoryFilterStatus == "ordersHistory"){
//                         orderHistoryManagementresult = dataDict.value(forKey: "orderHistoryManagementresult") as! NSMutableArray
//
//                    }
                    
//                if(shoppingCartResult.count > 0){
//                    for i in 0..<shoppingCartResult.count {
//                        self.filtersDataArray.add(shoppingCartResult[i])
//                    }
//
//                }
                    
                    
                if(currentInventoryResult.count > 0){
                    for i in 0..<currentInventoryResult.count {
                        self.filtersDataArray.add(currentInventoryResult[i])
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
                                
//                    print("Filters Data is \(self.filtersDataArray)")
                    
                    if(self.moduleStatusStr == "currentInventory"){
                        
                        if(self.filtersDataArray.count == 0){
                            
                            self.localSortBottomView.backHiddenBtn.isHidden = false
                            self.localSortBottomView.removeFromSuperview()
                            
                            self.showAlertWith(title: "Alert", message: "No data found")
                            return
                        }
                    }else{
                        
                        if(shoppingCartResult.count == 0){
                            self.localShoppingBottomView.hiddenBackBtutton.isHidden = false
                            self.localShoppingBottomView.removeFromSuperview()
                            
                            self.showAlertWith(title: "Alert", message: "No data found")
                            return

                        }
                        
                    }
                    
//                    let VC = CurrentInventoryViewController()
                    
                    if(self.moduleStatusStr == "currentInventory"){
                        self.delegate?.sendLocalSearchDetailsData(dataArray: self.filtersDataArray, statusStr: "CurrentInventory")

                    }else{
                        
                        self.delegate1?.sendShoppingLocalSearchDetailsData(dataArray: self.filtersDataArray, statusStr: "Shopping")

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
        
//      if(isLocalSearch == "1"){
        
        if(moduleStatusStr == "currentInventory"){
            
            if(filterSortStatus == "1"){ //Purchase Btn
                localSortBottomView.startDateBtn.setTitle(result , for: .normal)
                filterStartDateStr = result

            }else if(filterSortStatus == "0"){
                localSortBottomView.endDateBtn.setTitle(result, for: .normal)
                filetEndDateStr = result
            }
        }else{
            
            if(filterSortStatus == "1"){ //Start Date
                localShoppingBottomView.startDate.setTitle(result , for: .normal)
                filterStartDateStr = result

            }else if(filterSortStatus == "0"){
                localShoppingBottomView.endDateBtn.setTitle(result, for: .normal)
                filetEndDateStr = result

            }
        }


//        }else{
//            if(filterSortStatus == "1"){ //Purchase Btn
//                FiltterView.startDateBtn.setTitle(result, for: .normal)
//                filterStartDateStr = result
//
//            }else{
//
//                FiltterView.endDateBtn.setTitle(result, for: .normal)
//                filetEndDateStr = result
//
//            }
//        }

   }
   
   @objc func dueDateChanged(sender:UIDatePicker){
       
       let dateFormatter = DateFormatter()
       
       dateFormatter.dateFormat = "dd/MM/yyyy"
       let selectedDate = dateFormatter.string(from: picker.date)
    
//    if(isLocalSearch == "1"){
    
    if(moduleStatusStr == "currentInventory"){

        if(filterSortStatus == "1"){ //Purchase Btn
         localSortBottomView.startDateBtn.setTitle(selectedDate, for: .normal)
         filterStartDateStr = selectedDate
         
        }else if(filterSortStatus == "0"){
            localSortBottomView.endDateBtn.setTitle(selectedDate, for: .normal)
         filetEndDateStr = selectedDate

        }
        
    }else{
        
        if(filterSortStatus == "1"){ //Start Date
            localShoppingBottomView.startDate.setTitle(selectedDate , for: .normal)
            filterStartDateStr = selectedDate

        }else if(filterSortStatus == "0"){
            localShoppingBottomView.endDateBtn.setTitle(selectedDate, for: .normal)
            filetEndDateStr = selectedDate

        }
    }
        

        
//    }else{
//
//        if(filterSortStatus == "1"){ //Purchase Btn
//         FiltterView.startDateBtn.setTitle(selectedDate, for: .normal)
//         filterStartDateStr = selectedDate
//
//        }else if(filterSortStatus == "0"){
//         FiltterView.endDateBtn.setTitle(selectedDate, for: .normal)
//         filetEndDateStr = selectedDate
//
//        }
//      }
   }
   
   @objc func doneBtnTap(_ sender: UIButton) {

       hiddenBtn.removeFromSuperview()
       pickerDateView.removeFromSuperview()
       
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
    
    func filterLocalSearchApplyAPI() {
        
        searchFilterStatusStr = lookingForTxtField.text ?? ""
        
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
                    var filtersDataArray = NSMutableArray()

                    if self.moduleStatusStr == "currentInventory"{
                           
                    filtersDataArray = dataDict.value(forKey: "currentInventoryresult") as! NSMutableArray
                        
                        self.delegate?.sendLocalSearchDetailsData(dataArray: filtersDataArray, statusStr: "CurrentInventory")

                                        
//                            print("Filters Data is \(filtersDataArray)")
                            
//                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                            let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
//                            VC.modalPresentationStyle = .fullScreen
//                            VC.isFilter = "1"
//                            VC.currentInventoryResult = filtersDataArray
//                            self.present(VC, animated: true, completion: nil)

                    }else if(self.moduleStatusStr == "shoppingCart"){
                        
                        filtersDataArray = dataDict.value(forKey: "shoppingCartresult") as! NSMutableArray
                        
//                        shoppingCartResult = respVo.result!
                        
                        self.delegate1?.sendShoppingLocalSearchDetailsData(dataArray: filtersDataArray, statusStr: "Shopping")
                        
//                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                        let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingVC") as! ShoppingViewController
//                        VC.modalPresentationStyle = .fullScreen
//                        VC.isFilter = "1"
//                        VC.shoppingCartResult = shoppingCartResult
//                        self.present(VC, animated: true, completion: nil)

                    }
                    
                    if(self.moduleStatusStr == "currentInventory"){
                        
                        if(filtersDataArray.count == 0){
                            
                            self.showAlertWith(title: "Alert", message: "No data found")
                            return
                        }
                    }else{
                        
                        if(filtersDataArray.count == 0){
                            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
