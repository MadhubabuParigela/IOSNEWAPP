//
//  DetailsNewViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 12/03/22.
//

import UIKit
import ObjectMapper
import GoogleSignIn

class DetailsNewViewController: UIViewController, SendingHomeDelegateProtocol {
  
    @IBOutlet var reenterPwdHeight: NSLayoutConstraint!//45
    @IBOutlet var reenterpwdTop: NSLayoutConstraint!//12
    
    @IBAction func onClickPWDEYE(_ sender: Any) {
        
        if pwdEyeButton.currentImage == UIImage(named: "eye-1"){
            pwdEyeButton.setImage(UIImage(named: "eye"), for: .normal)
            passwordTF.isSecureTextEntry = true
        }
        else {
            pwdEyeButton.setImage(UIImage(named: "eye-1"), for: .normal)
            passwordTF.isSecureTextEntry = false
        }
    }
    @IBOutlet var pwdEyeButton: UIButton!
    @IBOutlet var reenterPwdEyeButton: UIButton!
    @IBAction func onClickREEnterPWDEYE(_ sender: Any) {
        
        if reenterPwdEyeButton.currentImage == UIImage(named: "eye-1"){
            reenterPwdEyeButton.setImage(UIImage(named: "eye"), for: .normal)
            re_enterTF.isSecureTextEntry = true
        }
        else {
            reenterPwdEyeButton.setImage(UIImage(named: "eye-1"), for: .normal)
            re_enterTF.isSecureTextEntry = false
        }
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
    
    var country_code=String()
    var existing_user=[String:AnyObject]()
    var userListArr = [MobileResultVo]()
    var mobile_no_exists=Bool()
    var pageContentArr = [PageContentResultVo]()
    
    var isTermsChecked:Bool = false
    var isPrivachChecked:Bool = false
    var userEisted=String()
    var networkCode=String()
    var introService=ServiceController()
        
    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var re_enterTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    
    @IBOutlet weak var termsCheckBtn: UIButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var privacyCheckBtn: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    
    
    @IBAction func onClickgoogleLogin(_ sender: Any) {
        
        let signInConfig = GIDConfiguration.init(clientID: "976753428495-vq0j414cqq63dv33jjk8dfe5rsn2mvqj.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
           guard error == nil else { return }
            
//            user?.profile?.familyName
//            user?.profile?.email
//            user?.profile?.name
//            user?.profile?.givenName
            if user != nil {
                signUpFirstName = user?.profile?.givenName ?? ""
                signUpLastName = user?.profile?.familyName ?? ""
                userEmailID = user?.profile?.email ?? ""
                self.emailTF.text=user?.profile?.email ?? ""
                signUpTypeGlobal = "Gmail"
                self.view.makeToast("Google details is added successfully")
            }
           // If sign in succeeded, display the app's main content View.
         }
    }
    @IBAction func onClickFacebookLogin(_ sender: Any) {
        
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (dataDictionary:Dictionary<String, AnyObject>?, error:NSError?) -> Void in
            
            print("dataDictionary:\(dataDictionary)")
            
            if dataDictionary != nil {
                
                let respVo:FacebookRespVo = Mapper().map(JSON: dataDictionary as! [String : Any])!
                signUpFirstName = respVo.first_name ?? ""
                signUpLastName = respVo.last_name ?? ""
                userEmailID = respVo.email ?? ""
                self.emailTF.text=respVo.email ?? ""
                signUpTypeGlobal = "Facebook"
                self.view.makeToast("Facebook details is added successfully")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pwdEyeButton.setImage(UIImage(named: "eye"), for: .normal)
        passwordTF.isSecureTextEntry = true
        reenterPwdEyeButton.setImage(UIImage(named: "eye"), for: .normal)
        re_enterTF.isSecureTextEntry = true
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userNameTF.text = networkCode + phoneNumber
        if userExists=="Yes"
        {
            reenterPwdHeight.constant=0
            re_enterTF.isHidden=true
            reenterpwdTop.constant=0
            let userDetailsArr = userListArr[0]
        
                self.privacyCheckBtn.setImage(UIImage(named: "checkBoxActive"), for: .normal)
                self.privacyCheckBtn.isUserInteractionEnabled = false
                self.isPrivachChecked = true
  
                self.termsCheckBtn.setImage(UIImage(named: "checkBoxActive"), for: .normal)
                self.termsCheckBtn.isUserInteractionEnabled = false
                self.isTermsChecked = true
            reenterPwdEyeButton.isHidden=true
            reenterPwdEyeButton.isUserInteractionEnabled=false
        }
        else
        {
            reenterPwdHeight.constant=45
            re_enterTF.isHidden=false
            reenterpwdTop.constant=12
            self.privacyCheckBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
            self.privacyCheckBtn.isUserInteractionEnabled = true
            self.isPrivachChecked = false

            self.termsCheckBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
            self.termsCheckBtn.isUserInteractionEnabled = true
            self.isTermsChecked = false
            reenterPwdEyeButton.isHidden=false
            reenterPwdEyeButton.isUserInteractionEnabled=true
        }
    }
    
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
    func isValidPassword(passwordStr:String) -> Bool {
        let password = passwordStr
        let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{6,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
    }   
    
    @IBAction func onClickNextButton(_ sender: Any) {
        let strLength = passwordTF.text?.count ?? 0
        if userNameTF.text=="" || passwordTF.text=="" || emailTF.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please enter all fields")
        }
        if(isValidPassword(passwordStr: passwordTF.text ?? "") == false){
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
        if userExists == "No"
        {
        if re_enterTF.text == ""
        {
            self.showAlertWith(title: "Alert", message: "Enter your confirm password")
            return
        }
        
        else if(passwordTF.text != re_enterTF.text)
        {
            self.showAlertWith(title: "Alert", message: "Password and confirm password do not match")
            return
        }
        }
        if isTermsChecked==false
        {
            self.showAlertWith(title: "Alert", message: "Terms and condition should be checked")
            return
        }
        else if isPrivachChecked==false
        {
           self.showAlertWith(title: "Alert", message: "Privacy policy should be checked")
           return
       }
        else
        {
            self.getConsumerUserDetailsAdd()
        }
    }
    
    func getConsumerUserDetailsAdd()
    {
        userEmailID=emailTF.text ?? ""
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
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + consumerUserDetailsAdd
        let params = ["userName":userNameTF.text!,"passWord":passwordTF.text!,"emailId":emailTF.text!,"deviceInfo":deviceInfoDict,"mobileNumber":phoneNumber,"signUpType":signUpTypeGlobal,"countryCode":"IND"] as [String : Any]
        let postHeaders_IndividualLogin = ["":""]
        
        introService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                            let respVo:AccountInfo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            let statusCode = respVo.statusCode
            var accountInfo=[AccountInfoResultVo]()
            accountInfo=respVo.result ?? [AccountInfoResultVo]()
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
           
            var accountExist1:Bool = false
            var userExist:Bool = false
            var mailVerificationPending:Bool = true
            var accountInfStatus=String()
            var accountStatus=String()
            
            if accountInfo.count>0
            {
                let resultObject:AccountInfoResultVo=accountInfo[0]
                accountInfStatus=resultObject.accountInfoStatus ?? ""
                accountStatus=resultObject.accountStatus ?? ""
                signUpTypeGlobal=resultObject.signUpType ?? ""
                signUpUserAccountDetailArray=accountInfo
                
            }
            
            if self.userListArr.count > 0  {
                
                let userDetailsArr = self.userListArr[0]
                
                    if let userExist1 = userDetailsArr.mobileStatus
                    {
                    if userExist1 == "Completed" || userExist1 == "completed"{
                        userExist = true
                        userDetailsExists=true
                    }
                        else
                    {
                        userDetailsExists=false
                    }
                }
            }
            if accountInfStatus == "Completed" || accountInfStatus == "completed"
            {
                accountExist1 = true
                accountExists=true
            }
            else
            {
                accountExists=false
            }
            if accountStatus == "registered"
            {
                mailVerificationPending = false;
            }
            
            if (((!accountExist1) || (!userExist) || mailVerificationPending) && status == "SUCCESS" && statusCode == 200) {

                if signUpTypeGlobal=="Manual" && mailVerificationPending {

                                           let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                    let VC = storyBoard.instantiateViewController(withIdentifier: "ConfirmationLinkViewController") as! ConfirmationLinkViewController
                    VC.messageStr = messageResp ?? ""
                    VC.emailId=self.emailTF.text ?? ""
                    self.navigationController?.pushViewController(VC, animated: true)
                                        } else {

                                            let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                                            let VC = storyBoard.instantiateViewController(withIdentifier: "VerifyAccountViewController") as! VerifyAccountViewController
                                            self.navigationController?.pushViewController(VC, animated: true)
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
    
    
    
    @IBAction func onClickTermsandCondition(_ sender: UIButton) {
        
        if termsBtn.currentImage == UIImage(named: "checkBoxInactive"){
            termsBtn.setImage(UIImage(named: "checkBoxActive"), for: .normal)
            isTermsChecked = true
        }
        else {
            isTermsChecked = false
            termsBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
        }
    }
    
    @IBAction func onClickPrivacyPolicy(_ sender: UIButton) {
        
        if privacyBtn.currentImage == UIImage(named: "checkBoxInactive"){
            privacyBtn.setImage(UIImage(named: "checkBoxActive"), for: .normal)
            isPrivachChecked = true
        }
        else {
            isPrivachChecked = false
            privacyBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
        }
    }
    
}
