//
//  ShppingCartTableViewCell.swift
//  Lekha
//
//  Created by Mallesh Kurva on 14/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class ShppingCartTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var prodIdLbl: UILabel!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var reqQtyLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var prefVendorLbl: UILabel!
//    @IBOutlet weak var prefPlaceLbl: UILabel!
    @IBOutlet weak var prefPurchaseDatelbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var saveForLaterBtn: UIButton!
    @IBOutlet weak var moveToCartBtn: UIButton!
    
    @IBOutlet weak var pricePerUnitLbl: UILabel!
    @IBOutlet weak var priceUnitLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var shoppingCheckBoxBtn: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
