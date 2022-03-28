//
//  UserDetailsPage2ViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 12/03/22.
//

import UIKit
import DropDown
import ObjectMapper

class UserDetailsPage2ViewController: UIViewController {
    
    var categoryArray = ["1-10","10-50","50-100","100-500","Above 500"]
    let dropDown = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.userJoiningAsTF.text="I am Consumer"
        self.useraccountCountTF.text="1-10"
        self.userNameL.text=phoneNumber
        self.userEmailL.text=userEmailID
        if accountExists==true
        {
            let accountObject=signUpUserAccountDetailArray[0]
            self.useraccountCountTF.text=accountObject.companySize
            self.primaryAccountTF.text=accountObject.accountUniqueId
            self.userJoiningBtn.isUserInteractionEnabled=false
            self.userCountBtn.isUserInteractionEnabled=false
            self.userJoiningAsTF.isUserInteractionEnabled=false
            self.useraccountCountTF.isUserInteractionEnabled=false
            self.primaryAccountTF.isUserInteractionEnabled=false
            self.userJoiningAsTF.textColor=UIColor.lightGray
            self.useraccountCountTF.textColor=UIColor.lightGray
            self.primaryAccountTF.textColor=UIColor.lightGray
        }
        else
        {
            self.userJoiningBtn.isUserInteractionEnabled=true
            self.userCountBtn.isUserInteractionEnabled=true
            self.primaryAccountTF.isUserInteractionEnabled=true
            self.userJoiningAsTF.isUserInteractionEnabled=false
            self.useraccountCountTF.isUserInteractionEnabled=false
            self.userJoiningAsTF.textColor=UIColor.black
            self.useraccountCountTF.textColor=UIColor.black
            self.primaryAccountTF.textColor=UIColor.black
        }
        
    }
    @IBOutlet var userNameL: UILabel!
    @IBOutlet var userEmailL: UILabel!
    @IBOutlet var userJoiningAsTF: UITextField!
    
    @IBOutlet var userJoiningBtn: UIButton!
    @IBAction func onClickUserJoiningas(_ sender: Any) {
        
        dropDown.dataSource = ["I am Consumer"]
        dropDown.anchorView = sender as! AnchorView
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                
                self?.userJoiningAsTF.text = item
            }
    }
    @IBOutlet var userCountBtn: UIButton!
    @IBOutlet var useraccountCountTF: UITextField!
    
    
    @IBAction func onClickUserAccountCountButton(_ sender: Any) {
        
        dropDown.dataSource = categoryArray
        dropDown.anchorView = sender as! AnchorView
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                
                self?.useraccountCountTF.text = item
            }
    }
    @IBOutlet var primaryAccountTF: UITextField!
    
   
    @IBAction func onClickBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickNextButton(_ sender: Any) {
        if accountExists==false
        {
        if userJoiningAsTF.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please select joining")
            return
        }
        else if useraccountCountTF.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please select count")
            return
        }
        else if primaryAccountTF.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please enter primary name of account")
            return
        }
        else
        {
            
            self.checkPrimaryAccount()
            }
    }
            else
            {
                let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                let VC = storyBoard.instantiateViewController(withIdentifier: "UserDetailsPage3ViewController") as! UserDetailsPage3ViewController
                    VC.companyName=self.primaryAccountTF.text ?? ""
                    VC.companySize=self.useraccountCountTF.text ?? ""
                self.navigationController?.pushViewController(VC, animated: true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var introService=ServiceController()
    func checkPrimaryAccount()
    {
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        let URLString_loginIndividual = Constants.BaseUrl + consumerAccount_check + "\(self.primaryAccountTF.text!)"
       
        let params = ["":""]
        let postHeaders_IndividualLogin = ["":""]
        
        introService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
            
            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            _ = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if status == "FALSE" {
                let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                let VC = storyBoard.instantiateViewController(withIdentifier: "UserDetailsPage3ViewController") as! UserDetailsPage3ViewController
                    VC.companyName=self.primaryAccountTF.text ?? ""
                    VC.companySize=self.useraccountCountTF.text ?? ""
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

}
