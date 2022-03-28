//
//  ForgotPasswordViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 16/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown

class ForgotPasswordViewController: UIViewController , UITextFieldDelegate{
    
    @IBAction func signInBtnTap(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    var OTPServerice = ServiceController()
    
    var otpSTR1 = String()
    var otpSTR2 = String()
    var otpSTR3 = String()
    var otpSTR4 = String()
    var finalOTPStr = String()

    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var mobileDropView: UIView!
    @IBOutlet weak var mobileDropDownTF: UITextField!
    @IBOutlet weak var mobileBtn: UIButton!
    
    @IBOutlet weak var mobileTF: UITextField!
    
    @IBAction func sendOTPBtnTap(_ sender: Any) {
        
        if(mobileTF.text == ""){
            self.showAlertWith(title: "Alert", message:"Enter mobile number" )
            return
        }
        
        sendOTP()
    }
    let dropDown = DropDown() //2
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
                self?.mobileDropDownTF.text = self?.slectedCodeStr
                if self?.countryCodeStr == self?.slectedCodeStr {
                    
                }
                else {
                    self?.view.makeToast("Invalid country")
                }
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
    
    @IBOutlet weak var otpTF1: UITextField!
    @IBOutlet weak var otpTF2: UITextField!
    @IBOutlet weak var otpTF3: UITextField!
    @IBOutlet weak var otpTF4: UITextField!
    
    @IBAction func resendOTPTap(_ sender: Any) {
        
        if(mobileTF.text == ""){
            self.showAlertWith(title: "Alert", message:"Enter mobile number" )
            return
        }
        
        sendOTP()

    }
    
    @IBAction func submitBtnTap(_ sender: Any) {
        
        finalOTPStr = otpSTR1 + otpSTR2 + otpSTR3 + otpSTR4

        if mobileTF.text == ""{
            self.showAlertWith(title: "Alert", message: "Please enter mobile number")
            return
            
        }
        
        if slectedCodeStr == countryCodeStr {
            
            print("selectStr:\(countryNameStr)")
        }
        else {
            self.view.makeToast("Invalid country code")
            return
        }
        
        if(otpSTR1 == "" || otpSTR2 == "" || otpSTR3 == "" || otpSTR4 == ""){
            self.showAlertWith(title: "Alert", message: "Enter OTP")
            return
            
        }        
        
        callVerifyOTPAPI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobileTF.delegate = self
        
        mobileDropView.layer.borderColor = UIColor.gray.cgColor
        mobileDropView.layer.borderWidth = 0.5
        mobileDropView.layer.cornerRadius = 3
        mobileDropView.clipsToBounds = true
        
        mobileView.layer.borderColor = UIColor.gray.cgColor
        mobileView.layer.borderWidth = 0.5
        mobileView.layer.cornerRadius = 3
        mobileView.clipsToBounds = true
                
        if let countryCode = CountryUtility.getLocalCountryCode() {
            
            let codestr = IsoCountryCodes.find(key: countryCode)?.alpha3
             
            countryNameStr = IsoCountryCodes.find(key: countryCode)?.name ?? ""
            
            mobileDropDownTF.text = codestr
            slectedCodeStr = codestr ?? ""
            self.countryCodeStr = codestr ?? ""
        }
        
//        mobileDropDownTF.optionArray = ["India-IND"]
//                Its Id Values and its optional
//        mobileDropDownTF.optionIds = ["1"]
//        mobileDropDownTF.text = "IND"
//        mobileDropDownTF.arrow.arrowColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
//        mobileDropDownTF.handleKeyboard = false
//        mobileDropTF.delegate = self
        
        animatingView()
        
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

        otpTF1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTF2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTF3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTF4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    //    view Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        getCountryList_APICall()
                
//        mobileDropDownTF.didSelect { (selectedText , index ,id) in
//            print("Selected String: \(selectedText) \n index: \(index)")
//
//            if selectedText == "India-IND"{
//                self.mobileDropDownTF.text = "IND"
//            }
//        }
       
    }
    
    func getCountryList_APICall() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + GetAllCountriesUrl
        
        OTPServerice.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in
            
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
        otpTF1.resignFirstResponder()
        otpTF2.resignFirstResponder()
        otpTF3.resignFirstResponder()
        otpTF4.resignFirstResponder()
        
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

       
       @objc func textFieldDidChange(textField: UITextField){
           let text = textField.text
           if  text?.count == 1 {
               switch textField{
               case otpTF1:
                   otpSTR1 = (textField.text ?? "") as String
                   otpTF2.becomeFirstResponder()
               case otpTF2:
                   otpSTR2 = (textField.text ?? "") as String
                   otpTF3.becomeFirstResponder()
               case otpTF3:
                   otpSTR3 = (textField.text ?? "") as String
                   otpTF4.becomeFirstResponder()
               case otpTF4:
                   otpSTR4 = (textField.text ?? "") as String
                   otpTF4.resignFirstResponder()
               default:
                   break
               }
           }
           if  text?.count == 0 {
               switch textField{
               case otpTF1:
                   otpSTR1 = ""
                   otpTF1.becomeFirstResponder()
               case otpTF2:
                   otpSTR2 = ""
                   otpTF1.becomeFirstResponder()
               case otpTF3:
                   otpSTR3 = ""
                   otpTF2.becomeFirstResponder()
               case otpTF4:
                   otpSTR4 = ""
                   otpTF3.becomeFirstResponder()
               default:
                   break
               }
           }
           else{

           }
       }
    
    @IBOutlet weak var resendOTPBtn: UIButton!
    
    func sendOTP(){
        
        resendOTPBtn.isEnabled = true
        resendOTPBtn.isUserInteractionEnabled = true
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
    
                               let mobileNumStr = mobileTF.text!

                                let URLString_loginIndividual = Constants.BaseUrl + FogotPwdSendOTPUrl + mobileNumStr
                        
                                    let params_IndividualLogin = [
                                        "mobileNumber":mobileTF.text ?? ""]
                                
                                    print(params_IndividualLogin)
                                
                                    let postHeaders_IndividualLogin = ["":""]
                                    
                                    OTPServerice.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    print("Success")
                                    
                                    if(statusCode == 200){ //Success
                                        
                                self.showAlertWith(title: "Suceess", message:"OTP sent to your mobile number" )
                                return


                                    }
                                    else{
                                        
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
    
    func callVerifyOTPAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let mobileNumStr = mobileTF.text!
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(mobileNumStr, forKey: "forgetMobile")

//        let countryStr = userDefaults.value(forKey: "countryCode") ?? ""
//        let countryNameStr = userDefaults.value(forKey: "countryName") ?? ""
        
        userDefaults.synchronize()
            
                    let URLString_loginIndividual = Constants.BaseUrl + ForgotPwdOTPVerificationUrl + mobileNumStr + "/" + finalOTPStr
                        
                                    let params_IndividualLogin = [
                                        "mobileNumber":mobileTF.text ?? "",
                                        "otp": finalOTPStr ,
                                        "countryCode":countryCodeStr,
                                        "countryName":countryNameStr
                                    ]
                                    print(params_IndividualLogin)
                                    let postHeaders_IndividualLogin = ["":""]
                                    
                                  OTPServerice.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                            let respVo:OTPRespoVO = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let VC = storyBoard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordViewController
                            VC.modalPresentationStyle = .fullScreen
//                            self.present(VC, animated: true, completion: nil)
                        self.navigationController?.pushViewController(VC, animated: true)


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
