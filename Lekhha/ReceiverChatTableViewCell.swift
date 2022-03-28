//
//  ReceiverChatTableViewCell.swift
//  Lekhha
//
//  Created by USM on 14/07/21.
//

import UIKit

class ReceiverChatTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chatMsgLbl.layer.cornerRadius = 5
        chatMsgLbl.clipsToBounds = true
        
    }
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    @IBOutlet weak var labelWidth: NSLayoutConstraint!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var chatContentView: UIView!
    @IBOutlet weak var chatProfileImg: UIImageView!
    @IBOutlet weak var chatMsgLbl: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        

        // Configure the view for the selected state
    }
    
}

