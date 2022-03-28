//
//  ProductModfitingTableViewCell.swift
//  Lekhha
//
//  Created by USM on 05/08/21.
//

import UIKit

class ProductModfitingTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var dateLblField: UILabel!
    @IBOutlet var arrowButton: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
