//
//  TotalValuationGeneratedReportViewController.swift
//  LekhaLatest
//
//  Created by USM on 11/02/21.
//

import UIKit

class TotalValuationGeneratedReportViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var headerTitleLbl: UILabel!
    var headerTitleStr = ""
    
    var accountID = String()
    var reportsArray = NSArray()
    var valuationDataDict = NSDictionary()
    var fromDateStr = ""
    var toDateStr = ""

    @IBOutlet weak var valuationTblView: UITableView!
    
    @IBOutlet weak var valuationCountLbl: UILabel!
    @IBOutlet weak var prodCountLbl: UILabel!
    
    @IBOutlet weak var fromToDateLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        valuationTblView.register(UINib(nibName: "PeriodGeneratedTableViewCell", bundle: nil), forCellReuseIdentifier: "PeriodGeneratedTableViewCell")

        valuationTblView.delegate = self
        valuationTblView.dataSource = self
        
        valuationTblView.reloadData()
        
        let prodCount = valuationDataDict.value(forKey: "TotalQuantity") as! Int
        
        fromToDateLbl.text = fromDateStr + " To " + toDateStr
        valuationCountLbl.text = "₹ \(valuationDataDict.value(forKey: "TotalAmount") as? String ?? "")"
        prodCountLbl.text = String(prodCount)
        
        headerTitleLbl.text = headerTitleStr
        
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

    @IBAction func backBtnTapped(_ sender: Any) {
//        self.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }
    
    // MARK: - UITableViewDataSource

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return reportsArray.count
            
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40

    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeriodGeneratedTableViewCell", for: indexPath) as! PeriodGeneratedTableViewCell
      
        if(reportsArray.count > 0){
            
            let dataDict = reportsArray[indexPath.row] as! NSDictionary
            
            cell.weekNameLbl.text = dataDict.value(forKey: "number") as? String
            
//            let totalAmnt = dataDict.value(forKey: "TotalAmount") as! Int
            cell.totalValLbl.text = "₹ \((dataDict.value(forKey: "TotalAmount") as? String)!)"
            
            let quan = dataDict.value(forKey: "TotalQuantity") as! Int
            cell.prodCountLbl.text = String(quan)
            
        }
        
        return cell
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
