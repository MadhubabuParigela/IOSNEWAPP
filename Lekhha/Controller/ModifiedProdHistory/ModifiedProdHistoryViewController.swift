//
//  ModifiedProdHistoryViewController.swift
//  Lekha
//
//  Created by USM on 07/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class ModifiedProdHistoryViewController: UIViewController {
    @IBAction func backBtnTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var userIDLbl: UILabel!
    
    @IBOutlet weak var prodImgView: UIImageView!
    @IBOutlet weak var prodIdLbl: UILabel!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var prodDescLbl: UILabel!
    @IBOutlet weak var stockQtyLbl: UILabel!
    @IBOutlet weak var stockUntiTF: UILabel!
    @IBOutlet weak var expDateLBL: UILabel!
    @IBOutlet weak var storageLocLbl: UILabel!
    @IBOutlet weak var borrowed_RentBtn: UIButton!
    
    @IBOutlet weak var giveAwayBtn: UIButton!
    var productDataDict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateData()
        
        // Do any additional setup after loading the view.
    }
    
    func updateData() {
        
//        let productDetailsArray = productDataDict.value(forKey: "productModifingDetails") as! NSArray
//        let userDataArray = productDataDict.value(forKey: "userdetails") as! NSArray
        
        let productDetailsDict = productDataDict.value(forKey: "productModifingDetails") as! NSDictionary
        let accountDetailsArray = productDataDict.value(forKey: "accountinfo") as! NSArray
        var accountDetailsDict=NSDictionary()
        if accountDetailsArray.count>0
        {
            accountDetailsDict = accountDetailsArray[0] as! NSDictionary
            storageLocLbl.text = accountDetailsDict.value(forKey: "city") as? String
        }
        else
        {
            storageLocLbl.text = ""
        }
        let stockUnitDetailsArray  = productDataDict.value(forKey: "stockUnitDetails") as! NSArray
        var stockUnitDetailsDict=NSDictionary()
        if stockUnitDetailsArray.count>0
        {
            stockUnitDetailsDict = stockUnitDetailsArray[0] as! NSDictionary
            stockUntiTF.text = stockUnitDetailsDict.value(forKey: "stockUnitName") as? String
        }
        else
        {
            stockUntiTF.text = ""
        }
        
        let userDataArray = productDataDict.value(forKey: "userinfo") as! NSArray
        var userDataDict=NSDictionary()
        if userDataArray.count>0
        {
            userDataDict = userDataArray[0] as! NSDictionary
            let firstName = userDataDict.value(forKey: "firstName") as? String
            let lastName = userDataDict.value(forKey: "lastName") as? String
            
            let name = "\(firstName!) \(lastName!)"
            
            userIDLbl.text = name
        }
        else
        {
          
            userIDLbl.text = ""
        }
        
      
        msgLbl.text = productDataDict.value(forKey: "message") as? String
        let expiryDate = (productDataDict.value(forKey: "modifiedDateTime"))!
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let convertedDate = dateFormatter.date(from: expiryDate as! String)
        
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:a"///this is what you want to convert format
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)
        
//      let convertedExpiryDate = convertDateTimeFormatter(date: expiryDate as! String)
        
        dateTimeLbl.text = timeStamp
        
        prodIdLbl.text = (productDetailsDict.value(forKey: "productUniqueNumber") as?
                            String)
        prodNameLbl.text = (productDetailsDict.value(forKey: "productName") as? String)
        prodDescLbl.text = (productDetailsDict.value(forKey: "description") as? String)

        let stockQuan = productDetailsDict.value(forKey: "stockQuantity") as? Int ?? 0
        
        stockQtyLbl.text = String(stockQuan)
        
        
        
        
        let prodArray = (productDetailsDict.value(forKey: "productImages") as! NSArray)
        
        if(prodArray.count  > 0){
            
            let dict = prodArray[0] as! NSDictionary
                    
                    let imageStr = dict.value(forKey: "0") as! String
                    
                    if !imageStr.isEmpty {
                        
                        let imgUrl:String = imageStr
                        
                        let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                            
                        let imggg = Constants.BaseImageUrl + trimStr
                        
                        let url = URL.init(string: imggg)

//                        prodImgView?.sd_setImage(with: url , placeholderImage: UIImage(named: "add photo"))
                        
                        prodImgView?.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                        
                        prodImgView?.contentMode = UIView.ContentMode.scaleAspectFit
                        
                    }
                    else {
                        
                        prodImgView?.image = UIImage(named: "no_image")
                    }
        }else{
            prodImgView?.image = UIImage(named: "no_image")

        }

        let expiryDateProd = (productDetailsDict.value(forKey: "expiryDate") as? String) ?? ""
        let convertedExpiryDateProd = convertDateFormatter(date: expiryDateProd )
        
        expDateLBL.text = convertedExpiryDateProd
        
        let borrowedStatus = (productDetailsDict.value(forKey: "borrowed") as? String)

        if borrowedStatus == "yes"
        {
            borrowed_RentBtn.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
            
        }else{
            borrowed_RentBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)

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
