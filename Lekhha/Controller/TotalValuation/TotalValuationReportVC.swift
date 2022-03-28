//
//  TotalValuationReportVC.swift
//  LekhaApp
//
//  Created by apple on 11/24/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

class TotalValuationReportVC: UIViewController {
    
    @IBOutlet weak var headerTitleLbl: UILabel!
    
    var headerTitleStr = ""
    var valuationReportArray = NSArray()
    var valuationDict = NSDictionary()
    
    @IBOutlet weak var totalValuationTV_Prog: UITableView!
    
    @IBOutlet weak var valuationProductLbl: UILabel!
    
    @IBOutlet weak var productCountLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalValuationTV_Prog.delegate = self
        totalValuationTV_Prog.dataSource = self
        let nibName2 = UINib(nibName: "TotalvaluationTV_Cell", bundle: nil)
        totalValuationTV_Prog.register(nibName2, forCellReuseIdentifier: "TotalvaluationTV_Cell")
        totalValuationTV_Prog.reloadData()
        
        let prodCount = valuationDict.value(forKey: "TotalQuantity") as? Int
        
        valuationProductLbl.text = "₹ \(valuationDict.value(forKey: "TotalAmount") as? String ?? "")"
        productCountLbl.text = String(prodCount ?? 0)
        
        headerTitleLbl.text = headerTitleStr

        
    }
    
    
    @IBAction func onTapped_BackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: false, completion: nil)
    }
    
}

extension TotalValuationReportVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valuationReportArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TotalvaluationTV_Cell = totalValuationTV_Prog.dequeueReusableCell(withIdentifier: "TotalvaluationTV_Cell", for: indexPath) as! TotalvaluationTV_Cell
        
        if(valuationReportArray.count > 0){
            
            let dataDict = valuationReportArray[indexPath.row] as! NSDictionary
            let orderListArr = dataDict.value(forKey: "ordersList") as! NSArray
            
            let orderListDict = orderListArr[0] as? NSDictionary
            let prodDetailsDict = orderListDict?.value(forKey: "productdetails") as? NSDictionary
            
            cell.orderIDLbl.text = prodDetailsDict?.value(forKey: "productName") as? String
            cell.dateTimeLbl.text = dataDict.value(forKey: "createdDate") as? String
            
            let stockQuan = orderListDict?.value(forKey: "updatingQuantity") as! Int
            cell.productCountLbl.text = String(stockQuan)
            
            let price = prodDetailsDict?.value(forKey: "price") as? Float
            cell.orderPriceLbl.text = String(price ?? 0.0)
            
            cell.doorDeliveryLbl.text = prodDetailsDict?.value(forKey: "borrowed") as? String
            cell.accountIDLbl.text = dataDict.value(forKey: "accountId") as? String
            cell.locationLbl.text = prodDetailsDict?.value(forKey: "storageLocation") as? String
            
            //            cell.orderIDLbl.text =
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}


