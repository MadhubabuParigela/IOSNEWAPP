//
//  VendorTV_Cell.swift
//  LekhaApp
//
//  Created by apple on 11/26/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import GoogleMaps

class VendorTV_Cell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var imgBackView: UIView!
    
    @IBOutlet weak var myCellImgView: UIImageView!
    
    @IBOutlet weak var vendorIDLbl: UILabel!
    
    @IBOutlet weak var penStandLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var expiryDateLbl: UILabel!
    
    @IBOutlet weak var catageoryNameLbl: UILabel!
    
    @IBOutlet weak var subCatageoryNameLbl: UILabel!
    
    @IBOutlet weak var offeredPriceLbl: UILabel!
    
    @IBOutlet weak var offeredQtyLbl: UILabel!
    
    @IBOutlet weak var addtoCartBtn: UIButton!
    
    @IBOutlet weak var mapBackView: UIView!
    @IBOutlet weak var myMapsView: GMSMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
                       // UIView Card View in Ios Swift4:
                        cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        cardView.layer.cornerRadius = 10.0
                        cardView.layer.shadowColor = UIColor.white.cgColor
                        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                        cardView.layer.shadowRadius = 6.0
                        cardView.layer.shadowOpacity = 0.7
                        cardView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        cardView.layer.borderWidth = 1
        
                   
                   // UIView Card View in Ios Swift4:
                   myCellImgView.backgroundColor = .white
                   myCellImgView.layer.cornerRadius = 10.0
                   myCellImgView.layer.shadowColor = UIColor.white.cgColor
                   myCellImgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                   myCellImgView.layer.shadowRadius = 6.0
                   myCellImgView.layer.shadowOpacity = 1
                   
                   //Button Rounded:
                   addtoCartBtn.layer.cornerRadius = 10
                   addtoCartBtn.clipsToBounds = true
                   addtoCartBtn.layer.borderWidth = 1
                   addtoCartBtn.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
           }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
