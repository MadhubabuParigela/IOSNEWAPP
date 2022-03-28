//
//  GiveAwayViewController.swift
//  Lekha
//
//  Created by Mallesh on 11/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper

class GiveAwayViewController: UIViewController,GiveAwayBtnCellDelegate {
        
    @IBOutlet weak var giveAwayTblView: UITableView!
    
    @IBOutlet weak var kmSlider: UISlider!
    @IBOutlet weak var minRangeLbl: UILabel!
    @IBOutlet weak var maxRangeLbl: UILabel!
    
    var serviceVC = ServiceController()
    var giveAwayListArr = [GiveAwayResultVo]()
    var idValue = ""
    var locStartRange = Float(0)
    var locEndRange = Float(10)
    var headerTitleStr = String()
    var sideMenuView = SideMenuView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTitleStr = "GiveAway"
        
        giveAwayTblView.dataSource = self
        giveAwayTblView.delegate = self
        giveAwayTblView.separatorStyle = .none
        
        let nibName1 = UINib(nibName: "GiveAwayTableViewCell", bundle: nil)
        giveAwayTblView.register(nibName1, forCellReuseIdentifier: "GiveAwayTableViewCell")
        let userDefaults=UserDefaults.standard
        let minn=userDefaults.value(forKey: "minVicinity") as? Float
        let maxx=userDefaults.value(forKey: "maxVicinity") as? Float
        kmSlider.minimumValue = Float(minn ?? 0)
        kmSlider.maximumValue = 10.0
        
//        let maxValue = (defaults.value(forKey: "maxVicinity") ?? 0)
        kmSlider.setValue(Float(maxx ?? 0), animated: false)
        maxRangeLbl.text=String(Float(maxx ?? 0)) + "KM"
//        maxVicinity
        
        kmSlider.isContinuous = false
        if(headerTitleStr == "GiveAway"){
            kmSlider.addTarget(self, action:#selector(sliderGiveAwayValueDidChange(sender:)), for: .valueChanged)

        }
        
        get_GiveAway_API_Call()

        // Do any additional setup after loading the view.
    }
    
    @objc func sliderValueDidChange(sender: UISlider) {
        locEndRange = Float(String(format: "%.2f", sender.value)) ?? 0
        
        if(locEndRange <= 1){
            maxRangeLbl.text = "\(Int(sender.value)) Km"

        }else{
            maxRangeLbl.text = "\(Int(sender.value)) Kms"

        }
        
        if(headerTitleStr == "GiveAway"){
            setVicinityAPI()

        }else{
//            getCosumerConnectAPI()

        }

   }
    
    @objc func sliderGiveAwayValueDidChange(sender: UISlider){
       
        let endR = sender.value
        locEndRange=Float(String(format: "%.2f", endR)) ?? 0
        if(locEndRange <= 1){
           
            maxRangeLbl.text = "\(locEndRange) Km"

        }else{
           
            maxRangeLbl.text = "\(locEndRange) Kms"

        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(locEndRange, forKey: "maxVicinity")

        setVicinityAPI()

    }
    
    @objc func onchangedTheSliderValue(){
//        minRangeLbl.text = "\(Int(rangeSlider.lowerValue)) Km"
//        maxRangeLbl.text = "\(Int(rangeSlider.upperValue)) Km"

    }
    
    @IBAction func backBtnTap(_ sender: Any) {
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
    
    func get_GiveAway_API_Call() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let URLString_loginIndividual = Constants.BaseUrl + "endUsers/getAllGiveAwayList/\(accountID)"
        
        serviceVC.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
            
            let respVo:GiveAwayRepVo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if statusCode == 200 {
                
                if status == "SUCCESS" {
                    
                    self.giveAwayListArr = respVo.result!
                    self.giveAwayTblView.reloadData()
                    
                }else {
                   
                }
            }
            else {
                
            }
                        
        }) { (error) in
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
        }
    }
    
    func delete_CancelBid_API_Call() {
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        let URLString_loginIndividual = Constants.BaseUrl + "endUsers/deleteBid/\(idValue)"
        
        serviceVC.requestDeleteURL(strURL:URLString_loginIndividual, success: {(result) in
            
            let respVo:GiveAwayRepVo = Mapper().map(JSON: result as! [String : Any])!
            let status = respVo.status
            let statusCode = respVo.statusCode
            let msgStr = respVo.message
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            if statusCode == 200 {
                if status == "SUCCESS" {
                    self.view.makeToast(msgStr)
                    self.get_GiveAway_API_Call()
                    self.giveAwayTblView.reloadData()
                }else {
                }
            }
            else {
            }
        }) { (error) in
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
        }
    }
    
    func setVicinityAPI() {

        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        let defaults = UserDefaults.standard
        let accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let URLString_loginIndividual = Constants.BaseUrl + SetGiveAwayRangeUrl
         
                    let params_IndividualLogin = [
                        "accountId" : accountID,
                        "from" : locStartRange,
                        "to" : locEndRange
                    ] as [String : Any]
                
                
                    let postHeaders_IndividualLogin = ["":""]
                    
        serviceVC.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            
                            if(statusCode == 200 ){
                                
//                                let alert = UIAlertController(title: "Success", message: "Details updated successfully", preferredStyle: UIAlertController.Style.alert)
//
//                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
//
//
//                                }))
//                                self.present(alert, animated: true, completion: nil)

                                
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
// MARK: UITableView Methods
extension GiveAwayViewController:UITableViewDataSource,UITableViewDelegate {
    //    number Of Rows In Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if giveAwayListArr.count > 0 {
            return giveAwayListArr.count
        }
        return 0
    }
    //    cell For Row At indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:GiveAwayTableViewCell = giveAwayTblView.dequeueReusableCell(withIdentifier: "GiveAwayTableViewCell", for: indexPath) as! GiveAwayTableViewCell
        cell.selectionStyle = .none
        
        cell.cellDelegate = self
        cell.cancelBidBtn.tag = indexPath.row
        cell.productChangeHistoryBtn.tag = indexPath.row
        cell.biddingDetailsBtn.tag = indexPath.row
        
        if giveAwayListArr.count > 0 {
            let obj = giveAwayListArr[indexPath.row]
            cell.productIdLabel.text = obj.productDetails?.productUniqueNumber
            cell.productNameLabel.text = obj.productDetails?.productName
            cell.descriptionLabel.text = obj.productDetails?.description
            cell.stockQuantityLabel.text = String(format:"%.3f",obj.productDetails?.stockQuantity ?? 0)
            cell.offeredQuantityLabel.text = String(format:"%.3f",obj.offeredQuantity ?? 0)
            if obj.stockUnitDetails?.count ?? 0>0
            {
            cell.stockUnitLabel.text = "\(obj.stockUnitDetails![0].stockUnitName ?? "")"
            }
            
            let purDateStr = obj.productDetails?.purchaseDate ?? ""
            if purDateStr != "" {
            if purDateStr != "<null>" {
                let purStr = self.convertDateFormater(obj.productDetails?.purchaseDate ?? "")
                if purStr != "" {
                    cell.purchaseDateLabel.text = "\(purStr)"
                }
            }
            else {
                cell.purchaseDateLabel.text = ""
            }
            }
            else {
                cell.purchaseDateLabel.text = ""
            }
                let expDateStr = obj.productDetails?.expiryDate ?? ""
                if expDateStr != "" {
                if expDateStr != "<null>" {
                    let expStr = self.convertDateFormater(obj.productDetails?.expiryDate ?? "")
                    if expStr != "" {
                        cell.expireDateLabel.text = "\(expStr)"
                    }
                }
                else {
                    cell.expireDateLabel.text = ""
                }
                }
                else {
                    cell.expireDateLabel.text = ""
                }
            cell.pricePerStockUnitLabel.text = String(format:"%.2f",obj.productDetails?.unitPrice ?? 0)
            cell.totalPriceLabel.text = String(format:"%.2f", obj.productDetails?.price ?? 0)
            cell.statusBidLabel.text = "\(obj.status ?? false)"
            
            let dataDict = obj.productDetails
            let prodArray = dataDict?.productImages
            if(prodArray?.count ?? 0  > 0){

                        let dict = prodArray?[0] as? NSDictionary
                let imageStr = dict?.value(forKey: "0") as! String
                        if !imageStr.isEmpty {
                            let imgUrl:String = imageStr
                            let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                            let imggg = Constants.BaseImageUrl + trimStr
                            let fileUrl = URL(string: imggg)
                            cell.productImgView?.sd_setImage(with: fileUrl, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)
                            cell.productImgView?.contentMode = UIView.ContentMode.scaleAspectFit
                            
                        }
                        else {
                            cell.productImgView?.image = UIImage(named: "no_image")
                        }
            }else{
                cell.productImgView?.image = UIImage(named: "no_image")

            }
        }
        return cell
    }
    func didCancelBidPressBtn(_ tag: Int) {
        let index = NSIndexPath(row: tag, section: 0)
        let obj = giveAwayListArr[index.row]
        idValue = obj._id ?? ""
        delete_CancelBid_API_Call()
    }
    
    func didChangeHistoryPressBtn(_ tag: Int) {
        let index = NSIndexPath(row: tag, section: 0)
        let obj = giveAwayListArr[index.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "ProductChangeHistoryViewController") as! ProductChangeHistoryViewController
        VC.modalPresentationStyle = .fullScreen
        VC.productId = obj.productId ?? ""
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func didBiddingDetailsPressBtn(_ tag: Int) {
//        GiveAwayDetailViewController
        let index = NSIndexPath(row: tag, section: 0)
        let obj = giveAwayListArr[index.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GiveAwayDetailViewController") as! GiveAwayDetailViewController
        vc.idStr = obj.productId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //    height For Row At indexPath
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 500
    }
    //    did Select Row At indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func convertDateFormater(_ date: String) -> String
        {
            let dateFormatter = DateFormatter()
//          yyyy-MM-dd'T'HH:mm:ssZ   "yyyy-MM-dd HH:mm:ss" 2022-01-18T00:00:00.000Z
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formatterr = DateFormatter()
        formatterr.dateFormat = "dd/MM/yyyy"
        return formatterr.string(from: date!)
        }
}
