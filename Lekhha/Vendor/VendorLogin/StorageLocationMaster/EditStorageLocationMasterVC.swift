//
//  EditStorageLocationMasterVC.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import UIKit
import ObjectMapper
import DropDown

class EditStorageLocationMasterVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var storageLocationNameTF: UITextField!
    
    @IBOutlet var defaultCheckView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var hierachyView: UIView!
    @IBOutlet weak var hierachyTF: UITextField!
    @IBOutlet weak var parentLocationTF: UITextField!
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var parentLocationView: UIView!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var parentHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var parentBgView: UIView!
    
    var serviceVC = ServiceController()
    var storageLocationArray = NSMutableArray()
    
    var accountID = ""
    
    var stockNameStr = ""
    var descriptionStr = ""
    var idStr = ""
    var hierachyStr = Int()
    var isDefaultValue:Bool = false
    
    var params = [String:Any]()
    var isdefault:Bool = false
    var hierachyValue = Int()
    var parentLocationStr = ""
    
    @IBOutlet var descWarn: UIButton!
    @IBOutlet var nameWarn: UIButton!
    let dropDown = DropDown() //2
    var productN:Bool=false
    var productD:Bool=false
    var storageLocationArr = [GetStorageLocationMasterResultVo]()
    var selectedId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        storageLocationNameTF.text = stockNameStr
        descriptionTextView.text = descriptionStr
        if parentLocationStr != "" {
            parentLocationTF.text = parentLocationStr
            self.parentBgView.isHidden = false
            self.parentHeightConstant.constant = 60
        }
        else {
            self.parentBgView.isHidden = true
            self.parentHeightConstant.constant = 0
        }
        isdefault = isDefaultValue
        hierachyTF.text = "Level" + "\(hierachyStr)"
        hierachyValue = hierachyStr
        self.nameWarn.isHidden=true
        self.descWarn.isHidden=true
        self.nameWarn.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
        self.descWarn.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
        if isdefault == true {
            
            checkImg.image = #imageLiteral(resourceName: "checkBoxActive")
        }
        else {
            checkImg.image = #imageLiteral(resourceName: "checkBoxInactive")
        }
        if hierachyValue==1
        {
            self.defaultCheckView.isHidden=false
        }
        else
        {
            self.defaultCheckView.isHidden=true
        }
        
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 5.0
        bgView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        bgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        bgView.layer.shadowRadius = 6.0
        bgView.layer.shadowOpacity = 0.7
        
        descriptionView.layer.borderColor = UIColor.gray.cgColor
        descriptionView.layer.borderWidth = 0.5
        descriptionView.layer.cornerRadius = 3
        descriptionView.clipsToBounds = true
        
        parentLocationView.layer.borderColor = UIColor.gray.cgColor
        parentLocationView.layer.borderWidth = 0.5
        parentLocationView.layer.cornerRadius = 3
        parentLocationView.clipsToBounds = true
        
        hierachyView.layer.borderColor = UIColor.gray.cgColor
        hierachyView.layer.borderWidth = 0.5
        hierachyView.layer.cornerRadius = 3
        hierachyView.clipsToBounds = true
        // Do any additional setup after loading the view.
        animatingView()
        // Do any additional setup after loading the view.
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
    
    
    @objc func onClickWarnButton()
    {
        self.showAlertWith(title: "Alert", message: "Required")
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
            
        let cancelAction = UIAlertAction(title: "NO", style: .default, handler: { (action) in
            self.checkImg.image = #imageLiteral(resourceName: "checkBoxInactive")
            self.isdefault = false
        })
            let alertAction = UIAlertAction(title: "YES", style: .default, handler: { (action) in
               
                self.checkImg.image = #imageLiteral(resourceName: "checkBoxActive")
                self.isdefault = true
            })
        
    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
        alertController.addAction(cancelAction)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func checkBtnAction(_ sender: Any) {
        
        if checkImg.image == #imageLiteral(resourceName: "checkBoxInactive") {
            
            self.showAlertWith(title: "Make Default", message: "You are changing the default storage location from NA to \(storageLocationNameTF.text ?? "")")
        }
        else {
            
//            checkImg.image = #imageLiteral(resourceName: "checkBoxInactive")
//            self.isdefault = false
        }
    }
    @IBAction func saveBtnAction(_ sender: Any) {
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        if storageLocationNameTF.text == "" {
            
            self.productN=true
            self.nameWarn.isHidden=false
        }
        else
        {
            self.productN=false
            self.nameWarn.isHidden=true
        }
        if descriptionTextView.text == "" {
            
            self.productD=true
            self.descWarn.isHidden=false
        }
        else
        {
            self.productD=false
            self.descWarn.isHidden=true
        }
        if self.productN==true || self.productD==true
        {
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
        else
        {
            activity.startAnimating()
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.post_StockUnitMaster_API_Call()
            })
        }
    }
    
    @IBAction func hierachyBtnAction(_ sender: UIButton) {
        
     /*   dropDown.dataSource = ["Level 1","Level 2","Level 3"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.hierachyTF.text = item
                self?.selectedId = index
                if index == 0 {
                    self?.parentBgView.isHidden = true
                    self?.parentHeightConstant.constant = 0
                }
                else {
                    self?.get_StorageLocationMaster_API_Call()
                    self?.parentBgView.isHidden = false
                    self?.parentHeightConstant.constant = 60
                }
            }
        */
    }
    @IBAction func parentLocationBtnAction(_ sender: UIButton) {
        
        var parentNameArr = [String]()
        
        for obj in storageLocationArr {
            parentNameArr.append(obj.slocName ?? "")
        }
        
        dropDown.dataSource = parentNameArr//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.parentLocationTF.text = item
                
            }
    }
    // MARK: Add Experience Info API Call
    func post_StockUnitMaster_API_Call() {
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
       /* [{"accountId":"618e6797fd00a3439500134f","canEdit":true,"hierachyLevel":2,"_id":"61927952c776752e67bb1a8e","isDefault":false,"parentLocation":"NA","slocDescription":"Gg","slocName":"dddd"}]
        */
        if hierachyTF.text == ""{
            
            hierachyValue = hierachyStr
            
            params = [
            "accountId":accountID,
                "slocDescription":descriptionTextView.text ?? "",
                "slocName":storageLocationNameTF.text ?? "",
                "_id": idStr,
                "hierachyLevel": hierachyValue,
            "parentLocation":parentLocationTF.text ?? "",
                "canEdit":true,
                "isDefault":isdefault
            ]
        }
        else {
            
            let hierStr = hierachyTF.text ?? ""
            let lastVal = hierStr.suffix(1)
            let str:String = "\(lastVal)"
            let val:Int = Int(str)!
                
            params = [
            "accountId":accountID,
                "slocDescription":descriptionTextView.text ?? "",
                "slocName":storageLocationNameTF.text ?? "",
                "_id": idStr,
                "hierachyLevel": val,
                "parentLocation":parentLocationTF.text ?? "",
                "canEdit":true,
                "isDefault":isdefault
            ]
        }
        
       
        
//        [{"_id":"","accountId":"6167f9d214a7a77cad66c9ae","slocName":"u44","slocDescription":"ue3y","hierachyLevel":"","parentLocation":""}]
        
        
        storageLocationArray.add(params)
             
        print(params)
        var urlStr = ""

            urlStr = Constants.BaseUrl + vendorUpdateStoragekUnitUrl
            
            let postHeaders_IndividualLogin = ["":""]
            
            serviceVC.requestPOSTURLWithArray(strURL: urlStr as NSString, postParams: storageLocationArray as NSArray, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                
                let respVo:AddStockUnitMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
                
                let status = respVo.STATUS_CODE
                let statusMessage = respVo.STATUS_MSG
                let message = respVo.message
                
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                if status == 200 {
                    
                    if statusMessage == "SUCCESS" {
                        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                            self.navigationController?.popViewController(animated: true)
                                                       
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                    self.view.makeToast(message)
                }
            }) { (error) in
                
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                print("Something Went To Wrong...PLrease Try Again Later")
//                self.view.makeToast("app.SomethingWentToWrongAlert".localize())
            }
    }
    
    // MARK: Get AddressBook API Call
    func get_StorageLocationMaster_API_Call() {
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let urlStr = Constants.BaseUrl + getAllStorageLocationByHierachyLevelUrl + "\(selectedId)/" + accountID
        
        serviceVC.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:GetStorageLocationMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            DispatchQueue.main.async {
                
                let status = respVo.STATUS_CODE
                let message = respVo.STATUS_MSG
                
                if status == 200 {
                    if message == "SUCCESS" {
                        if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            self.storageLocationArr = respVo.result!
                            
                            for obj in self.storageLocationArr {
                                
                                self.parentLocationTF.text = obj.parentLocation ?? ""
                            }
                        }
                        else {
                            
                        }
                    }
                    }
                }
                else {
                    self.view.makeToast(message)
                }
            }
        }) { (error) in
//            self.view.makeToast("app.SomethingWentToWrongAlert".localize())
            print("Oops, your connection seems off... Please try again later")
        }
    }
}

