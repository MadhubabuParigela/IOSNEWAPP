//
//  PrivacyPolicyViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 05/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import WebKit
import ObjectMapper

protocol SendingHomeDelegateProtocol {
    
    func getCheckValue(str:String)
}

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var privacyPolicyWebView: WKWebView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    var urlStr = ""
    var isChacked = ""
    var isLogin:Bool = false
    
    var loginIndividualServer = ServiceController()
    
    var isConsumerStatus = ""
    var mobileNumString = ""
    var passwordStr = ""
    var isPrivacy = ""
    var latestVStr = ""
    var tLatestVStr = ""
    var headerStr = ""
    var isBack:Bool = false
    
    var delegate: SendingHomeDelegateProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isBack == true {
            
            backBtn.isUserInteractionEnabled = false
            backBtn.isHidden = true
        }
        else {
            backBtn.isUserInteractionEnabled = true
            backBtn.isHidden = false
        }
        
        headerTitleLabel.text = headerStr
        
        let userDefaults = UserDefaults.standard
        isChacked = userDefaults.value(forKey: "isPrivacyTerms") as! String
        
                
        if isChacked == "PrivacyTerms" {
            
            urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/privacypolicy"
        }
        else if isChacked == "Privacy"{
            
            urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/privacypolicy"
        }
        else if isChacked == "Terms" {
            
            urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/termsandconditions"
        }
        else {
            
            
        }
        let url: URL! = URL(string: urlStr)
        privacyPolicyWebView.load(URLRequest(url: url))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func agreeBtnAction(_ sender: UIButton) {
        
        
        if isLogin == true {
            
            if isChacked == "PrivacyTerms" {
    //            endusers/privacypolicy_update
                privacypolicy_updateAPI()
            }
            else if isChacked == "Privacy"{
                
                urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/privacypolicy"
                privacypolicy_updateAPI()
            }
            else if isChacked == "Terms" {
                
    //            endusers/termaandconditions_update
                
                termsAndconditions_updateAPI()
                urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/termsandconditions"
                
            }
        }
        else {
            if isChacked == "PrivacyTerms" {
                
                termsAndconditions_updateAPI()
                
    //            endusers/privacypolicy_update
                
            }
            else if isChacked == "Privacy"{
                
    //            endusers/privacypolicy_update
                urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/privacypolicy"
                privacypolicy_updateAPI()
                
            }
            else if isChacked == "Terms" {
                
    //            endusers/termaandconditions_update
                urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/termsandconditions"
                termsAndconditions_updateAPI()
                            
            }
            else {
                
                if self.delegate != nil {
                    
                    if isPrivacy == "Privacy" {
                        self.delegate?.getCheckValue(str: "Privacy")
                    }
                    else {
                        self.delegate?.getCheckValue(str: "Terms")
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func privacypolicy_updateAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        
        
        let URLString_loginIndividual = Constants.BaseUrl + GetPrivacypolicyUpdateUrl
        
        let params_IndividualLogin = [
            "userId" : userID,
            "privacypolicy_accepted_version": latestVStr,
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
                    
                    if self.isChacked == "PrivacyTerms" {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyBoard.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
                        VC.urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/termsandconditions"
                        VC.isConsumerStatus = self.isConsumerStatus
                        VC.mobileNumString = self.mobileNumString
                        VC.passwordStr = self.passwordStr
                        VC.latestVersionStr = self.tLatestVStr
                        VC.isChacked = self.isChacked
                        self.navigationController?.pushViewController(VC, animated: true)
                    }
                    else if self.isChacked == "Privacy"{
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyBoard.instantiateViewController(withIdentifier: "SelectAccountVC") as! SelectAccountViewController
                        VC.isConsumerStatus = self.isConsumerStatus
                        VC.mobileNumString = self.mobileNumString
                        VC.passwordStr = self.passwordStr
                        VC.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(VC, animated: true)
                    }
                    else if self.isChacked == "Terms" {
                        
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyBoard.instantiateViewController(withIdentifier: "SelectAccountVC") as! SelectAccountViewController
                        VC.isConsumerStatus = self.isConsumerStatus
                        VC.mobileNumString = self.mobileNumString
                        VC.passwordStr = self.passwordStr
                        VC.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(VC, animated: true)
                    }
                    else {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
                        self.navigationController?.pushViewController(VC, animated: true)
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
    
    func termsAndconditions_updateAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        
        
        let URLString_loginIndividual = Constants.BaseUrl + GetTermaandconditionsUpdateUrl
        
        let params_IndividualLogin = [
            "userId" : userID,
            "termaandconditions_accepted_version": latestVStr,
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
                    
                    if self.isChacked == "PrivacyTerms" {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyBoard.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
                        VC.urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/termsandconditions"
                        VC.isConsumerStatus = self.isConsumerStatus
                        VC.mobileNumString = self.mobileNumString
                        VC.passwordStr = self.passwordStr
                        VC.latestVersionStr = self.tLatestVStr
                        self.navigationController?.pushViewController(VC, animated: true)
                    }
                    else if self.isChacked == "Privacy"{
                        
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyBoard.instantiateViewController(withIdentifier: "SelectAccountVC") as! SelectAccountViewController
                        VC.isConsumerStatus = self.isConsumerStatus
                        VC.mobileNumString = self.mobileNumString
                        VC.passwordStr = self.passwordStr
                        VC.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(VC, animated: true)
                    }
                    else if self.isChacked == "Terms" {
                        
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyBoard.instantiateViewController(withIdentifier: "SelectAccountVC") as! SelectAccountViewController
                        VC.isConsumerStatus = self.isConsumerStatus
                        VC.mobileNumString = self.mobileNumString
                        VC.passwordStr = self.passwordStr
                        VC.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(VC, animated: true)
                    }
                    else {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
                        self.navigationController?.pushViewController(VC, animated: true)
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
}
