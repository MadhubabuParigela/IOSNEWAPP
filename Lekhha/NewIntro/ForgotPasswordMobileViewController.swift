//
//  ForgotPasswordMobileViewController.swift
//  Lekhha
//
//  Created by apple on 16/03/22.
//

import UIKit
import ObjectMapper

class ForgotPasswordMobileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var introService = ServiceController()
    @IBAction func onClickBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet var veriftTableView: UITableView!
    @IBOutlet var firstTF: UITextField!
    @IBOutlet var secondTF: UITextField!
    @IBOutlet var thirdTF: UITextField!
    @IBOutlet var fourthTF: UITextField!
    @IBAction func onClickVerifyButton(_ sender: Any) {
        if firstTF.text=="" || secondTF.text=="" || thirdTF.text=="" || fourthTF.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please enter valid OTP")
        }
        else
        {
        }
    }
    @IBAction func onClickResendOTPButton(_ sender: Any) {
        self.getMobileVerification()
    }
    @IBOutlet var timerLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        veriftTableView.separatorStyle = .none
        self.getMobileVerification()
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
    func getMobileVerification()
    {
        
//        sendOTPUrl
//        consumer/mobileverification/{{mobienumber}}/{{countryCode}}
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + mobileVerification
        let params = ["mobilenumber":phoneNumber]
        let postHeaders_IndividualLogin = ["":""]
        
        introService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                            }else {
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }

    }
    var otp=String()
    func getOTPVerification()
    {
    
    activity.startAnimating()
    self.view.isUserInteractionEnabled = true
    

        let URLString_loginIndividual = Constants.BaseUrl + mobileOTPVerification + phoneNumber + otp
                                
        introService.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                        let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        _ = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            
                            let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                            let VC = storyBoard.instantiateViewController(withIdentifier: "DetailsNewViewController") as! DetailsNewViewController
                            VC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(VC, animated: true)
                            
                        }else {
                            
                            self.showAlertWith(title: "Alert", message: messageResp ?? "")
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
