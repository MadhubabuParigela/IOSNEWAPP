//
//  EditPermissionsViewController.swift
//  Lekha
//
//  Created by USM on 30/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper

class EditPermissionsViewController: UIViewController {
    
    var servcCntrl = ServiceController()
    var accountID = String()
    
    var idStr = String()
    var mobileNumStr = String()
    var emailAddressStr = String()
    
    var currentInventoryStatusStr = Bool()
    var shoppingCartStatusStr = Bool()
    var openOrdersStatusStr = Bool()
    var ordersHistoryStatusStr = Bool()
    var vendorMasterStatusStr = Bool()
    
    var borrowLentStatusStr = Bool()
    var giveAwayStatusStr = Bool()
    var consumerConnectStatusStr = Bool()
    var masterDataStatusStr = Bool()
    var reportsStatusStr = Bool()
    var shareStatusStr = Bool()
    var vendorConnectStr = Bool()
    
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var vendorConnectBtn: UIButton!
    @IBOutlet weak var consumerConnectBtn: UIButton!
    @IBOutlet weak var giveAwayBtn: UIButton!
    @IBOutlet weak var borrowedLentBtn: UIButton!
    @IBOutlet weak var sahreBtn: UIButton!
    @IBOutlet weak var reportsBtn: UIButton!
    
//    @IBOutlet weak var permissionSV: UIScrollView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var currentInventorySwitchBtn: UIButton!
    
    @IBAction func currentInvSwitchBtnTapped(_ sender: Any) {
        
        if(currentInventoryStatusStr == true){
            currentInventoryStatusStr = false
            currentInventorySwitchBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)

        }else{
            currentInventoryStatusStr = true
            currentInventorySwitchBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)

        }
    }
    
    @IBAction func shoppingCartSwitchBtn(_ sender: Any) {
        
        if(shoppingCartStatusStr == true){
            shoppingCartStatusStr = false
            shoppingSwitchBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
            
        }else{
            shoppingCartStatusStr = true
            shoppingSwitchBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)

        }
    }
    
    @IBOutlet weak var shoppingSwitchBtn: UIButton!
    
    @IBOutlet weak var openOrdersSwitchBtn: UIButton!
    
    @IBAction func openOrdersSwitchBtnTapped(_ sender: Any) {
        
        if(openOrdersStatusStr == true){
            openOrdersStatusStr = false
            openOrdersSwitchBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
            
        }else{
            openOrdersStatusStr = true
            openOrdersSwitchBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)

        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

        
    }
    @IBAction func ordersHistorySwitchBtn(_ sender: Any) {
        
        if(ordersHistoryStatusStr == true){
            ordersHistoryStatusStr = false
            ordersHisSwitchBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
            
        }else{
            ordersHistoryStatusStr = true
            ordersHisSwitchBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)

        }
    }
    
    @IBOutlet weak var ordersHisSwitchBtn: UIButton!
    
    @IBOutlet weak var vendorMastersSwitchBtn: UIButton!
    
    @IBAction func vendorMastersSwitchBtnTap(_ sender: Any) {
        if(vendorMasterStatusStr == true){
            vendorMasterStatusStr = false
            vendorMastersSwitchBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
            
        }else{
            vendorMasterStatusStr = true
            vendorMastersSwitchBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
        }
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        updatePermissionsUrl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        permissionSV.delegate = self
//        if #available(iOS 11.0, *) {
//            self.permissionSV.contentInsetAdjustmentBehavior = .never
//
//        }else{
//            self.automaticallyAdjustsScrollViewInsets = false
//        }
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        updatePermissionsUI()

        // Do any additional setup after loading the view.
    }
    
    //    view Will Layout Subviews
//    override func viewWillLayoutSubviews()
//    {
//        super.viewWillLayoutSubviews();
//        //        scViewHeight.constant = 1200
//        self.permissionSV.contentSize.height = 1200 // Or whatever you want it to be.
//    }
    
    @IBAction func vendorConnectBtnAction(_ sender: Any) {
        
        if(vendorConnectStr == true){
            vendorConnectStr = false
            vendorConnectBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)

        }else{
            vendorConnectStr = true
            vendorConnectBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
        }
    }
    @IBAction func consumerConnectBtnAction(_ sender: Any) {
        
        if(consumerConnectStatusStr == true){
            consumerConnectStatusStr = false
            consumerConnectBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
        }else{
            consumerConnectStatusStr = true
            consumerConnectBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
        }
    }
    @IBAction func giveAwayBtnAction(_ sender: Any) {
        
        if(giveAwayStatusStr == true){
            giveAwayStatusStr = false
            giveAwayBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
        }else{
            giveAwayStatusStr = true
            giveAwayBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
        }
    }
    @IBAction func borrowedLentBtnAction(_ sender: Any) {
        
        if(borrowLentStatusStr == true){
            borrowLentStatusStr = false
            borrowedLentBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
        }else{
            borrowLentStatusStr = true
            borrowedLentBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
        }
    }
    @IBAction func shareBtnAction(_ sender: Any) {
        
        if(shareStatusStr == true){
            shareStatusStr = false
            sahreBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
        }else{
            shareStatusStr = true
            sahreBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
        }
    }
    @IBAction func reportsBtnAction(_ sender: Any) {
        
        if(reportsStatusStr == true){
            reportsStatusStr = false
            reportsBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
        }else{
            reportsStatusStr = true
            reportsBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
        }
    }
    
    @IBAction func dropDownBtnAction(_ sender: UIButton) {
    }
    
    func updatePermissionsUI()  {
        
        if(currentInventoryStatusStr == true){
            currentInventorySwitchBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
            
        }else{
            currentInventorySwitchBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
        }
        
        if(shoppingCartStatusStr == true){
            shoppingSwitchBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
            
        }else{
            shoppingSwitchBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)

        }
        
        if(openOrdersStatusStr == true){
            openOrdersSwitchBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
            
        }else{
            openOrdersSwitchBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)

        }
        
        if(ordersHistoryStatusStr == true){
            ordersHisSwitchBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
            
        }else{
            ordersHisSwitchBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)

        }
        
        if(vendorMasterStatusStr == true){
            vendorMastersSwitchBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
            
        }else{
            vendorMastersSwitchBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)

        }
        
        if(vendorConnectStr == true){
            vendorConnectBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
            
        }else{
            vendorConnectBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)

        }
        if(consumerConnectStatusStr == true){
            consumerConnectBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
            
        }else{
            consumerConnectBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)

        }
        if(giveAwayStatusStr == true){
            giveAwayBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
            
        }else{
            giveAwayBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
        }
        if(borrowLentStatusStr == true){
            borrowedLentBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
            
        }else{
            borrowedLentBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
        }
        if(shareStatusStr == true){
            sahreBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
            
        }else{
            sahreBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
        }
        if(reportsStatusStr == true){
            reportsBtn.setImage(UIImage.init(named: "switchActive"), for: .normal)
            
        }else{
            reportsBtn.setImage(UIImage.init(named: "switchInActive"), for: .normal)
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
    
    func showSucessMsg()  {
        
                let alertController = UIAlertController(title: "Success", message:"Details updated successfully" , preferredStyle: .alert)
                //to change font of title and message.
                let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
                let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Success", attributes: titleFont)
                let messageAttrString = NSMutableAttributedString(string: "Details updated successfully", attributes: messageFont)
                alertController.setValue(titleAttrString, forKey: "attributedTitle")
                alertController.setValue(messageAttrString, forKey: "attributedMessage")
                
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                          let VC = storyBoard.instantiateViewController(withIdentifier: "ApprovalsVC") as! ApprovalsViewController
                          VC.modalPresentationStyle = .fullScreen
//                          self.present(VC, animated: true, completion: nil)
                    self.navigationController?.pushViewController(VC, animated: true)

                
                   
                })
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)

    }
    
    func updatePermissionsUrl() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
            
//        var modulePermissionDict = NSDictionary()
//        modulePermissionDict = ["currentInventory_management": currentInventoryStatusStr,"shoppingCart_management":shoppingCartStatusStr,"openOrders_management":openOrdersStatusStr,"orderHistory_management":ordersHistoryStatusStr,"vendors_management":vendorMasterStatusStr]
        
        let permissionsDict = ["borrow_lent":borrowLentStatusStr,"consumer_connect":consumerConnectStatusStr,"currentInventory_management":currentInventoryStatusStr,"give_away":giveAwayStatusStr,"master_data": vendorMasterStatusStr,"openOrders_management":openOrdersStatusStr,"orderHistory_management":ordersHistoryStatusStr,"report":reportsStatusStr,"share":shareStatusStr,"shoppingCart_management":shoppingCartStatusStr,"vendor_login":vendorMasterStatusStr,"vendor_connect":vendorConnectStr]
        
        let params_IndividualLogin = [
            "_id" : idStr,
            "modulePermissions":permissionsDict,
            "mobileNumber":mobileNumStr,
            "emailAddress":emailAddressStr
        ] as [String : Any]

        let URLString_loginIndividual = Constants.BaseUrl + UpdatePermissionsListUrl 
        
        let postHeaders_IndividualLogin = ["":""]

        
        servcCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                self.showSucessMsg()
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
