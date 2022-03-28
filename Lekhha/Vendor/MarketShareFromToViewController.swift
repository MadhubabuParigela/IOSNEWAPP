//
//  MarketShareFromToViewController.swift
//  Lekhha
//
//  Created by USM on 15/06/21.
//

import UIKit

class MarketShareFromToViewController: UIViewController {

    @IBOutlet weak var totalMarketShareTxtLbl: UILabel!
    @IBOutlet weak var marketShareFirstTxtLbl: UILabel!
    
    var totalValue = Int()
    var marketShareValue = Double()
    
    @IBAction func homeBtnTap(_ sender: Any) {
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalMarketShareTxtLbl.text = "\(totalValue)"
        marketShareFirstTxtLbl.text = "\(marketShareValue)"

        // Do any additional setup after loading the view.
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
