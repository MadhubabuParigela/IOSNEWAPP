//
//  GiveAwayOrderHistoryView.swift
//  Lekhha
//
//  Created by Swapna Nimma on 18/01/22.
//

import UIKit

class GiveAwayOrderHistoryView: UIView {
    let nibName = "GiveAwayOrderHistoryView"
    @IBOutlet var mainView: UIView!
    @IBOutlet var dataView: UIView!
    @IBOutlet var changeTypeLabel: UILabel!
    @IBOutlet var companyNameL: UILabel!
    @IBOutlet var modifiedDateL: UILabel!
    @IBOutlet var userAccountL: UILabel!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var stockQty: UILabel!
    @IBOutlet var stockUnitL: UILabel!
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
