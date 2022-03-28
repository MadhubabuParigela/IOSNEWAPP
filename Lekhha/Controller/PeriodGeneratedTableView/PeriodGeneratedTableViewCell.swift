//
//  PeriodGeneratedTableViewCell.swift
//  LekhaLatest
//
//  Created by USM on 11/02/21.
//

import UIKit

class PeriodGeneratedTableViewCell: UITableViewCell {

    @IBOutlet weak var topLbl1: UILabel!
    @IBOutlet weak var topLbl2: UILabel!
    @IBOutlet weak var topLbl3: UILabel!
    
    @IBOutlet weak var totalValLbl: UILabel!
    @IBOutlet weak var weekNameLbl: UILabel!
    @IBOutlet weak var prodCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
