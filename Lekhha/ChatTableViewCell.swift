//
//  ChatTableViewCell.swift
//  Lekhha
//
//  Created by USM on 19/06/21.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chatTxtLbl.layer.cornerRadius = 5
        chatTxtLbl.clipsToBounds = true
    }
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    @IBOutlet weak var labelWidth: NSLayoutConstraint!
    @IBOutlet weak var chatContentView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var chatProfileImg: UIImageView!
    @IBOutlet weak var chatTxtLbl: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

