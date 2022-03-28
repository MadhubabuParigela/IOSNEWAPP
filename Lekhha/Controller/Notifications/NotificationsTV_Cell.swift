//
//  NotificationsTV_Cell.swift
//  LekhaApp
//
//  Created by apple on 11/23/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

class NotificationsTV_Cell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var imgBackView: UIView!
    
    @IBOutlet weak var myImgView: UIImageView!
    
    @IBOutlet weak var namehereLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var someTextLbl: UILabel!
    
    @IBOutlet weak var dottsBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
