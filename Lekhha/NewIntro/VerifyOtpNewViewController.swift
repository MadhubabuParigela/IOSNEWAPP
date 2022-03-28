//
//  VerifyOtpNewViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 12/03/22.
//

import UIKit
import ObjectMapper
import OTPFieldView

class VerifyOtpNewViewController: UIViewController {

    var introService = ServiceController()
    @IBAction func onClickBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet var veriftTableView: UITableView!
    @IBOutlet var firstTF: UITextField!
    @IBOutlet var secondTF: UITextField!
    @IBOutlet var thirdTF: UITextField!
    @IBOutlet var fourthTF: UITextField!
    @IBOutlet weak var otpTF: OTPFieldView!
        
    @IBAction func onClickVerifyButton(_ sender: Any) {
        
        if self.otpTF.fieldsCount <= 0 {
            self.showAlertWith(title: "Alert", message: "Please enter valid OTP")
        }
        else
        {
           
            self.getOTPVerification()
        }
//        if firstTF.text=="" || secondTF.text=="" || thirdTF.text=="" || fourthTF.text==""
//        {
//            self.showAlertWith(title: "Alert", message: "Please enter valid OTP")
//        }
        
    }
    @IBAction func onClickResendOTPButton(_ sender: Any) {
        self.getMobileVerification()
    }
    @IBOutlet var timerLabel: UILabel!
    
    var otpString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOtpView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        veriftTableView.separatorStyle = .none
        self.getMobileVerification()
    }
    
    func setupOtpView(){
        self.otpTF.fieldsCount = 4
        self.otpTF.fieldBorderWidth = 2
        self.otpTF.defaultBorderColor = UIColor.black
        self.otpTF.filledBorderColor = UIColor.green
        self.otpTF.cursorColor = UIColor.red
        self.otpTF.displayType = .roundedCorner
        self.otpTF.fieldSize = 50
        self.otpTF.separatorSpace = 8
        self.otpTF.shouldAllowIntermediateEditing = false
        self.otpTF.delegate = self
        self.otpTF.initializeUI()
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
    var country_code=String()
    var net_code=String()
    func getMobileVerification()
    {
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + mobileVerification + "/\(phoneNumber)" + "/IND"
            //"/\(country_code)"
        let params = ["":""]
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
    func getOTPVerification()
    {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + mobileOTPVerification + "/" + net_code + "/" + phoneNumber + "/" + otpString
        
        introService.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
            
            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if statusCode == 200 {
                if status == "SUCCESS" {
                    let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                    let VC = storyBoard.instantiateViewController(withIdentifier: "DetailsNewViewController") as! DetailsNewViewController
                    VC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(VC, animated: true)
                    
                }else {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension VerifyOtpNewViewController: OTPFieldViewDelegate {
    
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        self.otpString = otpString
        print("OTPString: \(otpString)")
    }
}
