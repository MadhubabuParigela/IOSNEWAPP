//
//  OpenOrdersTableViewCell.swift
//  Lekha
//
//  Created by USM on 23/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class OpenOrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var orderQtyLbl: UILabel!
    @IBOutlet weak var orderUnitLbl: UILabel!
    @IBOutlet weak var vendorNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var purchaseDateLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var pricePerStockUnitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
