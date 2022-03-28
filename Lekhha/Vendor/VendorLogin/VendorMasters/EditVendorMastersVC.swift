//
//  EditVendorMastersVC.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import UIKit
import DropDown

class EditVendorMastersVC: UIViewController {

    @IBOutlet var vendorWarn: UIButton!
    @IBOutlet weak var vendorNameTF: UITextField!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var subcategoryView: UIView!
    @IBOutlet weak var subcategoryTF: UITextField!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyNameTF: UITextField!
    @IBOutlet weak var gstView: UIView!
    @IBOutlet weak var gstTF: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    var vendorWarnN=Bool()
    let dropDown = DropDown() //2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryView.layer.borderColor = UIColor.gray.cgColor
        categoryView.layer.borderWidth = 0.5
        categoryView.layer.cornerRadius = 3
        categoryView.clipsToBounds = true
        
        subcategoryView.layer.borderColor = UIColor.gray.cgColor
        subcategoryView.layer.borderWidth = 0.5
        subcategoryView.layer.cornerRadius = 3
        subcategoryView.clipsToBounds = true
        
        descriptionView.layer.borderColor = UIColor.gray.cgColor
        descriptionView.layer.borderWidth = 0.5
        descriptionView.layer.cornerRadius = 3
        descriptionView.clipsToBounds = true
        
        companyView.layer.borderColor = UIColor.gray.cgColor
        companyView.layer.borderWidth = 0.5
        companyView.layer.cornerRadius = 3
        companyView.clipsToBounds = true
        
        gstView.layer.borderColor = UIColor.gray.cgColor
        gstView.layer.borderWidth = 0.5
        gstView.layer.cornerRadius = 3
        gstView.clipsToBounds = true
        
        locationView.layer.borderColor = UIColor.gray.cgColor
        locationView.layer.borderWidth = 0.5
        locationView.layer.cornerRadius = 3
        locationView.clipsToBounds = true
        
        addressView.layer.borderColor = UIColor.gray.cgColor
        addressView.layer.borderWidth = 0.5
        addressView.layer.cornerRadius = 3
        addressView.clipsToBounds = true
        
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 5.0
        bgView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        bgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        bgView.layer.shadowRadius = 6.0
        bgView.layer.shadowOpacity = 0.7

        self.vendorWarn.isHidden=true
        self.vendorWarn.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc func onClickWarnButton()
    {
        self.showAlertWith(title: "Alert", message: "Required")
    }
    // Alert controller
    func showAlertWith(title:String,message:String)
        {
            let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
            //to change font of title and message.
            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
            alertController.setValue(titleAttrString, forKey: "attributedTitle")
            alertController.setValue(messageAttrString, forKey: "attributedMessage")
            
        let cancelAction = UIAlertAction(title: "NO", style: .default, handler: { (action) in
           
        })
            let alertAction = UIAlertAction(title: "YES", style: .default, handler: { (action) in
               
            })
        
    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
        alertController.addAction(cancelAction)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        if vendorNameTF.text == "" {
            
            self.vendorWarnN=true
            self.vendorWarn.isHidden=false
        }
        else
        {
            self.vendorWarnN=false
            self.vendorWarn.isHidden=true
        }
        
        if self.vendorWarnN==true
        {
            
        }
        else
        {
//        post_StockUnitMaster_API_Call()
        }
    }
    
    @IBAction func subcategoryBtnAction(_ sender: UIButton) {
        
        dropDown.dataSource = ["Level 1","Level 2","Level 3"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.subcategoryTF.text = item
            }
    }
    
    @IBAction func categoryBtnAction(_ sender: UIButton) {
        
        dropDown.dataSource = ["Level 1","Level 2","Level 3"]//4
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
                self?.categoryTF.text = item
            }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
