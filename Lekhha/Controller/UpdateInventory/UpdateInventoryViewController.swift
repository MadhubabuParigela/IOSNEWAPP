//
//  UpdateInventoryViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 06/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown

class UpdateInventoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,sentname,sendDetails,UITextFieldDelegate {
    
    
    @IBOutlet weak var homeBtnTap: UIButton!
    var isCategoryBtnTapped = Bool()
    
    @IBAction func homeBtnTapped(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    var stockStatusArray = NSMutableArray()
    var updateInventoryDataArray = NSMutableArray()
    var dataDict = NSDictionary()
    var shareUserArr = NSMutableArray()
    var serverShareDict = NSMutableDictionary()
    
    var shareOptionsView = UIView()
    
    var borrowRequestStr = "borrow"
    
    var isShareViewStatusStr = "0"
    var borrowLentIdStr = ""
    var sharedUserIDStr = ""
    var shareProdIDStr = ""
    var sharedUserNameStr = ""
    var shareQty = Float()
    var shareUserName = ""
    var borrowedTagValue = 0
    
    var picker : UIDatePicker = UIDatePicker()

    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
    var borrowLentView = UIView()
    
    var accountTF = UITextField()
    var quantTF = UITextField()
    
    var selectAccBtn = UIButton()
    var shareQtyTF = UITextField()
    
    var shareView = UIView()
    
    var categoryDataArray = NSMutableArray()
    var categoryIDArray = NSMutableArray()

    var lentRadioBtn = UIButton()
    var borrowRadioBtn = UIButton()

    func sendnamedfields(fieldname: String, idStr: String) {
        
        if(isShareViewStatusStr == "1"){
            sharedUserIDStr = idStr
            sharedUserNameStr = fieldname
            selectAccBtn.setTitle("  \(fieldname)", for: .normal)

        }else{
            let productDict = updateInventoryDataArray[currentStatusTagValue] as! NSMutableDictionary
        
            let dataDict = productDict.value(forKey: "productdetails") as! NSMutableDictionary
            
            dataDict.setValue(fieldname, forKey: "productStatus")
            
           // productDict.removeObject(forKey: "productdetails")
            productDict.setValue(dataDict, forKey: "productdetails")
            
            updateInventoryDataArray.replaceObject(at: currentStatusTagValue, with: productDict)
            updateInventoryTblView.reloadData()

        }
        


    }
    
    func details(titlename: String, type: String, countrycode: String) {
        
    }
     
    var updateInventoryServiceCntrl = ServiceController()
//    var updateInventoryResult = [CurrentInventoryResult]()
    var emptyMsgBtn = UIButton()

    var accountID = String()
    
    var expiryDateTagValue = Int()
    var currentStatusTagValue = Int()
    
    var vendorListResult = NSMutableArray()

    @IBOutlet weak var updateInventoryTblView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")

        updateInventoryTblView.delegate = self
        updateInventoryTblView.dataSource = self
        
//        updateInventoryTblView.reloadData()
        
        stockStatusArray = ["Available","Expired","Consumed","Returned"]
        
        animatingView()
        
//        parseData()
        
//        self.getUpdateInventoryAPI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
      
            self.getUpdateInventoryAPI()

        
    }
    
    func parseData() {
        
        let updateDateArray = updateInventoryDataArray
        
        for i in 0..<updateDateArray.count {

            let productDict = updateDateArray[i] as! NSMutableDictionary
            
            let dataDict = productDict.value(forKey: "productdetails") as! NSMutableDictionary
            var stockQuan=Float()
            if let aastockQuan=dataDict.value(forKey: "stockQuantity") as? Double
            {
                stockQuan=Float(aastockQuan)
            }
            else if let aastockQuan=dataDict.value(forKey: "stockQuantity") as? Float
            {
                stockQuan=aastockQuan
            }
            else
            {
                stockQuan=Float(dataDict.value(forKey: "stockQuantity") as? String ?? "") ?? 0
            }
            dataDict.setValue(stockQuan ?? 0, forKey: "updatingQuantity")
            
            dataDict.setValue("No", forKey: "isUpdatedQuan")
            
            let currentDate = Date()
            let eventDatePicker = UIDatePicker()
            
            eventDatePicker.datePickerMode = UIDatePicker.Mode.date
            eventDatePicker.minimumDate = currentDate
                   
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let selectedDate = dateFormatter.string(from: eventDatePicker.date)
            productDict.setValue(selectedDate, forKey: "expiryDate")
            
            productDict.removeObject(forKey: "productdetails")
            productDict.setValue(dataDict, forKey: "productdetails")
            
            updateDateArray.replaceObject(at: i, with: productDict)

        }
        
        print(updateInventoryDataArray)
        
        updateInventoryDataArray = updateDateArray
        updateInventoryTblView.reloadData()

    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
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
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

    }
    

    //****************** TableView Delegate Methods*************************//
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return updateInventoryDataArray.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = updateInventoryTblView.dequeueReusableCell(withIdentifier: "UpdateInventoryCell", for: indexPath) as! UpdateInventoryTableViewCell
        
        let productDict = updateInventoryDataArray[indexPath.row] as! NSDictionary
        
//        print("Inner Data is \(productDict)")
        
//        print("Stock quan is \(dataDict.value(forKey: "stockQuantity") as? String ?? "")")

        let dataDict = productDict.value(forKey: "productdetails") as! NSDictionary
        var stockQuan=String()
        if let aastockQuan=productDict.value(forKey: "stockQuantity") as? Double
        {
            stockQuan=String(format:"%.3f",aastockQuan)
        }
        else if let aastockQuan=productDict.value(forKey: "stockQuantity") as? Float
        {
            stockQuan=String(format:"%.3f",aastockQuan)
        }
        else
        {
            stockQuan=dataDict.value(forKey: "stockQuantity") as? String ?? ""
        }
        
        let stockUnitDetails=productDict.value(forKey: "stockUnitDetails")as? NSArray
       
        let storagelocationLevel1=productDict.value(forKey: "storageLocationLevel1Details")as? NSArray
        let storagelocationLevel2=productDict.value(forKey: "storageLocationLevel2Details")as? NSArray
        let storagelocationLevel3=productDict.value(forKey: "storageLocationLevel3Details")as? NSArray
        if stockUnitDetails?.count ?? 0>0
        {
        let stockUnitDetailsDic=stockUnitDetails?[0] as? NSDictionary
            cell.stockUnitTF.text = stockUnitDetailsDic?.value(forKey: "stockUnitName") as? String
        }
        else
        {
            cell.stockUnitTF.text = ""
        }
       
        if storagelocationLevel1?.count ?? 0>0
        {
            let storagelocationLevel1Dic=storagelocationLevel1?[0] as? NSDictionary
            cell.storageLocationTF.text = storagelocationLevel1Dic?.value(forKey: "slocName") as? String
        }
        else
        {
            cell.storageLocationTF.text = ""
        }
        if storagelocationLevel2?.count ?? 0>0
        {
            let storagelocationLevel2Dic=storagelocationLevel2?[0] as? NSDictionary
            cell.storageLocationLevel2.text = storagelocationLevel2Dic?.value(forKey: "slocName") as? String
        }
        else
        {
            cell.storageLocationLevel2.text = ""
        }
        if storagelocationLevel3?.count ?? 0>0
        {
            let storagelocationLevel3Dic=storagelocationLevel3?[0] as? NSDictionary
            cell.storageLocationLevel3.text = storagelocationLevel3Dic?.value(forKey: "slocName") as? String
        }
        else
        {
            cell.storageLocationLevel3.text = ""
        }
        cell.idLbl?.text = dataDict["productUniqueNumber"] as? String
        
        cell.prodNameLbl.text = dataDict.value(forKey: "productName") as? String
        cell.descriptionLbl.text = dataDict.value(forKey: "description") as? String
//        cell.stockQuanTF.text = dataDict.value(forKey: "stockQuantity") as? String
        cell.stockQuanTF.text = stockQuan
       
        cell.currentInventoryBtn.setTitle(dataDict.value(forKey: "productStatus") as? String, for: .normal)
        
//        dataDict.setValue("Yes", forKey: "isUpdatedQuan")
        
        let isUpdatedQuan = dataDict.value(forKey: "isUpdatedQuan") as! String
        
        cell.expiredStockTF.keyboardType = UIKeyboardType.decimalPad

        let productStatusStr = dataDict.value(forKey: "productStatus") as! String
        
        if(productStatusStr == "Available"){
            cell.expiredStockLbl.text = "Available Stock"
            cell.expiryDateLbl.text = "Available Date"
            
            
        }else if(productStatusStr == "Expired"){
            cell.expiredStockLbl.text = "Expired Stock"
            cell.expiryDateLbl.text = "Expired Date"

        }else if(productStatusStr == "Consumed"){
            cell.expiredStockLbl.text = "Consumed Stock"
            cell.expiryDateLbl.text = "Consumed Date"

        }else{
            cell.expiredStockLbl.text = "Returned Stock"
            cell.expiryDateLbl.text = "Returned Date"

        }
        
//        let updateQuanStr = dataDict.value(forKey: "updatingQuantity") as? String
//
//        if(updateQuanStr == ""){
//            cell.expiredStockTF.text = String(stockQuan)
//
//        }else{
//            cell.expiredStockTF.text = String(updateQuanStr ?? "")
//
//        }
        
        cell.expiredStockTF.text = stockQuan
        
//       updatingQuantity
        
        

        let expiryDate = (productDict.value(forKey: "expiryDate") as? String) ?? ""
            let convertedExpiryDate = convertServerDateFormatter(date: expiryDate)
        
//        cell.expiryDateBtn.setTitle(expiryDate , for: . normal)

        if(convertedExpiryDate != ""){
            cell.expiryDateBtn.setTitle(convertedExpiryDate as? String, for: . normal)

        }

        if(convertedExpiryDate == "" || convertedExpiryDate == nil){
            let vall=productDict.value(forKey: "expiryDate") as? String
            let valArr=vall?.components(separatedBy: "-")
            var valString=String()
            if valArr?.count==3
            {
                let aa:String=valArr![2] + "/"
                valString = aa + valArr![1] + "/" + valArr![0]
            }
            else
            {
                valString = ""
            }
            cell.expiryDateBtn.setTitle(valString, for: . normal)
        }
        
        let borrowedStatus = productDict.value(forKey: "isBorrowed") as? Bool
        let lentStatus = productDict.value(forKey: "isLent") as? Bool
        
        if(borrowedStatus == true){
            if let borroeLent=productDict.value(forKey: "borrowLentDetails")as? NSDictionary{
                let quan=borroeLent.value(forKey: "quantity") as? String ?? ""
                cell.borrowLentTxtLbl.setTitle("Borrow(Qty:" + quan + ")", for: .normal)
            }
            cell.isBorrowedCheckBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
//            cell.borrowLentTxtLbl.setTitle("Borrow", for: .normal)
       
        }else if(lentStatus == true){
            if let borroeLent=productDict.value(forKey: "borrowLentDetails")as? NSDictionary{
                let quan=borroeLent.value(forKey: "quantity") as? String ?? ""
                cell.borrowLentTxtLbl.setTitle("Lent(Qty:"+quan+")", for:.normal)
            }
            cell.isBorrowedCheckBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
//            cell.borrowLentTxtLbl.setTitle("Lent", for: .normal)

        }else{
            cell.isBorrowedCheckBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
            cell.borrowLentTxtLbl.setTitle("Borrow/Lent", for: .normal)

        }
        
        let sharedStatus = productDict.value(forKey: "shared") as? Bool
        
        if(sharedStatus == true){
           
            cell.shareBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)

        }else{
            cell.shareBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)

        }
        
        
        cell.isBorrowedCheckBtn.addTarget(self, action: #selector(borrowedCheckBoxBtnTapped), for: .touchUpInside)
        
        cell.isBorrowedCheckBtn.tag = indexPath.row
        
        cell.shareBtn.addTarget(self, action: #selector(shareCheckBoxBtnTapped), for: .touchUpInside)
        
        cell.shareBtn.tag = indexPath.row


        cell.currentInventoryBtn.addTarget(self, action: #selector(onCurrentInventoryStatusBtnTapped), for: .touchUpInside)
                
        cell.expiryDateBtn.addTarget(self, action: #selector(onExpiryDateBtnTapped), for: .touchUpInside)
        
        cell.updateDetailsBtn.addTarget(self, action: #selector(onUpdateDetailsBtnTapped), for: .touchUpInside)
        
        cell.editDetailsBtn.addTarget(self, action: #selector(onEditDetailsBtnTap), for: .touchUpInside)
        
        cell.editDetailsBtn.tag = indexPath.row
        cell.updateDetailsBtn.tag = indexPath.row
        
        cell.expiredStockTF.delegate = self
        cell.expiredStockTF.tag = indexPath.row
        
        let giveAway = dataDict.value(forKey: "giveAwayStatus") as? Bool
        
        let attrs = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        
        let attrs1 = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "0f5fee"),
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

        let attributedString = NSMutableAttributedString(string:"")
        let attributedString1 = NSMutableAttributedString(string: "")
        
        let buttonTitleStr = NSMutableAttributedString(string:"Edit", attributes:attrs)
        attributedString.append(buttonTitleStr)
        cell.editDetailsBtn.setAttributedTitle(attributedString, for: .normal)

        let buttonTitleStr1 = NSMutableAttributedString(string:"Change History", attributes:attrs1)
        attributedString1.append(buttonTitleStr1)
        cell.changeHistoryBtn.setAttributedTitle(attributedString1, for: .normal)
        
        cell.changeHistoryBtn.addTarget(self, action: #selector(productChangeHistoryBtnTapprd), for: .touchUpInside)
        
        cell.changeHistoryBtn.tag = indexPath.row

        if(giveAway == true){
            
            cell.prodImgConstant.constant = 15
            cell.prodIdConstant.constant = 15
            
            cell.updateDetailsBtn.isHidden = true
            cell.editDetailsBtn.isHidden = true
            
            cell.currentInventoryBtn.backgroundColor = hexStringToUIColor(hex: "f1f1f1")
            cell.expiryDateBtn.backgroundColor = hexStringToUIColor(hex: "f1f1f1")
            
            cell.currentInventoryBtn.isUserInteractionEnabled = false
            cell.expiryDateBtn.isUserInteractionEnabled = false
            
            cell.isBorrowedCheckBtn.isUserInteractionEnabled=false
            
        }else{
            
            cell.prodImgConstant.constant = 30
            cell.prodIdConstant.constant = 30
            
            cell.updateDetailsBtn.isHidden = false
            cell.editDetailsBtn.isHidden = false
            
            cell.currentInventoryBtn.backgroundColor = .clear
            cell.expiryDateBtn.backgroundColor = .clear
            
            cell.currentInventoryBtn.isUserInteractionEnabled = true
            cell.expiryDateBtn.isUserInteractionEnabled = true
            cell.isBorrowedCheckBtn.isUserInteractionEnabled=true
        }

        if(isUpdatedQuan == "Yes"){
            cell.expiredStockTF.text = String(format:"%.3f",dataDict.value(forKey: "updatingQuantity") as? Double ?? 0)
        }
        
        if(productStatusStr == "Available"){
            cell.expiredStockTF.backgroundColor = hexStringToUIColor(hex: "f1f1f1")
            cell.expiredStockTF.isUserInteractionEnabled = false
       
        }else{
            cell.expiredStockTF.backgroundColor = UIColor.clear
            cell.expiredStockTF.isUserInteractionEnabled = true

        }
        
        cell.currentInventoryBtn.tag = indexPath.row
        cell.expiryDateBtn.tag = indexPath.row

        let prodArray = dataDict.value(forKey: "productImages") as? NSArray

        if(prodArray?.count ?? 0  > 0){

                    let dict = prodArray?[0] as! NSDictionary

                    let imageStr = dict.value(forKey: "0") as! String

                    if !imageStr.isEmpty {

                        let imgUrl:String = imageStr

                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")

                        let imggg = Constants.BaseImageUrl + trimStr

                        let url = URL.init(string: imggg)

//                        cell.prodImgView?.sd_setImage(with: url , placeholderImage: UIImage(named: "add photo"))
                        
                        cell.prodImgView?.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                        
                        cell.prodImgView?.contentMode = UIView.ContentMode.scaleAspectFit

                    }
                    else {

                        //cell.imageView?.image = UIImage(named: "no_image")
                    }
        }else{
            //cell.imageView?.image = UIImage(named: "no_image")

        }
        cell.editDetailsBtn.isHidden=true
        if(productStatusStr == "Consumed" || productStatusStr == "Expired" || productStatusStr == "Returned"){
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let result = formatter.string(from: date)
            cell.expiryDateBtn.setTitle(result, for: .normal)
        }
         return cell

     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let productDict = updateInventoryDataArray[indexPath.row] as! NSDictionary
        let dataDict = productDict.value(forKey: "productdetails") as! NSDictionary

        let giveAway = dataDict.value(forKey: "giveAwayStatus") as? Bool

        if(giveAway == true){
            return 623
            
        }else{
            return 678

        }
     }
    
    @objc func productChangeHistoryBtnTapprd(sender:UIButton){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
//       let productDict = updateInventoryDataArray[sender.tag] as! NSDictionary
        let dataDict = updateInventoryDataArray.object(at: sender.tag) as? NSDictionary
//        shareProdIDStr = dataDict?.value(forKey: "productId") as? String ?? ""

        let VC = storyBoard.instantiateViewController(withIdentifier: "ProductChangeHistoryViewController") as! ProductChangeHistoryViewController
        VC.modalPresentationStyle = .fullScreen
        VC.productId = dataDict?.value(forKey: "productId") as? String ?? ""
        self.navigationController?.pushViewController(VC, animated: true)

    }
    var shareUserArray=[String]()
    var shareTag=Int()
    var shareSelect:Bool=false
    @objc func shareCheckBoxBtnTapped(sender:UIButton){
        if userDefaults.bool(forKey: "shareStatus")==false
        {
            self.showAlertWith(title: "Alert", message: "You are not authorized to access this module")
        }
        else
        {
        shareTag=sender.tag
        shareProdIDStr = ""
        sharedUserIDStr = ""
        sharedUserNameStr = ""
        shareQty = 0.0
        shareUserName=""
        shareUserArray=[String]()
        shareUserArr=NSMutableArray()
       
        let dataDict = updateInventoryDataArray.object(at: sender.tag) as? NSDictionary
        shareProdIDStr = dataDict?.value(forKey: "productId") as? String ?? ""
        if dataDict?.value(forKey: "shared") as? Bool == true
        {
        let sharedUserDetails = dataDict?.value(forKey: "sharedUserDetails") as? NSDictionary
        let userDetails = sharedUserDetails?.value(forKey: "userDetails") as? NSMutableArray
            shareQty = Float(sharedUserDetails?.value(forKey: "sharedQuantity") as? String ?? "") ?? 0.0
            for i in 0..<userDetails!.count {
                
                let userDict=userDetails![i] as? NSDictionary
               
                shareUserArray.append(userDict?.value(forKey: "_id") as? String ?? "")
                
                let firstNamevaluu=(userDict?.value(forKey: "firstName")as? String)!
                let lastNamevaluu=(userDict?.value(forKey: "lastName")as? String)!
                let valuu = firstNamevaluu+" "+lastNamevaluu
                if shareUserName==""
                {
                    shareUserName=valuu
                }
                else
                {
                    shareUserName += ","+valuu
                }
                let userDict1=NSMutableDictionary()
                userDict1.setValue(userDict?.value(forKey: "_id"), forKey: "userId")
                shareUserArr.add(userDict1)
            }
            
            
//        let userId = dataDict?.value(forKey: "stockQuantity") as? String ?? ""
        }
        print("Qty is \(shareQty)")
        

//        serverShareDict.setValue(userId, forKey: "userId")
//        serverShareDict.setValue(stockQuan, forKey: "quantity")
//        serverShareDict.setValue(shareProdIDStr, forKey: "productId")
        
        getVendorListDataFromServer()
    }
    }
    
    func loadShareOptionsView() {
        
        print("Vendor List is \(vendorListResult)")
        
        shareOptionsView.removeFromSuperview()
        
        shareOptionsView = UIView()
        
        hiddenBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)

        
        var shareOptionHeight = CGFloat()
        shareOptionHeight = CGFloat(40 * vendorListResult.count)
        shareOptionHeight = shareOptionHeight + 60
        
//        shareOptionsView.frame = CGRect(x: 15, y: CGFloat(Int(self.view.frame.size.height)/2 - (shareOptionHeight/2)), width: self.view.frame.size.width - 30, height: shareOptionHeight)
        
        shareOptionsView.frame = CGRect(x: 15, y: (self.view.frame.size.height/2) - (shareOptionHeight/2), width: self.view.frame.size.width - 30, height: shareOptionHeight)
        shareOptionsView.backgroundColor = .white
        self.view.addSubview(shareOptionsView)
        
        let okBtn = UIButton()
        okBtn.frame = CGRect(x: shareOptionsView.frame.size.width - 60, y: shareOptionsView.frame.size.height - 30, width: 50, height: 20)
        okBtn.setTitle("OK", for: .normal)
        okBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        okBtn.addTarget(self, action: #selector(onOKBtnTap), for: .touchUpInside)
        okBtn.setTitleColor(.blue, for: .normal)
        okBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
        shareOptionsView.addSubview(okBtn)

        var yValue = 15
        
        for i in 0..<self.vendorListResult.count {
            
            let dataDict1 = self.vendorListResult.object(at: i) as? NSDictionary
            if shareUserArray.contains((dataDict1?.value(forKey: "userId") as? String)!)
            {
                dataDict1?.setValue("1", forKey: "isChecked")
            }
            let userDetailsDict  = dataDict1?.value(forKey: "userDetails") as? NSDictionary
            
            let vendorListView = UIView()
            vendorListView.frame = CGRect(x: 0, y: yValue, width: Int((shareOptionsView.frame.size.width)), height: 40)
            shareOptionsView.addSubview(vendorListView)
            
            let checkBoxBtn = UIButton()
            checkBoxBtn.frame = CGRect(x: 5, y: 0, width: 40, height: 40)
            checkBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
            checkBoxBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            checkBoxBtn.addTarget(self, action: #selector(onShareCheckBoxBtnTap), for: .touchUpInside)
            checkBoxBtn.tag = i
            vendorListView.addSubview(checkBoxBtn)
            
            let checkBoxStr = dataDict1?.value(forKey: "isChecked") as? String
            
            if(checkBoxStr == "1"){
                
                checkBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
            }
            
            
            let textLbl = UILabel()
            textLbl.frame = CGRect(x: checkBoxBtn.frame.origin.x + checkBoxBtn.frame.size.width, y: 0, width: vendorListView.frame.size.width - (50), height: vendorListView.frame.size.height)
            textLbl.textColor = hexStringToUIColor(hex: "232c51")
            textLbl.font = UIFont.init(name: kAppFontMedium, size: 13)
            vendorListView.addSubview(textLbl)
            
            
            let idStr = dataDict1?.value(forKey: "userId") as? String
            let firstName = userDetailsDict?.value(forKey: "firstName") as? String ?? ""
            let lastName=userDetailsDict?.value(forKey: "lastName")as? String ?? ""
            let valuu = firstName+" "+lastName
            textLbl.text = valuu

            self.categoryIDArray.add(idStr ?? "")
            self.categoryDataArray.add(valuu ?? "")
            
            yValue = yValue + 40
            
        }
    }
    
    @objc func onShareCheckBoxBtnTap(sender:UIButton){
        
        let dataDict = self.vendorListResult.object(at: sender.tag) as? NSDictionary
        let isCheckedStr = dataDict?.value(forKey: "isChecked") as? String
        
        let innerUserID = dataDict?.value(forKey: "userId") as? String
        
        if(isCheckedStr == "0"){
            dataDict?.setValue("1", forKey: "isChecked")
            
        }else{
            dataDict?.setValue("0", forKey: "isChecked")
            if shareUserArray.count>0
            {
                if shareUserArray.contains((dataDict?.value(forKey: "userId") as? String)!)
                {
                    for j in 0..<shareUserArray.count {
                        if shareUserArray[j] == dataDict?.value(forKey: "userId") as? String
                        {
                            shareUserArray.remove(at: j)
                            break
                        }
                    }
                }
            }
        }
        
        let userDict = NSMutableDictionary()
        
        if(shareUserArr.count == 0){
            userDict.setValue(innerUserID, forKey: "userId")
//            let userDet=dataDict?.value(forKey: "userDetails") as? NSDictionary
//            sharedUserNameStr
            shareUserArr.add(userDict)
            
        }else{
            for i in 0..<self.shareUserArr.count {

                let shareUserID = shareUserArr.object(at: i) as? String
                
                if(shareUserID == innerUserID){
                    shareUserArr.removeObject(at: i)
              
                }else{
                    
                    if(i == (shareUserArr.count-1)){
                        userDict.setValue(innerUserID, forKey: "userId")
                        shareUserArr.add(userDict)

                    }
                }
            }
        }
        
        
        vendorListResult.replaceObject(at:sender.tag, with: dataDict as? NSDictionary)
        loadShareOptionsView()
        
    }
    
    @objc func onOKBtnTap(sender:UIButton){
        
        shareOptionsView.removeFromSuperview()
        sharedUserNameStr=""
      shareUserName=""
        shareUserArr=NSMutableArray()
        if vendorListResult.count>0
        {
                for j in 0..<vendorListResult.count
                {
                    let dataa = vendorListResult[j] as? NSDictionary
                    if dataa?.value(forKey: "isChecked")as? String == "1"
                    {
                        let userDetails=dataa?.value(forKey: "userDetails")as? NSDictionary
                        let firstNamevaluu=(userDetails?.value(forKey: "firstName")as? String)!
                        let lastNamevaluu=(userDetails?.value(forKey: "lastName")as? String)!
                        let valuu = firstNamevaluu+" "+lastNamevaluu
                        if sharedUserNameStr==""
                        {
                            sharedUserNameStr=valuu
                        }
                        else
                        {
                            sharedUserNameStr += ","+valuu
                        }
                        
                        let userDict1=NSMutableDictionary()
                        userDict1.setValue(userDetails?.value(forKey: "_id"), forKey: "userId")
                        shareUserArr.add(userDict1)
                    }
                }
        }
        shareViewUI()
        
//        self.loadShareOptionsView()
        
//        submitShareAPI()
    }
    var userDefaults=UserDefaults.standard
    @objc func borrowedCheckBoxBtnTapped(sender:UIButton){
        if userDefaults.bool(forKey: "borrowLentStatus")==false
        {
            self.showAlertWith(title: "Alert", message: "You are not authorized to access this module")
        }
        else
        {
        shareTag=sender.tag
        let dataDict = updateInventoryDataArray.object(at: sender.tag) as? NSDictionary
        borrowLentIdStr = dataDict?.value(forKey: "_id") as! String
        shareProdIDStr = dataDict?.value(forKey: "productId") as? String ?? ""

        if sender.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
            
            borrowLentIdStr = ""
            borrowedTagValue = sender.tag
            borrowLentViewUI()

        }else{
            
//            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
            borrowedTagValue = sender.tag
            borrowLentViewUI()
            //submitBorrowLentInactiveAPI()

        }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {                if string=="."
        {
            if textField.text?.contains(".")==true || textField.text==""
            {
                return false
            }
           
        }
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
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
    var shareSuccess=Bool()
    func textFieldDidEndEditing(_ textField: UITextField) {
        var productDict=NSMutableDictionary()
        if textField == quantTF || textField == shareQtyTF
        {
        productDict = updateInventoryDataArray[self.shareTag] as! NSMutableDictionary
        }
        else
        {
        productDict = updateInventoryDataArray[currentStatusTagValue] as! NSMutableDictionary
        }
        
        let dataDict = productDict.value(forKey: "productdetails") as! NSMutableDictionary
        
        var stockQuant=Float()
        if let aastockQuan=dataDict.value(forKey: "stockQuantity") as? Double
        {
            stockQuant=Float(aastockQuan)
        }
        else if let aastockQuan=dataDict.value(forKey: "stockQuantity") as? Float
        {
            stockQuant=aastockQuan
        }
        else
        {
            stockQuant=Float(dataDict.value(forKey: "stockQuantity") as? String ?? "") ?? 0
        }
        let updatingQunatity: Float? = Float(textField.text!)
        
        if(textField.text == ""){
            
            dataDict.setValue(0, forKey: "updatingQuantity")
            dataDict.setValue("Yes", forKey: "isUpdatedQuan")
            
            productDict.removeObject(forKey: "productdetails")
            productDict.setValue(dataDict, forKey: "productdetails")
            if textField == quantTF || textField == shareQtyTF
            {
            updateInventoryDataArray.replaceObject(at: self.shareTag, with: productDict)
            }
            else
            {
                updateInventoryDataArray.replaceObject(at: currentStatusTagValue, with: productDict)
            }
            updateInventoryTblView.reloadData()

        }
        else if(updatingQunatity ?? 0 > stockQuant){
            self.showAlertWith(title: "Alert", message: "Please update require stock less than stock quantiy")
            shareSuccess=false
            dataDict.setValue(Float(textField.text!), forKey: "updatingQuantity")
            dataDict.setValue("Yes", forKey: "isUpdatedQuan")
            
            productDict.removeObject(forKey: "productdetails")
            productDict.setValue(dataDict, forKey: "productdetails")
            
            if textField == quantTF || textField == shareQtyTF
            {
            updateInventoryDataArray.replaceObject(at: self.shareTag, with: productDict)
            }
            else
            {
                updateInventoryDataArray.replaceObject(at: currentStatusTagValue, with: productDict)
            }
//            updateInventoryTblView.reloadData()
            return
        }else{
            shareSuccess=true
            dataDict.setValue(Float(textField.text!), forKey: "updatingQuantity")
            dataDict.setValue("Yes", forKey: "isUpdatedQuan")
            
            productDict.removeObject(forKey: "productdetails")
            productDict.setValue(dataDict, forKey: "productdetails")
            
            if textField == quantTF || textField == shareQtyTF
            {
            updateInventoryDataArray.replaceObject(at: self.shareTag, with: productDict)
            }
            else
            {
                updateInventoryDataArray.replaceObject(at: currentStatusTagValue, with: productDict)
            }
            updateInventoryTblView.reloadData()

        }
        if textField == quantTF
        {
            print(quantTF.text)
        }
        if textField == shareQtyTF
        {
            if textField.text != ""
            {
                if shareSuccess==true
                {
                shareQty = Float(textField.text!)!
                }
            }
        }
    }
    let dropDown = DropDown() //2
    @objc func onCurrentInventoryStatusBtnTapped(sender:UIButton){
        currentStatusTagValue = sender.tag
        dropDown.dataSource = self.stockStatusArray as! [String]//4
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal) //9
                self?.sendnamedfields(fieldname: item, idStr: self?.stockStatusArray[index] as! String)
            }
        

       
    }
    
    @objc func onUpdateDetailsBtnTapped(sender:UIButton){
        
        self.view.endEditing(true)
        let productDict = updateInventoryDataArray[sender.tag] as! NSDictionary
        let dataDict = productDict.value(forKey: "productdetails") as! NSDictionary

        let productStatusStr = dataDict.value(forKey: "productStatus") as! String
        
        if(productStatusStr == "Available"){
            self.showAlertWith(title: "Alert", message: "You are trying to update the item without changing the status")
            return
        }
        
//        let productDict = updateInventoryDataArray[textField.tag] as! NSMutableDictionary
//
//        let dataDict = productDict.value(forKey: "productdetails") as! NSMutableDictionary
        
        var stockQuant=Float()
        if let aastockQuan=dataDict.value(forKey: "stockQuantity") as? Double
        {
            stockQuant=Float(aastockQuan)
        }
        else if let aastockQuan=dataDict.value(forKey: "stockQuantity") as? Float
        {
            stockQuant=aastockQuan
        }
        else
        {
            stockQuant=Float(dataDict.value(forKey: "stockQuantity") as? String ?? "") ?? 0
        }
        var updatingQunatity=Float()
        if let aastockQuan=dataDict.value(forKey: "updatingQuantity") as? Double
        {
            updatingQunatity=Float(aastockQuan)
        }
        else if let aastockQuan=dataDict.value(forKey: "updatingQuantity") as? Float
        {
            updatingQunatity=aastockQuan
        }
        else
        {
            updatingQunatity=Float(dataDict.value(forKey: "updatingQuantity") as? String ?? "") ?? 0
        }
        
//        let stockIntQuan = Int(stockQuant) ?? 0
        let updateStockQuan = updatingQunatity
        
         
        if(updateStockQuan > stockQuant){
            self.showAlertWith(title: "Alert", message: "Please update require stock less than stock quantiy")
            return
        }
        
        if(updateStockQuan == 0){
            self.showAlertWith(title: "Alert", message: "Please enter valid quantity")
            return

        }
        
        updateInventoryDetailsAPIWithTag(tagValue: sender.tag)

    }
    
    @objc func onEditDetailsBtnTap(sender:UIButton){
        
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyBoard.instantiateViewController(withIdentifier: "EditUpdateInventoryViewController") as! EditUpdateInventoryViewController
                VC.modalPresentationStyle = .fullScreen
        //      self.navigationController?.pushViewController(VC, animated: true)
        
        let productDict = updateInventoryDataArray[sender.tag] as! NSDictionary
        VC.prodIDStr = productDict.value(forKey: "_id") as! String
        VC.productID = productDict.value(forKey: "productId") as! String
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @objc func onExpiryDateBtnTapped(sender:UIButton){
        
        expiryDateTagValue = sender.tag
        
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
        
        let productDict = updateInventoryDataArray[expiryDateTagValue] as! NSMutableDictionary
        
        let dataDict = productDict.value(forKey: "productdetails") as! NSMutableDictionary
        
        productDict.setValue(result, forKey: "expiryDate")
        
//        productDict.removeObject(forKey: "productdetails")
        productDict.setValue(dataDict, forKey: "productdetails")
        
        updateInventoryDataArray.replaceObject(at: expiryDateTagValue, with: productDict)
        updateInventoryTblView.reloadData()

//      FiltterView.startDateBtn.setTitle(result, for: .normal)

    }
    
    @objc func dueDateChanged(sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: picker.date)

//         FiltterView.startDateBtn.setTitle(selectedDate, for: .normal)
        
        let productDict = updateInventoryDataArray[expiryDateTagValue] as! NSMutableDictionary
        
        let dataDict = productDict.value(forKey: "productdetails") as! NSMutableDictionary
        
        productDict.setValue(selectedDate, forKey: "expiryDate")
        
        productDict.removeObject(forKey: "productdetails")
        productDict.setValue(dataDict, forKey: "productdetails")
        
        updateInventoryDataArray.replaceObject(at: expiryDateTagValue, with: productDict)
        updateInventoryTblView.reloadData()

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
    @objc func giveButtonCheck()
    {
        let dataDict = updateInventoryDataArray.object(at: borrowedTagValue) as? NSDictionary
        borrowLentIdStr = dataDict?.value(forKey: "_id") as! String
        shareProdIDStr = dataDict?.value(forKey: "productId") as? String ?? ""

        if checkGiveButton.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
            checkGiveButton.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
            let title="Borrow/Lent"
            let message="Do you really want to uncheck this product as Borrowed / Lent? If yes, the Borrowed / Lent information may be lost."
            let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
            //to change font of title and message.
            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
            alertController.setValue(titleAttrString, forKey: "attributedTitle")
            alertController.setValue(messageAttrString, forKey: "attributedMessage")
            
            let alertAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
                self.checkGiveButton.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
            })
        
        let alertAction1 = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.removeBorrowLentAPI()
           
        })

            alertController.addAction(alertAction)
           alertController.addAction(alertAction1)

        self.present(alertController, animated: true, completion: nil)
            

        }
    }
    var checkGiveButton = UIButton()
    func borrowLentViewUI()  {
        
        quantTF.text = ""
        accountTF.text = ""
        
//        hiddenBtn = UIButton()
        hiddenBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)
        
        borrowLentView = UIView()
        borrowLentView.frame = CGRect(x: 20, y: self.view.frame.size.height/2-(225), width: self.view.frame.size.width - (40), height: 380)
        borrowLentView.backgroundColor = UIColor.white
        borrowLentView.layer.cornerRadius = 10
        borrowLentView.layer.masksToBounds = true
        self.view.addSubview(borrowLentView)
        
        //Change Pwd Lbl
        
        let changePwdLbl = UILabel()
        changePwdLbl.frame = CGRect(x: 10, y: 5, width: borrowLentView.frame.size.width - (60), height: 40)
        changePwdLbl.text = "      Borrow/Lent"
        changePwdLbl.textAlignment = NSTextAlignment.center
        changePwdLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        changePwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        borrowLentView.addSubview(changePwdLbl)
        
        //Cancel Btn
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: borrowLentView.frame.size.width - 40, y: 5, width: 40, height: 40)
        cancelBtn.setImage(UIImage.init(named: "cancel"), for: UIControl.State.normal)
        cancelBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        borrowLentView.addSubview(cancelBtn)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        
        //Seperator Line Lbl
        
        let seperatorLine = UILabel()
        seperatorLine.frame = CGRect(x: 0, y: changePwdLbl.frame.origin.y+changePwdLbl.frame.size.height, width: borrowLentView.frame.size.width , height: 1)
        seperatorLine.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
        borrowLentView.addSubview(seperatorLine)
        
        borrowRadioBtn = UIButton()
        borrowRadioBtn.frame = CGRect(x: 15, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: 30, height: 30)
        borrowRadioBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)
        borrowRadioBtn.addTarget(self, action: #selector(borrowRadioBtnTap), for: .touchUpInside)
        borrowLentView.addSubview(borrowRadioBtn)

        let borrowLbl = UILabel()
        borrowLbl.frame = CGRect(x: borrowRadioBtn.frame.size.width+borrowRadioBtn.frame.origin.x, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+18, width: 60, height: 25)
        borrowLbl.text = "Borrow"
        borrowLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        borrowLbl.textColor = hexStringToUIColor(hex: "232c51")
        borrowLentView.addSubview(borrowLbl)

        lentRadioBtn = UIButton()
        lentRadioBtn.frame = CGRect(x: borrowLbl.frame.size.width + borrowLbl.frame.origin.x + (10), y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: 30, height: 30)
        lentRadioBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
        lentRadioBtn.addTarget(self, action: #selector(lentRadioBtnTap), for: .touchUpInside)
        borrowLentView.addSubview(lentRadioBtn)

        let lentLbl = UILabel()
        lentLbl.frame = CGRect(x: lentRadioBtn.frame.size.width+lentRadioBtn.frame.origin.x, y:seperatorLine.frame.origin.y+seperatorLine.frame.size.height+18, width: 80, height: 25)
        lentLbl.text = "Lent"
        lentLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        lentLbl.textColor = hexStringToUIColor(hex: "232c51")
        borrowLentView.addSubview(lentLbl)
        
        borrowRadioBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        lentRadioBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        //Current Pwd Lbl

        let currentPwdLbl = UILabel()
        currentPwdLbl.frame = CGRect(x: 10, y: lentLbl.frame.origin.y+lentLbl.frame.size.height+15, width: borrowLentView.frame.size.width - (20), height: 20)
        currentPwdLbl.text = "Account"
        currentPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        currentPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        borrowLentView.addSubview(currentPwdLbl)

        //Current Pwd TF

        accountTF.frame = CGRect(x: 10, y: currentPwdLbl.frame.origin.y+currentPwdLbl.frame.size.height+5, width: borrowLentView.frame.size.width - (20), height: 45)
        accountTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        accountTF.textColor = hexStringToUIColor(hex: "232c51")
        accountTF.autocapitalizationType = .none
        borrowLentView.addSubview(accountTF)

        accountTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        accountTF.layer.cornerRadius = 3
        accountTF.clipsToBounds = true

        let currentPwdPaddingView = UIView()
        currentPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: accountTF.frame.size.height)
        accountTF.leftView = currentPwdPaddingView
        accountTF.leftViewMode = UITextField.ViewMode.always
        
        //New Pwd Lbl

        let newPwdLbl = UILabel()
        newPwdLbl.frame = CGRect(x: 10, y: accountTF.frame.origin.y+accountTF.frame.size.height+15, width: borrowLentView.frame.size.width - (20), height: 20)
        newPwdLbl.text = "Quantity"
        newPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        newPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        borrowLentView.addSubview(newPwdLbl)

        //New Pwd TF

        quantTF.frame = CGRect(x: 10, y: newPwdLbl.frame.origin.y+newPwdLbl.frame.size.height+5, width: borrowLentView.frame.size.width - (20), height: 45)
        quantTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        quantTF.textColor = hexStringToUIColor(hex: "232c51")
        quantTF.keyboardType=UIKeyboardType.decimalPad
        borrowLentView.addSubview(quantTF)

        quantTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        quantTF.layer.cornerRadius = 3
        quantTF.clipsToBounds = true
        quantTF.delegate=self
        
        
        let dataDict = updateInventoryDataArray.object(at: borrowedTagValue) as? NSDictionary
         checkGiveButton = UIButton()
        let checkGiveButtonLbl = UILabel()
        quantTF.isUserInteractionEnabled=true
        borrowRadioBtn.isUserInteractionEnabled=true
        lentRadioBtn.isUserInteractionEnabled=true
        accountTF.isUserInteractionEnabled=true
        if dataDict?.value(forKey: "isBorrowed")as? Bool == true || dataDict?.value(forKey: "isLent")as? Bool == true
        {
            if let borrowLentDetails=dataDict?.value(forKey: "borrowLentDetails")as? NSDictionary
            {
                if let accountDetails=borrowLentDetails.value(forKey: "accountDetails")as? NSDictionary
                {
                    accountTF.text=accountDetails.value(forKey: "emailAddress")as? String
                    accountTF.isUserInteractionEnabled=false
                }
                quantTF.text=borrowLentDetails.value(forKey: "quantity") as? String
                quantTF.isUserInteractionEnabled=false
                borrowRadioBtn.isUserInteractionEnabled=false
                lentRadioBtn.isUserInteractionEnabled=false
            }
            
        checkGiveButton.frame = CGRect(x: 15, y: quantTF.frame.origin.y+quantTF.frame.size.height+15, width: 30, height: 30)
        checkGiveButton.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        checkGiveButton.addTarget(self, action: #selector(giveButtonCheck), for: .touchUpInside)
        borrowLentView.addSubview(checkGiveButton)

       
        checkGiveButtonLbl.frame = CGRect(x: checkGiveButton.frame.size.width+20, y: quantTF.frame.origin.y+quantTF.frame.size.height+18, width: 60, height: 25)
        checkGiveButtonLbl.text = "Give back"
        checkGiveButtonLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        checkGiveButtonLbl.textColor = hexStringToUIColor(hex: "232c51")
        borrowLentView.addSubview(checkGiveButtonLbl)
        }
        let newPwdPaddingView = UIView()
        newPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: quantTF.frame.size.height)
        quantTF.leftView = newPwdPaddingView
        quantTF.leftViewMode = UITextField.ViewMode.always
        if dataDict?.value(forKey: "isBorrowed")as? Bool == true  || dataDict?.value(forKey: "isLent")as? Bool == true
        {
        let updateBtn = UIButton()
        updateBtn.frame = CGRect(x:borrowLentView.frame.size.width/2 - 30, y: quantTF.frame.origin.y+quantTF.frame.size.height+60, width: 80, height: 40)
        updateBtn.setTitle("CLOSE", for: UIControl.State.normal)
        updateBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        updateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        updateBtn.backgroundColor = hexStringToUIColor(hex: "232c51")
        updateBtn.addTarget(self, action: #selector(closeBtnTap), for: .touchUpInside)
            updateBtn.layer.cornerRadius = 3
            updateBtn.layer.masksToBounds = true
        borrowLentView.addSubview(updateBtn)
        }
        else
        {
        let updateBtn = UIButton()
        updateBtn.frame = CGRect(x:borrowLentView.frame.size.width/2 - (90), y: quantTF.frame.origin.y+quantTF.frame.size.height+60, width: 80, height: 40)
        updateBtn.setTitle("CLOSE", for: UIControl.State.normal)
        updateBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        updateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        updateBtn.backgroundColor = hexStringToUIColor(hex: "232c51")
        updateBtn.addTarget(self, action: #selector(closeBtnTap), for: .touchUpInside)
            updateBtn.layer.cornerRadius = 3
            updateBtn.layer.masksToBounds = true
        borrowLentView.addSubview(updateBtn)
        }
        if dataDict?.value(forKey: "isBorrowed")as? Bool == true  || dataDict?.value(forKey: "isLent")as? Bool == true
        {
        }
        else
        {
            let productDet=dataDict?.value(forKey: "productdetails")as! NSDictionary
            stockQuantity=productDet.value(forKey: "stockQuantity") as? Float ?? 0
        let submitBtn = UIButton()
        submitBtn.frame = CGRect(x:borrowLentView.frame.size.width/2 + (10), y: quantTF.frame.origin.y+quantTF.frame.size.height+60, width: 80, height: 40)
        submitBtn.setTitle("SAVE", for: UIControl.State.normal)
        submitBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        submitBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        submitBtn.backgroundColor = hexStringToUIColor(hex: "0f5fee")
        submitBtn.addTarget(self, action: #selector(borrowLentSubmitBtnTap), for: .touchUpInside)

        borrowLentView.addSubview(submitBtn)
            submitBtn.layer.cornerRadius = 3
        }

        
        
        
    }
    var stockQuantity=Float()
    @objc func borrowRadioBtnTap(){
     
        borrowRequestStr = "borrow"
        
        borrowRadioBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)
        lentRadioBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
    }
    
    @objc func lentRadioBtnTap(){
        
        borrowRequestStr = "Lent"
        
        borrowRadioBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
        lentRadioBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)

    }
    
    func shareViewUI()  {
        
//        shareUserArr.removeAllObjects()
//        shareUserArr = NSMutableArray()

        shareView.removeFromSuperview()
        
        isShareViewStatusStr = "1"
        
        selectAccBtn.setTitle("", for: .normal)
//        shareQtyTF.text = ""
        
//        hiddenBtn = UIButton()
        hiddenBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)
        
        shareView = UIView()
        shareView.frame = CGRect(x: 20, y: self.view.frame.size.height/2-(175), width: self.view.frame.size.width - (40), height: 350)
        shareView.backgroundColor = UIColor.white
        shareView.layer.cornerRadius = 10
        shareView.layer.masksToBounds = true
        self.view.addSubview(shareView)
        
        //Change Pwd Lbl
        
        let changePwdLbl = UILabel()
        changePwdLbl.frame = CGRect(x: 10, y: 5, width: shareView.frame.size.width - (60), height: 40)
        changePwdLbl.text = "      Share"
        changePwdLbl.textAlignment = NSTextAlignment.center
        changePwdLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        changePwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        shareView.addSubview(changePwdLbl)
        
        //Cancel Btn
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: shareView.frame.size.width - 40, y: 5, width: 40, height: 40)
        cancelBtn.setImage(UIImage.init(named: "cancel"), for: UIControl.State.normal)
        cancelBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        shareView.addSubview(cancelBtn)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        
        //Seperator Line Lbl
        
        let seperatorLine = UILabel()
        seperatorLine.frame = CGRect(x: 0, y: changePwdLbl.frame.origin.y+changePwdLbl.frame.size.height, width: shareView.frame.size.width , height: 1)
        seperatorLine.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
        shareView.addSubview(seperatorLine)
        
        //Current Pwd Lbl

        let currentPwdLbl = UILabel()
        currentPwdLbl.frame = CGRect(x: 10, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: shareView.frame.size.width - (20), height: 20)
        currentPwdLbl.text = "Select User"
        currentPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        currentPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        shareView.addSubview(currentPwdLbl)

        //Current Pwd TF
      
        
        selectAccBtn.frame = CGRect(x: 10, y: currentPwdLbl.frame.origin.y+currentPwdLbl.frame.size.height+5, width: shareView.frame.size.width - (20), height: 45)
        selectAccBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
        selectAccBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: .normal)
        shareView.addSubview(selectAccBtn)
        selectAccBtn.addTarget(self, action: #selector(selectAccBtnTap), for: .touchUpInside)
        selectAccBtn.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        selectAccBtn.layer.cornerRadius = 3
        if shareUserName==""
        {
        selectAccBtn.setTitle(sharedUserNameStr, for: .normal)
        }
        else
        {
            selectAccBtn.setTitle(shareUserName, for: .normal)
        }
        selectAccBtn.clipsToBounds = true
        
        selectAccBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        let selectDropBtn=UIButton()
         selectDropBtn.frame = CGRect(x: shareView.frame.size.width - (60), y: currentPwdLbl.frame.origin.y+currentPwdLbl.frame.size.height+12, width: 30, height: 30)
         selectDropBtn.setImage(UIImage(named: "arrowDown"), for: .normal)
        selectDropBtn.addTarget(self, action: #selector(selectAccBtnTap), for: .touchUpInside)
         shareView.addSubview(selectDropBtn)
        //New Pwd Lbl

        let newPwdLbl = UILabel()
        newPwdLbl.frame = CGRect(x: 10, y: selectAccBtn.frame.origin.y+selectAccBtn.frame.size.height+15, width: shareView.frame.size.width - (20), height: 20)
        newPwdLbl.text = "Quantity"
        newPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        newPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        shareView.addSubview(newPwdLbl)

        //New Pwd TF

        shareQtyTF.frame = CGRect(x: 10, y: newPwdLbl.frame.origin.y+newPwdLbl.frame.size.height+5, width: shareView.frame.size.width - (20), height: 45)
        shareQtyTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        shareQtyTF.textColor = hexStringToUIColor(hex: "232c51")
        shareView.addSubview(shareQtyTF)
        shareQtyTF.delegate=self
        shareQtyTF.keyboardType = UIKeyboardType.decimalPad

        shareQtyTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        shareQtyTF.layer.cornerRadius = 3
        shareQtyTF.clipsToBounds = true
        if shareUserName==""
        {
//            shareQtyTF.text = String(shareQty)
        }
        else
        {
            shareQtyTF.text = String(shareQty)
        }
        let newPwdPaddingView = UIView()
        newPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: quantTF.frame.size.height)
        shareQtyTF.leftView = newPwdPaddingView
        shareQtyTF.leftViewMode = UITextField.ViewMode.always

        let updateBtn = UIButton()
        updateBtn.frame = CGRect(x:shareView.frame.size.width/2 - (90), y: shareQtyTF.frame.origin.y+shareQtyTF.frame.size.height+40, width: 80, height: 40)
        updateBtn.setTitle("CLOSE", for: UIControl.State.normal)
        updateBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        updateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        updateBtn.backgroundColor = hexStringToUIColor(hex: "232c51")
        updateBtn.addTarget(self, action: #selector(closeBtnTap), for: .touchUpInside)

        shareView.addSubview(updateBtn)
        
        let submitBtn = UIButton()
        
        submitBtn.frame = CGRect(x:shareView.frame.size.width/2 + (10), y: shareQtyTF.frame.origin.y+shareQtyTF.frame.size.height+40, width: 80, height: 40)
        submitBtn.setTitle("SAVE", for: UIControl.State.normal)
        submitBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        submitBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        submitBtn.backgroundColor = hexStringToUIColor(hex: "0f5fee")
        submitBtn.addTarget(self, action: #selector(shareSubmitBtnTap), for: .touchUpInside)

        shareView.addSubview(submitBtn)
        shareView.addSubview(updateBtn)

        updateBtn.layer.cornerRadius = 3
        updateBtn.layer.masksToBounds = true
        
        submitBtn.layer.cornerRadius = 3
        
    }
    
    
    @objc func selectAccBtnTap(){
        shareUserArr.removeAllObjects()
            shareUserArr = NSMutableArray()
//        getVendorListDataFromServer()

//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
//        viewTobeLoad.delegate1 = self
//        viewTobeLoad.iscountry = false
//        viewTobeLoad.fields = self.categoryDataArray as! [String]
//        viewTobeLoad.categoryIDs = self.categoryIDArray as! [String]
//
//        viewTobeLoad.modalPresentationStyle = .fullScreen
////                                                self.present(viewTobeLoad, animated: true, completion: nil)
//
//        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

        loadShareOptionsView()
        
    }
    
    @objc func cancelBtnTap(){
        
        hiddenBtn.removeFromSuperview()

        borrowLentView.removeFromSuperview()
        shareView.removeFromSuperview()
        
        shareOptionsView.removeFromSuperview()
        
        isShareViewStatusStr = "0"
        
    }
    
    @objc func shareSubmitBtnTap(sender:UIButton){
//
//                if(shareUserArr.count == 0){
//                    self.showAlertWith(title: "Alert", message: "Please select at least one user")
//                    return
//                }
//
        self.view.endEditing(true)
        isShareViewStatusStr = "0"
        if shareSuccess==true
        {
        submitShareAPI()
        }
        
    }
    
    @objc func borrowLentSubmitBtnTap(sender:UIButton){
        self.view.endEditing(true)
        if(accountTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter Account Name")
            return
            
        }else if(quantTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter Quantity")
            return
        }
        let aa=Float(quantTF.text ?? "")
        var productDict=NSMutableDictionary()
        productDict = updateInventoryDataArray[self.shareTag] as! NSMutableDictionary
        
        let dataDict = productDict.value(forKey: "productdetails") as! NSMutableDictionary
        
        var stockQuant=Float()
        if let aastockQuan=dataDict.value(forKey: "stockQuantity") as? Double
        {
            stockQuant=Float(aastockQuan)
        }
        else if let aastockQuan=dataDict.value(forKey: "stockQuantity") as? Float
        {
            stockQuant=aastockQuan
        }
        else
        {
            stockQuant=Float(dataDict.value(forKey: "stockQuantity") as? String ?? "") ?? 0
        }
        if aa! > stockQuant
        {
            self.showAlertWith(title: "Alert", message: "Quantity should not be greater than stock quantity")
        }
        else
        {
        submitBorrowLentAPI()
        }
        
    }
    
    @objc func closeBtnTap(sender: UIButton){
        
        hiddenBtn.removeFromSuperview()

        borrowLentView.removeFromSuperview()
        shareView.removeFromSuperview()
        
        shareOptionsView.removeFromSuperview()
        
        isShareViewStatusStr = "0"

    }
    
    func getVendorListDataFromServer() {
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String
        
        var accountID = String()
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
                activity.startAnimating()
                self.view.isUserInteractionEnabled = true
        
//        accountID = "5f8970b099c2f076c8c54af6"
        
                let URLString_loginIndividual = Constants.BaseUrl + GetUsersListUrl + accountID as String + "/\(userID)"
                updateInventoryServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                                    let respVo:VendorListRespo = Mapper().map(JSON: result as! [String : Any])!
                                                            
                                    let status = respVo.status
                                    let messageResp = respVo.message
                                    _ = respVo.statusCode
                                    
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                    
                                  let dataDict = result as? NSDictionary
                                                
                                    if status == "SUCCESS" {
                                        
                                        self.vendorListResult = dataDict?.value(forKey: "result") as? NSMutableArray ?? [""]
                                        
                                        if(self.vendorListResult.count > 0){
                                            
                                            for i in 0..<self.vendorListResult.count {

                                                let dataDict = self.vendorListResult.object(at: i) as? NSDictionary
                                                let userDetailsDict  = dataDict?.value(forKey: "userDetails") as? NSDictionary
                                                
                                                dataDict?.setValue("0", forKey: "isChecked")
                                                
                                                self.vendorListResult.replaceObject(at: i, with: dataDict)
                                                
                                                let idStr = dataDict?.value(forKey: "userId") as? String
                                                let firstName = userDetailsDict?.value(forKey: "firstName") as? String
                                            
                                                self.categoryIDArray.add(idStr ?? "")
                                                self.categoryDataArray.add(firstName ?? "")
                                          
                                                }
                                            
                                            self.shareViewUI()
                                            

                                        }else{
                                            self.showAlertWith(title: "Alert", message:"There are no other users for this account")

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
        
        if(self.vendorListResult.count == 0){
        }

    }
    func getUpdateInventoryAPI() {
        
        updateInventoryDataArray.removeAllObjects()
        updateInventoryDataArray = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
var URLString_loginIndividual=String()
        if localSearchInventory==""
        {
        URLString_loginIndividual = Constants.BaseUrl + CurrentInventoryUrl + accountID as String
        }
        else
        {
            URLString_loginIndividual=localSearchInventory
        }
        
        updateInventoryServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
            
            self.dataDict = result as? NSDictionary ?? NSDictionary()


            if self.dataDict != nil
            {
            if localSearchInventory==""
            {
            self.updateInventoryDataArray = self.dataDict.value(forKey: "result") as! NSMutableArray
            }
            else
            {
                self.updateInventoryDataArray = self.dataDict.value(forKey: "currentInventoryresult") as! NSMutableArray
                
            }
            print(self.updateInventoryDataArray)

            }
        let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
            let status = respVo.status
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                                        
                            if status == "SUCCESS" {
                                
//                                self.updateInventoryResult = respVo.result!
//                                self.updateInventoryTblView.reloadData()
                                
                                if(self.updateInventoryDataArray.count > 0){
                                    self.emptyMsgBtn.removeFromSuperview()
                                    self.parseData()

                                }else if(self.updateInventoryDataArray.count == 0){
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
        
        if(self.updateInventoryDataArray.count == 0){
//            self.showEmptyMsgBtn()
        }
    }
    
    func updateInventoryDetailsAPIWithTag(tagValue:Int) {
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String
        
        let productDict = updateInventoryDataArray[tagValue] as! NSMutableDictionary
        
        let dataDict = productDict.value(forKey: "productdetails") as! NSMutableDictionary
        var dataMainObject=NSDictionary()
        dataMainObject = ["_id": dataDict.value(forKey: "_id") as Any,
            "accountEmailId": dataDict.value(forKey: "accountEmailId") as Any,
            "accountId": dataDict.value(forKey: "accountId") as Any,
            "addedByUserId": dataDict.value(forKey: "addedByUserId") as Any,
            "availableStockQuantity": 0,
           "isBorrowed": false,
            "category": dataDict.value(forKey: "category") as Any,
           "changedStockQuantity": 0,
            "description": dataDict.value(forKey: "description") as Any,
            "giveAwayStatus": dataDict.value(forKey: "giveAwayStatus") as Any,
            "id": 0,
            "isLent": false,
            "orderId": dataDict.value(forKey: "orderId") as Any,
           "price": dataDict.value(forKey: "price") as Any,
            "priceUnit": dataDict.value(forKey: "priceUnit") as Any,
            "productImages": dataDict.value(forKey: "productImages") as Any,
            "productManuallyAddOrAutoMovedDate": dataDict.value(forKey: "productManuallyAddOrAutoMovedDate") as Any,
            "productName": dataDict.value(forKey: "productName") as Any,
            "productStatus": dataDict.value(forKey: "productStatus") as Any,
            "productUniqueNumber": dataDict.value(forKey: "productUniqueNumber") as Any,
            "purchaseDate": dataDict.value(forKey: "purchaseDate") as Any,
            "shared": dataDict.value(forKey: "shared") as Any,
            "status": dataDict.value(forKey: "status") as Any,
            "stockQuantity": dataDict.value(forKey: "stockQuantity") as Any,
            "stockUnit": dataDict.value(forKey: "stockUnit") as Any,
            "storageLocation1": dataDict.value(forKey: "storageLocation1") as Any,
            "storageLocation2": dataDict.value(forKey: "storageLocation2") as Any,
            "storageLocation3": dataDict.value(forKey: "storageLocation3") as Any,
            "subCategory": dataDict.value(forKey: "subCategory") as Any,
            "unitPrice": dataDict.value(forKey: "unitPrice") as Any,
            "uploadType": dataDict.value(forKey: "uploadType") as Any,
            "expiryDate": dataDict.value(forKey: "expiryDate") as Any,
            "vendorId": dataDict.value(forKey: "vendorId") as Any]
        let idStr = productDict.value(forKey: "_id") as! String
//        let stockQuantityStr:String = String(dataDict.value(forKey: "stockQuantity"))
        
        let stockQuantityStr:String = String(format: "%@", (dataDict.value(forKey: "stockQuantity")) as! CVarArg)
        
        let updatingQuantityStr:String = String(format: "%@", (dataDict.value(forKey: "updatingQuantity")) as! CVarArg)
        let expiryStr = productDict.value(forKey: "expiryDate")
        
        let expiryDateStr = expiryStr as! String
        let productStatusStr = dataDict.value(forKey: "productStatus") as! String
        
       
        let borrowLentQuantity = 0

        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let URLString_loginIndividual = Constants.BaseUrl + UpdateInventoryUrl
        
        dataDict.setValue(productStatusStr, forKey: "productStatus")
        
        let params_IndividualLogin = ["_id":idStr,"accountId":accountID,"updatingQuantity":updatingQuantityStr,"expiryDate":(expiryDateStr ?? "") as String,"userId":userID,"productDetails":dataMainObject,"stockQuantity":stockQuantityStr,"borrowLentQuantity":borrowLentQuantity] as [String : Any]
                
        print(params_IndividualLogin)
        let postHeaders_IndividualLogin = ["":""]
                    
        updateInventoryServiceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "Success" {
                            print("Success")

                            if(statusCode == 200 ){
                                
//                                if(stockQuant - updatingQunatity == 0){
//
//                                    self.updateInventoryDataArray.removeObject(at: tagValue)
//                                    self.updateInventoryTblView.reloadData()
//
//                                }
                                
//                                if(productStatusStr == "Consumed"){
//                                    self.updateInventoryDataArray.removeObject(at: tagValue)
//                                    self.updateInventoryTblView.reloadData()
//
//                                }
                                
                                self.showAlertWith(title: "Success", message: "Updated succesfully")
                                sleep(3)
                                self.getUpdateInventoryAPI()

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
    
    
    func submitShareAPI() {

        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String
        
        let URLString_loginIndividual = Constants.BaseUrl + ShareUrl
        
        let params_IndividualLogin = ["sharingUSer":shareUserArr,"quantity":shareQty ,"userId":userID,"productId":shareProdIDStr,"accountId":accountID] as [String : Any]
                
                    print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
        updateInventoryServiceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "Success" {
                            print("Success")
                            
                            self.showAlertWith(title: "Success", message: messageResp ?? "")
                            
                            self.shareView.removeFromSuperview()
                            self.shareOptionsView.removeFromSuperview()
                            self.hiddenBtn.removeFromSuperview()

                            self.getUpdateInventoryAPI()
                        }
                        else {
                            self.shareView.removeFromSuperview()
                            self.shareOptionsView.removeFromSuperview()
                            self.hiddenBtn.removeFromSuperview()

                            self.getUpdateInventoryAPI()
                            self.showAlertWith(title: "Alert", message: messageResp ?? "")
                        }
                        
                    }) { (error) in
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        print("Something Went To Wrong...PLrease Try Again Later")
                    }
                }
    
    
    func submitBorrowLentInactiveAPI() {

        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let URLString_loginIndividual = Constants.BaseUrl + VendorBorrowInactiveUrl
        
        let params_IndividualLogin = ["productId":shareProdIDStr,"accountId":accountID,"acceptanceStatus":false] as [String : Any]
                
                    print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
        updateInventoryServiceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")
                            
//                            let dataDict = self.updateInventoryDataArray.object(at: self.borrowedTagValue) as? NSDictionary
//
//                            let prodDetailsDict = dataDict?.value(forKey: "productdetails") as? NSDictionary
//
////                            let isBorrowdStr = prodDetailsDict?.value(forKey: "borrowed") as? String
//                    //
////                            if (isBorrowdStr == "no") {
////                                prodDetailsDict?.setValue("yes", forKey: "borrowed")
////
////                            }else{
//                                prodDetailsDict?.setValue("no", forKey: "borrowed")
//
////                            }
//
//                            dataDict?.setValue(prodDetailsDict, forKey: "productdetails")
//
                            self.showAlertWith(title: "Success", message: messageResp ?? "")


//                            self.updateInventoryDataArray.replaceObject(at: self.borrowedTagValue, with: dataDict!)
//                            self.updateInventoryTblView.reloadData()

                            self.hiddenBtn.removeFromSuperview()
                            self.borrowLentView.removeFromSuperview()
                            self.getUpdateInventoryAPI()

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
    
    func submitBorrowLentAPI() {
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String

        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let URLString_loginIndividual = Constants.BaseUrl + BorrowLentUrl
        
        let params_IndividualLogin = ["productId":shareProdIDStr,"quantity":quantTF.text ?? "","accountEmailId":accountTF.text ?? "","requestType":borrowRequestStr,"userId":userID,"currentAccountId":accountID] as [String : Any]
                
                    print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
        updateInventoryServiceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")
                            
//                            let dataDict = self.updateInventoryDataArray.object(at: self.borrowedTagValue) as? NSDictionary
//
//                           // let prodDetailsDict = dataDict?.value(forKey: "productdetails") as? NSDictionary
//
//                            let isBorrowdStr = dataDict?.value(forKey: "isBorrowed") as? String
//                    //
//                            if (isBorrowdStr == "false") {
//                                dataDict?.setValue("true", forKey: "borrowed")
//
//                            }else{
//                                dataDict?.setValue("false", forKey: "borrowed")
//
//                            }
//
//
                            self.showAlertWith(title: "Success", message: messageResp ?? "")
//
//
//                            self.updateInventoryDataArray.replaceObject(at: self.borrowedTagValue, with: dataDict!)
//                            self.updateInventoryTblView.reloadData()
                            self.getUpdateInventoryAPI()
                            self.hiddenBtn.removeFromSuperview()
                            self.borrowLentView.removeFromSuperview()

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
    
    func removeBorrowLentAPI()
    {
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String

        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let URLString_loginIndividual = Constants.BaseUrl + RemoveBorrowLentUrl
       

        let params_IndividualLogin = ["_id":shareProdIDStr,"accountId":accountID,"updatingQuantity":quantTF.text] as [String : Any]
                
                    print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
        updateInventoryServiceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")
                            

//
                            self.showAlertWith(title: "Success", message: messageResp ?? "")

//                            self.updateInventoryTblView.reloadData()
                            self.getUpdateInventoryAPI()
                            self.hiddenBtn.removeFromSuperview()
                            self.borrowLentView.removeFromSuperview()
                            self.checkGiveButton.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
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

}

