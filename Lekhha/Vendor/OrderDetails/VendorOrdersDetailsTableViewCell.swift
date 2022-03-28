//
//  VendorOrdersDetailsTableViewCell.swift
//  LekhaLatest
//
//  Created by USM on 31/03/21.
//

import UIKit

class VendorOrdersDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var createdDateLbl: UILabel!

    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var productCountLbl: UILabel!
    @IBOutlet weak var orderPriceLbl: UILabel!
    @IBOutlet weak var doorDeliveryLbl: UILabel!
    @IBOutlet weak var accIDLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var orderStatusImgView: UIImageView!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBAction func acceptBtnTap(_ sender: Any) {
    }
    
    @IBAction func declineBtnTap(_ sender: Any) {
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
