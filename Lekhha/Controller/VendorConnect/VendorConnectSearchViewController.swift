//
//  VendorConnectSearchViewController.swift
//  Lekhha
//
//  Created by apple on 10/11/21.
//

import UIKit
import ObjectMapper

class VendorConnectSearchViewController: UIViewController {

    var vendorConnectResult = NSMutableArray()
    var servCntrl = ServiceController()
    @IBAction func onClickBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet var backButton: UIButton!
    @IBOutlet var productIdTF: UITextField!
    @IBOutlet var productNameTF: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBAction func onClickSearchButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VendorConnectVC") as! VendorConnectVC
        vc.accountNameTF=self.accountIdTF.text ?? ""
        vc.productIDTF=self.productIdTF.text ?? ""
        vc.productNameTF=self.productNameTF.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet var accountIdTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
