//
//  VendorGlobalSearchViewController.swift
//  Lekhha
//
//  Created by USM on 09/06/21.
//

import UIKit
import ObjectMapper

class VendorGlobalSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var orderListArray = NSMutableArray()
    var tabStatusStr = "Products"
    var productListArray = NSMutableArray()
    var filterBottomView = VendorGlobalSearchBottomView()
    
    var filterKeyStr = ""
    
    var accountID = String()
    var serviceCntrl = ServiceController()
    
    var emptyMsgBtn = UIButton()
    var startDateStr = ""
    var endDateStr = ""
    
    var isStartDateStr = ""
    
    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
    var picker : UIDatePicker = UIDatePicker()


    @IBOutlet weak var lookingForTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: lookingForTF.frame.size.width - (35), y: 0, width: 35, height: lookingForTF.frame.size.height)
        lookingForTF.rightView = paddingView
        lookingForTF.rightViewMode = UITextField.ViewMode.always
        
        lookingForTF.delegate = self
        
        globalSearchTblView.delegate = self
        globalSearchTblView.dataSource = self
        
        let filterBtn = UIButton()
        filterBtn.frame = CGRect(x: paddingView.frame.size.width/2 - 12.5, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
        paddingView.addSubview(filterBtn)
        
       filterBtn.addTarget(self, action: #selector(filterBtnTapped), for: .touchUpInside)

        
        ordersUnderLineLbl.isHidden = true
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        print(accountID)
        
        globalSearchTblView.register(UINib(nibName: "VendorAddProductTableViewCell", bundle: nil), forCellReuseIdentifier: "VendorAddProductTableViewCell")

        globalSearchTblView.register(UINib(nibName: "VendorOrdersDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "VendorOrdersDetailsTableViewCell")

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
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
//           getGlobalSearchFilterAPI()

    }
    
    @objc func filterBtnTapped(){
        
        filterKeyStr = "transactionByDate"
        toggleBottomViewWithAnimation()
        
    }
    
    @IBOutlet weak var prodUnderLineLbl: UILabel!
    @IBOutlet weak var ordersUnderLineLbl: UILabel!
    @IBOutlet weak var globalSearchTblView: UITableView!
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func productBtnTapped(_ sender: Any) {
        
        tabStatusStr = "Products"
        prodUnderLineLbl.isHidden = false
        ordersUnderLineLbl.isHidden = true
        
        startDateStr = ""
        endDateStr = ""
        
        if(productListArray.count > 0){
            globalSearchTblView.reloadData()

        }else{
            showEmptyMsgBtn()
        }
        
//        getGlobalSearchFilterAPI()
    }
    
    @IBAction func ordersBtnTapped(_ sender: Any) {
        
        tabStatusStr = "Orders"
        prodUnderLineLbl.isHidden = true
        ordersUnderLineLbl.isHidden = false
        
        startDateStr = ""
        endDateStr = ""
        
        if(orderListArray.count > 0){
            globalSearchTblView.reloadData()

        }else{
            showEmptyMsgBtn()
        }

//        getGlobalSearchFilterAPI()
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
    
    func toggleBottomViewWithAnimation() {

        let allViewsInXibArray = Bundle.main.loadNibNamed("VendorGlobalSearchBottomView", owner: self, options: nil)
        filterBottomView = allViewsInXibArray?.first as! VendorGlobalSearchBottomView
        filterBottomView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
         self.view.addSubview(filterBottomView)
        
        filterBottomView.cancelBtn.addTarget(self, action: #selector(bottomCancelBtntapped), for: .touchUpInside)
        
        filterBottomView.startDateBtn.addTarget(self, action: #selector(bottomStartDateBtnTapped), for: .touchUpInside)
        
        filterBottomView.applyBtn.addTarget(self, action: #selector(bottomFilterApplyBtnTapped), for: .touchUpInside)

//        filterBottomView.endDateBtn.addTarget(self, action: #selector(localShoppingSortEndDateBtnTap), for: .touchUpInside)
        
        filterBottomView.endDateBtnn.addTarget(self, action: #selector(bottomEndDataBtnTapped), for: .touchUpInside)
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.filterBottomView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.filterBottomView)
            

         }, completion: { (finished: Bool) -> Void in
            self.filterBottomView.backHiddenBtn.isHidden = false

         })

    }
    
    @objc func bottomCancelBtntapped(){
        
        filterKeyStr = ""
        
        filterBottomView.backHiddenBtn.isHidden = true
        filterBottomView.removeFromSuperview()
    }

    @objc func bottomStartDateBtnTapped(){
        isStartDateStr = "1"
        datePickerView()
        
    }
    
    @objc func bottomEndDataBtnTapped(){
        isStartDateStr = "0"
        datePickerView()
        
    }
    
    @objc func bottomFilterApplyBtnTapped(){
        
        filterBottomView.backHiddenBtn.isHidden = true
        filterBottomView.removeFromSuperview()
        
        getGlobalSearchFilterAPI()
        
    }
    
    @IBAction func applyBtnTapped(_ sender: UIButton) {
        getGlobalSearchFilterAPI()

    }
    
    func datePickerView()  {
        
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
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        
        if(isStartDateStr == "1"){
            filterBottomView.startDateBtn.setTitle(result, for: .normal)
            startDateStr = result
            
        }else{
            filterBottomView.endDateBtnn.setTitle(result, for: .normal)
            endDateStr = result
        }
    }
    
    @objc func dueDateChanged(sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: picker.date)
        
        if(isStartDateStr == "1"){
            
            filterBottomView.startDateBtn.setTitle(selectedDate, for: .normal)
            startDateStr = selectedDate
            
        }else{
            filterBottomView.endDateBtnn.setTitle(selectedDate, for: .normal)
            endDateStr = selectedDate
            
        }
    }
    
    @objc func doneBtnTap(_ sender: UIButton) {
        
        hiddenBtn.removeFromSuperview()
        pickerDateView.removeFromSuperview()
        
    }


    @IBAction func homeBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "VendorOrdersViewController") as! VendorOrdersViewController
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

    }
    
    //****************** TableView Delegate Methods*************************//
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tabStatusStr == "Products"){
            return productListArray.count
       
        }else{
            return orderListArray.count

        }
        
         
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(tabStatusStr == "Products"){
            return 335

        }else{
            
            let dataDict = orderListArray.object(at: indexPath.row) as? NSDictionary
            let orderStatus = dataDict?.value(forKey: "orderStatus") as? String

            if(orderStatus == "Approved" || orderStatus == "Rejected"){
                return 230

            }else{
                return 280

            }
        }
    }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tabStatusStr == "Products"){
            
            let cell = globalSearchTblView.dequeueReusableCell(withIdentifier: "VendorAddProductTableViewCell", for: indexPath) as! VendorAddProductTableViewCell
           
           let dataDict = productListArray.object(at: indexPath.row) as? NSDictionary
           
           cell.idLbl.text = dataDict?.value(forKey: "_id") as? String
           cell.prodNameLbl.text = dataDict?.value(forKey: "productName") as? String
           cell.descLbl.text = dataDict?.value(forKey: "description") as? String
           
           let stockQuan = dataDict?.value(forKey: "stockQuantity") as? Int
           cell.stockQtyLbl.text = String(stockQuan ?? 0)

           cell.stockUnitLbl.text = dataDict?.value(forKey: "stockUnit") as? String
           
           let actualPrice = dataDict?.value(forKey: "actualPrice") as? Int
           cell.actualPriceLbl.text = String(actualPrice ?? 0)
           
           let offerPrice = dataDict?.value(forKey: "offeredPrice") as? Int
           cell.actualPriceLbl.text = String(offerPrice ?? 0)

           let expiryDate = (dataDict?.value(forKey: "expiryDate") as? String) ?? ""
               let convertedExpiryDate = convertDateFormatter(date: expiryDate)
               cell.expiryDateLbl.text = convertedExpiryDate

           cell.categoryLbl.text = dataDict?.value(forKey: "category") as? String
           cell.subCategoryLbl.text = dataDict?.value(forKey: "") as? String
           
           let prodArray = dataDict?.value(forKey: "productImages") as? NSArray
           
           cell.editProductBtn.addTarget(self, action: #selector(editProdBtnTap), for: .touchUpInside)

           if(prodArray?.count ?? 0  > 0){

                       let dict = prodArray?[0] as! NSDictionary
                       
                       let imageStr = dict.value(forKey: "0") as! String
                       
                       if !imageStr.isEmpty {
                           
                           let imgUrl:String = imageStr
                           
                           let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                               
                           let imggg = Constants.BaseImageUrl + trimStr
                           
   //                            let url = URL.init(string: imggg)
                           
   //                            let fileUrl = URL(fileURLWithPath: imggg)
                           let fileUrl = URL(string: imggg)

   //                            cell.prodImgView?.sd_setImage(with: fileUrl , placeholderImage: UIImage(named: "add photo"))
                           
                           cell.prodImgView?.sd_setImage(with: fileUrl, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                           cell.prodImgView?.contentMode = UIView.ContentMode.scaleAspectFit
                           
                       }
                       
                       else {
                           
                           cell.prodImgView?.image = UIImage(named: "no_image")
                       }
           }else{
               cell.prodImgView?.image = UIImage(named: "no_image")

           }
           
            return cell

            
        }else{
            
            let cell = globalSearchTblView.dequeueReusableCell(withIdentifier: "VendorOrdersDetailsTableViewCell", for: indexPath) as! VendorOrdersDetailsTableViewCell
            
            let dataDict = orderListArray.object(at: indexPath.row) as? NSDictionary
            
            cell.orderIDLbl.text = dataDict?.value(forKey: "orderId") as? String
            cell.productCountLbl.text = ""
            cell.orderPriceLbl.text = ""
    //         cell.doorDeliveryLbl.text = ""
            cell.accIDLbl.text = dataDict?.value(forKey: "accountId") as? String
            cell.locationLbl.text = ""
           
           let prodCount = dataDict?.value(forKey: "productCount") as? Int
           let orderPrice = dataDict?.value(forKey: "orderPrice") as? Int

           cell.productCountLbl.text = String(prodCount ?? 0)
           cell.orderPriceLbl.text = String(orderPrice ?? 0)
           
           if(isActive == "Active"){
               
               let orderStatus = dataDict?.value(forKey: "orderStatus") as? String
               
               
               if(orderStatus == "Approved"){
                   cell.orderStatusImgView.image = UIImage.init(named: "orderAccepted")
                   cell.acceptBtn.isHidden = true
                   cell.declineBtn.isHidden = true
                   
               }else if(orderStatus == "Rejected"){
                   cell.orderStatusImgView.image = UIImage.init(named: "orderRejected")
                   cell.acceptBtn.isHidden = true
                   cell.declineBtn.isHidden = true
                   
               }else{
                   cell.acceptBtn.isHidden = false
                   cell.declineBtn.isHidden = false

                   cell.orderStatusImgView.isHidden = true
                   
               }
           }else if(isActive == ""){
               
               cell.acceptBtn.isHidden = true
               cell.declineBtn.isHidden = true

               cell.orderStatusImgView.isHidden = true
               
           }else{
               
               cell.acceptBtn.isHidden = true
               cell.declineBtn.isHidden = true

               cell.orderStatusImgView.isHidden = true

           }
            
            return cell

        }
         
     }
    
    @objc func editProdBtnTap(_ sender: UIButton) {

                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                  let VC = storyBoard.instantiateViewController(withIdentifier: "VendorAddProductViewController") as! VendorAddProductViewController
                                  VC.modalPresentationStyle = .fullScreen
                                  VC.isEditVendorProduct = true
                                  VC.editProductDict = (productListArray.object(at: sender.tag) as? NSDictionary)!
        //                          self.present(VC, animated: true, completion: nil)
                            self.navigationController?.pushViewController(VC, animated: true)

    }
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

    }
    
    func getGlobalSearchFilterAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + VendoeGlobalSearchUrl
        
        let params_IndividualLogin = ["accountId":accountID,"searchParam":lookingForTF.text ?? "","start":startDateStr,"end":endDateStr,"filterKey":filterKeyStr] as [String : Any]
                
                    let postHeaders_IndividualLogin = ["":""]
                    
                    serviceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                        
                        self.filterKeyStr = ""
                                        
                            if status == "SUCCESS" {
                                
                                let dataDict = result as! NSDictionary
                                
                                self.productListArray = dataDict.value(forKey: "productResult") as! NSMutableArray
                                
                                self.orderListArray = dataDict.value(forKey:"orderResult") as! NSMutableArray
                                
                                self.globalSearchTblView.reloadData()
                                
                                if(self.tabStatusStr == "Products"){
                                    
                                    if(self.productListArray.count > 0){
                                        self.emptyMsgBtn.removeFromSuperview()
                                        
                                        print(self.accountID)

                                    }else if(self.productListArray.count == 0){
                                        self.showEmptyMsgBtn()
                                    }
                                }else{
                                    if(self.orderListArray.count > 0){
                                        self.emptyMsgBtn.removeFromSuperview()
                                        print(self.accountID)

                                    }else if(self.orderListArray.count == 0){
                                        self.showEmptyMsgBtn()
                                    }
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
        
        if(tabStatusStr == "Products"){
            if(self.productListArray.count == 0){
//                self.showEmptyMsgBtn()
         }
        }else{
            if(self.orderListArray.count == 0){
//                self.showEmptyMsgBtn()
                
           }
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
