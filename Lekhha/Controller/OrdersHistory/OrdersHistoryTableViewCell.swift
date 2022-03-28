//
//  OrdersHistoryTableViewCell.swift
//  Lekha
//
//  Created by Mallesh on 10/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class OrdersHistoryTableViewCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var changeTypeLabel: UILabel!
    @IBOutlet var expandableButton: UIButton!
    @IBOutlet weak var prodImgView: UIImageView!
    @IBOutlet weak var prodIdLbl: UILabel!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var orderedQtyLbl: UILabel!
    @IBOutlet weak var orderUnitLbl: UILabel!
    @IBOutlet weak var subCategoryLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet var companyNameLabel: UILabel!
    //    @IBOutlet weak var priceLbl: UILabel!
//    @IBOutlet weak var orderIdLbl: UILabel!
//    @IBOutlet weak var vendorIdLbl: UILabel!
//    @IBOutlet weak var purchaseDateLbl: UILabel!
    @IBOutlet var stackView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateOfCreationLabel: UILabel!
    //    @IBOutlet weak var vendorNameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var pricePerStockUnitLbl: UILabel!
    @IBOutlet weak var priceUnitLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var levelOneLabel: UILabel!
    @IBOutlet weak var levelTwoLabel: UILabel!
    @IBOutlet weak var levelThreeLabel: UILabel!
    @IBOutlet weak var borrowLentBtn: UIButton!
    @IBOutlet weak var borrowLentImg: UIImageView!
    @IBOutlet weak var shareOneBtn: UIButton!
    @IBOutlet weak var shareCheckImg: UIImageView!
    @IBOutlet weak var shareTwoBtn: UIButton!
    @IBOutlet weak var shareTwoCheckImg: UIImageView!
    @IBOutlet weak var expireDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func shareOneBtnAction(_ sender: UIButton) {
    }
    @IBAction func shareTwoBtnAction(_ sender: UIButton) {
    }
    
}
