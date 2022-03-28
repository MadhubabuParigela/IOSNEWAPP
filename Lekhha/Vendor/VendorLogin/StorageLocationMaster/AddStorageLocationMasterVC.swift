//
//  AddStorageLocationMasterVC.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import UIKit
import DropDown
import ObjectMapper

class AddStorageLocationMasterVC: UIViewController,AddStorageLocationMasterBtnCellDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addTableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    
    var tableArr = [Int]()
    
    let dropDown = DropDown() //2
    
    var serviceVC = ServiceController()
    var storageLocationArray = NSMutableArray()
    var storageLocationMainArray = NSMutableArray()
    
    var accountID = ""
    
    var params = NSMutableDictionary()
    var isdefault:Bool = false
    var hierachyValue = Int()
    
    var stockNamesArr : [String] = [String]()
    var descriptionArr : [String] = [String]()
    var hierachyArr : [String] = [String]()
    var parentLocationArr : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableView.dataSource = self
        addTableView.delegate = self
        addTableView.separatorStyle = .none
        let nibName1 = UINib(nibName: "AddStorageLocationMasterTVCell", bundle: nil)
        addTableView.register(nibName1, forCellReuseIdentifier: "AddStorageLocationMasterTVCell")
        
        animatingView()
        // Do any additional setup after loading the view.
    }
    
    func animatingView(){
           
           self.view.addSubview(activity)
                         
           activity.translatesAutoresizingMaskIntoConstraints = false
           let horizontalConstraint = activity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
           let verticalConstraint = activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
           let widthConstraint = activity.widthAnchor.constraint(equalToConstant: 50)
           let heightConstraint = activity.heightAnchor.constraint(equalToConstant: 50)
           view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
           
       }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addStorageBtnAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        tableArr.append(1)
        params = [
        "accountId":accountID,
            "slocDescription": "",
            "warnDescription":false,
            "slocName": "",
            "warnName":false,
            "hierachyLevel": "Level 1",
        "parentLocation":""
        ]
        storageLocationMainArray.add(params)
        addTableView.reloadData()
    }
    var warningDesArr=[Bool]()
    var warningStockArr=[Bool]()
    @IBAction func saveBtnAction(_ sender: Any) {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        self.view.endEditing(true)
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        warningDesArr=[Bool]()
        warningStockArr=[Bool]()
        for i in 0..<storageLocationMainArray.count {
           let dictt=storageLocationMainArray[i]as? NSDictionary
            let storageName = dictt?.value(forKey: "slocName")as? String ?? ""
            
            if storageName == "" {
                stockNamesArr.removeAll()
                descriptionArr.removeAll()
                hierachyArr.removeAll()
                parentLocationArr.removeAll()
                dictt?.setValue(true, forKey: "warnName")
                warningStockArr.append(true)
            }
            else {
                stockNamesArr.append(storageName)
                dictt?.setValue(false, forKey: "warnName")
                warningStockArr.append(false)
            }
            let storageDescrp = dictt?.value(forKey: "slocDescription")as? String ?? ""
            
            if storageDescrp == "" {
                stockNamesArr.removeAll()
                descriptionArr.removeAll()
                hierachyArr.removeAll()
                parentLocationArr.removeAll()
                dictt?.setValue(true, forKey: "warnDescription")
                warningDesArr.append(true)
            }
            else {
                dictt?.setValue(false, forKey: "warnDescription")
                descriptionArr.append(storageDescrp)
                warningDesArr.append(false)
            }
            
            let hierachyStr = dictt?.value(forKey: "hierachyLevel")as? String ?? ""
            
            if hierachyStr == "" {
                stockNamesArr.removeAll()
                descriptionArr.removeAll()
                hierachyArr.removeAll()
                parentLocationArr.removeAll()
            }
            else {
                hierachyArr.append(hierachyStr)
            }
            
            let parentLocStr = dictt?.value(forKey: "parentLocation")as? String ?? ""
            if parentLocStr == "" {
//                self.view.makeToast("Please enter parent location")
//                stockNamesArr.removeAll()
//                descriptionArr.removeAll()
//                hierachyArr.removeAll()
//                parentLocationArr.removeAll()
//                return
                parentLocationArr.append("")
            }
            else {
                parentLocationArr.append(parentLocStr)
            }
        }
        print(stockNamesArr)
        if warningStockArr.contains(true) || warningDesArr.contains(true)
        {
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.addTableView.reloadData()
        }
        else
        {
            activity.startAnimating()
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.post_StockUnitMaster_API_Call()
            })
        }
    }
    // MARK: Add Experience Info API Call
    func post_StockUnitMaster_API_Call() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        for index in 0..<storageLocationMainArray.count
        {

            let dictttt=storageLocationMainArray[index]as? NSDictionary
            let storrageNam = dictttt?.value(forKey: "slocName")as? String ?? ""
            let descripe = dictttt?.value(forKey: "slocDescription")as? String ?? ""
            let hierchyStrr = dictttt?.value(forKey: "hierachyLevel")as? String ?? ""
            let parentStrr = dictttt?.value(forKey: "parentLocation")as? String ?? ""
            
            let lastVal = hierchyStrr.suffix(1)
            let str:String = "\(String(describing: lastVal))"
            let val:Int = Int(str)!
            
            params = [
            "accountId":accountID,
                "slocDescription": descripe,
                "slocName": storrageNam,
                "hierachyLevel": val,
            "parentLocation":parentStrr
            ]
            storageLocationArray.add(params)
        }
             
        print(params)
        var urlStr = ""

            urlStr = Constants.BaseUrl + vendorAddStoragekUnitUrl
            
            let postHeaders_IndividualLogin = ["":""]
            
            serviceVC.requestPOSTURLWithArray(strURL: urlStr as NSString, postParams: storageLocationArray as NSArray, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                
                let respVo:AddStockUnitMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
                
                let status = respVo.STATUS_CODE
                let statusMessage = respVo.STATUS_MSG
                let message = respVo.message
                
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                if status == 200 {
                    
                    if statusMessage == "SUCCESS" {
                        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                            self.navigationController?.popViewController(animated: true)
                                                       
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                else {
                    self.view.makeToast(message)
                }
            }) { (error) in
                
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                print("Something Went To Wrong...PLrease Try Again Later")
//                self.view.makeToast("app.SomethingWentToWrongAlert".localize())
            }
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableArr.count > 0 {
            return tableArr.count
        }
        else {
            tableArr.append(1)
            params = [
            "accountId":accountID,
                "slocDescription": "",
                "warnDescription":false,
                "slocName": "",
                "warnName":false,
                "hierachyLevel": "Level 1",
            "parentLocation":""
            ]
            storageLocationMainArray.add(params)
            return 1
        }
    }
    //    cell For Row At indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = addTableView.dequeueReusableCell(withIdentifier: "AddStorageLocationMasterTVCell", for: indexPath) as! AddStorageLocationMasterTVCell

        cell.cellDelegate = self
        cell.deleteBtn.tag = indexPath.row
        cell.hierachyBtn.tag = indexPath.row
        cell.parentButton.tag = indexPath.row
        let dict=storageLocationMainArray[indexPath.row]as? NSDictionary
        cell.descriptionTextView.text=dict?.value(forKey: "slocDescription")as? String ?? ""
        cell.storageLocationNameTF.text=dict?.value(forKey: "slocName")as? String ?? ""
        cell.parentLocationTF.text=dict?.value(forKey: "parentLocation")as? String ?? ""
        cell.hierachyTF.text=dict?.value(forKey: "hierachyLevel")as? String ?? ""
        cell.storageLocationNameTF.tag=Int("1000" + String(indexPath.row)) ?? 0
        cell.descriptionTextView.tag=Int("1001" + String(indexPath.row)) ?? 0
        cell.parentLocationTF.tag=Int("1002" + String(indexPath.row)) ?? 0
        cell.hierachyTF.tag=Int("1003" + String(indexPath.row)) ?? 0
        cell.descriptionTextView.delegate = self
        cell.storageLocationNameTF.delegate = self
        cell.hierachyTF.delegate = self
        cell.parentLocationTF.delegate = self
        if dict?.value(forKey: "hierachyLevel")as? String=="Level 1"
        {
            cell.parentHeightConstant.constant=0
            cell.parentBgView.isHidden = true
        }
        else
        {
            cell.parentHeightConstant.constant=60
            cell.parentBgView.isHidden = false
        }
        if dict?.value(forKey: "warnName")as? Bool==true
        {
            cell.warnNamebtn.isHidden=false
        }
        else
        {
            cell.warnNamebtn.isHidden=true
        }
        if dict?.value(forKey: "warnDescription")as? Bool==true
        {
            cell.warnDescriptionbtn.isHidden=false
        }
        else
        {
            cell.warnDescriptionbtn.isHidden=true
        }
        self.animatingView()
        return cell
    }
    //    did Press Button
    func didPressButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
        if tableArr.count > 0 {
            tableArr.remove(at: tag)
            storageLocationMainArray.removeObject(at: tag)
            addTableView.reloadData()
        }
    }
    //    did Press Button
    func didPressHierachyButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
                
    }
    func didPressParenttext(_ tag: Int, sender: String) {
        print("I have pressed a button with a tag: \(tag)")
        var dict = NSMutableDictionary()
        dict = storageLocationMainArray[tag] as! NSMutableDictionary
        dict.setValue(sender, forKey: "parentLocation")
        storageLocationMainArray.replaceObject(at: tag, with: dict)
    }
    func didPressHierachytext(_ tag: Int, sender: String) {
        print("I have pressed a button with a tag: \(tag)")
        var dict = NSMutableDictionary()
        dict = storageLocationMainArray[tag] as! NSMutableDictionary
        dict.setValue(sender, forKey: "hierachyLevel")
        storageLocationMainArray.replaceObject(at: tag, with: dict)
    }
    //    height For Row At indexPath
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 380
    }
    //    did Select Row At indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if UIDevice.current.userInterfaceIdiom == .phone {
           print("running on iPhone")

        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    print("TextField did end editing method called")
        var productTagValue = Int()
        
        var productArrayPosition = Int()
        let sstag:String = String(textField.tag)
        if sstag.count>5
        {
       productArrayPosition = textField.tag%100
        productTagValue = textField.tag / 100;
          
        }
        else
        {
        productArrayPosition = textField.tag%10
        productTagValue = textField.tag / 10;
        
        }
        var dict = NSMutableDictionary()
        dict = storageLocationMainArray[productArrayPosition] as! NSMutableDictionary

        print(productArrayPosition)
        print(productTagValue)
        
        if productTagValue == 1000{
            dict.setValue(textField.text, forKey: "slocName")
            if textField.text==""
            {
            }
            else
            {
                if dict.value(forKey: "warnName") as? Bool==true
                {
                    dict.setValue(false, forKey: "warnName")
                }
              
            }
            storageLocationMainArray.replaceObject(at: productArrayPosition, with: dict)
        }
        if productTagValue == 1002{
            dict.setValue(textField.text, forKey: "parentLocation")
            
            storageLocationMainArray.replaceObject(at: productArrayPosition, with: dict)
        }
        if productTagValue == 1003{
            dict.setValue(textField.text, forKey: "hierachyLevel")
           
            storageLocationMainArray.replaceObject(at: productArrayPosition, with: dict)
        }
        
        self.addTableView.reloadData()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {

    textField.resignFirstResponder();
    return true;
    }
   
    func textViewDidEndEditing(_ textView: UITextView) {
        var productTagValue = Int()
        
        var productArrayPosition = Int()
        let sstag:String = String(textView.tag)
        if sstag.count>5
        {
       productArrayPosition = textView.tag%100
        productTagValue = textView.tag / 100;
          
        }
        else
        {
        productArrayPosition = textView.tag%10
        productTagValue = textView.tag / 10;
        
        }
        var dict = NSMutableDictionary()
        dict = storageLocationMainArray[productArrayPosition] as! NSMutableDictionary

        print(productArrayPosition)
        print(productTagValue)
        if productTagValue == 1001{
            dict.setValue(textView.text, forKey: "slocDescription")
            if textView.text==""
            {
            }
            else
            {
                if dict.value(forKey: "warnDescription") as? Bool==true
                {
                    dict.setValue(false, forKey: "warnDescription")
                }
              
            }
            storageLocationMainArray.replaceObject(at: productArrayPosition, with: dict)
            self.addTableView.reloadData()
        }
        
    }
}
