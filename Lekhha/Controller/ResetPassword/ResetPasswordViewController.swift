//
//  ResetPasswordViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 16/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper

class ResetPasswordViewController: UIViewController,UITextFieldDelegate {
    
    var loginIndividualServer = ServiceController()

    @IBOutlet weak var newPwdTF: UITextField!
    @IBOutlet weak var confirmPwdTF: UITextField!
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func resetPwdBtnTap(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animatingView()
        
        self.newPwdTF.delegate = self
        self.confirmPwdTF.delegate = self
        
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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        newPwdTF.resignFirstResponder()
        confirmPwdTF.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    func animatingView(){
        
        self.view.addSubview(activity)
                      
        activity.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = activity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthConstraint = activity.widthAnchor.constraint(equalToConstant: 50)
        let heightConstraint = activity.heightAnchor.constraint(equalToConstant: 50)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        let strLength = newPwdTF.text?.count ?? 0

        if newPwdTF.text == ""
        {
            self.showAlertWith(title: "Alert", message: "Enter new password")
            return
        }
        if(isValidPassword(passwordStr: newPwdTF.text ?? "") == false){
            self.showAlertWith(title: "Alert", message: "Password must contain minimum 6 characters, at least 1 number and 1 special character")
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
        else if confirmPwdTF.text == ""
        {
            self.showAlertWith(title: "Alert", message: "Enter confirm password")
            return
        }
        else if(newPwdTF.text != confirmPwdTF.text)
        {
            self.showAlertWith(title: "Alert", message: "Password and confirm password do not match")
            return
        }

        callResetPwdAPI()
        
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
    
//    {
//    "contact":{{emailId/MobileNumber}},
//    "passWord":{{new password}}
//    }
    
    func showSucessMsg()  {
        
                let alertController = UIAlertController(title: "Success", message:"Password changed successfully" , preferredStyle: .alert)
                //to change font of title and message.
                let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
                let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Success", attributes: titleFont)
                let messageAttrString = NSMutableAttributedString(string: "Password changed successfully", attributes: messageFont)
                alertController.setValue(titleAttrString, forKey: "attributedTitle")
                alertController.setValue(messageAttrString, forKey: "attributedMessage")
                
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                          let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
                          VC.modalPresentationStyle = .fullScreen
//                          self.present(VC, animated: true, completion: nil)
                    self.navigationController?.pushViewController(VC, animated: true)

                   
                })
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)

    }
    
    func callResetPwdAPI()  {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
         let defaults = UserDefaults.standard
         let mobile = defaults.string(forKey: "forgetMobile")
                        
                        let URLString_loginIndividual = Constants.BaseUrl + ResetPwdURL
                
                            let params_IndividualLogin = [
                                "contact":mobile,
                                "passWord":newPwdTF.text ?? "",
                            ]
                        
                            print(params_IndividualLogin)
                        
                            let postHeaders_IndividualLogin = ["":""]
                            
                            loginIndividualServer.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                                
                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    print("Success")
                                    
                                    if(statusCode == 200){ //Success
                                        self.showSucessMsg()
                                        
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

}
