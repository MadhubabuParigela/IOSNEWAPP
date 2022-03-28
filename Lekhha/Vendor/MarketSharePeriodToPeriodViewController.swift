//
//  MarketSharePeriodToPeriodViewController.swift
//  Lekhha
//
//  Created by USM on 15/06/21.
//

import UIKit

class MarketSharePeriodToPeriodViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var marketShareResArr = NSMutableArray()

    @IBOutlet weak var datesWeeksTxtLbl: UILabel!
    @IBOutlet weak var marketShareTblView: UITableView!
    
    var fromDateStr = String()
    var toDateStr = String()
    
    @IBAction func homeBtnTap(_ sender: Any) {
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datesWeeksTxtLbl.text = fromDateStr + " To" + toDateStr
        
        marketShareTblView.delegate = self
        marketShareTblView.dataSource = self
        
        marketShareTblView.register(UINib(nibName: "MarketShareTableViewCell", bundle: nil), forCellReuseIdentifier: "MarketShareTableViewCell")
        marketShareTblView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marketShareResArr.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 45
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
           
        let cell = marketShareTblView.dequeueReusableCell(withIdentifier: "MarketShareTableViewCell", for: indexPath) as! MarketShareTableViewCell
          
          let dataDict = marketShareResArr.object(at: indexPath.row) as? NSDictionary
        cell.periodLbl.text = dataDict?.value(forKey: "number") as? String
        cell.totalValLbl.text = dataDict?.value(forKey: "TotalValue") as? String
        cell.shareValLbl.text = dataDict?.value(forKey: "marketSharevalue") as? String
        
//        cell.shareValLbl.text = "000"
        
          return cell
        
    }
}
