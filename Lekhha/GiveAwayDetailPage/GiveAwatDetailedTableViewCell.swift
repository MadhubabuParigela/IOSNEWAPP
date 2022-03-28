//
//  GiveAwatDetailedTableViewCell.swift
//  Lekhha
//
//  Created by USM on 25/05/21.
//

import UIKit
import GoogleMaps

class GiveAwatDetailedTableViewCell: UITableViewCell {

    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var accIdLbl: UILabel!
    @IBOutlet weak var offerPriceByTheBidderLbl: UILabel!
    @IBOutlet weak var reqQtyLbl: UILabel!
    
    @IBOutlet var accountNameL: UILabel!
    @IBOutlet var bidPriceL: UILabel!
    @IBOutlet weak var mapBackView: UIView!
    @IBOutlet weak var gmsMapView: GMSMapView!
    @IBOutlet weak var acceptDeclineLbl: UILabel!
    
    @IBOutlet var chatMainUIVHeight: NSLayoutConstraint!
    @IBOutlet var chatTF: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var textView: UIView!
    @IBOutlet var chatView: UIView!
    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var chatMainUIView: UIView!
    @IBOutlet var expandButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    
}
