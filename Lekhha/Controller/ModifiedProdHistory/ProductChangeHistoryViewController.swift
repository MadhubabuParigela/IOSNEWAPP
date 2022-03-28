//
//  ProductChangeHistoryViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 07/01/22.
//

import UIKit
import ObjectMapper

class ProductChangeHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBAction func onClickBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    var ordersHistoryServcCntrl = ServiceController()
    @IBOutlet var historyTableView: UITableView!
    var mainHistoryArray=[ProductChangesList]()
    var editArray=[ProductChangesList]()
    var updateArray=[ProductChangesList]()
    var editString:Bool=false
    @IBAction func editChanges(_ sender: UISwitch) {
        if editString==false
        {
            editString=true
        self.getEditHistoryAPI()
        }
        else
        {
            editString=false
            self.getUpdatesHistoryAPI()
        }

    }
    @IBAction func onClickCollapseButton(_ sender: UIButton) {
        if expandLabel.text=="Expand all"
        {
            expandLabel.text="Collapse all"
            if isExpandable.count>0
            {
                for i in 0..<isExpandable.count {
                    isExpandable[i]=true
                }
            }
        }
        else
        {
            expandLabel.text="Expand all"
            if isExpandable.count>0
            {
                for i in 0..<isExpandable.count {
                    isExpandable[i]=false
                }
            }
        }
        self.historyTableView.reloadData()
    }
    @IBOutlet var arroeImage: UIImageView!
    @IBOutlet var expandLabel: UILabel!
    var productId=String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibName1 = UINib(nibName: "EditHistoryTableViewCell", bundle: nil)
        historyTableView.register(nibName1, forCellReuseIdentifier: "EditHistoryTableViewCell")
        let nibName2 = UINib(nibName: "UpdateGiveAwayTableViewCell", bundle: nil)
        historyTableView.register(nibName2, forCellReuseIdentifier: "UpdateGiveAwayTableViewCell")
        let nibName3 = UINib(nibName: "OrderedViewTableViewCell", bundle: nil)
        historyTableView.register(nibName3, forCellReuseIdentifier: "OrderedViewTableViewCell")
        let nibName4 = UINib(nibName: "UpdateShareTableViewCell", bundle: nil)
        historyTableView.register(nibName4, forCellReuseIdentifier: "UpdateShareTableViewCell")
        self.historyTableView.separatorStyle = .none
        let headerNib = UINib.init(nibName: "ProductSectionTableViewCell", bundle: nil)
        historyTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "ProductSectionTableViewCell")
        self.getUpdatesHistoryAPI()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = historyTableView.dequeueReusableHeaderFooterView(withIdentifier: "ProductSectionTableViewCell") as! ProductSectionTableViewCell
       
        let modificationDictionary=self.mainHistoryArray[section].productModifingDetails as? ProductModifingDetailsVo
        let userinfo=modificationDictionary?.userinfo ?? [UserinfoVo]()
        let accountinfo=modificationDictionary?.accountinfo ?? [AccountinfoVo]()
        
        headerView.updateTypeL.text=modificationDictionary?.changeType
        if accountinfo.count>0
        {
        headerView.companyNameL.text=accountinfo[0].companyName
        }
        else
        {
            headerView.companyNameL.text=""
        }
        headerView.createdDateL.text=modificationDictionary?.modifiedDateTime
        headerView.collapseButton.tag=section
        headerView.collapseButton.addTarget(self, action: #selector(dropDoownBtnTap), for: .touchUpInside)
        if isExpandable[section] == true {
            headerView.collapseButton.setImage(UIImage(named: "Up"), for: .normal)
        }
        else{
            headerView.collapseButton.setImage(UIImage(named: "arrowDown"), for: .normal)
        }
        var nameLabel=String()
        if userinfo.count>0
        {
            let ffname=userinfo[0].firstName ?? ""
            let ssname=userinfo[0].lastName ?? ""
            nameLabel=ffname + " " + ssname
        }
        headerView.userNameL.text=nameLabel
        
        return headerView
   }
    var isExpandable=[Bool]()
    @objc func dropDoownBtnTap(sender:UIButton)
    {
     print("Button Tapped,need to insert (or) DElete Rows In Section\(sender.tag)")
     
     if isExpandable[sender.tag] == true {
         isExpandable[sender.tag]=false
        sender.setImage(UIImage(named: "Up"), for: .normal)
        historyTableView.reloadData()
       }
       else if isExpandable[sender.tag] == false  {
         isExpandable[sender.tag]=true
        sender.setImage(UIImage(named: "arrowDown"), for: .normal)
        historyTableView.reloadData()
            }
         }
    //****************** TableView Delegate Methods*************************//
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var productsList = [ProductChangesList]()
        productsList = mainHistoryArray
        if isExpandable[section]==true
        {
        return 1
        }
        return 0
     }
     var indexPathRow=IndexPath()
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var productsList = [ProductChangesList]()
        productsList = mainHistoryArray
        
        print(productsList)
        
        let prodDetails = productsList[indexPath.section].productdetails!
        
        let stockDetails = productsList[indexPath.section].stockUnitDetails!
        let storageOneDetails = productsList[indexPath.section].storageLocationLevel1Details!
        let storageTwoDetails = productsList[indexPath.section].storageLocationLevel2Details!
        let storageThreeDetails = productsList[indexPath.section].storageLocationLevel3Details!
        let priceUnitDetails = productsList[indexPath.section].priceUnitDetails!
        let productModifiedDetails = productsList[indexPath.section].productModifingDetails!
      
        
        var cellHieight=Int()
        cellHieight=productsList[indexPath.section].cellHeight ?? 0
        
        if productModifiedDetails.change=="Edit" || productModifiedDetails.change == "add-currentinventory"
        {
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "EditHistoryTableViewCell", for: indexPath) as! EditHistoryTableViewCell
            
            cell.mainView.layer.borderColor=UIColor.black.cgColor
            cell.mainView.layer.borderWidth=0.5
            let prodArray = prodDetails.productImages
            
            if(prodArray?.count ?? 0  > 0){
                
                        let dict = prodArray?[0] as! NSDictionary
                        
                        let imageStr = dict.value(forKey: "0") as! String
                        
                        if !imageStr.isEmpty {
                            
                            let imgUrl:String = imageStr
                            
                            let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                                
                            let imggg = Constants.BaseImageUrl + trimStr
                            
                            let url = URL.init(string: imggg)

                            
                            cell.oroductImage?.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                            
                            cell.oroductImage?.contentMode = UIView.ContentMode.scaleAspectFit
                            
                        }
                        else {
                            
                            cell.oroductImage?.image = UIImage(named: "no_image")
                        }
            }else{
                
                cell.oroductImage?.image = UIImage(named: "no_image")
            }
            
            cell.productId.text=prodDetails.productUniqueNumber
            cell.productName.text=prodDetails.productName
            cell.productDesc.text=prodDetails.description
            cell.stockQtyL.text=String(format:"%.3f",prodDetails.stockQuantity ?? 0)
            if stockDetails.count>0
            {
            cell.stocckUnitL.text=stockDetails[0].stockUnitName
            }
            else
            {
                cell.stocckUnitL.text=""
            }
            cell.totalPriceLabel.text=String(format:"%.2f", prodDetails.price ?? 0)
            cell.expiryDateL.text=convertDateFormatter(date: prodDetails.expiryDate ?? "")
            if priceUnitDetails.count>0
            {
            cell.priceUnitL.text=priceUnitDetails[0].priceUnit
            }
            else
            {
                cell.priceUnitL.text=""
            }
            cell.pricePerStockLabel.text=String(format:"%.2f",prodDetails.unitPrice ?? 0)
            if storageOneDetails.count != 0 {
            cell.storageLevel1Label.text=storageOneDetails[0].slocName
            }
            else
            {
                cell.storageLevel1Label.text=""
            }
            if storageTwoDetails.count != 0 {
            cell.storageLevel2Label.text=storageTwoDetails[0].slocName
            }
            else
            {
                cell.storageLevel2Label.text=""
            }
            if storageThreeDetails.count != 0 {
            cell.storageLevel3Label.text=storageThreeDetails[0].slocName
            }
            else
            {
                cell.storageLevel3Label.text=""
            }
            cell.categoryLabel.text=prodDetails.category
            cell.subCategoryLabel.text=prodDetails.subCategory
            return cell
        }
        else if productModifiedDetails.change=="share"
        {
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "UpdateShareTableViewCell", for: indexPath) as! UpdateShareTableViewCell
            cell.mainView.layer.borderColor=UIColor.black.cgColor
            cell.mainView.layer.borderWidth=0.5
            let sharedUserDetails=productModifiedDetails.sharedUserDetails
            let sharedUserArray=sharedUserDetails?["userDetails"]as? [AnyObject] ?? [AnyObject]()
           
                cell.checkButton.setImage(UIImage(named: "checkBoxActive"), for: .normal)
           
            if let pp=sharedUserDetails?["sharedQuantity"]as? Double
            {
            cell.stockQty.text=String(format:"%.3f", pp)
            }
            else if let pp=sharedUserDetails?["sharedQuantity"]as? Float
            {
                cell.stockQty.text=String(format:"%.3f", pp)
                }
                else if let pp=sharedUserDetails?["sharedQuantity"]as? String
                {
                    cell.stockQty.text=pp
                }
            if stockDetails.count>0
            {
            cell.stockUnitL.text=stockDetails[0].stockUnitName
            }
            else
            {
                cell.stockUnitL.text=""
            }
            var nameLabel=String()
            if sharedUserArray.count>0
            {
                let shareDict=sharedUserArray[0]
                let ffname=shareDict["firstName"] as? String ?? ""
                let ssname=shareDict["lastName"] as? String ?? ""
                nameLabel=ffname + " " + ssname
            }
            cell.sharedUserL.text=nameLabel
            cell.sharedView.isHidden=false
            
            return cell
        }
        else if productModifiedDetails.change=="borrow"
        {
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "UpdateShareTableViewCell", for: indexPath) as! UpdateShareTableViewCell
            cell.mainView.layer.borderColor=UIColor.black.cgColor
            cell.mainView.layer.borderWidth=0.5
            cell.shareTitleL.text="Borrow"
            cell.sharedUserT.text="Borrowed from"
                cell.checkButton.setImage(UIImage(named: "checkBoxActive"), for: .normal)
            let accountDetails=productModifiedDetails.borrowLentDetails
            if let pp=accountDetails?.value(forKey: "quantity") as? Double
            {
            cell.stockQty.text=String(format:"%.3f", pp)
            }
            else if let pp=accountDetails?.value(forKey: "quantity") as? Float
            {
                cell.stockQty.text=String(format:"%.3f", pp)
                }
                else if let pp=accountDetails?.value(forKey: "quantity") as? String
                {
                    cell.stockQty.text=pp
                }
            if stockDetails.count>0
            {
            cell.stockUnitL.text=stockDetails[0].stockUnitName
            }
            else
            {
                cell.stockUnitL.text=""
            }
            var nameLabel=String()
            
            let accountDetailsArray=accountDetails?.value(forKey: "accountDetails")as? NSDictionary ?? NSDictionary()
            
            if accountDetailsArray.count>0
            {
                let ffname=accountDetailsArray["companyName"] as? String ?? ""
                nameLabel=ffname
            }
            cell.sharedUserL.text=nameLabel
            cell.sharedView.isHidden=false
            
            return cell
        }
        else if productModifiedDetails.change=="uncheck-borrowlent"
        {
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "UpdateGiveAwayTableViewCell", for: indexPath) as! UpdateGiveAwayTableViewCell
            cell.mainView.layer.borderColor=UIColor.black.cgColor
            cell.mainView.layer.borderWidth=0.5
            
            
                cell.checkButton.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
            cell.giveawayL.text="Borrow/Lent"
            
            cell.stockQty.text=String(format:"%.3f", productModifiedDetails.availableStockQuantity ?? 0)
            
            if stockDetails.count>0
            {
            cell.stockUnitL.text=stockDetails[0].stockUnitName
            }
            else
            {
                cell.stockUnitL.text=""
            }
            return cell
        }
        else if productModifiedDetails.change=="uncheck-share"
        {
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "UpdateShareTableViewCell", for: indexPath) as! UpdateShareTableViewCell
            cell.mainView.layer.borderColor=UIColor.black.cgColor
            cell.mainView.layer.borderWidth=0.5
            let sharedUserDetails=productModifiedDetails.sharedUserDetails
            let sharedUserArray=sharedUserDetails?["userDetails"]as? [AnyObject] ?? [AnyObject]()
           
                cell.checkButton.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
            
            if let pp=sharedUserDetails?["sharedQuantity"]as? Double
            {
            cell.stockQty.text=String(format:"%.3f", pp)
            }
            else if let pp=sharedUserDetails?["sharedQuantity"]as? Float
            {
                cell.stockQty.text=String(format:"%.3f", pp)
                }
                else if let pp=sharedUserDetails?["sharedQuantity"]as? String
                {
                    cell.stockQty.text=pp
                }
            if stockDetails.count>0
            {
            cell.stockUnitL.text=stockDetails[0].stockUnitName
            }
            else
            {
                cell.stockUnitL.text=""
            }
            cell.sharedView.isHidden=true
            
            
            return cell
        }
        else if productModifiedDetails.change=="uncheck-giveAway" || productModifiedDetails.change=="giveAway"
        {
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "UpdateGiveAwayTableViewCell", for: indexPath) as! UpdateGiveAwayTableViewCell
            cell.mainView.layer.borderColor=UIColor.black.cgColor
            cell.mainView.layer.borderWidth=0.5
            if productModifiedDetails.change=="uncheck-giveAway"
               {
                cell.checkButton.setImage(UIImage(named: "checkBoxInactive"), for: .normal)
               }
            if productModifiedDetails.change=="giveAway"
               {
                cell.checkButton.setImage(UIImage(named: "checkBoxActive"), for: .normal)
               }
         
            cell.stockQty.text=String(format:"%.3f",productModifiedDetails.availableStockQuantity ?? 0)
            if stockDetails.count>0
            {
            cell.stockUnitL.text=stockDetails[0].stockUnitName
            }
            else
            {
                cell.stockUnitL.text=""
            }
            return cell
        }
        else if productModifiedDetails.change=="lent"
        {
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "UpdateGiveAwayTableViewCell", for: indexPath) as! UpdateGiveAwayTableViewCell
            cell.mainView.layer.borderColor=UIColor.black.cgColor
            cell.mainView.layer.borderWidth=0.5
            
            
                cell.checkButton.setImage(UIImage(named: "checkBoxActive"), for: .normal)
            cell.giveawayL.text="Lent"
            let accountDetails=productModifiedDetails.borrowLentDetails
            if let pp=accountDetails?.value(forKey: "quantity") as? Double
            {
            cell.stockQty.text=String(format:"%.3f", pp)
            }
            else if let pp=accountDetails?.value(forKey: "quantity") as? Float
            {
                cell.stockQty.text=String(format:"%.3f", pp)
                }
                else if let pp=accountDetails?.value(forKey: "quantity") as? String
                {
                    cell.stockQty.text=pp
                }
            if stockDetails.count>0
            {
            cell.stockUnitL.text=stockDetails[0].stockUnitName
            }
            else
            {
                cell.stockUnitL.text=""
            }
            return cell
        }
        else if productModifiedDetails.change=="Update" || productModifiedDetails.change=="update-giveAway"
        {
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "OrderedViewTableViewCell", for: indexPath) as! OrderedViewTableViewCell
            cell.mainView.layer.borderColor=UIColor.black.cgColor
            cell.mainView.layer.borderWidth=0.5
            cell.availableStockQtyL.text=String(format:"%.3f", productModifiedDetails.availableStockQuantity ?? 0)
            if stockDetails.count>0
            {
            cell.stockUnitL.text=stockDetails[0].stockUnitName
            }
            else
            {
                cell.stockUnitL.text=""
            }
            cell.currentStatusL.text=productModifiedDetails.updatedProductStatus
            cell.updatedStockQtyL.text=String(format:"%.3f",productModifiedDetails.changedStockQuantity ?? 0)
            cell.dateL.text=convertDateFormatter(date: productModifiedDetails.statusUpdatedDate ?? "")
           
            return cell
        }
        
        return UITableViewCell()
     }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainHistoryArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var productsList = [ProductChangesList]()
        productsList = mainHistoryArray
        
        print(productsList)
        let productModifiedDetails = productsList[indexPath.section].productModifingDetails!
      
        if isExpandable[indexPath.section] == true
        {
            var celllHeight=Int()
           
        if productModifiedDetails.change == "Edit" || productModifiedDetails.change == "add-currentinventory"
            {
                celllHeight = 372
                productsList[indexPath.section].cellHeight = celllHeight
            }
        else if productModifiedDetails.change=="share"
                {
            celllHeight = 135
            productsList[indexPath.section].cellHeight = celllHeight
        }
        else if productModifiedDetails.change=="uncheck-share"
                {
            celllHeight = 90
            productsList[indexPath.section].cellHeight = celllHeight
        }
        else if productModifiedDetails.change=="borrow"
        {
    celllHeight = 135
    productsList[indexPath.section].cellHeight = celllHeight
}
        else if productModifiedDetails.change=="uncheck-giveAway" || productModifiedDetails.change=="giveAway"
                {
            celllHeight = 80
            productsList[indexPath.section].cellHeight = celllHeight
        }
        else if productModifiedDetails.change=="lent"
        {
    celllHeight = 80
    productsList[indexPath.section].cellHeight = celllHeight
}
        else if productModifiedDetails.change=="uncheck-borrowlent"
        {
    celllHeight = 80
    productsList[indexPath.section].cellHeight = celllHeight
}
        else if productModifiedDetails.change=="Update" || productModifiedDetails.change=="update-giveAway"
                {
            celllHeight = 142
            productsList[indexPath.section].cellHeight = celllHeight
        }
            
            return CGFloat(celllHeight)
        }
        return 0
        
    }

   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
       return 65
       
   }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getEditHistoryAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + EditOrdersHistoryUrl + productId
                                    
        ordersHistoryServcCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:OrderHistoryRespVo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                
                                self.editArray = respVo.resultHistory ?? [ProductChangesList]()
                                self.mainHistoryArray=[ProductChangesList]()
                                self.isExpandable=[Bool]()
                                if self.editArray.count>0
                                {
                                    for i in 0..<self.editArray.count {
                                        if self.expandLabel.text=="Collapse all"
                                        {
                                            self.isExpandable.append(true)
                                        }
                                        else
                                        {
                                        self.isExpandable.append(false)
                                        }
                                        self.mainHistoryArray.append(self.editArray[i])
                                }
                                }
                                if self.updateArray.count>0
                                {
                                    for i in 0..<self.updateArray.count {
                                        if self.expandLabel.text=="Collapse all"
                                        {
                                            self.isExpandable.append(true)
                                        }
                                        else
                                        {
                                        self.isExpandable.append(false)
                                        }
                                        self.mainHistoryArray.append(self.updateArray[i])
                                }
                                }
                                self.historyTableView.reloadData()
                               
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
    func getUpdatesHistoryAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

        let URLString_loginIndividual = Constants.BaseUrl + UpdateOrdersHistoryUrl + productId
                                    
        ordersHistoryServcCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:OrderHistoryRespVo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                   
                            if status == "SUCCESS" {
                                self.mainHistoryArray=[ProductChangesList]()
                                self.updateArray = respVo.resultHistory ?? [ProductChangesList]()
                               
                                self.isExpandable=[Bool]()
                                if self.updateArray.count>0
                                {
                                    for i in 0..<self.updateArray.count {
                                        if self.expandLabel.text=="Collapse all"
                                        {
                                            self.isExpandable.append(true)
                                        }
                                        else
                                        {
                                        self.isExpandable.append(false)
                                        }
                                        let productModifiedDetails = self.updateArray[i].productModifingDetails!
                                        if productModifiedDetails.change=="add-currentinventory"
                                        {
                                            self.mainHistoryArray.append(self.updateArray[i])
                                        }
                                        else
                                        {
                                        self.mainHistoryArray.append(self.updateArray[i])
                                        }
                                }
                                }
                                self.historyTableView.reloadData()
//                                if(self.ordersHistoryResult.count == 0){
//                                    self.showEmptyMsgBtn()
//                                }

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
