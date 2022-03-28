//
//  UpdateOrderHistoryView.swift
//  Lekhha
//
//  Created by Swapna Nimma on 25/12/21.
//

import UIKit

class UpdateOrderHistoryView: UIView {
    let nibName = "UpdateOrderHistoryView"
    @IBOutlet var mainView: UIView!
    @IBOutlet var dataView: UIView!
    @IBOutlet var changeTypeLabel: UILabel!
    @IBOutlet var companyNameL: UILabel!
    @IBOutlet var modifiedDateL: UILabel!
    @IBOutlet var userAccountL: UILabel!
    @IBOutlet var availableStockL: UILabel!
    @IBOutlet var updatedStockL: UILabel!
    @IBOutlet var stockUnitL: UILabel!
    @IBOutlet var dateL: UILabel!
    @IBOutlet var currentStatusL: UILabel!
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
