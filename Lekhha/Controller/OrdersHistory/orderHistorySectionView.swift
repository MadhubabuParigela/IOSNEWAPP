//
//  orderHistorySectionView.swift
//  Lekhha
//
//  Created by Swapna Nimma on 25/12/21.
//

import UIKit

class orderHistorySectionView: UIView {

    let nibName = "orderHistorySectionView"
    @IBOutlet var mainView: UIView!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productId: UILabel!
    @IBOutlet var productNameL: UILabel!
    @IBOutlet var descriptionL: UILabel!
    @IBOutlet var collapseButtonL: UIButton!
   
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
