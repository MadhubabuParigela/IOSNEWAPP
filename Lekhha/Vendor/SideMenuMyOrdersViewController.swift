//
//  SideMenuMyOrdersViewController.swift
//  LekhaLatest
//
//  Created by USM on 12/05/21.
//

import UIKit
import ObjectMapper
import CoreLocation

class SideMenuMyOrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var activeBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    @IBOutlet weak var cancelledBtn: UIButton!
    
    var bottomView = SideMenuMyOrdersBottomView()
    var sideMenuView = SideMenuView()
    
    var tabKeyValueStr = "Active"
    var isTransactionByStr = String()
    var filterKeyStr = ""
    
    var startDateStr = ""
    var endDateStr = ""
    
    var isActive = "Active"
    
    var isStartDateStr = "0"
    
    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
    var picker : UIDatePicker = UIDatePicker()
    var isSearchBtnTapped = Bool()

    @IBAction func cancelledBtnTap(_ sender: Any) {
        
        isActive = "Cancelled"
        tabKeyValueStr = "Cancelled"
        
        cancelledBtn.backgroundColor = hexStringToUIColor(hex: "ffffff")
        completedBtn.backgroundColor = hexStringToUIColor(hex: "598ff4")
        activeBtn.backgroundColor = hexStringToUIColor(hex: "598ff4")
        
        cancelledBtn.setTitleColor(hexStringToUIColor(hex: "0f5fee"), for: .normal)
        completedBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        activeBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)

        orderListArray = NSMutableArray()
        getCancelledOrdersListAPI()
    }
    
    @IBAction func completedBtnTap(_ sender: Any) {
        
        isActive = "Completed"
        tabKeyValueStr = "Completed"
        
        completedBtn.backgroundColor = hexStringToUIColor(hex: "ffffff")
        activeBtn.backgroundColor = hexStringToUIColor(hex: "598ff4")
        cancelledBtn.backgroundColor = hexStringToUIColor(hex: "598ff4")
        
        completedBtn.setTitleColor(hexStringToUIColor(hex: "0f5fee"), for: .normal)
        activeBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        cancelledBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        
        orderListArray = NSMutableArray()
        getCompletedOrdersListAPI()
    }
    
    @IBAction func activeBtnTap(_ sender: Any) {
        
        isActive = "Active"
        tabKeyValueStr = "Active"
        
        activeBtn.backgroundColor = hexStringToUIColor(hex: "ffffff")
        completedBtn.backgroundColor = hexStringToUIColor(hex: "598ff4")
        cancelledBtn.backgroundColor = hexStringToUIColor(hex: "598ff4")
        
        activeBtn.setTitleColor(hexStringToUIColor(hex: "0f5fee"), for: .normal)
        completedBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        cancelledBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        
        orderListArray = NSMutableArray()
        getActiveOrdersListAPI()
    }
    
    

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var orderListTblView: UITableView!
    
    var accountID = String()
    var serviceCntrl =  ServiceController()
    var emptyMsgBtn = UIButton()
    var orderListArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        orderListTblView.delegate = self
        orderListTblView.dataSource = self
        
        searchTF.delegate = self
        
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: searchTF.frame.size.width - (80), y: 0, width: 80, height: searchTF.frame.size.height)
        searchTF.rightView = paddingView
        searchTF.rightViewMode = UITextField.ViewMode.always
        
        let filterBtn = UIButton()
        filterBtn.frame = CGRect(x: 10, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
        paddingView.addSubview(filterBtn)
        filterBtn.addTarget(self, action: #selector(filterBtnTapped), for: .touchUpInside)
        
        let searchBtn = UIButton()
        searchBtn.frame = CGRect(x: 40, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        searchBtn.setImage(UIImage.init(named: "search"), for: .normal)
        paddingView.addSubview(searchBtn)
        searchBtn.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)

        orderListTblView.register(UINib(nibName: "VendorOrdersDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "VendorOrdersDetailsTableViewCell")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(tabKeyValueStr == "Active"){
            getActiveOrdersListAPI()

        }else if(tabKeyValueStr == "Completed"){
            getCompletedOrdersListAPI()
            
        }else{
            getCancelledOrdersListAPI()
        }
    }
    
    @IBAction func menuOrderBtnTapped(_ sender: Any) {
        toggleSideMenuViewWithAnimation()
    }
    
    @objc func searchBtnTapped(){
        isSearchBtnTapped = true
        filterApplyAPI()
        
    }
    
    @objc func filterBtnTapped()  {
        
        isSearchBtnTapped = false
        toggleLocalSortViewWithAnimation()
        
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
    
    //****************** TableView Delegate Methods*************************//
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return orderListArray.count
         
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = orderListTblView.dequeueReusableCell(withIdentifier: "VendorOrdersDetailsTableViewCell", for: indexPath) as! VendorOrdersDetailsTableViewCell
         
         let dataDict = orderListArray.object(at: indexPath.row) as? NSDictionary
        
        let accDict = dataDict?.value(forKey: "accountDetails") as? NSDictionary
         
         cell.orderIDLbl.text = dataDict?.value(forKey: "orderId") as? String
         cell.productCountLbl.text = ""
         cell.orderPriceLbl.text = ""
//         cell.doorDeliveryLbl.text = ""
         cell.accIDLbl.text = dataDict?.value(forKey: "accountId") as? String
         cell.locationLbl.text = accDict?.value(forKey: "address") as? String
        
        let expiryDate = (dataDict?.value(forKey: "createdDate") as? String) ?? ""
        let convertedExpiryDate = convertServerDateFormatter(date: expiryDate)
        cell.createdDateLbl.text = convertedExpiryDate

        
        let prodCount = dataDict?.value(forKey: "productCount") as? Int
        let orderPrice = dataDict?.value(forKey: "orderPrice") as? Int

        cell.productCountLbl.text = String(prodCount ?? 0)
        cell.orderPriceLbl.text = String(orderPrice ?? 0)
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        let lat: Double = Double("\(pdblLatitude)")!
//        //21.228124
//        let lon: Double = Double("\(pdblLongitude)")!
//        //72.833770
        
        let userDetailsDict = dataDict?.value(forKey: "userDetails") as? NSDictionary
        let locDict = userDetailsDict?.value(forKey: "loc") as? NSDictionary
        
        let corArray = locDict?.value(forKey: "coordinates") as? NSArray
        
        let latDoub = corArray?.object(at: 0) as? Double ?? 0
        let longDoub = corArray?.lastObject as? Double ?? 0

        let latStr = String(latDoub)
        let longStr = String(longDoub)
        
        let lat : Double = latDoub
        let lon : Double = longDoub
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
    
        var addressString : String = ""

        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
//                    print(pm.country)
//                    print(pm.locality)
//                    print(pm.subLocality)
//                    print(pm.thoroughfare)
//                    print(pm.postalCode)
//                    print(pm.subThoroughfare)
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode!  + " "
                    }
                  }
                
                cell.locationLbl.text = addressString

                })

        
        if(isActive == "Active"){
            
            let orderStatus = dataDict?.value(forKey: "orderStatus") as? String
            
            
            if(orderStatus == "Approved"){
                cell.orderStatusImgView.image = UIImage.init(named: "orderAccepted")
                cell.acceptBtn.isHidden = true
                cell.declineBtn.isHidden = true
                
                cell.orderStatusImgView.isHidden = false

                
            }else if(orderStatus == "Rejected"){
                cell.orderStatusImgView.image = UIImage.init(named: "orderRejected")
                cell.acceptBtn.isHidden = true
                cell.declineBtn.isHidden = true
                cell.orderStatusImgView.isHidden = false

            }else{
                
                cell.acceptBtn.isHidden = false
                cell.declineBtn.isHidden = false
                
                cell.acceptBtn.addTarget(self, action: #selector(acceptBtnTap), for: .touchUpInside)
                cell.acceptBtn.tag = indexPath.row

                cell.orderStatusImgView.isHidden = true
                
                cell.declineBtn.addTarget(self, action: #selector(declineBtnTap), for: .touchUpInside)
                cell.declineBtn.tag = indexPath.row

            }
        }else if(isActive == ""){
            
            cell.acceptBtn.isHidden = true
            cell.declineBtn.isHidden = true

            cell.orderStatusImgView.isHidden = true
            
        }else{
            
            cell.acceptBtn.isHidden = true
            cell.declineBtn.isHidden = true

            cell.orderStatusImgView.isHidden = true

        }
         
         return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         let dataDict = orderListArray.object(at: indexPath.row) as? NSDictionary
         
         let orderStatus = dataDict?.value(forKey: "orderStatus") as? String
        
        if(isActive == "Active"){
            
            if(orderStatus == "Rejected"){
                
            }else if(orderStatus == "Approved") {
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyBoard.instantiateViewController(withIdentifier: "VendorOrderDetailsViewController") as! VendorOrderDetailsViewController
                VC.modalPresentationStyle = .fullScreen
                VC.idStr = dataDict?.value(forKey: "_id") as? String ?? ""
                VC.orderStatus = dataDict?.value(forKey: "orderStatus") as? String ?? ""
                VC.isActiveStatusStr = isActive
                self.navigationController?.pushViewController(VC, animated: true)

            }else{
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyBoard.instantiateViewController(withIdentifier: "VendorOrderDetailsViewController") as! VendorOrderDetailsViewController
                VC.modalPresentationStyle = .fullScreen
                VC.idStr = dataDict?.value(forKey: "_id") as? String ?? ""
                VC.orderStatus = dataDict?.value(forKey: "orderStatus") as? String ?? ""
                VC.isActiveStatusStr = "Active"
                self.navigationController?.pushViewController(VC, animated: true)

            }
        
        }else{
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "VendorOrderDetailsViewController") as! VendorOrderDetailsViewController
            VC.modalPresentationStyle = .fullScreen
            VC.idStr = dataDict?.value(forKey: "_id") as? String ?? ""
            VC.orderStatus = dataDict?.value(forKey: "orderStatus") as? String ?? ""
            VC.isActiveStatusStr = isActive
            self.navigationController?.pushViewController(VC, animated: true)

        }

     }
    
    @IBAction func acceptBtnTap(_ sender: UIButton){
        
        let dataDict = orderListArray.object(at: sender.tag) as? NSDictionary

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "VendorOrderDetailsViewController") as! VendorOrderDetailsViewController
        VC.modalPresentationStyle = .fullScreen
        VC.idStr = dataDict?.value(forKey: "_id") as? String ?? ""
        VC.orderStatus = dataDict?.value(forKey: "orderStatus") as? String ?? ""
        VC.isActiveStatusStr = isActive
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBAction func declineBtnTap(_ sender: UIButton){
        
        let dataDict = orderListArray.object(at: sender.tag) as? NSDictionary
        
        let idString = dataDict?.value(forKey: "_id") as? String ?? ""
        declineRequestAPI(idStr: idString)
        
    }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
         
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
         let dataDict = orderListArray.object(at: indexPath.row) as? NSDictionary
         let orderStatus = dataDict?.value(forKey: "orderStatus") as? String
        
        if(isActive == "Active"){
            
            if(orderStatus == "Approved" || orderStatus == "Rejected"){
                return 210

            }else{
                return 260

            }
        }else{
            return 210
        }

     }
    
    func declineRequestAPI(idStr:String) {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + VendorUpdateProductStatusUrl
        
        let params_IndividualLogin = ["_id":idStr,"orderStatus":"Rejected"] as [String : Any]
        
        serviceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: params_IndividualLogin as NSDictionary, successHandler: { (result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {

                                self.showAlertWith(title: "Success", message: "Rejected successfully")
                                
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        if(textField == searchTF){
//            textField.resignFirstResponder()
//            toggleLocalSortViewWithAnimation()
//        }
        
    }
    
    func toggleLocalSortViewWithAnimation() {
        
        filterKeyStr = ""
        startDateStr = ""
        endDateStr = ""

//        bottomView.startDateBtn.setTitle("", for: .normal)
//        bottomView.endDateBtn.setTitle("", for: .normal)
        
        isTransactionByStr = "0"
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("SideMenuMyOrdersBottomView", owner: self, options: nil)
        bottomView = allViewsInXibArray?.first as! SideMenuMyOrdersBottomView
        bottomView.frame = CGRect(x: 0, y: self.view.frame.size.height+350, width: self.view.frame.size.width, height: self.view.frame.size.height)
         self.view.addSubview(bottomView)
        
        bottomView.cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        
        bottomView.startDateBtn.addTarget(self, action: #selector(bottomStartDateBtnTap), for: .touchUpInside)
        
        bottomView.accIdBtn.addTarget(self, action: #selector(bottomAccIDBtnTap), for: .touchUpInside)

        bottomView.orderIdBtn.addTarget(self, action: #selector(bottomOrderIDBtnTap), for: .touchUpInside)


        bottomView.endDateBtn.addTarget(self, action: #selector(bottomEndDateBtnTap), for: .touchUpInside)
        
        bottomView.transactionBtn.addTarget(self, action: #selector(bottomTransactionBtnTap), for: .touchUpInside)

        bottomView.applyBtn.addTarget(self, action: #selector(filterApplyBtnTap), for: .touchUpInside)

    
//        let path = UIBezierPath(roundedRect:bottomView.cardView.bounds,
//                                byRoundingCorners:[.topRight, .topLeft],
//                                cornerRadii: CGSize(width: 20, height:  20))
//
//        let maskLayer = CAShapeLayer()
//
//        maskLayer.path = path.cgPath
//        bottomView.cardView.layer.mask = maskLayer
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.bottomView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.bottomView)
            

         }, completion: { (finished: Bool) -> Void in
            self.bottomView.backHiddenBtn.isHidden = false

         })
        
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

        if(isStartDateStr == "1"){ //Start Btn
            bottomView.startDateBtn.setTitle(result, for: .normal)
            startDateStr = result

        }else{
            bottomView.endDateBtn.setTitle(result, for: .normal)
            endDateStr = result

        }
   }
   
   @objc func dueDateChanged(sender:UIDatePicker){
       
       let dateFormatter = DateFormatter()
       
       dateFormatter.dateFormat = "dd/MM/yyyy"
       let selectedDate = dateFormatter.string(from: picker.date)

       if(isStartDateStr == "1"){ //Start Btn
        bottomView.startDateBtn.setTitle(selectedDate, for: .normal)
        startDateStr = selectedDate
        
       }else {
        bottomView.endDateBtn.setTitle(selectedDate, for: .normal)
        endDateStr = selectedDate
        
       }
   }
   
   @objc func doneBtnTap(_ sender: UIButton) {

       hiddenBtn.removeFromSuperview()
       pickerDateView.removeFromSuperview()
       
   }

    
    @objc func cancelBtnTap(){
        
        bottomView.backHiddenBtn.isHidden = true
        bottomView.removeFromSuperview()
    }
    
    @objc func bottomAccIDBtnTap(){
        
        filterKeyStr = "accountId"
        
        bottomView.accIdBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)
        bottomView.orderIdBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)

    }
    
    @objc func bottomOrderIDBtnTap(){
        
        filterKeyStr = "orderId"

        bottomView.accIdBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
        bottomView.orderIdBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)

    }
    
    @objc func bottomStartDateBtnTap(){
        isStartDateStr = "1"
        
        datePickerView()
    }
    
    @objc func bottomEndDateBtnTap(){
        isStartDateStr = "0"
        datePickerView()

    }
    @objc func filterApplyBtnTap(){
           filterApplyAPI()
        
    }
    
    @objc func bottomTransactionBtnTap(){
       
        if(isTransactionByStr == "0"){
            
            isTransactionByStr = "1"
            bottomView.transactionBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
            
        }else{
            isTransactionByStr = "0"
            bottomView.transactionBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)

        }
    }
    
    func getActiveOrdersListAPI() {
        
        orderListArray = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + VendorActiveOrdersUrl + accountID as String
        serviceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                let dataDict = result as! NSDictionary
                                
                                self.orderListArray = dataDict.value(forKey: "result") as! NSMutableArray
                                self.orderListTblView.reloadData()
                                
                                if(self.orderListArray.count > 0){
                                    self.emptyMsgBtn.removeFromSuperview()
                                    
                                    print(self.accountID)

                                }else if(self.orderListArray.count == 0){
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
        
                       if(self.orderListArray.count == 0){
//                           self.showEmptyMsgBtn()
                    }
            
                }
    
    func getCompletedOrdersListAPI() {
        
        orderListArray = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + VendorCompletedOrdersUrl + accountID as String
        serviceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                let dataDict = result as! NSDictionary
                                
                                self.orderListArray = dataDict.value(forKey: "result") as! NSMutableArray
                                self.orderListTblView.reloadData()
                                
                                if(self.orderListArray.count > 0){
                                    self.emptyMsgBtn.removeFromSuperview()
                                    
                                    print(self.accountID)

                                }else if(self.orderListArray.count == 0){
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
        
                       if(self.orderListArray.count == 0){
                           self.showEmptyMsgBtn()
                    }
            
                }
    
    func getCancelledOrdersListAPI() {
        
        orderListArray = NSMutableArray()

        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + VendorCancelledOrdersUrl + accountID as String
        serviceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                let dataDict = result as! NSDictionary
                                
                                self.orderListArray = dataDict.value(forKey: "result") as! NSMutableArray
                                self.orderListTblView.reloadData()
                                
                                if(self.orderListArray.count > 0){
                                    self.emptyMsgBtn.removeFromSuperview()
                                    
                                    print(self.accountID)

                                }else if(self.orderListArray.count == 0){
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
        
                       if(self.orderListArray.count == 0){
//                           self.showEmptyMsgBtn()
                    }
            
                }
    
    func filterApplyAPI() {
        
        orderListArray = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        let URLString_loginIndividual = Constants.BaseUrl + VendorOrderLocalSearchAPI
        
        let params_IndividualLogin = [
            "accountId":accountID,
            "searchParam":searchTF.text ?? "",
            "filterKey": filterKeyStr,
            "tabKeyValue": tabKeyValueStr,
            "start":startDateStr,
            "end":endDateStr] as [String : Any]
        
        let postHeaders_IndividualLogin = ["":""]
        
        serviceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { [self] (result) in
            
            let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            //                        let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if status == "SUCCESS" {
                
                let dataDict = result as! NSDictionary
                
                self.orderListArray = dataDict.value(forKey: "result") as! NSMutableArray
                self.orderListTblView.reloadData()
                
                filterKeyStr = ""
                startDateStr = ""
                endDateStr = ""
                
                if(self.orderListArray.count > 0){
                    
                    if(isSearchBtnTapped == false){
                        bottomView.backHiddenBtn.isHidden = true
                        bottomView.removeFromSuperview()

                    }

                    
                }else if(orderListArray.count == 0){
                    self.showAlertWith(title: "Alert!!", message: "No Data Found")
                    
                    if(isSearchBtnTapped == false){
                        bottomView.backHiddenBtn.isHidden = true
                        bottomView.removeFromSuperview()

                    }
                }
            }
            else {
                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                
            }
            
        }) { (error) in
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...Please Try Again Later")
        }
        
    }
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
