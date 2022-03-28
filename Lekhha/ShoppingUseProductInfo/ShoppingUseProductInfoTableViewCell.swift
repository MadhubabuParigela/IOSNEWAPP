//
//  ShoppingUseProductInfoTableViewCell.swift
//  Lekha
//
//  Created by USM on 04/01/21.
//  Copyright © 2021 Longdom. All rights reserved.
//

import UIKit

class ShoppingUseProductInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var prodImgView: UIImageView!
    @IBOutlet weak var prodTitleLbl: UILabel!
    
    @IBOutlet weak var prodIDLbl: UILabel!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var stockQuanLbl: UILabel!
    @IBOutlet weak var stockUnitLbl: UILabel!
    @IBOutlet weak var expiryDateLbl: UILabel!
    @IBOutlet weak var storageLocLbl: UILabel!
    @IBOutlet weak var saveForLaterBtn: UIButton!
    
    @IBOutlet var level1Label: UILabel!
    @IBOutlet var level2Label: UILabel!
    @IBOutlet var level3Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
