//
//  VendorProductSearchViewController.swift
//  Lekhha
//
//  Created by USM on 27/05/21.
//

import UIKit
import ObjectMapper

class VendorProductSearchViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var searchTF: UITextField!
    
    @IBAction func vendorApplyBtnTapped(_ sender: Any) {
        filterApplyAPI()
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBOutlet weak var searchProdTblView: UITableView!
    
    var productListArray = NSMutableArray()
    
    var filterKeyStr = ""
    var startDateStr = ""
    var endDateStr = ""
    
    var isStartDateStr = ""
    
    var accountID = String()
    var serviceCntrl = ServiceController()
    
    var vendorProdBottomView = VendorProductFilterBottomView()
    
    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
    var picker : UIDatePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: searchTF.frame.size.width - (35), y: 0, width: 35, height: searchTF.frame.size.height)
        searchTF.rightView = paddingView
        searchTF.rightViewMode = UITextField.ViewMode.always
        
        searchTF.delegate = self
        
        let filterBtn = UIButton()
        filterBtn.frame = CGRect(x: paddingView.frame.size.width/2 - 12.5, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
        paddingView.addSubview(filterBtn)

        filterBtn.addTarget(self, action: #selector(filterBtnTap), for: .touchUpInside)
        
       
        searchProdTblView.delegate = self
        searchProdTblView.dataSource = self
        
        searchProdTblView.register(UINib(nibName: "VendorAddProductTableViewCell", bundle: nil), forCellReuseIdentifier: "VendorAddProductTableViewCell")


        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }

    @objc func filterBtnTap(_ sender: UIButton) {
        toggleProductSortViewWithAnimation()
        
    }
    
    func toggleProductSortViewWithAnimation() {
        
//        vendorProdBottomView.startDateBtn.setTitle("", for: .normal)
//        vendorProdBottomView.endDateBtn.setTitle("", for: .normal)
        
        filterKeyStr = ""
        startDateStr = ""
        endDateStr = ""
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("VendorProductFilterBottomView", owner: self, options: nil)
        vendorProdBottomView = allViewsInXibArray?.first as! VendorProductFilterBottomView
        vendorProdBottomView.frame = CGRect(x: 0, y: self.view.frame.size.height+350, width: self.view.frame.size.width, height: self.view.frame.size.height)
         self.view.addSubview(vendorProdBottomView)
        
        vendorProdBottomView.prodNameCheckBoxBtn.addTarget(self, action: #selector(prodNameCheckBoxBtnTapped), for: .touchUpInside)
        
        vendorProdBottomView.prodKeywordsCheckBoxBtn.addTarget(self, action: #selector(prodKeywordsCheckBoxBtnTap), for: .touchUpInside)

        vendorProdBottomView.prodCategoryBtn.addTarget(self, action: #selector(prodCategoryBtnTap), for: .touchUpInside)
        
        vendorProdBottomView.prodSubcategoryBtn.addTarget(self, action: #selector(prodSubcategoryBtnTap), for: .touchUpInside)
    
        vendorProdBottomView.transactionByDateBtn.addTarget(self, action: #selector(transactionByDateBtnTap(_:)), for: .touchUpInside)

        vendorProdBottomView.endDateBtn.addTarget(self, action: #selector(endDateBtnTap(_:)), for: .touchUpInside)
        
        vendorProdBottomView.startDateBtn.addTarget(self, action: #selector(startDateBtnTap(_:)), for: .touchUpInside)

        vendorProdBottomView.applyBtn.addTarget(self, action: #selector(popUpApplyBtnTap(_:)), for: .touchUpInside)
        
        vendorProdBottomView.closeBtn.addTarget(self, action: #selector(popUpCloseBtnTap(_:)), for: .touchUpInside)


    
//        let path = UIBezierPath(roundedRect:vendorProdBottomView.cardView.bounds,
//                                byRoundingCorners:[.topRight, .topLeft],
//                                cornerRadii: CGSize(width: 20, height:  20))
//
//        let maskLayer = CAShapeLayer()
//
//        maskLayer.path = path.cgPath
//        vendorProdBottomView.cardView.layer.mask = maskLayer
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.vendorProdBottomView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.vendorProdBottomView)
            

         }, completion: { (finished: Bool) -> Void in
            self.vendorProdBottomView.hiddenBackBtn.isHidden = false

         })
       }
    
    @objc func popUpCloseBtnTap(_ sender: UIButton){
        self.vendorProdBottomView.hiddenBackBtn.isHidden = true
        vendorProdBottomView.removeFromSuperview()
        
    }
    
    @objc func prodNameCheckBoxBtnTapped(_ sender: UIButton) {
        
        filterKeyStr = "productName"
        
        vendorProdBottomView.prodNameCheckBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
        vendorProdBottomView.prodKeywordsCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.prodCategoryBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.prodSubcategoryBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.transactionByDateBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)

    }
    
    @objc func prodKeywordsCheckBoxBtnTap(_ sender: UIButton) {
        
        filterKeyStr = "keyWords"

        vendorProdBottomView.prodNameCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.prodKeywordsCheckBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
        vendorProdBottomView.prodCategoryBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.prodSubcategoryBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.transactionByDateBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)

    }
    
    @objc func prodCategoryBtnTap(_ sender: UIButton) {
        
        filterKeyStr = "category"

        vendorProdBottomView.prodNameCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.prodKeywordsCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.prodCategoryBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
        vendorProdBottomView.prodSubcategoryBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.transactionByDateBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)

    }

    @objc func prodSubcategoryBtnTap(_ sender: UIButton) {
        
        filterKeyStr = "subCategory"
        
        vendorProdBottomView.prodNameCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.prodKeywordsCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.prodCategoryBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.prodSubcategoryBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
        vendorProdBottomView.transactionByDateBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)

    }
    
    @objc func transactionByDateBtnTap(_ sender: UIButton) {
        
        filterKeyStr = "transactionByDate"

        vendorProdBottomView.prodNameCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.prodKeywordsCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.prodCategoryBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.prodSubcategoryBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
        vendorProdBottomView.transactionByDateBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)

    }
    @objc func endDateBtnTap(_ sender: UIButton) {
        isStartDateStr = "0"
        datePickerView()

    }
    @objc func startDateBtnTap(_ sender: UIButton) {
        isStartDateStr = "1"
        
        datePickerView()
    }
    @objc func popUpApplyBtnTap(_ sender: UIButton) {
        filterApplyAPI()
        
    }
    
    
    //****************** TableView Delegate Methods*************************//
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productListArray.count
         
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = searchProdTblView.dequeueReusableCell(withIdentifier: "VendorAddProductTableViewCell", for: indexPath) as! VendorAddProductTableViewCell
        
        
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
        cell.subCategoryLbl.text = dataDict?.value(forKey: "subCategory") as? String
        
        let prodArray = dataDict?.value(forKey: "productImages") as? NSArray
        
        cell.editProductBtn.addTarget(self, action: #selector(editProdBtnTap), for: .touchUpInside)

        if(prodArray?.count ?? 0  > 0){

                    let dict = prodArray?[0] as? NSDictionary
                    
            let imageStr = dict?.value(forKey: "0") as! String
                    
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
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
         
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 335

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

        if(isStartDateStr == "1"){ //Start Btn
            vendorProdBottomView.startDateBtn.setTitle(result, for: .normal)
            startDateStr = result

        }else{
            vendorProdBottomView.endDateBtn.setTitle(result, for: .normal)
            endDateStr = result

        }
   }
   
   @objc func dueDateChanged(sender:UIDatePicker){
       
       let dateFormatter = DateFormatter()
       
       dateFormatter.dateFormat = "dd/MM/yyyy"
       let selectedDate = dateFormatter.string(from: picker.date)

       if(isStartDateStr == "1"){ //Start Btn
        vendorProdBottomView.startDateBtn.setTitle(selectedDate, for: .normal)
        startDateStr = selectedDate
        
       }else {
        vendorProdBottomView.endDateBtn.setTitle(selectedDate, for: .normal)
        endDateStr = selectedDate
        
       }
   }
   
   @objc func doneBtnTap(_ sender: UIButton) {

       hiddenBtn.removeFromSuperview()
       pickerDateView.removeFromSuperview()
       
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

    func filterApplyAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        let URLString_loginIndividual = Constants.BaseUrl + VendorProductLocalSearchAPI
        
        let params_IndividualLogin = [
            "accountId":accountID,
            "searchParam":searchTF.text ?? "",
            "filterKey": filterKeyStr,
            "start":startDateStr,
            "end":endDateStr] as [String : Any]
        
        let postHeaders_IndividualLogin = ["":""]
        
        serviceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { [self] (result) in
            
            let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            //                        let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if status == "SUCCESS" {
                
                let dataDict = result as! NSDictionary
                
                self.productListArray = dataDict.value(forKey: "result") as! NSMutableArray
                self.searchProdTblView.reloadData()
                
                if(vendorProdBottomView.hiddenBackBtn != nil){
                    
                    vendorProdBottomView.hiddenBackBtn.isHidden = true
                    vendorProdBottomView.removeFromSuperview()

                }
                
                
                filterKeyStr = ""
                startDateStr = ""
                endDateStr = ""
                
                if(self.productListArray.count > 0){
//                    self.emptyMsgBtn.removeFromSuperview()
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
