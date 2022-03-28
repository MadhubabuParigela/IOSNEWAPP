//
//  UpdateGiveAwayTableViewCell.swift
//  Lekhha
//
//  Created by Swapna Nimma on 06/01/22.
//

import UIKit

class UpdateGiveAwayTableViewCell: UITableViewCell {

    @IBOutlet var giveawayL: UILabel!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var stockQty: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var stockUnitL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
