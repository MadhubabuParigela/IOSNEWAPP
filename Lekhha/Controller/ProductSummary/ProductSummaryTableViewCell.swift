//
//  ProductSummaryTableViewCell.swift
//  Lekha
//
//  Created by Mallesh Kurva on 09/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class ProductSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNumLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var vendorIdLbl: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
//    let imageStr = thumbBase64Str
//    let imageOne = ["productImage": image1Base64Str]
//    let imageTwo = ["productImage": image2Base64Str]
//    let imageThree = ["productImage": image3Base64Str]
//
//
//    let parms = ["productName": productNameTF.text ?? "",
//    "productDescription":description_TextView.text ?? "",
//    "weight": grossWeightTF.text ?? "",
//    "units": unitTF.text ?? "",
//    "price": priceTF.text ?? "",
//    "discountedPrice": discountPriceTF.text ?? "",
//    "purity": purityTF.text ?? "",
//    "size": sizeTF.text ?? "",
//    "colour": colorTF.text ?? "",
//    "occasion": occasionTF.text ?? "",
//    "ratings": "4",
//    "returnPolicy":returnpolicy_TextView.text ?? "",
//    "availableStockQuantity":stockquantityTF.text ?? "",
//    "categoryId":"5f5dc1081228ed1a34dd955d",
//    "subCategoryId": "5f5efc7d1a53f52bf09ef735",
//    "storeId":storeId!,
//    "thumbNailImage":imageStr,
//    "productImages":[imageOne,imageTwo,imageThree]] as [String : Any]
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
