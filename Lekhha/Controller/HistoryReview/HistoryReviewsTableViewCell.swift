//
//  HistoryReviewsTableViewCell.swift
//  Lekha
//
//  Created by Mallesh on 10/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class HistoryReviewsTableViewCell: UITableViewCell {
    
    @IBOutlet var userCountL: UILabel!
    @IBOutlet weak var commentsTitleLbl: UILabel!
    @IBOutlet weak var editBtnYConstant: NSLayoutConstraint!
    @IBOutlet weak var permissionsYConstant: NSLayoutConstraint!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userIdLbl: UILabel!
    @IBOutlet weak var mobileNumlbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var commentsLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var currentInventoryLbl: UILabel!
    @IBOutlet weak var shoppingCartLbl: UILabel!
    @IBOutlet weak var openOrderslbl: UILabel!
    @IBOutlet weak var orderHistoryLbl: UILabel!
    @IBOutlet weak var vendorMastersLbl: UILabel!
    @IBOutlet weak var vendorConnectLbl: UILabel!
    @IBOutlet weak var consumerConnectLbl: UILabel!
    @IBOutlet weak var giveAwaylbl: UILabel!
    @IBOutlet weak var borrowedLbl: UILabel!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var reportsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
