//
//  PhoneSignInViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 12/03/22.
//

import UIKit
import ObjectMapper
import DropDown

class PhoneSignInViewController: UIViewController {

    var dropDown=DropDown()    
    @IBOutlet weak var passwordEyeBtn: UIButton!
    @IBOutlet var phoneViewDropDown: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var mobileView: UIView!
    @IBOutlet var countryCodeTF: UITextField!
    @IBOutlet var phoneNumberTF: SDCTextField!
    @IBOutlet var passwordTF: SDCTextField!
    var introService=ServiceController()
    var countryArr = [CountryResultVo]()
    var countryNameArr = [String]()
    var countryCodeArr = [String]()
    var countryNameStr = ""
    var slectedCodeStr = ""
    var countryCodeStr = ""
    var networkCode = [String]()
    var selectedNetworkCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordEyeBtn.setImage(UIImage(named: "eye"), for: .normal)
        passwordTF.isSecureTextEntry = true
        
        phoneViewDropDown.layer.borderColor = UIColor.gray.cgColor
        phoneViewDropDown.layer.borderWidth = 0.5
        phoneViewDropDown.layer.cornerRadius = 3
        phoneViewDropDown.clipsToBounds = true
        
        mobileView.layer.borderColor = UIColor.gray.cgColor
        mobileView.layer.borderWidth = 0.5
        mobileView.layer.cornerRadius = 3
        mobileView.clipsToBounds = true
        
        passwordView.layer.borderColor = UIColor.gray.cgColor
        passwordView.layer.borderWidth = 0.5
        passwordView.layer.cornerRadius = 3
        passwordView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        phoneViewDropDown.layer.borderColor = UIColor.gray.cgColor
        phoneViewDropDown.layer.borderWidth = 0.5
        phoneViewDropDown.layer.cornerRadius = 3
        phoneViewDropDown.clipsToBounds = true
        
        mobileView.layer.borderColor = UIColor.gray.cgColor
        mobileView.layer.borderWidth = 0.5
        mobileView.layer.cornerRadius = 3
        mobileView.clipsToBounds = true
        
        passwordView.layer.borderColor = UIColor.gray.cgColor
        passwordView.layer.borderWidth = 0.5
        passwordView.layer.cornerRadius = 3
        passwordView.clipsToBounds = true
        countryCodeStr="IND"
        selectedNetworkCode="+91"
    }
    @IBAction func onClickCountryCodeButton(_ sender: Any) {
        dropDown.dataSource = self.networkCode
        dropDown.anchorView = sender as! AnchorView
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                self?.countryCodeTF.text=item
                self?.selectedNetworkCode=item
                self?.countryNameStr = self?.countryNameArr[index] ?? String()
                self?.slectedCodeStr = self?.countryCodeArr[index] ?? String()
                self?.countryCodeStr = self?.countryCodeArr[index] ?? String()
            }
    }
    @IBAction func onClickPasswordPrivacyButton(_ sender: Any) {
        
        if passwordEyeBtn.currentImage == UIImage(named: "eye-1"){
            passwordEyeBtn.setImage(UIImage(named: "eye"), for: .normal)
            passwordTF.isSecureTextEntry = true
        }
        else {
            passwordEyeBtn.setImage(UIImage(named: "eye-1"), for: .normal)
            passwordTF.isSecureTextEntry = false
        }
    }
    @IBAction func onClickSignInButton(_ sender: Any) {
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + consumerLogin
        let params = ["mobileNumber":self.phoneNumberTF.text ?? "","countryCode":countryCodeStr,"passWord":self.passwordTF.text ?? ""]
        let postHeaders_IndividualLogin = ["":""]
        
        introService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
            
            let respVo:Login_IndividualRespVO = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            let token = respVo.token
            _ = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if status == "SUCCESS" {
                
                if statusCode==200
                { //Success
                    
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
                                VC.isConsumerStatus = "1"
                                VC.mobileNumString = self.phoneNumberTF.text ?? ""
                                VC.passwordStr = self.passwordTF.text ?? ""
                                VC.modalPresentationStyle = .fullScreen
                                self.navigationController?.pushViewController(VC, animated: true)
                            }
                            else {
                                
                                let userDefaults = UserDefaults.standard
                                if pLatestStatus != pAcceptedStatus && tLatestStatus != tAcceptedStatus {
                                    
                                    userDefaults.set("PrivacyTerms", forKey: "isPrivacyTerms")
                                    
                                    //                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    //                                let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
                                    //                                VC.isConsumerStatus = "1"
                                    //                                VC.mobileNumString = self.phoneNumberTF.text ?? ""
                                    //                                VC.passwordStr = self.passwordTF.text ?? ""
                                    //                                VC.isLogin = true
                                    //                                VC.headerStr = "Privacy Policy"
                                    //                                VC.latestVStr = pLatestStatus ?? ""
                                    //                                VC.tLatestVStr = tLatestStatus ?? ""
                                    //                                self.navigationController?.pushViewController(VC, animated: true)
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let VC = storyBoard.instantiateViewController(withIdentifier: "SelectAccountVC") as! SelectAccountViewController
                                    VC.isConsumerStatus = "1"
                                    VC.mobileNumString = self.phoneNumberTF.text ?? ""
                                    VC.passwordStr = self.passwordTF.text ?? ""
                                    VC.modalPresentationStyle = .fullScreen
                                    self.navigationController?.pushViewController(VC, animated: true)
                                    
                                }
                                else {
                                    
                                    if pLatestStatus != pAcceptedStatus {
                                        
                                        userDefaults.set("Privacy", forKey: "isPrivacyTerms")
                                        
                                        //                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        //                                    let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
                                        //                                    VC.isConsumerStatus = "1"
                                        //                                    VC.mobileNumString = self.phoneNumberTF.text ?? ""
                                        //                                    VC.passwordStr = self.passwordTF.text ?? ""
                                        //                                    VC.isLogin = true
                                        //                                    VC.headerStr = "Privacy Policy"
                                        //                                    VC.latestVStr = pLatestStatus ?? ""
                                        //                                    self.navigationController?.pushViewController(VC, animated: true)
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let VC = storyBoard.instantiateViewController(withIdentifier: "SelectAccountVC") as! SelectAccountViewController
                                        VC.isConsumerStatus = "1"
                                        VC.mobileNumString = self.phoneNumberTF.text ?? ""
                                        VC.passwordStr = self.passwordTF.text ?? ""
                                        VC.modalPresentationStyle = .fullScreen
                                        self.navigationController?.pushViewController(VC, animated: true)
                                    }
                                    else {
                                        
                                        if tLatestStatus != tAcceptedStatus {
                                            
                                            userDefaults.set("Terms", forKey: "isPrivacyTerms")
                                            
                                            //                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                            //                                        let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
                                            //                                        VC.isConsumerStatus = "1"
                                            //                                        VC.mobileNumString = self.phoneNumberTF.text ?? ""
                                            //                                        VC.passwordStr = self.passwordTF.text ?? ""
                                            //                                        VC.isLogin = true
                                            //                                        VC.headerStr = "Terms of use"
                                            //                                        VC.latestVStr = tLatestStatus ?? ""
                                            //                                        self.navigationController?.pushViewController(VC, animated: true)
                                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                            let VC = storyBoard.instantiateViewController(withIdentifier: "SelectAccountVC") as! SelectAccountViewController
                                            VC.isConsumerStatus = "1"
                                            VC.mobileNumString = self.phoneNumberTF.text ?? ""
                                            VC.passwordStr = self.passwordTF.text ?? ""
                                            VC.modalPresentationStyle = .fullScreen
                                            self.navigationController?.pushViewController(VC, animated: true)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if(statusCode == 203){ //Email Verification
                    
                    let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                    let VC = storyBoard.instantiateViewController(withIdentifier: "ConfirmationLinkViewController") as! ConfirmationLinkViewController
                    //      self.navigationController?.pushViewController(VC, animated: true)
                    VC.modalPresentationStyle = .fullScreen
                    //                                    self.present(VC, animated: true, completion: nil)
                    self.navigationController?.pushViewController(VC, animated: true)
                    
                }else{
                    self.showAlertWith(title: "Alert", message: "Invalid Credentials")
                    activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
                
            }else {
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
    @IBAction func onClickForgotPasswordButton(_ sender: Any) {
    }
    @IBAction func onClickEmailButton(_ sender: Any) {
    }
    @IBAction func onClickGoogleButton(_ sender: Any) {
    }
    @IBAction func onClickFacebookButton(_ sender: Any) {
    }
    @IBAction func onClickAppleButton(_ sender: Any) {
    }
    @IBAction func onClickSignUpButton(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignUpNewViewController") as! SignUpNewViewController
        VC.modalPresentationStyle = .fullScreen
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
            
        })
        //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
        //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func getCountryList_APICall() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + GetAllCountriesNetworkUrl
        
        introService.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in
            
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
                                self.networkCode.append(obj.networkCode ?? "")
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
    
}

