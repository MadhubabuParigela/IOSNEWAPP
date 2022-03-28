//
//  UpdateShareTableViewCell.swift
//  Lekhha
//
//  Created by Swapna Nimma on 07/01/22.
//

import UIKit

class UpdateShareTableViewCell: UITableViewCell {
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var shareTitleL: UILabel!
    @IBOutlet var stockQty: UILabel!
    @IBOutlet var stockUnitL: UILabel!
    @IBOutlet var sharedUserL: UILabel!
    @IBOutlet var sharedUserT: UILabel!
    @IBOutlet var sharedView: UIView!
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
