//
//  UpdateInventoryNewViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 24/03/22.
//

import UIKit
import ObjectMapper
import DropDown

class UpdateInventoryNewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateInventoryTblView.delegate = self
        updateInventoryTblView.dataSource = self
        stockStatusArray = ["Available","Expired","Consumed","Returned"]
        
        animatingView()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var borrowCheckImg: UIImageView!
    @IBOutlet weak var borrowLabel: UILabel!
    
    @IBOutlet weak var lendCheckImg: UIImageView!
    @IBOutlet weak var lendLabel: UILabel!
    
    @IBOutlet weak var borrowLendAccountView: UIView!
    
    @IBOutlet weak var borrowLendAccountTF: UITextField!
    @IBOutlet weak var borrowLendQuantityView: UIView!
    
    @IBOutlet weak var borrowLendQuantityTF: UITextField!
    
    @IBOutlet weak var borrowLendCancelBtn: UIButton!
    @IBOutlet weak var borrowLendOkBtn: UIButton!
    @IBOutlet weak var shareBgView: UIView!
    @IBOutlet weak var borrowLendBgview: UIView!
    
    @IBOutlet weak var shareSlectUserView: UIView!
    @IBOutlet weak var shareTF: UITextField!
    @IBOutlet weak var shareSelectUserBtn: UIButton!
    @IBOutlet weak var shareQuantityView: UIView!
    @IBOutlet weak var shareQuantityTF: UITextField!
    @IBOutlet weak var transparentView:UIView!
    @IBOutlet weak var shareCancelBtn: UIButton!
    @IBOutlet weak var shareOkBtn: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        shareBgView.isHidden = true
        borrowLendBgview.isHidden = true
        transparentView.isHidden=true
        shareCancelBtn.layer.cornerRadius = 8
        shareCancelBtn.clipsToBounds = true
        
        shareOkBtn.layer.cornerRadius = 8
        shareOkBtn.clipsToBounds = true
        
        borrowLendCancelBtn.layer.cornerRadius = 8
        borrowLendCancelBtn.clipsToBounds = true
        
        borrowLendOkBtn.layer.cornerRadius = 8
        borrowLendOkBtn.clipsToBounds = true
        
        borrowLendAccountView.layer.borderColor = UIColor.gray.cgColor
        borrowLendAccountView.layer.borderWidth = 0.5
        borrowLendAccountView.layer.cornerRadius = 3
        borrowLendAccountView.clipsToBounds = true
        
        borrowLendQuantityView.layer.borderColor = UIColor.gray.cgColor
        borrowLendQuantityView.layer.borderWidth = 0.5
        borrowLendQuantityView.layer.cornerRadius = 3
        borrowLendQuantityView.clipsToBounds = true
        
        shareSlectUserView.layer.borderColor = UIColor.gray.cgColor
        shareSlectUserView.layer.borderWidth = 0.5
        shareSlectUserView.layer.cornerRadius = 3
        shareSlectUserView.clipsToBounds = true
        
        shareQuantityView.layer.borderColor = UIColor.gray.cgColor
        shareQuantityView.layer.borderWidth = 0.5
        shareQuantityView.layer.cornerRadius = 3
        shareQuantityView.clipsToBounds = true
        
        shareBgView.backgroundColor = .white
        shareBgView.layer.cornerRadius = 5.0
        shareBgView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        shareBgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shareBgView.layer.shadowRadius = 6.0
        shareBgView.layer.shadowOpacity = 0.7
        
        borrowLendBgview.backgroundColor = .white
        borrowLendBgview.layer.cornerRadius = 5.0
        borrowLendBgview.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        borrowLendBgview.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        borrowLendBgview.layer.shadowRadius = 6.0
        borrowLendBgview.layer.shadowOpacity = 0.7
        
        self.parseData()
    }
    @IBAction func borrowCheckBtnAction(_ sender: Any) {
    }
    
    @IBAction func lendCheckBtnAction(_ sender: Any) {
    }
    @IBAction func borrowLendCancelBtnAction(_ sender: Any) {
        self.borrowLendBgview.isHidden=true
        self.shareBgView.isHidden=true
        transparentView.isHidden=true
    }
    @IBAction func borrowLendOkBtnAction(_ sender: Any) {
        self.borrowLendBgview.isHidden=true
        self.shareBgView.isHidden=true
        transparentView.isHidden=true
    }
    @IBAction func shareSelectUserBtnAction(_ sender: Any) {
    }
    @IBAction func shareCancelBtnAction(_ sender: Any) {
        self.borrowLendBgview.isHidden=true
        self.shareBgView.isHidden=true
        transparentView.isHidden=true
    }
    @IBAction func shareOkBtnAction(_ sender: Any) {
        self.borrowLendBgview.isHidden=true
        self.shareBgView.isHidden=true
        transparentView.isHidden=true
    }
    
    var stockStatusArray = NSMutableArray()
    var updateInventoryDataArray = [GetCurrentInventoryResultVo]()
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
    @IBOutlet weak var homeBtnTap: UIButton!
    var isCategoryBtnTapped = Bool()
    var updateInventoryServiceCntrl = ServiceController()
    @IBAction func homeBtnTapped(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "CurrentInventory", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryVC
        self.navigationController?.pushViewController(VC, animated: true)

    }
    var vendorListResult = NSMutableArray()

    @IBOutlet weak var updateInventoryTblView: UITableView!
    //****************** TableView Delegate Methods*************************//
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return updateInventoryDataArray.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = updateInventoryTblView.dequeueReusableCell(withIdentifier: "UpdateInventoryNewTableViewCell", for: indexPath) as! UpdateInventoryNewTableViewCell
        let productDict:GetCurrentInventoryResultVo = updateInventoryDataArray[indexPath.row]
        
        let dataDict = productDict.productdetails
        var stockQuan=String()
        let aastockQuan=dataDict?.stockQuantity
        stockQuan=String(format:"%.3f",aastockQuan!)
       
        let stockUnitDetails=productDict.stockUnitDetails
       
        let storagelocationLevel1=productDict.storageLocationLevel1Details
        let storagelocationLevel2=productDict.storageLocationLevel2Details
        let storagelocationLevel3=productDict.storageLocationLevel3Details
        if stockUnitDetails?.count ?? 0>0
        {
            let stockUnitDetailsDic=stockUnitDetails?[0]
            cell.stockUnitTF.text = stockUnitDetailsDic?.stockUnitName
        }
        else
        {
            cell.stockUnitTF.text = ""
        }
       
        if storagelocationLevel1?.count ?? 0>0
        {
            let storagelocationLevel1Dic=storagelocationLevel1?[0]
            cell.storageLocationTF.text = storagelocationLevel1Dic?.slocName
        }
        else
        {
            cell.storageLocationTF.text = ""
        }
        if storagelocationLevel2?.count ?? 0>0
        {
            let storagelocationLevel2Dic=storagelocationLevel2?[0]
            cell.storageLocationLevel2.text = storagelocationLevel2Dic?.slocName
        }
        else
        {
            cell.storageLocationLevel2.text = ""
        }
        if storagelocationLevel3?.count ?? 0>0
        {
            let storagelocationLevel3Dic=storagelocationLevel3?[0]
            cell.storageLocationLevel3.text = storagelocationLevel3Dic?.slocName
        }
        else
        {
            cell.storageLocationLevel3.text = ""
        }
        cell.idLbl?.text = dataDict?.productUniqueNumber as? String
        
        cell.prodNameLbl.text = dataDict?.productName as? String
        cell.descriptionLbl.text = dataDict?.description as? String
        cell.stockQuanTF.text = stockQuan
       
        cell.currentInventoryBtn.setTitle(dataDict?.productStatus as? String, for: .normal)
        
        
        let isUpdatedQuan = dataDict?.isUpdatedQuan as! String
        
        cell.expiredStockTF.keyboardType = UIKeyboardType.decimalPad

        let productStatusStr = dataDict?.productStatus as! String
        
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

        cell.expiredStockTF.text = stockQuan
        
//       updatingQuantity
        

        let expiryDate = (productDict.expiryDate as? String) ?? ""
            let convertedExpiryDate = convertServerDateFormatter(date: expiryDate)
        

        if(convertedExpiryDate != ""){
            cell.expiryDateBtn.setTitle(convertedExpiryDate as? String, for: . normal)

        }

        if(convertedExpiryDate == "" || convertedExpiryDate == nil){
            let vall=productDict.expiryDate as? String
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
        
//        let borrowedStatus = productDict.value(forKey: "isBorrowed") as? Bool
//        let lentStatus = productDict.value(forKey: "isLent") as? Bool
//
//        if(borrowedStatus == true){
//            if let borroeLent=productDict.value(forKey: "borrowLentDetails")as? NSDictionary{
//                let quan=borroeLent.value(forKey: "quantity") as? String ?? ""
//                cell.borrowLentTxtLbl.setTitle("Borrow(Qty:" + quan + ")", for: .normal)
//            }
//            cell.isBorrowedCheckBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
////            cell.borrowLentTxtLbl.setTitle("Borrow", for: .normal)
//
//        }else if(lentStatus == true){
//            if let borroeLent=productDict.value(forKey: "borrowLentDetails")as? NSDictionary{
//                let quan=borroeLent.value(forKey: "quantity") as? String ?? ""
//                cell.borrowLentTxtLbl.setTitle("Lent(Qty:"+quan+")", for:.normal)
//            }
//            cell.isBorrowedCheckBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
////            cell.borrowLentTxtLbl.setTitle("Lent", for: .normal)
//
//        }else{
//            cell.isBorrowedCheckBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
//            cell.borrowLentTxtLbl.setTitle("Borrow/Lent", for: .normal)
//
//        }
        
//        let sharedStatus = productDict.value(forKey: "shared") as? Bool
//
//        if(sharedStatus == true){
//
//            cell.shareBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
//
//        }else{
//            cell.shareBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
//
//        }
        
        
        cell.isBorrowedCheckBtn.addTarget(self, action: #selector(borrowedCheckBoxBtnTapped), for: .touchUpInside)
        
        cell.isBorrowedCheckBtn.tag = indexPath.row
        
        cell.shareBtn.addTarget(self, action: #selector(shareCheckBoxBtnTapped), for: .touchUpInside)
//
        cell.shareBtn.tag = indexPath.row


        cell.currentInventoryBtn.addTarget(self, action: #selector(onCurrentInventoryStatusBtnTapped), for: .touchUpInside)
//
        cell.expiryDateBtn.addTarget(self, action: #selector(onExpiryDateBtnTapped), for: .touchUpInside)
//
        cell.updateDetailsBtn.addTarget(self, action: #selector(onUpdateDetailsBtnTapped), for: .touchUpInside)
//
//        cell.editDetailsBtn.addTarget(self, action: #selector(onEditDetailsBtnTap), for: .touchUpInside)
        
        //cell.editDetailsBtn.tag = indexPath.row
        cell.updateDetailsBtn.tag = indexPath.row
        
        cell.expiredStockTF.delegate = self
        cell.expiredStockTF.tag = indexPath.row
        
        let giveAway = dataDict?.giveAwayStatus as? Bool
        
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
       // cell.editDetailsBtn.setAttributedTitle(attributedString, for: .normal)

        let buttonTitleStr1 = NSMutableAttributedString(string:"Change History", attributes:attrs1)
        attributedString1.append(buttonTitleStr1)
        cell.changeHistoryBtn.setAttributedTitle(attributedString1, for: .normal)
        
        //cell.changeHistoryBtn.addTarget(self, action: #selector(productChangeHistoryBtnTapprd), for: .touchUpInside)
        
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
            
//            cell.prodImgConstant.constant = 30
//            cell.prodIdConstant.constant = 30
//
            cell.updateDetailsBtn.isHidden = false
           // cell.editDetailsBtn.isHidden = false
            
            cell.currentInventoryBtn.backgroundColor = .clear
            cell.expiryDateBtn.backgroundColor = .clear
            
            cell.currentInventoryBtn.isUserInteractionEnabled = true
            cell.expiryDateBtn.isUserInteractionEnabled = true
            cell.isBorrowedCheckBtn.isUserInteractionEnabled=true
        }

        if(isUpdatedQuan == "Yes"){
            cell.expiredStockTF.text = String(format:"%.3f",dataDict?.updatingQuantity as? Double ?? 0)
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

        let prodArray = dataDict?.productImages as? NSArray

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
        //cell.editDetailsBtn.isHidden=true
        if(productStatusStr == "Consumed" || productStatusStr == "Expired" || productStatusStr == "Returned"){
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let result = formatter.string(from: date)
            cell.expiryDateBtn.setTitle(result, for: .normal)
        }
        return cell

    }
    @objc func borrowedCheckBoxBtnTapped(sender:UIButton)
    {
        self.shareBgView.isHidden=true
        self.borrowLendBgview.isHidden=false
        transparentView.isHidden=false
    }
    @objc func shareCheckBoxBtnTapped(sender:UIButton)
    {
        self.borrowLendBgview.isHidden=true
        self.shareBgView.isHidden=false
        transparentView.isHidden=false
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
        
        let productDict:GetCurrentInventoryResultVo = updateInventoryDataArray[expiryDateTagValue]
        
        let dataDict = productDict.productdetails
        
        productDict.expiryDate=result
        
        productDict.productdetails=dataDict
        
        updateInventoryDataArray[expiryDateTagValue]=productDict
        updateInventoryTblView.reloadData()


    }
    var expiryDateTagValue = Int()
    @objc func dueDateChanged(sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: picker.date)

//         FiltterView.startDateBtn.setTitle(selectedDate, for: .normal)
        
        let productDict:GetCurrentInventoryResultVo = updateInventoryDataArray[expiryDateTagValue]
        
        let dataDict = productDict.productdetails
        
        productDict.expiryDate=selectedDate
        productDict.productdetails=dataDict
        updateInventoryDataArray[expiryDateTagValue]=productDict
        updateInventoryTblView.reloadData()

    }
    
    @objc func doneBtnTap(_ sender: UIButton) {

        hiddenBtn.removeFromSuperview()
        pickerDateView.removeFromSuperview()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 650
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    var dropDown=DropDown()
    var currentStatusTagValue=Int()
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
    func sendnamedfields(fieldname: String, idStr: String) {
        
        if(isShareViewStatusStr == "1"){
            sharedUserIDStr = idStr
            sharedUserNameStr = fieldname
            selectAccBtn.setTitle("  \(fieldname)", for: .normal)

        }else{
            let productDict:GetCurrentInventoryResultVo = updateInventoryDataArray[currentStatusTagValue]
        
            let dataDict = productDict.productdetails
            dataDict?.productStatus=fieldname
            productDict.productdetails=dataDict
            updateInventoryDataArray[currentStatusTagValue]=productDict
    
            updateInventoryTblView.reloadData()

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
    var introService=ServiceController()
    func updateInventoryDetailsAPIWithTag(tagValue:Int) {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String
        
        let productDict:GetCurrentInventoryResultVo = updateInventoryDataArray[tagValue]
        
        let dataDict = productDict.productdetails
        var dataMainObject=NSDictionary()
        dataMainObject = ["_id": dataDict?._id as Any,
                          "accountId": dataDict?.accountId as Any,
                          "category": dataDict?.category as Any,
                          "description": dataDict?.description as Any,
                          "orderId": dataDict?.orderId as Any,
           "price": dataDict?.price as Any,
            "priceUnit": dataDict?.priceUnit as Any,
            "productImages": dataDict?.productImages as Any,
            "productName": dataDict?.productName as Any,
            "productUniqueNumber": dataDict?.productUniqueNumber as Any,
            "purchaseDate": dataDict?.purchaseDate as Any,
            "stockQuantity": dataDict?.stockQuantity as Any,
            "stockUnit": dataDict?.stockUnit as Any,
            "storageLocation1": dataDict?.storageLocation1 as Any,
            "storageLocation2": dataDict?.storageLocation2 as Any,
            "storageLocation3": dataDict?.storageLocation3 as Any,
            "subCategory": dataDict?.subCategory as Any,
            "unitPrice": dataDict?.unitPrice as Any,
            "uploadType": dataDict?.uploadType as Any,
            "expiryDate": dataDict?.expiryDate as Any,
            "userId":userID as Any,
            "vendorId": dataDict?.vendorId as Any]
        let URLString_loginIndividual = Constants.BaseUrl + updateInventoryNewUrl
        
        let postHeaders_IndividualLogin = ["":""]
        
        introService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: dataMainObject as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
            
            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            _ = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if status == "SUCCESS" {
                
            }else {
                self.showAlertWith(title: "Alert", message: messageResp ?? "")
            }
            
        }) { (error) in
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
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
    func parseData() {
        
        let updateDateArray:[GetCurrentInventoryResultVo] = updateInventoryDataArray
        
        for i in 0..<updateDateArray.count {

            let productDict = updateDateArray[i]
            
            let dataDict = productDict.productdetails
            var stockQuan=Float()
            stockQuan=Float(dataDict?.stockQuantity ?? Double())
            dataDict?.updatingQuantity=stockQuan
            dataDict?.isUpdatedQuan="No"
            
            let currentDate = Date()
            let eventDatePicker = UIDatePicker()
            
            eventDatePicker.datePickerMode = UIDatePicker.Mode.date
            eventDatePicker.minimumDate = currentDate
                   
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let selectedDate = dateFormatter.string(from: eventDatePicker.date)
            productDict.expiryDate=selectedDate
            productDict.productdetails=dataDict

        }
        
        print(updateInventoryDataArray)
        
        updateInventoryDataArray = updateDateArray
        updateInventoryTblView.reloadData()

    }
    @objc func onUpdateDetailsBtnTapped(sender:UIButton){
        
        self.view.endEditing(true)
        let productDict:GetCurrentInventoryResultVo = updateInventoryDataArray[sender.tag]
        let dataDict = productDict.productdetails

        let productStatusStr = dataDict?.productStatus as! String
        
        if(productStatusStr == "Available"){
            self.showAlertWith(title: "Alert", message: "You are trying to update the item without changing the status")
            return
        }

        var stockQuant=Float()
        let aastockQuan=dataDict?.stockQuantity
      
        stockQuant=Float(aastockQuan ?? 0.0)
       
        var updatingQunatity=Float()
        let aastockQuan1=dataDict?.updatingQuantity
        
        updatingQunatity=Float(aastockQuan1 ?? 0)
        
        
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
}
