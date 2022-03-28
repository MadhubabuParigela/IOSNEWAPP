//
//  SignUpNewViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 12/03/22.
//

import UIKit
import ObjectMapper
import DropDown

class SignUpNewViewController: UIViewController, UITextFieldDelegate {
    let dropDown = DropDown()
    @IBOutlet var tableViewNew: UITableView!
    
    @IBOutlet var mobileView: UIView!
    @IBOutlet var mobileDropButton: UIView!
    @IBOutlet var countryCodeTF: UITextField!
    @IBOutlet var phoneNumberTF: SDCTextField!
    
    var introService = ServiceController()
    var mobileNumber=String()
    var countryArr = [CountryResultVo]()
    var countryNameArr = [String]()
    var countryCodeArr = [String]()
    var countryNameStr = ""
    var slectedCodeStr = ""
    var countryCodeStr = ""
    var networkCode = [String]()
    var selectedNetworkCode = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countryCodeStr="IND"
        selectedNetworkCode="+91"
        
        phoneNumberTF.delegate = self
        phoneNumberTF.maxLength = 10
        
        if let countryCode = CountryUtility.getLocalCountryCode() {
            
            let codestr = IsoCountryCodes.find(key: countryCode)?.alpha3
            
            slectedCodeStr = codestr ?? ""
            self.countryCodeStr = codestr ?? ""
            
            countryNameStr = IsoCountryCodes.find(key: countryCode)?.name ?? ""
//            self.countryCodeTF.text = codestr

            if let alpha3 = CountryUtility.getCountryCodeAlpha3(countryCodeAlpha2: countryCode){
                print(alpha3) ///result: PRT
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countryCodeStr="IND"
        selectedNetworkCode="+91"
        
        mobileDropButton.layer.borderColor = UIColor.gray.cgColor
        mobileDropButton.layer.borderWidth = 0.5
        mobileDropButton.layer.cornerRadius = 3
        mobileDropButton.clipsToBounds = true
        
        mobileView.layer.borderColor = UIColor.gray.cgColor
        mobileView.layer.borderWidth = 0.5
        mobileView.layer.cornerRadius = 3
        mobileView.clipsToBounds = true
        tableViewNew.separatorStyle = .none
        self.getCountryList_APICall()
    }
    
    //    should Change Characters In range
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // Verify all the conditions
        if textField.isFirstResponder {
            if textField.textInputMode?.primaryLanguage == nil || textField.textInputMode?.primaryLanguage == "emoji" {
                return false
              }
        }
        let validString = NSCharacterSet(charactersIn: "")
//        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if let sdcTextField = textField as? SDCTextField {
            
            if string.rangeOfCharacter(from: validString as CharacterSet) != nil
            {
//                print(range)
                return false
            }
            else
            {
                guard range.location == 0 else {
                    if textField == self.phoneNumberTF {
                        return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string) && string.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
                    }
                    return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
                }
                let newString = (sdcTextField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                                    
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }
        if let range = string.rangeOfCharacter(from: validString as CharacterSet)
        {
//            print(range)
            return false
        }
        else
        {
            guard range.location == 0 else {
                return true
            }
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
        }
    }
    
    @IBAction func onClickCountryCodeButton(_ sender: Any) {
        dropDown.dataSource = self.networkCode
        dropDown.anchorView = sender as! AnchorView
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                self?.countryCodeTF.text=item
                self?.selectedNetworkCode=item
                self?.countryNameStr = self?.countryNameArr[index] ?? String()
                self?.slectedCodeStr = self?.countryCodeArr[index] ?? String()
                self?.countryCodeStr = self?.countryCodeArr[index] ?? String()
            }
    }
    @IBAction func onClickNextButton(_ sender: Any) {
        
        if phoneNumberTF.text == ""
        {
//            self.view.makeToast("Enter your mobile number")
            self.showAlertWith(title: "Alert", message: "Enter your mobile number")
            return
        }
        let pNumber = phoneNumberTF.text
        let pNumberTrim = pNumber!.replacingOccurrences(of: " ", with: "")
        if pNumberTrim.count < 10 {
//            self.view.makeToast("Must be 10 digits")
            self.showAlertWith(title: "Alert", message: "Must be 10 digits")
            return
        }
       
//        if self.phoneNumberTF.text==""
//        {
//            self.showAlertWith(title: "Alert", message: "Phone Number should not be empty")
//        }
//        else
//        {
            self.getMobileExistance()
//        }
    }
    @IBAction func onClickGoogleButton(_ sender: Any) {
    }
    @IBAction func onClickFacebookButton(_ sender: Any) {
    }
    @IBAction func onClickAppleButton(_ sender: Any) {
    }
    @IBAction func onClickSignInButton(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "CurrentInventory", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryVC
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)
//        let userDefaults = UserDefaults.standard
//
//        userDefaults.set(false, forKey: "isLoggedIn")
//        userDefaults.synchronize()
//
    }
       
    func getMobileExistance()
    {
//        http://15.206.193.122:4500/consumer/mobileExistanceverification/9502264256/IND

        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + mobileExistance + "\(String(describing: phoneNumberTF.text!))" + "/" + countryCodeStr
        
        introService.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
            
            let respVo:MobileRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            signUpTypeGlobal="Manual"
            
                if statusCode == 200  && status == "SUCCESS" {
                    
                    phoneNumber=self.phoneNumberTF.text ?? ""
                    
                    let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                    let VC = storyBoard.instantiateViewController(withIdentifier: "VerifyOtpNewViewController") as! VerifyOtpNewViewController
                    VC.modalPresentationStyle = .fullScreen
                    VC.country_code=self.countryCodeStr
                    VC.net_code=self.selectedNetworkCode
                    self.navigationController?.pushViewController(VC, animated: true)
                    //self.showAlertWith(title: "Alert", message: messageResp ?? "")
                    userExists="No"
                    self.view.makeToast(messageResp ?? "")
                }
                else
                {
                    userExists="Yes"
                    let obj = respVo.result!
                    let pageContent = respVo.pageContentResult!
                    let userObbject = respVo.result![0]
                    signUpFirstName=userObbject.firstName ?? ""
                    signUpLastName=userObbject.lastName ?? ""
                   signUpDOB=userObbject.dateOfBirth ?? ""
                    signUpmobileStatus=userObbject.mobileStatus ?? ""
                    signUpUserDetailArray=respVo.result ?? [MobileResultVo]()
                    
                    phoneNumber=self.phoneNumberTF.text ?? ""
                    
                    let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                    let VC = storyBoard.instantiateViewController(withIdentifier: "DetailsNewViewController") as! DetailsNewViewController
                    VC.modalPresentationStyle = .fullScreen
                    VC.country_code=self.countryCodeStr
                    VC.networkCode=self.selectedNetworkCode
                    VC.mobile_no_exists=true
    //                VC.existing_user=userArrayList[0] as! [String : AnyObject]
                    VC.userListArr = obj
                    VC.pageContentArr = pageContent
                    self.navigationController?.pushViewController(VC, animated: true)
                    //self.showAlertWith(title: "Alert", message: messageResp ?? "")
                    self.view.makeToast(messageResp ?? "")
                }
            
        }) { (error) in
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
        }
        
    }
    
    func getCountryList_APICall() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + GetAllCountriesNetworkUrl
        
        introService.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in
            
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
                                self.networkCode.append(obj.networkCode ?? "")
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
    
    
    func getConsumerAccountCheck()
    {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + consumerAccount_check
        let params = ["companyName":"9963408545"]
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
