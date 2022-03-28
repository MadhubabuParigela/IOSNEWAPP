//
//  AddStockUnitMasterTVCell.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import UIKit


//Stock Btn Cell Delegate
protocol AddStockUnitMasterBtnCellDelegate : class {
    func didPressButton(_ tag: Int)
}

class AddStockUnitMasterTVCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var stockUnitNameView: UIView!
    @IBOutlet weak var stockUnitNameTF: UITextField!
    @IBOutlet var stockWarnButton: UIButton!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet var descriptionWarnButton: UIButton!
    var cellDelegate: AddStockUnitMasterBtnCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        stockUnitNameView.layer.borderColor = UIColor.gray.cgColor
        stockUnitNameView.layer.borderWidth = 0.5
        stockUnitNameView.layer.cornerRadius = 3
        stockUnitNameView.clipsToBounds = true
        
        descriptionView.layer.borderColor = UIColor.gray.cgColor
        descriptionView.layer.borderWidth = 0.5
        descriptionView.layer.cornerRadius = 3
        descriptionView.clipsToBounds = true
        
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 5.0
        bgView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        bgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        bgView.layer.shadowRadius = 6.0
        bgView.layer.shadowOpacity = 0.7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag)
    }
}
