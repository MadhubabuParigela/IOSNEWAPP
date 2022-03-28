//
//  PropertiesShowTableViewCell.swift
//  Lekhha
//
//  Created by Swapna Nimma on 28/01/22.
//

import UIKit

class PropertiesShowTableViewCell: UITableViewCell {

    @IBOutlet var selectView: UIView!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var nameView: UIView!
    @IBOutlet var nameTextView: UITextView!
    @IBOutlet var priceView: UIView!
    @IBOutlet var priceTF: UITextField!
    @IBOutlet var quantityView: UIView!
    @IBOutlet var quantityTF: UITextField!
    @IBOutlet var priceWarn: UIButton!
    @IBOutlet var quantityWarn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
