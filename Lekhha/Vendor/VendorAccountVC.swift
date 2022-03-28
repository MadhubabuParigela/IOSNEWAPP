//
//  VendorAccountVC.swift
//  Lekhha
//
//  Created by USM on 29/11/21.
//

import UIKit
import ObjectMapper
import GoogleMaps
import CoreLocation
import GooglePlaces
import DropDown

class VendorAccountVC: UIViewController , sentname , UITextFieldDelegate, GMSAutocompleteViewControllerDelegate,GMSMapViewDelegate{
    
    var chooseLocationBackView = UIView()
     var locationTF = UITextField()
    var sideMenuView = SideMenuView()
    
    var location: CLLocation?
    var geocoder = GMSGeocoder()
    var locationgeocoder: CLGeocoder?
    let destiMarker = GMSMarker()
    var locationManager:CLLocationManager!
    var latt = Double()
    var long = Double()
    var addressStr = String()
    var mapView = GMSMapView()

    @IBOutlet weak var gmsMapView: GMSMapView!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var mobileTextLabel: UILabel!
    @IBOutlet weak var mobileImage: UIImageView!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var maleImg: UIImageView!
    @IBOutlet weak var femaleImg: UIImageView!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var otherImg: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var addressOneView: UIView!
    @IBOutlet weak var addressOneTF: UITextField!
    @IBOutlet weak var addressTwoView: UIView!
    @IBOutlet weak var addressTwoTF: UITextField!
    @IBOutlet weak var streetView: UIView!
    @IBOutlet weak var streetTF: UITextField!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var pinCodeView: UIView!
    @IBOutlet weak var pinCodeTF: UITextField!
    @IBOutlet weak var landMarkView: UIView!
    @IBOutlet weak var landmarkTF: UITextField!
    @IBOutlet weak var accountNameView: UIView!
    @IBOutlet weak var accountNameTF: UITextField!
    @IBOutlet weak var accountUsersView: UIView!
    @IBOutlet weak var setVicinityTF: UITextField!
    @IBOutlet weak var soonExpireTF: UITextField!
    
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var dobBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var accountUsersBtn: UIButton!
    @IBOutlet weak var changePwBtn: UIButton!
    @IBOutlet weak var editMainBtn: UIButton!
    
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    
    
    var previousAccEmail = String()
    let dropDown = DropDown() //2
    
    var myAccServerCntrl = ServiceController()
    var selectedAccIDStr = String()
    var selectedEmailStr = String()
    var genderStr = ""
    
    var selectedPermissionsDict = NSDictionary()
    var selectAccEmailStr = String()
    var accountID = String()
    var vendorId = ""
    var stateId = ""
    var companySizeStr = ""
    var companyNameStr = ""
    
    
    var statesResultArr = [StatesResultVo]()
    var statesNamesArr = [String]()
    var statesIdsArr = [String]()
    
    var selectAccResulDatatArr = [SelectAccResultVC]()
    var getAccountConsumerDataArr = [GetAccountVendorDetailResultVo]()
    
    @IBOutlet weak var mapBackView: UIView!
    @IBOutlet weak var locEditBtn: UIButton!
    var accountEmailStr = ""
    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
    var picker : UIDatePicker = UIDatePicker()
    
    @IBAction func emailBtn(_ sender: UIButton) {
        
        selectAccountAPI()
    }
    @IBAction func dobBtnAction(_ sender: UIButton) {
        
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

        picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
//        let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
        picker.frame = CGRect(x:0.0, y:50, width:pickerDateView.frame.size.width, height:300)
        // you probably don't want to set background color as black
        // picker.backgroundColor = UIColor.blackColor()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }

        pickerDateView.addSubview(picker)
        
//        let dateStr = dateFormatter.string(from: eventDatePicker.date)
        
        
//        myProductArray.replaceObject(at:purchase_expiryProductPosLev, with: dict)
    }
    
    @IBAction func mobileDropBtnAction(_ sender: UIButton) {
    }
    @IBAction func stateBtnAction(_ sender: UIButton) {
        
        dropDown.dataSource = statesNamesArr //4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.stateTF.text = item
                self?.stateId = (self?.statesIdsArr[index])!
            }
    }
    
    @IBAction func maleBtnAction(_ sender: Any) {
        genderStr = "male"
        maleImg.image = #imageLiteral(resourceName: "radio_active")
        femaleImg.image = #imageLiteral(resourceName: "radioInactive")
        otherImg.image = #imageLiteral(resourceName: "radioInactive")
    }
    @IBAction func femaleBtnAction(_ sender: Any) {
        genderStr = "female"
        maleImg.image = #imageLiteral(resourceName: "radioInactive")
        femaleImg.image = #imageLiteral(resourceName: "radio_active")
        otherImg.image = #imageLiteral(resourceName: "radioInactive")
    }
    @IBAction func otherBtnAction(_ sender: Any) {
        genderStr = "other"
        maleImg.image = #imageLiteral(resourceName: "radioInactive")
        femaleImg.image = #imageLiteral(resourceName: "radioInactive")
        otherImg.image = #imageLiteral(resourceName: "radio_active")
        
    }
    @IBAction func accountUsersBtnAction(_ sender: UIButton) {
        
        dropDown.dataSource = ["1-10","10-50","50-100","100-500","Above 500"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
//                self?.accountUsersTF.text = item
            }
    }
    
    
    @IBAction func locEditBtnTap(_ sender: Any) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)

    }
    
    var addAccDetailsArray = NSMutableArray()
    var addAccIDArray = NSMutableArray()

    @IBAction func menuBtnTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
        
        toggleSideMenuViewWithAnimation()

    }
    
    @objc func doneBtnTap(_ sender: UIButton) {

        hiddenBtn.removeFromSuperview()
        pickerDateView.removeFromSuperview()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: picker.date)
        
        self.dobTF.text = selectedDate
        
//        self.loadAddProductUI()
        
    }
    @objc func dueDateChanged(sender:UIDatePicker){
        
//        print(purchase_ExpiryTagVal)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: picker.date)
        
        self.dobTF.text = selectedDate
            
//        myProductArray.replaceObject(at:purchase_expiryProductPosLev, with: dict)

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
    
    @IBOutlet weak var profileImgBtn: UIButton!
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var addressTF: UIButton!
    
    var firstNameStr = NSString()
    var lastNameStr = NSString()
    var mobileNumStr = NSString()
//    var addressStr = NSString()
    var profileBase64Img = NSString()
    
    func sendnamedfields(fieldname: String, idStr: String) {
        
        for i in 0..<selectAccResulDatatArr.count {

            let accDetailsDict = selectAccResulDatatArr[i].accDetails
//            let dataDict = accDetailsArr![0] as! NSDictionary

            let accIDStr = accDetailsDict?._id ?? ""
            
            if(accIDStr == idStr){
                selectedPermissionsDict = selectAccResulDatatArr[i].modulePermissions!
                
//                let emailAddressArray = selectAccResulDatatArr[i].accDetails!
//                let accDict = emailAddressArray[0] as! NSDictionary
                selectAccEmailStr = accDetailsDict?.emailAddress ?? ""
                selectedEmailStr = accDetailsDict?.emailAddress ?? ""
                emailTF.text = selectAccEmailStr
                print(selectAccEmailStr)

            }
        }
        
    
        
        if(accountEmailStr == selectedEmailStr){
            
            self.navigationController?.popViewController(animated: true)
            
        }else{
            
            let alertController = UIAlertController(title: "Success", message:"Are you sure you want to switch your account to \(fieldname)" , preferredStyle: .alert)
            //to change font of title and message.
            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: "Success", attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: "Are you sure you want to switch your account to \(fieldname)", attributes: messageFont)
            alertController.setValue(titleAttrString, forKey: "attributedTitle")
            alertController.setValue(messageAttrString, forKey: "attributedMessage")
            
            let alertAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
               
            })

           let alertAction1 = UIAlertAction(title: "Yes", style: .default, handler: { [self] (action) in
    //        self.addressTF.setTitle(fieldname, for: UIControl.State.normal)
            self.navigationController?.popViewController(animated: true)

            self.selectedAccIDStr = idStr
            self.switchAccPwdView()

           })
            
            self.dismiss(animated: true, completion: nil)

            alertController.addAction(alertAction)
            alertController.addAction(alertAction1)

            present(alertController, animated: true, completion: nil)

        }
        
        
        
//        self.dismiss(animated: true, completion: nil)
//        showAlertMsg(message: "Are you sure you want to switch your account\(fieldname)")
    
    }
    
   var updatePwdView: UIView!
    
    let currentPwdTF = UITextField()
    let newPwdTF = UITextField()
    let confirmPwdTF = UITextField()
    
    @IBAction func changePwdBtnTap(_ sender: Any) {
        changePwdView()
        
    }
    
    @IBAction func editBtnTap(_ sender: UIButton) {
        
        if(sender.currentTitle == "EDIT"){
            
            firstNameTF.isUserInteractionEnabled = true
            lastNameTF.isUserInteractionEnabled = true
            addressTF.isUserInteractionEnabled = true
            profileImgBtn.isUserInteractionEnabled = true
            
            self.addressOneTF.isUserInteractionEnabled = true
            self.addressTwoTF.isUserInteractionEnabled = true
            self.streetTF.isUserInteractionEnabled = true
            self.cityTF.isUserInteractionEnabled = true
            self.stateTF.isUserInteractionEnabled = true
            self.pinCodeTF.isUserInteractionEnabled = true
            self.landmarkTF.isUserInteractionEnabled = true
            self.accountNameTF.isUserInteractionEnabled = true
            self.soonExpireTF.isUserInteractionEnabled = true
            self.setVicinityTF.isUserInteractionEnabled = true
            self.phoneNumTF.isUserInteractionEnabled = true
            self.firstNameTF.isUserInteractionEnabled = true
            self.lastNameTF.isUserInteractionEnabled = true
            self.dobBtn.isUserInteractionEnabled = true
            self.emailBtn.isUserInteractionEnabled = true
            self.emailTF.isUserInteractionEnabled = true
//            self.accountUsersBtn.isUserInteractionEnabled = true
            self.stateBtn.isUserInteractionEnabled = true

            firstNameTF.backgroundColor = UIColor.clear
            lastNameTF.backgroundColor = UIColor.clear
            addressTF.backgroundColor = UIColor.clear
            
            locEditBtn.isHidden = false
            
//          firstNameTF.becomeFirstResponder()
            sender.setTitle("UPDATE", for: .normal)
            
        }else{
            
            sender.setTitle("EDIT", for: .normal)
            self.addressOneTF.isUserInteractionEnabled = false
            self.addressTwoTF.isUserInteractionEnabled = false
            self.streetTF.isUserInteractionEnabled = false
            self.cityTF.isUserInteractionEnabled = false
            self.stateTF.isUserInteractionEnabled = false
            self.pinCodeTF.isUserInteractionEnabled = false
            self.landmarkTF.isUserInteractionEnabled = false
            self.accountNameTF.isUserInteractionEnabled = false
            self.soonExpireTF.isUserInteractionEnabled = false
            self.setVicinityTF.isUserInteractionEnabled = false
            self.phoneNumTF.isUserInteractionEnabled = false
            self.firstNameTF.isUserInteractionEnabled = false
            self.lastNameTF.isUserInteractionEnabled = false
            
            self.dobBtn.isUserInteractionEnabled = false
            self.emailBtn.isUserInteractionEnabled = false
            self.emailTF.isUserInteractionEnabled = false
//            self.accountUsersBtn.isUserInteractionEnabled = false
            self.stateBtn.isUserInteractionEnabled = false
            
            if(firstNameTF.text == ""){
                self.showAlertWith(title: "Alert", message: "Enter your first name")
                
            }else if(lastNameTF.text == ""){
                self.showAlertWith(title: "Alert", message: "Enter your last name")
                
            }else if(phoneNumTF.text == ""){
                self.showAlertWith(title: "Alert", message: "Enter your last phone number")
                
            }
//            else if(addressTF.text == ""){
//                self.showAlertWith(title: "Alert", message: "Enter your address")
//
//            }
            self.updateMyAccDetailsAPI()
        }
    }
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        logOutShowAlertWith(title: "Alert", message: "Are you sure to logout ?")

    }
    
    func logout()  {
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(false, forKey: "isLoggedIn")
        userDefaults.synchronize()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
        VC.modalPresentationStyle = .fullScreen
       // self.viewCntrlObj.present(VC, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
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
                alertController.dismiss(animated: true, completion: nil)
            })
        


    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
//           alertController.addAction(alertAction1)

        self.present(alertController, animated: true, completion: nil)
        
        }
    
    func logOutShowAlertWith(title:String,message:String)
        {
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
            })
        
        let alertAction1 = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.logout()
           
        })

    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
           alertController.addAction(alertAction1)

        self.present(alertController, animated: true, completion: nil)
        
        }
    
    func parseAccDetailsData() {
        
        print(selectAccResulDatatArr)
        
        addAccDetailsArray = NSMutableArray()
        addAccIDArray = NSMutableArray()

        for i in 0..<selectAccResulDatatArr.count {

            let accDetailsDict = selectAccResulDatatArr[i].accDetails
//            let dataDict = accDetailsArr![0] as! NSDictionary
            
            addAccDetailsArray.add(accDetailsDict?.emailAddress ?? "")
            addAccIDArray.add(accDetailsDict?._id ?? "")

        }
        
        print(addAccDetailsArray)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select"
        viewTobeLoad.fields = self.addAccDetailsArray as! [String]
        viewTobeLoad.categoryIDs = self.addAccIDArray as! [String]

//        self.navigationController?.present(viewTobeLoad, animated: true, completion: nil)
         viewTobeLoad.modalPresentationStyle = .fullScreen
//        self.present(viewTobeLoad, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

//        self.eventTypeFiled.optionArray = addAccDetailsArray as! [String]
//        self.eventTypeFiled.optionIds = addAccIDArray as! [Int]
        
    }
    
    @IBAction func aboutUsBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
              let VC = storyBoard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsViewController
              VC.modalPresentationStyle = .fullScreen
//              self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func privacyPolicyBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
              let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
              VC.modalPresentationStyle = .fullScreen
        VC.headerStr = "Privacy Policy"
        VC.urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/privacypolicy"
//              self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        
        profileBase64Img = ""
        
        phoneNumTF.isUserInteractionEnabled = false
        addressTF.isUserInteractionEnabled = false
        
//        NotificationCenter.default.addObserver(
//                   self,
//                   selector: #selector(keyboardWillShow),
//                   name: UIResponder.keyboardWillShowNotification,
//                   object: nil
//               )
//
//        NotificationCenter.default.addObserver(
//                   self,
//                   selector: #selector(keyboardWillHide),
//                   name: UIResponder.keyboardWillHideNotification,
//                   object: nil
//               )

        animatingView()
//        getMyAccDetails()
        
        getConsumerAccountDetailsAPI()
        getStatesAPI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
      self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }
    
    func switchAccPwdView(){
        
        hiddenBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)
        
        updatePwdView = UIView()
        updatePwdView.frame = CGRect(x: 20, y: self.view.frame.size.height/2-(120), width: self.view.frame.size.width - (40), height: 240)
        updatePwdView.backgroundColor = UIColor.white
        updatePwdView.layer.cornerRadius = 10
        updatePwdView.layer.masksToBounds = true
        self.view.addSubview(updatePwdView)
        
        //Change Pwd Lbl
        
        let changePwdLbl = UILabel()
        changePwdLbl.frame = CGRect(x: 10, y: 5, width: updatePwdView.frame.size.width - (60), height: 40)
        changePwdLbl.text = "      Enter Password"
        changePwdLbl.textAlignment = NSTextAlignment.center
        changePwdLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        changePwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(changePwdLbl)
        
        //Cancel Btn
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: updatePwdView.frame.size.width - 40, y: 5, width: 40, height: 40)
        cancelBtn.setImage(UIImage.init(named: "cancel"), for: UIControl.State.normal)
        cancelBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        updatePwdView.addSubview(cancelBtn)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        
        //Seperator Line Lbl
        
        let seperatorLine = UILabel()
        seperatorLine.frame = CGRect(x: 0, y: changePwdLbl.frame.origin.y+changePwdLbl.frame.size.height, width: updatePwdView.frame.size.width , height: 1)
        seperatorLine.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
        updatePwdView.addSubview(seperatorLine)
        
        //Current Pwd Lbl

        let currentPwdLbl = UILabel()
        currentPwdLbl.frame = CGRect(x: 10, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: updatePwdView.frame.size.width - (20), height: 20)
        currentPwdLbl.text = " Password"
        currentPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        currentPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(currentPwdLbl)

        //Current Pwd TF

        currentPwdTF.frame = CGRect(x: 10, y: currentPwdLbl.frame.origin.y+currentPwdLbl.frame.size.height+5, width: updatePwdView.frame.size.width - (20), height: 45)
        currentPwdTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        currentPwdTF.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(currentPwdTF)
        currentPwdTF.isSecureTextEntry = true

        currentPwdTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        currentPwdTF.layer.cornerRadius = 3
        currentPwdTF.clipsToBounds = true

        let currentPwdPaddingView = UIView()
        currentPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: currentPwdTF.frame.size.height)
        currentPwdTF.leftView = currentPwdPaddingView
        currentPwdTF.leftViewMode = UITextField.ViewMode.always
        
        let updateBtn = UIButton()
        updateBtn.frame = CGRect(x:updatePwdView.frame.size.width/2 - (85), y: currentPwdTF.frame.origin.y+currentPwdTF.frame.size.height+40, width: 170, height: 40)
        updateBtn.setTitle("Submit Password", for: UIControl.State.normal)
        updateBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        updateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        updateBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
        updateBtn.addTarget(self, action: #selector(switchPwdSubmitBtnTapped), for: .touchUpInside)

        updateBtn.layer.cornerRadius = 5
        updatePwdView.addSubview(updateBtn)

    }
    
    func changePwdView()  {
        
//        hiddenBtn = UIButton()
        hiddenBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)
        
        updatePwdView = UIView()
        updatePwdView.frame = CGRect(x: 20, y: self.view.frame.size.height/2-(225), width: self.view.frame.size.width - (40), height: 450)
        updatePwdView.backgroundColor = UIColor.white
        updatePwdView.layer.cornerRadius = 10
        updatePwdView.layer.masksToBounds = true
        self.view.addSubview(updatePwdView)
        
        //Change Pwd Lbl
        
        let changePwdLbl = UILabel()
        changePwdLbl.frame = CGRect(x: 10, y: 5, width: updatePwdView.frame.size.width - (60), height: 40)
        changePwdLbl.text = "      Change Password"
        changePwdLbl.textAlignment = NSTextAlignment.center
        changePwdLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        changePwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(changePwdLbl)
        
        //Cancel Btn
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: updatePwdView.frame.size.width - 40, y: 5, width: 40, height: 40)
        cancelBtn.setImage(UIImage.init(named: "cancel"), for: UIControl.State.normal)
        cancelBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        updatePwdView.addSubview(cancelBtn)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        
        //Seperator Line Lbl
        
        let seperatorLine = UILabel()
        seperatorLine.frame = CGRect(x: 0, y: changePwdLbl.frame.origin.y+changePwdLbl.frame.size.height, width: updatePwdView.frame.size.width , height: 1)
        seperatorLine.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
        updatePwdView.addSubview(seperatorLine)
        
        //Current Pwd Lbl

        let currentPwdLbl = UILabel()
        currentPwdLbl.frame = CGRect(x: 10, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: updatePwdView.frame.size.width - (20), height: 20)
        currentPwdLbl.text = "Current Password"
        currentPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        currentPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(currentPwdLbl)

        //Current Pwd TF

        currentPwdTF.frame = CGRect(x: 10, y: currentPwdLbl.frame.origin.y+currentPwdLbl.frame.size.height+5, width: updatePwdView.frame.size.width - (20), height: 45)
        currentPwdTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        currentPwdTF.textColor = hexStringToUIColor(hex: "232c51")
        currentPwdTF.isSecureTextEntry = true
        updatePwdView.addSubview(currentPwdTF)

        currentPwdTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        currentPwdTF.layer.cornerRadius = 3
        currentPwdTF.clipsToBounds = true

        let currentPwdPaddingView = UIView()
        currentPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: currentPwdTF.frame.size.height)
        currentPwdTF.leftView = currentPwdPaddingView
        currentPwdTF.leftViewMode = UITextField.ViewMode.always
        
        //New Pwd Lbl

        let newPwdLbl = UILabel()
        newPwdLbl.frame = CGRect(x: 10, y: currentPwdTF.frame.origin.y+currentPwdTF.frame.size.height+15, width: updatePwdView.frame.size.width - (20), height: 20)
        newPwdLbl.text = "New Password"
        newPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        newPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(newPwdLbl)

        //New Pwd TF

        newPwdTF.frame = CGRect(x: 10, y: newPwdLbl.frame.origin.y+newPwdLbl.frame.size.height+5, width: updatePwdView.frame.size.width - (20), height: 45)
        newPwdTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        newPwdTF.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(newPwdTF)

        newPwdTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        newPwdTF.layer.cornerRadius = 3
        newPwdTF.clipsToBounds = true
        newPwdTF.isSecureTextEntry = true

        let newPwdPaddingView = UIView()
        newPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: newPwdTF.frame.size.height)
        newPwdTF.leftView = newPwdPaddingView
        newPwdTF.leftViewMode = UITextField.ViewMode.always

        //Confirm Pwd Lbl

        let confirmPwdLbl = UILabel()
        confirmPwdLbl.frame = CGRect(x: 10, y: newPwdTF.frame.origin.y+newPwdTF.frame.size.height+15, width: updatePwdView.frame.size.width - (20), height: 20)
        confirmPwdLbl.text = "Confirm Password"
        confirmPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        confirmPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(confirmPwdLbl)

        //New Pwd TF

        confirmPwdTF.frame = CGRect(x: 10, y: confirmPwdLbl.frame.origin.y+confirmPwdLbl.frame.size.height+5, width: updatePwdView.frame.size.width - (20), height: 45)
        confirmPwdTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        confirmPwdTF.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(confirmPwdTF)
        confirmPwdTF.isSecureTextEntry = true

        confirmPwdTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        confirmPwdTF.layer.cornerRadius = 3
        confirmPwdTF.clipsToBounds = true

        let confirmPwdPaddingView = UIView()
        confirmPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: confirmPwdTF.frame.size.height)
        confirmPwdTF.leftView = confirmPwdPaddingView
        confirmPwdTF.leftViewMode = UITextField.ViewMode.always
        
        let updateBtn = UIButton()
        updateBtn.frame = CGRect(x:updatePwdView.frame.size.width/2 - (85), y: confirmPwdTF.frame.origin.y+confirmPwdTF.frame.size.height+40, width: 170, height: 40)
        updateBtn.setTitle("Update Password", for: UIControl.State.normal)
        updateBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        updateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        updateBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
        updateBtn.addTarget(self, action: #selector(updateBtnTap), for: .touchUpInside)

        updatePwdView.addSubview(updateBtn)

        updateBtn.layer.cornerRadius = 3
        updateBtn.layer.masksToBounds = true
        
    }
    

    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let locationgeocoder = CLGeocoder()
        location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        locationgeocoder.reverseGeocodeLocation(location!, completionHandler: { placemarks, error in
            DispatchQueue.main.async {
                let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,longitude: place.coordinate.longitude,zoom: 15)
//                self.locationMapView.camera = camera
            }
            let placemark = placemarks?[0]
            if let aPlacemark = placemark {
                print("placemark: \(aPlacemark)")
            }
//            self.isSearchLocation = true
            print("zipcode: \(placemark?.postalCode ?? "")")
            UserDefaults.standard.set(placemark?.postalCode ?? "", forKey: "pinCode")
            
            let address = String(format : "%@,%@,%@,%@,%@,%@",placemark?.subThoroughfare ?? "",placemark?.thoroughfare ?? "",placemark?.subLocality ?? "",placemark?.locality ?? "" ,placemark?.subAdministrativeArea ?? "",placemark?.country ?? "",placemark?.postalCode ?? "")
            
            self.addressStr = address
            
            self.latt = place.coordinate.latitude
            self.long = place.coordinate.longitude
            
            print("address: \(address)")
            self.addressOneTF.text = placemark?.thoroughfare ?? ""
            self.addressTwoTF.text = placemark?.subThoroughfare ?? ""
            self.streetTF.text = placemark?.subLocality ?? ""
            self.cityTF.text = placemark?.locality ?? ""
            self.landmarkTF.text = placemark?.subAdministrativeArea ?? ""
            self.pinCodeTF.text = placemark?.postalCode ?? ""
//            self.locationTF.text = address
//            self.addressLabel.text = place.formattedAddress
                                
           self.destiMarker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    
            let london = GMSMarker(position: self.destiMarker.position)
            //        london.isFlat = true
            london.isDraggable = true
//            london.map = self.locationMapView
            london.title = address
            london.icon = UIImage(named: "ic_location")
//            london.map = self.locationMapView
            
            UserDefaults.standard.set(placemark?.locality ?? "", forKey: "pickedCity")
            UserDefaults.standard.synchronize()
            
            self.loadMapView()
            
//            UserDefaults.standard.set(placemark?.subThoroughfare ?? "", forKey: "houseno")
            self.dismiss(animated: true, completion: nil)
            
        })

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        dismiss(animated: true, completion: nil)

    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)

    }


    
    @IBAction func editBtnTapped(_ sender: Any) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)

    }
    
    
    @objc func cancelBtnTap(sender: UIButton!){
        
        hiddenBtn.removeFromSuperview()
        updatePwdView.removeFromSuperview()

    }
    
    @objc func switchPwdSubmitBtnTapped(sender: UIButton!){
        
        if(currentPwdTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter current password")

        }

        verifySwitchAccPasswordAPICall()
    }
    
    @objc func updateBtnTap(sender: UIButton!) {
        
        let strLength = newPwdTF.text?.count ?? 0

        
        if(currentPwdTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter current password")

        }
        else if(newPwdTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter new password")

        }
        else if(strLength < 6){
            self.showAlertWith(title: "Alert", message: "Password should not be less than 6 chartacters")
            return

        }
        else if(strLength > 12){
            self.showAlertWith(title: "Alert", message: "Password should not be more than 12 chartacters")
            return

        }
        else if(confirmPwdTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter confirm password")

        }
        else if(newPwdTF.text != confirmPwdTF.text)
        {
            self.showAlertWith(title: "Alert", message: "Password and confirm password do not match")
            return
        }

        updatePasswordAPICall()
        
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
    
    @IBAction func emailBtnTapped(_ sender: UIButton) {
        selectAccountAPI()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == firstNameTF || textField == lastNameTF {
            
                    let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
                    let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                    let typedCharacterSet = CharacterSet(charactersIn: string)
                    let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
                    return alphabet

          } else if(textField == phoneNumTF  ) {
            return true
         
          }else{
            return false
            
          }
      }
    
    func upateMyAccDetails()  {

        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String
        print(userID)
        
//        userDefaults.set(fieldname, forKey: "accountEmail")
        
        let emailStr = userDefaults.value(forKey: "accountEmail") as! String
        accountEmailStr = userDefaults.value(forKey: "accountEmail") as! String
            
//      let URLString_loginIndividual = MyAccImgUrl  + userID
        
//        editBtn.isHidden = true

        let imageStr = VendorMyAccImgUrl + userID

                if !imageStr.isEmpty {

                    let imgUrl:String = imageStr

                    let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")

                    let imggg = VendorMyAccImgUrl + userID

                    let url = URL.init(string: imggg)
                    
//                    editBtn.isHidden = true

                    profileImgView.sd_setImage(with: url , placeholderImage: UIImage(named: "no_image"))
                    
//                    profileImgView.sd_setImage(with: url, placeholderImage:UIImage(named: "add photo"), options: .refreshCached)
                    
                    profileImgView.contentMode = UIView.ContentMode.scaleAspectFill

                }
                else {
                    
//                    editBtn.isHidden = false
                    profileImgView.image = UIImage(named: "no_image")
                    
                }
        
        
        let camera = GMSCameraPosition.camera(withLatitude: self.latt, longitude: self.long, zoom: 12)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: mapBackView.frame.size.width, height: mapBackView.frame.size.height), camera: camera)
        mapBackView.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.latt, longitude: self.long)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
        marker.map = mapView

        
//        firstNameTF.text = firstNameStr as String
//        lastNameTF.text = lastNameStr as String
//        phoneNumTF.text = mobileNumStr as String
//        addressTF.setTitle(emailStr as String, for: .normal)
        
    }
    
    func showAlertMsg(message:String)  {
        
                let alertController = UIAlertController(title: "Success", message:message , preferredStyle: .alert)
                //to change font of title and message.
                let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
                let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Success", attributes: titleFont)
                let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
                alertController.setValue(titleAttrString, forKey: "attributedTitle")
                alertController.setValue(messageAttrString, forKey: "attributedMessage")
                
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
                    VC.modalPresentationStyle = .fullScreen
//                    self.present(VC, animated: true, completion: nil)
                    self.navigationController?.pushViewController(VC, animated: true)

                })
        
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)

    }
    
    func getMyAccDetails() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        
//        userID = "5f6d80e4950eaf1c4bfea973"
            
                    let URLString_loginIndividual = Constants.BaseUrl + VendorMyAccountUrl + accountID
                                
//                                    let postHeaders_IndividualLogin = ["":""]
                                    
                          myAccServerCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                if respVo.result?.count ?? 0>0
                                {
                                let userId = respVo.result![0]._id
                                self.firstNameStr = respVo.result![0].firstName! as NSString
                                self.lastNameStr = respVo.result![0].lastName! as NSString
                                self.mobileNumStr = respVo.result![0].mobileNumber! as NSString
                                self.addressStr = respVo.result![0].firstName!
                                
                                let locDict = respVo.result![0].locDict
                                let locArray = locDict?.value(forKey: "coordinates") as? NSArray
                                
                                self.latt = locArray?.object(at: 0) as? Double ?? 0
                                self.long = locArray?.object(at: 1) as? Double ?? 0

//                                let locDict =

//                                self.getMyAccProfilePic()
                                print(userId)
                                
                                self.upateMyAccDetails()
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
    
    func loadMapView() {
        
        DispatchQueue.main.async {
            
            self.chooseLocationBackView.removeFromSuperview()
            
            self.chooseLocationBackView = UIView()
            self.chooseLocationBackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.chooseLocationBackView)
            
            let camera = GMSCameraPosition.camera(withLatitude: self.latt, longitude: self.long, zoom: 6)
            self.mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.chooseLocationBackView.frame.size.height - 140), camera: camera)
            self.chooseLocationBackView.addSubview(self.mapView)
            
//            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//            gestureRecognizer.delegate = self
//            self.mapView.addGestureRecognizer(gestureRecognizer)
            
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: self.latt, longitude: self.long)
            marker.map = self.mapView
            
            //Location TF
            
            let locationTxtView = UIView()
            locationTxtView.frame = CGRect(x: 0, y: self.chooseLocationBackView.frame.size.height - 140, width: self.chooseLocationBackView.frame.size.width, height: 140)
            locationTxtView.backgroundColor = .white
            self.chooseLocationBackView.addSubview(locationTxtView)

            self.locationTF = UITextField()
            self.locationTF.frame = CGRect(x: 15, y: 15, width: self.view.frame.size.width - (30), height: 45)
            self.locationTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            self.locationTF.textColor = hexStringToUIColor(hex: "000000")
            locationTxtView.addSubview(self.locationTF)
            
            self.locationTF.delegate = self
            self.locationTF.text = self.addressStr

            self.locationTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
            self.locationTF.layer.cornerRadius = 3
            self.locationTF.clipsToBounds = true
            
            let productPaddingView = UIView()
            productPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: self.locationTF.frame.size.height)
            self.locationTF.leftView = productPaddingView
            self.locationTF.leftViewMode = UITextField.ViewMode.always
            
            self.locationTF.text = self.addressStr
            
            let OKBtn = UIButton()
            OKBtn.frame = CGRect(x:self.chooseLocationBackView.frame.size.width/2-(50), y: self.locationTF.frame.size.height+self.locationTF.frame.origin.y+15, width: 100, height: 40)
//            OKBtn.backgroundColor = UIColor.orange
            OKBtn.addTarget(self, action: #selector(self.locationSubmitBtnTap), for: .touchUpInside)
            OKBtn.setTitle("Submit", for: .normal)
            OKBtn.setTitleColor(.white, for: .normal)
            OKBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            OKBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
            OKBtn.layer.cornerRadius = 5
            locationTxtView.addSubview(OKBtn)

        }
    }
    
    @objc func locationSubmitBtnTap(sender: UIButton!){
        
//        chooseLocationTF.text = addressStr
        
        self.chooseLocationBackView.removeFromSuperview()
        self.locationTF.removeFromSuperview()

    }
    
    func selectAccountAPI() {
        
        selectAccResulDatatArr = [SelectAccResultVC]()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        print(userID)
            
                    let URLString_loginIndividual = Constants.BaseUrl + GetAllAccountsUrl + userID
                                
//                                    let postHeaders_IndividualLogin = ["":""]
                                    
                    myAccServerCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:SelectAccRespoVC = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                                    _ = respVo.result
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
//                                _ = respVo.result?[0].userId
//                                let selectAccResultArr = respVo.result
//                                let dict = selectAccResultArr?[0] as! NSDictionary
                                
                                self.selectAccResulDatatArr = [SelectAccResultVC]()
                                self.selectAccResulDatatArr = respVo.result!
                                
                                print(self.selectAccResulDatatArr)
                                self.parseAccDetailsData()

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
    
    func getMyAccProfilePic() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String
        print(userID)
            
        let URLString_loginIndividual = MyAccImgUrl  + userID
                                    
                            myAccServerCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:OTPRespoVO = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {

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
    
    func getConsumerAccountDetailsAPI() {
        
        getAccountConsumerDataArr = [GetAccountVendorDetailResultVo]()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        print(userID)
        
        accountID = (defaults.string(forKey: "accountId") ?? "")
            
                    let URLString_loginIndividual = Constants.BaseUrl + VendorMyAccountUrl + accountID
//                        + "/" + userID
                                
//                                    let postHeaders_IndividualLogin = ["":""]
                                    
                    myAccServerCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:GetAccountVendorDetailResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                                    _ = respVo.result
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                self.getAccountConsumerDataArr = respVo.result!
                                
                                self.getConsumerAccountDetails()
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
    
    func getStatesAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + satesUrl
                                    
        myAccServerCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:StatesRespVo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.STATUS_MSG
                            let statusCode = respVo.STATUS_CODE
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                if statusCode == 200 {
                                    
                                    self.statesResultArr = respVo.result!
                                    
                                    for obj in self.statesResultArr {
                                        let nameStr = obj.stateName
                                        self.statesNamesArr.append(nameStr ?? "")
                                        let idStr = obj._id
                                        self.statesIdsArr.append(idStr ?? "")
                                    }
//                                    self.stateTF.optionArray = self.statesNamesArr
//                                    self.stateTF.optionIds = self.statesIdsArr
                                    
                                }
                                else {
                                    
                                    
                                }
                                
                            }else {
                                
//                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
        
    }
    
    func getConsumerAccountDetails(){
        
        self.addressOneTF.isUserInteractionEnabled = false
        self.addressTwoTF.isUserInteractionEnabled = false
        self.streetTF.isUserInteractionEnabled = false
        self.cityTF.isUserInteractionEnabled = false
        self.stateTF.isUserInteractionEnabled = false
        self.pinCodeTF.isUserInteractionEnabled = false
        self.landmarkTF.isUserInteractionEnabled = false
        self.accountNameTF.isUserInteractionEnabled = false
        self.soonExpireTF.isUserInteractionEnabled = false
        self.setVicinityTF.isUserInteractionEnabled = false
        self.phoneNumTF.isUserInteractionEnabled = false
        self.firstNameTF.isUserInteractionEnabled = false
        self.lastNameTF.isUserInteractionEnabled = false
        
        self.dobBtn.isUserInteractionEnabled = false
        self.emailBtn.isUserInteractionEnabled = false
        self.emailTF.isUserInteractionEnabled = false
//        self.accountUsersBtn.isUserInteractionEnabled = false
        self.stateBtn.isUserInteractionEnabled = false
        
        var i = 0
        for obj in getAccountConsumerDataArr {
            
            self.vendorId = obj._id ?? ""
            self.companySizeStr = obj.accountDetails?.companySize ?? ""
            self.companyNameStr = obj.accountDetails?.companyName ?? ""
            self.accountNameTF.text = obj.accountDetails?.companyName ?? ""
            
            self.addressOneTF.text = obj.accountDetails?.address01 ?? ""
            self.addressTwoTF.text = obj.accountDetails?.address02 ?? ""
            self.streetTF.text = obj.accountDetails?.street ?? ""
            self.cityTF.text = obj.accountDetails?.city ?? ""
            self.stateId = obj.accountDetails?.state ?? ""
            
            for statesObj in statesIdsArr {
                
                let stateIStr = obj.accountDetails?.state ?? ""
                
                if statesObj == stateIStr {
                    
                    self.stateTF.text = statesNamesArr[i]
                    
                }
                i += 1
            }
            
            self.pinCodeTF.text = obj.accountDetails?.pincode ?? ""
            self.landmarkTF.text = obj.accountDetails?.landMark ?? ""
            self.setVicinityTF.text = "\(obj.setVicinity ?? 0)"
            self.soonExpireTF.text = "\(obj.soonToexpiryLeadTime ?? 0)"
            self.phoneNumTF.text = obj.userDetails?.mobileNumber ?? ""
            self.emailTF.text = obj.accountDetails?.emailAddress ?? ""
            self.firstNameTF.text = obj.userDetails?.firstName ?? ""
            self.lastNameTF.text = obj.userDetails?.lastName ?? ""
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let selectedDate = dateFormatter.string(from: obj.userDetails?.dateOfBirth!)
            self.dobTF.text = obj.userDetails?.dateOfBirth ?? ""
                        
            if let maleStr = obj.userDetails?.gender{
                if maleStr == "male" {
                    genderStr = "male"
                    maleImg.image = #imageLiteral(resourceName: "radio_active")
                    femaleImg.image = #imageLiteral(resourceName: "radioInactive")
                    otherImg.image = #imageLiteral(resourceName: "radioInactive")
                }
                else if maleStr == "female" {
                    
                    genderStr = "female"
                    femaleImg.image = #imageLiteral(resourceName: "radio_active")
                    maleImg.image = #imageLiteral(resourceName: "radioInactive")
                    otherImg.image = #imageLiteral(resourceName: "radioInactive")
                }
                else {
                    genderStr = "other"
                    otherImg.image = #imageLiteral(resourceName: "radio_active")
                    maleImg.image = #imageLiteral(resourceName: "radioInactive")
                    femaleImg.image = #imageLiteral(resourceName: "radioInactive")
                }
            }
            else {
                genderStr = ""
                otherImg.image = #imageLiteral(resourceName: "radioInactive")
                maleImg.image = #imageLiteral(resourceName: "radioInactive")
                femaleImg.image = #imageLiteral(resourceName: "radioInactive")
            }
        }
        upateMyAccDetails()
    }
    // Alert controller
//    func showAlertWith(title:String,message:String)
//        {
//            let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
//            //to change font of title and message.
//            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
//            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
//
//            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
//            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
//            alertController.setValue(titleAttrString, forKey: "attributedTitle")
//            alertController.setValue(messageAttrString, forKey: "attributedMessage")
//
//            let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//
//            })
//    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
//    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
//            alertController.addAction(alertAction)
//            present(alertController, animated: true, completion: nil)
//        }


    func updateMyAccDetailsAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        
        let accountId = (defaults.string(forKey: "accountId") ?? "") as String
        
//        userID = "5f6d80e4950eaf1c4bfea973"
        
        let setVicinityStr = setVicinityTF.text ?? ""
        let setVicinityValue = Int(setVicinityStr)
        let soonToexpiryLeadTimeStr = soonExpireTF.text ?? ""
        let soonToexpiryLeadTimeValue = Int(soonToexpiryLeadTimeStr)
        
                let URLString_loginIndividual = Constants.BaseUrl + "endUsers/vendorUser_byaccountid_update"
        
                    var params_IndividualLogin = [
                        "userId":userID,
                        "accountId":accountId,
                        "firstName":firstNameTF.text ?? "",
                        "lastName":lastNameTF.text ?? "",
                        "profilePhoto": profileBase64Img,
                        "lattitude":latt,
                        "longitude":long,
                        "gender":genderStr,
                        "dateOfBirth":dobTF.text ?? "",
                        "address01": addressOneTF.text ?? "",
                        "address02":addressTwoTF.text ?? "",
                        "street":streetTF.text ?? "",
                        "city":cityTF.text ?? "",
                        "state":stateId,
                        "pinCode":pinCodeTF.text ?? "",
                        "landMark":landmarkTF.text ?? "",
                        "setVicinity":setVicinityValue!,
                        "soonToexpiryLeadTime":soonToexpiryLeadTimeValue!,
                        "companyName": self.companyNameStr,
                        "companySize":self.companySizeStr
                        ] as [String : Any]
        
        if(profileBase64Img == ""){
            
            params_IndividualLogin = [
                "userId":userID,
                "accountId":accountId,
                "firstName":firstNameTF.text ?? "",
                "lastName":lastNameTF.text ?? "",
                "lattitude":latt,
                "longitude":long,
                "gender": genderStr,
                "dateOfBirth":dobTF.text ?? "",
                "address01": addressOneTF.text ?? "",
                "address02":addressTwoTF.text ?? "",
                "street":streetTF.text ?? "",
                "city":cityTF.text ?? "",
                "state":stateId,
                "pinCode":pinCodeTF.text ?? "",
                "landMark":landmarkTF.text ?? "",
                "setVicinity": setVicinityValue!,
                "soonToexpiryLeadTime": soonToexpiryLeadTimeValue!,
                "companyName": self.companyNameStr,
                "companySize": self.companySizeStr
                ] as [String : Any]
        }
                
//                    print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
                    myAccServerCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
//                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true

                        if status == "SUCCESS" {
                            self.showAlertWith(title: "Success", message: "Profile details updated successfully")
                            
                            let userDefaults = UserDefaults.standard
                            
                            let firstName = self.firstNameTF.text ?? ""
                            let lastName = self.lastNameTF.text ?? ""
                            
                            let fullName = firstName + " " + lastName
                            userDefaults.set(fullName, forKey: "fullName")

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
    
    func verifySwitchAccPasswordAPICall() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String

//http://35.154.239.192:4500/endusers/changepassword
        
                let URLString_loginIndividual = Constants.BaseUrl + CheckSwitchAccPwdUrl
        
                    let params_IndividualLogin = [
                        "userId" : userID,
                        "passWord":currentPwdTF.text ?? "",
                    ]
                
//                    print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
                    myAccServerCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        if status == "SUCCESS" {
                            
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(self.selectedAccIDStr, forKey: "accountId")
                            userDefaults.set(self.selectedEmailStr, forKey: "accountEmail")
                            userDefaults.setValue(self.selectedPermissionsDict, forKey: "modulePermissions")
                            
                            userDefaults.set(self.selectAccEmailStr, forKey: "emailAddress")
                            userDefaults.synchronize()
                            
                            self.showAlertMsg(message: "Switched account successfully")

                        }
                        else {
                            self.showAlertWith(title: "Alert", message: messageResp ?? "")

                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                        }
                        
                    }) { (error) in
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        print("Something Went To Wrong...PLrease Try Again Later")
                    }
                }
    
    func updatePasswordAPICall() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String

        
//http://35.154.239.192:4500/endusers/changepassword
        
                let URLString_loginIndividual = Constants.BaseUrl + ChangePwdUrl
        
                    let params_IndividualLogin = [
                        "userId" : userID,
                        "currentPassword":currentPwdTF.text ?? "",
                        "password":newPwdTF.text ?? "",
                    ]
                
//          print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
                    myAccServerCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        if status == "SUCCESS" {

                            self.showAlertWith(title: "Success", message: "Password updated successfully")

                        }
                        else {
                            self.showAlertWith(title: "Alert", message: messageResp ?? "")

                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true

                        }
                        
                    }) { (error) in
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        print("Something Went To Wrong...PLrease Try Again Later")
                    }
        
                }
    
}

   //********************** (ImagePicker Functionality) *****************************
extension VendorAccountVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //ImagePicking Button :
    @IBAction func profileImgBtnTap(_ sender: Any) {
        
//     let image = UIImagePickerController()
//             image.delegate=self
//             image.sourceType = .photoLibrary
//             image.allowsEditing=false
//             self.present(image, animated: true){
//
//             }
        
        loadActionSheet()
        
         }
    
    func loadActionSheet()  {
        
        let alert = UIAlertController(title: "Image Selection", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.loadCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            self.loadGallery()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
        if Constants.IS_IPAD {
                        let popoverPresentationController = alert.popoverPresentationController
                        popoverPresentationController?.sourceView = self.view
                        popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width/3 , y: self.view.frame.height/3, width: 0, height: 0)
                        popoverPresentationController?.permittedArrowDirections = .down
                    }

    }
    
    func loadGallery() {
        
        let image = UIImagePickerController()
                image.delegate=self
                image.sourceType = .photoLibrary
                image.allowsEditing=false
                self.present(image, animated: true){

                }
    }
    
    func loadCamera() {
        
        let image = UIImagePickerController()
                image.delegate=self
                image.sourceType = .camera
                image.allowsEditing=false
                self.present(image, animated: true){

                }
    }
         
             //Delegate Method in UIImage Picker Controller :
         func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             
             if let imagePick = info[UIImagePickerController.InfoKey.originalImage] {
                profileImgView.image = imagePick as? UIImage
                
                let imageData: Data? = (imagePick as! UIImage).jpegData(compressionQuality: 0.4)
                let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""

                profileBase64Img = imageStr as NSString
                
//                profileImgBtn.setImage(imagePick as? UIImage, for: UIControl.State.normal)
         }
             else{

             //Error Message
             }
             self.dismiss(animated: true, completion: nil)
    }
}
