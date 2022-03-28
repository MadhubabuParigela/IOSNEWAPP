//
//  StockUnitMasterVC.swift
//  Lekhha
//
//  Created by USM on 04/11/21.
//

import UIKit
import ObjectMapper

class StockUnitMasterVC: UIViewController,StockUnitMasterBtnCellDelegate {

    @IBOutlet weak var stockUnitMasterTV: UITableView!
    @IBOutlet weak var headerTextLabel: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var serviceVC = ServiceController()
    
    var stockUnitsArr = [StockUnitMasterResultVo]()
    
    var accountID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stockUnitMasterTV.dataSource = self
        stockUnitMasterTV.delegate = self
        stockUnitMasterTV.separatorStyle = .none
        let nibName1 = UINib(nibName: "StockUnitMasterTVCell", bundle: nil)
        stockUnitMasterTV.register(nibName1, forCellReuseIdentifier: "StockUnitMasterTVCell")
        
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
        
        get_StockUnitMaster_API_Call()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func addBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Vendor", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddStockUnitMasterVC") as! AddStockUnitMasterVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    // MARK: Get AddressBook API Call
    func get_StockUnitMaster_API_Call() {
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        let urlStr = Constants.BaseUrl + vendorGetAllStockUnitUrl + accountID
        
        serviceVC.requestGETURL(strURL: urlStr, success: {(result) in
            
            let respVo:StockUnitMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            DispatchQueue.main.async {
                
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                let status = respVo.STATUS_CODE
                let message = respVo.STATUS_MSG
                
                if status == 200 {
                    if message == "SUCCESS" {
                        if respVo.result != nil {
                        if respVo.result!.count > 0 {
                            
                            self.stockUnitsArr = respVo.result!
                            self.stockUnitMasterTV.reloadData()
                            
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
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
//            self.view.makeToast("app.SomethingWentToWrongAlert".localize())
            print("Oops, your connection seems off... Please try again later")
        }
    }
    
}
// MARK: UITableView Methods
extension StockUnitMasterVC:UITableViewDataSource,UITableViewDelegate {

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return stockUnitsArr.count
    }
    //    cell For Row At indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:StockUnitMasterTVCell = stockUnitMasterTV.dequeueReusableCell(withIdentifier: "StockUnitMasterTVCell", for: indexPath) as! StockUnitMasterTVCell
        cell.cellDelegate = self
        cell.NAEditBtn.tag = indexPath.row
        if stockUnitsArr.count > 0 {
            let obj = stockUnitsArr[indexPath.row]
            cell.NALabel.text = obj.stockUnitName
            cell.stockUnitText.text = obj.stockUnitName
            cell.descriptionText.text = obj.stockUnitDescription
            
            if obj.stockUnitName == "NA" {
                cell.NAEditBtn.isHidden = true
                cell.NAEditImg.isHidden = true
            }
            else {
                cell.NAEditBtn.isHidden = false
                cell.NAEditImg.isHidden = false
            }
            if obj.isDefault == true {
                cell.defaultStockUnitText.text = "Yes"
                cell.defaultStockUnitLabel.text = "Default stock unit"
            }
            else {
                cell.defaultStockUnitText.text = ""
                cell.defaultStockUnitLabel.text = ""
            }
            
        }
        return cell
    }
    //    did Press Button
    func didPressButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
        
        let index = NSIndexPath(row: tag, section: 0)
        let obj = stockUnitsArr[index.row]
        
        let storyboard = UIStoryboard(name: "Vendor", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditStockUnitMastorVC") as! EditStockUnitMastorVC
        vc.stockNameStr = obj.stockUnitName ?? ""
        vc.descriptionStr = obj.stockUnitDescription ?? ""
        vc.idStr = obj._id ?? ""
        vc.isDefaultValue = obj.isDefault ?? false
        self.navigationController!.pushViewController(vc, animated: true)
    }
    //    height For Row At indexPath
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 180
    }
    //    did Select Row At indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if UIDevice.current.userInterfaceIdiom == .phone {
           print("running on iPhone")

        }
    }
}
