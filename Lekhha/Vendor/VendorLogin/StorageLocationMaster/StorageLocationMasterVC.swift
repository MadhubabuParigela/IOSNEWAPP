//
//  StorageLocationMasterVC.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import UIKit
import ObjectMapper

class StorageLocationMasterVC: UIViewController, StorageLocationMasterBtnCellDelegate {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var storageLocationTV: UITableView!
    
    var accountID = ""
    var serviceVC = ServiceController()
    var storageLocationArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageLocationTV.dataSource = self
        storageLocationTV.delegate = self
        storageLocationTV.separatorStyle = .none
        let nibName1 = UINib(nibName: "StorageLocationMasterTVCell", bundle: nil)
        storageLocationTV.register(nibName1, forCellReuseIdentifier: "StorageLocationMasterTVCell")
        // Do any additional setup after loading the view.
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        get_StorageLocationMaster_API_Call()
    }
    
    // MARK: Get AddressBook API Call
    func get_StorageLocationMaster_API_Call() {
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let urlStr = Constants.BaseUrl + vendorGetStorageLocationUrl + accountID
        
        serviceVC.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:GetStorageLocationMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
            print(result)
            DispatchQueue.main.async {
                
                let status = respVo.STATUS_CODE
                let message = respVo.STATUS_MSG
                self.storageLocationArr=NSMutableArray()
                
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                if status == 200 {
                    if message == "SUCCESS" {
                        let ss=respVo.result?.compactMap{ $0 }
                        if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            let resultObj:[String:Any]=result as? [String:Any] ?? [String:Any]()
                            let resultArr:NSMutableArray=resultObj["result"]as? NSMutableArray ?? NSMutableArray()
                            self.storageLocationArr = resultArr
                            self.storageLocationTV.reloadData()
                            
                        }
                        else {
                            
                        }
                    }
                        else
                        {
                           let resultObj:[String:Any]=result as? [String:Any] ?? [String:Any]()
                           let resultArr:NSMutableArray=resultObj["result"]as? NSMutableArray ?? NSMutableArray()
                            resultArr.compactMap{ $0 }
                            for i in 0..<resultArr.count
                            {
                                if let aaaaa=resultArr[i] as? NSDictionary
                                {
                                    let aaaa=resultArr[i] as! NSDictionary
                                self.storageLocationArr.add(aaaa)
                                }
                            }
                            self.storageLocationTV.reloadData()
                        }
                    }
                }
                else {
                    activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
//                    self.view.makeToast(message)
                }
            }
        }) { (error) in
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
//            self.view.makeToast("app.SomethingWentToWrongAlert".localize())
            print("Oops, your connection seems off... Please try again later")
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Vendor", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddStorageLocationMasterVC") as! AddStorageLocationMasterVC
        self.navigationController!.pushViewController(vc, animated: true)
    }

}
// MARK: UITableView Methods
extension StorageLocationMasterVC:UITableViewDataSource,UITableViewDelegate {

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return storageLocationArr.count
    }
    //    cell For Row At indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = storageLocationTV.dequeueReusableCell(withIdentifier: "StorageLocationMasterTVCell", for: indexPath) as! StorageLocationMasterTVCell
        
        cell.cellDelegate = self
        cell.naEditBtn.tag = indexPath.row
        
        if storageLocationArr.count > 0 {
            
            let obj = storageLocationArr[indexPath.row] as? NSDictionary
            cell.naLabel.text = obj?.value(forKey: "slocName")as? String
            cell.storageLocationLabel.text = obj?.value(forKey: "slocName")as? String
            cell.parentLocationLabel.text = obj?.value(forKey: "parentLocation")as? String
            cell.descriptionLabel.text = obj?.value(forKey: "slocDescription")as? String
            cell.hierachyLevelLabel.text = "Level\(obj?.value(forKey: "hierachyLevel")as? Int ?? 0)"
            
            if obj?.value(forKey: "slocName")as? String == "NA" {
                cell.naEditBtn.isHidden = true
                cell.naEditImg.isHidden = true
            }
            else {
                cell.naEditBtn.isHidden = false
                cell.naEditImg.isHidden = false
            }
            if obj?.value(forKey: "isDefault")as? Bool == true {
                cell.defaultStorageLocationLabel.text = "Yes"
                cell.defaultLabel.text = "Default storage location"
            }
            else {
                cell.defaultStorageLocationLabel.text = ""
                cell.defaultLabel.text = ""
            }
        }
        return cell
    }
    //    did Press Button
    func didPressButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
        
        let index = NSIndexPath(row: tag, section: 0)
        let obj = storageLocationArr[index.row] as? NSDictionary
        let storyboard = UIStoryboard(name: "Vendor", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditStorageLocationMasterVC") as! EditStorageLocationMasterVC
        vc.stockNameStr = obj?.value(forKey: "slocName")as? String ?? ""
        vc.descriptionStr = obj?.value(forKey: "slocDescription")as? String ?? ""
        vc.idStr = obj?.value(forKey: "_id")as? String ?? ""
        vc.hierachyStr = obj?.value(forKey: "hierachyLevel")as? Int ?? 0
        vc.isDefaultValue = obj?.value(forKey: "isDefault")as? Bool ?? false
        vc.parentLocationStr = obj?.value(forKey: "parentLocation")as? String ?? ""
        self.navigationController!.pushViewController(vc, animated: true)
    }
    //    height For Row At indexPath
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 250
    }
    //    did Select Row At indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if UIDevice.current.userInterfaceIdiom == .phone {
           print("running on iPhone")

        }
    }
}
