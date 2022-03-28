//
//  VendorMastersTVCell.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import UIKit
//Stock Btn Cell Delegate
protocol VendorMasterBtnCellDelegate : class {
    func didPressButton(_ tag: Int)
}
class VendorMastersTVCell: UITableViewCell {
    
    @IBOutlet weak var naLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var vendorIdLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var gstLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var vendorStatusLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var cellDelegate: VendorMasterBtnCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editBtnAction(_ sender: UIButton) {
        
        cellDelegate?.didPressButton(sender.tag)
    }
    
}
