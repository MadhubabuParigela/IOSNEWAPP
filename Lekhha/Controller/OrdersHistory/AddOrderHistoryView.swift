//
//  AddOrderHistoryView.swift
//  Lekhha
//
//  Created by Swapna Nimma on 25/12/21.
//

import UIKit

class AddOrderHistoryView: UIView {
    let nibName = "AddOrderHistoryView"
    @IBOutlet var mainView: UIView!
    @IBOutlet var dataView: UIView!
    @IBOutlet var changeTypeLabel: UILabel!
    @IBOutlet var companyNameL: UILabel!
    @IBOutlet var modifiedDateL: UILabel!
    @IBOutlet var userAccountL: UILabel!
    @IBOutlet var orderedQtyL: UILabel!
    @IBOutlet var stockUnitL: UILabel!
    @IBOutlet var expiryDateL: UILabel!
    @IBOutlet var priceUnitL: UILabel!
    @IBOutlet var priceperstockUnitL: UILabel!
    @IBOutlet var totalPriceL: UILabel!
    @IBOutlet var storageLocation1L: UILabel!
    @IBOutlet var storageLocation2L: UILabel!
    @IBOutlet var storageLocation3L: UILabel!
    @IBOutlet var categoryL: UILabel!
    @IBOutlet var subcategoryL: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
        
    func commonInit(){
            if let view = Bundle.main.loadNibNamed(nibName,
                                                   owner: self,
                                                   options: nil)?.first as? UIView {
                view.frame = self.bounds
                addSubview(view)
                
            }
            else {
               fatalError("no file")
            }
         
           
        }
}
