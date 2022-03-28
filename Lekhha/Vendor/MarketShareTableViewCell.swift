//
//  MarketShareTableViewCell.swift
//  Lekhha
//
//  Created by USM on 15/06/21.
//

import UIKit

class MarketShareTableViewCell: UITableViewCell {
    
    @IBOutlet weak var periodLbl: UILabel!
    @IBOutlet weak var totalValLbl: UILabel!
    @IBOutlet weak var shareValLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
