//
//  AddVendorMastersVC.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import UIKit

class AddVendorMastersVC: UIViewController,AddVendorMasterBtnCellDelegate {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var addTableView: UITableView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var tableArr = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableView.dataSource = self
        addTableView.delegate = self
        addTableView.separatorStyle = .none
        let nibName1 = UINib(nibName: "AddVendorMastersTVCell", bundle: nil)
        addTableView.register(nibName1, forCellReuseIdentifier: "AddVendorMastersTVCell")
        
        // Do any additional setup after loading the view.
    }
    @IBAction func addBtnAction(_ sender: Any) {
        
        tableArr.append(1)
        addTableView.reloadData()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveBtnAction(_ sender: Any) {
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
// MARK: UITableView Methods
extension AddVendorMastersVC:UITableViewDataSource,UITableViewDelegate {

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableArr.count > 0 {
            return tableArr.count
        }
        else {
            return 1
        }
    }
    //    cell For Row At indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = addTableView.dequeueReusableCell(withIdentifier: "AddVendorMastersTVCell", for: indexPath) as! AddVendorMastersTVCell
        
        cell.cellDelegate = self
        cell.deleteBtn.tag = indexPath.row
//        cell.hierachyBtn.tag = indexPath.row
        
        return cell
    }
    //    did Press Button
    func didPressButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
        if tableArr.count > 0 {
            tableArr.remove(at: tag)
            addTableView.reloadData()
        }
    }
    func didPressCategoryButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
    }
    
    func didPressSubCategoryButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
    }
    //    height For Row At indexPath
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 500
    }
    //    did Select Row At indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if UIDevice.current.userInterfaceIdiom == .phone {
           print("running on iPhone")

        }
    }
}
