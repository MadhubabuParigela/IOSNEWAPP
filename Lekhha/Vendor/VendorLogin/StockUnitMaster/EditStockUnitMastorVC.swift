//
//  EditStockUnitMastorVC.swift
//  Lekhha
//
//  Created by USM on 04/11/21.
//

import UIKit
import ObjectMapper
import Toast_Swift

class EditStockUnitMastorVC: UIViewController {

    @IBOutlet weak var headerTextLabel: UILabel!
    
    @IBOutlet var descriptionWarn: UIButton!
    @IBOutlet var stockUnitWarn: UIButton!
    @IBOutlet weak var stockUnitNameTF: UITextField!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    var tableArr = [Int]()
    
    var serviceVC = ServiceController()
    var stockUnitArray = NSMutableArray()
    
    var accountID = ""
    var row : Int = -1
    
    var stockNameStr = ""
    var descriptionStr = ""
    var idStr = ""
    var isDefaultValue:Bool = false
    
    var customcell:AddStockUnitMasterTVCell!
    
    var stockNamesArr : [String] = [String]()
    var descriptionArr : [String] = [String]()
    
    var models: [StockList] = []
    
    var params = [String:Any]()
    var stockObj: StockList?
    var isdefault:Bool = false
    var productN:Bool=false
    var productD:Bool=false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stockUnitNameTF.text = stockNameStr
        descriptionTextView.text = descriptionStr
        isdefault = isDefaultValue
        self.stockUnitWarn.isHidden=true
        self.descriptionWarn.isHidden=true
        self.stockUnitWarn.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
        self.descriptionWarn.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
        if isdefault == true {
            
            checkImg.image = #imageLiteral(resourceName: "checkBoxActive")
        }
        else {
            checkImg.image = #imageLiteral(resourceName: "checkBoxInactive")
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
    // MARK: Add Experience Info API Call
    func post_StockUnitMaster_API_Call() {
        
//        for index in 0..<stockNamesArr.count
//        {
////            models.append(StockList(name: stockNamesArr[index], description: descriptionArr[index]))
//
//            let descrip = stockNamesArr[index]
//            let nameStr = descriptionArr[index]
//        }
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        params = [
        "accountId":accountID,
            "stockUnitDescription":descriptionTextView.text ?? "",
            "stockUnitName":stockUnitNameTF.text ?? "",
            "_id": idStr,
            "isDefault":isdefault
        ]
        stockUnitArray.add(params)
             
        print(params)
        var urlStr = ""

            urlStr = Constants.BaseUrl + vendorUpdateStockUnitUrl
            
            let postHeaders_IndividualLogin = ["":""]
            
            serviceVC.requestPOSTURLWithArray(strURL: urlStr as NSString, postParams: stockUnitArray as NSArray, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                
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
    
    @IBAction func checkBtnAction(_ sender: Any) {
        
        if checkImg.image == #imageLiteral(resourceName: "checkBoxInactive") {
            
            self.showAlertWith(title: "Make Default", message: "You are changing the default stock unit from NA to \(stockUnitNameTF.text ?? "")")
        }
        else {
            
//            checkImg.image = #imageLiteral(resourceName: "checkBoxInactive")
//            self.isdefault = false
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
            
            let alertAction = UIAlertAction(title: "YES", style: .default, handler: { (action) in
               
                self.checkImg.image = #imageLiteral(resourceName: "checkBoxActive")
                self.isdefault = true
            })
        let cancelAction = UIAlertAction(title: "NO", style: .default, handler: { (action) in
            self.checkImg.image = #imageLiteral(resourceName: "checkBoxInactive")
            self.isdefault = false
        })
    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
        alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        if stockUnitNameTF.text == "" {
            
            self.productN=true
            self.stockUnitWarn.isHidden=false
        }
        else
        {
            self.productN=false
            self.stockUnitWarn.isHidden=true
        }
        if descriptionTextView.text == "" {
            
            self.productD=true
            self.descriptionWarn.isHidden=false
        }
        else
        {
            self.productD=false
            self.descriptionWarn.isHidden=true
        }
        if self.productN==true || self.productD==true
        {
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
        else
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.post_StockUnitMaster_API_Call()
            })
        
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
