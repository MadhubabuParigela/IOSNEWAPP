//
//  ConsumerConnectDetailedViewController.swift
//  Lekhha
//
//  Created by USM on 01/06/21.
//

import UIKit
import ObjectMapper
import GoogleMaps

class ConsumerConnectDetailedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var emptyMsgBtn = UIButton()
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    var sideMenuView = SideMenuView()
    var acceptBidView = UIView()
    var idStr = String()
    var acceptBidDict = NSDictionary()
    var consumerDetailsArray=NSDictionary()
    var consumerProductArray=NSArray()
    var reqQtyTF = UITextField()
    var counterPriceTF = UITextField()
    var totalPriceTF = UITextField()
    var accountID = String()
    var servCntrl = ServiceController()
    let hiddenBtn = UIButton()
    var declineIdStr = ""
    var collapsedSection=NSMutableArray()
    var sectionData=NSMutableArray()
    var locRange=Float()
    var productIDD=String()
    var accounntId=String()
    var prodductName=String()
    
    var consumerConnectResult = NSMutableArray()
var isExpandable=[Bool]()
    @IBAction func menuBtnTapped(_ sender: Any) {
        toggleSideMenuViewWithAnimation()

    }
    
    @IBOutlet weak var lookingForTF: UITextField!

    @IBOutlet weak var consumerConnectTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       

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
        
        animatingView()
       // getConsumerConnectDetailsAPI()
        self.consumerConnectResult = consumerDetailsArray.value(forKey: "result")  as? NSMutableArray ?? NSMutableArray()
        
        self.sectionData = consumerDetailsArray.value(forKey: "result")  as? NSMutableArray  ?? NSMutableArray()
        if(self.consumerConnectResult.count > 0){
            for i in 0..<self.consumerConnectResult.count
            {
            isExpandable.append(true)
            }
            consumerConnectTblView.delegate = self
            consumerConnectTblView.dataSource = self
            
            animatingView()
            
            lookingForTF.delegate = self
            
            let defaults = UserDefaults.standard
            accountID = (defaults.string(forKey: "accountId") ?? "")
            
            let nibName = UINib(nibName: "ConsumerConnectDetailTableViewCell", bundle: nil)
            consumerConnectTblView.register(nibName, forCellReuseIdentifier: "ConsumerConnectDetailTableViewCell")
            let headerNib = UINib.init(nibName: "ConsumerConnectDetailSectionTableViewCell", bundle: nil)
            consumerConnectTblView.register(headerNib, forHeaderFooterViewReuseIdentifier: "SectionCell")
            self.consumerConnectTblView.reloadData()
        }
        
        else if(self.consumerConnectResult.count == 0){
            self.showEmptyMsgBtn()
        }

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

    // Alert controller
    func showAlertWith(title:String,message:String)
        {
            let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return consumerConnectResult.count
       
       }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = consumerConnectTblView.dequeueReusableHeaderFooterView(withIdentifier: "SectionCell") as! ConsumerConnectDetailSectionTableViewCell

      
      // UIView Card View in Ios Swift4:
      headerView.cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      headerView.cardView.layer.cornerRadius = 10.0
      headerView.cardView.layer.shadowColor = UIColor.white.cgColor
      headerView.cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
      headerView.cardView.layer.shadowRadius = 6.0
      headerView.cardView.layer.shadowOpacity = 0.7
      headerView.cardView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      headerView.cardView.layer.borderWidth = 1
      
      headerView.dropDownButton.tag = section
      
      let dataDict = consumerConnectResult.object(at: section) as? NSDictionary
        consumerProductArray = dataDict?.value(forKey: "result") as! NSArray
        let productDict = dataDict?.value(forKey: "result") as? NSArray ?? NSArray()
        var productDictResult=NSDictionary()
        if productDict.count>0
        {
            productDictResult=productDict[0] as? NSDictionary ?? NSDictionary()
        }
        let productResults = productDictResult.value(forKey: "productResult") as? NSDictionary

        let accountDetailsDict = productResults?.value(forKey: "accountDetails") as? NSDictionary
      headerView.accoundIdLabel.text = accountDetailsDict?.value(forKey: "accountUniqueId") as? String
        let locDict = accountDetailsDict?.value(forKey: "loc") as? NSDictionary
        let coordinatesArr = locDict?.value(forKey: "coordinates") as? NSArray

        let latVal = coordinatesArr?.object(at: 0) as? Double ?? 0
        let longVal = coordinatesArr?.object(at: 1) as? Double ?? 0

        let camera = GMSCameraPosition.camera(withLatitude: latVal, longitude: longVal, zoom: 12)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: headerView.productMapView.frame.size.width, height: headerView.productMapView.frame.size.height), camera: camera)
        headerView.productMapView.addSubview(mapView)

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latVal, longitude: longVal)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
        marker.map = mapView
//      headerView.vendorName_Lbl.text = dataDict?.value(forKey: "accountName") as? String
          headerView.dropDownButton.addTarget(self, action: #selector(onChangingOpenCloseBtnTap(selectedBtn:)), for: .touchUpInside)
        
               return headerView
        }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
             return 209
         }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
           var cell = consumerConnectTblView.dequeueReusableCell(withIdentifier: "ConsumerConnectDetailTableViewCell", for: indexPath) as! ConsumerConnectDetailTableViewCell
        let consumerDict=consumerConnectResult[indexPath.section] as! NSDictionary
        let consumerArr=consumerDict.value(forKey: "result")as! NSArray
        let  mainDict:NSDictionary = consumerArr[indexPath.row] as! NSDictionary
        let productResults = mainDict.value(forKey: "productResult") as? NSDictionary

        let userDetailsDict = productResults?.value(forKey: "userDetails") as? NSDictionary
        
        let stockUnitDetailsArray = productResults?.value(forKey: "stockUnitDetails") as? NSArray
        var stockUnitDetailsDict=NSDictionary()
        if stockUnitDetailsArray?.count ?? 0>0
        {
            stockUnitDetailsDict = stockUnitDetailsArray?[0] as? NSDictionary ?? NSDictionary()
        }
        let dataDict = productResults?.value(forKey: "productDetails") as! NSDictionary
        let offeredPrice = productResults?.value(forKey: "offeredPrice") as? Double
        let offeredQty = productResults?.value(forKey: "offeredQuantity") as? Double
        //let reqQty = productDict.value(forKey: "requiredQuantity") as? Int
        //let counterOfferPrice = productDict.value(forKey: "counterOfferPrice") as? Int

        cell.prodIdLbl.text = dataDict["productUniqueNumber"] as? String
        cell.prodNameLbl.text = dataDict.value(forKey: "productName") as? String
        cell.productDescLabel.text = dataDict.value(forKey: "description") as? String
        cell.stockUnitLbl.text = stockUnitDetailsDict.value(forKey: "stockUnitName") as? String
        cell.totalPriceLbl.text = String(format:"%.2f",offeredPrice ?? 0)
        cell.pricePerStockUnitLbl.text = String(format:"%.2f",dataDict.value(forKey: "unitPrice") as? Double ?? 0)
        cell.offerQtyLbl.text = String(format:"%.2f",offeredQty ?? 0)
        //cell.reqQtyLbl.text = String(reqQty ?? 0)
        //cell.counterOfferPriceLbl.text = String(counterOfferPrice ?? 0)
        
        let expiryDate = (dataDict.value(forKey: "expiryDate") as? String) ?? ""
        let convertedExpiryDate = convertServerDateFormatter(date: expiryDate)
        cell.exxpiryDateLbl.text = convertedExpiryDate
        
        let purchaseDate = (dataDict.value(forKey: "purchaseDate") as? String) ?? ""
        let convertedpurchaseDate = convertServerDateFormatter(date: purchaseDate)
        cell.purchaseDateLbl.text = convertedpurchaseDate

        let prodArray = dataDict.value(forKey: "productImages") as? NSArray
        
        cell.bidBtn.addTarget(self, action: #selector(acceptBidBtnTap), for: .touchUpInside)
        cell.bidBtn.tag = indexPath.row
    
     
        let orderStatusStr = mainDict.value(forKey: "status") as? String

        cell.prodViewBtn.addTarget(self, action: #selector(prodViewBtnTapped), for: .touchUpInside)
        cell.prodViewBtn.tag = indexPath.row
        cell.bidBtn.isHidden = true
        
       if(orderStatusStr == "Not Requested"){
            
            cell.bidBtn.isHidden = false

        }
        

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

                        cell.profImgView?.sd_setImage(with: fileUrl, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                        cell.profImgView?.contentMode = UIView.ContentMode.scaleAspectFit

                    }

                    else {

                        cell.profImgView?.image = UIImage(named: "no_image")
                    }
        }else{
            cell.profImgView?.image = UIImage(named: "no_image")

        }
             return cell
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpandable[section]==true
        {
        let consumerDict=consumerConnectResult[section] as! NSDictionary
        let consumerArr=consumerDict.value(forKey: "result")as! NSArray
        return consumerArr.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let consumerDict=consumerConnectResult[indexPath.section] as! NSDictionary
        let consumerArr=consumerDict.value(forKey: "result")as! NSArray
        let  mainDict:NSDictionary = consumerArr[indexPath.row] as! NSDictionary

        let orderStatusStr = mainDict.value(forKey: "status") as? String

        if(orderStatusStr == "Not Requested"){
            return 441
            
        }else{
            return 370

            }
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == lookingForTF){
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "GlobalSearchViewController") as! GlobalSearchViewController
                        //      self.navigationController?.pushViewController(VC, animated: true)
            VC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(VC, animated: true)
            
            textField.resignFirstResponder()

        }
    }
    
    @objc func prodViewBtnTapped(_ sender: UIButton){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let  mainDict = consumerProductArray[sender.tag] as! NSDictionary
        let productDict = mainDict.value(forKey: "productResult") as? NSDictionary

        let VC = storyBoard.instantiateViewController(withIdentifier: "ProductChangeHistoryViewController") as! ProductChangeHistoryViewController
        VC.modalPresentationStyle = .fullScreen
        VC.productId
            = productDict?.value(forKey: "productId") as? String ?? ""
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
//    @objc func onDeclineBtnTap(_ sender: UIButton){
//
//        let resultDataDict = consumerConnectResult.object(at: sender.tag) as? NSDictionary
//        let dataDict = resultDataDict?.value(forKey: "result") as? NSDictionary
//
//        declineIdStr = dataDict?.value(forKey: "_id") as? String ?? ""
//        declineAPI()
//    }
    
//    @objc func onChatBtnTapped(_ sender: UIButton){
//
//        let userDefaults = UserDefaults.standard
//
//        let resultDataDict = consumerConnectResult.object(at: sender.tag) as? NSDictionary
//
//        let dataDict = resultDataDict?.value(forKey: "result") as? NSDictionary
//        let prodDetailsDict = dataDict?.value(forKey: "productDetails") as? NSDictionary
//        let userDetailsDict = dataDict?.value(forKey: "userDetails") as? NSDictionary
////      let userDetailsDict = userDetailsArr?.object(at: 0) as? NSDictionary
//
//        let giveAwayID = dataDict?.value(forKey: "giveAwayId") as? String ?? "0"
//        let chatUserID = userDetailsDict?.value(forKey: "_id") as? String ?? "0"
//
////        userDefaults.set(giveAwayID, forKey: "giveAwayID")
////        userDefaults.set(chatUserID, forKey: "chatUserID")
//
////        let userDefaults = UserDefaults.standard
//        let userID = userDefaults.value(forKey: "userID") as? String ?? ""
////        let giveAwayID = userDefaults.value(forKey: "giveAwayID") as? String ?? ""
////        let chatUSerId = userDefaults.value(forKey: "chatUserID") as? String ?? ""
//
//        let finalSuerID = giveAwayID + " \(userID)" + " \(chatUserID)"
//        userDefaults.set(finalSuerID, forKey: "finalChatUserId")
//
//        let firstName = userDetailsDict?.value(forKey: "firstName") as? String ?? ""
//        let lastName = userDetailsDict?.value(forKey: "lastName") as? String ?? ""
//
//        let fullName = firstName + lastName
//
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let VC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//        VC.chatNameStr = fullName
//        VC.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(VC, animated: true)
//
//    }
//
    func declineAPI()  {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + ConsumerDetailsRejectUrl + declineIdStr
                                    
        let postHeaders_IndividualLogin = ["":""]
        
        servCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: postHeaders_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                self.getConsumerConnectDetailsAPI()
                                
                            }else {
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }

    }
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

    }

    func getConsumerConnectDetailsAPI() {
        
        consumerConnectResult.removeAllObjects()
        consumerConnectResult = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        print("Acc ID is \(accountID)")

        let URLString_loginIndividual = Constants.BaseUrl + ConsumerConnectDetailUrl + idStr + "/" + accountID
                                    
        servCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                let dataDict = result as? NSDictionary
                                
                                self.consumerConnectResult = dataDict?.value(forKey: "result")  as! NSMutableArray
                                
                                self.consumerConnectTblView.reloadData()
                                
//                                if(self.consumerConnectResult.count > 0){
//                                    self.consumerConnectTblView.reloadData()
//
//                                }
                                
                                if(self.consumerConnectResult.count == 0){
                                    self.showEmptyMsgBtn()
                                }
                                
                            }else {
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
        
//        if(self.consumerConnectResult.count == 0){
//            self.showEmptyMsgBtn()
//        }
            
    }
    var offeredQtyy=Float()
    @objc func acceptBidBtnTap(sender:UIButton)  {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.consumerConnectTblView)
            let indexPath = self.consumerConnectTblView.indexPathForRow(at: buttonPosition)

        let dataDict = consumerConnectResult[indexPath!.section] as! NSDictionary
          let productDict = dataDict.value(forKey: "result") as! NSArray
        let productDictResult=productDict[indexPath!.row] as! NSDictionary
           let productResults = productDictResult.value(forKey: "productResult") as! NSDictionary
        offeredQtyy=Float(productResults.value(forKey: "offeredQuantity") as? Double ?? 0)
        acceptBidDict = productResults 
        acceptBidViewUI()
        
    }
    func acceptBidViewUI()
    {
        
        acceptBidView.removeFromSuperview()
        counterPriceTF.removeFromSuperview()
        totalPriceTF.removeFromSuperview()
        reqQtyTF.removeFromSuperview()
        
//        hiddenBtn = UIButton()
        hiddenBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)
        
        acceptBidView = UIView()
        acceptBidView.frame = CGRect(x: 20, y: self.view.frame.size.height/2-(225), width: self.view.frame.size.width - (40), height: 420)
        acceptBidView.backgroundColor = UIColor.white
        acceptBidView.layer.cornerRadius = 10
        acceptBidView.layer.masksToBounds = true
        self.view.addSubview(acceptBidView)
        
        //Change Pwd Lbl
        
        let changePwdLbl = UILabel()
        changePwdLbl.frame = CGRect(x: 10, y: 5, width: acceptBidView.frame.size.width - (60), height: 40)
        changePwdLbl.text = "      Accept Bid"
        changePwdLbl.textAlignment = NSTextAlignment.center
        changePwdLbl.font = UIFont.init(name: kAppFontBold, size: 14)
        changePwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        acceptBidView.addSubview(changePwdLbl)
        
        //Cancel Btn
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: acceptBidView.frame.size.width - 40, y: 5, width: 40, height: 40)
        cancelBtn.setImage(UIImage.init(named: "cancel"), for: UIControl.State.normal)
        cancelBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        acceptBidView.addSubview(cancelBtn)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        
        //Seperator Line Lbl
        
        let seperatorLine = UILabel()
        seperatorLine.frame = CGRect(x: 0, y: changePwdLbl.frame.origin.y+changePwdLbl.frame.size.height, width: acceptBidView.frame.size.width , height: 1)
        seperatorLine.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
        acceptBidView.addSubview(seperatorLine)
        
        //Current Pwd Lbl

        let currentPwdLbl = UILabel()
        currentPwdLbl.frame = CGRect(x: 10, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: acceptBidView.frame.size.width - (20), height: 20)
        currentPwdLbl.text = "Required Quantity"
        currentPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        currentPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        acceptBidView.addSubview(currentPwdLbl)

        //Current Pwd TF

        reqQtyTF = UITextField()
        reqQtyTF.frame = CGRect(x: 10, y: currentPwdLbl.frame.origin.y+currentPwdLbl.frame.size.height+5, width: acceptBidView.frame.size.width - (20), height: 45)
        reqQtyTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        reqQtyTF.textColor = hexStringToUIColor(hex: "232c51")
        reqQtyTF.keyboardType = UIKeyboardType.decimalPad
        reqQtyTF.delegate=self
        acceptBidView.addSubview(reqQtyTF)

        reqQtyTF.backgroundColor = hexStringToUIColor(hex: "FFFFFF")
        reqQtyTF.layer.borderWidth = 1
        reqQtyTF.layer.borderColor = UIColor.gray.cgColor
        reqQtyTF.layer.cornerRadius = 3
        reqQtyTF.clipsToBounds = true

        let currentPwdPaddingView = UIView()
        currentPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: reqQtyTF.frame.size.height)
        reqQtyTF.leftView = currentPwdPaddingView
        reqQtyTF.leftViewMode = UITextField.ViewMode.always
        
        //New Pwd Lbl

        let newPwdLbl = UILabel()
        newPwdLbl.frame = CGRect(x: 10, y: reqQtyTF.frame.origin.y+reqQtyTF.frame.size.height+15, width: acceptBidView.frame.size.width - (20), height: 20)
        newPwdLbl.text = "Bid Price Per Unit"
        newPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        newPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        acceptBidView.addSubview(newPwdLbl)

        //New Pwd TF

        counterPriceTF = UITextField()
        counterPriceTF.frame = CGRect(x: 10, y: newPwdLbl.frame.origin.y+newPwdLbl.frame.size.height+5, width: acceptBidView.frame.size.width - (20), height: 45)
        counterPriceTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        counterPriceTF.textColor = hexStringToUIColor(hex: "232c51")
        counterPriceTF.delegate=self
        acceptBidView.addSubview(counterPriceTF)

        counterPriceTF.backgroundColor = hexStringToUIColor(hex: "FFFFFF")
        counterPriceTF.layer.borderWidth = 1
        counterPriceTF.layer.borderColor = UIColor.gray.cgColor
        counterPriceTF.layer.cornerRadius = 3
        counterPriceTF.clipsToBounds = true

        let newPwdPaddingView = UIView()
        newPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: counterPriceTF.frame.size.height)
        counterPriceTF.leftView = newPwdPaddingView
        counterPriceTF.leftViewMode = UITextField.ViewMode.always
        
        //New Pwd Lbl

        let newPwdLbl1 = UILabel()
        newPwdLbl1.frame = CGRect(x: 10, y: counterPriceTF.frame.origin.y+counterPriceTF.frame.size.height+15, width: acceptBidView.frame.size.width - (20), height: 20)
        newPwdLbl1.text = "Total Price"
        newPwdLbl1.font = UIFont.init(name: kAppFontMedium, size: 12)
        newPwdLbl1.textColor = hexStringToUIColor(hex: "232c51")
        acceptBidView.addSubview(newPwdLbl1)

        //New Pwd TF

        totalPriceTF = UITextField()
        totalPriceTF.frame = CGRect(x: 10, y: newPwdLbl1.frame.origin.y+newPwdLbl1.frame.size.height+5, width: acceptBidView.frame.size.width - (20), height: 45)
        totalPriceTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        totalPriceTF.textColor = hexStringToUIColor(hex: "232c51")
        totalPriceTF.delegate=self
        acceptBidView.addSubview(totalPriceTF)
        totalPriceTF.layer.borderWidth = 1
        totalPriceTF.layer.borderColor = UIColor.gray.cgColor
        totalPriceTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        totalPriceTF.layer.cornerRadius = 3
        totalPriceTF.clipsToBounds = true

        let newPwdPaddingView1 = UIView()
        newPwdPaddingView1.frame = CGRect(x: 0, y: 0, width: 15, height: totalPriceTF.frame.size.height)
        totalPriceTF.leftView = newPwdPaddingView1
        totalPriceTF.leftViewMode = UITextField.ViewMode.always
        
        let updateBtn = UIButton()
        updateBtn.frame = CGRect(x:acceptBidView.frame.size.width/2 - (90), y: totalPriceTF.frame.origin.y+totalPriceTF.frame.size.height+40, width: 80, height: 40)
        updateBtn.setTitle("CLOSE", for: UIControl.State.normal)
        updateBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        updateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        updateBtn.backgroundColor = hexStringToUIColor(hex: "232c51")
        updateBtn.addTarget(self, action: #selector(closeBtnTap), for: .touchUpInside)

        acceptBidView.addSubview(updateBtn)
        counterPriceTF.keyboardType=UIKeyboardType.decimalPad
        reqQtyTF.keyboardType=UIKeyboardType.decimalPad
        totalPriceTF.isUserInteractionEnabled=false
        let submitBtn = UIButton()
        submitBtn.frame = CGRect(x:acceptBidView.frame.size.width/2 + (10), y: totalPriceTF.frame.origin.y+totalPriceTF.frame.size.height+40, width: 80, height: 40)
        submitBtn.setTitle("SUBMIT", for: UIControl.State.normal)
        submitBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        submitBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        submitBtn.backgroundColor = hexStringToUIColor(hex: "0f5fee")
        submitBtn.addTarget(self, action: #selector(acceptBidSubmitBtnTap), for: .touchUpInside)

        acceptBidView.addSubview(submitBtn)

        updateBtn.layer.cornerRadius = 3
        updateBtn.layer.masksToBounds = true
        
        submitBtn.layer.cornerRadius = 3
        submitBtn.layer.masksToBounds = true

    }
    @objc func acceptBidSubmitBtnTap(sender:UIButton){
        
//        let  productDict = acceptBidDict.value(forKey: "result") as! NSDictionary

        let reqQty: Float? = Float(reqQtyTF.text ?? "0")
        
        if(reqQtyTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter required quantity")
            return
            
        }
       
        else if(counterPriceTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter counter prince")
            return
        }
        else if(reqQty ?? 0 > offeredQtyy){
            self.showAlertWith(title: "Alert", message: "Required quantity should be less than Offered quantity")
            return

        }
        
        acceptBidAPI(dataDict: acceptBidDict)
        
    }
    
    @objc func closeBtnTap(sender: UIButton){
        
        hiddenBtn.removeFromSuperview()
        acceptBidView.removeFromSuperview()

    }
    
    @objc func cancelBtnTap(sender: UIButton!){
        
        hiddenBtn.removeFromSuperview()
        acceptBidView.removeFromSuperview()

    }
    func acceptBidAPI(dataDict:NSDictionary) {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let prodIDStr = acceptBidDict.value(forKey: "productId") as? String
        let consumerConnectIdStr = acceptBidDict.value(forKey: "_id") as? String
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String


        let URLString_loginIndividual = Constants.BaseUrl + AcceptBidUrl
        
        let params_IndividualLogin = ["productId":prodIDStr,"consumerConnectId":consumerConnectIdStr,"accountId":accountID,"userId":userID,"requiredQuantity":reqQtyTF.text ?? "","counterOfferPrice":counterPriceTF.text ?? "","counterUnitPrice":totalPriceTF.text ?? ""] as [String : Any]
        
        servCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: params_IndividualLogin as NSDictionary, successHandler: { (result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                self.hiddenBtn.removeFromSuperview()
                                self.acceptBidView.removeFromSuperview()
                                
                                self.showAlertWith(title: "Success", message: "Bid accepted successfully")
                                
                               self.getCosumerConnectAPI()

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
    func getCosumerConnectAPI() {
        
        consumerConnectResult.removeAllObjects()
        consumerConnectResult = NSMutableArray()
        
        animatingView()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        print("Acc ID is \(accountID)")
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String

        let URLString_loginIndividual = Constants.BaseUrl + searchConsumerConnect + accountID + "/\(userID)" + "/\(locRange)"
                                    
        let params_IndividualLogin = [
            "productId" : productIDD,
            "productName" : prodductName,
            "accountName" : accounntId
        ] as [String : Any]
    
    
        let postHeaders_IndividualLogin = ["":""]
        
servCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

    let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                    
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
                        
            if status == "SUCCESS" {
                
                if(statusCode == 200 ){
                    let dataDict = result as? NSDictionary
                    
                   self.consumerConnectResult = dataDict?.value(forKey: "result")  as! NSMutableArray
                    
                    self.sectionData = dataDict?.value(forKey: "result")  as! NSMutableArray
                    if(self.consumerConnectResult.count > 0){
                        for i in 0..<self.consumerConnectResult.count
                        {
                            self.isExpandable.append(true)
                        }
                    }
                    self.consumerConnectTblView.reloadData()

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
    self.showAlertWith(title: "Alert", message: "Something Went To Wrong...Please Try Again Later")
            print("Something Went To Wrong...PLrease Try Again Later")
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        print(newString)
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        if string=="."
        {
            if textField.text?.contains(".")==true || textField.text==""
            {
                return false
            }
           
        }
        if textField == counterPriceTF
        {
            if self.reqQtyTF.text != "" && newString != ""
            {
                let aa=decimalPlaces(stt: newString)
                if aa>2 {
                    
                }
                else
                {
            self.totalPriceTF.text = String(format: "%.2f", Float(self.reqQtyTF.text!)! * Float(newString)!)
            }
            }
        }
        if textField == reqQtyTF
        {
            if self.counterPriceTF.text != "" && newString != ""
            {
                let aa=decimalPlaces(stt: newString)
                if aa>3 {
                    
                }
                else
                {
            self.totalPriceTF.text = String(format: "%.2f", Float(self.counterPriceTF.text!)! * Float(newString)!)
                }
            }
        }
        if textField == reqQtyTF
        {
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
        if textField == counterPriceTF
        {
            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1

            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }

            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        }
        
        return true
    }
    //Expand&Collapse Button Functionality:
           @objc func onChangingOpenCloseBtnTap(selectedBtn:UIButton) {
            print("Button Tapped,need to insert (or) DElete Rows In Section\(selectedBtn.tag)")
            
            if isExpandable[selectedBtn.tag] == true {
                isExpandable[selectedBtn.tag]=false
               selectedBtn.setImage(UIImage(named: "Up"), for: .normal)
                consumerConnectTblView.reloadData()
              }
              else if isExpandable[selectedBtn.tag] == false  {
                isExpandable[selectedBtn.tag]=true
              selectedBtn.setImage(UIImage(named: "arrowDown"), for: .normal)
                consumerConnectTblView.reloadData()
                   }
                }


}
