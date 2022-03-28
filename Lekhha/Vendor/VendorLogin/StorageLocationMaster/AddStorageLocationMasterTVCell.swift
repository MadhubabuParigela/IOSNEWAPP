//
//  AddStorageLocationMasterTVCell.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import UIKit
import DropDown
import ObjectMapper

//Stock Btn Cell Delegate
protocol AddStorageLocationMasterBtnCellDelegate : class {
    func didPressButton(_ tag: Int)
    func didPressHierachyButton(_ tag: Int)
    func didPressHierachytext(_ tag: Int,sender:String)
    func didPressParenttext(_ tag: Int,sender:String)
}
class AddStorageLocationMasterTVCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var storageLocationNameView: UIView!
    @IBOutlet var warnDescriptionbtn: UIButton!
    @IBOutlet weak var storageLocationNameTF: UITextField!
    @IBOutlet var warnNamebtn: UIButton!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var hierachyView: UIView!
    @IBOutlet weak var hierachyTF: UITextField!
    @IBOutlet weak var hierachyBtn: UIButton!
    @IBOutlet weak var parentLocationView: UIView!
    @IBOutlet weak var parentLocationTF: UITextField!
    @IBOutlet weak var parentBgView: UIView!
    @IBOutlet weak var parentHeightConstant: NSLayoutConstraint!
    
    var cellDelegate: AddStorageLocationMasterBtnCellDelegate?
    
    let dropDown = DropDown() //2
    var selectedId = 0
    
    var accountID = ""
    var storageLocationArr = NSMutableArray()
    var serviceVC = ServiceController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.parentBgView.isHidden = true
        self.parentHeightConstant.constant = 0
        
        storageLocationNameView.layer.borderColor = UIColor.gray.cgColor
        storageLocationNameView.layer.borderWidth = 0.5
        storageLocationNameView.layer.cornerRadius = 3
        storageLocationNameView.clipsToBounds = true
        
        descriptionView.layer.borderColor = UIColor.gray.cgColor
        descriptionView.layer.borderWidth = 0.5
        descriptionView.layer.cornerRadius = 3
        descriptionView.clipsToBounds = true
        
        hierachyView.layer.borderColor = UIColor.gray.cgColor
        hierachyView.layer.borderWidth = 0.5
        hierachyView.layer.cornerRadius = 3
        hierachyView.clipsToBounds = true
        
        parentLocationView.layer.borderColor = UIColor.gray.cgColor
        parentLocationView.layer.borderWidth = 0.5
        parentLocationView.layer.cornerRadius = 3
        parentLocationView.clipsToBounds = true
        
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 5.0
        bgView.layer.shadowColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        bgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        bgView.layer.shadowRadius = 6.0
        bgView.layer.shadowOpacity = 0.7
        
        hierachyTF.text = "Level 1"
    }

    @IBOutlet var parentButton: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        
        cellDelegate?.didPressButton(sender.tag)
    }
    var tagVal=Int()
    @IBAction func hierachyBtnAction(_ sender: UIButton) {
        
        cellDelegate?.didPressHierachyButton(sender.tag)
        
        dropDown.dataSource = ["Level 1","Level 2","Level 3"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.selectedId = index
                self?.hierachyTF.text = item
                self?.cellDelegate?.didPressHierachytext(sender.tag, sender: item)
                if index == 0 {
                    self?.parentBgView.isHidden = true
                    self?.parentHeightConstant.constant = 0
                }
                else {
                    self?.get_StorageLocationMaster_API_Call()
                    self?.parentBgView.isHidden = false
                    self?.parentHeightConstant.constant = 60
                }
            }
    }
    
    @IBAction func parentLocationBtnAction(_ sender: UIButton) {
        
        var parentNameArr = [String]()
      
        for obj in self.storageLocationArr {
            let ddict=obj as? NSDictionary
            parentNameArr.append(ddict?.value(forKey: "slocName")as? String ?? "")
        }
        dropDown.dataSource = parentNameArr//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                
                self?.parentLocationTF.text = item
                self?.cellDelegate?.didPressParenttext(sender.tag, sender: item)
                
            }
    }
    
    // MARK: Get AddressBook API Call
    func get_StorageLocationMaster_API_Call() {
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let urlStr = Constants.BaseUrl + getAllStorageLocationByHierachyLevelUrl + "\(selectedId)/" + accountID
        
        serviceVC.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:GetStorageLocationMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            DispatchQueue.main.async {
                
                let status = respVo.STATUS_CODE
                let message = respVo.STATUS_MSG
                
                if status == 200 {
                    if message == "SUCCESS" {
                        if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            let resultObj:[String:Any]=result as? [String:Any] ?? [String:Any]()
                            let resultArr:NSMutableArray=resultObj["result"]as? NSMutableArray ?? NSMutableArray()
                            self.storageLocationArr = resultArr
                            for obj in self.storageLocationArr {
                                let ddict=obj as? NSDictionary
                                self.parentLocationTF.text = ddict?.value(forKey: "parentLocation")as? String ?? ""
                            }
                        }
                        else {
                            
                        }
                        }
                    }
                }
                else {
//                    self.view.makeToast(message)
                }
            }
        }) { (error) in
//            self.view.makeToast("app.SomethingWentToWrongAlert".localize())
            print("Oops, your connection seems off... Please try again later")
        }
    }
}
