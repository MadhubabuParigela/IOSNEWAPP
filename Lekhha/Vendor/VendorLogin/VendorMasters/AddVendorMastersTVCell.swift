//
//  AddVendorMastersTVCell.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import UIKit
import DropDown

//Stock Btn Cell Delegate
protocol AddVendorMasterBtnCellDelegate : class {
    func didPressButton(_ tag: Int)
    func didPressCategoryButton(_ tag: Int)
    func didPressSubCategoryButton(_ tag: Int)
}

class AddVendorMastersTVCell: UITableViewCell {
    
    @IBOutlet weak var vendorNameTF: UITextField!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var subcategoryView: UIView!
    @IBOutlet weak var subcategoryTF: UITextField!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyNameTF: UITextField!
    @IBOutlet weak var gstView: UIView!
    @IBOutlet weak var gstTF: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var subcategoryBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var cellDelegate: AddVendorMasterBtnCellDelegate?
    let dropDown = DropDown() //2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categoryView.layer.borderColor = UIColor.gray.cgColor
        categoryView.layer.borderWidth = 0.5
        categoryView.layer.cornerRadius = 3
        categoryView.clipsToBounds = true
        
        subcategoryView.layer.borderColor = UIColor.gray.cgColor
        subcategoryView.layer.borderWidth = 0.5
        subcategoryView.layer.cornerRadius = 3
        subcategoryView.clipsToBounds = true
        
        descriptionView.layer.borderColor = UIColor.gray.cgColor
        descriptionView.layer.borderWidth = 0.5
        descriptionView.layer.cornerRadius = 3
        descriptionView.clipsToBounds = true
        
        companyView.layer.borderColor = UIColor.gray.cgColor
        companyView.layer.borderWidth = 0.5
        companyView.layer.cornerRadius = 3
        companyView.clipsToBounds = true
        
        gstView.layer.borderColor = UIColor.gray.cgColor
        gstView.layer.borderWidth = 0.5
        gstView.layer.cornerRadius = 3
        gstView.clipsToBounds = true
        
        locationView.layer.borderColor = UIColor.gray.cgColor
        locationView.layer.borderWidth = 0.5
        locationView.layer.cornerRadius = 3
        locationView.clipsToBounds = true
        
        addressView.layer.borderColor = UIColor.gray.cgColor
        addressView.layer.borderWidth = 0.5
        addressView.layer.cornerRadius = 3
        addressView.clipsToBounds = true
        
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
    
    @IBAction func categoryBtnAction(_ sender: UIButton) {
        
        cellDelegate?.didPressCategoryButton(sender.tag)
        
        dropDown.dataSource = ["Level 1","Level 2","Level 3"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.categoryTF.text = item
            }
    }
    @IBAction func subCategoryBtnAction(_ sender: UIButton) {
        
        cellDelegate?.didPressSubCategoryButton(sender.tag)
        
        dropDown.dataSource = ["Level 1","Level 2","Level 3"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.subcategoryTF.text = item
            }
    }
    
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        
        cellDelegate?.didPressButton(sender.tag)
    }
    
}
