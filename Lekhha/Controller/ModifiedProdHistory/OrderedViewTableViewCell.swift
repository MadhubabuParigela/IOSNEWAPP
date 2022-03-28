//
//  OrderedViewTableViewCell.swift
//  Lekhha
//
//  Created by Swapna Nimma on 06/01/22.
//

import UIKit

class OrderedViewTableViewCell: UITableViewCell {

    @IBOutlet var availableStockQtyL: UILabel!
    @IBOutlet var stockUnitL: UILabel!
    @IBOutlet var currentStatusL: UILabel!
    @IBOutlet var updatedStockQtyL: UILabel!
    @IBOutlet var dateL: UILabel!
    @IBOutlet var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
