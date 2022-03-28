//
//  UpdateOpenOrdersTableViewCell.swift
//  Lekha
//
//  Created by USM on 08/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class UpdateOpenOrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var orderedQtyTF: UITextField!
    @IBOutlet weak var stockUnitTF: UITextField!
    @IBOutlet weak var vendorTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var purchaseDataBtn: UIButton!
    @IBOutlet weak var statusBtn: UIButton!
    
    @IBOutlet weak var updateOpenOrdersBtn: UIButton!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var prodIDTF: UILabel!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var editDetailsBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
