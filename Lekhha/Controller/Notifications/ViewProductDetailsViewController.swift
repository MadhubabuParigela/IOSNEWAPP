//
//  ViewProductDetailsViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 04/03/22.
//

import UIKit

class ViewProductDetailsViewController: UIViewController {
    @IBOutlet var productId: UILabel!
    
    @IBOutlet var productDesc: UILabel!
    @IBOutlet var productName: UILabel!
    @IBOutlet var collapseButton: UIButton!
    @IBOutlet var oroductImage: UIImageView!
    @IBOutlet var stockQtyL: UILabel!
    @IBOutlet var stocckUnitL: UILabel!
    @IBOutlet var expiryDateL: UILabel!
    @IBOutlet var priceUnitL: UILabel!
    @IBOutlet var pricePerStockLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var storageLevel1Label: UILabel!
    @IBOutlet var storageLevel2Label: UILabel!
    @IBOutlet var storageLevel3Label: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var subCategoryLabel: UILabel!
    var mainHistoryArray=NSArray()
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var productsList = NSArray()
        productsList = mainHistoryArray
        
        print(productsList)
        let productDict=productsList[0]as? NSDictionary
        let prodDetails = productDict?.value(forKey: "productModifingDetails") as? NSDictionary
        
        let stockDetails = productDict?.value(forKey: "stockUnitDetails") as? NSArray ?? NSArray()
        let storageOneDetails = productDict?.value(forKey: "storageLocationLevel1Details") as? NSArray ?? NSArray()
        let storageTwoDetails = productDict?.value(forKey: "storageLocationLevel2Details") as? NSArray ?? NSArray()
        let storageThreeDetails = productDict?.value(forKey: "storageLocationLevel3Details") as? NSArray ?? NSArray()
        let priceUnitDetails = productDict?.value(forKey: "priceUnitDetails") as? NSArray ?? NSArray()
        
      
    
        let prodArray = prodDetails?.value(forKey: "productImages") as? NSArray
            
            if(prodArray?.count ?? 0  > 0){
                
                        let dict = prodArray?[0] as! NSDictionary
                        
                        let imageStr = dict.value(forKey: "0") as! String
                        
                        if !imageStr.isEmpty {
                            
                            let imgUrl:String = imageStr
                            
                            let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                                                
                            let imggg = Constants.BaseImageUrl + trimStr
                            
                            let url = URL.init(string: imggg)

                            
                            self.oroductImage?.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)

                            
                            self.oroductImage?.contentMode = UIView.ContentMode.scaleAspectFit
                            
                        }
                        else {
                            
                            self.oroductImage?.image = UIImage(named: "no_image")
                        }
            }else{
                
                self.oroductImage?.image = UIImage(named: "no_image")
            }
            
        self.productId.text=prodDetails?.value(forKey: "productUniqueNumber") as? String ?? ""
            self.productName.text=prodDetails?.value(forKey: "productName") as? String ?? ""
            self.productDesc.text=prodDetails?.value(forKey: "description") as? String ?? ""
        var stockQQu=Float()
        if let stockQuan = productDict?.value(forKey: "stockQuantity") as? Double {
            self.stockQtyL.text = String(format:"%.3f",stockQuan)
            stockQQu=Float(stockQuan)
        }
        else if let stockQuant = productDict?.value(forKey: "stockQuantity") as? Float{
            
            self.stockQtyL.text = String(format:"%.3f",stockQuant)
            stockQQu=stockQuant
        }
        else {
            
            self.stockQtyL.text = productDict?.value(forKey: "stockQuantity") as? String
            stockQQu=Float(productDict?.value(forKey: "stockQuantity") as? String ?? "") ?? 0
        }
        if stockDetails.count > 0 {
            let dd=stockDetails[0] as? NSDictionary
            self.stocckUnitL.text=dd?.value(forKey: "stockUnitName")as? String ?? ""
        }
        else
        {
            self.stocckUnitL.text==""
        }
            
        let expiryDate = convertDateFormatter(date: prodDetails?.value(forKey: "expiryDate")as? String ?? "")
        if expiryDate==""
        {
            self.expiryDateL.text=""
        }
        else
        {
        
            self.expiryDateL.text=expiryDate
        }
        if priceUnitDetails.count > 0 {
            let dd=priceUnitDetails[0] as? NSDictionary
            self.priceUnitL.text=dd?.value(forKey: "priceUnit")as? String ?? ""
        }
        else
        {
            self.priceUnitL.text=""
        }
        var unitPPrice=Float()
        if let unitPriceStr = prodDetails?.value(forKey: "unitPrice") as? Double {
           
           self.pricePerStockLabel.text = String(unitPriceStr)
           unitPPrice=Float(unitPriceStr)
       }
        else if let unitPriceStr = prodDetails?.value(forKey: "unitPrice") as? Float {
        self.pricePerStockLabel.text = String(unitPriceStr)
           unitPPrice=unitPriceStr
       }
       else {
           
        self.pricePerStockLabel.text = prodDetails?.value(forKey: "unitPrice") as? String
        unitPPrice=Float(prodDetails?.value(forKey: "unitPrice") as? String ?? "") ?? 0
       }
       
//           let obj3=stockQQu * unitPPrice
//           self.totalPriceLabel.text = String(format:"%.2f", obj3 ?? 0)
      
        
            if storageOneDetails.count != 0 {
                let dd=storageOneDetails[0] as? NSDictionary
            self.storageLevel1Label.text=dd?.value(forKey:"slocName")as? String ?? ""
            }
            else
            {
                self.storageLevel1Label.text=""
            }
            if storageTwoDetails.count != 0 {
                let dd=storageTwoDetails[0] as? NSDictionary
            self.storageLevel2Label.text=dd?.value(forKey:"slocName")as? String ?? ""
            }
            else
            {
                self.storageLevel2Label.text=""
            }
            if storageThreeDetails.count != 0 {
                let dd=storageThreeDetails[0] as? NSDictionary
            self.storageLevel3Label.text=dd?.value(forKey:"slocName")as? String ?? ""
            }
            else
            {
                self.storageLevel3Label.text=""
            }
        self.categoryLabel.text=prodDetails?.value(forKey: "category")as? String ?? ""
            self.subCategoryLabel.text=prodDetails?.value(forKey: "subCategory")as? String ?? ""
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
