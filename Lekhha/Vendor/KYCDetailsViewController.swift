//
//  KYCDetailsViewController.swift
//  LekhaLatest
//
//  Created by USM on 01/04/21.
//

import UIKit
import ObjectMapper

class KYCDetailsViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var gstInTF: UITextField!
    @IBOutlet var legalNameTF: UITextField!
    @IBOutlet var principalPlaceTF: UITextField!
    @IBOutlet var constitutionTF: UITextField!
   
    @IBOutlet var logoutButtonXValue: NSLayoutConstraint!
    @IBOutlet var mainViewHeight: NSLayoutConstraint!
    @IBOutlet var dateOfRegistrationBtn: UIButton!
    @IBAction func onClickDateOfRegistrationBtn(_ sender: UIButton) {
        
        pickerDateView.removeFromSuperview()
        hiddenBtn.removeFromSuperview()
        picker.removeFromSuperview()
        
        hiddenBtn.frame = CGRect (x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)
        
        pickerDateView.frame = CGRect(x: 0, y: self.view.frame.size.height - 350, width: self.view.frame.size.width, height: 350)
        pickerDateView.backgroundColor = UIColor.white
        self.view.addSubview(pickerDateView)
        
        let doneBtn = UIButton()
        doneBtn.frame = CGRect(x: pickerDateView.frame.size.width - 100, y: 10, width: 80, height: 30)
        doneBtn.setTitle("Done", for: UIControl.State.normal)
        doneBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
        doneBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
        doneBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        doneBtn.addTarget(self, action: #selector(doneBtnTap), for: .touchUpInside)
        pickerDateView.addSubview(doneBtn)
        
        //Seperator Line 1 Lbl
        
        let seperatorLine1 = UILabel()
        seperatorLine1.frame = CGRect(x: 0, y: doneBtn.frame.size.height+doneBtn.frame.origin.y, width: pickerDateView.frame.size.width , height: 1)
        seperatorLine1.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
        pickerDateView.addSubview(seperatorLine1)

        picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
 //        let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
        picker.frame = CGRect(x:0.0, y:50, width:self.view.frame.size.width, height:300)
        // you probably don't want to set background color as black
        // picker.backgroundColor = UIColor.blackColor()
         if #available(iOS 13.4, *) {
             picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
         } else {
             // Fallback on earlier versions
         }

        pickerDateView.addSubview(picker)
        
        
         let currentDate = Date()
         let eventDatePicker = UIDatePicker()
         
         eventDatePicker.datePickerMode = UIDatePicker.Mode.date
         eventDatePicker.minimumDate = currentDate
                
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd/MM/yyyy"

         dateOfRegistrationBtn?.setTitle(dateFormatter.string(from: eventDatePicker.date), for: .normal)
         
    }
    var picker : UIDatePicker = UIDatePicker()
    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
   @objc func dueDateChanged(sender:UIDatePicker){
       
       
       let dateFormatter = DateFormatter()
       
       dateFormatter.dateFormat = "dd/MM/yyyy"
       let selectedDate = dateFormatter.string(from: picker.date)

       
    dateOfRegistrationBtn?.setTitle(selectedDate, for: .normal)
   
   }
   
   @objc func doneBtnTap(_ sender: UIButton) {

       hiddenBtn.removeFromSuperview()
       pickerDateView.removeFromSuperview()
              
   }
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var logoutBtn: UIButton!
    @IBOutlet var typeView: UIView!
    @IBOutlet var dateL: UILabel!
    @IBOutlet var dataHeightLabel: NSLayoutConstraint!
    var servCntrl = ServiceController()
    var gstStr = ""
    
    var isCosumerStr = ""
    
    var verifyBtn = UIButton()
    var isValidGST = Bool()
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        
      if gstInTF.text == ""
       {
            self.showAlertWith(title: "Alert", message: "Enter gst number")
            return
       }
        
//       else if(isValidGST == false){
//             self.showAlertWith(title: "Alert", message: "Enter valid gst number")
//             return
//
//       }
        
        gstStr = gstInTF.text ?? ""
//        get_Gst_API_Call(gst: gstStr)
        
        self.callUploadKYCDetailsAPI()

        
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    var serviceCntrl = ServiceController()
    var gstIn=String()
    var legalName=String()
    var principalPlace=String()
    var constitution=String()
    var dateOfRegistration=String()
    var KYCVV=String()
    var rejectionComment=String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: gstInTF.frame.size.width - (90), y: 0, width: 90, height: gstInTF.frame.size.height)
        gstInTF.rightView = paddingView
        gstInTF.rightViewMode = UITextField.ViewMode.always
        
        verifyBtn.frame = CGRect(x:10, y: 0, width: paddingView.frame.size.width - (20), height: paddingView.frame.size.height)
        verifyBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
        verifyBtn .setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
        verifyBtn.setTitle("Verify", for: .normal)
        paddingView.addSubview(verifyBtn)
        verifyBtn.addTarget(self, action: #selector(verifyGSTBtnTapped), for: .touchUpInside)
        
        let userDefaults = UserDefaults.standard

        let emailAddress = userDefaults.value(forKey: "emailAddress") as? String
        let phoneNum = userDefaults.value(forKey: "primaryMobileNumber") as? String

        emailTF.text = emailAddress ?? ""
        mobileTF.text = phoneNum ?? ""
        gstInTF.text=gstIn
        legalNameTF.text=legalName
        principalPlaceTF.text=principalPlace
        constitutionTF.text=constitution
        dateOfRegistrationBtn.setTitle(dateOfRegistration, for: .normal)
        emailTF.isUserInteractionEnabled=false
        mobileTF.isUserInteractionEnabled=false
        if KYCVV=="Pending"
        {
            self.typeView.isHidden=false
            self.dateL.text="KYC Verification is Pending.\n Please wait for Approval"
            self.dataHeightLabel.constant=70
            self.mainViewHeight.constant = 850
            self.logoutBtn.isHidden=false
            self.logoutButtonXValue.constant = -60
            self.submitButton.isHidden=true
            gstInTF.isUserInteractionEnabled=false
            legalNameTF.isUserInteractionEnabled=false
            principalPlaceTF.isUserInteractionEnabled=false
            constitutionTF.isUserInteractionEnabled=false
            dateOfRegistrationBtn.isUserInteractionEnabled=false
        }
        if KYCVV=="Not Uploaded"
        {
            self.typeView.isHidden=true
            self.dateL.text=""
            self.dataHeightLabel.constant=0
            self.mainViewHeight.constant = 700
            self.logoutButtonXValue.constant = 10
            self.logoutBtn.isHidden=false
            self.submitButton.isHidden=false
            gstInTF.isUserInteractionEnabled=true
            legalNameTF.isUserInteractionEnabled=true
            principalPlaceTF.isUserInteractionEnabled=true
            constitutionTF.isUserInteractionEnabled=true
            dateOfRegistrationBtn.isUserInteractionEnabled=true

        }
        if KYCVV=="Rejected"
        {
            let reason:String=rejectionComment
            self.typeView.isHidden=false
            self.dateL.text="Your KYC verification is Rejected. \n Reason : " + reason + "\n Please Contact Lekhha administrator"
            self.logoutBtn.isHidden=false
            self.submitButton.isHidden=false
            self.submitButton.setTitle("RESUBMIT", for: .normal)
            self.dataHeightLabel.constant=100
            self.mainViewHeight.constant = 1100
            self.logoutButtonXValue.constant = 10
            gstInTF.isUserInteractionEnabled=true
            legalNameTF.isUserInteractionEnabled=true
            principalPlaceTF.isUserInteractionEnabled=true
            constitutionTF.isUserInteractionEnabled=true
            dateOfRegistrationBtn.isUserInteractionEnabled=true
        }
        animatingView()

    }
    
    @IBAction func verifyGSTBtnTapped(_ sender: UIButton) {

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
    
    func validatePANCardNumber(_ strPANNumber : String) -> Bool{
           let regularExpression = "[A-Z]{5}[0-9]{4}[A-Z]{1}"
           let panCardValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
           return panCardValidation.evaluate(with: strPANNumber)
       }

    @IBAction func logoutBtnTap(_ sender: UIButton) {
        logout()
    }
    
    func logout()  {
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(false, forKey: "isLoggedIn")
        userDefaults.synchronize()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
        VC.modalPresentationStyle = .fullScreen
       // self.viewCntrlObj.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    func get_Gst_API_Call(gst:String) {
        
        activity.startAnimating()
        view.isUserInteractionEnabled = false
        
//        String URL = "https://appyflow.in/api/verifyGST?gstNo=" + gstin + "&key_secret=r13QSIEOmQT0OImo2LF2JwUBXlq2";

        let URLString_loginIndividual = "https://appyflow.in/api/verifyGST?gstNo=" + gstStr + "&key_secret=r13QSIEOmQT0OImo2LF2JwUBXlq2"
                                    
        servCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                let respVo:GetGstRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            let dataDict = result as! NSDictionary
            let errorCode = dataDict.value(forKey: "error") as? Bool
                
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                                                
//                let message = respVo.consent
//                let status = respVo.response_msg
            
            if(errorCode == true){
                self.showAlertWith(title: "Alert !!", message: "Enter valid GST Number")
                
            }else{
                self.callUploadKYCDetailsAPI()
            }
                                
//                if status == "Success" {
//
//                    self.callUploadKYCDetailsAPI()
//
////                    self.view.makeToast(status)
////                    self.isValidGST = true
//                    // create the alert
//
//                }
//                else {
//
//                    self.view.makeToast(status)
//                }
                
            }) { (error) in
                
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                print("Something Went To Wrong...PLrease Try Again Later")
            }
            
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
    
    func callUploadKYCDetailsAPI() {

        var accountID = String()
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
                let URLString_loginIndividual = Constants.BaseUrl + UploadVendorKYCDEtailsUrl
        
                    let params_IndividualLogin = [
                        "id":accountID,
                        "GSTIn":gstInTF.text ?? "",
                        "legalName":legalNameTF.text ?? "",
                        "businessPlace":principalPlaceTF.text ?? "",
                        "businessConstitution":constitutionTF.text ?? "",
                        "dateOfReg":dateOfRegistrationBtn.currentTitle ?? ""
                    ]
       
                    print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
        serviceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:Login_IndividualRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        let token = respVo.token
    
                        let resultArr = respVo.result?[0] as? NSDictionary
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        if status == "SUCCESS" {
                            
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(self.isCosumerStr, forKey: "consumerStatus")
                            userDefaults.synchronize()

                            self.KYCVV="Pending"
                            self.typeView.isHidden=false
                            self.dateL.text="KYC Verification is Pending.\n Please wait for Approval"
                            self.dataHeightLabel.constant=70
                            self.mainViewHeight.constant = 850
                            self.logoutBtn.isHidden=false
                            self.logoutButtonXValue.constant = -60
                            self.submitButton.isHidden=true
                            self.gstInTF.isUserInteractionEnabled=false
                            self.legalNameTF.isUserInteractionEnabled=false
                            self.principalPlaceTF.isUserInteractionEnabled=false
                            self.constitutionTF.isUserInteractionEnabled=false
                            self.dateOfRegistrationBtn.isUserInteractionEnabled=false
                            
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        print(newString)
        
        if textField==gstInTF
        {
            if newString.count>15
            {
                return false
            }
        }
        return true
    }

}

