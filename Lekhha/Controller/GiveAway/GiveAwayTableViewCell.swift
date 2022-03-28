//
//  GiveAwayTableViewCell.swift
//  Lekha
//
//  Created by Mallesh on 11/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
//Personal Btn Cell Delegate
protocol GiveAwayBtnCellDelegate : class {
    func didCancelBidPressBtn(_ tag: Int)
    func didChangeHistoryPressBtn(_ tag: Int)
    func didBiddingDetailsPressBtn(_ tag: Int)
}

class GiveAwayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productIdLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var stockQuantityLabel: UILabel!
    @IBOutlet weak var offeredQuantityLabel: UILabel!
    @IBOutlet weak var stockUnitLabel: UILabel!
    @IBOutlet weak var purchaseDateLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var pricePerStockUnitLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var statusBidLabel: UILabel!
    @IBOutlet weak var productChangeHistoryBtn: UIButton!
    @IBOutlet weak var biddingDetailsBtn: UIButton!
    @IBOutlet weak var cancelBidBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    var cellDelegate: GiveAwayBtnCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func cancelBidBtnAction(_ sender: UIButton) {
        cellDelegate?.didCancelBidPressBtn(sender.tag)
    }
    @IBAction func changeHistoryBtnAction(_ sender: UIButton) {
        cellDelegate?.didChangeHistoryPressBtn(sender.tag)
    }
    @IBAction func biddingDetailsBtnAction(_ sender: UIButton) {
        cellDelegate?.didBiddingDetailsPressBtn(sender.tag)
    }
}
