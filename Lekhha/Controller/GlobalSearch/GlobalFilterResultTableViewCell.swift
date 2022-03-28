//
//  GlobalFilterResultTableViewCell.swift
//  LekhaLatest
//
//  Created by USM on 18/02/21.
//

import UIKit

class GlobalFilterResultTableViewCell: UITableViewCell {

    @IBOutlet weak var stockQtyLbl: UILabel!
    @IBOutlet weak var stockUnitLbl: UILabel!
    @IBOutlet weak var expiryDateLbl: UILabel!
    @IBOutlet weak var storageLocLbl: UILabel!
    
    @IBOutlet weak var prodIDLbl: UILabel!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var desclbl: UILabel!
    
    @IBOutlet weak var prodImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
