//
//  VendorListingViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 21/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper

class VendorListingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var lookingForTxtField: UITextField!
    var emptyMsgBtn = UIButton()
    var sideMenuView = SideMenuView()

    var isAddProd = ""
    
    @IBAction func onClickAddButtonAction(_ sender: UIButton) {
    }
    @IBOutlet var addButton: UIButton!
    @IBAction func onClickSortButtonAction(_ sender: UIButton) {
    }
    @IBAction func onClickSearchButtonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var menuBtn: UIButton!
    @IBAction func menuBtnTapped(_ sender: Any) {
        
        if(isAddProd == "1"){
            self.navigationController?.popViewController(animated: true)

        }else{
            toggleSideMenuViewWithAnimation()

        }
    }
    
    func toggleSideMenuViewWithAnimation() {
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("SideMenuView", owner: self, options: nil)
         sideMenuView = allViewsInXibArray?.first as! SideMenuView
         sideMenuView.frame = CGRect(x: -320, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
         self.view.addSubview(sideMenuView)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.sideMenuView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.sideMenuView)
            
            self.sideMenuView.loadSideMenuView(viewCntrl: self, status: "")

         }, completion: { (finished: Bool) -> Void in

         })
    }
    
    @IBAction func addVendorBtnTapped(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddVendorVC") as! AddVendorMasterViewController
        VC.modalPresentationStyle = .fullScreen
        VC.isUpdate = "0"
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)


    }
    @IBOutlet weak var vendorListTblView: UITableView!
    var accountID = String()
    var vendorServiceCntrl = ServiceController()
    var vendorListResult = [VendorListResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isAddProd == "1"){
            menuBtn.setImage(UIImage.init(named: "backWhite"), for: .normal)
        }
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: lookingForTxtField.frame.size.width - (35), y: 0, width: 35, height: lookingForTxtField.frame.size.height)
        lookingForTxtField.rightView = paddingView
        lookingForTxtField.rightViewMode = UITextField.ViewMode.always
        
        lookingForTxtField.delegate = self
        
        let filterBtn = UIButton()
        filterBtn.frame = CGRect(x: paddingView.frame.size.width/2 - 12.5, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
        paddingView.addSubview(filterBtn)
        
        filterBtn.addTarget(self, action: #selector(onFilterBtnTapped), for: .touchUpInside)

        vendorListTblView.register(UINib(nibName: "VendorListTableViewCell", bundle: nil), forCellReuseIdentifier: "VendorListCell")

        vendorListTblView.delegate = self
        vendorListTblView.dataSource = self
        
        animatingView()
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == lookingForTxtField){
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "GlobalSearchViewController") as! GlobalSearchViewController
                        //      self.navigationController?.pushViewController(VC, animated: true)
            VC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(VC, animated: true)
            
            textField.resignFirstResponder()

        }
    }
    
    @objc func onFilterBtnTapped(){
     
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "GlobalSearchViewController") as! GlobalSearchViewController
                    //      self.navigationController?.pushViewController(VC, animated: true)
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)
        
        lookingForTxtField.resignFirstResponder()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getVendorListDataFromServer()

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
    
    // MARK: - UITableViewDataSource

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return vendorListResult.count
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "VendorListCell", for: indexPath) as! VendorListTableViewCell
            
            if vendorListResult.count > 0{
                
                cell.vendorNameLbl.text = vendorListResult[indexPath.row].vendorName as? String
                cell.vendorIdLbl.text = vendorListResult[indexPath.row]._id as? String
                cell.descriptionLbl.text = vendorListResult[indexPath.row].vendorDescription as? String
                cell.categoryLbl.text = vendorListResult[indexPath.row].category as? String
                cell.subCategoryLbl.text = vendorListResult[indexPath.row].subCategory as? String
                cell.companyNameLbl.text = vendorListResult[indexPath.row].vendorCompany as? String
                cell.GSTInLbl.text = vendorListResult[indexPath.row].vendorGSTIN as? String
                cell.locationLbl.text = vendorListResult[indexPath.row].vendorLocation as? String
                cell.addressLbl.text = vendorListResult[indexPath.row].vendorAddress as? String
                
                if indexPath.row==0
                {
                    cell.editBtn.isHidden=true
                }
                else
                {
                    cell.editBtn.isHidden=false
                cell.editBtn.addTarget(self, action: #selector(editBtnTapped), for: .touchUpInside)
                cell.editBtn.tag = indexPath.row
                }
                
                let status = vendorListResult[indexPath.row].status! as Bool
                
                if(status == true){
                    cell.statusLbl.text = "Active"
                    cell.statusLbl.textColor = UIColor.green

                }else{
                    cell.statusLbl.text = "Inactive"
                    cell.statusLbl.textColor = hexStringToUIColor(hex: "ed3a50")

                }

            }
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350

    }
    
    @objc func editBtnTapped(sender: UIButton!){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddVendorVC") as! AddVendorMasterViewController
        VC.modalPresentationStyle = .fullScreen
        VC.vendorID = vendorListResult[sender.tag]._id!
        VC.isUpdate = "1"
//        vendorListResult[indexPath.row]._id!
//        self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

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
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

    }
    
    func getVendorListDataFromServer() {
        
        vendorListResult = [VendorListResult]()
        
                activity.startAnimating()
                self.view.isUserInteractionEnabled = false

        print(accountID)
        
//        accountID = "5f8970b099c2f076c8c54af6"
        
                let URLString_loginIndividual = Constants.BaseUrl + VendorMasterListUrl + accountID as String
                                    vendorServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                                    let respVo:VendorListRespo = Mapper().map(JSON: result as! [String : Any])!
                                                            
                                    let status = respVo.status
                                    let messageResp = respVo.message
                                    _ = respVo.statusCode
                                    
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                                
                                    if status == "SUCCESS" {
                                        
                                        self.vendorListResult = respVo.result!
                                        
                                        if(self.vendorListResult.count > 0){
                                            self.emptyMsgBtn.removeFromSuperview()
                                            self.vendorListTblView.reloadData()
                                       
                                        }else if(self.vendorListResult.count == 0){
                                            self.showEmptyMsgBtn()
                                        }

                                        
                                        
        //                                let userId = respVo.result![0].productDict?.accountEmailId
        //                                print(userId)
                                        
                                    }
                                    else {
                                        
                                        self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                        
                                    }
                                    
                                }) { (error) in
                                    
                                    activity.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                    print("Something Went To Wrong...PLrease Try Again Later")
                                }
        
        if(self.vendorListResult.count == 0){
//            self.showEmptyMsgBtn()
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
