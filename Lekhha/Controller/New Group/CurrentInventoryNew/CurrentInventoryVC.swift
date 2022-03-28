//
//  CurrentInventoryVC.swift
//  Lekhha
//
//  Created by USM on 21/03/22.
//

import UIKit
import ObjectMapper

class CurrentInventoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var currentInventoryTV: UITableView!
    @IBOutlet var localSortMainView: UIView!
    @IBOutlet weak var localSortBgView: UIView!
    @IBOutlet weak var localSortCloseBtn: UIButton!
    @IBOutlet weak var bottomBgView: UIView!
    @IBOutlet weak var descendingLabel: UILabel!
    @IBOutlet weak var descendingView: UIView!
    @IBOutlet weak var ascendingView: UIView!
    @IBOutlet weak var ascendingLabel: UILabel!
    @IBOutlet weak var purchaseDateBtn: UIButton!
    @IBOutlet weak var expireBtn: UIButton!
    @IBOutlet weak var productNameBtn: UIButton!
    @IBOutlet weak var quantityBtn: UIButton!
    @IBOutlet weak var localSortApplyBtn: UIButton!
    @IBOutlet var localSearchMainView: UIView!
    @IBOutlet weak var localSearchBgView: UIView!
    @IBOutlet weak var localSearchClearBtn: UIButton!
    @IBOutlet weak var localSearchTFView: UIView!
    @IBOutlet weak var localSearchTF: UITextField!
    @IBOutlet weak var localSearchPurchaseDateBtn: UIButton!
    @IBOutlet weak var localSearchExpireDateBtn: UIButton!
    @IBOutlet weak var localSearchQuantityBtn: UIButton!
    @IBOutlet weak var transactionByDateCheckBtn: UIButton!
    @IBOutlet weak var localSearchStartDateView: UIView!
    @IBOutlet weak var localSearchStartDateTF: UITextField!
    @IBOutlet weak var localSearchEndDateView: UIView!
    @IBOutlet weak var localSearchEndDateTF: UITextField!
    @IBOutlet weak var localSearchCancelBtn: UIButton!
    @IBOutlet weak var localSearchApplyBtn: UIButton!
    
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
    
    @IBOutlet weak var shareCancelBtn: UIButton!
    @IBOutlet weak var shareOkBtn: UIButton!
    
    var currentInventoryResultArr = [GetCurrentInventoryResultVo]()
    var sortCurrentInventoryResultArr = [GetCurrentInventoryResultVo]()
    var serviceVC = ServiceController()
    var accountID = String()
    var sortOrderStr = ""
    var searchParamStr = ""
    var isExpandable=[false,false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    /*    shareBgView.isHidden = true
        borrowLendBgview.isHidden = true
        
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
        */
        sortOrderStr = "Ascending"
        searchParamStr = "purchaseDate"
        
        ascendingView.backgroundColor = hexStringToUIColor(hex: "FFC93C")
        descendingView.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        
        purchaseDateBtn.backgroundColor = hexStringToUIColor(hex: "FFC93C")
        expireBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        productNameBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        quantityBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        
        localSearchPurchaseDateBtn.backgroundColor = hexStringToUIColor(hex: "FFC93C")
        localSearchExpireDateBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        localSearchQuantityBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        
        purchaseDateBtn.layer.cornerRadius = 5
//        purchaseDateBtn.layer.borderColor = hexStringToUIColor(hex: "263238").cgColor
        purchaseDateBtn.layer.borderWidth = 0.5
        purchaseDateBtn.clipsToBounds = true
        
        expireBtn.layer.cornerRadius = 5
//        expireBtn.layer.borderColor = hexStringToUIColor(hex: "263238").cgColor
        expireBtn.layer.borderWidth = 0.5
        expireBtn.clipsToBounds = true
        
        productNameBtn.layer.cornerRadius = 5
//        productNameBtn.layer.borderColor = hexStringToUIColor(hex: "263238").cgColor
        productNameBtn.layer.borderWidth = 0.5
        productNameBtn.clipsToBounds = true
        
        quantityBtn.layer.cornerRadius = 5
//        quantityBtn.layer.borderColor = hexStringToUIColor(hex: "263238").cgColor
        quantityBtn.layer.borderWidth = 0.5
        quantityBtn.clipsToBounds = true
 

        
        currentInventoryTV.register(UINib(nibName: "CurrentInventoryVCTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrentInventoryVCTableViewCell")
        currentInventoryTV.separatorStyle = .none
        self.currentInventoryTV.reloadData()
        
        localSearchMainView.isHidden = true
        localSortMainView.isHidden = true
        
        localSearchBgView.backgroundColor = .white
        localSearchBgView.layer.cornerRadius = 5.0
        localSearchBgView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        localSearchBgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        localSearchBgView.layer.shadowRadius = 6.0
        localSearchBgView.layer.shadowOpacity = 0.7
        
        bottomBgView.backgroundColor = .white
        bottomBgView.layer.cornerRadius = 5.0
        bottomBgView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        bottomBgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        bottomBgView.layer.shadowRadius = 6.0
        bottomBgView.layer.shadowOpacity = 0.7
        
        localSortBgView.backgroundColor = .white
        localSortBgView.layer.cornerRadius = 5.0
        localSortBgView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        localSortBgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        localSortBgView.layer.shadowRadius = 6.0
        localSortBgView.layer.shadowOpacity = 0.7
        
        ascendingView.layer.borderColor = UIColor.gray.cgColor
        ascendingView.layer.borderWidth = 0.5
        ascendingView.layer.cornerRadius = 3
        ascendingView.clipsToBounds = true
        
        descendingView.layer.borderColor = UIColor.gray.cgColor
        descendingView.layer.borderWidth = 0.5
        descendingView.layer.cornerRadius = 3
        descendingView.clipsToBounds = true
        
        descendingView.layer.borderColor = UIColor.gray.cgColor
        descendingView.layer.borderWidth = 0.5
        descendingView.layer.cornerRadius = 3
        descendingView.clipsToBounds = true
        
        localSortApplyBtn.layer.cornerRadius = 5
        localSortApplyBtn.clipsToBounds = true
        
        localSearchApplyBtn.layer.cornerRadius = 5
        localSearchApplyBtn.clipsToBounds = true
        
        localSearchCancelBtn.layer.cornerRadius = 5
        localSearchCancelBtn.clipsToBounds = true
        
        localSearchTFView.layer.cornerRadius = 5
        localSearchTFView.clipsToBounds = true
        
        localSearchTFView.layer.cornerRadius = 5
        localSearchTFView.clipsToBounds = true
        
        
        localSearchPurchaseDateBtn.layer.cornerRadius = 5
        localSearchPurchaseDateBtn.clipsToBounds = true
        
        localSearchExpireDateBtn.layer.cornerRadius = 5
        localSearchExpireDateBtn.clipsToBounds = true
        
        localSearchQuantityBtn.layer.cornerRadius = 5
        localSearchQuantityBtn.clipsToBounds = true
        
        localSearchStartDateView.layer.borderColor = UIColor.gray.cgColor
        localSearchStartDateView.layer.borderWidth = 0.5
        localSearchStartDateView.layer.cornerRadius = 3
        localSearchStartDateView.clipsToBounds = true
        
        localSearchEndDateView.layer.borderColor = UIColor.gray.cgColor
        localSearchEndDateView.layer.borderWidth = 0.5
        localSearchEndDateView.layer.cornerRadius = 3
        localSearchEndDateView.clipsToBounds = true
        
        get_CurrentInventory_API_Call()
        
        // Do any additional setup after loading the view.
    }
    
    func get_CurrentInventory_API_Call() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        print(accountID)
        
        let URLString_loginIndividual = Constants.BaseUrl + getCurrentInventoryUrl + "623869d4b79f633f8b907d65" as String
        
        serviceVC.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
            
            let respVo:GetCurrentInventoryRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if statusCode == 200 {
                if status == "SUCCESS" {
                    if respVo.result != nil {
                        if respVo.result!.count > 0{
                            self.currentInventoryResultArr = respVo.result!
                            self.currentInventoryTV.reloadData()
                        }
                    }
                }
                else {
                    self.view.makeToast(messageResp)
                }
            }
            else {
                self.view.makeToast(messageResp)
            }
            
        }) { (error) in
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
        }
        
//        if(self.currentInventoryResult.count == 0){
//            //                           self.showEmptyMsgBtn()
//        }
        
    }
    
    func get_SortCurrentInventory_API_Call() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        print(accountID)
//        http://15.206.193.122:4500/consumer/get_by_accountid/sorting/623869d4b79f633f8b907d65/Ascending/purchaseDate/currentInventory
        let urlStr = Constants.BaseUrl + getSortingCurrentInventoryUrl + "623869d4b79f633f8b907d65/" + "\(sortOrderStr)/\(searchParamStr)/currentInventory" as String
        
        serviceVC.requestGETURL(strURL:urlStr, success: {(result) in
            
            let respVo:GetCurrentInventoryRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if statusCode == 200 {
                if status == "SUCCESS" {
                    if respVo.result != nil {
                        if respVo.result!.count > 0{
                            self.sortCurrentInventoryResultArr = respVo.result!
                            self.currentInventoryResultArr = self.sortCurrentInventoryResultArr
                            self.currentInventoryTV.reloadData()
                        }
                    }
                }
                else {
                    self.view.makeToast(messageResp)
                }
            }
            else {
                self.view.makeToast(messageResp)
            }
            
        }) { (error) in
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
        }
        
//        if(self.currentInventoryResult.count == 0){
//            //                           self.showEmptyMsgBtn()
//        }
        
    }
    
//    @IBAction func borrowCheckBtnAction(_ sender: Any) {
//    }
//    
//    @IBAction func lendCheckBtnAction(_ sender: Any) {
//    }
//    @IBAction func borrowLendCancelBtnAction(_ sender: Any) {
//    }
//    @IBAction func borrowLendOkBtnAction(_ sender: Any) {
//    }
//    @IBAction func shareSelectUserBtnAction(_ sender: Any) {
//    }
//    @IBAction func shareCancelBtnAction(_ sender: Any) {
//    }
//    @IBAction func shareOkBtnAction(_ sender: Any) {
//    }
//    
    
    // MARK: Local SORT UIButton Actions
    
    @IBAction func assendingBtnAction(_ sender: Any) {
        
        ascendingView.backgroundColor = hexStringToUIColor(hex: "FFC93C")
        descendingView.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        
        sortOrderStr = "Ascending"
    }
    @IBAction func localSortCloseBtnAction(_ sender: Any) {
        localSortMainView.isHidden = true
    }
    @IBAction func descendingBtnAction(_ sender: Any) {
        ascendingView.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        descendingView.backgroundColor = hexStringToUIColor(hex: "FFC93C")
        sortOrderStr = "Descending"
    }
    @IBAction func purchaseBtnAction(_ sender: Any) {
        purchaseDateBtn.backgroundColor = hexStringToUIColor(hex: "FFC93C")
        expireBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        productNameBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        quantityBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        searchParamStr = "purchaseDate"
    }
    @IBAction func expireBtnAction(_ sender: Any) {
        
        purchaseDateBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        expireBtn.backgroundColor = hexStringToUIColor(hex: "FFC93C")
        productNameBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        quantityBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        searchParamStr = "expireDate"
    }
    @IBAction func productNameBtnAction(_ sender: Any) {
        purchaseDateBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        expireBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        productNameBtn.backgroundColor = hexStringToUIColor(hex: "FFC93C")
        quantityBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        searchParamStr = "productName"
    }
    @IBAction func quantityBtnAction(_ sender: Any) {
        purchaseDateBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        expireBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        productNameBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        quantityBtn.backgroundColor = hexStringToUIColor(hex: "FFC93C")
        searchParamStr = "quantity"
    }
    
    // MARK: Local Search UIButton Actions
    
    @IBAction func localSortApplyBtnAction(_ sender: Any) {
        
        get_SortCurrentInventory_API_Call()
        
    }
    @IBAction func localSearchClearBtnAction(_ sender: Any) {
        localSearchMainView.isHidden = true
    }
    @IBAction func localSearchPurchaseBtnAction(_ sender: Any) {
        
        searchParamStr = "purchaseDate"
        localSearchPurchaseDateBtn.backgroundColor = hexStringToUIColor(hex: "FFC93C")
        localSearchExpireDateBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        localSearchQuantityBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
    }
    @IBAction func localSearchExpireDateBtnAction(_ sender: Any) {
        
        searchParamStr = "expireDate"
        localSearchPurchaseDateBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        localSearchExpireDateBtn.backgroundColor = hexStringToUIColor(hex: "FFC93C")
        localSearchQuantityBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
    }
    @IBAction func localSearchQuantityBtnAction(_ sender: Any) {
        searchParamStr = "quantity"
        localSearchPurchaseDateBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        localSearchExpireDateBtn.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        localSearchQuantityBtn.backgroundColor = hexStringToUIColor(hex: "FFC93C")
    }
    @IBAction func transactionByDateCheckBtnAction(_ sender: Any) {
    }
    @IBAction func localSearchCancelBtnAction(_ sender: Any) {
    }
    @IBAction func localSearchApplyBtnAction(_ sender: Any) {
    }
    
    // MARK: Main View UIButton Actions
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
    }
    @IBAction func filterBtnAction(_ sender: UIButton) {
    }
    @IBAction func sideMenuBtnAction(_ sender: UIButton) {
    }
    @IBAction func notificationBtnAction(_ sender: UIButton) {
    }
    @IBAction func addProductBtnAction(_ sender: UIButton) {
        
//        shareBgView.isHidden = false
//        borrowLendBgview.isHidden = true
    }
    @IBAction func updateInventoryBtnAction(_ sender: Any) {
        
//        shareBgView.isHidden = true
//        borrowLendBgview.isHidden = false
        
        let storyBoard = UIStoryboard(name: "CurrentInventory", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "UpdateInventoryNewViewController") as! UpdateInventoryNewViewController
        VC.updateInventoryDataArray=self.currentInventoryResultArr
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    @IBAction func localSortBtnAction(_ sender: Any) {
        
        searchParamStr = "purchaseDate"
        localSearchMainView.isHidden = true
        localSortMainView.isHidden = false
        
        let theHeight = view.frame.size.height
        localSortMainView.isHidden = false
        localSortMainView.frame = CGRect(x: 0, y: theHeight - 400 , width: self.view.frame.width, height: 400)
        //        customView.backgroundColor = UIColor.black //give color to the view
        //        pickerView.center = self.view.center
        self.view.addSubview(localSortMainView)
        
    }
    @IBAction func localSearchBtnAction(_ sender: Any) {
        
        searchParamStr = "purchaseDate"
        localSearchMainView.isHidden = false
        localSortMainView.isHidden = true
        
        let theHeight = view.frame.size.height
        localSearchMainView.isHidden = false
        localSearchMainView.frame = CGRect(x: 0, y: theHeight - 400 , width: self.view.frame.width, height: 400)
        //        customView.backgroundColor = UIColor.black //give color to the view
        //        pickerView.center = self.view.center
        self.view.addSubview(localSearchMainView)
    }    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentInventoryResultArr.count > 0 {
            return currentInventoryResultArr.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currentInventoryTV.dequeueReusableCell(withIdentifier: "CurrentInventoryVCTableViewCell", for: indexPath) as! CurrentInventoryVCTableViewCell
        tableView.separatorStyle = .none
        cell.dropDownButton.tag=indexPath.row
        
        if currentInventoryResultArr.count > 0 {
            let obj = currentInventoryResultArr[indexPath.row]
            cell.prodNameLbl.text = obj.productdetails?.productName ?? ""
            cell.prodIDLbl.text = obj.productdetails?.orderId
            cell.stockUnitLbl.text = obj.stockUnitDetails?[0].stockUnitName ?? ""
            let convertedExpiryDate = convertServerDateFormatter1(date: obj.createdDate ?? "")
            
            let postedTime = convertedExpiryDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date = dateFormatter.date(from: postedTime)
            if date != nil {
                let timeAgo:String = timeAgoSinceDate(date: date! as NSDate, numericDates: true)
                cell.expiryLabel.text = "Expires in \(timeAgo)"
            }
            let convertDate = convertServerDateFormatter(date: obj.createdDate ?? "")
            cell.expDateLbl.text = convertDate
            cell.priceUnitLabel.text = obj.priceUnitDetails?[0].priceUnit ?? ""
            cell.pricePerStockUnitLabel.text = "\(obj.productdetails?.unitPrice ?? 0)"
            cell.totalPriceLabel.text = "\(obj.productdetails?.price ?? 0)"
            
            var stockQQu=Float()
            if let stockQuan = obj.productdetails?.stockQuantity as? Double {
                cell.stockQtyLbl.text = String(format:"%.3f",stockQuan)
                stockQQu=Float(stockQuan)
            }
            else if let stockQuant = obj.productdetails?.stockQuantity as? Float {
                cell.stockQtyLbl.text = String(format:"%.3f",stockQuant)
                stockQQu=Float(stockQuant)
            }
            else {
                cell.stockQtyLbl.text = obj.productdetails?.stockQuantity as? String
                stockQQu=Float(obj.productdetails?.stockQuantity as? String ?? "") ?? 0
            }
            if obj.storageLocationLevel1Details!.count > 0 {
                
                cell.storageLoclbl.text = obj.storageLocationLevel1Details?[0].slocName ?? ""
            }
            if obj.storageLocationLevel2Details!.count > 0 {
                cell.level2Label.text = obj.storageLocationLevel2Details?[0].slocName ?? ""
            }
            if obj.storageLocationLevel3Details!.count > 0 {
                cell.level3Label.text = obj.storageLocationLevel3Details?[0].slocName ?? ""
            }
      /*      let borrowedStatus = obj.productdetails?.status
           
                if borrowedStatus == true
                {
                    if let borroeLent=productDict.value(forKey: "borrowLentDetails")as? NSDictionary{
                        let quan=borroeLent.value(forKey: "quantity") as? String ?? ""
                        cell.borrowLentLabel.text="Borrow(Qty:" + quan + ")"
                    }
                    cell.borrowedChckBox.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
                }else{
                    cell.borrowedChckBox.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)

                }
            let sharedStatus = productDict.value(forKey: "shared") as? Bool

            if(sharedStatus == true)
            {
                cell.shareCheckButton.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
            }else{
                cell.shareCheckButton.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)

            }
            
            let giveAway = dataDict.value(forKey: "giveAwayStatus") as? Bool

            if(giveAway == true){
                cell.checkboxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
                
            }else{
                cell.checkboxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)

            }
            cell.checkboxBtn.addTarget(self, action: #selector(giveAwayCheckBoBtnTapped), for: .touchUpInside)
            
            cell.checkboxBtn.tag = indexPath.row
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(onEditDetailsBtnTap), for: .touchUpInside)
                
            */

            let prodArray = obj.productdetails?.productImages
            
                if(prodArray?.count ?? 0  > 0){

                            let dict = prodArray?[0] as! NSDictionary
                            let imageStr = dict.value(forKey: "0") as! String
                            if !imageStr.isEmpty {
                                let imgUrl:String = imageStr
                                let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                let imggg = Constants.BaseImageUrl + trimStr
    //                            let url = URL.init(string: imggg)
    //                            let fileUrl = URL(fileURLWithPath: imggg)
                                let fileUrl = URL(string: imggg)

    //                            cell.prodImgView?.sd_setImage(with: fileUrl , placeholderImage: UIImage(named: "add photo"))
                                cell.prodImgView?.sd_setImage(with: fileUrl, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)
                                cell.prodImgView?.contentMode = UIView.ContentMode.scaleAspectFit
                                
                            }
                            else {
                                cell.prodImgView?.image = UIImage(named: "no_image")
                            }
                }else{
                    cell.prodImgView?.image = UIImage(named: "no_image")
                }
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(onEditDetailsBtnTap), for: .touchUpInside)
                
        cell.dropDownButton.addTarget(self, action: #selector(expandableCell(sender:)), for: .touchUpInside)
            cell.descriptionLabel.text = obj.productdetails?.description ?? ""
        if isExpandable[indexPath.row] == true {
            
//            cell.descriptionLabel.isHidden = false            
            cell.dropDownButton.setImage(UIImage(named: "Up"), for: .normal)
        }
        else{
//            cell.descriptionLabel.isHidden = true
            cell.dropDownButton.setImage(UIImage(named: "arrowDown"), for: .normal)
        }
    }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isExpandable[indexPath.row] == true
        {
        return 510
        }
        else
        {
            return 128
        }
    }
    @objc func expandableCell(sender:UIButton)
    {
        if isExpandable[sender.tag] == true {
            isExpandable[sender.tag]=false
           sender.setImage(UIImage(named: "Up"), for: .normal)
           currentInventoryTV.reloadData()
          }
          else if isExpandable[sender.tag] == false  {
            isExpandable[sender.tag]=true
           sender.setImage(UIImage(named: "arrowDown"), for: .normal)
            currentInventoryTV.reloadData()
               }
    }
    @objc func onEditDetailsBtnTap(sender:UIButton)
    {
        let storyBoard = UIStoryboard(name: "CurrentInventory", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "EditInventoryNewViewController") as! EditInventoryNewViewController
        VC.modalPresentationStyle = .fullScreen
        let productDict = currentInventoryResultArr[sender.tag]
        VC.prodIDStr = productDict.id as! String
        VC.productID = productDict.productID as! String
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    func convertServerDateFormatter1(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let convertedDate = dateFormatter.date(from: date)

    guard dateFormatter.date(from: date) != nil else {
    //    assert(false, "no date from string")
        return ""
    }
        
    //    dateFormatter.dateFormat = "dd MMM yyyy "///this is what you want to convert format
    //    dateFormatter.dateFormat = "dd/MM/yyyy"
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)

        return timeStamp

    }
    
    // MARK: Time Ago Since Date
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour"
            } else {
                return "An hour"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute"
            } else {
                return "A minute"
            }
        } else if (components.second! >= 3) {
//            return "\(components.second!) seconds ago"
            return "A minute"
        } else {
            return "Just now"
        }
    }
}
