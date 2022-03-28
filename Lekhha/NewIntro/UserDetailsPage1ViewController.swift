//
//  UserDetailsPage1ViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 12/03/22.
//

import UIKit
import ObjectMapper

class UserDetailsPage1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.isgender = "male"
        self.otherButton.setImage(UIImage(named: "radioInactive"), for: .normal)
        self.maleButton.setImage(UIImage(named: "radio_active"), for: UIControl.State.normal)
        self.femaleButton.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
        
        showDatePicker()
        if userDetailsExists==true
        {
            self.userFirstNameTF.isUserInteractionEnabled=false
            self.userLastNameTF.isUserInteractionEnabled=false
            self.dateOfBirthNameTF.isUserInteractionEnabled=false
            self.userFirstNameTF.textColor=UIColor.lightGray
            self.userLastNameTF.textColor=UIColor.lightGray
            self.dateOfBirthNameTF.textColor=UIColor.lightGray
        }
        else
        {
            self.userFirstNameTF.isUserInteractionEnabled=true
            self.userLastNameTF.isUserInteractionEnabled=true
            self.dateOfBirthNameTF.isUserInteractionEnabled=true
            self.userFirstNameTF.textColor=UIColor.black
            self.userLastNameTF.textColor=UIColor.black
            self.dateOfBirthNameTF.textColor=UIColor.black
        }
        self.userNameL.text=phoneNumber
        self.userEmailL.text=userEmailID
        if signUpUserDetailArray.count>0
        {
        let object=signUpUserDetailArray[0]
        
        self.userFirstNameTF.text=object.firstName
        self.userLastNameTF.text=object.lastName
        self.dateOfBirthNameTF.text=object.dateOfBirth
            isgender=object.gender ?? "male"
            if isgender=="male"
            {
                self.otherButton.setImage(UIImage(named: "radioInactive"), for: .normal)
                self.maleButton.setImage(UIImage(named: "radio_active"), for: UIControl.State.normal)
                self.femaleButton.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
            }
           else if isgender=="female"
            {
                self.otherButton.setImage(UIImage(named: "radioInactive"), for: .normal)
                self.maleButton.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
                self.femaleButton.setImage(UIImage(named: "radio_active"), for: UIControl.State.normal)
            }
            else
           {
               self.otherButton.setImage(UIImage(named: "radio_active"), for: .normal)
               self.maleButton.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
               self.femaleButton.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
           }
        }
        if signUpTypeGlobal=="Gmail" || signUpTypeGlobal=="Facebook"
        {
            self.userFirstNameTF.text=signUpFirstName
            self.userLastNameTF.text=signUpLastName
        }
    }
    func showDatePicker(){

        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }

        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()

        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self.cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self.donedatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        dateOfBirthNameTF.inputAccessoryView = toolbar
        dateOfBirthNameTF.inputView = datePicker
        
     }
    @objc func cancelDatePicker(){
       self.view.endEditing(true)
     }
    @objc func donedatePicker(){

     let formatter = DateFormatter()
     formatter.dateFormat = "dd/MM/yyyy"
     dobSTR = formatter.string(from: datePicker.date)
      
      let formatterr = DateFormatter()
      formatterr.dateFormat = "dd/MM/yyyy"
      dateOfBirthNameTF.text = formatter.string(from: datePicker.date)
     self.view.endEditing(true)
   }
    @IBOutlet var userNameL: UILabel!
    @IBOutlet var userEmailL: UILabel!
    @IBOutlet var userFirstNameTF: UITextField!
    @IBOutlet var userLastNameTF: UITextField!
    @IBOutlet var dateOfBirthNameTF: UITextField!
    var datePicker = UIDatePicker()
    var dobSTR = ""
    @IBAction func onClickUserDOBbutton(_ sender: Any) {
        showDatePicker()
    }
    @IBAction func onClickMaleButton(_ sender: UIButton) {
        isgender = "male"
        
        otherButton.setImage(UIImage(named: "radioInactive"), for: .normal)
        maleButton.setImage(UIImage(named: "radio_active"), for: UIControl.State.normal)
        femaleButton.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
    }
    @IBOutlet var maleButton: UIButton!
    @IBAction func onClickFemaleButton(_ sender: UIButton) {
        isgender = "female"
        
        otherButton.setImage(UIImage(named: "radioInactive"), for: .normal)
        maleButton.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
        femaleButton.setImage(UIImage(named: "radio_active"), for: UIControl.State.normal)
    }
    @IBOutlet var femaleButton: UIButton!
    @IBAction func onClickMOtherButton(_ sender: UIButton) {
        isgender = "other"
        otherButton.setImage(UIImage(named: "radio_active"), for: .normal)
        maleButton.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
        femaleButton.setImage(UIImage(named: "radioInactive"), for: UIControl.State.normal)
    }
    @IBOutlet var otherButton: UIButton!
    var isgender=String()
    @IBAction func onClickNextButton(_ sender: Any) {
        if userDetailsExists==false
        {
        if userFirstNameTF.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please enter user firstname")
            return
        }
        else if userLastNameTF.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please enter user lastname")
            return
        }
        else if dateOfBirthNameTF.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please enter DOB")
            return
        }
        else if isgender==""
        {
            self.showAlertWith(title: "Alert", message: "Please select gender")
        }
        else
        {
        
        self.getConsumerUserPersonalDetails()
        }
    }
            else
        {
            let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "UserDetailsPage2ViewController") as! UserDetailsPage2ViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    var introService=ServiceController()
    func getConsumerUserPersonalDetails()
    {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + consumerUserpersonalDetails
        let params = ["firstName":userFirstNameTF.text!,
                      "lastName":userLastNameTF.text!,
                      "dateOfBirth":dateOfBirthNameTF.text!,
                        "gender":isgender,
                        "mobileNumber":phoneNumber] as [String : Any]
        let postHeaders_IndividualLogin = ["":""]
        
        introService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                                let VC = storyBoard.instantiateViewController(withIdentifier: "UserDetailsPage2ViewController") as! UserDetailsPage2ViewController
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
