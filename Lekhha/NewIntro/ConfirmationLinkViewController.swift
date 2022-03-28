//
//  ConfirmationLinkViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 12/03/22.
//

import UIKit
import ObjectMapper

class ConfirmationLinkViewController: UIViewController {
    
    var messageStr = ""

    @IBOutlet weak var openEmailBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var emailId=String()
    var serviceVC = ServiceController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.makeToast(messageStr)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickOpenEmailButton(_ sender: Any) {
        
//        let googleUrlString = "googlegmail://"
//
//        if let googleUrl = URL(string: googleUrlString) {
//            UIApplication.shared.open(googleUrl, options: [:]) {
//                success in
//                if !success {
//                     // Notify user or handle failure as appropriate
//                }
//            }
//        }
//        else {
//            print("Could not get URL from string")
//        }
//        let appURL = URL(string: "mailto:\(userEmailID)")!
//
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(appURL)
//        }
    }
   
    @IBAction func nextBtnAction(_ sender: Any) {        
        get_Check_emailVerify_APICall()
    }
    
   func get_Check_emailVerify_APICall() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + "consumer/getAccountDetailsByEmailId/\(userEmailID)"
        
        serviceVC.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in
            
            let respVo:EmailVerifyRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if statusCode == 200 {
                if status == "SUCCESS" {
                    if respVo.result != nil {
                        if respVo.result!.count > 0 {
                                           
                            let statusInfo = respVo.result![0].accountStatus ?? ""
                            
                            if statusInfo == "registered" || statusInfo == "Registered" {
                                
                                let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                                let VC = storyBoard.instantiateViewController(withIdentifier: "VerifyAccountViewController") as! VerifyAccountViewController
                                self.navigationController?.pushViewController(VC, animated: true)
                            }
                            
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            
                            let alert = UIAlertController(title: "Alert", message: "Your email not verified. Do you want to proced next?", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "No",style: UIAlertAction.Style.destructive,handler: {(_: UIAlertAction!) in
                                print("No")
                            }))
                            
                            alert.addAction(UIAlertAction(title: "Yes",style: UIAlertAction.Style.destructive,handler: {(_: UIAlertAction!) in
                                
                                let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                                let VC = storyBoard.instantiateViewController(withIdentifier: "VerifyAccountViewController") as! VerifyAccountViewController
                                self.navigationController?.pushViewController(VC, animated: true)
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                }
                else {
                    
                    DispatchQueue.main.async {
                        
                        let alert = UIAlertController(title: "Alert", message: "Your email not verified. Do you want to proced next?", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "No",style: UIAlertAction.Style.destructive,handler: {(_: UIAlertAction!) in
                            print("No")
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Yes",style: UIAlertAction.Style.destructive,handler: {(_: UIAlertAction!) in
                            
                            let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                            let VC = storyBoard.instantiateViewController(withIdentifier: "VerifyAccountViewController") as! VerifyAccountViewController
                            self.navigationController?.pushViewController(VC, animated: true)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            else {
                
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "Alert", message: "Your email not verified. Do you want to proced next?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "No",style: UIAlertAction.Style.destructive,handler: {(_: UIAlertAction!) in
                        print("No")
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Yes",style: UIAlertAction.Style.destructive,handler: {(_: UIAlertAction!) in
                        
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }) { (error) in
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
        }
    }
    var introService=ServiceController()
    @IBAction func onClickResendEmailButton(_ sender: Any) {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        do {
            
            let URLString_loginIndividual = Constants.BaseUrl + resendEmailNew + ""
                                            
                let postHeaders_IndividualLogin = ["":""]
                
            let dict = ["":""] as [String : Any]
                print(dict)

            introService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: dict as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                                    let respVo:OpenOrdersRespo = Mapper().map(JSON: result as! [String : Any])!
                                                            
                                    let status = respVo.status
                                    let messageResp = respVo.message
                                    let statusCode = respVo.statusCode
                                    
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                    
                                    let dataDict = result as! NSDictionary
                                    print(dataDict)
                    
                    if statusCode == 200 {
                        
                        if status == "SUCCESS" {
                            self.showAlertWith(title: "Alert", message: messageResp ?? "")
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
        catch{
            
            print("error")
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
 

}
