//
//  StorageLocationMasterTVCell.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import UIKit

//Stock Btn Cell Delegate
protocol StorageLocationMasterBtnCellDelegate : class {
    func didPressButton(_ tag: Int)
}
class StorageLocationMasterTVCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var naLabel: UILabel!
    
    @IBOutlet weak var naEditImg: UIImageView!
    @IBOutlet weak var naEditBtn: UIButton!
    @IBOutlet weak var storageLocationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var hierachyLevelLabel: UILabel!
    @IBOutlet weak var parentLocationLabel: UILabel!
    @IBOutlet weak var defaultStorageLocationLabel: UILabel!
    
    @IBOutlet weak var defaultLabel: UILabel!
    var cellDelegate: StorageLocationMasterBtnCellDelegate?
    
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
