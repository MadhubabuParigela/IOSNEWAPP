//
//  TotalvaluationTV_Cell.swift
//  LekhaApp
//
//  Created by apple on 11/24/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

class TotalvaluationTV_Cell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!

    @IBOutlet weak var orderIDLbl: UILabel!
    
    @IBOutlet weak var dateTimeLbl: UILabel!
    
    @IBOutlet weak var productCountLbl: UILabel!
    
    @IBOutlet weak var orderPriceLbl: UILabel!
    
    @IBOutlet weak var doorDeliveryLbl: UILabel!
    
    @IBOutlet weak var accountIDLbl: UILabel!
    
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var declineBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // UIView Card View in Ios Swift4:
             cardView.backgroundColor = .white
             cardView.layer.cornerRadius = 5
             cardView.layer.shadowColor = UIColor.lightText.cgColor
             cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
             cardView.layer.shadowRadius = 6.0
             cardView.layer.shadowOpacity = 0.7
        
        //accept Button:
        acceptBtn.layer.cornerRadius = 5
        acceptBtn.layer.borderWidth = 1
        acceptBtn.layer.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        
        //accept Button:
        declineBtn.layer.cornerRadius = 5
        declineBtn.layer.borderWidth = 1
        declineBtn.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
 
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
