//
//  ChatCustomView.swift
//  Lekhha
//
//  Created by Swapna Nimma on 05/03/22.
//

import UIKit
class ChatCustomView: UIView {
    let nibName = "ChatCustomView"
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    @IBOutlet weak var labelWidth: NSLayoutConstraint!
    @IBOutlet weak var chatContentView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var chatProfileImg: UIImageView!
    @IBOutlet weak var chatTxtLbl: UILabel!
    
    
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
