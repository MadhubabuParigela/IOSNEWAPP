//
//  ApprovalTableViewCell.swift
//  Lekha
//
//  Created by Mallesh on 10/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class ApprovalTableViewCell: UITableViewCell {

    @IBOutlet var userCountLabel: UILabel!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userIdTF: UITextField!
    @IBOutlet weak var mobileNumTF: UITextField!
    @IBOutlet weak var dateTimeTF: UITextField!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var commentsTxtView: UITextView!
    @IBOutlet weak var currentInventoryBtn: UIButton!
    @IBOutlet weak var shoppingCartBtn: UIButton!
    @IBOutlet weak var openOrdersBtn: UIButton!
    @IBOutlet weak var orderHistoryBtn: UIButton!
    @IBOutlet weak var vendorMastersBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet var giveAwayBtn: UIButton!
    @IBOutlet var consumerConnectBtn: UIButton!
    
    @IBOutlet var reportBtn: UIButton!
    @IBOutlet var vendorConnectBtn: UIButton!
    @IBOutlet var borrowBtn: UIButton!
    @IBOutlet var shareBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

