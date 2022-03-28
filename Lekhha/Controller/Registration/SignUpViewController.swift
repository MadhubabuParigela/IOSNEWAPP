//
//  SignUpViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 16/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleMaps
import CoreLocation
import GooglePlaces
import GoogleSignIn
import DropDown

class SignUpViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate,GMSMapViewDelegate, UIGestureRecognizerDelegate,GMSAutocompleteViewControllerDelegate, UITextViewDelegate,SendingHomeDelegateProtocol {
    
    var genderStr = ""
//    private var marker :GMSMarker!
    
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
    
    func textViewDidBeginEditing(_ textView: UITextView)  {
        
//        if(textView == chooseLocationTF){
//            self.loadMapView()
//
//        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == locationTF){
            
            isUpdateLocation = true
            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)

        }
        
//        if(textField == chooseLocationTF){
//            self.loadMapView()
//
//        }
    }
    
    
    var location: CLLocation?
    var geocoder = GMSGeocoder()
    var locationgeocoder: CLGeocoder?
    var destiMarker = GMSMarker()
    var locationManager:CLLocationManager!
    var latt = Double()
    var long = Double()
    var addressStr = String()
    var locationTF = UITextField()
    var mapView = GMSMapView()
    var isSelectAccount:Bool = false
    var passwordStr = ""
    var mobileStr = ""
    
    var countryArr = [CountryResultVo]()
    var countryNameArr = [String]()
    var countryCodeArr = [String]()
    var countryNameStr = ""
    var slectedCodeStr = ""
    var countryCodeStr = ""
    
    @IBOutlet weak var termsCheckBtn: UIButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var privacyCheckBtn: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    
    var isTermsChecked:Bool = false
    var isPrivachChecked:Bool = false
    
    @IBAction func termsCheckBtnAction(_ sender: UIButton) {
        
        if termsCheckBtn.currentImage == UIImage(named: "checkBoxInactive"){
            termsCheckBtn.setImage(UIImage(named: "checkBoxActive"), for: .normal)
            isTermsChecked = true
        }
        else {
            isTermsChecked = false
            termsCheckBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
        }
    }
    
    @IBAction func termsBtnAction(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set("PrivacyTerm", forKey: "isPrivacyTerms")
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
              let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
              VC.modalPresentationStyle = .fullScreen
        VC.isPrivacy = "Terms"
        VC.delegate = self
        VC.headerStr = "Terms of use"
        VC.urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/termsandconditions"
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func privacyCheckBtnAction(_ sender: UIButton) {
        
        if privacyCheckBtn.currentImage == UIImage(named: "checkBoxInactive"){
            privacyCheckBtn.setImage(UIImage(named: "checkBoxActive"), for: .normal)
            isPrivachChecked = true
        }
        else {
            isPrivachChecked = false
            privacyCheckBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
        }
    }
    
    @IBAction func privacyBtnAction(_ sender: UIButton) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set("PrivacyTerm", forKey: "isPrivacyTerms")
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
              let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
              VC.modalPresentationStyle = .fullScreen
        VC.isPrivacy = "Privacy"
        VC.delegate = self
        VC.headerStr = "Privacy Policy"
        VC.urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/privacypolicy"
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    func getCheckValue(str: String) {
    
        if str == "Privacy"{
        
            print("Privacy")
            isPrivachChecked = true
            privacyCheckBtn.setImage(UIImage(named: "checkBoxActive"), for: .normal)
            
        }
        else if str == "Terms"{
            
            print("Terms")
            isTermsChecked = true
            termsCheckBtn.setImage(UIImage(named: "checkBoxActive"), for: .normal)
        }
    }
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var overAllMainViewHeightConstant: NSLayoutConstraint!
    var isUpdateLocation = true
    
    var chooseLocationBackView = UIView()
    
    @IBOutlet weak var chooseLocationTF: UILabel!
    var isgender = ""
    var messaheStr = ""
    var isUserFound:Bool = false
    var userDeatilsArr = [Login_IndividualResultVO]()
    
    @IBOutlet weak var submitBtnYConstant: NSLayoutConstraint!

    @IBOutlet weak var submitBtnHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var chooseLocHeightConstant: NSLayoutConstraint!
    
    var loginIndividualServer = ServiceController()
    
     @IBOutlet weak var dobDatePicker: UITextField!
     var datePicker = UIDatePicker()
    
    @IBOutlet weak var mobileTF: SDCTextField!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var dOBBtn: UIButton!
    var dobSTR = ""
    
    @IBOutlet weak var signUpFirstView: UIView!
    
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var mobileNumberTF: SDCTextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var mobileImg: UIImageView!
    @IBOutlet weak var mobileImgBtn: UIButton!
    @IBOutlet weak var signUpSecondView: UIView!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var alradySignInBtn: UIButton!
    
    @IBOutlet weak var mobileBtn: UIButton!
    @IBOutlet weak var mobileDropTF: UITextField!
    @IBOutlet weak var mobileDropView: UIView!
    @IBOutlet weak var mobileSecondBgView: UIView!
    @IBOutlet weak var mobileSecondDropView: UIView!
    @IBOutlet weak var mobileSecondDropTF: UITextField!
    
    @IBOutlet weak var eyeBtn: UIButton!
    @IBAction func eyeBtnAction(_ sender: Any) {
        
        if eyeBtn.currentImage == UIImage(named: "eye-1"){
            eyeBtn.setImage(UIImage(named: "eye"), for: .normal)
            passwordTF.isSecureTextEntry = true
        }
        else {
            eyeBtn.setImage(UIImage(named: "eye-1"), for: .normal)
            passwordTF.isSecureTextEntry = false
        }
    }
    
    @IBOutlet weak var confirmEyeBtn: UIButton!
    @IBAction func confirmPwdBtnAction(_ sender: Any) {
        
        if confirmEyeBtn.currentImage == UIImage(named: "eye-1"){
            confirmEyeBtn.setImage(UIImage(named: "eye"), for: .normal)
            confirmPasswordTF.isSecureTextEntry = true
        }
        else {
            confirmEyeBtn.setImage(UIImage(named: "eye-1"), for: .normal)
            confirmPasswordTF.isSecureTextEntry = false
        }
    }
    
    
    let dropDown = DropDown() //2
    var isSignValue = ""
    @IBAction func mobileBtnAction(_ sender: UIButton) {
        
        dropDown.dataSource = countryNameArr
//            ["India-IND"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.slectedCodeStr = (self?.countryCodeArr[index])!
                self?.mobileDropTF.text = self?.slectedCodeStr
                if self?.countryCodeStr == self?.slectedCodeStr {
                    
                }
                else {
                    self?.view.makeToast("Invalid country")
                }
            }
    }
    @IBAction func mobileSecondBtnAction(_ sender: UIButton) {
        
        dropDown.dataSource = countryNameArr
//            ["India-IND"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.slectedCodeStr = (self?.countryCodeArr[index])!
                self?.mobileSecondDropTF.text = self?.slectedCodeStr
                if self?.countryCodeStr == self?.slectedCodeStr {
                    
                }
                else {
                    self?.view.makeToast("Invalid country")
                }
            }
    }
    
    
    @IBAction func mobileImgBtnAction(_ sender: Any) {
    }
    @IBAction func proceedBtnAction(_ sender: Any) {
    
        pwdTF.text = passwordTF.text
        confirmPwdTF.text = confirmPasswordTF.text
        mobileTF.text = mobileNumberTF.text
        let strLength = passwordTF.text?.count ?? 0
        let mobileStrLength = mobileTF.text?.count ?? 0
       
        if mobileNumberTF.text == ""
        {
            self.showAlertWith(title: "Alert", message: "Enter your mobile number")
            return
        }
        else if(isvalidcontact(value: mobileTF.text ?? "0") == false){
            
                self.showAlertWith(title: "Alert", message: "Enter valid mobile number")
                return
        }
        else if mobileStrLength < 10
        {
            self.showAlertWith(title: "Alert", message: "Enter valid mobile number")
            return
        }
        else if mobileStrLength > 10
        {
            self.showAlertWith(title: "Alert", message: "Enter valid mobile number")
            return
        }
        else if(isValidPassword(passwordStr: passwordTF.text ?? "") == false){
            self.showAlertWith(title: "Alert", message: "Password must contain minimum 6 characters, at least 1 number and 1 special character")
            return
        }
        else if passwordTF.text == ""
        {
            self.showAlertWith(title: "Alert", message: "Enter your password")
            return
        }
        else if(strLength < 6){
            self.showAlertWith(title: "Alert", message: "Password should not be less than 6 chartacters")
            return
        }
        else if(strLength > 12){
            self.showAlertWith(title: "Alert", message: "Password should not be more than 12 chartacters")
            return
        }
//        else if confirmPasswordTF.text == ""
//        {
//            self.showAlertWith(title: "Alert", message: "Enter your confirm password")
//            return
//        }
//        else if(passwordTF.text != confirmPasswordTF.text)
//        {
//            self.showAlertWith(title: "Alert", message: "Password and confirm password do not match")
//            return
//        }
        if slectedCodeStr == countryCodeStr {
            
            print("selectStr:\(countryNameStr)")
        }
        else {
            self.view.makeToast("You cannot login with the selected country")
            return
        }
        
        callSignInAPI()
        
    }
    
    func callSignInAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        let userDefaults = UserDefaults.standard
//        let countryStr = userDefaults.value(forKey: "countryCode") ?? ""
//        let countryNameStr = userDefaults.value(forKey: "countryName") ?? ""
        
                let URLString_loginIndividual = Constants.BaseUrl + LoginUrl
        
                    let params_IndividualLogin = [
                        "mobileNumber":mobileNumberTF.text ?? "",
                        "passWord":passwordTF.text ?? "",
                        "countryCode":countryCodeStr,
                        "countryName":countryNameStr
                    ]
                
                    print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
                    loginIndividualServer.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:Login_IndividualRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
//                        let token = respVo.token
    
//                        let resultArr = respVo.result?[0] as? NSDictionary
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                                    
                            if(statusCode == 200){ //Success
                                
                                if status == "SUCCESS" {
                                    print("Success")
                                
//                                let userId = respVo.result![0]._id
                                    var firstName = String()
                                    var lastName = String()
                                    var genderStr = String()
                                    var dobStr = String()
                                    if respVo.result?.count ?? 0>0
                                    {
                                        self.userDeatilsArr = respVo.result!
                                        self.isUserFound = true
                                 firstName = respVo.result![0].firstName ?? ""
                                 lastName = respVo.result![0].last_name ?? ""
                                 genderStr = respVo.result![0].gender ?? ""
                                 dobStr = respVo.result![0].dateOfBirth ?? ""
                                        
                                        let pLatestStatus = respVo.result![0].privacypolicy_latest_version
                                        let pAcceptedStatus = respVo.result![0].privacypolicy_accepted_version
                                        
                                        let tLatestStatus = respVo.result![0].termsandconditions_latest_version
                                        let tAcceptedStatus = respVo.result![0].termsandconditions_accepted_version
                                                                                
                                        if pLatestStatus == pAcceptedStatus {
                                            
                                            self.privacyCheckBtn.setImage(UIImage(named: "checkBoxActive"), for: .normal)
                                            self.privacyCheckBtn.isUserInteractionEnabled = false
                                            self.isPrivachChecked = true
                                        }
                                        if tLatestStatus == tAcceptedStatus {
                                            self.termsCheckBtn.setImage(UIImage(named: "checkBoxActive"), for: .normal)
                                            self.termsCheckBtn.isUserInteractionEnabled = false
                                            self.isTermsChecked = true
                                        }
                                    }
                                    
                                    userDefaults.set(self.countryCodeStr, forKey: "countryCode")
                                    userDefaults.set(self.countryNameStr, forKey: "countryName")
                                    
                                    self.firstNameTF.text = firstName
                                    self.lastNameTF.text = lastName
                                    self.isgender = genderStr
                                    let joinStr = self.convertDateFormater(dobStr)
                                    
                                    if joinStr != "" {
                                        self.dobDatePicker.text = "\(joinStr)"
                                    }
                                
                                    if self.isgender == "male" {
                                        self.isgender = "male"
                                        self.otherOptionBtn.setImage(UIImage(named: "radioInactive"), for: .normal)
                                        self.maleRadioBtn.setImage(UIImage(named: "radio_active"), for: UIControl.State.normal)
                                        self.femaleRadioBtn.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
                                    }
                                    else if self.isgender == "female" {
                                        self.isgender = "female"
                                        self.otherOptionBtn.setImage(UIImage(named: "radioInactive"), for: .normal)
                                        self.maleRadioBtn.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
                                        self.femaleRadioBtn.setImage(UIImage(named: "radio_active"), for: UIControl.State.normal)
                                        
                                    }
                                    else if self.isgender == "other" {
                                        self.isgender = "other"
                                        self.otherOptionBtn.setImage(UIImage(named: "radio_active"), for: .normal)
                                        self.maleRadioBtn.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
                                        self.femaleRadioBtn.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
                                    }
                                    
                                    self.signUpSecondView.isHidden = false
                                    self.signUpFirstView.isHidden = true
                                    
                                    self.view.makeToast("This mobile number already registered with us")
                                    
//                                    self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                                                
                                }
                                else {
                                   
                                    self.isUserFound = false
                                    self.privacyCheckBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
                                    self.privacyCheckBtn.isUserInteractionEnabled = true
                                    self.termsCheckBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
                                    self.termsCheckBtn.isUserInteractionEnabled = true
                                    self.showAlertWithTag(title: "Alert", message: "Do you remember password what you have entered")
                                    
//                                    messaheStr = messageResp ?? ""
                                    
//                                    self.firstNameTF.text = "First Name"
//                                    self.lastNameTF.text = "Last Name"
//                                    self.firstNameTF.textColor = UIColor.lightGray
//                                    self.lastNameTF.textColor = UIColor.lightGray
//                                    self.showAlertWith(title: "Alert", message: messageResp ?? "")
//                                    activity.stopAnimating()
//                                    self.view.isUserInteractionEnabled = true
                                }
                                
                            }else{
                                
                                self.isUserFound = false
                                self.privacyCheckBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
                                self.privacyCheckBtn.isUserInteractionEnabled = true
                                self.termsCheckBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
                                self.termsCheckBtn.isUserInteractionEnabled = true
                                self.showAlertWithTag(title: "Alert", message: "Do you remember password what you have entered")
                                
//                                self.firstNameTF.text = "First Name"
//                                self.lastNameTF.text = "Last Name"
//                                self.firstNameTF.textColor = UIColor.lightGray
//                                self.lastNameTF.textColor = UIColor.lightGray
//
//                                self.signUpSecondView.isHidden = false
//                                self.signUpFirstView.isHidden = true
//                                activity.stopAnimating()
//                                self.view.isUserInteractionEnabled = true
                            }
                                                    
                    }) { (error) in
                        
                        
//                        self.firstNameTF.text = "First Name"
//                        self.lastNameTF.text = "Last Name"
//                        self.firstNameTF.textColor = UIColor.lightGray
//                        self.lastNameTF.textColor = UIColor.lightGray
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        print("Something Went To Wrong...PLrease Try Again Later")
                    }
                }
    
    func showAlertWithTag(title:String,message:String)
        {
            let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
            //to change font of title and message.
            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
            alertController.setValue(titleAttrString, forKey: "attributedTitle")
            alertController.setValue(messageAttrString, forKey: "attributedMessage")
            
            let alertAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                
                self.firstNameTF.text = "First Name"
                self.lastNameTF.text = "Last Name"
                self.firstNameTF.textColor = UIColor.lightGray
                self.lastNameTF.textColor = UIColor.lightGray
//                self.showAlertWith(title: "Alert", message: "")
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                self.signUpSecondView.isHidden = false
                self.signUpFirstView.isHidden = true
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
            })
        
        let alertAction1 = UIAlertAction(title: "No", style: .destructive, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        })

    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
           alertController.addAction(alertAction1)

        navigationController?.present(alertController, animated: true, completion: nil)
        
        }
    
    func convertDateFormater(_ date: String) -> String
        {
            let dateFormatter = DateFormatter()
//          yyyy-MM-dd'T'HH:mm:ssZ   "yyyy-MM-dd HH:mm:ss"
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "dd/MM/yyyy"
        if date != nil {
            dobSTR = dateFormatter.string(from: date!)
        }
        let formatterr = DateFormatter()
        formatterr.dateFormat = "dd/MM/yyyy"
        if date != nil {
            return formatterr.string(from: date!)
        }
        else {
            return ""
        }
        }
    
    @IBAction func alreadySignInBtnAction(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
        VC.modalPresentationStyle = .fullScreen
      self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func dobBtnTap(_ sender: Any) {
        showDatePicker()

    }
    @IBOutlet weak var maleRadioBtn: UIButton!
    
    @IBAction func maleRadioBtnTap(_ sender: Any) {
        
        isgender = "male"
        
        otherOptionBtn.setImage(UIImage(named: "radioInactive"), for: .normal)
        maleRadioBtn.setImage(UIImage(named: "radio_active"), for: UIControl.State.normal)
        femaleRadioBtn.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)

    }
    
    @IBAction func femaleRadioBtnTap(_ sender: Any) {
        
        isgender = "female"
        
        otherOptionBtn.setImage(UIImage(named: "radioInactive"), for: .normal)
        maleRadioBtn.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
        femaleRadioBtn.setImage(UIImage(named: "radio_active"), for: UIControl.State.normal)

    }
    
    @IBOutlet weak var femaleRadioBtn: UIButton!
    
    @IBOutlet weak var confirmPwdTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var fbView: UIView!
    @IBOutlet weak var googleView: UIView!
    
    
    @IBAction func signUpFBBtnAction(_ sender: Any) {
    }
    @IBAction func googleSignInBtnAction(_ sender: Any) {
    }
    @IBAction func googleBtnAction(_ sender: Any) {
        
        let signInConfig = GIDConfiguration.init(clientID: "976753428495-vq0j414cqq63dv33jjk8dfe5rsn2mvqj.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
           guard error == nil else { return }
            
//            user?.profile?.familyName
//            user?.profile?.email
//            user?.profile?.name
//            user?.profile?.givenName
            if user != nil {
                self.firstNameTF.text = user?.profile?.givenName
                self.lastNameTF.text = user?.profile?.familyName
                self.emailTF.text = user?.profile?.email
                self.isSignValue = "Gmail"
                self.view.makeToast("Google details is added successfully")
            }
           // If sign in succeeded, display the app's main content View.
         }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.firstNameTF.textColor = UIColor.black
        self.lastNameTF.textColor = UIColor.black
        
        if textField == self.emailTF {
            self.isSignValue = "Manual"
        }
        // Verify all the conditions
        if textField.isFirstResponder {
            if textField.textInputMode?.primaryLanguage == nil || textField.textInputMode?.primaryLanguage == "emoji" {
                return false
              }
        }
        let validString = NSCharacterSet(charactersIn: "")
//        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if let sdcTextField = textField as? SDCTextField {
            
            if string.rangeOfCharacter(from: validString as CharacterSet) != nil
            {
//                print(range)
                return false
            }
            else
            {
                guard range.location == 0 else {
                    if textField == self.mobileTF {
                        return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string) && string.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
                    }
                    if textField == self.mobileNumberTF {
                        return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string) && string.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
                    }
                    return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
                }
                let newString = (sdcTextField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                                    
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }
        if let range = string.rangeOfCharacter(from: validString as CharacterSet)
        {
//            print(range)
            return false
        }
        else
        {
            guard range.location == 0 else {
                return true
            }
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
        }
        
//        if let text = textField.text as NSString? {
//            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
//
//        }
        return true
    }
    
    @IBAction func fbBtnAction(_ sender: Any) {
        
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (dataDictionary:Dictionary<String, AnyObject>?, error:NSError?) -> Void in
            
            print("dataDictionary:\(dataDictionary)")
            
            if dataDictionary != nil {
                
                let respVo:FacebookRespVo = Mapper().map(JSON: dataDictionary as! [String : Any])!
                
                
                self.firstNameTF.text = respVo.first_name
                self.lastNameTF.text = respVo.last_name
                self.emailTF.text = respVo.email
                
                self.isSignValue = "Facebook"
                self.view.makeToast("Facebook details is added successfully")
//
//                let strId = String(respVo.id ?? "0")
                
//                https://www.facebook.com/fitz.cube
                
//                UIApplication.tryURL(urls: [
//                    "fb://profile/578516649642725", // App
//                    "https://www.facebook.com/fitz.cube" // Website if app fails
//                    ])
                
//                UIApplication.tryURL(urls: [
//                    "fb://profile/116022086529035", // App
//                    "http://www.facebook.com/116022086529035" // Website if app fails
//                    ])
                
            }
        }
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        let strLength = pwdTF.text?.count ?? 0
        let mobileStrLength = mobileTF.text?.count ?? 0

        if mobileTF.text == ""
        {
            self.showAlertWith(title: "Alert", message: "Enter your mobile number")
            return
        }
        else if(isvalidcontact(value: mobileTF.text ?? "0") == false){
            
                self.showAlertWith(title: "Alert", message: "Enter valid mobile number")
                return
        }
        else if mobileStrLength < 10
        {
            self.showAlertWith(title: "Alert", message: "Enter valid mobile number")
            return
        }
        else if mobileStrLength > 10
        {
            self.showAlertWith(title: "Alert", message: "Enter valid mobile number")
            return
        }
        else if firstNameTF.text == ""
        {
            self.showAlertWith(title: "Alert", message: "Enter your first name")
            return
        }
        else if lastNameTF.text == ""
        {
            self.showAlertWith(title: "Alert", message: "Enter your last name")
            return
        }
//        else if(dobSTR == ""){
//            self.showAlertWith(title: "Alert", message: "Select date of birth")
//            return
//
//        }
        else if(isgender == ""){
            self.showAlertWith(title: "Alert", message: "Select gender")
            return

        }
        else if emailTF.text == ""
        {
            self.showAlertWith(title: "Alert", message: "Enter your email")
            return
        }
        else if emailTF.text!.isValidEmail() == false{
                
            self.showAlertWith(title: "Alert", message: "Enter valid email id")
            return
                
        }
        else if(isValidPassword(passwordStr: pwdTF.text ?? "") == false){
            self.showAlertWith(title: "Alert", message: "Password must contain minimum 6 characters, at least 1 number and 1 special character")
            return

        }
        else if pwdTF.text == ""
        {
            self.showAlertWith(title: "Alert", message: "Enter your password")
            return
        }
        else if(strLength < 6){
            self.showAlertWith(title: "Alert", message: "Password should not be less than 6 chartacters")
            return

        }
        else if(strLength > 12){
            self.showAlertWith(title: "Alert", message: "Password should not be more than 12 chartacters")
            return

        }
        
        if isPrivachChecked == false && isTermsChecked == false {
            
            self.showAlertWith(title: "Alert", message: "Please Accept Terms of use and Privacy policy")
            return
        }
        if isPrivachChecked == false {
            
            self.showAlertWith(title: "Alert", message: "Please Accept Privacy policy")
            return
        }
        if isTermsChecked == false {
            self.showAlertWith(title: "Alert", message: "Please Accept Terms of use")
            return
        }
        
//        else if confirmPwdTF.text == ""
//        {
//            self.showAlertWith(title: "Alert", message: "Enter your confirm password")
//            return
//        }
//        else if(pwdTF.text != confirmPwdTF.text)
//        {
//            self.showAlertWith(title: "Alert", message: "Password and confirm password do not match")
//            return
//        }
        
//        else if(chooseLocationTF.text == "")
//        {
//            self.showAlertWith(title: "Alert", message: "Choose location")
//            return
//        }
        
        callSignUpAPI()
        
    }
    
    @IBOutlet weak var otherOptionBtn: UIButton!
    
    @IBAction func otherOptionBtnTap(_ sender: UIButton) {
        
        isgender = "other"
        otherOptionBtn.setImage(UIImage(named: "radio_active"), for: .normal)
        maleRadioBtn.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
        femaleRadioBtn.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)

    }
    
    @IBAction func alreadyHaveAnAccBtnTap(_ sender: Any) {
        
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
                VC.modalPresentationStyle = .fullScreen
              self.navigationController?.pushViewController(VC, animated: true)
//                self.present(VC, animated: true, completion: nil)

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
    
    func showAlert1With(title:String,message:String)
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
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
                VC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(VC, animated: true)
               
            })
    
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    
    override func viewDidLoad() {
        
//        isUpdateLocation = false
        super.viewDidLoad()
        self.isgender = "male"
        self.otherOptionBtn.setImage(UIImage(named: "radioInactive"), for: .normal)
        self.maleRadioBtn.setImage(UIImage(named: "radio_active"), for: UIControl.State.normal)
        self.femaleRadioBtn.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
        
        termsCheckBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
        privacyCheckBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
        
        eyeBtn.setImage(UIImage(named: "eye"), for: .normal)
        confirmEyeBtn.setImage(UIImage(named: "eye"), for: .normal)
        
        if isSelectAccount == true {
            pwdTF.text = passwordStr
            confirmPwdTF.text = passwordStr
            mobileTF.text = mobileStr
            signUpSecondView.isHidden = false
            signUpFirstView.isHidden = true
        }
        else {
            signUpSecondView.isHidden = true
            signUpFirstView.isHidden = false
        }
            
        mobileView.layer.borderColor = UIColor.gray.cgColor
        mobileView.layer.borderWidth = 0.5
        mobileView.layer.cornerRadius = 3
        mobileView.clipsToBounds = true
        
        passwordView.layer.borderColor = UIColor.gray.cgColor
        passwordView.layer.borderWidth = 0.5
        passwordView.layer.cornerRadius = 3
        passwordView.clipsToBounds = true
        
        confirmPasswordView.layer.borderColor = UIColor.gray.cgColor
        confirmPasswordView.layer.borderWidth = 0.5
        confirmPasswordView.layer.cornerRadius = 3
        confirmPasswordView.clipsToBounds = true
        
        mobileDropView.layer.borderColor = UIColor.gray.cgColor
        mobileDropView.layer.borderWidth = 0.5
        mobileDropView.layer.cornerRadius = 3
        mobileDropView.clipsToBounds = true
        
        mobileSecondDropView.layer.borderColor = UIColor.gray.cgColor
        mobileSecondDropView.layer.borderWidth = 0.5
        mobileSecondDropView.layer.cornerRadius = 3
        mobileSecondDropView.clipsToBounds = true
        
        mobileSecondBgView.layer.borderColor = UIColor.gray.cgColor
        mobileSecondBgView.layer.borderWidth = 0.5
        mobileSecondBgView.layer.cornerRadius = 3
        mobileSecondBgView.clipsToBounds = true
        
        
        proceedBtn.layer.cornerRadius = 5
        proceedBtn.clipsToBounds = true
        
//        signUpFirstView.backgroundColor = #colorLiteral(red: 0.9110219479, green: 0.9110219479, blue: 0.9110219479, alpha: 1)
        
        showDatePicker()
        
        mapView.delegate = self
        
        animatingView()
        
        if let countryCode = CountryUtility.getLocalCountryCode() {
            
            let codestr = IsoCountryCodes.find(key: countryCode)?.alpha3
            
            slectedCodeStr = codestr ?? ""
            self.countryCodeStr = codestr ?? ""
            
            countryNameStr = IsoCountryCodes.find(key: countryCode)?.name ?? ""
            
            self.mobileDropTF.text = codestr
            self.mobileSecondDropTF.text = codestr

            if let alpha3 = CountryUtility.getCountryCodeAlpha3(countryCodeAlpha2: countryCode){
                        print(alpha3) ///result: PRT
            }
        }
                
//        mobileDropTF.optionArray = ["India-IND"]
//                Its Id Values and its optional
//        mobileDropTF.optionIds = ["1"]
//        mobileDropTF.text = "IND"
//        mobileDropTF.checkMarkEnabled = false
        
//        mobileDropTF.arrow.arrowColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
//        mobileDropTF.handleKeyboard = false
        
        googleView.layer.shadowColor = UIColor.lightGray.cgColor
        googleView.layer.shadowOpacity = 1
        googleView.layer.shadowOffset = CGSize.zero
        googleView.layer.shadowRadius = 5
        
        fbView.layer.shadowColor = UIColor.lightGray.cgColor
        fbView.layer.shadowOpacity = 1
        fbView.layer.shadowOffset = CGSize.zero
        fbView.layer.shadowRadius = 5
        
//        let paddingView = UIView()
//        paddingView.frame = CGRect(x: 0, y: 0, width: 50, height: mobileTF.frame.size.height)
//        mobileTF.leftView = paddingView
//        mobileTF.leftViewMode = UITextField.ViewMode.always
//
//        let imgView = UIImageView()
//        imgView.frame = CGRect(x: 10, y: 12, width: 30, height: 20)
//        imgView.image = UIImage(named:"Flag_of_India")
//        paddingView.addSubview(imgView)
        
//        let seperatorLine = UILabel()
//        seperatorLine.frame = CGRect(x: paddingView.frame.size.width - 1, y: 0, width: 1, height: paddingView.frame.size.height)
//        seperatorLine.backgroundColor = hexStringToUIColor(hex: "#dfdfdf")
//        paddingView.addSubview(seperatorLine)
        
//        let locPaddingView = UIView()
//        locPaddingView.frame = CGRect(x: 0, y: 0, width: 50, height: chooseLocationTF.frame.size.height)
//        chooseLocationTF.rightView = locPaddingView
//        chooseLocationTF.rightViewMode = UITextField.ViewMode.always
        
//        chooseLocationTF.delegate = self

//      placeholder
        
//        let locImgView = UIImageView()
//        imgView.frame = CGRect(x: locPaddingView.frame.size.width/2 - (12), y: locPaddingView.frame.size.height/2 - (12), width: 24, height: 24)
//        locImgView.image = UIImage.init(named: "placeholder")
//        locPaddingView.addSubview(locImgView)
        
        mobileTF.delegate = self
        emailTF.delegate = self
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        pwdTF.delegate = self
        confirmPwdTF.delegate = self
        passwordTF.delegate = self
        confirmPasswordTF.delegate = self
        mobileNumberTF.delegate = self
        
        mobileTF.maxLength = 10
        mobileNumberTF.maxLength = 10
//        chooseLocationTF.delegate = self
        
        locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()

           if CLLocationManager.locationServicesEnabled(){
               locationManager.startUpdatingLocation()
           }

        
        // Do any additional setup after loading the view.
    }
    
    //    view Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        getCountryList_APICall()
                
//        mobileDropTF.didSelect { (selectedText , index ,id) in
//            print("Selected String: \(selectedText) \n index: \(index)")
//
//            if selectedText == "India-IND"{
//                self.mobileDropTF.text = "IND"
//            }
//            if id == "1"{
//                self.mobileDropTF.text = "IND"
//            }
//        }
        
       
    }
    func getCountryList_APICall() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + GetAllCountriesUrl
        
        loginIndividualServer.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in
            
            let respVo:CountryRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if statusCode == 200 {
                if status == "SUCCESS" {
                    if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            self.countryArr = respVo.result ?? [CountryResultVo]()
                            for obj in self.countryArr {
                                self.countryNameArr.append(obj.countryName ?? "")
                                self.countryCodeArr.append(obj.countryCode ?? "")
                            }
                        }
                    }
                }
                else {
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
    // MARK: - MEthod to create mapview and its camera
    func updateLocationCoordinates(coordinates : CLLocationCoordinate2D)
    {
//        mapView.removeFromSuperview()
//        let camera = GMSCameraPosition(latitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 18) as GMSCameraPosition
//
//        mapView = GMSMapView(frame: CGRect(x: 0, y: 72*Constants.APDim_Y, width: self.view.frame.size.width, height: 200*Constants.APDim_Y), camera: camera)
//        mapView.isMyLocationEnabled = true
//        mapView.delegate = self
//        self.view.addSubview(mapView)
        
        loadMapView()
        
    }
    
    // MARK: - GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        addreslbl.text = ""
//        localityLbl.text = ""
        getAddress(_postion: position.target)
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        addreslbl.text = ""
//        localityLbl.text = ""
        
        destiMarker.position = position.target
        getAddress(_postion: position.target)
    }
    
    // MARK: - MEthod to get address
    func getAddress(_postion : CLLocationCoordinate2D)
    {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(_postion) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else {
            return
        }
            self.addressStr = lines.joined(separator: "\n")
//        self.localityLbl.text = address.subLocality
            self.locationTF.text = self.addressStr
//        self.pinCodeStr = address.postalCode ?? ""
        self.latt = Double(_postion.latitude)
        self.long = Double(_postion.longitude)
            
        }
    }

    
    func showDatePicker(){

        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }

        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()

        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self.cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self.donedatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        dobDatePicker.inputAccessoryView = toolbar
        dobDatePicker.inputView = datePicker
        
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

      @objc func donedatePicker(){

       let formatter = DateFormatter()
       formatter.dateFormat = "dd/MM/yyyy"
       dobSTR = formatter.string(from: datePicker.date)
        
        let formatterr = DateFormatter()
        formatterr.dateFormat = "dd/MM/yyyy"
        dobDatePicker.text = formatter.string(from: datePicker.date)
       self.view.endEditing(true)
     }
    
    func showAlertWithEmail() {
        
        let alert = UIAlertController(title: "Success", message: "Your account created successfully please check your mail", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "EmailValidateVC") as! EmailValidationViewController
            VC.isManual = self.isSignValue
                        //      self.navigationController?.pushViewController(VC, animated: true)
            VC.modalPresentationStyle = .fullScreen
//                                self.present(VC, animated: true, completion: nil)
            self.navigationController?.pushViewController(VC, animated: true)
            
        }))
                
        self.present(alert, animated: true, completion: nil)
    }
    func callSignUpAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let URLString_loginIndividual = Constants.BaseUrl + "endusers/user_add"
        
//        firstName
//        lastName
//        mobileNumber
//        emailId
//        passWord
//        dateOfBirth
//        gender
//        latitude
//        longitude
        
        let emailIdStr = emailTF.text ?? ""
        let emailLowerCaseStr = emailIdStr.lowercased()
        
//        let userDefaults = UserDefaults.standard
//        let countryStr = userDefaults.value(forKey: "countryCode") ?? ""
//        let countryNameStr = userDefaults.value(forKey: "countryName") ?? ""
        
        let modelName = UIDevice.modelName
        print("modelName:\(modelName)")
        let deviceVersion = UIDevice.current.systemVersion
        print("deviceVersion:\(deviceVersion)")
        let typeVendor = UIDevice.current.identifierForVendor
        print("typeVendor:\(typeVendor)")
        let type = UIDevice.current.type
        print("type:\(type)")
        let name = UIDevice.current.name
        print("name:\(name)")
        let model = UIDevice.current.model
        print("model:\(model)")
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let appVersionStr = appVersion ?? ""
        print("appVersionStr:\(appVersionStr)")
        let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let buildVersionStr = appBuild ?? ""
        print("buildVersionStr:\(buildVersionStr)")
        
        let deviceInfoDict = ["appVersion":appVersionStr,"basebandVersion":deviceVersion,"buildNo":buildVersionStr,"deviceName":name,"kernelVersion":deviceVersion,"lattitude":"NA","longitude":"NA","manufacture":"APPLE","model":modelName,"osVersion":deviceVersion,"serial":"unknown"] as [String : Any]
        
        print("deviceInfoDict:\(deviceInfoDict)")
                        
        let params_IndividualLogin = [
            "firstName":firstNameTF.text ?? "",
            "lastName":lastNameTF.text ?? "",
            "mobileNumber":mobileTF.text ?? "",
            "emailId":emailLowerCaseStr,
            "passWord":pwdTF.text ?? "",
            "dateOfBirth":dobSTR,
            "gender":isgender,
            "countryCode":countryCodeStr,
            "countryName":countryNameStr,
            "deviceInfo":deviceInfoDict
        ] as [String : Any]
        
         /*           let params_IndividualLogin = [
                        
                        "firstName":firstNameTF.text ?? "",
                        "lastName":lastNameTF.text ?? "",
                        "mobileNumber":mobileTF.text ?? "",
                        "emailId": emailTF.text ?? "",
                        "passWord":pwdTF.text ?? "",
                        "dateOfBirth":dobSTR,
                        "latitude":latt,
                        "longitude":long,
                        "gender":isgender
                        
                    ] as [String : Any]
        
        */
                
                    print(params_IndividualLogin)
                    let postHeaders_IndividualLogin = ["":""]
                    
                    loginIndividualServer.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        self.updatePrivacyPolicyAndTerms()
                                    
                        if status == "SUCCESS" {
                            print("Success")
                            let opsResult = respVo.result?.ops
                            let userDefaults = UserDefaults.standard
                            if opsResult != nil {
                                let dict = opsResult?[0] as! NSDictionary
                                userDefaults.setValue(dict, forKey: "user_dict")
                            }
                              userDefaults.set(emailLowerCaseStr, forKey: "emailId")
                              userDefaults.set(self.mobileTF.text, forKey: "mobileNum")
                            userDefaults.set(self.countryCodeStr, forKey: "countryCode")
                            userDefaults.set(self.countryNameStr, forKey: "countryName")
                              userDefaults.synchronize()
                            
                            if(statusCode == 200 || statusCode == 100){
                                
                                if opsResult != nil {
                                    
                                    if messageResp == "You have already requested access for this account." {
                                        
                                        self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                    }
                                    else if messageResp == "You are already registered with us" {
                                        
                                        self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                    }
                                    else {
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let VC = storyBoard.instantiateViewController(withIdentifier: "OTPVC") as! OTPViewController
                                        VC.modalPresentationStyle = .fullScreen
                                        VC.isManual = self.isSignValue
                                        self.navigationController?.pushViewController(VC, animated: true)
                                    }
                                }
                                else {
                                    self.showAlert1With(title: "Alert", message: "Please wait for primary user approval")
                                }
                                
                            }else if(statusCode == 204){ //EMAIL
//                                self.showAlertWithEmail()
                                
                                let alert = UIAlertController(title: "Alert", message: messageResp, preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in

                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let VC = storyBoard.instantiateViewController(withIdentifier: "EmailValidateVC") as! EmailValidationViewController
                                    VC.isManual = self.isSignValue
                                                //      self.navigationController?.pushViewController(VC, animated: true)
                                    VC.modalPresentationStyle = .fullScreen
                        //                                self.present(VC, animated: true, completion: nil)
                                    self.navigationController?.pushViewController(VC, animated: true)

                                }))
                                self.present(alert, animated: true, completion: nil)

                            }else{
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                            
                        }
                        else {
                            
                            if(statusCode == 100){
                                
                                let opsResult = respVo.mobileresult! as NSArray
                                print(opsResult)
                                var dict = opsResult[0] as? NSMutableDictionary
                                dict?.removeObject(forKey: "mobileOTP")
                                dict?.removeObject(forKey: "fcmToken")
                                print(dict)
                                
                                let userDefaults = UserDefaults.standard
                                  userDefaults.set(dict, forKey: "user_dict")
                                  userDefaults.set(emailLowerCaseStr, forKey: "emailId")
                                  userDefaults.set(self.mobileTF.text, forKey: "mobileNum")
                                  userDefaults.synchronize()
                                
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let VC = storyBoard.instantiateViewController(withIdentifier: "OTPVC") as! OTPViewController
                                VC.modalPresentationStyle = .fullScreen
                                      self.navigationController?.pushViewController(VC, animated: true)
//                                self.present(VC, animated: true, completion: nil)

                            }else if(statusCode == 204){ //EMAIL
                                
                                let opsResult = respVo.mobileresult! as NSArray
                                print(opsResult)
                                
                                var dict = opsResult[0] as? NSMutableDictionary
                                dict?.removeObject(forKey: "mobileOTP")
                                dict?.removeObject(forKey: "fcmToken")
                                print(dict)
                                
                                let userDefaults = UserDefaults.standard
                                  userDefaults.set(dict, forKey: "user_dict")
                                  userDefaults.set(emailLowerCaseStr, forKey: "emailId")
                                  userDefaults.set(self.mobileTF.text, forKey: "mobileNum")
                                  userDefaults.synchronize()
                                
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let VC = storyBoard.instantiateViewController(withIdentifier: "EmailValidateVC") as! EmailValidationViewController
                                VC.isManual = self.isSignValue
                                VC.modalPresentationStyle = .fullScreen
                                self.navigationController?.pushViewController(VC, animated: true)

                            }else{
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                        }
                        
                    }) { (error) in
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        print("Something Went To Wrong...PLrease Try Again Later")
                    }
        
                }
    
    func updatePrivacyPolicyAndTerms(){
        
        if isUserFound == true {
            
            let obj = userDeatilsArr[0]
            
            let pLatestStatus = obj.privacypolicy_latest_version
            let pAcceptedStatus = obj.privacypolicy_accepted_version
            
            let tLatestStatus = obj.termsandconditions_latest_version
            let tAcceptedStatus = obj.termsandconditions_accepted_version
                                                    
            if pLatestStatus != pAcceptedStatus {
//                endusers/privacypolicy_update
                privacypolicy_updateAPI(str: pLatestStatus ?? "")
            }
            if tLatestStatus != tAcceptedStatus {
//                endusers/termaandconditions_update
                termsAndconditions_updateAPI(str: tLatestStatus ?? "")
            }
        }
        }
    
    func privacypolicy_updateAPI(str:String) {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        
        
        let URLString_loginIndividual = Constants.BaseUrl + GetPrivacypolicyUpdateUrl
        
        let params_IndividualLogin = [
            "userId" : userID,
            "privacypolicy_accepted_version": str,
        ]
        
        let postHeaders_IndividualLogin = ["":""]
        
        loginIndividualServer.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
            
            let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if statusCode == 200 {
                if status == "SUCCESS" {
                    

                }
                else {
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
    
    func termsAndconditions_updateAPI(str:String) {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        
        
        let URLString_loginIndividual = Constants.BaseUrl + GetTermaandconditionsUpdateUrl
        
        let params_IndividualLogin = [
            "userId" : userID,
            "termaandconditions_accepted_version": str,
        ]
        
        let postHeaders_IndividualLogin = ["":""]
        
        loginIndividualServer.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
            
            let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if statusCode == 200 {
                if status == "SUCCESS" {
                    
                }
                else {
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
    
    func isvalidcontact(value: String) -> Bool {
        
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: value)

    }
    
    func isValidPassword(passwordStr:String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
//        let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
        
        let password = passwordStr
        let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{6,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

    }
    
     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - location delegate methods
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation :CLLocation = locations[0] as CLLocation
    
    if(isUpdateLocation){
        
        isUpdateLocation = false
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

    //    self.labelLat.text = "\(userLocation.coordinate.latitude)"
    //    self.labelLongi.text = "\(userLocation.coordinate.longitude)"

        latt = userLocation.coordinate.latitude
        long = userLocation.coordinate.longitude

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks ?? [CLPlacemark]()
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)

    //            self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                
                self.addressStr = "\(placemark.subLocality!) ,\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                
                let city = placemark.locality ??  "" as String
                
                UserDefaults.standard.set(city, forKey: "pickedCity")
                UserDefaults.standard.synchronize()

//                self.loadMapView()
            }
        }
    }
}
    
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error \(error)")
}
    
    func getCurrentLocation()  {
        
        locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()

           if CLLocationManager.locationServicesEnabled(){
               locationManager.startUpdatingLocation()
           }
        
    }
    
    @IBOutlet weak var locBtn: UIButton!
    @IBAction func locBtnTap(_ sender: UIButton) {
        loadMapView()
        
    }
    
    func loadMapView() {
        
        DispatchQueue.main.async { [self] in
            
            self.chooseLocationBackView.removeFromSuperview()
            
            self.chooseLocationBackView = UIView()
            self.chooseLocationBackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.chooseLocationBackView)
            
            let camera = GMSCameraPosition.camera(withLatitude: self.latt, longitude: self.long, zoom: 12)
            self.mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.chooseLocationBackView.frame.size.height - 140), camera: camera)
            self.chooseLocationBackView.addSubview(self.mapView)
            
            mapView.delegate = self

//            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//            gestureRecognizer.delegate = self
//            self.mapView.addGestureRecognizer(gestureRecognizer)
            
            // Creates a marker in the center of the map.
//            let marker = GMSMarker()
//            marker.position = CLLocationCoordinate2D(latitude: self.latt, longitude: self.long)
//            marker.map = self.mapView
            
//            destiMarker = nil;
            
            destiMarker = GMSMarker()
            destiMarker.position = CLLocationCoordinate2D(latitude: self.latt, longitude: self.long);
            destiMarker.map = mapView;

            //Location TF
            
            let locationTxtView = UIView()
            locationTxtView.frame = CGRect(x: 0, y: self.chooseLocationBackView.frame.size.height - 140, width: self.chooseLocationBackView.frame.size.width, height: 140)
            locationTxtView.backgroundColor = .white
            self.chooseLocationBackView.addSubview(locationTxtView)

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
    
    
    
    func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {

    }

    @IBOutlet weak var chooseLocheightConstant: NSLayoutConstraint!
    
    @objc func locationSubmitBtnTap(sender: UIButton!){
        
        var Qheight = heightForView(text: addressStr, font: UIFont(name: kAppFontMedium, size: 15)!, width: self.view.frame.size.width - 130, xValue: 0, yValue: 0)
        
        Qheight = Qheight + 30
        
//        if(Qheight <= 45){
//
//        }
        
//        else if(Qheight <= 90){
            chooseLocheightConstant.constant = Qheight
            overAllMainViewHeightConstant.constant = 933 + Qheight
            
//        }
        
        chooseLocationTF.text = addressStr
        
        self.chooseLocationBackView.removeFromSuperview()
        self.locationTF.removeFromSuperview()

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
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        if(textField == chooseLocationTF){
//            chooseLocationTF.resignFirstResponder()
//            getCurrentLocation()
//
//        }else if(textField == locationTF){
//
//            let autocompleteController = GMSAutocompleteViewController()
//            autocompleteController.delegate = self
//            present(autocompleteController, animated: true, completion: nil)
//
//        }
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if textField == firstNameTF || textField == lastNameTF {
//
//                    let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
//                    let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
//                    let typedCharacterSet = CharacterSet(charactersIn: string)
//                    let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
//                    return alphabet
//
//          } else if(textField == mobileTF || textField == emailTF || textField == pwdTF || textField == confirmPwdTF || textField == chooseLocationTF) {
//
//            return true
//
//          }else{
//
//            return false
//          }
//      }
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//
//        let locationgeocoder = CLGeocoder()
//        location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        locationgeocoder.reverseGeocodeLocation(location!, completionHandler: { placemarks, error in
//            DispatchQueue.main.async {
//                let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,longitude: place.coordinate.longitude,zoom: 15)
////                self.locationMapView.camera = camera
//            }
//            let placemark = placemarks?[0]
//            if let aPlacemark = placemark {
//                print("placemark: \(aPlacemark)")
//            }
////            self.isSearchLocation = true
//            print("zipcode: \(placemark?.postalCode ?? "")")
//            UserDefaults.standard.set(placemark?.postalCode ?? "", forKey: "pinCode")
//
//            let address = String(format : "%@,%@,%@,%@,%@,%@",placemark?.subThoroughfare ?? "",placemark?.thoroughfare ?? "",placemark?.subLocality ?? "",placemark?.locality ?? "" ,placemark?.subAdministrativeArea ?? "",placemark?.country ?? "",placemark?.postalCode ?? "")
//
//            self.addressStr = address
//
//            self.latt = place.coordinate.latitude
//            self.long = place.coordinate.longitude
//
//            print("address: \(address)")
//            self.locationTF.text = address
////            self.addressLabel.text = place.formattedAddress
//
//           self.destiMarker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//
//            let london = GMSMarker(position: self.destiMarker.position)
//            //        london.isFlat = true
//            london.isDraggable = true
////            london.map = self.locationMapView
//            london.title = address
//            london.icon = UIImage(named: "ic_location")
////            london.map = self.locationMapView
//
//            UserDefaults.standard.set(placemark?.locality ?? "", forKey: "pickedCity")
//            UserDefaults.standard.synchronize()
//
////            UserDefaults.standard.set(placemark?.subThoroughfare ?? "", forKey: "houseno")
//            self.dismiss(animated: true, completion: nil)
//
//        })
//
//    }
//
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//
//        // TODO: handle the error.
//        print("Error: ", error.localizedDescription)
//        dismiss(animated: true, completion: nil)
//
//    }
//
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        dismiss(animated: true, completion: nil)
//
//    }
//
//    //MARK: - location delegate methods
//func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    let userLocation :CLLocation = locations[0] as CLLocation
//
//
//    if(isUpdateLocation){
//
//        isUpdateLocation = false
//
//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
//
//    //    self.labelLat.text = "\(userLocation.coordinate.latitude)"
//    //    self.labelLongi.text = "\(userLocation.coordinate.longitude)"
//
//        latt = userLocation.coordinate.latitude
//        long = userLocation.coordinate.longitude
//
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
//            if (error != nil){
//                print("error in reverseGeocode")
//            }
//            let placemark = placemarks! as [CLPlacemark]
//            if placemark.count>0{
//                let placemark = placemarks![0]
//                print(placemark.locality!)
//                print(placemark.administrativeArea!)
//                print(placemark.country!)
//
//    //            self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
//
//                self.addressStr = "\(placemark.subLocality!) ,\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
//
//                let city = placemark.locality ??  "" as String
//
//                UserDefaults.standard.set(city, forKey: "pickedCity")
//                UserDefaults.standard.synchronize()
//
//                self.loadMapView()
//            }
//        }
//    }
//
//
//}
//
//func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//    print("Error \(error)")
//}

    
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}


