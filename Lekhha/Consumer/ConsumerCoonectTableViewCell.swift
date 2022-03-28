//
//  ConsumerCoonectTableViewCell.swift
//  LekhaLatest
//
//  Created by USM on 17/05/21.
//

import UIKit
import MapKit
class ConsumerCoonectTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var prodIDLbl: UILabel!
    @IBOutlet weak var prodImgView: UIImageView!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var prodDescLbl: UILabel!
    
    @IBOutlet var chatButton: UIButton!
    
    @IBOutlet weak var acceptBidBtn: UIButton!
   
    @IBOutlet var statusOfBidL: UILabel!
    @IBOutlet var statusBiddL: UILabel!
    @IBOutlet var offeredQuantityL: UILabel!
    @IBOutlet var offeredQuantityAnswerL: UILabel!
    @IBOutlet var bidQuantityL: UILabel!
    @IBOutlet var bidQuantityAnswerL: UILabel!
    @IBOutlet var stockUnitL: UILabel!
    @IBOutlet var stockUnitAnswerL: UILabel!
    @IBOutlet var purchaseDateL: UILabel!
    @IBOutlet var purchaseDateAnswerL: UILabel!
    @IBOutlet var expiryDateL: UILabel!
    @IBOutlet var expiryDateAnswerL: UILabel!
    @IBOutlet var pricePerStockUnitL: UILabel!
    @IBOutlet var pricePerStockUnitAnswerL: UILabel!
    @IBOutlet var totalPriceL: UILabel!
    @IBOutlet var totalPriceAnswerL: UILabel!
    @IBOutlet var bidPricePerUnitL: UILabel!
    @IBOutlet var bidPricePerUnitAnswerL: UILabel!
    @IBOutlet var productChangeHistoryL: UILabel!
    @IBOutlet var productChangeHistoryButton: UIButton!
    @IBOutlet var giveAwayConsumerLocationL: UILabel!
    @IBOutlet var accountNameBtn: UIButton!
    @IBOutlet var productMapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
