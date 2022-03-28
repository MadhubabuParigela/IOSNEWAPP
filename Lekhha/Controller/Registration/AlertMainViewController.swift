//
//  AlertMainViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 01/03/22.
//

import UIKit
import ObjectMapper

class AlertMainViewController: UIViewController {
    var viewCntrlObj = UIViewController()
    
    var serviceVC = ServiceController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        let isChacked = userDefaults.value(forKey: "isCheckAccount") as! String
        
        if isChacked == "CheckAccount" {
            
            userDefaults.set("CheckAcc", forKey: "isCheckAccount")
            checkAccountForUser_API_Call()
        }
        else {
            showAlertWith(title: "Invalid Country", message: "You cannot use the application as logged in country does not match with your current country")
        }
                
        // Do any additional setup after loading the view.
    }
    
    func checkAccountForUser_API_Call() {
                
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        print(userID)
        let accountId = defaults.value(forKey: "accountId") as! String
        
        let URLString_loginIndividual = Constants.BaseUrl + CheckAccountsForUserUrl + userID + "/" + accountId
        
        serviceVC.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in
            
            let respVo:CheckAccountUserRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            let resultObj = respVo.result
                        
            if statusCode == 200 {
                
                if status == "SUCCESS" {
                    
                    if resultObj != nil {
                        
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(true, forKey: "isLoggedIn")
                        userDefaults.synchronize()
                        let primaryUser=respVo.result?[0].primaryUser
                        userDefaults.set(primaryUser, forKey: "primaryUser")
                        userDefaults.synchronize()
                        let modulePermissionDict = respVo.result?[0].modulePermissions
                        userDefaults.setValue(modulePermissionDict, forKey: "modulePermissions")
                        let accDict = respVo.result?[0].accountDetails
                        let minVicinityRange = accDict?.setVicinityMin ?? 0
                        let maxVicinityRange = accDict?.setVicinityMax ?? 0
                        userDefaults.setValue(minVicinityRange, forKey: "minVicinity")
                        userDefaults.setValue(maxVicinityRange, forKey: "maxVicinity")
                        
                        
                        let userDetails = respVo.result?[0].userDetails
                        
                        let pLatestStatus = userDetails?.privacypolicy_latest_version
                        let pAcceptedStatus = userDetails?.privacypolicy_accepted_version
                        
                        let tLatestStatus = userDetails?.termsandconditions_latest_version
                        let tAcceptedStatus = userDetails?.termsandconditions_accepted_version
                        
//                        let isconsumerStatus = userDefaults.string(forKey: "consumerStatus")
                        
                        if pLatestStatus == pAcceptedStatus && tLatestStatus == tAcceptedStatus {
                            
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
                            self.navigationController?.pushViewController(VC, animated: true)
                        }
                        else {
                                                        
                            let userDefaults = UserDefaults.standard
                            if pLatestStatus != pAcceptedStatus && tLatestStatus != tAcceptedStatus {
                            
                                userDefaults.set("PrivacyTerms", forKey: "isPrivacyTerms")
                                
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
                                VC.latestVStr = pLatestStatus ?? ""
                                VC.tLatestVStr = tLatestStatus ?? ""
                                VC.headerStr = "Privacy Policy"
                                VC.isBack = true
                                self.navigationController?.pushViewController(VC, animated: true)
                                
                            }
                            else {
                                
                                if pLatestStatus != pAcceptedStatus {
                                    
                                    userDefaults.set("Privacy", forKey: "isPrivacyTerms")
                                    
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
                                    VC.latestVStr = pLatestStatus ?? ""
                                    VC.headerStr = "Privacy Policy"
                                    VC.isBack = true
                                    self.navigationController?.pushViewController(VC, animated: true)
                                }
                                else {
                                    
                                    if tLatestStatus != tAcceptedStatus {
                                        
                                        userDefaults.set("Terms", forKey: "isPrivacyTerms")
                                        
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
                                        VC.latestVStr = tLatestStatus ?? ""
                                        VC.headerStr = "Terms of use"
                                        VC.isBack = true
                                        self.navigationController?.pushViewController(VC, animated: true)
                                    }
                                }
                            }
                        }
                    }
                    else {
                        
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
            
            let alertAction = UIAlertAction(title: "Logout", style: .default, handler: { (action) in
                self.moveTosignInVC()
            })
        
        let alertAction1 = UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                       UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                         exit(0)
                        }
            }
//            alertController.dismiss(animated: true, completion: nil)
        })

    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
           alertController.addAction(alertAction1)

        self.present(alertController, animated: true, completion: nil)
        
        }
    func moveTosignInVC() {

//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
//        VC.modalPresentationStyle = .fullScreen
//       // self.viewCntrlObj.present(VC, animated: true, completion: nil)
//
//        self.navigationController?.pushViewController(VC, animated: true)
        
        let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "PhoneSignInViewController") as! PhoneSignInViewController
        VC.modalPresentationStyle = .fullScreen
       // self.viewCntrlObj.present(VC, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(VC, animated: true)
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
