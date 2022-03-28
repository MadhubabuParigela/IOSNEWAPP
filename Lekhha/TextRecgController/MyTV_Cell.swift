//
//  MyTV_Cell.swift
//  TextRecognizProg
//
//  Created by apple on 1/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class MyTV_Cell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var myLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    var myArrLbl = UILabel()
    
    var myImgProg = UIImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = 10
        cardView.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.9058823529, blue: 0.9176470588, alpha: 1)
        cardView.layer.borderWidth = 2
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    


    }

