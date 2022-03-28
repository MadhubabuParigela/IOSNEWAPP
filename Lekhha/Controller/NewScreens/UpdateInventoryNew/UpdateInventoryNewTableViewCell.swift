//
//  UpdateInventoryNewTableViewCell.swift
//  Lekhha
//
//  Created by Swapna Nimma on 24/03/22.
//

import UIKit

class UpdateInventoryNewTableViewCell: UITableViewCell {
    @IBOutlet weak var prodImgView: UIImageView!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var stockQuanTF: UITextField!
    @IBOutlet weak var stockUnitTF: UITextField!
//    @IBOutlet weak var currentStateTF: UITextField!
    
    @IBOutlet weak var expiryDateBtn: UIButton!
    @IBOutlet weak var currentInventoryBtn: UIButton!
    @IBOutlet weak var expiredStockTF: UITextField!
    @IBOutlet weak var expiredDateTF: UITextField!
    @IBOutlet weak var storageLocationTF: UITextField!
    @IBOutlet var storageLocationLevel2: UITextField!
    @IBOutlet var storageLocationLevel3: UITextField!
    @IBOutlet weak var isBorrowedCheckBtn: UIButton!
    
    @IBOutlet weak var prodImgConstant: NSLayoutConstraint!
    
    @IBOutlet weak var prodIdConstant: NSLayoutConstraint!
    @IBOutlet weak var borrowLentTxtLbl: UIButton!
    @IBOutlet weak var expiredStockLbl: UILabel!
    @IBOutlet weak var updateDetailsBtn: UIButton!
    
    @IBOutlet weak var expiryDateLbl: UILabel!
    @IBOutlet weak var editDetailsBtn: UIButton!
    
    @IBOutlet weak var changeHistoryBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
