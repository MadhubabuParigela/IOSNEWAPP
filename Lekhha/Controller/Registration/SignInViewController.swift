//
//  SignInViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 16/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown
import CoreTelephony

class SignInViewController: UIViewController, UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    var isConsumer = "1"
    let dropDown = DropDown() //2
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    var loginIndividualServer = ServiceController()

    @IBOutlet weak var consumerRadioBtn: UIButton!
    
    @IBAction func consumerRadioBtnTap(_ sender: Any) {
        
        isConsumer = "1"
        
        vendorRadioBtn.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
        consumerRadioBtn.setImage(UIImage(named: "radio_active"), for: UIControl.State.normal)

    }
    
    @IBOutlet weak var mobileBtn: UIButton!
    @IBOutlet weak var mobileSelctTF: UITextField!
    
    @IBOutlet weak var vendorRadioBtn: UIButton!
    @IBOutlet weak var mobileDropView: UIView!
    @IBOutlet weak var mobileView: UIView!
    
    var countryArr = [CountryResultVo]()
    var countryNameArr = [String]()
    var countryCodeArr = [String]()
    var countryNameStr = ""
    var slectedCodeStr = ""
    var countryCodeStr = ""
    
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
                self?.mobileSelctTF.text = self?.slectedCodeStr
                if self?.countryCodeStr == self?.slectedCodeStr {
                    
                }
                else {
                    self?.view.makeToast("Invalid country")
                }
            }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
//        if(textView == chooseLocationTF){
//            self.loadMapView()
//
//        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        if(textField == chooseLocationTF){
//            self.loadMapView()
//
//        }
    }
    
    @IBAction func vendorRadioBtnTap(_ sender: Any) {
        
        isConsumer = "0"
        
//        self.showAlertWith(title: "Alert", message: "Vendor option is not available now")
        
        vendorRadioBtn.setImage(UIImage(named: "radio_active"), for: UIControl.State.normal)
        consumerRadioBtn.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
        
    }
    
    @IBOutlet weak var mobileTF: SDCTextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var pwdView: UIView!
    
    @IBAction func eyeBtnAction(_ sender: Any) {
        
        if eyeBtn.currentImage == UIImage(named: "eye-1"){
            eyeBtn.setImage(UIImage(named: "eye"), for: .normal)
            pwdTF.isSecureTextEntry = true
        }
        else {
            eyeBtn.setImage(UIImage(named: "eye-1"), for: .normal)
            pwdTF.isSecureTextEntry = false
        }
    }
    @IBAction func forgotPwdBtnTap(_ sender: Any) {
        
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordViewController
        //      self.navigationController?.pushViewController(VC, animated: true)
                VC.modalPresentationStyle = .fullScreen
//                self.present(VC, animated: true, completion:. nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBAction func validateBtnTap(_ sender: Any) {
        
//        if(isConsumer == "0"){
//            self.showAlertWith(title: "Alert", message: "Please select consumer")
//            return
//
//        }
        
        if mobileTF.text == ""
        {
//            self.view.makeToast("Enter your mobile number")
            self.showAlertWith(title: "Alert", message: "Enter your mobile number")
            return
        }
        let pNumber = mobileTF.text
        let pNumberTrim = pNumber!.replacingOccurrences(of: " ", with: "")
        if pNumberTrim.count < 10 {
//            self.view.makeToast("Must be 10 digits")
            self.showAlertWith(title: "Alert", message: "Must be 10 digits")
            return
        }
        if pwdTF.text == ""
        {
            self.showAlertWith(title: "Alert", message: "Enter your password")
            return
        }
        
//        if slectedCodeStr == countryCodeStr {
//
//            print("selectStr:\(countryNameStr)")
//        }
//        else {
//            self.view.makeToast("You cannot login with the selected country")
//            return
//        }
        callSignInAPI()
        
    }
    
    @IBAction func newUserBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
        VC.modalPresentationStyle = .fullScreen
//      self.navigationController?.pushViewController(VC, animated: true)
        VC.modalPresentationStyle = .fullScreen
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }
    let t = CTTelephonyNetworkInfo()
        
        func test() {
            print(UIDevice.current.systemVersion)
            for (id, carrier) in t.serviceSubscriberCellularProviders ?? [:] {
                print("\(id):")
                print("  \(carrier.mobileNetworkCode ?? "-")")
                print("  \(carrier.mobileCountryCode ?? "-")")
                print("  \(carrier.isoCountryCode ?? "-")")
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test()
        
        let telephonyInfo: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
              let carrierNetwork: String = telephonyInfo.currentRadioAccessTechnology ?? ""
              print("mobile network : \(carrierNetwork)")

              let carrier = telephonyInfo.subscriberCellularProvider

              let countryCode = carrier?.mobileCountryCode
              print("country code:\(String(describing: countryCode))")

              let mobileNetworkName = carrier?.mobileNetworkCode
              print("mobile network name:\(String(describing: mobileNetworkName))")

              let carrierName = carrier?.carrierName
              print("carrierName is : \(String(describing: carrierName))")

              let isoCountrycode = carrier?.isoCountryCode
              print("iso country code: \(String(describing: isoCountrycode))")
        
//        let str = CountryUtility.getLocalCountry()
        
        
        let emojiString = IsoCountryCodes.find(key: "IND")?.flag
        
        print(emojiString)
                
        if let countryCode = CountryUtility.getLocalCountryCode() {
            
            let codestr = IsoCountryCodes.find(key: countryCode)?.alpha3
             
            countryNameStr = IsoCountryCodes.find(key: countryCode)?.name ?? ""
            
            mobileSelctTF.text = codestr
            slectedCodeStr = codestr ?? ""
            self.countryCodeStr = codestr ?? ""

            if let alpha3 = CountryUtility.getCountryCodeAlpha3(countryCodeAlpha2: countryCode){
                        print(alpha3) ///result: PRT
            }
        }
        
        eyeBtn.setImage(UIImage(named: "eye"), for: .normal)
        
        mobileDropView.layer.borderColor = UIColor.gray.cgColor
        mobileDropView.layer.borderWidth = 0.5
        mobileDropView.layer.cornerRadius = 3
        mobileDropView.clipsToBounds = true
        
        mobileView.layer.borderColor = UIColor.gray.cgColor
        mobileView.layer.borderWidth = 0.5
        mobileView.layer.cornerRadius = 3
        mobileView.clipsToBounds = true
        
        pwdView.layer.borderColor = UIColor.gray.cgColor
        pwdView.layer.borderWidth = 0.5
        pwdView.layer.cornerRadius = 3
        pwdView.clipsToBounds = true
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        
        animatingView()
        mobileSelctTF.delegate = self
        
//        mobileSelctTF.optionArray = ["India-IND"]
//                Its Id Values and its optional
//        mobileSelctTF.optionIds = ["1"]
        
//        mobileSelctTF.arrow.arrowColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
//        mobileSelctTF.handleKeyboard = false
        mobileTF.delegate = self
        pwdTF.delegate = self
        mobileTF.maxLength = 10
        
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    //    view Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        getCountryList_APICall()
                
//        mobileSelctTF.didSelect { (selectedText , index ,id) in
//            print("Selected String: \(selectedText) \n index: \(index)")
//
//            if selectedText == "India-IND"{
//                self.mobileSelctTF.text = "IND"
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
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        mobileTF.resignFirstResponder()
        pwdTF.resignFirstResponder()
        
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
    //    should Change Characters In range
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
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
    }
    
//    func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    func keyboardWillHide(notification: NSNotification) {
//        if view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
    
 //  status code -- 203 == Email Verification
    //400 -- Invalid credentials
    
    func animatingView(){
        
        self.view.addSubview(activity)
                      
        activity.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = activity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthConstraint = activity.widthAnchor.constraint(equalToConstant: 50)
        let heightConstraint = activity.heightAnchor.constraint(equalToConstant: 50)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
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
    
        func callSignInAPI() {
            
            activity.startAnimating()
            self.view.isUserInteractionEnabled = true
            
                    let URLString_loginIndividual = Constants.BaseUrl + LoginUrl
//
//                        let params_IndividualLogin = [
//                            "mobileNumber":mobileTF.text ?? "",
//                            "passWord":pwdTF.text ?? "",
//                            "countryCode":countryCodeStr,
//                            "countryName":countryNameStr
//                        ]
            let params_IndividualLogin = [
                "mobileNumber":mobileTF.text ?? "",
                "passWord":pwdTF.text ?? "",
                "countryCode":"IND",
                "countryName":"India"
            ]
                        print(params_IndividualLogin)
                    
                        let postHeaders_IndividualLogin = ["":""]
                        
                        loginIndividualServer.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                            
                            let respVo:Login_IndividualRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            let statusCode = respVo.statusCode
                            let token = respVo.token
        
                            let resultArr = respVo.result?[0] as? NSDictionary
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            
                            if status == "SUCCESS" {
                                print("Success")
                                
                                if(statusCode == 200){ //Success
                                    
                                    var userId = String()
                                    var firstName = String()
                                    var lastName = String()
                                    var mobileStatus = String()
                                    var mobileNoStr = String()
                                    var emailStr = String()
                                    var fullName = String()
                                    if respVo.result?.count ?? 0>0
                                    {
                                        userId = respVo.result![0]._id ?? ""
                                     firstName = respVo.result![0].firstName ?? ""
                                     lastName = respVo.result![0].last_name ?? ""
                                     mobileStatus = respVo.result![0].mobileStatus ?? ""
                                    fullName = firstName + " " + lastName
                                        mobileNoStr = respVo.result![0].mobileNumber ?? ""
                                        emailStr = respVo.result![0].emailId ?? ""
                                        
                                        
                                        let pLatestStatus = respVo.result![0].privacypolicy_latest_version
                                        let pAcceptedStatus = respVo.result![0].privacypolicy_accepted_version
                                        
                                        let tLatestStatus = respVo.result![0].termsandconditions_latest_version
                                        let tAcceptedStatus = respVo.result![0].termsandconditions_accepted_version
                                        
                                    let userDefaults = UserDefaults.standard
                                    userDefaults.set(userId, forKey: "userID")
                                    userDefaults.set(token, forKey: "token")
                                    userDefaults.set(fullName, forKey: "fullName")
                                    userDefaults.set(mobileNoStr, forKey: "mobileNum")
                                    userDefaults.set(emailStr, forKey: "emailId")
                                    
                                    userDefaults.set(self.countryCodeStr, forKey: "countryCode")
                                    userDefaults.set(self.countryNameStr, forKey: "countryName")
                                    
//                                    userDefaults.set(true, forKey: "isLoggedIn")
                                    
                                    userDefaults.synchronize()
                                    
                                    if mobileStatus == "Enrolled" {
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let VC = storyBoard.instantiateViewController(withIdentifier: "OTPVC") as! OTPViewController
                                        VC.modalPresentationStyle = .fullScreen
                                        VC.isManual = "Manual"
                                        self.navigationController?.pushViewController(VC, animated: true)
                                    }
                                    else {
                                        
                                        if pLatestStatus == pAcceptedStatus && tLatestStatus == tAcceptedStatus {
                                            
                                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                            let VC = storyBoard.instantiateViewController(withIdentifier: "SelectAccountVC") as! SelectAccountViewController
                                            VC.isConsumerStatus = self.isConsumer
                                            VC.mobileNumString=self.mobileTF.text ?? ""
                                            VC.passwordStr = self.pwdTF.text ?? ""
                                            VC.modalPresentationStyle = .fullScreen
                                            self.navigationController?.pushViewController(VC, animated: true)
                                        }
                                        else {
                                                                        
                                            let userDefaults = UserDefaults.standard
                                            if pLatestStatus != pAcceptedStatus && tLatestStatus != tAcceptedStatus {
                                            
                                                userDefaults.set("PrivacyTerms", forKey: "isPrivacyTerms")
                                                
                                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
                                                VC.isConsumerStatus = self.isConsumer
                                                VC.mobileNumString = self.mobileTF.text ?? ""
                                                VC.passwordStr = self.pwdTF.text ?? ""
                                                VC.isLogin = true
                                                VC.headerStr = "Privacy Policy"
                                                VC.latestVStr = pLatestStatus ?? ""
                                                VC.tLatestVStr = tLatestStatus ?? ""
                                                self.navigationController?.pushViewController(VC, animated: true)
                                                
                                            }
                                            else {
                                                
                                                if pLatestStatus != pAcceptedStatus {
                                                    
                                                    userDefaults.set("Privacy", forKey: "isPrivacyTerms")
                                                    
                                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                    let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
                                                    VC.isConsumerStatus = self.isConsumer
                                                    VC.mobileNumString = self.mobileTF.text ?? ""
                                                    VC.passwordStr = self.pwdTF.text ?? ""
                                                    VC.isLogin = true
                                                    VC.headerStr = "Privacy Policy"
                                                    VC.latestVStr = pLatestStatus ?? ""
                                                    self.navigationController?.pushViewController(VC, animated: true)
                                                }
                                                else {
                                                    
                                                    if tLatestStatus != tAcceptedStatus {
                                                        
                                                        userDefaults.set("Terms", forKey: "isPrivacyTerms")
                                                        
                                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                        let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
                                                        VC.isConsumerStatus = self.isConsumer
                                                        VC.mobileNumString = self.mobileTF.text ?? ""
                                                        VC.passwordStr = self.pwdTF.text ?? ""
                                                        VC.isLogin = true
                                                        VC.headerStr = "Terms of use"
                                                        VC.latestVStr = tLatestStatus ?? ""
                                                        self.navigationController?.pushViewController(VC, animated: true)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    }
                                    
                                }else if(statusCode == 203){ //Email Verification
                                    
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let VC = storyBoard.instantiateViewController(withIdentifier: "EmailValidateVC") as! EmailValidationViewController
                                                //      self.navigationController?.pushViewController(VC, animated: true)
                                    VC.modalPresentationStyle = .fullScreen
//                                    self.present(VC, animated: true, completion: nil)
                                    self.navigationController?.pushViewController(VC, animated: true)

                                }else{
                                    self.showAlertWith(title: "Alert", message: "Invalid Credentials")
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
