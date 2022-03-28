//
//  VendorMastersVC.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import UIKit
import ObjectMapper

class VendorMastersVC: UIViewController, VendorMasterBtnCellDelegate {

    @IBOutlet weak var vendorMasterTV: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    
    var accountID = ""
    var serviceVC = ServiceController()
    var storageLocationArr = [GetStorageLocationMasterResultVo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vendorMasterTV.dataSource = self
        vendorMasterTV.delegate = self
        vendorMasterTV.separatorStyle = .none
        let nibName1 = UINib(nibName: "VendorMastersTVCell", bundle: nil)
        vendorMasterTV.register(nibName1, forCellReuseIdentifier: "VendorMastersTVCell")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Vendor", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddVendorMastersVC") as! AddVendorMastersVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    // MARK: Get AddressBook API Call
    func get_VendorMaster_API_Call() {
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let urlStr = Constants.BaseUrl + vendorGetUrl + accountID
        
        serviceVC.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:GetStorageLocationMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            DispatchQueue.main.async {
                
                let status = respVo.STATUS_CODE
                let message = respVo.STATUS_MSG
                
                if status == 200 {
                    if message == "SUCCESS" {
                        if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            
                            self.storageLocationArr = respVo.result!
                            self.vendorMasterTV.reloadData()
                            
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
// MARK: UITableView Methods
extension VendorMastersVC:UITableViewDataSource,UITableViewDelegate {

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    //    cell For Row At indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = vendorMasterTV.dequeueReusableCell(withIdentifier: "VendorMastersTVCell", for: indexPath) as! VendorMastersTVCell
        
        cell.cellDelegate = self
        cell.editBtn.tag = indexPath.row
        
        return cell
    }
    //    did Press Button
    func didPressButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
        let storyboard = UIStoryboard(name: "Vendor", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditVendorMastersVC") as! EditVendorMastersVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    //    height For Row At indexPath
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 360
    }
    //    did Select Row At indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if UIDevice.current.userInterfaceIdiom == .phone {
           print("running on iPhone")

        }
    }
}
