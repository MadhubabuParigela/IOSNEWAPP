//
//  VendorListTableViewCell.swift
//  Lekha
//
//  Created by Mallesh Kurva on 21/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class VendorListTableViewCell: UITableViewCell {

    @IBOutlet weak var vendorNameLbl: UILabel!
    @IBOutlet weak var vendorIdLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var subCategoryLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var GSTInLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
