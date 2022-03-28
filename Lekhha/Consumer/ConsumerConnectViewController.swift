//
//  ConsumerConnectViewController.swift
//  LekhaLatest
//
//  Created by USM on 17/05/21.
//

import UIKit
import WARangeSlider
import ObjectMapper
import GoogleMaps

class ConsumerConnectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet var consumertabletop: NSLayoutConstraint!
    @IBOutlet var rangeViewHeight: NSLayoutConstraint!
    @IBOutlet var rangeView: UIView!
    @IBOutlet weak var kmSlider: UISlider!
    
    @IBOutlet var selrctRangeLabel: UILabel!
    @IBOutlet weak var titleTxtLbl: UILabel!
    @IBOutlet weak var menuBtnTapped: UIButton!
    @IBOutlet weak var lookungForTextField: UITextField!
    @IBOutlet weak var minRangeLbl: UILabel!
    @IBOutlet weak var maxRangeLbl: UILabel!
    @IBOutlet weak var consumerConnectTblView: UITableView!
    
    var locStartRange = Float(0)
    var locEndRange = Float(10)
    
    let hiddenBtn = UIButton()
    var acceptBidView = UIView()
    var sideMenuView = SideMenuView()
    
    var headerTitleStr = String()
    
    var reqQtyTF = UITextField()
    var counterPriceTF = UITextField()
    
    var accountID = String()
    var servCntrl = ServiceController()
    var emptyMsgBtn = UIButton()
    var consumerConnectResult = NSMutableArray()

    var acceptBidDict = NSDictionary()
    var fromTab=String()
    
    @IBOutlet var consumerStackView: UIStackView!
    @IBAction func onClickSearchButton(_ sender: Any) {
        searchLabel.isHidden=false
        activeLabel.isHidden=true
        closedLabel.isHidden=true
        searchView.isHidden=false
        consumerConnectTblView.isHidden=true
        emptyMsgBtn.isHidden=true
        rangeViewHeight.constant=120
        rangeView.isHidden=false
        selrctRangeLabel.isHidden=false
        maxRangeLbl.isHidden=false
        minRangeLbl.isHidden=false
        kmSlider.isHidden=false
    }
    @IBOutlet var searchLabel: UILabel!
    @IBOutlet var searchButton: UIButton!
    @IBAction func onClickActiveButton(_ sender: Any) {
        searchLabel.isHidden=true
        activeLabel.isHidden=false
        closedLabel.isHidden=true
        searchView.isHidden=true
        consumerConnectTblView.isHidden=false
        selrctRangeLabel.isHidden=true
        maxRangeLbl.isHidden=true
        minRangeLbl.isHidden=true
        kmSlider.isHidden=true
        rangeViewHeight.constant=0
        rangeView.isHidden=true
        fromTab="active"
        self.getActiveConsumerConnect()
    }
    @IBOutlet var activeLabel: UILabel!
    @IBOutlet var activeButton: UIButton!
    @IBAction func onClickClosedButton(_ sender: Any) {
        searchLabel.isHidden=true
        activeLabel.isHidden=true
        closedLabel.isHidden=false
        searchView.isHidden=true
        consumerConnectTblView.isHidden=false
        selrctRangeLabel.isHidden=true
        maxRangeLbl.isHidden=true
        minRangeLbl.isHidden=true
        kmSlider.isHidden=true
        rangeViewHeight.constant=0
        rangeView.isHidden=true
        fromTab="closed"
        self.getClosedConsumerConnect()
    }
    @IBOutlet var closedLabel: UILabel!
    @IBOutlet var closedButton: UIButton!
    @IBOutlet var searchView: UIView!
   
    @IBOutlet var productIdTF: UITextField!
    @IBOutlet var productNameTF: UITextField!
    @IBOutlet var accountIdTF: UITextField!
    @IBOutlet var searchWithButton: UIButton!
    @IBAction func onClickSearchWithButton(_ sender: Any) {
        self.getSearchConsumerConnect()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let nibName = UINib(nibName: "ConsumerCoonectTableViewCell", bundle: nil)
        consumerConnectTblView.register(nibName, forCellReuseIdentifier: "ConsumerCoonectTableViewCell")
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: lookungForTextField.frame.size.width - (35), y: 0, width: 35, height: lookungForTextField.frame.size.height)
        lookungForTextField.rightView = paddingView
        lookungForTextField.rightViewMode = UITextField.ViewMode.always
        
        let filterBtn = UIButton()
        filterBtn.frame = CGRect(x: paddingView.frame.size.width/2 - 12.5, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
        filterBtn.addTarget(self, action: #selector(onFilterBtnTapped), for: .touchUpInside)
        paddingView.addSubview(filterBtn)
        
        lookungForTextField.delegate = self
        
        if(headerTitleStr == "GiveAway"){
            titleTxtLbl.text = "Give Away"
            
        }else{
            titleTxtLbl.text = "Consumer Connect"

        }

        consumerConnectTblView.delegate = self
        consumerConnectTblView.dataSource = self
        
        kmSlider.minimumValue = 0
        kmSlider.maximumValue = 10
        
//        let maxValue = (defaults.value(forKey: "maxVicinity") ?? 0)
        kmSlider.setValue(Float(10), animated: false)

//        maxVicinity
        
        kmSlider.isContinuous = false

        if(headerTitleStr == "GiveAway"){
            kmSlider.addTarget(self, action:#selector(sliderGiveAwayValueDidChange(sender:)), for: .valueChanged)

        }else{
            kmSlider.addTarget(self, action:#selector(sliderValueDidChange(sender:)), for: .valueChanged)

        }
        
//

//        kmSlider.trackTintColor = hexStringToUIColor(hex: "005bf8")
//        kmSlider.trackHighlightTintColor = UIColor.lightGray
////        kmSlider.lowerValue = 1
////        kmSlider.maximumValue = 52
//        kmSlider.thumbTintColor = UIColor.white
//        kmSlider.thumbBorderWidth = 1
//        kmSlider.thumbBorderColor = UIColor.lightGray
        
//        kmSlider.addTarget(self, action: #selector(onchangedTheSliderValue), for: .valueChanged)

        // Do any additional setup after loading the view.
    }
    
    @objc func onFilterBtnTapped(){
     
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "GlobalSearchViewController") as! GlobalSearchViewController
                    //      self.navigationController?.pushViewController(VC, animated: true)
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)
        
        lookungForTextField.resignFirstResponder()

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
    
    @objc func sliderValueDidChange(sender: UISlider) {
        locEndRange = Float(String(format: "%.2f", sender.value)) ?? 0
        
        if(locEndRange <= 1){
           
            maxRangeLbl.text = "\(locEndRange) Km"

        }else{
           
            maxRangeLbl.text = "\(locEndRange) Kms"

        }
//        if(headerTitleStr == "GiveAway"){
//            setVicinityAPI()
//
//        }else{
            getCosumerConnectAPI()

//        }

   }
    
    @objc func sliderGiveAwayValueDidChange(sender: UISlider){
       
        locEndRange = sender.value
        
        if(locEndRange <= 1){
           
            maxRangeLbl.text = "\(locEndRange) Km"

        }else{
           
            maxRangeLbl.text = "\(locEndRange) Kms"

        }
        
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(sender.value, forKey: "maxVicinity")

        setVicinityAPI()

    }
    
    @objc func onchangedTheSliderValue(){
//        minRangeLbl.text = "\(Int(rangeSlider.lowerValue)) Km"
//        maxRangeLbl.text = "\(Int(rangeSlider.upperValue)) Km"

    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        
        animatingView()

        if(headerTitleStr == "GiveAway"){
            getGiveAwayListAPI()
       
        }else{
            //getCosumerConnectAPI()

        }
    }
    
    @IBAction func menuBtnTap(_ sender: Any) {
       toggleSideMenuViewWithAnimation()

    }
    

    @objc func onChangedYearSliderValue(){

//        let str = slider(rangeSlider, stringForValue: yearsSlider.maximumValue)


    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
           var cell = consumerConnectTblView.dequeueReusableCell(withIdentifier: "ConsumerCoonectTableViewCell", for: indexPath) as! ConsumerCoonectTableViewCell
        
        var mainDict = NSDictionary()
        var productDict = NSDictionary()
        
        
      
            mainDict = consumerConnectResult[indexPath.row] as! NSDictionary
            productDict = consumerConnectResult[indexPath.row] as! NSDictionary
        

        let dataDict = productDict.value(forKey: "productDetails") as! NSDictionary
       if let offeredPrice = dataDict.value(forKey: "unitPrice") as? Double
       {
        cell.pricePerStockUnitAnswerL.text = String(format:"%.2f",offeredPrice ?? 0)
       }
        else  if let offeredPrice = dataDict.value(forKey: "unitPrice") as? Float
        {
         cell.pricePerStockUnitAnswerL.text = String(format:"%.2f",offeredPrice ?? 0)
        }
        else
        {
            cell.pricePerStockUnitAnswerL.text = dataDict.value(forKey: "unitPrice") as? String
        }
        if let offeredQty = dataDict.value(forKey: "stockQuantity") as? Double
        {
        cell.offeredQuantityAnswerL.text = String(format:"%.2f",offeredQty ?? 0)
        }
        else if let offeredQty = dataDict.value(forKey: "stockQuantity") as? Float
        {
        cell.offeredQuantityAnswerL.text = String(format:"%.2f",offeredQty ?? 0)
        }
        else
        {
            cell.offeredQuantityAnswerL.text = dataDict.value(forKey: "stockQuantity") as? String
        }
        if let offeredpriced = dataDict.value(forKey: "price") as? Double
        {
        cell.totalPriceAnswerL.text = String(format:"%.2f", offeredpriced)
        }
        else if let offeredpriced = dataDict.value(forKey: "price") as? Float
        {
        cell.totalPriceAnswerL.text = String(format:"%.2f", offeredpriced)
        }
        else
        {
            cell.totalPriceAnswerL.text = dataDict.value(forKey: "price") as? String
        }
        let stockUnit = productDict.value(forKey: "stockUnitDetails") as? NSArray
        var stockUnitName=NSDictionary()
        if stockUnit?.count ?? 0>0
        {
            stockUnitName = stockUnit?[0] as? NSDictionary ?? NSDictionary()
        }

        cell.prodIDLbl.text = dataDict["productUniqueNumber"] as? String
        cell.prodNameLbl.text = dataDict.value(forKey: "productName") as? String
        cell.prodDescLbl.text = dataDict.value(forKey: "description") as? String
        cell.statusBiddL.text = productDict.value(forKey: "statusOfBiddingRequest") as? String
        
        if let pp=productDict.value(forKey: "requiredQuantity")as? Double
        {
        cell.bidQuantityAnswerL.text=String(format:"%.2f", pp)
        }
        else if let pp=productDict.value(forKey: "requiredQuantity")as? Float
        {
            cell.bidQuantityAnswerL.text=String(format:"%.2f", pp)
            }
            else if let pp=productDict.value(forKey: "requiredQuantity")as? String
            {
                cell.bidQuantityAnswerL.text=pp
            }
        if fromTab == "active"{
            cell.statusBiddL.textColor=UIColor.green
            cell.acceptBidBtn.isHidden=false
        }else if fromTab == "closed"
        {
            cell.statusBiddL.textColor=UIColor.red
            cell.acceptBidBtn.isHidden=true

            }
        cell.stockUnitAnswerL.text = stockUnitName.value(forKey: "stockUnitName") as? String
        
        
        if let pp=productDict.value(forKey: "counterUnitPrice")as? Double
        {
        cell.bidPricePerUnitAnswerL.text=String(format:"%.2f", pp)
        }
        else if let pp=productDict.value(forKey: "requiredQuantity")as? Float
        {
            cell.bidPricePerUnitAnswerL.text=String(format:"%.2f", pp)
            }
            else if let pp=productDict.value(forKey: "requiredQuantity")as? String
            {
                cell.bidPricePerUnitAnswerL.text=pp
            }

        let expiryDate = (dataDict.value(forKey: "expiryDate") as? String) ?? ""
        let convertedExpiryDate = convertServerDateFormatter(date: expiryDate)
        cell.expiryDateAnswerL.text = convertedExpiryDate
        
        let purchaseDate = (dataDict.value(forKey: "purchaseDate") as? String) ?? ""
        let convertedpurchaseDate = convertServerDateFormatter(date: purchaseDate)
        cell.purchaseDateAnswerL.text = convertedpurchaseDate
        
//        if(headerTitleStr == "GiveAway"){
//
//            cell.acceptBidBtn.isHidden = false
//            cell.productChangeHisLbl.isHidden = false
//
//            cell.biddingDetailsLbl.isHidden = false
//            cell.biddingViewBtn.isHidden = false
        cell.acceptBidBtn.tag=indexPath.row
            cell.acceptBidBtn.setTitle("CANCEL", for: .normal)
            cell.acceptBidBtn.addTarget(self, action: #selector(cancelBidBtnTap), for: .touchUpInside)
//            cell.stockQuanTxtLbl.text = String(stockQty ?? 0)
//            cell.stockUnitTxtLbl.text = dataDict.value(forKey: "stockUnit") as? String
            cell.productChangeHistoryButton.addTarget(self, action: #selector(productViewBtnTap), for: .touchUpInside)
            cell.productChangeHistoryButton.tag = indexPath.row
            cell.chatButton.addTarget(self, action: #selector(onChatBtnTapped), for: .touchUpInside)
            cell.chatButton.tag = indexPath.row
        cell.chatButton.layer.borderColor = UIColor.blue.cgColor
        cell.chatButton.layer.borderWidth = 1
//
//        }else{
            
            //cell.stackViewYPosConstant.constant = 15
//            cell.stockQuanLbl.isHidden = true
//            cell.stockUnitLbl.isHidden = true
//            cell.stockQuanTxtLbl.isHidden = true
//            cell.stockUnitTxtLbl.isHidden = true
            //cell.productChangeHisLbl.isHidden = false
//            cell.viewBtn.isHidden = true
            //cell.acceptBidYPos.constant = 65
            
           // cell.acceptBidBtn.isHidden = true
//            cell.productChangeHisLbl.isHidden = false
//
//            cell.biddingDetailsLbl.isHidden = false
//            cell.biddingViewBtn.isHidden = false
//
//            cell.viewBtn.addTarget(self, action: #selector(productViewBtnTap), for: .touchUpInside)
//            cell.viewBtn.tag = indexPath.row
             
//            cell.acceptBidBtn.setTitle("Accept Bid", for: .normal)
//            cell.acceptBidBtn.tag = indexPath.row
//            cell.acceptBidBtn.addTarget(self, action: #selector(acceptBidBtnTap), for: .touchUpInside)
            
//            cell.biddingViewBtn.addTarget(self, action: #selector(biddingViewBtnTap), for: .touchUpInside)
//            cell.biddingViewBtn.tag = indexPath.row

//            if(statusStr == "Requested"){
//                cell.acceptBidBtn.isHidden = true
//
//            }else{
//                cell.acceptBidBtn.isHidden = false
//
//            }
       // }
        let userDetailsDict = productDict.value(forKey: "accountDetails") as? NSDictionary
        cell.accountNameBtn.setTitle(userDetailsDict?.value(forKey: "companyName")as? String, for: .normal)
        let locDict = userDetailsDict?.value(forKey: "loc") as? NSDictionary
        let coordinatesArr = locDict?.value(forKey: "coordinates") as? NSArray

        let latVal = coordinatesArr?.object(at: 0) as? Double ?? 0
        let longVal = coordinatesArr?.object(at: 1) as? Double ?? 0

        let camera = GMSCameraPosition.camera(withLatitude: latVal, longitude: longVal, zoom: 12)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: cell.productMapView.frame.size.width, height: cell.productMapView.frame.size.height), camera: camera)
        cell.productMapView.addSubview(mapView)

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latVal, longitude: longVal)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
        marker.map = mapView
        
        let prodArray = dataDict.value(forKey: "productImages") as? NSArray

        if(prodArray?.count ?? 0  > 0){

                    let dict = prodArray?[0] as? NSDictionary

            let imageStr = dict?.value(forKey: "0") as! String

                    if !imageStr.isEmpty {

                        let imgUrl:String = imageStr

                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")

                        let imggg = Constants.BaseImageUrl + trimStr

//                            let url = URL.init(string: imggg)
//                            let fileUrl = URL(fileURLWithPath: imggg)
                        
                        let fileUrl = URL(string: imggg)

                        cell.prodImgView?.sd_setImage(with: fileUrl, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                        cell.prodImgView?.contentMode = UIView.ContentMode.scaleAspectFit

                    }

                    else {

                        cell.prodImgView?.image = UIImage(named: "no_image")
                    }
        }else{
            cell.prodImgView?.image = UIImage(named: "no_image")

        }


             return cell
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consumerConnectResult.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        if(headerTitleStr == "GiveAway"){
//            return 530
//
//        }else{
//
//           let mainDict = consumerConnectResult[indexPath.row] as! NSDictionary
//            return 645
//           let productDict = mainDict.value(forKey: "result") as! NSArray
//
//            var statusStr = ""
//            statusStr = mainDict.value(forKey: "status") as? String ?? ""
//
            if fromTab == "active"{
                return 700

            }else if fromTab == "closed"
            {
                return 640

                }
        return 0
            //}
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == lookungForTextField){
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "GlobalSearchViewController") as! GlobalSearchViewController
                        //      self.navigationController?.pushViewController(VC, animated: true)
            VC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(VC, animated: true)
            
            textField.resignFirstResponder()

        }
    }
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

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
    func showAlertWith1(title:String,message:String)
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
                self.getActiveConsumerConnect()
            })
    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    
    @objc func productViewBtnTap(sender:UIButton){
       
        if(headerTitleStr == "GiveAway"){
            
           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
           let productDict = consumerConnectResult[sender.tag] as! NSDictionary
                
            let VC = storyBoard.instantiateViewController(withIdentifier: "ProductChangeHistoryViewController") as! ProductChangeHistoryViewController
            VC.modalPresentationStyle = .fullScreen
            VC.productId = productDict.value(forKey: "_id") as? String ?? ""
            self.navigationController?.pushViewController(VC, animated: true)

        }else{
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)

            let productDict = consumerConnectResult[sender.tag] as! NSDictionary
            let dataDict = productDict.value(forKey: "productDetails") as! NSDictionary
            let VC = storyBoard.instantiateViewController(withIdentifier: "ProductChangeHistoryViewController") as! ProductChangeHistoryViewController
            VC.modalPresentationStyle = .fullScreen
            VC.productId = dataDict.value(forKey: "_id") as? String ?? ""
            self.navigationController?.pushViewController(VC, animated: true)

        }
    }
    
    @objc func biddingViewBtnTap(sender:UIButton){
        
        if(headerTitleStr == "GiveAway"){
            
            let productDict = consumerConnectResult[sender.tag] as! NSDictionary

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GiveAwayDetailViewController") as! GiveAwayDetailViewController
            vc.idStr = (productDict.value(forKey:"productId") as? String)!
            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            
           let mainDict = consumerConnectResult[sender.tag] as! NSDictionary
           let productDict = mainDict.value(forKey: "result") as! NSDictionary

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ConsumerConnectDetailedViewController") as! ConsumerConnectDetailedViewController
            vc.idStr = (productDict.value(forKey:"_id") as? String)!
            self.navigationController?.pushViewController(vc, animated: true)

            }
    }
    
    @objc func acceptBidBtnTap(sender:UIButton)  {
        
       let mainDict = consumerConnectResult[sender.tag] as! NSDictionary
       let productDict = mainDict.value(forKey: "result") as! NSDictionary
        
//        acceptBidDict = (consumerConnectResult.object(at: sender.tag) as? NSDictionary)!
        
        acceptBidDict = productDict
        acceptBidViewUI()
        
    }
    
    @objc func cancelBidBtnTap(sender:UIButton){
        
        let dataDict = consumerConnectResult.object(at: sender.tag) as? NSDictionary
        
        let idStr = dataDict?.value(forKey: "_id") as? String ?? ""
        cancelBidAPI(idStr: idStr)
        
    }
    
    func acceptBidViewUI()  {
        
        acceptBidView.removeFromSuperview()
        counterPriceTF.removeFromSuperview()
        reqQtyTF.removeFromSuperview()
        
//        hiddenBtn = UIButton()
        hiddenBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)
        
        acceptBidView = UIView()
        acceptBidView.frame = CGRect(x: 20, y: self.view.frame.size.height/2-(225), width: self.view.frame.size.width - (40), height: 330)
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
        reqQtyTF.keyboardType = UIKeyboardType.numberPad
        acceptBidView.addSubview(reqQtyTF)

        reqQtyTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        reqQtyTF.layer.cornerRadius = 3
        reqQtyTF.clipsToBounds = true

        let currentPwdPaddingView = UIView()
        currentPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: reqQtyTF.frame.size.height)
        reqQtyTF.leftView = currentPwdPaddingView
        reqQtyTF.leftViewMode = UITextField.ViewMode.always
        
        //New Pwd Lbl

        let newPwdLbl = UILabel()
        newPwdLbl.frame = CGRect(x: 10, y: reqQtyTF.frame.origin.y+reqQtyTF.frame.size.height+15, width: acceptBidView.frame.size.width - (20), height: 20)
        newPwdLbl.text = "Counter Offer Price"
        newPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        newPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        acceptBidView.addSubview(newPwdLbl)

        //New Pwd TF

        counterPriceTF = UITextField()
        counterPriceTF.frame = CGRect(x: 10, y: newPwdLbl.frame.origin.y+newPwdLbl.frame.size.height+5, width: acceptBidView.frame.size.width - (20), height: 45)
        counterPriceTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        counterPriceTF.textColor = hexStringToUIColor(hex: "232c51")
        acceptBidView.addSubview(counterPriceTF)

        counterPriceTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        counterPriceTF.layer.cornerRadius = 3
        counterPriceTF.clipsToBounds = true

        let newPwdPaddingView = UIView()
        newPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: counterPriceTF.frame.size.height)
        counterPriceTF.leftView = newPwdPaddingView
        counterPriceTF.leftViewMode = UITextField.ViewMode.always
        
        let updateBtn = UIButton()
        updateBtn.frame = CGRect(x:acceptBidView.frame.size.width/2 - (90), y: counterPriceTF.frame.origin.y+counterPriceTF.frame.size.height+40, width: 80, height: 40)
        updateBtn.setTitle("CLOSE", for: UIControl.State.normal)
        updateBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        updateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        updateBtn.backgroundColor = hexStringToUIColor(hex: "232c51")
        updateBtn.addTarget(self, action: #selector(closeBtnTap), for: .touchUpInside)

        acceptBidView.addSubview(updateBtn)
        
        let submitBtn = UIButton()
        submitBtn.frame = CGRect(x:acceptBidView.frame.size.width/2 + (10), y: counterPriceTF.frame.origin.y+counterPriceTF.frame.size.height+40, width: 80, height: 40)
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
    
    @objc func acceptBidSubmitBtnTap(sender:UIButton){
        
//        let  productDict = acceptBidDict.value(forKey: "result") as! NSDictionary

        let reqQty: Int? = Int(reqQtyTF.text ?? "0")
        let offeredQty = acceptBidDict.value(forKey: "offeredQuantity") as? Int ?? 0
        
        if(reqQtyTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter required quantity")
            return
            
        }else if(reqQty ?? 0 > offeredQty){
            self.showAlertWith(title: "Alert", message: "Required quantity should be less than Offered quantity")
            return

        }
        else if(counterPriceTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter counter prince")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(headerTitleStr == "GiveAway"){
            
//            let productDict = consumerConnectResult[indexPath.row] as! NSDictionary
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "GiveAwayDetailViewController") as! GiveAwayDetailViewController
//            vc.idStr = (productDict.value(forKey:"productId") as? String)!
//            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            
//           let mainDict = consumerConnectResult[indexPath.row] as! NSDictionary
//           let productDict = mainDict.value(forKey: "result") as! NSDictionary
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "ConsumerConnectDetailedViewController") as! ConsumerConnectDetailedViewController
//            vc.idStr = (productDict.value(forKey:"_id") as? String)!
//            self.navigationController?.pushViewController(vc, animated: true)

            }
       }

    func cancelBidAPI(idStr:String)  {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

            let URLString_loginIndividual = Constants.BaseUrl + ConsumerDetailsRejectUrl + idStr
        
        let params_IndividualLogin = ["id":idStr]
        
        servCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: params_IndividualLogin as NSDictionary, successHandler: { (result) in
            

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                self.showAlertWith1(title: "Suceess", message:"Bid Rejected successfully")
                                //self.getGiveAwayListAPI()
                               // self.getActiveConsumerConnect()
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

    func acceptBidAPI(dataDict:NSDictionary) {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let prodIDStr = acceptBidDict.value(forKey: "productId") as? String
        let consumerConnectIdStr = acceptBidDict.value(forKey: "_id") as? String
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String


        let URLString_loginIndividual = Constants.BaseUrl + AcceptBidUrl
        
        let params_IndividualLogin = ["productId":prodIDStr,"consumerConnectId":consumerConnectIdStr,"accountId":accountID,"requiredQuantity":reqQtyTF.text ?? "","counterOfferPrice":counterPriceTF.text ?? "","userId":userID]
        
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
    
    func setVicinityAPI() {

        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let URLString_loginIndividual = Constants.BaseUrl + SetGiveAwayRangeUrl
         
                    let params_IndividualLogin = [
                        "accountId" : accountID,
                        "from" : locStartRange,
                        "to" : locEndRange
                    ] as [String : Any]
                
                
                    let postHeaders_IndividualLogin = ["":""]
                    
        servCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

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

    func getCosumerConnectAPI() {
        
        consumerConnectResult.removeAllObjects()
        consumerConnectResult = NSMutableArray()
        
        animatingView()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        print("Acc ID is \(accountID)")
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String

        let URLString_loginIndividual = Constants.BaseUrl + ConsumerConnectListUrl + accountID + "/\(userID)" + "/\(locEndRange)"
                                    
        let params_IndividualLogin = [
            "productId" : productIdTF.text,
            "productName" : productNameTF.text,
            "accountName" : accountIdTF.text
        ] as [String : Any]
    
    
        let postHeaders_IndividualLogin = ["":""]
        
servCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

            let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                    
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
                        
            if status == "SUCCESS" {
                
                if(statusCode == 200 ){
                    let dataDict = result as? NSDictionary
                    
                    self.consumerConnectResult = dataDict?.value(forKey: "result")  as! NSMutableArray
//                    let mainDict = consumerConnectResult[sender.tag] as! NSDictionary
//                    let productDict = mainDict.value(forKey: "result") as! NSDictionary
//
//                     let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                     let vc = storyboard.instantiateViewController(withIdentifier: "ConsumerConnectDetailedViewController") as! ConsumerConnectDetailedViewController
//                     vc.idStr = (productDict.value(forKey:"_id") as? String)!
//                     self.navigationController?.pushViewController(vc, animated: true)

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
    
    func getGiveAwayListAPI() {
        
        consumerConnectResult.removeAllObjects()
        consumerConnectResult = NSMutableArray()
        
        animatingView()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        print("Acc ID is \(accountID)")

        let URLString_loginIndividual = Constants.BaseUrl + GiveAwayListUrl + accountID
                                    
        servCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                let dataDict = result as? NSDictionary
                                
                                self.consumerConnectResult = dataDict?.value(forKey: "result")  as? NSMutableArray ?? NSMutableArray()
                                
                                if(self.consumerConnectResult.count > 0){
                                    
                                    self.emptyMsgBtn.removeFromSuperview()
                                    self.consumerConnectTblView.reloadData()
                                }
                                else
                                {
                                    self.consumerConnectTblView.reloadData()
                                }
                                
                            }else {
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
        
        if(self.consumerConnectResult.count == 0){
//            self.showEmptyMsgBtn()
        }
            
    }
    
    func getSearchConsumerConnect()
    {
        
        consumerConnectResult.removeAllObjects()
        consumerConnectResult = NSMutableArray()
        
        animatingView()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        print("Acc ID is \(accountID)")
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String

        let URLString_loginIndividual = Constants.BaseUrl + searchConsumerConnect + accountID + "/\(userID)" + "/\(locEndRange)"
                                    
        let params_IndividualLogin = [
            "productId" : productIdTF.text,
            "productName" : productNameTF.text,
            "accountName" : accountIdTF.text
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
                    
                    
                   self.consumerConnectResult = dataDict?.value(forKey: "result")  as? NSMutableArray ?? NSMutableArray()

                     let storyboard = UIStoryboard(name: "Main", bundle: nil)
                     let vc = storyboard.instantiateViewController(withIdentifier: "ConsumerConnectDetailedViewController") as! ConsumerConnectDetailedViewController
                    vc.locRange=self.locEndRange
                    vc.accounntId=self.accountIdTF.text ?? ""
                    vc.productIDD=self.productIdTF.text ?? ""
                    vc.prodductName=self.productNameTF.text ?? ""
                    vc.consumerDetailsArray = dataDict!
                     self.navigationController?.pushViewController(vc, animated: true)

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
    func getActiveConsumerConnect()
    {
        
        consumerConnectResult.removeAllObjects()
        consumerConnectResult = NSMutableArray()
        
        animatingView()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        print("Acc ID is \(accountID)")
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String

        let URLString_loginIndividual = Constants.BaseUrl + activeConsumerConnect + accountID
                                    
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
                                
                                if(self.consumerConnectResult.count > 0){
                                    
                                    self.emptyMsgBtn.removeFromSuperview()
                              
                                }else if(self.consumerConnectResult.count == 0){
                                    self.showEmptyMsgBtn()
                                }
                                
                                self.consumerConnectTblView.reloadData()

                                
                            }else {
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
        
        if(self.consumerConnectResult.count == 0){
//            self.showEmptyMsgBtn()
        }
    }
    func getClosedConsumerConnect()
    {
        
        consumerConnectResult.removeAllObjects()
        consumerConnectResult = NSMutableArray()
        
        animatingView()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        print("Acc ID is \(accountID)")
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String

        let URLString_loginIndividual = Constants.BaseUrl + closedConsumerConnect + accountID
                                    
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
                                
                                if(self.consumerConnectResult.count > 0){
                                    
                                    self.emptyMsgBtn.removeFromSuperview()
                              
                                }else if(self.consumerConnectResult.count == 0){
                                    self.consumerConnectTblView.isHidden=true
                                    self.showEmptyMsgBtn()
                                }
                                
                                self.consumerConnectTblView.reloadData()

                                
                            }else {
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
        
        if(self.consumerConnectResult.count == 0){
//            self.showEmptyMsgBtn()
        }
    }
    @objc func onChatBtnTapped(_ sender: UIButton){
        
        let userDefaults = UserDefaults.standard
        
        let resultDataDict = consumerConnectResult.object(at: sender.tag) as? NSDictionary
    
        let dataDict = consumerConnectResult.object(at: sender.tag) as? NSDictionary
        let prodDetailsDict = dataDict?.value(forKey: "productDetails") as? NSDictionary
        let userDetailsDict = dataDict?.value(forKey: "userDetails") as? NSDictionary
        let accountDetailsDict = dataDict?.value(forKey: "accountDetails") as? NSDictionary
//      let userDetailsDict = userDetailsArr?.object(at: 0) as? NSDictionary

        let giveAwayID = dataDict?.value(forKey: "giveAwayId") as? String ?? "0"
        let chatUserID = accountDetailsDict?.value(forKey: "_id") as? String ?? "0"
        
//        userDefaults.set(giveAwayID, forKey: "giveAwayID")
//        userDefaults.set(chatUserID, forKey: "chatUserID")
        
//        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as? String ?? ""
//        let giveAwayID = userDefaults.value(forKey: "giveAwayID") as? String ?? ""
//        let chatUSerId = userDefaults.value(forKey: "chatUserID") as? String ?? ""

        let finalSuerID = giveAwayID + " \(accountID)" + " \(chatUserID)"
        userDefaults.set(finalSuerID, forKey: "finalChatUserId")
        
        let firstName = userDetailsDict?.value(forKey: "firstName") as? String ?? ""
        let lastName = userDetailsDict?.value(forKey: "lastName") as? String ?? ""
        
        let fullName = firstName + " " + lastName

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        VC.chatNameStr = fullName
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)

    }
}
