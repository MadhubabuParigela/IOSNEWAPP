//
//  OTPViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 18/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown

class OTPViewController: UIViewController {
    
    var OTPServerice = ServiceController()
    
    var otpSTR1 = String()
    var otpSTR2 = String()
    var otpSTR3 = String()
    var otpSTR4 = String()
    var finalOTPStr = String()
    
    let dropDown = DropDown() //2
    var isManual = ""
    var mobileStr = ""
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var mobileDropTF: UITextField!
    
    @IBAction func sendOTPBtnTap(_ sender: Any) {
        callSendOTP()
        
    }
    @IBOutlet weak var otpTF1: UITextField!
    @IBOutlet weak var otpTF2: UITextField!
    @IBOutlet weak var otpTF3: UITextField!
    @IBOutlet weak var otpTF4: UITextField!

    @IBOutlet weak var mobileBgView: UIView!
    @IBOutlet weak var mobileDropView: UIView!
    @IBOutlet weak var resendOTPBtn: UIButton!
    @IBAction func resendOTPBtnTap(_ sender: Any) {
        
        if(mobileTF.text == ""){
            self.showAlertWith(title: "Alert", message:"Enter mobile number" )
            return
        }
        
        callSendOTP()

    }
    @IBAction func mobileDropBtnAction(_ sender: UIButton) {
        
        dropDown.dataSource = ["India-IND"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.mobileDropTF.text = "IND"
            }
    }
    
    func sendOTP(){
        
        resendOTPBtn.isEnabled = true
        resendOTPBtn.isUserInteractionEnabled = true
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
                    let mobileNumStr = mobileTF.text!
            
                    let URLString_loginIndividual = Constants.BaseUrl + sendOTPUrl + mobileNumStr
            
                        let params_IndividualLogin = [
                            "mobileNumber":mobileTF.text ?? "",
                            "otp": finalOTPStr ,
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
                                
                                self.showAlertWith(title: "Alert", message: "OTP sent to your mobile number")

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
    
    @IBAction func submitBtnTap(_ sender: Any) {
        
        finalOTPStr = otpSTR1 + otpSTR2 + otpSTR3 + otpSTR4

        if(otpSTR1 == "" || otpSTR2 == "" || otpSTR3 == "" || otpSTR4 == ""){
//            self.view.makeToast("Please enter OTP")
            
            self.showAlertWith(title: "Alert", message: "Please enter OTP")
            return
            
        }
        callOTPAPI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobileBgView.layer.borderColor = UIColor.gray.cgColor
        mobileBgView.layer.borderWidth = 0.5
        mobileBgView.layer.cornerRadius = 3
        mobileBgView.clipsToBounds = true
        
        mobileDropView.layer.borderColor = UIColor.gray.cgColor
        mobileDropView.layer.borderWidth = 0.5
        mobileDropView.layer.cornerRadius = 3
        mobileDropView.clipsToBounds = true
        
        self.mobileDropTF.text = "IND"
        
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

//        let userDict = UserDefaults.standard.dictionary(forKey: "user_dict")! as NSDictionary
//        print(userDict)
//        print(UserDefaults.standard.value(forKey: "mobileNum"))
        let mobileNum = UserDefaults.standard.value(forKey: "mobileNum")
        mobileTF.text = mobileNum as? String

        otpTF1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTF2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTF3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTF4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        
        sendOTP()

       }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        mobileTF.resignFirstResponder()
        otpTF1.resignFirstResponder()
        otpTF2.resignFirstResponder()
        otpTF3.resignFirstResponder()
        otpTF4.resignFirstResponder()
        
    }
    
    @IBAction func signInBtnTap(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)

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
    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    
    func callOTPAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        let userDefaults = UserDefaults.standard
        let emailID = userDefaults.value(forKey: "emailId") as! String
        let mobileNumStr = mobileTF.text ?? ""
        let URLString_loginIndividual = Constants.BaseUrl + OTPUrl + mobileNumStr + "/" + finalOTPStr + "/" + emailID
        
        let params_IndividualLogin = [
            "mobileNumber":mobileTF.text ?? "",
            "otp": finalOTPStr,
        ]
        
        print(params_IndividualLogin)
        
        let postHeaders_IndividualLogin = ["":""]
        
        OTPServerice.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in
            
            let respVo:OTPRespoVO = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if statusCode == 200 {
                
                if status == "SUCCESS" {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyBoard.instantiateViewController(withIdentifier: "EmailValidateVC") as! EmailValidationViewController
                    VC.modalPresentationStyle = .fullScreen
                    VC.isManual = self.isManual
                    self.navigationController?.pushViewController(VC, animated: true)
                }
                else {
                    self.showAlert1With(title: "Alert", message: messageResp ?? "")
                }
            }
            else {
                self.showAlert1With(title: "Alert", message: messageResp ?? "")
            }
            
        }) { (error) in
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
        }
        
    }
    
    func callSendOTP() {
        
        resendOTPBtn.isEnabled = false
        resendOTPBtn.isUserInteractionEnabled = false
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
                    let mobileNumStr = mobileTF.text!
            
                    let URLString_loginIndividual = Constants.BaseUrl + sendOTPUrl + mobileNumStr
            
                        let params_IndividualLogin = [
                            "mobileNumber":mobileTF.text ?? "",
                            "otp": finalOTPStr ,
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
                                
                                self.showAlertWith(title: "Alert", message: "OTP sent to your mobile number")

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
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
