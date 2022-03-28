//
//  SelectAccountViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 16/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
//import iOSDropDown
import ObjectMapper
import DropDown

class SelectAccountViewController: UIViewController,sentname,sendDetails,UITextFieldDelegate {
    func sendnamedfields(fieldname: String, idStr: String) {
        
    }
    
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var mobileDropView: UIView!
    @IBOutlet weak var mobileDropDownTF: UITextField!
    @IBOutlet weak var mobileBtn: UIButton!
    
    @IBOutlet weak var mobileTF: SDCTextField!
    var mobileNumString=String()
    var passwordStr = String()
    
    var selectAccountUserArr = [SelectAccountUserResultVo]()
    var vendorSelectAccountUserArr = NSMutableArray()
    
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        logout()
    }
    let dropDown = DropDown() //2
    @IBAction func mobileBtnAction(_ sender: UIButton) {
        dropDown.dataSource = ["India-IND"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.mobileDropDownTF.text = "IND"
            }
    }
    func logout()  {
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(false, forKey: "isLoggedIn")
        userDefaults.synchronize()
        
        let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "PhoneSignInViewController") as! PhoneSignInViewController
        VC.modalPresentationStyle = .fullScreen
       // self.viewCntrlObj.present(VC, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    var selectedEmailStr = ""
    var isConsumerStatus = ""
    var kycDetails = ""
    var kycStatusStr = ""
   
 /*   func sendnamedfields(fieldname: String, idStr: String) {
        
        selectAccBtn.setTitle(fieldname, for: UIControl.State.normal)
        let userDefaults = UserDefaults.standard
        
        for i in 0..<selectAccResulDatatArr.count {

            let dataDict = selectAccResulDatatArr[i].accDetails
//            let dataDict = accDetailsArr![0] as! NSDictionary

            let accIDStr = dataDict?.value(forKey: "_id") as! String
            
            if(accIDStr == idStr){
                
                let modulePermissionDict = selectAccResulDatatArr[i].modulePermissions!
                userDefaults.setValue(modulePermissionDict, forKey: "modulePermissions")
                
                let accDict = selectAccResulDatatArr[i].accDetails!
//                let accDict = emailAddressArray[0] as! NSDictionary
                let emailAddress = accDict.value(forKey: "emailAddress") as! String
                print(emailAddress)
                
                let mobileNumber = accDict.value(forKey: "primaryMobileNumber") as! String

                
                let minVicinityRange = accDict.value(forKey: "setVicinityMin") as! Int
                let maxVicinityRange = accDict.value(forKey: "setVicinityMax") as! Int
                
                userDefaults.setValue(minVicinityRange, forKey: "minVicinity")
                userDefaults.setValue(maxVicinityRange, forKey: "maxVicinity")
                
//                userDefaults.setValue(accDict, forKey: "accDetails")
                
                selectedEmailStr = emailAddress
                
                if(isConsumerStatus == "0"){
                    kycDetails = selectAccResulDatatArr[i].kycVerification ?? ""
                }
                
                userDefaults.set(emailAddress, forKey: "emailAddress")
                userDefaults.set(mobileNumber, forKey: "primaryMobileNumber")

            }
        }
        
        userDefaults.set(idStr, forKey: "accountId")
        userDefaults.set(fieldname, forKey: "accountEmail")
        userDefaults.synchronize()
        
//        self.dismiss(animated: true, completion: nil)
       // self.navigationController?.popViewController(animated: true)

    }
    
    */
    
    func details(titlename: String, type: String, countrycode: String) {
        
    }
    
    @IBOutlet weak var selectAccBtn: UIButton!
    
    var loginIndividualServer = ServiceController()
    
    var selectAccResulDatatArr = [SelectAccResultVC]()
    
    var addAccDetailsArray = NSMutableArray()
    var addAccIDArray = NSMutableArray()
    
    var addAccDetailsArr = [String]()
    var addAccIDArr = [String]()

    var selectedID = ""
    var selectedEmailID = ""
    
    var gstIn=String()
    var legalName=String()
    var principalPlace=String()
    var constitution=String()
    var dateOfRegistration=String()
    var KYCVV=String()
    var rejectionComment=String()


//    @IBOutlet weak var eventTypeFiled: DropDown!
    @IBAction func selectAccBtnTap(_ sender: UIButton) {
                
        var addAccDetailsArray1 = [String]()
        var addAccIDArray1 = [String]()
                
        if(isConsumerStatus == "1"){
            
            for obj in selectAccountUserArr {
                addAccDetailsArray1.append(obj.emailAddress ?? "")
                addAccIDArray1.append(obj._id ?? "")
            }
            
        }else{
            
            for i in 0..<vendorSelectAccountUserArr.count {
                let dataDict = vendorSelectAccountUserArr[i] as? NSDictionary
                addAccDetailsArray1.append(dataDict?.value(forKey: "emailAddress") as? String ?? "")
                addAccIDArray1.append(dataDict?.value(forKey: "_id") as? String ?? "")
            }
        }
        
        dropDown.dataSource = addAccDetailsArray1 //4
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal) //9
                self?.selectedEmailID = item
                self?.selectedID = addAccIDArray1[index]
//                self?.sendnamedfields(fieldname: item, idStr: addAccIDArray1[index])
            }
    }
    
    /*
     let addAccDetailsArray1=NSMutableArray()
     let addAccIDArray1=NSMutableArray()
     
     
     for i in 0..<selectAccResulDatatArr.count {
         let dataDict = selectAccResulDatatArr[i].accDetails
         addAccDetailsArray1.add(dataDict!.value(forKey: "emailAddress") as? String)
         addAccIDArray1.add(dataDict!.value(forKey: "_id") as? String)
     }
     dropDown.dataSource = addAccDetailsArray1 as! [String]//4
     dropDown.anchorView = sender //5
     dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
         dropDown.show() //7
         dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
           guard let _ = self else { return }
           sender.setTitle(item, for: .normal) //9
             self?.sendnamedfields(fieldname: item, idStr: addAccIDArray1[index] as! String)
         }
     */
    
    @IBAction func submitBtnTap(_ sender: Any) {
        

        if(selectedEmailStr == ""){
            self.showAlertWith(title: "Alert", message: "Please select an account")
            return
        }

        if(isConsumerStatus == "1"){

            checkAccountForUser_API_Call()

        }else{
            vendorCheckAccountForUser_API_Call()
        }
        
//self.present(VC, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileTF.delegate = self
        
        mobileTF.isUserInteractionEnabled = false
        
        mobileTF.text=mobileNumString
        mobileDropView.layer.borderColor = UIColor.gray.cgColor
        mobileDropView.layer.borderWidth = 0.5
        mobileDropView.layer.cornerRadius = 3
        mobileDropView.clipsToBounds = true
        
        mobileView.layer.borderColor = UIColor.gray.cgColor
        mobileView.layer.borderWidth = 0.5
        mobileView.layer.cornerRadius = 3
        mobileView.clipsToBounds = true
        
       mobileDropDownTF.text = " IND"
        selectAccBtn.layer.borderWidth = 1
        selectAccBtn.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
        selectAccBtn.layer.cornerRadius = 3
        selectAccBtn.clipsToBounds = true
        
        mobileTF.maxLength = 10
        
        animatingView()
        
        if(isConsumerStatus == "1"){
//            selectAccountAPI()
            selectAccountForUser_API_Call()
            
        }else{
//            vendorSelectAccountAPI()
            vendorSelectAccountForUser_API_Call()
            
        }
        
//        selectAccountAPI()
        
//        self.eventTypeFiled.optionArray = ["dummy","dummy1","dummy2"]
                               
        //Its Id Values and its optional
//        self.eventTypeFiled.optionIds = [1,2,3]


        // Do any additional setup after loading the view.
    }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            
//            eventTypeFiled.didSelect { (selectedText , index ,id) in
//                print("Selected String: \(selectedText) \n index: \(index)")
//
//            }
           
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
            
            let alertAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
            })
        
        let alertAction1 = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.primaryAccountapproval_API_Call()
        })

    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
           alertController.addAction(alertAction1)

            present(alertController, animated: true, completion: nil)
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
                    
                    if textField == self.mobileTF {
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
        return true
    }
    
   /* func parseAccDetailsData() {
        
        print(selectAccResulDatatArr)

        for i in 0..<selectAccResulDatatArr.count {

            let dataDict = selectAccResulDatatArr[i].accDetails
//            let dataDict = accDetailsArr![0] as! NSDictionary
            
            addAccDetailsArray.add(dataDict?.value(forKey: "emailAddress") as? String)
            addAccIDArray.add(dataDict?.value(forKey: "_id") as? String)
            let dataDict1 = selectAccResulDatatArr[0].accDetails
            selectAccBtn.setTitle(dataDict1?.value(forKey: "emailAddress") as? String, for: UIControl.State.normal)
            self.sendnamedfields(fieldname: dataDict1?.value(forKey: "emailAddress") as! String, idStr: dataDict1?.value(forKey: "_id") as! String)
        }
        
        print(addAccDetailsArray)
       
//        self.eventTypeFiled.optionArray = addAccDetailsArray as! [String]
//        self.eventTypeFiled.optionIds = addAccIDArray as! [Int]
        
    }
    */
    
    func parseAccDetailsDataForUser() {
        
//        print(selectAccResulDatatArr)
        
        for obj in selectAccountUserArr {
//            let accountDet=obj.accountDetails as? [String:AnyObject]
            addAccDetailsArr.append(obj.emailAddress as? String ?? "")
            addAccIDArr.append(obj._id as? String ?? "")
            let selectBtnStr = addAccDetailsArr[0] ?? ""
            selectedEmailStr = selectBtnStr
            selectedEmailID = selectBtnStr
            let selectAccID = addAccIDArr[0] ?? ""
            selectedID = selectAccID
            selectAccBtn.setTitle(selectBtnStr, for: UIControl.State.normal)
//            self.sendnamedfields(fieldname: selectBtnStr, idStr: selectAccID)
        }
        
    }
    
    func vendorParseAccDetailsDataForUser() {
        
        print(selectAccResulDatatArr)
        
        if vendorSelectAccountUserArr.count > 0 {

//            let dataDict = selectAccResulDatatArr[i].accDetails
            let dataDict = vendorSelectAccountUserArr[0] as? NSDictionary
            selectedEmailStr = dataDict?.value(forKey: "emailAddress") as? String ?? ""
            selectedEmailID = dataDict?.value(forKey: "emailAddress") as? String ?? ""
            selectedID = dataDict?.value(forKey: "_id") as? String ?? ""
//            let dataDict1 = selectAccResulDatatArr[0].accDetails
            selectAccBtn.setTitle(dataDict?.value(forKey: "emailAddress") as? String, for: UIControl.State.normal)
        }
    }
    
    func vendorSelectAccountAPI() {
        
        selectAccResulDatatArr = [SelectAccResultVC]()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        print(userID)
            
                    let URLString_loginIndividual = Constants.BaseUrl + GetVendorAccountsUrl + userID
                                
//                                    let postHeaders_IndividualLogin = ["":""]
                                    
                    loginIndividualServer.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:SelectAccRespoVC = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                                    _ = respVo.result
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
//                                _ = respVo.result?[0].userId
//                                let selectAccResultArr = respVo.result
//                                let dict = selectAccResultArr?[0] as! NSDictionary
                                
                                self.selectAccResulDatatArr = [SelectAccResultVC]()
                                self.selectAccResulDatatArr = respVo.result!
                                
                                print(self.selectAccResulDatatArr)
//                                self.parseAccDetailsData()
                                self.parseAccDetailsDataForUser()

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
    
    func vendorSelectAccountForUser_API_Call() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let mobileStr = mobileTF.text ?? ""
            
                    let URLString_loginIndividual = Constants.BaseUrl + GetVendorAccountUsersUrl + mobileStr
                                
//                                    let postHeaders_IndividualLogin = ["":""]
                                    
                    loginIndividualServer.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:SelectAccRespoVC = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            let statusCode = respVo.statusCode
                            let resultObj = respVo.result1
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                        
                        if statusCode == 200 {
                            
                            if status == "SUCCESS" {
                                self.vendorSelectAccountUserArr = resultObj ?? NSMutableArray()
                                self.vendorParseAccDetailsDataForUser()

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
    
    func selectAccountForUser_API_Call() {
                
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        print(userID)
        
        let mobileStr = mobileTF.text ?? ""
            
        let URLString_loginIndividual = Constants.BaseUrl + GetAllAccountsForUserUrlNew + userID
                                
//                                    let postHeaders_IndividualLogin = ["":""]
                                    
                    loginIndividualServer.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:SelectAccountUserRespVo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            let statusCode = respVo.statusCode
                                    _ = respVo.result
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                        
                        if statusCode == 200 {
                            if status == "SUCCESS" {
                                if respVo.result != nil{
                                    if respVo.result!.count > 0 {
                                        self.selectAccountUserArr = respVo.result ?? [SelectAccountUserResultVo]()
                                        self.parseAccDetailsDataForUser()
                                    }
                                    else {
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let VC = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
                                        VC.modalPresentationStyle = .fullScreen
                                        VC.modalPresentationStyle = .fullScreen
                                        VC.isSelectAccount = true
                                        VC.passwordStr = self.passwordStr
                                        VC.mobileStr = self.mobileNumString
                                        self.navigationController?.pushViewController(VC, animated: true)
                                    }
                                }
                                else {
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let VC = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
                                    VC.modalPresentationStyle = .fullScreen
                                    VC.modalPresentationStyle = .fullScreen
                                    VC.isSelectAccount = true
                                    VC.passwordStr = self.passwordStr
                                    VC.mobileStr = self.mobileNumString
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
    
    func selectAccountAPI() {
        
        selectAccResulDatatArr = [SelectAccResultVC]()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        print(userID)
            
                    let URLString_loginIndividual = Constants.BaseUrl + GetAllAccountsUrl + userID
                                
//                                    let postHeaders_IndividualLogin = ["":""]
                                    
                    loginIndividualServer.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:SelectAccRespoVC = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                                    _ = respVo.result
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
//                                _ = respVo.result?[0].userId
//                                let selectAccResultArr = respVo.result
//                                let dict = selectAccResultArr?[0] as! NSDictionary
                                
                                self.selectAccResulDatatArr = [SelectAccResultVC]()
                                self.selectAccResulDatatArr = respVo.result ?? [SelectAccResultVC]()
                                
                                print(self.selectAccResulDatatArr)
//                                self.parseAccDetailsData()

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
    
    func checkAccountForUser_API_Call() {
                
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        print(userID)
        
            
       // let URLString_loginIndividual = Constants.BaseUrl + CheckAccountsForUserUrl + userID + "/" + selectedID
        //New
        let URLString_loginIndividual = Constants.BaseUrl + consumerAccountAccess + userID + "/" + selectedID
        
                                
//                                    let postHeaders_IndividualLogin = ["":""]
                                    
                    loginIndividualServer.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:CheckAccountUserRespVo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            let statusCode = respVo.statusCode
                            let resultObj = respVo.result
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                        
                        if statusCode == 200 {
                            
                            if status == "SUCCESS" {
                                
                                if resultObj != nil {
                                    
                                    let userDefaults = UserDefaults.standard
                                    userDefaults.set(true, forKey: "isLoggedIn")
                                    userDefaults.synchronize()
                                    
                                    userDefaults.set(self.isConsumerStatus, forKey: "consumerStatus")
                                    userDefaults.synchronize()
                                    
                                    let primaryUser=respVo.result?[0].primaryUser
                                    
                                    userDefaults.set(primaryUser, forKey: "primaryUser")
                                    userDefaults.synchronize()
                                    
                                    let modulePermissionDict = respVo.result?[0].modulePermissions
                                    
                                    userDefaults.setValue(modulePermissionDict, forKey: "modulePermissions")
                                    
                                    let accDict = respVo.result?[0].accountDetails
                    //                let accDict = emailAddressArray[0] as! NSDictionary
                                    let emailAddress = accDict?.emailAddress ?? ""
                                    
                                    let mobileNumber = accDict?.primaryMobileNumber ?? ""
                                    
                                    let minVicinityRange = accDict?.setVicinityMin ?? 0
                                    let maxVicinityRange = accDict?.setVicinityMax ?? 0
                                    
                                    userDefaults.setValue(minVicinityRange, forKey: "minVicinity")
                                    userDefaults.setValue(maxVicinityRange, forKey: "maxVicinity")
                                                                        
                                    self.selectedEmailStr = emailAddress
                                    
                                    userDefaults.set(emailAddress, forKey: "emailAddress")
                                    userDefaults.set(mobileNumber, forKey: "primaryMobileNumber")
                                    
                                    userDefaults.set(self.selectedID, forKey: "accountId")
                                    userDefaults.set(self.selectedEmailID, forKey: "accountEmail")
                                    userDefaults.synchronize()
                                                                        
                                    
                                    let storyBoard = UIStoryboard(name: "CurrentInventory", bundle: nil)
                                    let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryVC
                                    VC.modalPresentationStyle = .fullScreen
                                    self.navigationController?.pushViewController(VC, animated: true)
                                    
                                }
                                else {
                                    let isRejected = respVo.isRejected
                                    if isRejected == true {
                                        self.showAlert1With(title: "Alert", message: "Do you want to resubmit your request")
                                    }
                                    else {
                                        self.showAlertWith(title: "Alert", message: messageResp ?? "")
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
    
    func primaryAccountapproval_API_Call() {
                
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        do {
            
                let URLString_loginIndividual = Constants.BaseUrl + primaryAccountApprovalUrl
                                            
                let postHeaders_IndividualLogin = ["":""]
                
            let dict = ["mobileNumber":mobileTF.text ?? "","emailId":selectedEmailID] as [String : Any]
                print(dict)

                loginIndividualServer.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: dict as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

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
    
    func vendorCheckAccountForUser_API_Call() {
                
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        print(userID)
        
            
        let URLString_loginIndividual = Constants.BaseUrl + VendorCheckAccountForUserUrl + userID + "/" + selectedID
                                                                    
                    loginIndividualServer.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:SelectAccRespoVC = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            let statusCode = respVo.statusCode
                            let resultObj = respVo.result
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                        
                        if statusCode == 200 {
                            
                            if status == "SUCCESS" {
                                
                                if resultObj != nil {
                                    
                                    let userDefaults = UserDefaults.standard
                                    
                                    userDefaults.set(self.isConsumerStatus, forKey: "consumerStatus")
                                    userDefaults.synchronize()
                                    
                                    let modulePermissionDict = respVo.result?[0].modulePermissions
                                    
                                    userDefaults.setValue(modulePermissionDict, forKey: "modulePermissions")
                                    
                                    let accDict = respVo.result?[0].accDetails
                    //                let accDict = emailAddressArray[0] as! NSDictionary
                                    let emailAddress = accDict?.emailAddress ?? ""
                                    
                                    let mobileNumber = accDict?.primaryMobileNumber ?? ""
                                    
                                    let minVicinityRange = accDict?.setVicinityMin ?? 0
                                    let maxVicinityRange = accDict?.setVicinityMax ?? 0
                                    
                                    userDefaults.setValue(minVicinityRange, forKey: "minVicinity")
                                    userDefaults.setValue(maxVicinityRange, forKey: "maxVicinity")
                                                                        
                                    self.selectedEmailStr = emailAddress
                                    
                                    userDefaults.set(emailAddress, forKey: "emailAddress")
                                    userDefaults.set(mobileNumber, forKey: "primaryMobileNumber")
                                    
                                    userDefaults.set(self.selectedID, forKey: "accountId")
                                    userDefaults.set(self.selectedEmailID, forKey: "accountEmail")
                                    userDefaults.synchronize()
                                    
                                    self.kycDetails = respVo.result?[0].kycVerification ?? ""
                                    self.gstIn=respVo.result?[0].gstIn ?? ""
                                    self.legalName=respVo.result?[0].legalName ?? ""
                                    self.principalPlace=respVo.result?[0].principalPlace ?? ""
                                    self.constitution=respVo.result?[0].constitution ?? ""
                                    self.dateOfRegistration=respVo.result?[0].dateOfRegistration ?? ""
                                    self.KYCVV=respVo.result?[0].kycVerification ?? ""
                                    self.rejectionComment=respVo.result?[0].rejectionComment ?? ""
                                                   
                                    
                                    
                                    userDefaults.set(self.isConsumerStatus, forKey: "consumerStatus")
                                    userDefaults.synchronize()
                                    if(self.kycDetails == "Not Uploaded"){
                                        
                                        userDefaults.set(false, forKey: "isLoggedIn")
                                        userDefaults.synchronize()
                                        
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let VC = storyBoard.instantiateViewController(withIdentifier: "KYCDetailsViewController") as! KYCDetailsViewController
                                        VC.modalPresentationStyle = .fullScreen
                                        VC.isCosumerStr = self.isConsumerStatus
                                        VC.gstIn=self.gstIn
                                        VC.legalName=self.legalName
                                        VC.principalPlace=self.principalPlace
                                        VC.constitution=self.constitution
                                        VC.dateOfRegistration=self.dateOfRegistration
                                        VC.KYCVV=self.KYCVV
                                        VC.rejectionComment=self.rejectionComment
                                        self.navigationController?.pushViewController(VC, animated: true)

                                    }else if(self.kycDetails == "Pending"){
                                        
                                        userDefaults.set(false, forKey: "isLoggedIn")
                                        userDefaults.synchronize()
                                   
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let VC = storyBoard.instantiateViewController(withIdentifier: "KYCDetailsViewController") as! KYCDetailsViewController
                                        VC.modalPresentationStyle = .fullScreen
                                        VC.isCosumerStr = self.isConsumerStatus
                                        VC.gstIn=self.gstIn
                                        VC.legalName=self.legalName
                                        VC.principalPlace=self.principalPlace
                                        VC.constitution=self.constitution
                                        VC.dateOfRegistration=self.dateOfRegistration
                                        VC.KYCVV=self.KYCVV
                                        VC.rejectionComment=self.rejectionComment
                                        self.navigationController?.pushViewController(VC, animated: true)
                                        
                                    } else if self.kycDetails=="Rejected"
                                    {
                                        userDefaults.set(false, forKey: "isLoggedIn")
                                        userDefaults.synchronize()
                                        
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let VC = storyBoard.instantiateViewController(withIdentifier: "KYCDetailsViewController") as! KYCDetailsViewController
                                        VC.modalPresentationStyle = .fullScreen
                                        VC.isCosumerStr = self.isConsumerStatus
                                        VC.gstIn=self.gstIn
                                        VC.legalName=self.legalName
                                        VC.principalPlace=self.principalPlace
                                        VC.constitution=self.constitution
                                        VC.dateOfRegistration=self.dateOfRegistration
                                        VC.KYCVV=self.KYCVV
                                        VC.rejectionComment=self.rejectionComment
                                        self.navigationController?.pushViewController(VC, animated: true)
                                    }
                                    else{
                                        
                                        userDefaults.set(true, forKey: "isLoggedIn")
                                        userDefaults.synchronize()

                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let VC = storyBoard.instantiateViewController(withIdentifier: "VendorOrdersViewController") as! VendorOrdersViewController
                                        VC.modalPresentationStyle = .fullScreen
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


