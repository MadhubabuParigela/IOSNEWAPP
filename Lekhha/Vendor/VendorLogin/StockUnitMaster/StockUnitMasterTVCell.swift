//
//  StockUnitMasterTVCell.swift
//  Lekhha
//
//  Created by USM on 04/11/21.
//

import UIKit
//Stock Btn Cell Delegate
protocol StockUnitMasterBtnCellDelegate : class {
    func didPressButton(_ tag: Int)
}

class StockUnitMasterTVCell: UITableViewCell {
    
    @IBOutlet weak var NALabel: UILabel!
    @IBOutlet weak var NAEditBtn: UIButton!
    @IBOutlet weak var NAEditImg: UIImageView!
    @IBOutlet weak var stockUnitLabel: UILabel!
    @IBOutlet weak var stockUnitText: UILabel!
    
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var defaultStockUnitLabel: UILabel!
    @IBOutlet weak var defaultStockUnitText: UILabel!
    
    @IBOutlet weak var defaultStockUnitView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    var cellDelegate: StockUnitMasterBtnCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    @IBAction func naEditBtnAction(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag)
    }
}
