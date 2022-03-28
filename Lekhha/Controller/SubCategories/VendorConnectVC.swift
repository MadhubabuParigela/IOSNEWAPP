//
//  VendorConnectVC.swift
//  LekhaApp
//
//  Created by apple on 11/26/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleMaps

class VendorConnectVC: UIViewController {
    
    var offSetVal = 0
    var sideMenuView = SideMenuView()
    var vendorDataDict = NSDictionary()
     
    
    var scrollDidEndReached = Bool()
    
    @IBAction func threeLineMenuBtnTap(_ sender: UIButton) {
        toggleSideMenuViewWithAnimation()
    }
    
    @IBOutlet weak var lookingForTF: UITextField!
    @IBOutlet weak var vendorConnectTV: UITableView!
    @IBOutlet weak var searchHideView: UIView!
    @IBOutlet weak var notificationCountLbl: UILabel!
    
    var hiddenBtn = UIButton()
    var addToCartView = UIView()
    var addQtyTF = UITextField()
    
    var addToCartImgsArray = NSMutableArray()
    var prodIdStr:NSString!
    var accIdStr:NSString!
    var purchaseDateStr:NSString!
    var reqQtyStr:NSString!
    var savedListStr:NSString!

    var vendorConnectResult = NSMutableArray()
    var emptyMsgBtn = UIButton()
    
    var accountID = String()
    var accountNameTF=String()
    var productNameTF=String()
    var productIDTF=String()
    var isExpandable=[Bool]()
    var servCntrl = ServiceController()
    
       var Vendor1:SubCatageories!
       var Vendor2:SubCatageories!
       var Vendor3:SubCatageories!
       var Vendor4:SubCatageories!
       
       var catageoriesArray:[SubCatageories]!
       
       var vendorIDArray = ["345BEE345","345BEE345","345BEE345","345BEE345","345BEE345","345BEE345"]
    
       var VendorNameArray = ["Vendor Name Here","Vendor Name Here","Vendor Name Here","Vendor Name Here","Vendor Name Here","Vendor Name Here"]

                     override func viewDidLoad() {
                        super.viewDidLoad()
        
                        let defaults = UserDefaults.standard
                        accountID = (defaults.string(forKey: "accountId") ?? "")
                        
//                        animatingView()
                        
              vendorConnectTV.delegate = self
              vendorConnectTV.dataSource = self
                        
        Vendor1=SubCatageories(names:[""],isExpanded:false)
        Vendor2=SubCatageories(names:[""],isExpanded:false)
        Vendor3=SubCatageories(names:[""],isExpanded:false)
        Vendor4=SubCatageories(names:[""],isExpanded:false)

//        catageoriesArray=[Vendor1,Vendor2,Vendor3,Vendor4]
//
              let nibName = UINib(nibName: "VendorTV_Cell", bundle: nil)
              vendorConnectTV.register(nibName, forCellReuseIdentifier: "VendorTV_Cell")
            
              let headerNib = UINib.init(nibName: "VendorHV", bundle: Bundle.main)
              vendorConnectTV.register(headerNib, forHeaderFooterViewReuseIdentifier: "VendorHV")
                        
                // UIView Card View in Ios Swift4:
               searchHideView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
               searchHideView.layer.cornerRadius = 10.0
               searchHideView.layer.shadowColor = UIColor.white.cgColor
               searchHideView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
               searchHideView.layer.shadowRadius = 6.0
               searchHideView.layer.shadowOpacity = 0.7
               searchHideView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
               searchHideView.layer.borderWidth = 1
                        
              //Rounded Image Functionality:
               notificationCountLbl.layer.borderWidth = 3
               notificationCountLbl.layer.masksToBounds = false
               notificationCountLbl.layer.borderColor = UIColor.black.cgColor
               notificationCountLbl.layer.cornerRadius = notificationCountLbl.frame.height/2
               notificationCountLbl.clipsToBounds = true
                        
                        let paddingView = UIView()
                        paddingView.frame = CGRect(x: lookingForTF.frame.size.width - (35), y: 0, width: 35, height: lookingForTF.frame.size.height)
                        lookingForTF.rightView = paddingView
                        lookingForTF.rightViewMode = UITextField.ViewMode.always
                        
                        let filterBtn = UIButton()
                        filterBtn.frame = CGRect(x: paddingView.frame.size.width/2 - 12.5, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
                        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
                        paddingView.addSubview(filterBtn)
                        
                        filterBtn.addTarget(self, action: #selector(filterBtnTap), for: .touchUpInside)
                        
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
    
    @objc func filterBtnTap(){
     
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "GlobalSearchViewController") as! GlobalSearchViewController
                    //      self.navigationController?.pushViewController(VC, animated: true)
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        animatingView()
        getVendorConnectAPI()
        
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
    
    @IBAction func onTapped_BackBtn(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func onTapped_Notifications_Btn(_ sender: Any) {
        
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "VendorConnectVC") as! VendorConnectVC
      self.navigationController?.pushViewController(vc, animated: true)
        
       }
   }


  extension VendorConnectVC:UITableViewDelegate,UITableViewDataSource {
    
         func numberOfSections(in tableView: UITableView) -> Int {
          return vendorConnectResult.count
            
            }
            
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//              return catageoriesArray[section].names.count
            if isExpandable[section]==true
            {
                let productDict = vendorConnectResult[section] as! NSDictionary
                let productsListData = productDict.value(forKey: "productsList") as! NSArray

                return productsListData.count
            }
            return 0
                 }
      
          func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
              let headerView = vendorConnectTV.dequeueReusableHeaderFooterView(withIdentifier: "VendorHV") as! VendorHV
            
            // UIView Card View in Ios Swift4:
            headerView.cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            headerView.cardView.layer.cornerRadius = 10.0
            headerView.cardView.layer.shadowColor = UIColor.white.cgColor
            headerView.cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            headerView.cardView.layer.shadowRadius = 6.0
            headerView.cardView.layer.shadowOpacity = 0.7
            headerView.cardView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            headerView.cardView.layer.borderWidth = 1
            
            headerView.VendorBtn.tag = section
            
            let dataDict = vendorConnectResult.object(at: section) as? NSDictionary
            
            headerView.vendorID_Lbl.text = dataDict?.value(forKey: "_id") as? String
            headerView.vendorName_Lbl.text = dataDict?.value(forKey: "vendorName") as? String
           
          headerView.VendorBtn.addTarget(self, action: #selector(onChangingOpenCloseBtnTap(selectedBtn:)), for: .touchUpInside)
              
                     return headerView
              }
      
          func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
                   return 80
               }
      
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var cell = vendorConnectTV.dequeueReusableCell(withIdentifier: "VendorTV_Cell", for: indexPath) as! VendorTV_Cell

            let productDict = vendorConnectResult[indexPath.section] as! NSDictionary
            let productsListData = productDict.value(forKey: "productsList") as! NSArray
            
            let dataDict = productsListData[indexPath.row] as! NSDictionary
            let offeredPrice = dataDict.value(forKey: "offeredUnitPrice") as? Int
           // let purchasePrice = dataDict.value(forKey: "stockQuantity") as? Int

            cell.vendorIDLbl.text = dataDict.value(forKey: "_id") as? String
            cell.penStandLbl.text = dataDict.value(forKey: "productName") as? String
            cell.descriptionLbl.text = dataDict.value(forKey: "description") as? String
//            cell.offeredPriceLbl.text = String(offeredPrice ?? 0)
//            cell.offeredQtyLbl.text = String(purchasePrice ?? 0)
            
            cell.subCatageoryNameLbl.text = String(offeredPrice ?? 0)

            let purchaseDate = (dataDict.value(forKey: "purchaseDate") as? String) ?? ""
            let convertedpurchaseDate = convertServerDateFormatter(date: purchaseDate)
            cell.expiryDateLbl.text = convertedpurchaseDate
            let expiryDate = (dataDict.value(forKey: "expiryDate") as? String) ?? ""
            let convertedExpiryDate = convertServerDateFormatter(date: expiryDate)
            cell.catageoryNameLbl.text = convertedExpiryDate
            let prodArray = dataDict.value(forKey: "vendorProductImages") as? NSArray
            
            let prodIDStr = dataDict.value(forKey: "_id") as? String
            cell.addtoCartBtn.setTitle(prodIDStr, for: .normal)
            
            cell.addtoCartBtn.setTitleColor(.clear, for: .normal)
            cell.addtoCartBtn.addTarget(self, action: #selector(addToCartBtnTap), for: .touchUpInside)
            cell.addtoCartBtn.tag = indexPath.row
            let userDetailsDict = dataDict.value(forKey: "accountDetails") as? NSDictionary
            
            let locDict = userDetailsDict?.value(forKey: "loc") as? NSDictionary
            let coordinatesArr = locDict?.value(forKey: "coordinates") as? NSArray

            let latVal = coordinatesArr?.object(at: 0) as? Double ?? 0
            let longVal = coordinatesArr?.object(at: 1) as? Double ?? 0

            let camera = GMSCameraPosition.camera(withLatitude: latVal, longitude: longVal, zoom: 12)
            
            let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: cell.mapBackView.frame.size.width+70, height: cell.mapBackView.frame.size.height), camera: camera)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latVal, longitude: longVal)
    //        marker.title = "Sydney"
    //        marker.snippet = "Australia"
            marker.map = mapView
           
            cell.mapBackView.addSubview(mapView)

            if(prodArray?.count ?? 0  > 0){

                        let dict = prodArray?[0] as! NSDictionary

                        let imageStr = dict.value(forKey: "0") as! String

                        if !imageStr.isEmpty {

                            let imgUrl:String = imageStr

                            let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")

                            let imggg = Constants.VendorBaseImgUrl + trimStr

    //                            let url = URL.init(string: imggg)

    //                            let fileUrl = URL(fileURLWithPath: imggg)
                            let fileUrl = URL(string: imggg)

                            cell.myCellImgView?.sd_setImage(with: fileUrl, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                            cell.myCellImgView?.contentMode = UIView.ContentMode.scaleAspectFit

                        }

                        else {

                            cell.myCellImgView?.image = UIImage(named: "no_image")
                        }
            }else{
                cell.myCellImgView?.image = UIImage(named: "no_image")

            }
            
                   return cell
             }
    
    @objc func addToCartBtnTap(sender: UIButton!){
        
        let buttonPosition = sender.convert(CGPoint.zero, to: vendorConnectTV)
        let indexPath = vendorConnectTV.indexPathForRow(at: buttonPosition)

//        var prodImgDict = NSDictionary()
//        addToCartImgsArray = NSMutableArray()

        let productDict = vendorConnectResult[indexPath!.section] as! NSDictionary
        let prodArray = productDict.value(forKey: "productsList") as! NSArray
        
        let dataDict = prodArray.object(at: indexPath!.row)
        print(dataDict)
        
        vendorDataDict = prodArray.object(at: indexPath!.row) as! NSDictionary
    
        prodIdStr = sender.currentTitle as NSString?
        
//        accIdStr = dataDict.value(forKey: "accountId") as? NSString
//
//        let reqQty = dataDict.value(forKey: "stockQuantity") as! Int
//
//        reqQtyStr = String(reqQty) as NSString
//        savedListStr = (productDict.value(forKey: "_id") ?? 0) as? NSString
//
//        print(prodIdStr!,accIdStr!,reqQtyStr!,savedListStr!)
//
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        purchaseDateStr = formatter.string(from: date) as NSString
//
//        let dataArray = dataDict.value(forKey: "productImages") as! NSArray
//        prodImgDict = dataArray.object(at: 0) as! NSDictionary
//
//
//        for i in 0..<3 {
//
//            var imgStr = ""
//
//            if(i == 0){
//                imgStr = prodImgDict.value(forKey: "0") as? String ?? ""
//
//            }else if(i == 1){
//                imgStr = prodImgDict.value(forKey: "1") as? String ?? ""
//
//            }else if(i == 2){
//                imgStr = prodImgDict.value(forKey: "2") as? String ?? ""
//
//            }
//
//            if(imgStr == ""){
//
//                var addProdImgDict = NSMutableDictionary()
//                addProdImgDict = ["productImage":""]
//
//                addToCartImgsArray.add(addProdImgDict)
//
//
//            }else{
//
//                let imggg = Constants.BaseImageUrl + imgStr
//    //            let url = URL.init(string: imggg)
//
//                let url:NSURL = NSURL(string : imggg)!
//                let imageData:NSData = NSData.init(contentsOf: url as URL)!
//
//                let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
//
//                var addProdImgDict = NSMutableDictionary()
//                addProdImgDict = ["productImage":strBase64]
//
//                addToCartImgsArray.add(addProdImgDict)
//
//            }
//        }
//        self.addToCartAPICall()
        
        addToCart()
        
    }
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "VendorConnectVC") as! VendorConnectVC
                self.navigationController?.pushViewController(vc, animated: true)
                
               }

             func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                     return 530
                 }
      
              func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
                  vendorConnectTV.deselectRow(at: indexPath, animated: true)
               }
      
           //Expand&Collapse Button Functionality:
//           @objc func onChangingOpenCloseBtnTap(selectedBtn:UIButton) {
//            print("Button Tapped,need to insert (or) DElete Rows In Section\(selectedBtn.tag)")
//            var indexPathsArr=[IndexPath]()
//
//            for i in 0..<catageoriesArray[selectedBtn.tag].names.count {
//            var ip=IndexPath(row: i, section: selectedBtn.tag)
//                indexPathsArr  += [ip]
//            }
//            if (catageoriesArray[selectedBtn.tag].isExpanded == true) {
//               catageoriesArray[selectedBtn.tag].isExpanded=false
//               selectedBtn.setImage(UIImage(named: "Up"), for: .normal)
//              // cellImgView?.image = UIImage(named: "")
//               vendorConnectTV.deleteRows(at: indexPathsArr, with: UITableView.RowAnimation.bottom)
//              }
//              else if (catageoriesArray[selectedBtn.tag].isExpanded == false)  {
//              catageoriesArray[selectedBtn.tag].isExpanded=true
//              selectedBtn.setImage(UIImage(named: "Down"), for: .normal)
//            //  cellImgView?.image = UIImage(named: "")
//              vendorConnectTV.insertRows(at: indexPathsArr, with: UITableView.RowAnimation.bottom)
//                   }
//                }
    
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
    
    func addToCart()  {
        
//        hiddenBtn = UIButton()
        hiddenBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)
        
        addToCartView = UIView()
        addToCartView.frame = CGRect(x: 20, y: self.view.frame.size.height/2-(175), width: self.view.frame.size.width - (40), height: 250)
        addToCartView.backgroundColor = UIColor.white
        addToCartView.layer.cornerRadius = 10
        addToCartView.layer.masksToBounds = true
        self.view.addSubview(addToCartView)
        
        //Change Pwd Lbl
        
        let changePwdLbl = UILabel()
        changePwdLbl.frame = CGRect(x: 30, y: 5, width: addToCartView.frame.size.width - (60), height: 40)
        changePwdLbl.text = "Add To Cart"
        changePwdLbl.textAlignment = NSTextAlignment.center
        changePwdLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        changePwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        addToCartView.addSubview(changePwdLbl)
        
        //Cancel Btn
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: addToCartView.frame.size.width - 40, y: 5, width: 40, height: 40)
        cancelBtn.setImage(UIImage.init(named: "cancel"), for: UIControl.State.normal)
        cancelBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        addToCartView.addSubview(cancelBtn)
        
        cancelBtn.addTarget(self, action: #selector(closeBtnTap), for: .touchUpInside)
        
        //Seperator Line Lbl
        
        let seperatorLine = UILabel()
        seperatorLine.frame = CGRect(x: 0, y: changePwdLbl.frame.origin.y+changePwdLbl.frame.size.height, width: addToCartView.frame.size.width , height: 1)
        seperatorLine.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
        addToCartView.addSubview(seperatorLine)
        
        //Current Pwd Lbl

        let currentPwdLbl = UILabel()
        currentPwdLbl.frame = CGRect(x: 10, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: addToCartView.frame.size.width - (20), height: 20)
        currentPwdLbl.text = "Required Quantity"
        currentPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        currentPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        addToCartView.addSubview(currentPwdLbl)
        
        //New Pwd TF

        addQtyTF = UITextField()
        addQtyTF.frame = CGRect(x: 10, y: currentPwdLbl.frame.origin.y+currentPwdLbl.frame.size.height+5, width: addToCartView.frame.size.width - (20), height: 45)
        addQtyTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        addQtyTF.textColor = hexStringToUIColor(hex: "232c51")
        addQtyTF.text = ""
        addToCartView.addSubview(addQtyTF)
        
        addQtyTF.keyboardType = UIKeyboardType.numberPad

        addQtyTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        addQtyTF.layer.cornerRadius = 3
        addQtyTF.clipsToBounds = true

        let newPwdPaddingView = UIView()
        newPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: addQtyTF.frame.size.height)
        addQtyTF.leftView = newPwdPaddingView
        addQtyTF.leftViewMode = UITextField.ViewMode.always

        let updateBtn = UIButton()
        updateBtn.frame = CGRect(x:addToCartView.frame.size.width/2 - (90), y: addQtyTF.frame.origin.y+addQtyTF.frame.size.height+40, width: 80, height: 40)
        updateBtn.setTitle("CLOSE", for: UIControl.State.normal)
        updateBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        updateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        updateBtn.backgroundColor = hexStringToUIColor(hex: "232c51")
        updateBtn.addTarget(self, action: #selector(closeBtnTap), for: .touchUpInside)

        addToCartView.addSubview(updateBtn)
        
        let submitBtn = UIButton()
        submitBtn.frame = CGRect(x:addToCartView.frame.size.width/2 + (10), y: addQtyTF.frame.origin.y+addQtyTF.frame.size.height+40, width: 80, height: 40)
        submitBtn.setTitle("SAVE", for: UIControl.State.normal)
        submitBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        submitBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        submitBtn.backgroundColor = hexStringToUIColor(hex: "0f5fee")
        submitBtn.addTarget(self, action: #selector(submitAddCartBtnTap), for: .touchUpInside)

        addToCartView.addSubview(submitBtn)
        addToCartView.addSubview(updateBtn)

        updateBtn.layer.cornerRadius = 3
        updateBtn.layer.masksToBounds = true
        
        submitBtn.layer.cornerRadius = 3
        
    }
    
    @objc func submitAddCartBtnTap(sender: UIButton){
        
        let reqQty: Int? = Int(addQtyTF.text ?? "0")
        let offeredQty = vendorDataDict.value(forKey: "stockQuantity") as? Int ?? 0
        
        if(addQtyTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter required quantity")
            return
            
        }else if(reqQty ?? 0 > offeredQty){
            self.showAlertWith(title: "Alert", message: "Required quantity should be less than Offered quantity")
            return

        }else if(reqQty == 0){
            self.showAlertWith(title: "Alert", message: "Required quantity should not be 0")
            return

        }

//        if(addQtyTF.text == ""){
//            self.showAlertWith(title: "Alert", message: "Enter quantity")
//            return
//        }
        
        addToCartAPICall()
    }
    
    @objc func closeBtnTap(sender: UIButton){
        
        hiddenBtn.removeFromSuperview()
        addToCartView.removeFromSuperview()

    }

    func addToCartAPICall() {
        
        animatingView()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let URLString_loginIndividual = Constants.BaseUrl + VendorShoppingCartAddProductsUrl
        
        
        let params_IndividualLogin = ["accountId":accountID,"productId":prodIdStr!,"quantity":addQtyTF.text ?? ""] as [String : Any]
                
        let postHeaders_IndividualLogin = ["":""]
                    
        servCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")

                            if(statusCode == 200 ){
                                self.moveToCartAlert()
                                
                                self.hiddenBtn.removeFromSuperview()
                                self.addToCartView.removeFromSuperview()

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
                        print("Something Went To Wrong...Plrease Try Again Later")
                    }
                }
    
    func moveToCartAlert(){
        
        let alert = UIAlertController(title: "Success", message: "Added to cart succesfully", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        
//                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                                        let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingVC") as! ShoppingViewController
//                                        VC.modalPresentationStyle = .fullScreen
//            //                            self.present(VC, animated: true, completion: nil)
//                                        self.navigationController?.pushViewController(VC, animated: true)

        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    func getVendorConnectAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        print("Acc ID is \(accountID)")

        let params_IndividualLogin = [
            "productId":productIDTF,"productName":productNameTF,"accountName":accountNameTF
        ]
    
    
        let URLString_loginIndividual = Constants.BaseUrl + PostVendorConnectListUrl + accountID +  "/\(0)"
        
        servCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: params_IndividualLogin as NSDictionary, successHandler: { (result) in

                            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                            
                                let dataDict = result as? NSDictionary
                                
                                let dataArray = dataDict?.value(forKey: "result") as? NSArray
                                
                                
                                for i in 0..<dataArray!.count {

                                    let dataDict = dataArray?.object(at: i) as? NSDictionary
                                    self.vendorConnectResult.add(dataDict!)
                                    self.isExpandable.append(true)
                                }
                                
//                                self.vendorConnectResult = dataDict?.value(forKey: "result") as! NSMutableArray
                                
                                
                                let vendorAccCount = dataDict?.value(forKey: "vendorAccountResultCount") as? Int ?? 0
                                
                                if(dataArray!.count > 0){
                                    
//                                    DispatchQueue.main.async {
                                        self.emptyMsgBtn.removeFromSuperview()
                                   
                                       
                                        self.vendorConnectTV.reloadData()

//                                    }
                                }else{
                                    
                                    if(self.vendorConnectResult.count == 0){
                                        
                                        if(self.offSetVal > vendorAccCount){
                                            
                                        }else{
                                            self.offSetVal = self.offSetVal + 5
                                            self.getVendorConnectAPI()
                                            
                                        }
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
    
    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate: Bool){
        
//        offSetVal = offSetVal + 5
//        self.getVendorConnectAPI()

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let height = scrollView.frame.size.height
       let contentYoffset = scrollView.contentOffset.y
       let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        scrollDidEndReached = true
        
       if distanceFromBottom < height {
           print("you reached end of the table")
        
        if(scrollDidEndReached){
            offSetVal = offSetVal + 5
            self.getVendorConnectAPI()
            
            scrollDidEndReached = false

          }
       }
   }
    //Expand&Collapse Button Functionality:
           @objc func onChangingOpenCloseBtnTap(selectedBtn:UIButton) {
            print("Button Tapped,need to insert (or) DElete Rows In Section\(selectedBtn.tag)")
            
            if isExpandable[selectedBtn.tag] == true {
                isExpandable[selectedBtn.tag]=false
               selectedBtn.setImage(UIImage(named: "Up"), for: .normal)
                vendorConnectTV.reloadData()
              }
              else if isExpandable[selectedBtn.tag] == false  {
                isExpandable[selectedBtn.tag]=true
              selectedBtn.setImage(UIImage(named: "arrowDown"), for: .normal)
                vendorConnectTV.reloadData()
                   }
                }
}

