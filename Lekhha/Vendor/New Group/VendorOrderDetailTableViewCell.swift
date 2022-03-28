//
//  VendorOrderDetailTableViewCell.swift
//  LekhaLatest
//
//  Created by USM on 30/04/21.
//

import UIKit

class VendorOrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var doorDeliveryLbl: UILabel!
    @IBOutlet weak var prodImgView: UIImageView!
    @IBOutlet weak var prodIdLbl: UILabel!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var reqQtyLbl: UILabel!
    @IBOutlet weak var stockUnitLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var updateDetailsBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var dateTxxtLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
