//
//  TermsVC.swift
//  Lekhha
//
//  Created by USM on 03/03/22.
//

import UIKit
import WebKit
import ObjectMapper

class TermsVC: UIViewController {

    @IBOutlet weak var privacyPolicyWebView: WKWebView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    var urlStr = ""
    var isAgree:Bool = false
    var isLoginnn:Bool = false
    var loginIndividualServer = ServiceController()
    
    var isConsumerStatus = ""
    var mobileNumString = ""
    var passwordStr = ""
    var latestVersionStr = ""
    var isChacked = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        "http://35.154.239.192:4500/Misc/Files/pagecontent/privacypolicy"
        let url: URL! = URL(string: urlStr)
        privacyPolicyWebView.load(URLRequest(url: url))

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func agreeBtnAction(_ sender: UIButton) {
//        endusers/termaandconditions_update
                
        if isLoginnn == true {
            
            termsAndconditions_updateAPI()
        }
        else{
            
            termsAndconditions_updateAPI()
            
        }
                
//        self.navigationController?.popViewController(animated: true)
    }
    
    func termsAndconditions_updateAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        
        
        let URLString_loginIndividual = Constants.BaseUrl + GetTermaandconditionsUpdateUrl
        
        let params_IndividualLogin = [
            "userId" : userID,
            "termaandconditions_accepted_version": latestVersionStr,
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
