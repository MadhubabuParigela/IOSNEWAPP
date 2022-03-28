//
//  AddVendorMasterViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 20/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown

class AddVendorMasterViewController: UIViewController, UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,sentname,sendDetails {
    
    var dropDown=DropDown()
    var vendorID = String()
    var isUpdate = String()
    var vendorListResult = [VendorListResult]()
  
    @IBAction func saveBtnTap(_ sender: Any) {
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false

        var vendorWarn=[Bool]()
        for i in 0..<addVendorArray.count {
            
            let dataDict = addVendorArray.object(at: i) as! NSDictionary
            
            let vendorName = dataDict.value(forKey: "vendorName") as! String
            let vendorDescription = dataDict.value(forKey: "vendorDescription") as! String
            let category = dataDict.value(forKey: "category") as! String
            let subCategory = dataDict.value(forKey: "subCategory") as! String
            let vendorCompany = dataDict.value(forKey: "vendorCompany") as! String
            let vendorGSTIN = dataDict.value(forKey: "vendorGSTIN") as! String
            let vendorLocation = dataDict.value(forKey: "vendorLocation") as! String
            let vendorAddress = dataDict.value(forKey: "vendorAddress") as! String

            if(vendorName == ""){
                dataDict.setValue(true, forKey: "vendorWarn")
                vendorWarn.append(true)
                self.loadAddVendorUI()
                
            }
            else
            {
                dataDict.setValue(false, forKey: "vendorWarn")
                vendorWarn.append(false)
                self.loadAddVendorUI()
            }
            /*else if(vendorDescription == ""){
                self.showAlertWith(title: "Alert", message: "Please enter description")
                return
                
            }else if(category == ""){
                self.showAlertWith(title: "Alert", message: "Please select category")
                return
                
            }else if(subCategory == ""){
                self.showAlertWith(title: "Alert", message: "Please select Subcategory")
                return

            }else if(vendorCompany == ""){
                self.showAlertWith(title: "Alert", message: "Please enter company name")
                return

            }else if(vendorGSTIN == ""){
                self.showAlertWith(title: "Alert", message: "Please enter GST number")
                return

            }else if(vendorLocation == ""){
                self.showAlertWith(title: "Alert", message: "Please select location")
                return

            }else if(vendorAddress == ""){
                self.showAlertWith(title: "Alert", message: "Please enter address")
                return

            }*/
        }
        
        if vendorWarn.contains(true)
        {
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
        else
        {
        if(isUpdate == "1"){
            activity.startAnimating()
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.editVendorAPICall()
            })

        }else{
            activity.startAnimating()
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.addVendorAPICall()
            })
        }
        }
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }
    
    func details(titlename: String, type: String, countrycode: String) {
        
    }
    
    
    @IBOutlet weak var topHeaderView: UIView!
    let topMenuView = UIView()
    var addVendorScrollView = UIScrollView()
    var scrollViewYPos : CGFloat!
    
    var catSubCatArrPosition : Int!
    var catSubCatIndexPosition : Int!
    var catSubCatTagValue : Int!
    
//    var activeStatusArrPosition : Int!
//    var activeStatusIndexPosition : Int!
//    var activeStatusTagValue : Int!

    var categoryDataArray = NSMutableArray()
    var categoryIDArray = NSMutableArray()
    
    var categoryResult = [CategoryResult]()
    var subCategoryResult = [SubCategoryResult]()
    
    var addVendorServiceCntrl = ServiceController()
    var selectedCategoryID : String!
    
    var addVendorArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//      topHeaderView.isHidden = true
//      self.loadTopMenuView()
        
        scrollViewYPos = 0

        if(isUpdate == "1"){

            self.addEmptyVendor()
            self.getCategoriesDataFromServer()
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getVendorListDataFromServer()
                       }
            
        }else{
            self.addEmptyVendor()
            self.getCategoriesDataFromServer()
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           self.loadAddVendorUI()
                       }

        }
        
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
    
//    func loadTopMenuView(){
//
//        topMenuView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60)
//        topMenuView.backgroundColor = hexStringToUIColor(hex: "0F5FEE")
//        self.view.addSubview(topMenuView)
//
//    }
//    "accountId": "5f4c8f7e1f782915c50383fd",
//    "vendorName": "sds",
//    "vendorDescription": "dsfs",
//    "category": "dsfds",
//    "subCategory": "sadd",
//    "vendorCompany": "sdfds",
//    "vendorGSTIN": "125433417345621",
//    "vendorLocation": "sfs",
//    "vendorAddress": "dsfs"
    
        func addEmptyVendor() {
            
            var myDict = NSMutableDictionary()
            
            var accountID = String()
            let defaults = UserDefaults.standard
            accountID = (defaults.string(forKey: "accountId") ?? "")
            print(accountID)
            
            var userID = String()
            userID = (defaults.string(forKey: "userID") ?? "")
            print(userID)
            
//            [{"accountemailid":"vineela@usmsystems.com","accountId":"5fe970c651de0c7206d6175c","category":"test","dateOfCreation":"2021-02-10T00:00:00.000Z","_id":"6007e4354a885e3bdbe26712","status":false,"subCategory":"tesstt","vendorAddress":"sh","vendorCompany":"sh","vendorDescription":"svsfdsf","vendorGSTIN":"sg","vendorLocation":"sh","vendorName":"vsv"}]
            
            myDict  = ["accountId": accountID, "vendorName": "", "vendorDescription": "","category": "","subCategory": "","vendorCompany": "","vendorGSTIN": "","vendorLocation": "","vendorAddress": "","isActive":"1","status":true,"vendorWarn":false]
            
            addVendorArray.add(myDict)
            
        }
    @objc func onClickWarnButton()
    {
        self.showAlertWith(title: "Alert", message: "Required")
    }
    var categoryDropDown = UIButton()
    var subCategoryDropDown = UIButton()
    func loadAddVendorUI() {
        
        addVendorScrollView.removeFromSuperview()
        print(addVendorArray.count)
        
        addVendorScrollView = UIScrollView()
        
        addVendorScrollView.frame = CGRect(x: 0, y: 105, width: self.view.frame.size.width, height: self.view.frame.size.height - (topHeaderView.frame.size.height)+45)
        addVendorScrollView.backgroundColor = hexStringToUIColor(hex: "e4ecf9")
        self.view.addSubview(addVendorScrollView)
        
        addVendorScrollView.delegate = self
        
        var yValue = CGFloat()
        yValue = 15
        
        var accountID = String()
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        print(accountID)

        for i in 1...addVendorArray.count {

            let vendorNameTF = UITextField()
            let vendroDescriptionTxtView = UITextView()
            
            let companyNameTF = UITextField()
            let GSTInTF = UITextField()
            let locationTF = UITextField()
            let addressTxtView = UITextView()

            let vendorMainDict = addVendorArray.object(at: i-1) as! NSMutableDictionary

            let vendorView = UIView()
            vendorView.backgroundColor = UIColor.white
            
            if addVendorArray.count == i{
                vendorView.frame = CGRect(x: 15, y: yValue, width: addVendorScrollView.frame.size.width - 30, height: 750)

            }else{
                vendorView.frame = CGRect(x: 15, y: yValue, width: addVendorScrollView.frame.size.width - 30, height: 700)
            }
            
            addVendorScrollView.addSubview(vendorView)
            
            vendorView.layer.cornerRadius = 10
            vendorView.layer.masksToBounds = true
            
            //Product Lbl
            
            let Str : String = String(i)
            
            let vendorLbl = UILabel()
            vendorLbl.frame = CGRect(x: 10, y: 10, width: vendorView.frame.size.width - (80), height: 20)
            vendorLbl.text = "Vendor " + Str
            vendorLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
            vendorLbl.textColor = hexStringToUIColor(hex: "232c51")
            vendorView.addSubview(vendorLbl)
            
            //Seperator Line Lbl
            
            let seperatorLine = UILabel()
            seperatorLine.frame = CGRect(x: 10, y: vendorLbl.frame.origin.y+vendorLbl.frame.size.height+10, width: vendorView.frame.size.width - (20), height: 1)
            seperatorLine.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
            vendorView.addSubview(seperatorLine)
            
                        //Vendor Name Lbl
                        
                        let vendorNameLbl = UILabel()
                        vendorNameLbl.frame = CGRect(x: 10, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: vendorView.frame.size.width - (20), height: 20)
                        vendorNameLbl.text = "Vendor Name :"
                        vendorNameLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                        vendorNameLbl.textColor = hexStringToUIColor(hex: "232c51")
                        vendorView.addSubview(vendorNameLbl)
                        
                        //Product Name TF

                        vendorNameTF.frame = CGRect(x: 10, y: vendorNameLbl.frame.origin.y+vendorNameLbl.frame.size.height+5, width: vendorView.frame.size.width - (20), height: 40)
            //            productNameTF.text = "fdfdsfdsfd"
                        vendorNameTF.font = UIFont.init(name: kAppFontMedium, size: 13)
                        vendorNameTF.textColor = hexStringToUIColor(hex: "232c51")
                        vendorView.addSubview(vendorNameTF)
            if vendorMainDict.value(forKey: "vendorWarn") as? Bool==true
            {
            let vendorNameAlertButton = UIButton()
                vendorNameAlertButton.frame = CGRect(x: vendorNameTF.frame.origin.x+vendorNameTF.frame.size.width - 40, y: vendorNameTF.frame.origin.y+5, width: 30, height: 30)
                vendorNameAlertButton.setImage(UIImage(named: "warn.png"), for: .normal)
                vendorNameAlertButton.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
                vendorView.addSubview(vendorNameAlertButton)
            }
                        vendorNameTF.layer.borderWidth = 1
                        vendorNameTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                        vendorNameTF.layer.cornerRadius = 3
                        vendorNameTF.clipsToBounds = true

                        let vendorNamePaddingView = UIView()
                        vendorNamePaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: vendorNameTF.frame.size.height)
                        vendorNameTF.leftView = vendorNamePaddingView
                        vendorNameTF.leftViewMode = UITextField.ViewMode.always

                        //Description Lbl
                        
                        let descriptionLbl = UILabel()
                        descriptionLbl.frame = CGRect(x: 10, y: vendorNameTF.frame.origin.y+vendorNameTF.frame.size.height+15, width: vendorView.frame.size.width - (20), height: 20)
                        descriptionLbl.text = "Description :"
                        descriptionLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                        descriptionLbl.textColor = hexStringToUIColor(hex: "232c51")
                        vendorView.addSubview(descriptionLbl)
                        
                        //Description Text View

                        vendroDescriptionTxtView.frame = CGRect(x: 10, y: descriptionLbl.frame.origin.y+descriptionLbl.frame.size.height+5, width: vendorView.frame.size.width - (20), height: 80)
            //            descriptionTF.text = "fdfdsfdsfd"
                        vendroDescriptionTxtView.font = UIFont.init(name: kAppFontMedium, size: 13)
                        vendroDescriptionTxtView.textColor = hexStringToUIColor(hex: "232c51")
                        vendorView.addSubview(vendroDescriptionTxtView)
                        
                        vendroDescriptionTxtView.layer.borderWidth = 1
                        vendroDescriptionTxtView.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                        vendroDescriptionTxtView.layer.cornerRadius = 3
                        vendroDescriptionTxtView.clipsToBounds = true
            
            //Category
            
            let categoryBtn = UIButton()
            categoryBtn.frame = CGRect(x:10, y: vendroDescriptionTxtView.frame.origin.y+vendroDescriptionTxtView.frame.size.height+15, width: 100, height: 20)
            categoryBtn.setTitle("Category", for: UIControl.State.normal)
            categoryBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            categoryBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            vendorView.addSubview(categoryBtn)

            //sub Category Lbl

            let subCategoryBtn = UIButton()
            subCategoryBtn.frame = CGRect(x:vendorView.frame.size.width / 2 + 10, y: vendroDescriptionTxtView.frame.origin.y+vendroDescriptionTxtView.frame.size.height+15, width: 100, height: 20)
            subCategoryBtn.setTitle("Sub Category", for: UIControl.State.normal)
            subCategoryBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            subCategoryBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            vendorView.addSubview(subCategoryBtn)
            
            categoryBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            subCategoryBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            
            //Category Drop Down
            
            categoryDropDown = UIButton()
            categoryDropDown.frame = CGRect(x: 10, y: subCategoryBtn.frame.origin.y+subCategoryBtn.frame.size.height+5, width: vendorView.frame.size.width/2 - 20 , height: 40)
            categoryDropDown.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            categoryDropDown.layer.borderWidth = 1
            categoryDropDown.layer.cornerRadius = 3
            categoryDropDown.layer.masksToBounds = true
            let categoryImage = UIButton()
            categoryImage.frame = CGRect(x: categoryDropDown.frame.size.width - (20), y: categoryDropDown.frame.origin.y+6, width: 25, height: 25)
            categoryImage.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
            vendorView.addSubview(categoryImage)
            vendorView.addSubview(categoryDropDown)
            
            categoryDropDown.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            categoryDropDown.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            
            categoryDropDown.addTarget(self, action: #selector(category_SubCategoryBtnTap), for: .touchUpInside)
            categoryDropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
            categoryDropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left

            //Sub Category Drop Down
            
            subCategoryDropDown = UIButton()
            subCategoryDropDown.frame = CGRect(x: vendorView.frame.size.width/2 + 10, y: subCategoryBtn.frame.origin.y+subCategoryBtn.frame.size.height+5, width: vendorView.frame.size.width/2 - 20 , height: 40)
            subCategoryDropDown.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            subCategoryDropDown.layer.borderWidth = 1
            subCategoryDropDown.layer.cornerRadius = 3
            subCategoryDropDown.layer.masksToBounds = true
            let subCategoryImage = UIButton()
            subCategoryImage.frame = CGRect(x: vendorView.frame.size.width - (40), y: subCategoryDropDown.frame.origin.y+6, width: 25, height: 25)
            subCategoryImage.setImage(UIImage.init(named: "arrowDown"), for: UIControl.State.normal)
            vendorView.addSubview(subCategoryImage)
            vendorView.addSubview(subCategoryDropDown)
            
            subCategoryDropDown.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            subCategoryDropDown.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            
            subCategoryDropDown.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            
            subCategoryDropDown.addTarget(self, action: #selector(category_SubCategoryBtnTap), for: .touchUpInside)
            subCategoryDropDown.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)

                        //Storage Location Lbl
                        
                        let companyNameLbl = UILabel()
                        companyNameLbl.frame = CGRect(x: 10, y: subCategoryDropDown.frame.origin.y+subCategoryDropDown.frame.size.height+15, width: vendorView.frame.size.width - (20), height: 20)
                        companyNameLbl.text = "Company Name :"
                        companyNameLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                        companyNameLbl.textColor = hexStringToUIColor(hex: "232c51")
                        vendorView.addSubview(companyNameLbl)
                        
                        //Stock Unit TF

                        companyNameTF.frame = CGRect(x: 10, y: companyNameLbl.frame.origin.y+companyNameLbl.frame.size.height+5, width: vendorView.frame.size.width - (20), height: 40)
            //            storageLocationTF.text = "Hydd"
                        companyNameTF.font = UIFont.init(name: kAppFontMedium, size: 13)
                        companyNameTF.textColor = hexStringToUIColor(hex: "232c51")
                        vendorView.addSubview(companyNameTF)
                        
                        companyNameTF.layer.borderWidth = 1
                        companyNameTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                        companyNameTF.layer.cornerRadius = 3
                        companyNameTF.clipsToBounds = true

                        let companyPaddingView = UIView()
                        companyPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: companyNameTF.frame.size.height)
                        companyNameTF.leftView = companyPaddingView
                        companyNameTF.leftViewMode = UITextField.ViewMode.always
            
                        //GST In Lbl
                        
                        let gstInLbl = UILabel()
                        gstInLbl.frame = CGRect(x: 10, y: companyNameTF.frame.origin.y+companyNameTF.frame.size.height+15, width: vendorView.frame.size.width/2 - (20), height: 20)
                        gstInLbl.text = "GSTIN :"
                        gstInLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                        gstInLbl.textColor = hexStringToUIColor(hex: "232c51")
                        vendorView.addSubview(gstInLbl)
                        
                        //Product Name TF

                        GSTInTF.frame = CGRect(x: 10, y: gstInLbl.frame.origin.y+gstInLbl.frame.size.height+5, width: vendorView.frame.size.width/2 - (20), height: 40)
            //            stockQuantityTF.text = "fdfdsfdsfd"
                        GSTInTF.font = UIFont.init(name: kAppFontMedium, size: 13)
                        GSTInTF.textColor = hexStringToUIColor(hex: "232c51")
                        vendorView.addSubview(GSTInTF)
                        
                        GSTInTF.layer.borderWidth = 1
                        GSTInTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                        GSTInTF.layer.cornerRadius = 3
                        GSTInTF.clipsToBounds = true

                        let gstInPaddingView = UIView()
                        gstInPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: GSTInTF.frame.size.height)
                        GSTInTF.leftView = gstInPaddingView
                        GSTInTF.leftViewMode = UITextField.ViewMode.always

                        //Location Lbl
                        
                        let locationLbl = UILabel()
                        locationLbl.frame = CGRect(x: vendorView.frame.size.width/2+10, y: companyNameTF.frame.origin.y+companyNameTF.frame.size.height+15, width: vendorView.frame.size.width/2 - (20), height: 20)
                        locationLbl.text = "Location :"
                        locationLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                        locationLbl.textColor = hexStringToUIColor(hex: "232c51")
                        vendorView.addSubview(locationLbl)
                        
                        //Stock Unit TF

                        locationTF.frame = CGRect(x: vendorView.frame.size.width/2+10, y: locationLbl.frame.origin.y+locationLbl.frame.size.height+5, width: vendorView.frame.size.width/2 - (20), height: 40)
            //            stockUnitTF.text = "76"
                        locationTF.font = UIFont.init(name: kAppFontMedium, size: 13)
                        locationTF.textColor = hexStringToUIColor(hex: "232c51")
                        vendorView.addSubview(locationTF)
                        
                        locationTF.layer.borderWidth = 1
                        locationTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                        locationTF.layer.cornerRadius = 3
                        locationTF.clipsToBounds = true

                        let locationPaddingView = UIView()
                        locationPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: locationTF.frame.size.height)
                        locationTF.leftView = locationPaddingView
                        locationTF.leftViewMode = UITextField.ViewMode.always

                        //Description Lbl
                        
                        let addressLbl = UILabel()
                        addressLbl.frame = CGRect(x: 10, y: locationTF.frame.origin.y+locationTF.frame.size.height+15, width: vendorView.frame.size.width - (20), height: 20)
                        addressLbl.text = "Address :"
                        addressLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                        addressLbl.textColor = hexStringToUIColor(hex: "232c51")
                        vendorView.addSubview(addressLbl)
                        
                        //Description Text View

                        addressTxtView.frame = CGRect(x: 10, y: addressLbl.frame.origin.y+addressLbl.frame.size.height+5, width: vendorView.frame.size.width - (20), height: 80)
            //            descriptionTF.text = "fdfdsfdsfd"
                        addressTxtView.font = UIFont.init(name: kAppFontMedium, size: 13)
                        addressTxtView.textColor = hexStringToUIColor(hex: "232c51")
                        vendorView.addSubview(addressTxtView)
                        
                        addressTxtView.layer.borderWidth = 1
                        addressTxtView.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                        addressTxtView.layer.cornerRadius = 3
                        addressTxtView.clipsToBounds = true
            
//            vendorView.frame = CGRect(x: 15, y: yValue, width: addVendorScrollView.frame.size.width - 30, height: addressTxtView.frame.origin.y+addressTxtView.frame.size.height+15)

            //Add Product
            
            
            //Category
            
            let activeLbl = UIButton()
            activeLbl.frame = CGRect(x:10, y: addressTxtView.frame.origin.y+addressTxtView.frame.size.height+15, width: 100, height: 20)
            activeLbl.setTitle("Active", for: UIControl.State.normal)
            activeLbl.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            activeLbl.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            vendorView.addSubview(activeLbl)
            
            activeLbl.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            
            //Category Drop Down
            
            let activeStatusDropBtn = UIButton()
            activeStatusDropBtn.frame = CGRect(x: 10, y: activeLbl.frame.origin.y+activeLbl.frame.size.height+5, width: vendorView.frame.size.width/2 - 20 , height: 40)
            activeStatusDropBtn.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
            activeStatusDropBtn.layer.borderWidth = 1
            activeStatusDropBtn.layer.cornerRadius = 3
            activeStatusDropBtn.layer.masksToBounds = true
            vendorView.addSubview(activeStatusDropBtn)
            
            activeStatusDropBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            activeStatusDropBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
            
            activeStatusDropBtn.addTarget(self, action: #selector(activeBtnTap), for: .touchUpInside)
            activeStatusDropBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
            activeStatusDropBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left

            activeLbl.isHidden = true
            activeStatusDropBtn.isHidden = true

            let addProductBtn = UIButton()
            addProductBtn.frame = CGRect(x:10, y: addressTxtView.frame.origin.y+addressTxtView.frame.size.height+20, width: 120, height: 40)
            addProductBtn.setTitle("Add Vendor", for: UIControl.State.normal)
            addProductBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            addProductBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
            addProductBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
            addProductBtn.layer.cornerRadius = 5
            addProductBtn.layer.masksToBounds = true
            vendorView.addSubview(addProductBtn)
            
            addProductBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
            
            addProductBtn.addTarget(self, action: #selector(addVendorBtnTap), for: .touchUpInside)
            addProductBtn.isHidden = true
            
            if addVendorArray.count == i{
                print("reached")
                
//                vendorView.frame = CGRect(x: 15, y: yValue, width: addVendorScrollView.frame.size.width - 30, height: addProductBtn.frame.origin.y+addProductBtn.frame.size.height+15)
                addProductBtn.isHidden = false

            }
            
                            vendorView.frame = CGRect(x: 15, y: yValue, width: addVendorScrollView.frame.size.width - 30, height: addProductBtn.frame.origin.y+addProductBtn.frame.size.height+30)

      
            yValue = vendorView.frame.size.height + yValue + 10
            
            vendorNameTF.delegate = self
            vendroDescriptionTxtView.delegate = self
            companyNameTF.delegate = self
            GSTInTF.delegate = self
            locationTF.delegate = self
            addressTxtView.delegate = self
            
            let tagValue:Int = i-1
            let StringTagValue = String(tagValue)
            
            let vendorNameTag : String = "1000" + StringTagValue
            let vendorNameTagValue: Int? = Int(vendorNameTag)
            
            let vendorDescTag : String = "1001" + StringTagValue
            let vendorDescTagValue: Int? = Int(vendorDescTag)

            let companyTag : String = "1002" + StringTagValue
            let companyTagValue: Int? = Int(companyTag)

            let GSTInTag : String = "1003" + StringTagValue
            let GSTInTagValue: Int? = Int(GSTInTag)

            let locationTag : String = "1004" + StringTagValue
            let locationTagValue: Int? = Int(locationTag)

            let addressTag : String = "1005" + StringTagValue
            let addressTagValue: Int? = Int(addressTag)
            
            let catTag : String = "3000" + StringTagValue
            let catTagValue : Int? = Int(catTag)

            let subCatTag : String = "3001" + StringTagValue
            let subCatTagValue : Int? = Int(subCatTag)
            
            let activeStatusTag : String = "5001" + StringTagValue
            let activeStatusTagValue : Int? = Int(activeStatusTag)

            vendorNameTF.tag   = vendorNameTagValue!
            vendroDescriptionTxtView.tag = vendorDescTagValue!
            companyNameTF.tag = companyTagValue!
            GSTInTF.tag = GSTInTagValue!
            locationTF.tag = locationTagValue!
            addressTxtView.tag = addressTagValue!
            categoryDropDown.tag = catTagValue!
            subCategoryDropDown.tag = subCatTagValue!
            activeStatusDropBtn.tag = activeStatusTagValue!
            
            _ = vendorMainDict.value(forKey: "accountId") as? NSString ?? ""
            let vendorName = vendorMainDict.value(forKey: "vendorName") as? NSString ?? ""
            let vendorDescription = vendorMainDict.value(forKey: "vendorDescription") as? NSString ?? ""
            let vendorCompany = vendorMainDict.value(forKey: "vendorCompany") as? NSString ?? ""
            let vendorGSTIN = vendorMainDict.value(forKey: "vendorGSTIN") as? NSString ?? ""
            let vendorLocation =  vendorMainDict.value(forKey: "vendorLocation") as? NSString ?? ""
            let vendorAddress =  vendorMainDict.value(forKey: "vendorAddress") as? NSString ?? ""
            _ = vendorMainDict.value(forKey: "isActive") as? NSString ?? ""
            var category=String()
                       var categoryId=String()
                       if vendorMainDict.value(forKey: "category") as! String==""
                       {
                           if categoryResult.count>0
                           {
                               category=categoryResult[0].name ?? ""
                               categoryId=categoryResult[0]._id ?? ""
                           }
                           vendorMainDict.setValue(category, forKey: "category")
                           vendorMainDict.setValue(categoryId, forKey: "categoryId")
                       }
                       else
                       {
                           category = (vendorMainDict.value(forKey: "category") as? NSString ?? "") as String
                       }
                       var subCategory=String()
                       var subCategoryId=String()
                       if vendorMainDict.value(forKey: "subCategory") as! String==""
                       {
                           if subCategoryResult.count>0
                           {
                               subCategory=subCategoryResult[0].name ?? ""
                               subCategoryId=subCategoryResult[0]._id ?? ""
                           }
                           vendorMainDict.setValue(subCategory, forKey: "subCategory")
                           vendorMainDict.setValue(subCategoryId, forKey: "subCategoryId")
                       }
                       else
                       {
                           subCategory = (vendorMainDict.value(forKey: "subCategory") as? NSString ?? "") as String
                       }
                       print("Subcat is \(subCategory)")

            print("Subcat is \(subCategory)")
            
            vendorNameTF.text = vendorName as String
            vendroDescriptionTxtView.text = vendorDescription as String
            companyNameTF.text = vendorCompany as String
            GSTInTF.text = vendorGSTIN as String
            locationTF.text = vendorLocation as String
            addressTxtView.text = vendorAddress as String
            categoryDropDown.setTitle(category as String, for: UIControl.State.normal)
            subCategoryDropDown.setTitle(subCategory as String, for: UIControl.State.normal)

//            vendorListResult[indexPath.row].vendorName!
            
            if(isUpdate == "1"){

                vendorNameTF.text = vendorListResult[0].vendorName
                vendroDescriptionTxtView.text = vendorListResult[0].vendorDescription
                companyNameTF.text = vendorListResult[0].vendorCompany
                GSTInTF.text = vendorListResult[0].vendorGSTIN
                locationTF.text = vendorListResult[0].vendorLocation
                addressTxtView.text = vendorListResult[0].vendorAddress
//                categoryDropDown.setTitle(vendorListResult[0].category! as String, for: UIControl.State.normal)
//                subCategoryDropDown.setTitle(vendorListResult[0].subCategory! as String, for: UIControl.State.normal)
                addProductBtn.isHidden = true
                
                let dataDict = addVendorArray[0] as? NSDictionary
                
                let category = dataDict?.value(forKey: "category") as? String ?? ""
                let subCategory = dataDict?.value(forKey: "subCategory") as? String ?? ""
                
//                let status = dataDict.value(forKey: "status") as! Bool
                
                activeStatusDropBtn.setTitle("Active", for: .normal)
                
                let boolVal = dataDict?["status"] as! Bool
                
                if(boolVal){
                    
                }else{
                    
                }
                
                
//                if let booleanValue = dataDict["status"] as? Bool {
//
//                    if(booleanValue){
//                        activeStatusDropBtn.setTitle("Active", for: .normal)
//
//                    }else{
//                        activeStatusDropBtn.setTitle("Inactive", for: .normal)
//
//                    }
//                }

                
                activeLbl.isHidden = false
                activeStatusDropBtn.isHidden = false
                
                categoryDropDown.setTitle(category as String, for: UIControl.State.normal)
                subCategoryDropDown.setTitle(subCategory as String, for: UIControl.State.normal)


            }
        }
        
        addVendorScrollView.contentSize = CGSize(width: addVendorScrollView.frame.size.width, height: yValue+200)
        
        animatingView()
//        addVendorScrollView.contentOffset = CGPoint(x: 0, y: scrollViewYPos)

    }
    
    @objc func addVendorBtnTap(sender: UIButton!){
        
        self.addEmptyVendor()
        self.loadAddVendorUI()
        
    }
    
    @IBAction func activeBtnTap(_ sender: UIButton){
        
        let productArrayPosition : Int = sender.tag%10
        let productTagValue:Int = sender.tag / 10;

        catSubCatTagValue = sender.tag as Int
        catSubCatArrPosition = productArrayPosition as Int
        catSubCatIndexPosition = productTagValue as Int

        categoryDataArray = ["Active","Inactive"]
        categoryIDArray = ["",""]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select"
        viewTobeLoad.fields = self.categoryDataArray as! [String]
        viewTobeLoad.categoryIDs = self.categoryIDArray as! [String]
        viewTobeLoad.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

    }

    var subbuttonTap=String()
    var subbuttonTapPositon=Int()
    var selectedCategoryStr = ""
    @IBAction func category_SubCategoryBtnTap(_ sender: UIButton) {
        subbuttonTap="tap"
        
        var productArrayPosition = Int()
        var productTagValue=Int()
        let sstag:String = String(sender.tag)
        if sstag.count>5
        {
         productArrayPosition = sender.tag%100
         productTagValue = sender.tag / 100;
         
        }
        else
        {
         productArrayPosition = sender.tag%10
         productTagValue = sender.tag / 10;
            
        }
        subbuttonTapPositon=productArrayPosition
        catSubCatTagValue = sender.tag as Int
        catSubCatArrPosition = productArrayPosition as Int
        catSubCatIndexPosition = productTagValue as Int
        
        let dict = addVendorArray[catSubCatArrPosition] as! NSDictionary
        let selectedCatStr = dict.value(forKey: "category") as! String
        
        print(catSubCatIndexPosition as Any,catSubCatTagValue,catSubCatArrPosition)

        if(catSubCatIndexPosition == 3000){
            
            categoryDataArray = NSMutableArray()
            categoryIDArray = NSMutableArray()
//            categoryResult = [CategoryResult]()
            
            for categoryItems in self.categoryResult {
                
                self.categoryDataArray.add(categoryItems.name ?? "")
                self.categoryIDArray.add(categoryItems._id ?? "")

            }
            
//            self.getCategoriesDataFromServer()
            
//            self.getSubCategoriesDataFromServer()
            
            dropDown.dataSource = categoryDataArray as! [String]//4
                dropDown.anchorView = sender //5
                dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
                dropDown.show() //7
                dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
                  guard let _ = self else { return }
    //              sender.setTitle(item, for: .normal) //9
                    self?.categoryDropDown.setTitle(item as String, for: UIControl.State.normal)
                    let selectedId = self?.categoryIDArray[index]
                    dict.setValue(item, forKey: "category")
                    dict.setValue(selectedId, forKey: "categoryId")
                    self?.selectedCategoryStr = item
                    self?.selectedCategoryID = selectedId as? String
                    self?.getSubCategoriesDataFromServer()
                    self?.loadAddVendorUI()
                }
            
        }else if(catSubCatIndexPosition == 3001){
            
            if selectedCategoryStr == ""{
                self.showAlertWith(title: "Alert", message: "Select Category")
           
            }else{
                
                categoryDataArray = NSMutableArray()
                categoryIDArray = NSMutableArray()
//                categoryResult = [CategoryResult]()
                
//                selectedCategoryID = selectedCatStr
//                self.getSubCategoriesDataFromServer()
                
                for categoryItems in self.subCategoryResult {
                    
                    self.categoryDataArray.add(categoryItems.name ?? "")
                    self.categoryIDArray.add(categoryItems._id ?? "")

                }
                dropDown.dataSource = categoryDataArray as! [String]//4
                    dropDown.anchorView = sender //5
                    dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
                    dropDown.show() //7
                    dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
                      guard let _ = self else { return }
        //              sender.setTitle(item, for: .normal) //9
                        self?.subCategoryDropDown.setTitle(item as String, for: UIControl.State.normal)
                        dict.setValue(item, forKey: "subCategory")
                        let selecteSubId = self?.categoryIDArray[index]
                        dict.setValue(selecteSubId, forKey: "subCategoryId")
                        self?.loadAddVendorUI()
                    }
            }
        }
    }
    
    func sendnamedfields(fieldname:String,idStr:String){
        
        print(catSubCatArrPosition)
        
        selectedCategoryID = idStr
        
        var dict = NSMutableDictionary()
        dict = addVendorArray[catSubCatArrPosition] as! NSMutableDictionary

        if(catSubCatIndexPosition == 3000){ //Category Btn
            dict.setValue(fieldname, forKey: "category")
            dict.setValue(idStr, forKey: "categoryId")
            
            dict.setValue("", forKey: "subCategory")
            dict.setValue("", forKey: "subCategoryId")

            addVendorArray.replaceObject(at:catSubCatArrPosition!, with: dict)

        }else if(catSubCatIndexPosition == 3001){
            dict.setValue(fieldname, forKey: "subCategory")
            dict.setValue(fieldname, forKey: "subCategoryId")
            
            addVendorArray.replaceObject(at:catSubCatArrPosition!, with: dict)

        }
        
        
        else if(catSubCatIndexPosition == 5001){

            if(fieldname == "Active"){
                dict.setValue(true, forKey: "status")

            }else{
                dict.setValue(false, forKey: "status")

            }
            
            addVendorArray.replaceObject(at:catSubCatArrPosition!, with: dict)
        }
        
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
        print(addVendorArray)
//        self.loadAddVendorUI()
        
        print(catSubCatTagValue!)
        
        let tmpButton = addVendorScrollView.viewWithTag(catSubCatTagValue! ) as? UIButton
        tmpButton?.setTitleColor(hexStringToUIColor(hex: "232c51"), for: .normal)
        tmpButton?.setTitle(fieldname, for: .normal)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        textField.resignFirstResponder()
        return true
        
    }
    
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            let productArrayPosition : Int = textField.tag%10
            let productTagValue:Int = textField.tag / 10;
            
            var dict = NSMutableDictionary()
            dict = addVendorArray[productArrayPosition] as! NSMutableDictionary

            print(productArrayPosition)
            print(productTagValue)

            print(textField.tag)
            
            if productTagValue == 1000{ //Vendor Name
                dict.setValue(textField.text, forKey: "vendorName")
                if textField.text==""
                {
                    
                }
                else
                {
                    dict.setValue(false, forKey: "vendorWarn")
                }

            }else if(productTagValue == 1002){ //Company
                dict.setValue(textField.text, forKey: "vendorCompany")

            }else if(productTagValue == 1003){ //GSTIN
                dict.setValue(textField.text, forKey: "vendorGSTIN")

            }else if(productTagValue == 1004){ //Address
                dict.setValue(textField.text, forKey: "vendorLocation")

            }else if(productTagValue == 1005){ //Location
                dict.setValue(textField.text, forKey: "vendorAddress")

            }
            
            addVendorArray.replaceObject(at: productArrayPosition, with: dict)
    //        print(myProductArray)
            
        }
    
    func textViewDidEndEditing(_ textView: UITextView) {
          
          let productArrayPosition : Int = textView.tag%10
          let productTagValue:Int = textView.tag / 10;
          
          var dict = NSMutableDictionary()
          dict = addVendorArray[productArrayPosition] as! NSMutableDictionary

          print(productArrayPosition)
          print(productTagValue)

          if productTagValue == 1001{ //Description

              print("Product ID")
              print(textView.tag)

              dict.setValue(textView.text, forKey: "vendorDescription")

          }else if productTagValue == 1005{//Address
            dict.setValue(textView.text, forKey: "vendorAddress")

          }
          
          addVendorArray.replaceObject(at: productArrayPosition, with: dict)

      }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewYPos = scrollView.contentOffset.y

    }
    
    func parseEditVendorDetails(){
        
        var dict = NSMutableDictionary()
        dict = addVendorArray[0] as? NSMutableDictionary ?? NSMutableDictionary()

        let accID = vendorListResult[0].accountId as NSString? ?? ""
        let vendorName = vendorListResult[0].vendorName as NSString? ?? ""
        let vendorDescription = vendorListResult[0].vendorDescription as NSString? ?? ""
        let vendorCompany = vendorListResult[0].vendorCompany as NSString? ?? ""
        let vendorGSTIN = vendorListResult[0].vendorGSTIN as NSString? ?? ""
        let vendorLocation =  vendorListResult[0].vendorLocation as NSString? ?? ""
        let vendorAddress =  vendorListResult[0].vendorAddress as NSString? ?? ""
//        let isActive = vendorListResult[0].status as Bool?
        var category=String()
                   var categoryId=String()
        if vendorListResult[0].category as? String ?? "" == ""
                   {
                       if categoryResult.count>0
                       {
                           category=categoryResult[0].name ?? ""
                           categoryId=categoryResult[0]._id ?? ""
                       }
            vendorListResult[0].category=category
            vendorListResult[0].categoryId=categoryId
                       
                   }
                   else
                   {
                       category = vendorListResult[0].category as? String ?? ""
                   }
                   var subCategory=String()
                   var subCategoryId=String()
                   if vendorListResult[0].subCategory as? String ?? ""==""
                   {
                       if subCategoryResult.count>0
                       {
                           subCategory=subCategoryResult[0].name ?? ""
                           subCategoryId=subCategoryResult[0]._id ?? ""
                       }
                    vendorListResult[0].subCategory=subCategory
                    vendorListResult[0].subCategoryId=subCategoryId
                   }
                   else
                   {
                       subCategory = vendorListResult[0].subCategory as? String ?? ""
                   }
        let isActive = vendorListResult[0].status
        
        print(isActive!)
        
        dict.setValue(accID, forKey: "accountId")
        dict.setValue(vendorName, forKey: "vendorName")
        if vendorName==""
        {
        dict.setValue(true, forKey: "vendorWarn")
        }
        else
        {
            dict.setValue(false, forKey: "vendorWarn")
        }
        dict.setValue(vendorDescription, forKey: "vendorDescription")
        dict.setValue(category, forKey: "category")
        dict.setValue(subCategory, forKey: "subCategory")
        dict.setValue(vendorCompany, forKey: "vendorCompany")
        dict.setValue(vendorGSTIN, forKey: "vendorGSTIN")
        dict.setValue(vendorLocation, forKey: "vendorLocation")
        dict.setValue(vendorAddress, forKey: "vendorAddress")
        dict.setValue(vendorID, forKey: "_id")
        dict.setValue(isActive, forKey: "status")
//        dict.setValue(isActive, forKey: "status")

        
        addVendorArray.replaceObject(at: 0, with: dict)

        loadAddVendorUI()
        
    }
    
    func getCategoriesDataFromServer()  {
        
        categoryDataArray.removeAllObjects()
        categoryIDArray.removeAllObjects()
        
        categoryDataArray = NSMutableArray()
        categoryIDArray = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

            
                    let URLString_loginIndividual = Constants.BaseUrl + categoriesUrl
                                
                                    
                        addVendorServiceCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:CategoryRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                                    
//                            let adminID = respVo.result![0].name! as String
//                            print(adminID)
                                    
                            self.categoryResult = respVo.result!
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {

                                for categoryItems in self.categoryResult {
                                    
                                    self.categoryIDArray.add(categoryItems._id ?? "")
                                    self.categoryDataArray.add(categoryItems.name ?? "")
                                    
                                }
                                if self.categoryResult.count>0
                                {
                                self.selectedCategoryStr=respVo.result![0].name ?? ""
                                }
                                self.getSubCategoriesDataFromServer()
                                        
//                                        viewTobeLoad.modalPresentationStyle = .fullScreen
//                                        self.present(viewTobeLoad, animated: true, completion: nil)
                                print(self.categoryDataArray)
                                print(self.categoryIDArray)
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
    
    func getSubCategoriesDataFromServer()  {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        let newString = selectedCategoryStr.replacingOccurrences(of: " ", with: "%20")
                    let URLString_loginIndividual = Constants.BaseUrl + SubCategoriesUrl + newString
                                    
                            addVendorServiceCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:SubCategoryRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                                    
//                            let adminID = (respVo.result![0].name ?? "") as String
//                            print(adminID)
                                    
                            self.subCategoryResult = respVo.result!
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {

                                if self.subbuttonTap=="tap"
{
                                    let productArrayPosition : Int = self.subbuttonTapPositon
                                    let dict = self.addVendorArray[productArrayPosition] as! NSDictionary
                                    if self.subCategoryResult.count>0
                                    {
                                    dict.setValue(respVo.result![0].name, forKey: "subCategory")
                                    dict.setValue(respVo.result![0]._id, forKey: "subCategoryId")
                                    }
                                    
                                    self.subbuttonTap=""
                                    self.loadAddVendorUI()
}
                                print(self.categoryDataArray)
                                print(self.categoryIDArray)

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
    
    func showSucessMsg(title:String,message:String)  {
        
                let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
                //to change font of title and message.
                let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
                let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
                let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
                alertController.setValue(titleAttrString, forKey: "attributedTitle")
                alertController.setValue(messageAttrString, forKey: "attributedMessage")
                
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    self.navigationController?.popViewController(animated: true)
                    
//                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                          let VC = storyBoard.instantiateViewController(withIdentifier: "VendorListVC") as! VendorListingViewController
//                          VC.modalPresentationStyle = .fullScreen
////                          self.present(VC, animated: true, completion: nil)
//                    self.navigationController?.pushViewController(VC, animated: true)
                    
                })
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)

    }


    func addVendorAPICall() {
        
            let JSONStringFinal : String!
            
            do {

                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: addVendorArray, options: JSONSerialization.WritingOptions.prettyPrinted)

                //Convert back to string. Usually only do this for debugging

                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                   JSONStringFinal = JSONString
                    
                    activity.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    
                    let URLString_loginIndividual = Constants.BaseUrl + AddVendorUrl
                     
                                let params_IndividualLogin = [
                                    "" : ""
                                ]
                            
                                let postHeaders_IndividualLogin = ["":""]
                                
                    addVendorServiceCntrl.requestPOSTURLWithArray(strURL: URLString_loginIndividual as NSString, postParams: addVendorArray as NSArray, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                                    
                                    let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                            
                                    let status = respVo.status
                                    let messageResp = respVo.message
                                    let statusCode = respVo.statusCode
                                    
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                                
                                    if status == "SUCCESS" {
                                        
                                        if(statusCode == 200 ){
                                            self.showSucessMsg(title: "Success", message: messageResp ?? "")
                                            
                                        }else{
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

                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                var json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]


            } catch {
           
            }
        }
    
    func getVendorListDataFromServer() {
        
                activity.startAnimating()
                self.view.isUserInteractionEnabled = true
        
                let URLString_loginIndividual = Constants.BaseUrl + EditVendorListUrl + vendorID
        addVendorServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                                    let respVo:VendorListRespo = Mapper().map(JSON: result as! [String : Any])!
                                                            
                                    let status = respVo.status
                                    let messageResp = respVo.message
                                    _ = respVo.statusCode
                                    
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                                
                                    if status == "SUCCESS" {
                                        
                                        self.vendorListResult = respVo.result!
                                        self.loadAddVendorUI()
                                        
                                        self.parseEditVendorDetails()
                                        
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
    
    func editVendorAPICall() {
        
        print(addVendorArray)
            
            let JSONStringFinal : String!
            
//            do {

                //Convert to Data
//                let jsonData = try JSONSerialization.data(withJSONObject: addVendorArray, options: JSONSerialization.WritingOptions.prettyPrinted)

                //Convert back to string. Usually only do this for debugging

//                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
//                   JSONStringFinal = JSONString
                    
                    activity.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    
                    let URLString_loginIndividual = Constants.BaseUrl + UpdateVendorUrl
                     
                                let params_IndividualLogin = [
                                    "" : ""
                                ]
                            
                                let postHeaders_IndividualLogin = ["":""]
                                
                    addVendorServiceCntrl.requestPOSTURLWithArray(strURL: URLString_loginIndividual as NSString, postParams: addVendorArray as NSArray, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                                    
                                    let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                            
                                    let status = respVo.status
                                    let messageResp = respVo.message
                                    let statusCode = respVo.statusCode
                                    
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                                
                                    if status == "SUCCESS" {
                                        
                                        if(statusCode == 200 ){
                                            self.showSucessMsg(title: "Success", message: "Details updated successfully")
                                            
                                        }else{
                                            
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
//                }

                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
//                var json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]


//            } catch {
//
//            }
        }
}
