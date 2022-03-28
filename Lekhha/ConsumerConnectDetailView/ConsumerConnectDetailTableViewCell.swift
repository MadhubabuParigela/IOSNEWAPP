//
//  ConsumerConnectDetailTableViewCell.swift
//  Lekhha
//
//  Created by USM on 31/05/21.
//

import UIKit

class ConsumerConnectDetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var profImgView: UIImageView!
    @IBOutlet weak var prodIdLbl: UILabel!
    @IBOutlet weak var prodNameLbl: UILabel!
    
    @IBOutlet weak var purchaseDateLbl: UILabel!
    @IBOutlet weak var exxpiryDateLbl: UILabel!
    @IBOutlet weak var pricePerStockUnitLbl: UILabel!
    @IBOutlet weak var stockUnitLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var offerQtyLbl: UILabel!
    
    @IBOutlet var productDescLabel: UILabel!
    @IBOutlet weak var prodViewBtn: UIButton!
    @IBOutlet weak var bidBtn: UIButton!
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
