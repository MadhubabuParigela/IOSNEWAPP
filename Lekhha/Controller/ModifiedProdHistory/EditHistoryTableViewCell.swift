//
//  EditHistoryTableViewCell.swift
//  Lekhha
//
//  Created by Swapna Nimma on 06/01/22.
//

import UIKit

class EditHistoryTableViewCell: UITableViewCell {
    @IBOutlet var productId: UILabel!
    
    @IBOutlet var productDesc: UILabel!
    @IBOutlet var productName: UILabel!
    @IBOutlet var collapseButton: UIButton!
    @IBOutlet var oroductImage: UIImageView!
    @IBOutlet var stockQtyL: UILabel!
    @IBOutlet var stocckUnitL: UILabel!
    @IBOutlet var expiryDateL: UILabel!
    @IBOutlet var priceUnitL: UILabel!
    @IBOutlet var pricePerStockLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var storageLevel1Label: UILabel!
    @IBOutlet var storageLevel2Label: UILabel!
    @IBOutlet var storageLevel3Label: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var subCategoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
