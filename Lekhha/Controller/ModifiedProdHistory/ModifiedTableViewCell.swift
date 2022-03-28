//
//  ModifiedTableViewCell.swift
//  Lekha
//
//  Created by USM on 07/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class ModifiedTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet var modifiedButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
