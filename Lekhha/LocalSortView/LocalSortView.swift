//
//  LocalSortView.swift
//  Lekha
//
//  Created by Mallesh on 09/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit

class LocalSortView: UIView {
    
    @IBOutlet weak var prodCheckBtnYConstant: NSLayoutConstraint!
    @IBOutlet weak var prodQuanYConstant: NSLayoutConstraint!
    @IBOutlet weak var innerLocalSortView: UIView!
    @IBOutlet weak var backHiddenBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var applybtn: UIButton!
    
    @IBOutlet weak var ascendingBtn: UIButton!
    @IBOutlet weak var descendingBtn: UIButton!

    @IBOutlet weak var purchaseDateBtn: UIButton!
    @IBOutlet weak var expiryDateBtn: UIButton!
    @IBOutlet weak var productDateBtn: UIButton!
    @IBOutlet weak var quantityBtn: UIButton!

    @IBOutlet weak var expiryDateTxtBtn: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
