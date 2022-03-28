//
//  ShoppingCartTableViewCell.swift
//  Lekha
//
//  Created by Mallesh Kurva on 16/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class ShoppingCartTableViewCell: UITableViewCell {
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!

    @IBOutlet weak var itemNumLbl: UILabel!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var prefVendorLbl: UILabel!
    @IBOutlet weak var prefPricelbl: UILabel!
    @IBOutlet weak var plannedPuchaseDate: UILabel!
    @IBOutlet var unitPriceWarnImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
