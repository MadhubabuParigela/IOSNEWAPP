//
//  ApprovalsViewController.swift
//  Lekha
//
//  Created by Mallesh on 10/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown

class ApprovalsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,sentname,sendDetails{
    
    @IBOutlet weak var historySepLbl: UILabel!
    @IBOutlet weak var approvalSepLbl: UILabel!
    @IBOutlet weak var approvalTblView: UITableView!
    var dropDown=DropDown()
    var approveDataDict = NSDictionary()
    
    let approvalStatusArrPos = Int()
    
    var accountID = String()
    
    let emptyMsgBtn = UIButton()
    
    var tappedIndexPos = Int()
    var tappedStatusStr = String()
    
//    var approvalsListArr = [ApprovalResult]()
    var approvalsListArr = NSMutableArray()
    var approvedHistoryListArr = NSMutableArray()

    var isApprovalList: Bool!
    var approvalsServiceCntrl = ServiceController()
    
    var approvalSubmissionArray = NSMutableArray()
    var permissionStatusArray = NSArray()
    var statusArray = NSArray()

    @objc func dropDownStatus(sender:UIButton)
    {
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
        dict = approvalsListArr[productArrayPosition] as! NSMutableDictionary
       var modulePermissions = approvalSubmissionArray[productArrayPosition] as! NSMutableDictionary
        let permissionsDict = modulePermissions.value(forKey: "modulePermissions") as! NSDictionary
        var statusList = [String]()
        statusList=["Approved","Rejected"]
        
        dropDown.dataSource = statusList//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                dict.setValue(item, forKey: "approvalStatus")
                modulePermissions.setValue(item, forKey: "approvalStatus")
                self?.approvalTblView.reloadData()
            }
    }
    @objc func currentInventoryStatus(sender:UIButton)
    {
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
        dict = approvalSubmissionArray[productArrayPosition] as! NSMutableDictionary
        let permissionsDict = dict.value(forKey: "modulePermissions") as! NSDictionary
        var statusList = [String]()
        statusList=["Yes","No"]
        
        dropDown.dataSource = statusList//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                if item == "Yes"{
                    permissionsDict.setValue(true, forKey: "currentInventory_management")
                }
                else {
                    permissionsDict.setValue(false, forKey: "currentInventory_management")
                }
                dict.setValue(permissionsDict, forKey: "modulePermissions")
                self?.approvalTblView.reloadData()
            }
    }
    @objc func shoppingCartStatus(sender:UIButton)
    {
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
        dict = approvalSubmissionArray[productArrayPosition] as! NSMutableDictionary
        let permissionsDict = dict.value(forKey: "modulePermissions") as! NSDictionary
        var statusList = [String]()
        statusList=["Yes","No"]
        
        dropDown.dataSource = statusList//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                if item == "Yes"{
                    permissionsDict.setValue(true, forKey: "shoppingCart_management")
                }
                else {
                    permissionsDict.setValue(false, forKey: "shoppingCart_management")
                }
                dict.setValue(permissionsDict, forKey: "modulePermissions")
                self?.approvalTblView.reloadData()
            }
    }
    @objc func openOrdersStatus(sender:UIButton)
    {
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
        dict = approvalSubmissionArray[productArrayPosition] as! NSMutableDictionary
        let permissionsDict = dict.value(forKey: "modulePermissions") as! NSDictionary
        var statusList = [String]()
        statusList=["Yes","No"]
        
        dropDown.dataSource = statusList//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                if item == "Yes"{
                    permissionsDict.setValue(true, forKey: "openOrders_management")
                }
                else {
                    permissionsDict.setValue(false, forKey: "openOrders_management")
                }
                dict.setValue(permissionsDict, forKey: "modulePermissions")
                self?.approvalTblView.reloadData()
            }
    }
    @objc func orderHistoryStatus(sender:UIButton)
    {
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
        dict = approvalSubmissionArray[productArrayPosition] as! NSMutableDictionary
        let permissionsDict = dict.value(forKey: "modulePermissions") as! NSDictionary
        var statusList = [String]()
        statusList=["Yes","No"]
        
        dropDown.dataSource = statusList//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                if item == "Yes"{
                    permissionsDict.setValue(true, forKey: "orderHistory_management")
                }
                else {
                    permissionsDict.setValue(false, forKey: "orderHistory_management")
                }
                dict.setValue(permissionsDict, forKey: "modulePermissions")
                self?.approvalTblView.reloadData()
            }
    }
    @objc func masterDateStatus(sender:UIButton)
    {
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
        dict = approvalSubmissionArray[productArrayPosition] as! NSMutableDictionary
        let permissionsDict = dict.value(forKey: "modulePermissions") as! NSDictionary
        var statusList = [String]()
        statusList=["Yes","No"]
        
        dropDown.dataSource = statusList//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                if item == "Yes"{
                    permissionsDict.setValue(true, forKey: "master_data")
                }
                else {
                    permissionsDict.setValue(false, forKey: "master_data")
                }
                dict.setValue(permissionsDict, forKey: "modulePermissions")
                self?.approvalTblView.reloadData()
            }
    }
    @objc func giveAwayStatus(sender:UIButton)
    {
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
        dict = approvalSubmissionArray[productArrayPosition] as! NSMutableDictionary
        let permissionsDict = dict.value(forKey: "modulePermissions") as! NSDictionary
        var statusList = [String]()
        statusList=["Yes","No"]
        
        dropDown.dataSource = statusList//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                if item == "Yes"{
                    permissionsDict.setValue(true, forKey: "give_away")
                }
                else {
                    permissionsDict.setValue(false, forKey: "give_away")
                }
                dict.setValue(permissionsDict, forKey: "modulePermissions")
                self?.approvalTblView.reloadData()
            }
    }
    @objc func consumerConnectStatus(sender:UIButton)
    {
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
        dict = approvalSubmissionArray[productArrayPosition] as! NSMutableDictionary
        let permissionsDict = dict.value(forKey: "modulePermissions") as! NSDictionary
        var statusList = [String]()
        statusList=["Yes","No"]
        
        dropDown.dataSource = statusList//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                if item == "Yes"{
                    permissionsDict.setValue(true, forKey: "consumer_connect")
                }
                else {
                    permissionsDict.setValue(false, forKey: "consumer_connect")
                }
                dict.setValue(permissionsDict, forKey: "modulePermissions")
                self?.approvalTblView.reloadData()
            }
    }
    @objc func vendorConnectStatus(sender:UIButton)
    {
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
        dict = approvalSubmissionArray[productArrayPosition] as! NSMutableDictionary
        let permissionsDict = dict.value(forKey: "modulePermissions") as! NSDictionary
        var statusList = [String]()
        statusList=["Yes","No"]
        
        dropDown.dataSource = statusList//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                if item == "Yes"{
                    permissionsDict.setValue(true, forKey: "vendor_connect")
                }
                else {
                    permissionsDict.setValue(false, forKey: "vendor_connect")
                }
                dict.setValue(permissionsDict, forKey: "modulePermissions")
                self?.approvalTblView.reloadData()
            }
    }
    @objc func borrowLentStatus(sender:UIButton)
    {
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
        dict = approvalSubmissionArray[productArrayPosition] as! NSMutableDictionary
        let permissionsDict = dict.value(forKey: "modulePermissions") as! NSDictionary
        var statusList = [String]()
        statusList=["Yes","No"]
        
        dropDown.dataSource = statusList//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                if item == "Yes"{
                    permissionsDict.setValue(true, forKey: "borrow_lent")
                }
                else {
                    permissionsDict.setValue(false, forKey: "borrow_lent")
                }
                dict.setValue(permissionsDict, forKey: "modulePermissions")
                self?.approvalTblView.reloadData()
            }
    }
    @objc func shareStatus(sender:UIButton)
    {
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
        dict = approvalSubmissionArray[productArrayPosition] as! NSMutableDictionary
        let permissionsDict = dict.value(forKey: "modulePermissions") as! NSDictionary
        var statusList = [String]()
        statusList=["Yes","No"]
        
        dropDown.dataSource = statusList//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                if item == "Yes"{
                    permissionsDict.setValue(true, forKey: "share")
                }
                else {
                    permissionsDict.setValue(false, forKey: "share")
                }
                dict.setValue(permissionsDict, forKey: "modulePermissions")
                self?.approvalTblView.reloadData()
            }
    }
    @IBAction func backBtnTap(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
        self.navigationController?.pushViewController(VC, animated: true)

    }
    @IBAction func approvalListBtnTap(_ sender: Any) {
        
//        shoppingCartBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
//        savedProducts.titleLabel?.font = UIFont.init(name: kAppFont, size: 13)
//
        historySepLbl.isHidden = true
        approvalSepLbl.isHidden = false
        
        isApprovalList = true
        self.getApprovalsListAPI()
        
//        approvalTblView.reloadData()
        
    }
    
    @IBAction func historySecBtnTap(_ sender: Any) {
        
        emptyMsgBtn.removeFromSuperview()
        
        historySepLbl.isHidden = false
        approvalSepLbl.isHidden = true
        
        isApprovalList = false
        
        self.getHistoryListAPI()
        
//        approvalTblView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        permissionStatusArray = ["Yes","No"]
        statusArray = ["Approved","Rejected"]
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        isApprovalList = true
        
        approvalTblView.delegate = self
        approvalTblView.dataSource = self
        
        approvalTblView.register(UINib(nibName: "HistoryReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryReviewsTableViewCell")
        
        approvalTblView.register(UINib(nibName: "ApprovalTableViewCell", bundle: nil), forCellReuseIdentifier: "ApprovalTableViewCell")
        
        animatingView()
        // Do any additional setup after loading the view.
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getApprovalsListAPI()
        animatingView()
    }

    
    func addEmptyApprovalsData()  {
        
        for i in 0..<approvalsListArr.count {
            
            let dataDict = approvalsListArr.object(at: i) as! NSDictionary
            let accDetails = dataDict.value(forKey: "accountDetails") as! NSDictionary
            
//            let userDetailsArr = dataDict.value(forKey: "userDetails") as! NSArray
            let userDetailsDict = dataDict.value(forKey: "userDetails") as! NSDictionary

            let approvalDict = NSMutableDictionary()
            let approvalPermissionDict = NSMutableDictionary()
            
            approvalDict .setValue(dataDict.value(forKey: "_id") as! String , forKey: "_id")
            approvalDict .setValue(dataDict.value(forKey: "approvalStatus") as! String, forKey: "approvalStatus")
            approvalDict .setValue(userDetailsDict.value(forKey: "mobileNumber") as! String, forKey: "mobileNumber")
            approvalDict .setValue(accDetails.value(forKey: "emailAddress") as! String, forKey: "emailAddress")
            approvalDict .setValue("", forKey: "comments")
    
    approvalPermissionDict .setValue(true, forKey: "currentInventory_management")
    approvalPermissionDict .setValue(true, forKey: "openOrders_management")
    approvalPermissionDict .setValue(true, forKey: "shoppingCart_management")
    approvalPermissionDict .setValue(true, forKey: "orderHistory_management")
    approvalPermissionDict .setValue(true, forKey: "master_data")
    approvalPermissionDict .setValue(true, forKey: "give_away")
    approvalPermissionDict .setValue(true, forKey: "consumer_connect")
    approvalPermissionDict .setValue(true, forKey: "vendor_connect")
    approvalPermissionDict .setValue(true, forKey: "borrow_lent")
    approvalPermissionDict .setValue(true, forKey: "share")
    approvalPermissionDict .setValue(true, forKey: "report")
    approvalDict .setValue(approvalPermissionDict, forKey: "modulePermissions")
            approvalSubmissionArray.add(approvalDict)

        }
        
        self.approvalTblView.reloadData()

    }
    
    func sendnamedfields(fieldname: String, idStr: String) {
        
        var permissionDict = approvalSubmissionArray.object(at: tappedIndexPos) as! NSDictionary
        
        var modulePermissionDict = permissionDict.value(forKey: "modulePermissions") as! NSDictionary
        
        if(tappedStatusStr == "currentInv"){
            
            if fieldname == "Yes" {
                
                modulePermissionDict .setValue(true, forKey: "currentInventory_management")
            }
            else {
                
                modulePermissionDict .setValue(false, forKey: "currentInventory_management")
            }
            
        }else if(tappedStatusStr == "ShoppingCart"){
            if fieldname == "Yes" {
                
                modulePermissionDict .setValue(true, forKey: "shoppingCart_management")
            }
            else {
                
                modulePermissionDict.setValue(false, forKey: "shoppingCart_management")
            }

        }else if(tappedStatusStr == "openOrders"){
            if fieldname == "Yes" {
                
                modulePermissionDict.setValue(true, forKey: "openOrders_management")
            }
            else {
                
                modulePermissionDict.setValue(false, forKey: "openOrders_management")
            }

        }else if(tappedStatusStr == "ordersHistory"){
            if fieldname == "Yes" {
                
                modulePermissionDict .setValue(true, forKey: "orderHistory_management")
            }
            else {
                
                modulePermissionDict .setValue(false, forKey: "orderHistory_management")
            }

        }else if(tappedStatusStr == "vendorMaster"){
            if fieldname == "Yes" {
                
                modulePermissionDict .setValue(true, forKey: "vendors_management")
            }
            else {
                
                modulePermissionDict .setValue(false, forKey: "vendors_management")
            }

        }else{
            
            if(fieldname == "Approve"){
                permissionDict.setValue("Approved", forKey: "approvalStatus")

            }else{
                permissionDict.setValue("Rejected", forKey: "approvalStatus")

            }
            
            
            let dataDict = approvalsListArr.object(at: tappedIndexPos) as! NSMutableDictionary
            dataDict.setValue(fieldname, forKey: "approvalStatus")
            approvalsListArr.replaceObject(at: tappedIndexPos, with: dataDict)
            approvalTblView.reloadData()
            
        }
        
        permissionDict.setValue(modulePermissionDict, forKey: "modulePermissions")
        
        approvalSubmissionArray.replaceObject(at: tappedIndexPos, with: permissionDict)
        approvalTblView.reloadData()
        
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }
    
    func details(titlename: String, type: String, countrycode: String) {
        
    }
    
    
    func sendnamedfields(fieldname: String,iscategoty:Bool,isyrf:Bool,iseposter:Bool) {
        dismiss(animated: true, completion: nil)

    }
    
    //****************** TableView Delegate Methods*************************//
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isApprovalList){
            return approvalsListArr.count

        }else{
            return approvedHistoryListArr.count

        }
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(isApprovalList){
            
            print(approvalsListArr)
            
            let cell = approvalTblView.dequeueReusableCell(withIdentifier: "ApprovalTableViewCell", for: indexPath) as! ApprovalTableViewCell
            
            cell.userCountLabel.text="User "+String(indexPath.row+1)
            let dataDict = approvalsListArr.object(at: indexPath.row) as! NSDictionary
            _ = dataDict.value(forKey: "accountDetails") as! NSDictionary
            
//            let userDetailsArr = dataDict.value(forKey: "userDetails") as! NSArray
            let userDetailsDict = dataDict.value(forKey: "userDetails") as! NSDictionary
            
//            let userDetails = approvalsListArr[indexPath.row].userDetails!
            
            let fistStr = userDetailsDict.value(forKey: "firstName") as! String
            let lastStr = userDetailsDict.value(forKey: "lastName") as! String
//
            cell.userNameTF.text = fistStr + " " + lastStr
           // cell.userIdTF.text = userDetailsDict.value(forKey: "userId") as? String;
            cell.mobileNumTF.text = userDetailsDict.value(forKey: "mobileNumber") as? String
            
            let detailsDict = approvalSubmissionArray[indexPath.row] as! NSDictionary


            cell.commentsTxtView.text = (detailsDict.value(forKey: "comments") as! String)

            let permissionsDict = detailsDict.value(forKey: "modulePermissions") as! NSDictionary

            if permissionsDict.value(forKey: "currentInventory_management") as? Bool == true {
                
                cell.currentInventoryBtn.setTitle("Yes", for: .normal)
            }
            else {
                cell.currentInventoryBtn.setTitle("No", for: .normal)
            }
            
            if permissionsDict.value(forKey: "shoppingCart_management") as? Bool == true {
                
                cell.shoppingCartBtn.setTitle("Yes", for: .normal)
            }
            else {
                cell.shoppingCartBtn.setTitle("No", for: .normal)
            }
            if permissionsDict.value(forKey: "openOrders_management") as? Bool == true {
                
                cell.openOrdersBtn.setTitle("Yes", for: .normal)
            }
            else {
                cell.openOrdersBtn.setTitle("No", for: .normal)
            }
            if permissionsDict.value(forKey: "orderHistory_management") as? Bool == true {
                
                cell.orderHistoryBtn.setTitle("Yes", for: .normal)
            }
            else {
                cell.orderHistoryBtn.setTitle("No", for: .normal)
            }
            
            if permissionsDict.value(forKey: "master_data") as? Bool == true {
                
                cell.vendorMastersBtn.setTitle("Yes", for: .normal)
            }
            else {
                cell.vendorMastersBtn.setTitle("No", for: .normal)
            }
            if permissionsDict.value(forKey: "give_away") as? Bool == true {
                
                cell.giveAwayBtn.setTitle("Yes", for: .normal)
            }
            else {
                cell.giveAwayBtn.setTitle("No", for: .normal)
            }
            if permissionsDict.value(forKey: "consumer_connect") as? Bool == true {
                
                cell.consumerConnectBtn.setTitle("Yes", for: .normal)
            }
            else {
                cell.consumerConnectBtn.setTitle("No", for: .normal)
            }
            if permissionsDict.value(forKey: "vendor_connect") as? Bool == true {
                
                cell.vendorConnectBtn.setTitle("Yes", for: .normal)
            }
            else {
                cell.vendorConnectBtn.setTitle("No", for: .normal)
            }
            if permissionsDict.value(forKey: "borrow_lent") as? Bool == true {
                
                cell.borrowBtn.setTitle("Yes", for: .normal)
            }
            else {
                cell.borrowBtn.setTitle("No", for: .normal)
            }
            if permissionsDict.value(forKey: "share") as? Bool == true {
                
                cell.shareBtn.setTitle("Yes", for: .normal)
            }
            else {
                cell.shareBtn.setTitle("No", for: .normal)
            }
            if permissionsDict.value(forKey: "report") as? Bool == true {
                
                cell.reportBtn.setTitle("Yes", for: .normal)
            }
            else {
                cell.reportBtn.setTitle("No", for: .normal)
            }
            let expiryDate = dataDict.value(forKey: "dateOfCreation") as? String
            
            //let convertedExpiryDate = convertDateTimeFormatter(date: expiryDate)
            let dateee=convertDateFormatter1(date: expiryDate ?? "")
            cell.dateTimeTF.text = dateee
            cell.statusBtn.tag=indexPath.row
            cell.statusBtn.setTitle(dataDict.value(forKey: "approvalStatus") as? String, for: .normal)
            cell.statusBtn.addTarget(self, action: #selector(dropDownStatus), for: .touchUpInside)
            let approvalsStatus = dataDict.value(forKey: "approvalStatus") as? String
//            cell.statusLbl.text = dataDict.value(forKey: "approvalStatus") as? String

            if(approvalsStatus == "Pending"){
                cell.statusBtn.setTitle("Select", for: .normal)

            }
            
            cell.currentInventoryBtn.tag = indexPath.row
            cell.shoppingCartBtn.tag = indexPath.row
            cell.openOrdersBtn.tag = indexPath.row
            cell.orderHistoryBtn.tag = indexPath.row
            cell.vendorMastersBtn.tag = indexPath.row

            cell.currentInventoryBtn.addTarget(self, action: #selector(currentInventoryStatus(sender:)), for: .touchUpInside)
            cell.shoppingCartBtn.addTarget(self, action: #selector(shoppingCartStatus(sender:)), for: .touchUpInside)
            cell.openOrdersBtn.addTarget(self, action: #selector(openOrdersStatus(sender:)), for: .touchUpInside)
            cell.orderHistoryBtn.addTarget(self, action: #selector(orderHistoryStatus(sender:)), for: .touchUpInside)
            cell.vendorMastersBtn.addTarget(self, action: #selector(masterDateStatus(sender:)), for: .touchUpInside)
            cell.giveAwayBtn.addTarget(self, action: #selector(giveAwayStatus(sender:)), for: .touchUpInside)
            cell.consumerConnectBtn.addTarget(self, action: #selector(consumerConnectStatus(sender:)), for: .touchUpInside)
            cell.vendorConnectBtn.addTarget(self, action: #selector(vendorConnectStatus(sender:)), for: .touchUpInside)
            cell.borrowBtn.addTarget(self, action: #selector(borrowLentStatus(sender:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(shareStatus(sender:)), for: .touchUpInside)
            cell.submitBtn.tag=indexPath.row
            cell.submitBtn.addTarget(self, action: #selector(submitBtnTapped), for: .touchUpInside)

            
            return cell
            
        }else{

            let cell = approvalTblView.dequeueReusableCell(withIdentifier: "HistoryReviewsTableViewCell", for: indexPath) as! HistoryReviewsTableViewCell
            
            cell.userCountL.text="User "+String(indexPath.row+1)
            let dataDict = approvedHistoryListArr.object(at: indexPath.row) as! NSDictionary
            _ = dataDict.value(forKey: "accountDetails") as! NSDictionary
            
//            let userDetailsArr = dataDict.value(forKey: "userDetails") as! NSArray
            let userDetailsDict = dataDict.value(forKey: "userDetails") as! NSDictionary

            let modulePermissionsDict = dataDict.value(forKey: "modulePermissions") as! NSDictionary

            let firstN=userDetailsDict.value(forKey: "firstName") as? String ?? ""
                let secondN=userDetailsDict.value(forKey: "lastName") as? String ?? ""
            cell.userNameLbl.text = firstN + " " + secondN
            cell.userIdLbl.text = userDetailsDict.value(forKey: "userId") as? String
            cell.mobileNumlbl.text = userDetailsDict.value(forKey: "mobileNumber") as? String
            
            let expiryDate = dataDict.value(forKey: "dateOfCreation") as? String
            let dateee=convertDateFormatter1(date: expiryDate ?? "")
            cell.dateLbl.text = dateee

            let approvalsStatus = dataDict.value(forKey: "approvalStatus") as? String
            cell.statusLbl.text = dataDict.value(forKey: "approvalStatus") as? String

            if(approvalsStatus == "Rejected"){
                cell.statusLbl.textColor = hexStringToUIColor(hex: "e16380")
                cell.editBtn.isHidden = true
            }
            if(approvalsStatus == "Approved"){
                cell.statusLbl.textColor = hexStringToUIColor(hex: "50DA76")
                cell.editBtn.isHidden = false
            }
            
            let commentStr = dataDict.value(forKey: "comments") as? String
            cell.commentsLbl.text = dataDict.value(forKey: "comments") as? String

            if(commentStr == ""){
                cell.commentsLbl.isHidden = true
                cell.commentsTitleLbl.isHidden = true
                
                cell.permissionsYConstant.constant = 0
                cell.editBtnYConstant.constant = 0
            }
            
            if modulePermissionsDict.value(forKey: "currentInventory_management") as? Bool == true {
                
                cell.currentInventoryLbl.text = "Yes"
            }
            else {
                cell.currentInventoryLbl.text = "No"
            }
            
            if modulePermissionsDict.value(forKey: "shoppingCart_management") as? Bool == true {
                
                cell.shoppingCartLbl.text = "Yes"
            }
            else {
                cell.shoppingCartLbl.text = "No"
            }
            if modulePermissionsDict.value(forKey: "openOrders_management") as? Bool == true {
                
                cell.openOrderslbl.text = "Yes"
            }
            else {
                cell.openOrderslbl.text = "No"
            }
            if modulePermissionsDict.value(forKey: "orderHistory_management") as? Bool == true {
                
                cell.orderHistoryLbl.text = "Yes"
            }
            else {
                cell.orderHistoryLbl.text = "No"
            }
            
            if modulePermissionsDict.value(forKey: "master_data") as? Bool == true {
                
                cell.vendorMastersLbl.text = "Yes"
            }
            else {
                cell.vendorMastersLbl.text = "No"
            }
            if modulePermissionsDict.value(forKey: "give_away") as? Bool == true {
                
                cell.giveAwaylbl.text = "Yes"
            }
            else {
                cell.giveAwaylbl.text = "No"
            }
            if modulePermissionsDict.value(forKey: "vendor_connect") as? Bool == true {
                
                cell.vendorConnectLbl.text = "Yes"
            }
            else {
                cell.vendorConnectLbl.text = "No"
            }
            if modulePermissionsDict.value(forKey: "consumer_connect") as? Bool == true {
                
                cell.consumerConnectLbl.text = "Yes"
            }
            else {
                cell.consumerConnectLbl.text = "No"
            }
            if modulePermissionsDict.value(forKey: "borrow_lent") as? Bool == true {
                
                cell.borrowedLbl.text = "Yes"
            }
            else {
                cell.borrowedLbl.text = "No"
            }
            if modulePermissionsDict.value(forKey: "share") as? Bool == true {
                
                cell.shareLbl.text = "Yes"
            }
            else {
                cell.shareLbl.text = "No"
            }
            if modulePermissionsDict.value(forKey: "report") as? Bool == true {
                
                cell.reportsLbl.text = "Yes"
            }
            else {
                cell.reportsLbl.text = "No"
            }
            
            cell.editBtn.tag = indexPath.row
            cell.editBtn.addTarget(self, action: #selector(editBtnTap), for: .touchUpInside)

            return cell

        }
        
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(isApprovalList){
            return 920

        }else{
            let dataDict = approvedHistoryListArr.object(at: indexPath.row) as! NSDictionary
            
            let commentStr = dataDict.value(forKey: "comments") as? String

            if(commentStr == ""){
                return 600

            }else{
                return 580

            }
        }
    }
    
    
    @objc func editBtnTap(sender:UIButton){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "EditPermissionsViewController") as! EditPermissionsViewController
        VC.modalPresentationStyle = .fullScreen
        
        let dataDict = approvedHistoryListArr.object(at: sender.tag) as! NSDictionary
        _ = dataDict.value(forKey: "accountDetails") as! NSDictionary
        
//        let userDetailsArr = dataDict.value(forKey: "userDetails") as! NSArray
        let userDetailsDict = dataDict.value(forKey: "userDetails") as! NSDictionary

        let modulePermissionsDict = dataDict.value(forKey: "modulePermissions") as! NSDictionary
        
        VC.idStr = dataDict.value(forKey: "_id") as! String
        VC.emailAddressStr = dataDict.value(forKey: "emailAddress") as! String
        VC.mobileNumStr = dataDict.value(forKey: "mobileNumber") as! String
        
        VC.currentInventoryStatusStr = modulePermissionsDict.value(forKey: "currentInventory_management") as? Bool ?? true
        VC.shoppingCartStatusStr = modulePermissionsDict.value(forKey: "shoppingCart_management") as? Bool ?? true
        VC.openOrdersStatusStr = modulePermissionsDict.value(forKey: "openOrders_management") as? Bool ?? true
        VC.ordersHistoryStatusStr = modulePermissionsDict.value(forKey: "orderHistory_management") as? Bool ?? true
        VC.vendorMasterStatusStr = modulePermissionsDict.value(forKey: "master_data") as? Bool ?? true
        
        VC.giveAwayStatusStr = modulePermissionsDict.value(forKey: "give_away") as? Bool ?? true
        VC.vendorConnectStr = modulePermissionsDict.value(forKey: "vendor_connect") as? Bool ?? true
        VC.consumerConnectStatusStr = modulePermissionsDict.value(forKey: "consumer_connect") as? Bool ?? true
        VC.borrowLentStatusStr = modulePermissionsDict.value(forKey: "borrow_lent") as? Bool ?? true
        VC.shareStatusStr = modulePermissionsDict.value(forKey: "share") as? Bool ?? true
        VC.reportsStatusStr = modulePermissionsDict.value(forKey: "report") as? Bool ?? true
        
      self.navigationController?.pushViewController(VC, animated: true)
//        self.present(VC, animated: true, completion: nil)

    }
    
    @IBAction func statusBtnTap(_ sender: UIButton){

        tappedIndexPos = sender.tag
        tappedStatusStr = "status"
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select Status"
        viewTobeLoad.fields = self.statusArray as! [String]
        viewTobeLoad.categoryIDs = self.statusArray as! [String]
        viewTobeLoad.modalPresentationStyle = .fullScreen
//        self.present(viewTobeLoad, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)


    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton){
        
        approveDataDict = approvalSubmissionArray.object(at: sender.tag) as! NSDictionary
        
        let approvalStatus = approveDataDict.value(forKey: "approvalStatus") as? String
        
        if(approvalStatus == "Pending"){
            self.showAlertWith(title: "Alert", message: "Please change the approval status")
            return
        }
        
        self.ApproveRejectAPI()
    }
    
    @IBAction func currentInventoryBtnTap(_ sender: UIButton){
        
        tappedIndexPos = sender.tag
        tappedStatusStr = "currentInv"
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select"
        viewTobeLoad.fields = self.permissionStatusArray as! [String]
        viewTobeLoad.categoryIDs = self.permissionStatusArray as! [String]
        viewTobeLoad.modalPresentationStyle = .fullScreen
//        self.present(viewTobeLoad, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

    }
    @IBAction func shoppingCartBtnTap(_ sender: UIButton){
        
        tappedIndexPos = sender.tag
        tappedStatusStr = "ShoppingCart"
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select"
        viewTobeLoad.fields = self.permissionStatusArray as! [String]
        viewTobeLoad.categoryIDs = self.permissionStatusArray as! [String]
        viewTobeLoad.modalPresentationStyle = .fullScreen
//        self.present(viewTobeLoad, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

    }
    
    @IBAction func openOrderBtnTap(_ sender: UIButton){

        tappedIndexPos = sender.tag
        tappedStatusStr = "openOrders"

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select"
        viewTobeLoad.fields = self.permissionStatusArray as! [String]
        viewTobeLoad.categoryIDs = self.permissionStatusArray as! [String]
        viewTobeLoad.modalPresentationStyle = .fullScreen
//        self.present(viewTobeLoad, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

    }
    @IBAction func ordersHistoryBtnTap(_ sender: UIButton){

        tappedIndexPos = sender.tag
        tappedStatusStr = "ordersHistory"

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select"
        viewTobeLoad.fields = self.permissionStatusArray as! [String]
        viewTobeLoad.categoryIDs = self.permissionStatusArray as! [String]
        viewTobeLoad.modalPresentationStyle = .fullScreen
//        self.present(viewTobeLoad, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)


    }
    @IBAction func vendorMastersBtnTap(_ sender: UIButton){
        
        tappedIndexPos = sender.tag
        tappedStatusStr = "vendorMaster"
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select a Vendor"
        viewTobeLoad.fields = self.permissionStatusArray as! [String]
        viewTobeLoad.categoryIDs = self.permissionStatusArray as! [String]
        viewTobeLoad.modalPresentationStyle = .fullScreen
//        self.present(viewTobeLoad, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

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
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

    }
    
    func ApproveRejectAPI() {
        
                activity.startAnimating()
                self.view.isUserInteractionEnabled = false
                
                let URLString_loginIndividual = Constants.BaseUrl + Approve_RejectUrl
                 
                            let params_IndividualLogin = [
                                "" : ""
                            ]
                        
                            let postHeaders_IndividualLogin = ["":""]
                            
        approvalsServiceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams:approveDataDict as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
                                    if(statusCode == 200 ){
                             
                                        self.approveAlert(title: "Success", message: "Details updated successfully")
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
    
    
    func approveAlert(title:String,message:String)  {
                
        let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
        //to change font of title and message.
        let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
        let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            activity.startAnimating()
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.approvalSubmissionArray=NSMutableArray()
                self.getApprovalsListAPI()
            })
        })
//        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
//        alertController.setValue(titlealertaction, forKey: "attributedTitle")
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)

    }
    
    func getApprovalsListAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false

        let URLString_loginIndividual = Constants.BaseUrl + ApprovalsListUrl + accountID
                                    
        approvalsServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: { [self](result) in

                            let respVo:ApprovalRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
            
                          let dataDict = result as! NSDictionary
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
            self.approvalsListArr=NSMutableArray()
                            if status == "SUCCESS" {
                                
                                self.approvalsListArr = dataDict.value(forKey: "result") as! NSMutableArray

                                self.addEmptyApprovalsData()
                                
                                self.emptyMsgBtn.removeFromSuperview()
                                if(self.approvalsListArr.count == 0){
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
                    }

    
    func getHistoryListAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + ApprovalsHistoryUrl + accountID
                                    
        approvalsServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
            
                            let dataDict = result as! NSDictionary
                            self.approvedHistoryListArr = dataDict.value(forKey: "result") as! NSMutableArray
                                        
                            if status == "SUCCESS" {
                                
                                if self.approvedHistoryListArr.count > 0 {
                                    
                                    self.approvalTblView.reloadData()
                                    
                                }else{
                                    
                                    self.approvalTblView.reloadData()
                                    self.showEmptyMsgBtn()
                                }
                                
//                                approvedHistoryListArr
                                
//                                self.shoppingCartResult = respVo.result!
//                                self.summaryTblView.reloadData()
                                
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


