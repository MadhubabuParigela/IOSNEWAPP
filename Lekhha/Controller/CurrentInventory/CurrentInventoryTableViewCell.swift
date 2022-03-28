//
//  CurrentInventoryTableViewCell.swift
//  Lekha
//
//  Created by Mallesh Kurva on 25/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class CurrentInventoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var prodImgView: UIImageView!
    @IBOutlet weak var prodIDLbl: UILabel!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var desccriptionLbl: UILabel!
    @IBOutlet weak var stockQtyLbl: UILabel!
    @IBOutlet weak var stockUnitLbl: UILabel!
    @IBOutlet weak var expDateLbl: UILabel!
    @IBOutlet weak var storageLoclbl: UILabel!
    @IBOutlet var level2Label: UILabel!
    @IBOutlet var level3Label: UILabel!
    @IBOutlet weak var borrowedChckBox: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet var priceUnitLabel: UILabel!
    
    @IBOutlet weak var pricePerStockUnitLabel: UILabel!
    @IBOutlet weak var checkboxBtn: UIButton!
    @IBOutlet var shareCheckButton: UIButton!
    @IBOutlet weak var seperatorLine: UILabel!
    @IBOutlet weak var checkBoxLbl: UILabel!
    @IBOutlet var borrowLentLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
