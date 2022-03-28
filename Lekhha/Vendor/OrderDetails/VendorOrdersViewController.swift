//
//  VendorOrdersViewController.swift
//  LekhaLatest
//
//  Created by USM on 31/03/21.
//

import UIKit
import ObjectMapper
import CoreLocation

class VendorOrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var lookingForTF: UITextField!
    var sideMenuView = SideMenuView()
    var bottomFilterStr = ""
    
    var localSortView = VendorOrdersSortBottomView()
    
    var accountID = String()
    var currentInventoryService = ServiceController()
    var vendorPendingResultsArray = NSMutableArray()
    
    var emptyMsgBtn = UIButton()

    @IBAction func notificationBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        let VC = storyBoard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        VC.modalPresentationStyle = .fullScreen
//            viewCntrlObj.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }
    @IBAction func sortBtnTap(_ sender: Any) {
        toggleLocalSortViewWithAnimation()
        
    }
    @IBAction func sortBottomBtnTap(_ sender: Any) {
        toggleLocalSortViewWithAnimation()
        
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
            let VC = storyBoard.instantiateViewController(withIdentifier: "VendorGlobalSearchViewController") as! VendorGlobalSearchViewController
            VC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(VC, animated: true)
            textField.resignFirstResponder()
        }
    }
    
    @IBOutlet weak var vendorOrderDetailsTblView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        lookingForTF.delegate = self
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        let userDefaults = UserDefaults.standard
        userDefaults.set("Home", forKey: "sideMenuTitle")
        userDefaults.synchronize()
        
        vendorOrderDetailsTblView.delegate = self
        vendorOrderDetailsTblView.dataSource = self
        
        vendorOrderDetailsTblView.register(UINib(nibName: "VendorOrdersDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "VendorOrdersDetailsTableViewCell")
        
        self.navigationController?.navigationBar.isHidden = true
//        vendorOrderDetailsTblView.reloadData()

        deviceInfo_updateAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getOrderDetailsAPI()
    }
    
    func deviceInfo_updateAPI() {
        
//        activity.startAnimating()
//        self.view.isUserInteractionEnabled = false
        
        let defaults = UserDefaults.standard
        var userID = String()
        userID = (defaults.string(forKey: "userID") ?? "")
        
        let URLString_loginIndividual = Constants.BaseUrl + "endusers/deviceInfo_update/\(userID)"
                
        let modelName = UIDevice.modelName
        print("modelName:\(modelName)")
        let deviceVersion = UIDevice.current.systemVersion
        print("deviceVersion:\(deviceVersion)")
//        let typeVendor = UIDevice.current.identifierForVendor
//        print("typeVendor:\(typeVendor)")
        let type = UIDevice.current.type
        print("type:\(type)")
        let name = UIDevice.current.name
        print("name:\(name)")
//        let model = UIDevice.current.model
//        print("model:\(model)")
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let appVersionStr = appVersion ?? ""
        print("appVersionStr:\(appVersionStr)")
        let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let buildVersionStr = appBuild ?? ""
        print("buildVersionStr:\(buildVersionStr)")
        
        let deviceInfoDict = ["appVersion":appVersionStr,"basebandVersion":deviceVersion,"buildNo":buildVersionStr,"deviceName":name,"kernelVersion":deviceVersion,"lattitude":"NA","longitude":"NA","manufacture":"APPLE","model":modelName,"osVersion":deviceVersion,"serial":"unknown"] as [String : Any]
        
//       "basebandVersion":deviceVersion,"buildNo":"\(typeVendor!)","deviceName":name,"kernelVersion":deviceVersion,"manufacture":"APPLE","model":modelName,"osVersion":deviceVersion,"serial":"unknown"
                
        print("deviceInfoDict:\(deviceInfoDict)")
        let params_IndividualLogin = ["loginDeviceInfo":deviceInfoDict]
        
        
        print(params_IndividualLogin)
        let postHeaders_IndividualLogin = ["":""]
        
        currentInventoryService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
            
            let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
//            activity.stopAnimating()
//            self.view.isUserInteractionEnabled = true
            
            if statusCode == 200 {
                if status == "SUCCESS" {
//                    self.view.makeToast(messageResp)
                }
                else {
//                    self.view.makeToast(messageResp)
                }
            }
            else {
//                self.view.makeToast(messageResp)
            }
                        
        }) { (error) in
            
//            activity.stopAnimating()
//            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
          let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 210))
       
       let imgView = UIImageView()
       imgView.frame = CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: 210)
       imgView.image = UIImage.init(named: "homeBackground")
       headerView.addSubview(imgView)
       
        return headerView
   }
   
   //****************** TableView Delegate Methods*************************//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendorPendingResultsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = vendorOrderDetailsTblView.dequeueReusableCell(withIdentifier: "VendorOrdersDetailsTableViewCell", for: indexPath) as! VendorOrdersDetailsTableViewCell
        
        let dataDict = vendorPendingResultsArray.object(at: indexPath.row) as? NSDictionary
        
        let prodCount = dataDict?.value(forKey: "productCount") as? Int
        let orderPrice = dataDict?.value(forKey: "orderPrice") as? Int
         
        let accDetails = dataDict?.value(forKey: "accountDetails") as? NSDictionary
        
        cell.orderIDLbl.text = dataDict?.value(forKey: "orderId") as? String
        cell.productCountLbl.text = String(prodCount ?? 0)
        cell.orderPriceLbl.text = String(orderPrice ?? 0)
        cell.accIDLbl.text = dataDict?.value(forKey: "accountId") as? String
        cell.locationLbl.text = accDetails?.value(forKey: "address") as? String
        
        let userDetailsDict = dataDict?.value(forKey: "userDetails") as? NSDictionary
        let locDict = userDetailsDict?.value(forKey: "loc") as? NSDictionary
        
        let corArray = locDict?.value(forKey: "coordinates") as? NSArray
        
        let latDoub = corArray?.object(at: 0) as? Double ?? 0
        let longDoub = corArray?.lastObject as? Double ?? 0

        let latStr = String(latDoub)
        let longStr = String(longDoub)
        
//        let locationStr = getAddressFromLatLon(pdblLatitude: latStr, withLongitude: longStr)
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        let lat: Double = Double("\(pdblLatitude)")!
//        //21.228124
//        let lon: Double = Double("\(pdblLongitude)")!
//        //72.833770
        
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
                        addressString = addressString + pm.postalCode! + " "
                    }
                  }
                
                cell.locationLbl.text = addressString

                })
        
        
        let expiryDate = (dataDict?.value(forKey: "createdDate") as? String) ?? ""
        let convertedExpiryDate = convertServerDateFormatter(date: expiryDate)
        cell.createdDateLbl.text = convertedExpiryDate
        
        let doorDelivery = dataDict?.value(forKey: "")
        
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

            cell.declineBtn.addTarget(self, action: #selector(declineBtnTap), for: .touchUpInside)
            cell.declineBtn.tag = indexPath.row
            
            cell.orderStatusImgView.isHidden = true
            
        }
        
        return cell
    }
    
    @IBAction func acceptBtnTap(_ sender: UIButton){
        
        let dataDict = vendorPendingResultsArray.object(at: sender.tag) as? NSDictionary

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "VendorOrderDetailsViewController") as! VendorOrderDetailsViewController
        VC.modalPresentationStyle = .fullScreen
        VC.idStr = dataDict?.value(forKey: "_id") as? String ?? ""
        VC.orderStatus = dataDict?.value(forKey: "orderStatus") as? String ?? ""
        VC.isActiveStatusStr = isActive
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
//    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) -> String{
//            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//            let lat: Double = Double("\(pdblLatitude)")!
//            //21.228124
//            let lon: Double = Double("\(pdblLongitude)")!
//            //72.833770
//            let ceo: CLGeocoder = CLGeocoder()
//            center.latitude = lat
//            center.longitude = lon
//
//            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//
//            var addressString : String = ""
//
//            ceo.reverseGeocodeLocation(loc, completionHandler:
//                {(placemarks, error) in
//                    if (error != nil)
//                    {
//                        print("reverse geodcode fail: \(error!.localizedDescription)")
//                    }
//                    let pm = placemarks! as [CLPlacemark]
//
//                    if pm.count > 0 {
//                        let pm = placemarks![0]
//                        print(pm.country)
//                        print(pm.locality)
//                        print(pm.subLocality)
//                        print(pm.thoroughfare)
//                        print(pm.postalCode)
//                        print(pm.subThoroughfare)
//                        if pm.subLocality != nil {
//                            addressString = addressString + pm.subLocality! + ", "
//                        }
//                        if pm.thoroughfare != nil {
//                            addressString = addressString + pm.thoroughfare! + ", "
//                        }
//                        if pm.locality != nil {
//                            addressString = addressString + pm.locality! + ", "
//                        }
//                        if pm.country != nil {
//                            addressString = addressString + pm.country! + ", "
//                        }
//                        if pm.postalCode != nil {
//                            addressString = addressString + pm.postalCode! + " "
//                        }
//
//                        print(addressString)
//
//                  }
//            })
//
//             return addressString
//
//        }
    
    func toggleLocalSortViewWithAnimation() {
        
        bottomFilterStr = ""
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("VendorOrdersSortBottomView", owner: self, options: nil)
        localSortView = allViewsInXibArray?.first as! VendorOrdersSortBottomView
        localSortView.frame = CGRect(x: 0, y: self.view.frame.size.height+350, width: self.view.frame.size.width, height: self.view.frame.size.height)
         self.view.addSubview(localSortView)
        
        localSortView.cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        localSortView.applyBtn.addTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        
        localSortView.recentToOldRadioBtn.addTarget(self, action: #selector(recentToOldBtnTap), for: .touchUpInside)
        localSortView.oldToRecentBtn.addTarget(self, action: #selector(oldToRecentBtnTap), for: .touchUpInside)
        
        localSortView.nearestLocCustBtn.addTarget(self, action: #selector(nearestLocCustBtnTap), for: .touchUpInside)

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
    
    @objc func nearestLocCustBtnTap(){
        
        bottomFilterStr = "nearestlocationnearestlocation"
        
        localSortView.nearestLocCustBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)
        localSortView.oldToRecentBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
        localSortView.recentToOldRadioBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)

    }
    
    @objc func oldToRecentBtnTap(){
        
        bottomFilterStr = "oldtorecent"
        
        localSortView.nearestLocCustBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
        localSortView.oldToRecentBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)
        localSortView.recentToOldRadioBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)

        
    }
    
    @objc func recentToOldBtnTap(){
        
        bottomFilterStr = "recenttoold"
        
        localSortView.nearestLocCustBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
        localSortView.oldToRecentBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
        localSortView.recentToOldRadioBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)

    }
    
    @objc func applyBtnTap(){
        getFilterDetailsAPI()
        
    }
    
    @objc func cancelBtnTap(){
        
        localSortView.backHiddenBtn.isHidden = true
        localSortView.removeFromSuperview()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let dataDict = vendorPendingResultsArray.object(at: indexPath.row) as? NSDictionary
        
        let orderStatus = dataDict?.value(forKey: "orderStatus") as? String

        if(orderStatus == "Rejected"){
            
        }else if(orderStatus == "Approved") {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "VendorOrderDetailsViewController") as! VendorOrderDetailsViewController
            VC.modalPresentationStyle = .fullScreen
            VC.idStr = dataDict?.value(forKey: "_id") as? String ?? ""
            VC.orderStatus = dataDict?.value(forKey: "orderStatus") as? String ?? ""
            VC.isActiveStatusStr = "Active"
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
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dataDict = vendorPendingResultsArray.object(at: indexPath.row) as? NSDictionary
        let orderStatus = dataDict?.value(forKey: "orderStatus") as? String

        if(orderStatus == "Approved" || orderStatus == "Rejected"){
            return 230

        }else{
            return 280

        }
    }

   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 210
       
   }
    
    @IBAction func declineBtnTap(_ sender: UIButton){
        
        let dataDict = vendorPendingResultsArray.object(at: sender.tag) as? NSDictionary
        
        let idString = dataDict?.value(forKey: "_id") as? String ?? ""
        declineRequestAPI(idStr: idString)
        
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
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

    }
    
    func getFilterDetailsAPI() {
        
        vendorPendingResultsArray = NSMutableArray()
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String

        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + OrdersSortUrl + accountID + "/\(userID)" + "/\(bottomFilterStr)"
                            currentInventoryService.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                let dataDict = result as! NSDictionary
                                
                                let dataArray = dataDict.value(forKey: "result") as? NSArray
                                
                                if(dataArray!.count > 0){
                                    self.vendorPendingResultsArray = NSMutableArray()
                                    
                                    self.vendorPendingResultsArray = dataDict.value(forKey: "result") as! NSMutableArray
                                    self.vendorOrderDetailsTblView.reloadData()
                                    
                                    self.localSortView.backHiddenBtn.isHidden = true
                                    self.localSortView.removeFromSuperview()

                                }
                                
                                
                                if(self.vendorPendingResultsArray.count > 0){
                                    self.emptyMsgBtn.removeFromSuperview()
                                    
                                    print(self.accountID)

                                }else if(self.vendorPendingResultsArray.count == 0){
                                    self.showEmptyMsgBtn()
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
        
                       if(self.vendorPendingResultsArray.count == 0){
//                           self.showEmptyMsgBtn()
                    }
            
                }
    
    func declineRequestAPI(idStr:String) {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + VendorUpdateProductStatusUrl
        
        let params_IndividualLogin = ["_id":idStr,"orderStatus":"Rejected"] as [String : Any]
        
        currentInventoryService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: params_IndividualLogin as NSDictionary, successHandler: { (result) in

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
    
    func getOrderDetailsAPI() {
        
        vendorPendingResultsArray.removeAllObjects()
        vendorPendingResultsArray = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
//        sleep(3)

        let URLString_loginIndividual = Constants.BaseUrl + GetVendorPendingListUrl + accountID as String
                            currentInventoryService.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                let dataDict = result as! NSDictionary
                                
                                self.vendorPendingResultsArray = dataDict.value(forKey: "result") as! NSMutableArray
                                self.vendorOrderDetailsTblView.reloadData()
                                
                                if(self.vendorPendingResultsArray.count > 0){
                                    self.emptyMsgBtn.removeFromSuperview()
                                    
                                    print(self.accountID)

                                }
                                else if(self.vendorPendingResultsArray.count == 0){
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
        
                       if(self.vendorPendingResultsArray.count == 0){
//                           self.showEmptyMsgBtn()
                    }
            
                }

}
