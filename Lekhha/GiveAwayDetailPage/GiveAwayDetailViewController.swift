//
//  GiveAwayDetailViewController.swift
//  Lekhha
//
//  Created by USM on 01/06/21.
//

import UIKit
import ObjectMapper
import GoogleMaps
import TwilioChatClient
class GiveAwayDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var sideMenuView = SideMenuView()
    var accountID = String()
    var serCntrl = ServiceController()
    var giveAwayListArr = NSMutableArray()
    var idStr = String()
    var emptyMsgBtn = UIButton()
    var statusBiddingReq = ""
    var updateIdStr = ""
    
    @IBAction func menuBtnTapped(_ sender: Any) {
        toggleSideMenuViewWithAnimation()
    }
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatManager.sendMessage(textField.text!, completion: { (result, _) in
            if result.isSuccessful() {
                textField.text = ""
                textField.resignFirstResponder()
            } else {
                self.displayErrorMessage("Unable to send message")
            }
        })
        return true
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
    
    @IBOutlet weak var lookingForTF: UITextField!
    
    @IBOutlet weak var giveAwayTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lookingForTF.delegate = self
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        giveAwayTblView.delegate = self
        giveAwayTblView.dataSource = self
        
       
        let headerNib = UINib(nibName: "GiveAwatDetailedTableViewCell", bundle: nil)
        giveAwayTblView.register(UINib(nibName: "GiveAwatDetailedTableViewCell", bundle: nil), forCellReuseIdentifier: "GiveAwatDetailedTableViewCell")
        
        giveAwayTblView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        
        giveAwayTblView.register(UINib(nibName: "ReceiverChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiverChatTableViewCell")
        chatManager.delegate = self
        let paddingView = UIView()
        paddingView.frame = CGRect(x: lookingForTF.frame.size.width - (35), y: 0, width: 35, height: lookingForTF.frame.size.height)
        lookingForTF.rightView = paddingView
        lookingForTF.rightViewMode = UITextField.ViewMode.always
        
        let filterBtn = UIButton()
        filterBtn.frame = CGRect(x: paddingView.frame.size.width/2 - 12.5, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
        filterBtn.addTarget(self, action: #selector(onFilterBtnTapped), for: .touchUpInside)
        paddingView.addSubview(filterBtn)
        getGiveAwayDetailsAPI()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        fromChatScreen="giveAway"
           
        animatingView()
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
        chatText=textField.text ?? ""
    }
    var chatManager = QuickstartChatManager()
    var chatText=String()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = giveAwayTblView.dequeueReusableCell(withIdentifier: "GiveAwatDetailedTableViewCell", for: indexPath) as! GiveAwatDetailedTableViewCell
        cell.selectionStyle = .none
        let dataDict = giveAwayListArr.object(at: indexPath.row) as? NSDictionary
        let prodDetailsDict = dataDict?.value(forKey: "productDetails") as? NSDictionary
        let userDetailsDict = dataDict?.value(forKey: "userDetails") as? NSDictionary
        let accountDetailsDict = dataDict?.value(forKey: "accountDetails") as? NSDictionary
//        let userDetailsDict = userDetailsArr?.object(at: 0) as? NSDictionary
        cell.accountNameL.text=accountDetailsDict?.value(forKey: "companyName")as? String
//        var userName = ""
        let firstName = userDetailsDict?.value(forKey: "firstName") as? String ?? ""
        let lastName = userDetailsDict?.value(forKey: "lastName") as? String ?? ""

        let userName = "\(firstName) \(lastName)"
        
        cell.orderIdLbl.text = prodDetailsDict?.value(forKey: "productUniqueNumber") as? String
        cell.nameLbl.text = userName
        cell.accIdLbl.text = accountDetailsDict?.value(forKey: "accountUniqueId") as? String
        var counterOfferPrice=String()
        if let pp=dataDict?.value(forKey: "counterOfferPrice")as? Double
        {
            counterOfferPrice=String(format:"%.2f", pp)
        }
        else if let pp=dataDict?.value(forKey: "counterOfferPrice")as? Float
        {
            counterOfferPrice=String(format:"%.2f", pp)
            }
            else if let pp=dataDict?.value(forKey: "counterOfferPrice")as? String
            {
                counterOfferPrice=pp
            }
        var reqQty=String()
        if let pp=dataDict?.value(forKey: "requiredQuantity")as? Double
        {
            reqQty=String(format:"%.3f", pp)
        }
        else if let pp=dataDict?.value(forKey: "requiredQuantity")as? Float
        {
            reqQty=String(format:"%.3f", pp)
            }
            else if let pp=dataDict?.value(forKey: "requiredQuantity")as? String
            {
                reqQty=pp
            }
        var counterUnitPrice=String()
        if let pp=dataDict?.value(forKey: "counterUnitPrice")as? Double
        {
            counterUnitPrice=String(format:"%.2f", pp)
        }
        else if let pp=dataDict?.value(forKey: "counterUnitPrice")as? Float
        {
            counterUnitPrice=String(format:"%.2f", pp)
            }
            else if let pp=dataDict?.value(forKey: "counterUnitPrice")as? String
            {
                counterUnitPrice=pp
            }
        let orderStatusStr = dataDict?.value(forKey: "statusOfBiddingRequest") as? String
        cell.offerPriceByTheBidderLbl.text = counterOfferPrice
        cell.bidPriceL.text = counterUnitPrice
        cell.reqQtyLbl.text = reqQty
        
        let locDict = accountDetailsDict?.value(forKey: "loc") as? NSDictionary
        let coordinatesArr = locDict?.value(forKey: "coordinates") as? NSArray
        
//        let latDict = coordinatesArr?.object(at: 0) as? NSDictionary
//        let longDict = coordinatesArr?.object(at: 1) as? NSDictionary
        
        let latVal = coordinatesArr?.object(at: 0) as? Double ?? 0
        let longVal = coordinatesArr?.object(at: 1) as? Double ?? 0
        
        cell.expandButton.addTarget(self, action: #selector(chatBtnTap), for: .touchUpInside)
        cell.expandButton.tag = indexPath.row
        chatText=cell.chatTF.text ?? ""
        cell.sendButton.addTarget(self, action: #selector(sendBtnTap(sender:)), for: .touchUpInside)
        cell.sendButton.tag = indexPath.row
       
        cell.acceptDeclineLbl.text = orderStatusStr
   
        let camera = GMSCameraPosition.camera(withLatitude: latVal, longitude: longVal, zoom: 12)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: cell.mapBackView.frame.size.width, height: cell.mapBackView.frame.size.height), camera: camera)
        cell.mapBackView.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latVal, longitude: longVal)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
        marker.map = mapView

        cell.declineBtn.addTarget(self, action: #selector(declineBtnTap), for: .touchUpInside)
        
        cell.acceptBtn.tag = indexPath.row
        cell.declineBtn.tag = indexPath.row
        
        if(orderStatusStr == "Pending"){
            cell.acceptBtn.setTitle("Accept", for: .normal)
            cell.acceptBtn.backgroundColor = hexStringToUIColor(hex: "00ce44")
            cell.declineBtn.backgroundColor = hexStringToUIColor(hex: "ff5072")
            cell.chatBtn.isHidden = true
            
            cell.acceptBtn.isHidden = false
            cell.declineBtn.isHidden = false
            
            cell.acceptDeclineLbl.textColor = hexStringToUIColor(hex: "00ce44")
            cell.acceptBtn.addTarget(self, action: #selector(acceptBtnTap), for: .touchUpInside)
            
        }else if(orderStatusStr == "Accepted"){
            cell.acceptBtn.setTitle("Completed", for: .normal)
            cell.acceptBtn.backgroundColor = hexStringToUIColor(hex: "125ff0")
            cell.declineBtn.backgroundColor = hexStringToUIColor(hex: "ff5072")
            cell.chatBtn.isHidden = true
            
            cell.acceptBtn.isHidden = false
            cell.declineBtn.isHidden = false
            
            cell.acceptBtn.addTarget(self, action: #selector(completedBtnTap), for: .touchUpInside)

        }
        else if(orderStatusStr == "Bid"){
            //cell.acceptBtn.backgroundColor = hexStringToUIColor(hex: "125ff0")
           // cell.declineBtn.backgroundColor = hexStringToUIColor(hex: "ff5072")
            cell.chatBtn.isHidden = true
            
            cell.acceptBtn.isHidden = false
            cell.declineBtn.isHidden = false
            
            cell.acceptBtn.addTarget(self, action: #selector(acceptBtnTap), for: .touchUpInside)

        }
        else{
            cell.acceptBtn.isHidden = true
            cell.declineBtn.isHidden = true
            cell.chatBtn.isHidden = true
            
            if(orderStatusStr == "Rejected"){
                cell.acceptDeclineLbl.textColor = hexStringToUIColor(hex: "ff5072")

            }else{
                cell.acceptDeclineLbl.textColor = hexStringToUIColor(hex: "125ff0")

            }
        }
        cell.chatView.layer.borderWidth=1
        cell.chatView.layer.borderColor=UIColor.lightGray.cgColor
        cell.textView.layer.borderWidth=1
        cell.textView.layer.borderColor=UIColor.lightGray.cgColor
        cell.expandButton.layer.borderWidth=1
        cell.expandButton.layer.borderColor=UIColor.blue.cgColor
//        cell.sendButton.layer.borderWidth=1
//        cell.sendButton.layer.borderColor=UIColor.blue.cgColor
        cell.chatTF.delegate=self
        cell.chatTF.text=""
        //cell.chatView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        let chatDataArray=dataDict?.value(forKey: "chatObject")as? NSMutableArray ?? NSMutableArray()
        var scrollView = UIScrollView()
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: cell.chatMainUIView.frame.size.width, height: cell.chatMainUIView.frame.size.height))
        
        if chatDataArray.count>0
        {
            var chatHeight=CGFloat()
            for i in 0..<chatDataArray.count
        {
               
        let chatDict=chatDataArray[i] as? NSDictionary
                let  messageAuthor  = chatDict?.value(forKey: "author") as? String
                
                let userDefaults = UserDefaults.standard
                let accountId = userDefaults.value(forKey: "accountId") as! String
                if(messageAuthor == accountId){
            let chattView=ChatCustomView()
                let messageStr = chatDict?.value(forKey: "messageText") as? String ?? ""
                
                var Qheight = heightForView(text: messageStr, font: UIFont(name: kAppFont, size: 15)!, width: cell.chatMainUIView.frame.size.width - 80, xValue: 0, yValue: 0)
                
                if(Qheight < 40){
                    Qheight = 40
                    Qheight = Qheight + 10
                }
                else{
                    Qheight = Qheight + 10
                }
                print("Tablecell",indexPath.row,i,Qheight,chatHeight)
                chattView.frame=CGRect(x: 0, y: chatHeight, width: cell.chatMainUIView.frame.size.width, height: Qheight)
                
            chattView.labelHeight.constant = Qheight
                
                chatHeight = chatHeight + Qheight
        chattView.chatTxtLbl.text=messageStr
            let userID = userDefaults.value(forKey: "userID") as! String
            print(userID)

            let imageStr = MyAccImgUrl + userID

            if !imageStr.isEmpty {

                let imgUrl:String = imageStr

                let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")

                let imggg = MyAccImgUrl + userID

                let url = URL.init(string: imggg)
 
                chattView.chatProfileImg.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)
                chattView.chatProfileImg.contentMode = UIView.ContentMode.scaleAspectFill
            }
            else {
                chattView.chatProfileImg.image = UIImage(named: "no_image")
                
            }
            chattView.dateLabel.text=convertDateTimeFormatter1(date: chatDict?.value(forKey: "dateCreated") as? String ?? "")
//                if chatHeight>CGFloat(170)
//                {
//                   break
//                }else
//                {
                    //cell.chatMainUIVHeight.constant=chatHeight
                    scrollView.addSubview(chattView)
                //}
                }
                else
                {
            let chattView=ReceiverCustomView()
                let messageStr = chatDict?.value(forKey: "messageText") as? String ?? ""
                
                var Qheight = heightForView(text: messageStr, font: UIFont(name: kAppFont, size: 15)!, width: cell.chatMainUIView.frame.size.width - 80, xValue: 0, yValue: 0)
                
                if(Qheight < 40){
                    Qheight = 40
                    Qheight = Qheight + 10
                }
                else{
                    Qheight = Qheight + 10
                }
                print("Tablecell",indexPath.row,i,Qheight,chatHeight)
                chattView.frame=CGRect(x: 0, y: chatHeight, width: cell.chatMainUIView.frame.size.width, height: Qheight)
                
                    chattView.labelHeight.constant=Qheight
                
                chatHeight = chatHeight + Qheight
        chattView.chatTxtLbl.text=messageStr
            let userID = userDefaults.value(forKey: "userID") as! String
            print(userID)

            let imageStr = MyAccImgUrl + userID

            if !imageStr.isEmpty {

                let imgUrl:String = imageStr

                let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")

                let imggg = MyAccImgUrl + userID

                let url = URL.init(string: imggg)
 
                chattView.chatProfileImg.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)
                chattView.chatProfileImg.contentMode = UIView.ContentMode.scaleAspectFill
            }
            else {
                chattView.chatProfileImg.image = UIImage(named: "no_image")
                
            }
            chattView.dateLabel.text=convertDateTimeFormatter1(date: chatDict?.value(forKey: "dateCreated") as? String ?? "")
//                if chatHeight>CGFloat(170)
//                {
//                   break
//                }else
//                {
                    //cell.chatMainUIVHeight.constant=chatHeight
                scrollView.addSubview(chattView)
                //}
                }
                scrollView.contentSize = CGSize(width: cell.chatMainUIView.frame.size.width, height: chatHeight)
                let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom )
                scrollView.setContentOffset(bottomOffset, animated: true)
                scrollView.isScrollEnabled=true
                scrollView.bounces = false
                
                cell.chatMainUIView.addSubview(scrollView)
                
                
        }
            
        
        }
        return cell
       
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        chatManager.shutdown()
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
    // MARK: Login

    func login() {
        
        activity.startAnimating()
        
        chatManager.login(self.identity) { (success) in
            DispatchQueue.main.async {
                if success {
                    self.navigationItem.prompt = "Logged in as \"\(self.identity)\""
                    print("chat login success")
                    
                } else {
                    self.navigationItem.prompt = "Unable to login"
                    let msg = "Unable to login - check the token URL in ChatConstants.swift"
                    print("chat login fail")
                   activity.stopAnimating()
                    self.displayErrorMessage(msg)

                }
            }
        }
    }
    // MARK: Keyboard Dodging Logic

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
//                self.bottomConstraint.constant = keyboardRect.height + 10
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardDidShow(notification: NSNotification) {
//        scrollToBottomMessage()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
//            self.bottomConstraint.constant = 20
            self.view.layoutIfNeeded()
        })
    }
    var sendBtnID=Int()
    @objc func sendBtnTap(sender:UIButton){
        self.view.endEditing(true)
        sendBtnID=sender.tag
        let myString =  chatText
        let trimmedString = myString.trimmingCharacters(in: .whitespacesAndNewlines)

        if(trimmedString == ""){
            showAlertWith(title: "Alert", message: "Enter text")
            return
        }
       
            self.chatManager.sendMessage(trimmedString, completion: { (result, _) in
            if result.isSuccessful() {
                //self.chatTxxtField.text = ""
                print("Sent Successfully")
               // self.chatTxxtField.resignFirstResponder()
            } else {
                self.displayErrorMessage("Unable to send message")
            }
        })
        
    }
    private func displayErrorMessage(_ errorMessage: String) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
   
    }
    func heightForView(text:String, font:UIFont, width:CGFloat , xValue:Int,  yValue:Int) -> CGFloat {
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    var identity = "1738495944"
    var chatMessagesArray = NSMutableArray()
    var chatReversedMessageArray = NSMutableArray()
    var chatReversedMessageArray1 = NSMutableArray()
    @IBAction func completedBtnTap(_ sender: UIButton){
        
        let dataDict = giveAwayListArr.object(at: sender.tag) as? NSDictionary
        updateIdStr = dataDict?.value(forKey: "_id") as? String ?? ""
        
        statusBiddingReq = "Completed"
        self.callUpdateBiddingRequestAPI()

    }
    
    @IBAction func acceptBtnTap(_ sender: UIButton){
        
        let dataDict = giveAwayListArr.object(at: sender.tag) as? NSDictionary
        updateIdStr = dataDict?.value(forKey: "_id") as? String ?? ""
        
        statusBiddingReq = "Accepted"
        self.callUpdateBiddingRequestAPI()

    }
    
    @IBAction func declineBtnTap(_ sender: UIButton){
        
        let dataDict = giveAwayListArr.object(at: sender.tag) as? NSDictionary
        updateIdStr = dataDict?.value(forKey: "_id") as? String ?? ""
        
        statusBiddingReq = "Rejected"
        self.callUpdateBiddingRequestAPI()

    }
    
    @objc func onFilterBtnTapped(){
     
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "GlobalSearchViewController") as! GlobalSearchViewController
                    //      self.navigationController?.pushViewController(VC, animated: true)
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)
        
        lookingForTF.resignFirstResponder()

    }
    @objc func chatBtnTap(_ sender: UIButton){
        
        let userDefaults = UserDefaults.standard

        let dataDict = giveAwayListArr.object(at: sender.tag) as? NSDictionary
        let prodDetailsDict = dataDict?.value(forKey: "productDetails") as? NSDictionary
        let userDetailsDict = dataDict?.value(forKey: "userDetails") as? NSDictionary
        let accountDetailsDict = dataDict?.value(forKey: "accountDetails") as? NSDictionary
//        let userDetailsDict = userDetailsArr?.object(at: 0) as? NSDictionary

        let giveAwayID = dataDict?.value(forKey: "giveAwayId") as? String ?? "0"
        let chatUserID = accountDetailsDict?.value(forKey: "_id") as? String ?? "0"

        let userID = userDefaults.value(forKey: "userID") as? String ?? ""
        
        let finalSuerID = giveAwayID + " \(chatUserID)" + " \(accountID)"
        userDefaults.set(finalSuerID, forKey: "finalChatUserId")
        
        let firstName = userDetailsDict?.value(forKey: "firstName") as? String ?? ""
        let lastName = userDetailsDict?.value(forKey: "lastName") as? String ?? ""
        
        let fullName = firstName + " " + lastName

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        VC.modalPresentationStyle = .fullScreen
        if dataDict?.value(forKey: "statusOfBiddingRequest") as? String == "Completed"
        {
            VC.sendDisable=true
        }
        else
        {
            VC.sendDisable=false
        }
            
        VC.chatNameStr = fullName
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giveAwayListArr.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dataDict = giveAwayListArr.object(at: indexPath.row) as? NSDictionary
        let orderStatusStr = dataDict?.value(forKey: "statusOfBiddingRequest") as? String
        
        if(orderStatusStr == "Completed" || orderStatusStr == "Rejected"){
            return 800

        }else{
            return 827

        }
    }

    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

    }
    
    func callUpdateBiddingRequestAPI() {
        
                activity.startAnimating()
                self.view.isUserInteractionEnabled = false
                
                let URLString_loginIndividual = Constants.BaseUrl + GiveAwayDetailUpdateStatusUrl
                 
                            let params_IndividualLogin = [
                                "_id" : updateIdStr,
                                "statusOfBiddingRequest" : statusBiddingReq
                            ]
                        
                        
                            let postHeaders_IndividualLogin = ["":""]
                            
        serCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
                                    if(statusCode == 200 ){
                                        
                                        let alert = UIAlertController(title: "Success", message: "Details updated successfully", preferredStyle: UIAlertController.Style.alert)
                                        
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                                            self.statusBiddingReq=""
                                            self.getGiveAwayDetailsAPI()
                                                                       
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                        
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
//            }

            //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
//            var json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
//        } catch {
////            print(error.description)
//        }
    }
    
    func getGiveAwayDetailsAPI() {
        
        giveAwayListArr = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        print("Acc ID is \(accountID)")

        let URLString_loginIndividual = Constants.BaseUrl + GiveAwayDetailUrl + idStr
                                    
        serCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                           
                                        
                            if status == "SUCCESS" {
                                
                                let dataDict = result as? NSDictionary
                                
                                self.giveAwayListArr = dataDict?.value(forKey: "result")  as! NSMutableArray
                                self.chatFinalID=[String]()
                                if(self.giveAwayListArr.count > 0){
                                    
                                    for i in 0..<self.giveAwayListArr.count
                                    {
                                        if i>0
                                        {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                                let dataDict = self.giveAwayListArr.object(at: i) as? NSDictionary
                                                let accountDetailsDict = dataDict?.value(forKey: "accountDetails") as? NSDictionary
                                                
                                                let giveAwayID = dataDict?.value(forKey: "giveAwayId") as? String ?? "0"
                                                let chatUserID = accountDetailsDict?.value(forKey: "_id") as? String ?? "0"
                                                let finalSuerID = giveAwayID + " \(chatUserID)" + " \(self.accountID)"
                                                self.chatFinalID.append(finalSuerID)
                                                    let userDefaults = UserDefaults.standard
                                                    userDefaults.set(finalSuerID, forKey: "finalChatUserId")
                                                    self.identity = self.accountID

                                                    self.login()
                                                }
                                        }
                                        else
                                        {
                                        let dataDict = self.giveAwayListArr.object(at: i) as? NSDictionary
                                        let accountDetailsDict = dataDict?.value(forKey: "accountDetails") as? NSDictionary
                                        
                                        let giveAwayID = dataDict?.value(forKey: "giveAwayId") as? String ?? "0"
                                        let chatUserID = accountDetailsDict?.value(forKey: "_id") as? String ?? "0"
                                        let finalSuerID = giveAwayID + " \(chatUserID)" + " \(self.accountID)"
                                            self.chatFinalID.append(finalSuerID)
                                            let userDefaults = UserDefaults.standard
                                            userDefaults.set(finalSuerID, forKey: "finalChatUserId")
                                            self.identity = self.accountID

                                            self.login()
                                        }
                                      
                                        

                                    }
                                    self.emptyMsgBtn.removeFromSuperview()
                                    //self.giveAwayTblView.reloadData()
                                    
                                }else if(self.giveAwayListArr.count == 0){
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                    self.showEmptyMsgBtn()
                                }
                                
                            }else {
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
        
        if(self.giveAwayListArr.count == 0){
//            self.showEmptyMsgBtn()
        }
            
    }
    func chatMethod()
    {
        for i in 0..<chatFinalID.count
        {
            if i>0
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
        let userDefaults = UserDefaults.standard
                    userDefaults.set(self.chatFinalID[i], forKey: "finalChatUserId")
        self.identity = self.accountID

        self.login()
                }
            }
            else
            {
        let userDefaults = UserDefaults.standard
        userDefaults.set(chatFinalID[i], forKey: "finalChatUserId")
        self.identity = self.accountID

        self.login()
            }
        }
                                    self.emptyMsgBtn.removeFromSuperview()
                                    
    }
    var chatFinalID=[String]()
   var chatMainArray=NSMutableArray()
}
// MARK: QuickstartChatManagerDelegate
extension GiveAwayDetailViewController: QuickstartChatManagerDelegate {
    func sendAllOldMessages(messages: [TCHMessage]) {
        
        print(messages)
        chatMessagesArray=NSMutableArray()
        chatReversedMessageArray=NSMutableArray()
//        chatMainArray=NSMutableArray()
        for message in messages{
            
            let messageBody = message.body!
            let messageAuthor = message.author!
            let messageSId = message.sid!
            let messageDateCreated = message.dateCreated!
            
            let messageDataDict = NSMutableDictionary()
            messageDataDict.setValue(messageBody, forKey: "messageText")
            messageDataDict.setValue(messageAuthor, forKey: "author")
            messageDataDict.setValue(messageSId, forKey: "Sid")
            messageDataDict.setValue(messageDateCreated, forKey: "dateCreated")

            chatMessagesArray.add(messageDataDict)
        }
        
        
       chatReversedMessageArray =  NSMutableArray(array: chatMessagesArray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
        chatMainArray.add(NSMutableArray(array: chatReversedMessageArray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray)
        print(chatMessagesArray)
        
            if self.giveAwayListArr.count>0
            {
                if chatMainArray.count==self.giveAwayListArr.count
                {
                for j in 0..<self.giveAwayListArr.count
                {
                    let dataDict = self.giveAwayListArr.object(at: j) as? NSDictionary
                    let accountDetailsDict = dataDict?.value(forKey: "accountDetails") as? NSDictionary
                    
                    let giveAwayID = dataDict?.value(forKey: "giveAwayId") as? String ?? "0"
                    let chatUserID = accountDetailsDict?.value(forKey: "_id") as? String ?? "0"
                    let finalSuerID = giveAwayID + " \(chatUserID)" + " \(self.accountID)"
                    for k in 0..<chatMainArray.count
                    {
                        
                        if finalSuerID==chatFinalID[k]
                        {
                            dataDict?.setValue(chatMainArray[k], forKey: "chatObject")
                            self.giveAwayListArr[j]=dataDict
                            
                        }
                        
                        
                    }
                    
                    
                }
            
            
            print(self.giveAwayListArr)
               
        self.giveAwayTblView.reloadData()
                    activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
        }
        
    }
    
    func sendNewMessage(message:TCHMessage)  {
        
        let dataDict = self.giveAwayListArr.object(at: sendBtnID) as? NSDictionary ?? NSDictionary()
        chatMessagesArray=dataDict.value(forKey: "chatObject") as? NSMutableArray ?? NSMutableArray()
        let messageBody = message.body!
        let messageAuthor = message.author!
        let messageSId = message.sid!
        let messageDateCreated = message.dateCreated!
        
        let messageDataDict = NSMutableDictionary()
        messageDataDict.setValue(messageBody, forKey: "messageText")
        messageDataDict.setValue(messageAuthor, forKey: "author")
        messageDataDict.setValue(messageSId, forKey: "Sid")
        messageDataDict.setValue(messageDateCreated, forKey: "dateCreated")
        
        print("Before Chat is \(chatMessagesArray)")

        chatMessagesArray.add(messageDataDict)
        
//        chatReversedMessageArray =  NSMutableArray(array: chatMessagesArray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
        chatMainArray.add(NSMutableArray(array: chatReversedMessageArray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray)
        print(chatMessagesArray)
        
        dataDict.setValue(chatMessagesArray, forKey: "chatObject")
        self.giveAwayListArr.replaceObject(at: self.sendBtnID, with: dataDict)
        self.giveAwayTblView.reloadData()

        activity.stopAnimating()
        self.view.isUserInteractionEnabled = true
        print("Reverse Arr is \(chatReversedMessageArray)")
        
        print(messageDataDict)
    }
    
    func reloadMessages() {
        self.giveAwayTblView.reloadData()
    }

    // Scroll to bottom of table view for messages
    func receivedNewMessage(message:TCHMessage) {
        
        print(message)
            
            let messageBody = message.body!
            let messageAuthor = message.author!
            let messageSId = message.sid!
            let messageDateCreated = message.dateCreated!
            
            let messageDataDict = NSMutableDictionary()
            messageDataDict.setValue(messageBody, forKey: "messageText")
            messageDataDict.setValue(messageAuthor, forKey: "author")
            messageDataDict.setValue(messageSId, forKey: "Sid")
            messageDataDict.setValue(messageDateCreated, forKey: "dateCreated")

//            chatMessagesArray.add(messageDataDict)
//
//
//        chatReversedMessageArray =  NSMutableArray(array: chatMessagesArray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
//        print(chatMessagesArray)
//        self.giveAwayTblView.reloadData()

    }
}


