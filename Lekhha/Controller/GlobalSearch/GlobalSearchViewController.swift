//
//  GlobalSearchViewController.swift
//  Lekha
//
//  Created by USM on 01/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper

class GlobalSearchViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBOutlet weak var searchResultsView: UIView!
    @IBOutlet weak var headerTitlelbl: UILabel!
    
    var permissionStatusArray = NSArray()
    var statusArray = NSArray()
    
    var filterModuleName = ""
    
    var isTransactionByStr = "0"
    
    let filtersDataArray = NSMutableArray()

    
    var FiltterView = BottomView()
    var localSortBottomView = LocalBottomView()
    
    @IBOutlet weak var globalSearchTblView: UITableView!
    
    @IBOutlet weak var searchTblView: UITableView!
    
    var picker : UIDatePicker = UIDatePicker()
    
    var globarSearchServiceCntrl = ServiceController()

    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
    
    var filterSortStatus = String()
    var searchFilterStatusStr = String()
    var filterStartDateStr = String()
    var filetEndDateStr = String()
    
    var currentInvenFilterStatus = String()
    var shoppingCartFilterStatus = String()
    var openOrdersFilterStatus = String()
    var ordersHistoryFilterStatus = String()
    
    var searchResultsArray = NSMutableArray()
    var accountID = String()
    
    var isLocalSearch = String()
    var stockQuanStr = String()
    
    @IBOutlet weak var lookingForTxtField: UITextField!
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }
    
    var moduleStatusStr = String()
    
    @IBAction func applyBtnTapped(_ sender: Any) {
        
        if(lookingForTxtField.text == ""){
            self.showAlertWith(title: "Alert", message: "Please enter looking for data")
            return
        }
        
//        if(isLocalSearch == "1"){
//            filterLocalSearchApplyAPI()
//
//        }else{
            filterGlobalSearchApplyAPI()

//        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        if(isLocalSearch == "1"){
            headerTitlelbl.text = "Local Search"
            searchTblView.isHidden = true
        }
        
        statusArray = ["0-20","20-40","40-60","60-80","80-100","Above 100"]
        
        currentInvenFilterStatus = ""
        shoppingCartFilterStatus = ""
        openOrdersFilterStatus = ""
        ordersHistoryFilterStatus = ""
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: lookingForTxtField.frame.size.width - (35), y: 0, width: 35, height: lookingForTxtField.frame.size.height)
        lookingForTxtField.rightView = paddingView
        lookingForTxtField.rightViewMode = UITextField.ViewMode.always
        
        lookingForTxtField.delegate = self
        
        let filterBtn = UIButton()
        filterBtn.frame = CGRect(x: paddingView.frame.size.width/2 - 12.5, y: paddingView.frame.size.height/2 - 12.5, width: 25, height: 25)
        filterBtn.setImage(UIImage.init(named: "search_filter_icon"), for: .normal)
        paddingView.addSubview(filterBtn)
        
        filterBtn.addTarget(self, action: #selector(filterBtnTapped), for: .touchUpInside)
        
        searchTblView.register(UINib(nibName: "GlobalSearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "GlobalSearchResultTableViewCell")
        
        globalSearchTblView.register(UINib(nibName: "GlobalFilterResultTableViewCell", bundle: nil), forCellReuseIdentifier: "GlobalFilterResultTableViewCell")

        globalSearchTblView.delegate = self
        globalSearchTblView.dataSource = self
//
//        globalSearchTblView.reloadData()
        
//        searchResultsView.isHidden = true
        
        searchTblView.delegate = self
        searchTblView.dataSource = self

        animatingView()
        getSearchResultsAPI()
        
        // Doany additional setup after loading the view.
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        textField.resignFirstResponder()
        return true
        
    }


    @IBAction func filterBtnTapped(_ sender: UIButton){
        
        lookingForTxtField.resignFirstResponder()
        
        if(isLocalSearch == "1"){
            toggleLocalSortViewWithAnimation()

        }else{
            toggleBottomSortViewWithAnimation()

        }
    }
    
    func toggleLocalSortViewWithAnimation() {
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("LocalBottomView", owner: self, options: nil)
        localSortBottomView = allViewsInXibArray?.first as! LocalBottomView
        localSortBottomView.frame = CGRect(x: 0, y: self.view.frame.size.height+350, width: self.view.frame.size.width, height: self.view.frame.size.height)
         self.view.addSubview(localSortBottomView)
        
        localSortBottomView.cancelBtn.addTarget(self, action: #selector(localSortCancelBtnTapped), for: .touchUpInside)
        
        localSortBottomView.purchaseDateBtn.addTarget(self, action: #selector(localSortPurchaseDateBtnTap), for: .touchUpInside)

        localSortBottomView.expiryDateBtn.addTarget(self, action: #selector(localSortEndDateBtnTap), for: .touchUpInside)
        
        localSortBottomView.quantityBtn.addTarget(self, action: #selector(localQuanBtnTap), for: .touchUpInside)

    
        localSortBottomView.startDateBtn.addTarget(self, action: #selector(startdateBtnTapped(_:)), for: .touchUpInside)

        localSortBottomView.endDateBtn.addTarget(self, action: #selector(enddateBtnTapped(_:)), for: .touchUpInside)
    

        localSortBottomView.applyBtn.addTarget(self, action: #selector(filterApplyBtnTapped(_:)), for: .touchUpInside)

    
//        let path = UIBezierPath(roundedRect:localSortBottomView.cardView.bounds,
//                                byRoundingCorners:[.topRight, .topLeft],
//                                cornerRadii: CGSize(width: 20, height:  20))
//
//        let maskLayer = CAShapeLayer()
//
//        maskLayer.path = path.cgPath
//        localSortBottomView.cardView.layer.mask = maskLayer
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.localSortBottomView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.localSortBottomView)
            

         }, completion: { (finished: Bool) -> Void in
            self.localSortBottomView.backHiddenBtn.isHidden = false

         })
        
       }
    
    @objc func localSortPurchaseDateBtnTap(sender:UIButton){
        
        localSortBottomView.startDateView.isHidden = false
        localSortBottomView.endDateView.isHidden = false
        
        localSortBottomView.stockQuanTF.isHidden = true
        
        localSortBottomView.purchaseDateBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")
        localSortBottomView.expiryDateBtn.backgroundColor = UIColor.clear
        localSortBottomView.quantityBtn.backgroundColor = UIColor.clear
        
        localSortBottomView.purchaseDateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        localSortBottomView.expiryDateBtn.setTitleColor(.gray, for: .normal)


    }
    
    @objc func localSortEndDateBtnTap(sender:UIButton){
        
        localSortBottomView.startDateView.isHidden = false
        localSortBottomView.endDateView.isHidden = false
        
        localSortBottomView.stockQuanTF.isHidden = true
        
        localSortBottomView.expiryDateBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")
        localSortBottomView.purchaseDateBtn.backgroundColor = UIColor.clear
        localSortBottomView.quantityBtn.backgroundColor = UIColor.clear

        localSortBottomView.expiryDateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        localSortBottomView.purchaseDateBtn.setTitleColor(.gray, for: .normal)

        
    }
    @objc func localQuanBtnTap(sender:UIButton){
        
        localSortBottomView.startDateView.isHidden = true
        localSortBottomView.endDateView.isHidden = true
        
        localSortBottomView.stockQuanTF.isHidden = false
        
        localSortBottomView.quantityBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")
        localSortBottomView.purchaseDateBtn.backgroundColor = UIColor.clear
        localSortBottomView.endDateBtn.backgroundColor = UIColor.clear

        localSortBottomView.quantityBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
        localSortBottomView.purchaseDateBtn.setTitleColor(.gray, for: .normal)
        localSortBottomView.expiryDateBtn.setTitleColor(.gray, for: .normal)

    }
    
    func toggleBottomSortViewWithAnimation() {
           
           let allViewsInXibArray = Bundle.main.loadNibNamed("BottomView", owner: self, options: nil)
           FiltterView = allViewsInXibArray?.first as! BottomView
           FiltterView.frame = CGRect(x: 0, y: self.view.frame.size.height+350, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(FiltterView)
           
           FiltterView.xMarkBtn.addTarget(self, action: #selector(x_markButtonTap(_:)), for: .touchUpInside)
       
//        FiltterView.transactionByBtn.addTarget(self, action: #selector(x_markButtonTap(_:)), for: .touchUpInside)

       FiltterView.xMarkBtn.addTarget(self, action: #selector(x_markButtonTap(_:)), for: .touchUpInside)
       
       FiltterView.startDateBtn.addTarget(self, action: #selector(startdateBtnTapped(_:)), for: .touchUpInside)
        
        FiltterView.startDateBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: (FiltterView.startDateBtn.imageView?.frame.size.width)!)
        
        FiltterView.startDateBtn.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: FiltterView.startDateBtn.frame.size.width-30, bottom: 7.5, right: 7.5)
        
        FiltterView.startDateBtn.setImage(UIImage(named: "calenderlatest"), for: .normal)
        
        FiltterView.endDateBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: (FiltterView.endDateBtn.imageView?.frame.size.width)!)
        
        FiltterView.endDateBtn.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: FiltterView.endDateBtn.frame.size.width-30, bottom: 7.5, right: 7.5)
        
        FiltterView.endDateBtn.setImage(UIImage(named: "calenderlatest"), for: .normal)
        
       FiltterView.endDateBtn.addTarget(self, action: #selector(enddateBtnTapped(_:)), for: .touchUpInside)
        
        FiltterView.transactionByBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: .normal)
       
       FiltterView.currentInventoryBtn.addTarget(self, action: #selector(currentInventoryBtnTapped(_:)), for: .touchUpInside)

       FiltterView.shippingCartBtn.addTarget(self, action: #selector(shoppingCartBtnTapped(_:)), for: .touchUpInside)

       FiltterView.openOrderBtn.addTarget(self, action: #selector(openOrdersBtnTapped(_:)), for: .touchUpInside)

       FiltterView.orderHistoryBtn.addTarget(self, action: #selector(ordersHistoryBtnTapped(_:)), for: .touchUpInside)

       FiltterView.applyBtn.addTarget(self, action: #selector(filterApplyBtnTapped(_:)), for: .touchUpInside)
        
        FiltterView.transactionBYCheckBoxBtn.addTarget(self, action: #selector(filterCheckBoxBtnTapped(_:)), for: .touchUpInside)

       
           let path = UIBezierPath(roundedRect:FiltterView.cardView.bounds,
                                   byRoundingCorners:[.topRight, .topLeft],
                                   cornerRadii: CGSize(width: 20, height:  20))

           let maskLayer = CAShapeLayer()

           maskLayer.path = path.cgPath
           FiltterView.cardView.layer.mask = maskLayer
           
           UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
               self.FiltterView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
               self.view.addSubview(self.FiltterView)
               
               self.roundedButtonForFiltterView()
               
      //     self.sideMenuView.loadSideMenuView(viewCntrl: self, status: "")

            }, completion: { (finished: Bool) -> Void in
               self.FiltterView.backHiddenBtn.isHidden = false

            })
       }
    
    func roundedButtonForFiltterView(){
        
        //  currentInventoryBtn:
        FiltterView.currentInventoryBtn.layer.cornerRadius = 15
        FiltterView.currentInventoryBtn.layer.borderColor = #colorLiteral(red: 0.8275570273, green: 0.8275765181, blue: 0.8275660276, alpha: 1)
        FiltterView.currentInventoryBtn.layer.borderWidth = 0.5
        
        //  shippingCartBtn:
        FiltterView.shippingCartBtn.layer.cornerRadius = 15
        FiltterView.shippingCartBtn.layer.borderColor = #colorLiteral(red: 0.8275570273, green: 0.8275765181, blue: 0.8275660276, alpha: 1)
        FiltterView.shippingCartBtn.layer.borderWidth = 0.5
        
        //  openOrderBtn:
        FiltterView.openOrderBtn.layer.cornerRadius = 15
        FiltterView.openOrderBtn.layer.borderColor = #colorLiteral(red: 0.8275570273, green: 0.8275765181, blue: 0.8275660276, alpha: 1)
        FiltterView.openOrderBtn.layer.borderWidth = 0.5
        
        //  orderHistoryBtn:
        FiltterView.orderHistoryBtn.layer.cornerRadius = 15
        FiltterView.orderHistoryBtn.layer.borderColor = #colorLiteral(red: 0.8275570273, green: 0.8275765181, blue: 0.8275660276, alpha: 1)
        FiltterView.orderHistoryBtn.layer.borderWidth = 0.5
        
        //  orderHistoryBtn:
        FiltterView.startDateBtn.layer.cornerRadius = 5
        FiltterView.startDateBtn.layer.borderColor = #colorLiteral(red: 0.8275570273, green: 0.8275765181, blue: 0.8275660276, alpha: 1)
        FiltterView.startDateBtn.layer.borderWidth = 0.5
        
        //  orderHistoryBtn:
        FiltterView.endDateBtn.layer.cornerRadius = 5
        FiltterView.endDateBtn.layer.borderColor = #colorLiteral(red: 0.8275570273, green: 0.8275765181, blue: 0.8275660276, alpha: 1)
        FiltterView.endDateBtn.layer.borderWidth = 0.5

    }
    
    @objc func localSortCancelBtnTapped(sender:UIButton){
        localSortBottomView.backHiddenBtn.isHidden = false
        localSortBottomView.removeFromSuperview()
    }
    
    @objc func x_markButtonTap(_ sender: UIButton){
         FiltterView.backHiddenBtn.isHidden = false
         FiltterView.removeFromSuperview()
     }
 
 @objc func startdateBtnTapped(_ sender :UIButton){
     filterSortStatus = "1"
    
    let currentDate = Date()
    let eventDatePicker = UIDatePicker()
    
    eventDatePicker.datePickerMode = UIDatePicker.Mode.date
    eventDatePicker.minimumDate = currentDate
           
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    let result = dateFormatter.string(from: currentDate)
    
    if(isLocalSearch == "1"){

        if(filterSortStatus == "1"){ //Purchase Btn
            localSortBottomView.startDateBtn.setTitle(result, for: .normal)
            filterStartDateStr = result

        }else if(filterSortStatus == "0"){
            localSortBottomView.endDateBtn.setTitle(result, for: .normal)
            filetEndDateStr = result

        }

    }else{
        if(filterSortStatus == "1"){ //Purchase Btn
            FiltterView.startDateBtn.setTitle(result, for: .normal)
            filterStartDateStr = result

        }else{
            
            FiltterView.endDateBtn.setTitle(result, for: .normal)
            filetEndDateStr = result

        }
    }
    
     datePickerView()
     
 }
 
 @objc func enddateBtnTapped(_ sender :UIButton){
    
    if(filterStartDateStr == "" ){
        self.showAlertWith(title: "Alert", message: "Please select start date")
        return
        
    }
    
     filterSortStatus = "0"
    
    let currentDate = Date()
    let eventDatePicker = UIDatePicker()
    
    eventDatePicker.datePickerMode = UIDatePicker.Mode.date
    eventDatePicker.minimumDate = currentDate
           
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    let result = dateFormatter.string(from: currentDate)
    
    if(isLocalSearch == "1"){

        if(filterSortStatus == "1"){ //Purchase Btn
            localSortBottomView.startDateBtn.setTitle(result, for: .normal)
            filterStartDateStr = result

        }else if(filterSortStatus == "0"){
            localSortBottomView.endDateBtn.setTitle(result, for: .normal)
            filetEndDateStr = result

        }

    }else{
        if(filterSortStatus == "1"){ //Purchase Btn
            FiltterView.startDateBtn.setTitle(result, for: .normal)
            filterStartDateStr = result

        }else{
            
            FiltterView.endDateBtn.setTitle(result, for: .normal)
            filetEndDateStr = result

        }
    }
    
     datePickerView()
     
 }
    
    //****************** TableView Delegate Methods*************************//
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(tableView == searchTblView){
            return searchResultsArray.count
            
        }else{
            return filtersDataArray.count

        }
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == searchTblView){
            
            let cell = searchTblView.dequeueReusableCell(withIdentifier: "GlobalSearchResultTableViewCell", for: indexPath) as! GlobalSearchResultTableViewCell
                    
            let prodDict = searchResultsArray[indexPath.row] as! NSDictionary
                    cell.seachTxtLbl?.text = prodDict.value(forKey: "searchedValue") as? String
            
            return cell

        }else{
            
            let cell = globalSearchTblView.dequeueReusableCell(withIdentifier: "GlobalFilterResultTableViewCell", for: indexPath) as! GlobalFilterResultTableViewCell
            
            let productDict = filtersDataArray[indexPath.row] as! NSDictionary

            let dataDict = productDict.value(forKey: "productdetails") as! NSDictionary
            
            let stockQuan = dataDict.value(forKey: "stockQuantity") as? Int
            
            cell.prodIDLbl.text = dataDict["productUniqueNumber"] as? String
            cell.prodNameLbl.text = dataDict.value(forKey: "productName") as? String
            cell.desclbl.text = dataDict.value(forKey: "description") as? String
            cell.stockQtyLbl.text = String(stockQuan ?? 0)
            cell.stockUnitLbl.text = dataDict.value(forKey: "stockUnit") as? String
            cell.storageLocLbl.text = dataDict.value(forKey: "storageLocation") as? String
            
            let expiryDate = (dataDict.value(forKey: "expiryDate") as? String) ?? ""
            let convertedExpiryDate = convertDateFormatter(date: expiryDate)
            cell.expiryDateLbl.text = convertedExpiryDate
            
            let prodArray = dataDict.value(forKey: "productImages") as? NSArray

            if(prodArray?.count ?? 0  > 0){

                        let dict = prodArray?[0] as! NSDictionary
                        
                        let imageStr = dict.value(forKey: "0") as! String
                        
                        if !imageStr.isEmpty {
                            
                            let imgUrl:String = imageStr
                            
                            let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                                
                            let imggg = Constants.BaseImageUrl + trimStr
                            
                            let url = URL.init(string: imggg)

//                            cell.prodImgView?.sd_setImage(with: url , placeholderImage: UIImage(named: "add photo"))
                            
                            cell.prodImgView?.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)
                            
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
     }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
                    searchResultsView.isHidden = false
                    globalSearchTblView.isHidden = true

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
//        if(textField.text == ""){
//
//            searchResultsView.isHidden = false
//            globalSearchTblView.isHidden = true
//
//        }else{
//
//            searchResultsView.isHidden = false
//            globalSearchTblView.isHidden = true
//
//        }
        
        return true
}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(tableView == searchTblView){
            return 40

        }else{
            return 251

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == searchTblView){
            let prodDict = searchResultsArray[indexPath.row] as! NSDictionary
            lookingForTxtField.text = prodDict.value(forKey: "searchedValue") as? String

        }
        
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
        
        if(isLocalSearch == "1"){

            if(filterSortStatus == "1"){ //Purchase Btn
                localSortBottomView.startDateBtn.setTitle(result, for: .normal)
                filterStartDateStr = result

            }else if(filterSortStatus == "0"){
                localSortBottomView.endDateBtn.setTitle(result, for: .normal)
                filetEndDateStr = result

            }

        }else{
            if(filterSortStatus == "1"){ //Purchase Btn
                FiltterView.startDateBtn.setTitle(result, for: .normal)
                filterStartDateStr = result

            }else{
                
                filetEndDateStr = result
                
                let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let date = dateFormatter.date(from:filterStartDateStr)!
                
                let date2 = dateFormatter.date(from:filetEndDateStr)!

                if date.compare(date2) == .orderedAscending {
                    FiltterView.endDateBtn.setTitle(result, for: .normal)

                }else if date.compare(date2) == .orderedDescending{
                    self.showAlertWith(title: "Alert", message: "Invalid dates")
                    return
                    
                }else{
                    
                }
            }
        }
   }
   
   @objc func dueDateChanged(sender:UIDatePicker){
       
       let dateFormatter = DateFormatter()
       
       dateFormatter.dateFormat = "dd/MM/yyyy"
       let selectedDate = dateFormatter.string(from: picker.date)
    
    if(isLocalSearch == "1"){
        
        if(filterSortStatus == "1"){ //Purchase Btn
         localSortBottomView.startDateBtn.setTitle(selectedDate, for: .normal)
         filterStartDateStr = selectedDate
         
        }else if(filterSortStatus == "0"){
            localSortBottomView.endDateBtn.setTitle(selectedDate, for: .normal)
         filetEndDateStr = selectedDate

        }
        
    }else{
        
        if(filterSortStatus == "1"){ //Purchase Btn
         FiltterView.startDateBtn.setTitle(selectedDate, for: .normal)
         filterStartDateStr = selectedDate
         
        }else if(filterSortStatus == "0"){
//         FiltterView.endDateBtn.setTitle(selectedDate, for: .normal)
         filetEndDateStr = selectedDate
            
            let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = dateFormatter.date(from:filterStartDateStr)!
            
            let date2 = dateFormatter.date(from:filetEndDateStr)!

            if date.compare(date2) == .orderedAscending {
                FiltterView.endDateBtn.setTitle(selectedDate, for: .normal)
           
            }else if date.compare(date2) == .orderedDescending{
                self.showAlertWith(title: "Alert", message: "Invalid dates")
                return
                
            }else{
                
            }

        }
      }
   }
   
   @objc func doneBtnTap(_ sender: UIButton) {

       hiddenBtn.removeFromSuperview()
       pickerDateView.removeFromSuperview()
       
   }
    
    @objc func filterCheckBoxBtnTapped(_ sender:UIButton){
        
        if sender.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
            isTransactionByStr = "1"
            sender.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)

        }else{
            isTransactionByStr = "0"
            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
        }

    }
    
 @objc func filterApplyBtnTapped(_ sender:UIButton){
    
    if(lookingForTxtField.text == ""){
        self.showAlertWith(title: "Alert", message: "Please enter looking for data")
        return
    }
    
   else if(filterModuleName == ""){
        self.showAlertWith(title: "Alert", message: "Please select module")
        return

    }
    
    if(isTransactionByStr == "1"){
        
        if(filterStartDateStr == "" ){
            self.showAlertWith(title: "Alert", message: "Please select start date")
            return
            
        }else if(filetEndDateStr == "" ){
            self.showAlertWith(title: "Alert", message: "Please select end date")
            return

        }
    }
    
        
        if(isLocalSearch == "1"){
            filterPopupLocalSearchApplyAPI()
            
        }else{
            filterApplyAPI()
        }

 }
 
 @objc func currentInventoryBtnTapped(_ sender :UIButton){
    
    FiltterView.shippingCartBtn.backgroundColor = UIColor.clear
    FiltterView.openOrderBtn.backgroundColor = UIColor.clear
    FiltterView.orderHistoryBtn.backgroundColor = UIColor.clear

    if(currentInvenFilterStatus == ""){
        
        filterModuleName = "currentInventory"
        
        currentInvenFilterStatus = "currentInventory"
        FiltterView.currentInventoryBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")

    }else{
        
        filterModuleName = ""
        
        currentInvenFilterStatus = ""
        FiltterView.currentInventoryBtn.backgroundColor = UIColor.clear

    }
 }
 
 @objc func shoppingCartBtnTapped(_ sender :UIButton){
    
    FiltterView.currentInventoryBtn.backgroundColor = UIColor.clear
    FiltterView.openOrderBtn.backgroundColor = UIColor.clear
    FiltterView.orderHistoryBtn.backgroundColor = UIColor.clear

    if(shoppingCartFilterStatus == ""){
        
        filterModuleName = "shoppingCart"
        
        shoppingCartFilterStatus = "shoppingCart"
        FiltterView.shippingCartBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")

    }else{
        
        filterModuleName = ""
        
        shoppingCartFilterStatus = ""
        FiltterView.shippingCartBtn.backgroundColor = UIColor.clear

    }

 }
 
 @objc func openOrdersBtnTapped(_ sender :UIButton){
    
    FiltterView.shippingCartBtn.backgroundColor = UIColor.clear
    FiltterView.orderHistoryBtn.backgroundColor = UIColor.clear
    FiltterView.currentInventoryBtn.backgroundColor = UIColor.clear

    if(openOrdersFilterStatus == ""){
        openOrdersFilterStatus = "openOrders"
        filterModuleName = "openOrders"
        FiltterView.openOrderBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")

    }else{
        openOrdersFilterStatus = ""
        FiltterView.openOrderBtn.backgroundColor = UIColor.clear

    }
 }
 
 @objc func ordersHistoryBtnTapped(_ sender :UIButton){
    
    FiltterView.shippingCartBtn.backgroundColor = UIColor.clear
    FiltterView.openOrderBtn.backgroundColor = UIColor.clear
    FiltterView.currentInventoryBtn.backgroundColor = UIColor.clear

    
    if(ordersHistoryFilterStatus == ""){
        ordersHistoryFilterStatus = "ordersHistory"
        filterModuleName = "ordersHistory"
        FiltterView.orderHistoryBtn.backgroundColor = hexStringToUIColor(hex: "2435d0")

    }else{
        ordersHistoryFilterStatus = ""
        FiltterView.orderHistoryBtn.backgroundColor = UIColor.clear

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
    
    func SortFilterAPICall() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        var URLString_loginIndividual = Constants.BaseUrl + FilterSortUrl + accountID as String
        
        URLString_loginIndividual = URLString_loginIndividual.replacingOccurrences(of: " ", with: "%20")
        
        globarSearchServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                if(respVo.result!.count)>0{

                                }
                                
                                
                            }
                            else {
                                
                                
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
    }
    
    func filterPopupLocalSearchApplyAPI() {
        
        searchFilterStatusStr = lookingForTxtField.text ?? ""
        stockQuanStr = localSortBottomView.stockQuanTF.text ?? ""
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        var URLString_loginIndividual = Constants.BaseUrl + LocalSearchFilterUrl + accountID as String + "/\(searchFilterStatusStr)" + "/\(stockQuanStr)" + "/\(filterStartDateStr)" + "/\(filetEndDateStr)"
        
        URLString_loginIndividual = URLString_loginIndividual.replacingOccurrences(of: " ", with: "%20")
        
        let urlString = URLString_loginIndividual.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
        globarSearchServiceCntrl.requestGETURL(strURL:urlString!, success: {(result) in
            
            let dataDict = result as! NSDictionary

                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")

                if(statusCode == 200 ){
                    
                    var shoppingCartResult = NSMutableArray()
                    var currentInventoryResult = NSMutableArray()
                    var openOrdersManagementResult = NSMutableArray()
                    var orderHistoryManagementresult = NSMutableArray()
                    
                    if(self.currentInvenFilterStatus == "currentInventory"){
                        shoppingCartResult = dataDict.value(forKey: "currentInventoryresult") as! NSMutableArray
                    }
                    
                    if(self.shoppingCartFilterStatus == "shoppingCart"){
                         currentInventoryResult = dataDict.value(forKey: "shoppingCartManagementresult") as! NSMutableArray

                    }
                    
                    if(self.openOrdersFilterStatus == "openOrders"){
                         openOrdersManagementResult = dataDict.value(forKey: "openOrdersManagementresult") as! NSMutableArray

                    }
                    
                    if(self.ordersHistoryFilterStatus == "ordersHistory"){
                         orderHistoryManagementresult = dataDict.value(forKey: "orderHistoryManagementresult") as! NSMutableArray

                    }

                  
                if(shoppingCartResult.count > 0){
                    for i in 0..<shoppingCartResult.count {
                        self.filtersDataArray.add(shoppingCartResult[i])
                    }

                }
                if(currentInventoryResult.count > 0){
                    for i in 0..<currentInventoryResult.count {
                        self.filtersDataArray.add(currentInventoryResult[i])
                    }

                }
                if(openOrdersManagementResult.count > 0){
                    for i in 0..<openOrdersManagementResult.count {
                        self.filtersDataArray.add(openOrdersManagementResult[i])
                    }

                }
                if(orderHistoryManagementresult.count > 0){
                    for i in 0..<orderHistoryManagementresult.count {
                        self.filtersDataArray.add(orderHistoryManagementresult[i])
                    }
                }
                                
                    print("Filters Data is \(self.filtersDataArray)")
                    
//                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                    let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
//                    VC.modalPresentationStyle = .fullScreen
//                    VC.isFilter = "1"
//                    VC.filterDataArray = self.filtersDataArray
//                    self.present(VC, animated: true, completion: nil)

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
    
    func filterApplyAPI() {
        
        searchFilterStatusStr = lookingForTxtField.text ?? ""
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        filetEndDateStr = FiltterView.endDateBtn.currentTitle ?? ""
        filterStartDateStr = FiltterView.startDateBtn.currentTitle ?? ""
        
        if(filetEndDateStr == ""){
            filetEndDateStr = "null"
        }
        
        if(filterStartDateStr == ""){
            filterStartDateStr = "null"
        }
        
        
        var URLString_loginIndividual = Constants.BaseUrl + FilterSortUrl + accountID as String + "/\(searchFilterStatusStr)" + "/\(filterStartDateStr)" + "/\(filetEndDateStr)" + "/\(filterModuleName)"
        
        URLString_loginIndividual = URLString_loginIndividual.replacingOccurrences(of: " ", with: "%20")

            
        globarSearchServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
            
            let dataDict = result as! NSDictionary

                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")

                if(statusCode == 200 ){
                    
                    var shoppingCartResult = NSMutableArray()
                    var currentInventoryResult = NSMutableArray()
                    var openOrdersManagementResult = NSMutableArray()
                    var orderHistoryManagementresult = NSMutableArray()
                    
                    if(self.filterModuleName == "currentInventory"){
                        currentInventoryResult = dataDict.value(forKey: "currentInventoryresult") as! NSMutableArray
                    }
                    
                    if(self.filterModuleName == "shoppingCart"){
                         shoppingCartResult = dataDict.value(forKey: "shoppingCartresult") as! NSMutableArray

                    }
                    
                    if(self.filterModuleName == "openOrders"){
                         openOrdersManagementResult = dataDict.value(forKey: "openOrdersResult") as! NSMutableArray

                    }

                    if(self.filterModuleName == "ordersHistory"){
                         orderHistoryManagementresult = dataDict.value(forKey: "orderHistoryResult") as! NSMutableArray

                    }

//                let filtersDataArray = NSMutableArray()
                  
                if(shoppingCartResult.count > 0){
                    for i in 0..<shoppingCartResult.count {
                        self.filtersDataArray.add(shoppingCartResult[i])
                    }

                }
                if(currentInventoryResult.count > 0){
                    for i in 0..<currentInventoryResult.count {
                        self.filtersDataArray.add(currentInventoryResult[i])
                    }

                }
                if(openOrdersManagementResult.count > 0){
                    for i in 0..<openOrdersManagementResult.count {
                        
                        let dataDict = openOrdersManagementResult.object(at: i) as! NSDictionary
                        
                        let orderListArr = dataDict.value(forKey: "ordersList") as! NSArray
                        
                        for j in 0..<orderListArr.count {
                            self.filtersDataArray.add(orderListArr[j])

                        }
                    }

                }
                if(orderHistoryManagementresult.count > 0){
                    for i in 0..<orderHistoryManagementresult.count {
                        
                        let dataDict = orderHistoryManagementresult.object(at: i) as! NSDictionary
                        
                        let orderListArr = dataDict.value(forKey: "ordersList") as! NSArray

                        for j in 0..<orderListArr.count {
                            self.filtersDataArray.add(orderListArr[j])

                        }
                        
//                        self.filtersDataArray.add(orderHistoryManagementresult[i])
                    }
                }
                                
                    print("Filters Data is \(self.filtersDataArray)")
                    
//                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                    let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
//                    VC.modalPresentationStyle = .fullScreen
//                    VC.isFilter = "1"
//                    VC.filterDataArray = filtersDataArray
//                    self.present(VC, animated: true, completion: nil)
                    
                    self.FiltterView.backHiddenBtn.isHidden = false
                    self.FiltterView.removeFromSuperview()

                    self.showGlobalSearchDetails()

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
    
    func showGlobalSearchDetails()  {
        
//        localSortBottomView.backHiddenBtn.isHidden = false
//        localSortBottomView.removeFromSuperview()
        
        
        searchResultsView.isHidden = true
        
        globalSearchTblView.isHidden = false
        globalSearchTblView.reloadData()
        
    }
    
    func getSearchResultsAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        var URLString_loginIndividual = Constants.BaseUrl + GlobalSearchListUrl + accountID as String
        
        URLString_loginIndividual = URLString_loginIndividual.replacingOccurrences(of: " ", with: "%20")

        globarSearchServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                                     _ = respVo.message
                            _ = respVo.statusCode
            
                            let dataDict = result as! NSDictionary
                            self.searchResultsArray = dataDict.value(forKey: "result") as! NSMutableArray
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "Success" {
                                
                                if(self.searchResultsArray.count)>0{
                                    self.searchTblView.reloadData()
                                    
                                }else{
                                    self.searchTblView.isHidden = true
                                }
                            }
                            else {
                                
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
    }
    
    func filterLocalSearchApplyAPI() {
        
        searchFilterStatusStr = lookingForTxtField.text ?? ""
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        var URLString_loginIndividual = Constants.BaseUrl + LocalSearchUrl + accountID as String + "/\(searchFilterStatusStr)" + "/\(moduleStatusStr)"
        
        URLString_loginIndividual = URLString_loginIndividual.replacingOccurrences(of: " ", with: "%20")

            
        globarSearchServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
            
            let dataDict = result as! NSDictionary

                        let respVo:LocalSortRespo = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")

                if(statusCode == 200 ){
                    
                    if self.moduleStatusStr == "currentInventory"{
                        
                        var filtersDataArray = NSMutableArray()
                           
                        filtersDataArray = dataDict.value(forKey: "currentInventoryresult") as! NSMutableArray
                                        
                            print("Filters Data is \(filtersDataArray)")
                            
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
                            VC.modalPresentationStyle = .fullScreen
                            VC.isFilter = "1"
                            VC.currentInventoryResult = filtersDataArray
                            self.present(VC, animated: true, completion: nil)

                    }else if(self.moduleStatusStr == "shoppingCart"){
                        
                        var shoppingCartResult = NSMutableArray()
                        
                        shoppingCartResult = dataDict.value(forKey: "shoppingCartresult") as! NSMutableArray
                        
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyBoard.instantiateViewController(withIdentifier: "ShoppingVC") as! ShoppingViewController
                        VC.modalPresentationStyle = .fullScreen
                        VC.isFilter = "1"
                        VC.shoppingCartResult = shoppingCartResult
                        self.present(VC, animated: true, completion: nil)

                    }

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
    
    
    func filterGlobalSearchApplyAPI() {
        
        searchFilterStatusStr = lookingForTxtField.text ?? ""
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        var URLString_loginIndividual = Constants.BaseUrl + GlobalSearchFilterUrl + accountID as String + "/\(searchFilterStatusStr)"
        
        URLString_loginIndividual = URLString_loginIndividual.replacingOccurrences(of: " ", with: "%20")

            
        globarSearchServiceCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
            
            let dataDict = result as! NSDictionary

                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")

                if(statusCode == 200 ){
                    
                    var shoppingCartResult = NSMutableArray()
                    var currentInventoryResult = NSMutableArray()
                    var openOrdersManagementResult = NSMutableArray()
                    var orderHistoryManagementresult = NSMutableArray()
                    
                        shoppingCartResult = dataDict.value(forKey: "shoppingCartresult") as! NSMutableArray
                    
                         currentInventoryResult = dataDict.value(forKey: "currentInventoryresult") as! NSMutableArray

                         openOrdersManagementResult = dataDict.value(forKey: "openOrdersResult") as! NSMutableArray

                         orderHistoryManagementresult = dataDict.value(forKey: "orderHistoryResult") as! NSMutableArray

//                let filtersDataArray = NSMutableArray()
                  
                if(shoppingCartResult.count > 0){
                    for i in 0..<shoppingCartResult.count {
                        self.filtersDataArray.add(shoppingCartResult[i])
                    }

                }
                if(currentInventoryResult.count > 0){
                    for i in 0..<currentInventoryResult.count {
                        self.filtersDataArray.add(currentInventoryResult[i])
                    }

                }
                    
                    self.showGlobalSearchDetails()
                    
                if(openOrdersManagementResult.count > 0){
                    for i in 0..<openOrdersManagementResult.count {
                        self.filtersDataArray.add(openOrdersManagementResult[i])
                    }

                }
                if(orderHistoryManagementresult.count > 0){
                    for i in 0..<orderHistoryManagementresult.count {
                        self.filtersDataArray.add(orderHistoryManagementresult[i])
                    }
                }
                                
                    print("Filters Data is \(self.filtersDataArray)")
                    
//                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                    let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
//                    VC.modalPresentationStyle = .fullScreen
//                    VC.isFilter = "1"
//                    VC.filterDataArray = filtersDataArray
////                    self.present(VC, animated: true, completion: nil)
//                    self.navigationController?.pushViewController(VC, animated: true)

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
}
