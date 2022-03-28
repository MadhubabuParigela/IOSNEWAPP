//
//  ProductModifyViewController.swift
//  Lekhha
//
//  Created by USM on 26/07/21.
//

import UIKit
import ObjectMapper

class ProductModifyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var productID = ""
    var serCntrl = ServiceController()
    var prodModifyArray = NSMutableArray()
    var emptyMsgBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prodTblView.delegate = self
        prodTblView.dataSource = self
        
        prodTblView.register(UINib(nibName: "ProductModfitingTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductModfitingTableViewCell")

        getModifiedListAPI()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func homeBtnTapped(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBOutlet weak var prodTblView: UITableView!
    
    func showEmptyMsgBtn() {
        
        emptyMsgBtn.removeFromSuperview()
        
        emptyMsgBtn.frame = CGRect(x: self.view.frame.size.width/2-(70), y: self.view.frame.size.height/2-(70), width: 140, height: 160)
        emptyMsgBtn.setImage(UIImage.init(named: "no_data"), for: .normal)
        self.view.addSubview(emptyMsgBtn)

    }
    
    func getModifiedListAPI()  {

            activity.startAnimating()
            self.view.isUserInteractionEnabled = true

            let URLString_loginIndividual = Constants.BaseUrl + ModifiedProductHistoryUrl + productID
        
        serCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                                let respVo:EditInventoryRespo = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                _ = respVo.message
                                _ = respVo.statusCode
                
                let dataDict = result as! NSDictionary
                
                self.prodModifyArray = dataDict.value(forKey: "result") as! NSMutableArray
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                            
                                if status == "SUCCESS" {
                                    
                                    if(self.prodModifyArray.count)>0{
                                        self.emptyMsgBtn.removeFromSuperview()
                                        self.prodTblView.reloadData()
                                        
                                    }else{
                                        
                                        if(self.prodModifyArray.count == 0){
                                            self.showEmptyMsgBtn()
                                        }
                                    }
                                }
                                else {
                                    
                                }
            
            if(self.prodModifyArray.count == 0){
                self.showEmptyMsgBtn()
            }
                                
                            }) { (error) in
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                print("Something Went To Wrong...PLrease Try Again Later")
                            }
    }
    
    //****************** TableView Delegate Methods*************************//
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return prodModifyArray.count

     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = prodTblView.dequeueReusableCell(withIdentifier: "ProductModfitingTableViewCell", for: indexPath) as! ProductModfitingTableViewCell
        
        let prodDict = prodModifyArray[indexPath.row] as! NSDictionary

        let expiryDate = (prodDict.value(forKey: "modifiedDateTime"))!
        
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd                  HH:mm:ss"

        let convertedDate = dateFormatter.date(from: expiryDate as! String)
        
        if(convertedDate == nil){
            cell.dateLblField.text = ""
            
        }else{
            
            dateFormatter.dateFormat = "dd/MM/yyyy                  hh:mm:a"///this is what you want to convert format
//            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            let timeStamp = dateFormatter.string(from: convertedDate!)
            
            cell.dateLblField.text = timeStamp

        }
        cell.arrowButton.addTarget(self, action: #selector(redirecttoView), for: .touchUpInside)
        cell.arrowButton.tag = indexPath.row
//    guard dateFormatter.date(from: expiryDate) != nil else {
//    //    assert(false, "no date from string")
//        return ""
//    }
        
    //    yyyy MMM dd:mm EEEE
        
        return cell
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 59
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
////        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
////
////            let VC = storyBoard.instantiateViewController(withIdentifier: "ModifiedProdHistoryViewController") as! ModifiedProdHistoryViewController
////            VC.modalPresentationStyle = .fullScreen
////            VC.productDataDict = prodModifyArray[indexPath.row] as! NSDictionary
//////            self.present(VC, animated: true, completion: nil)
////        self.navigationController?.pushViewController(VC, animated: true)
//
//        }
    @objc func redirecttoView(sender:UIButton)
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let VC = storyBoard.instantiateViewController(withIdentifier: "ModifiedProdHistoryViewController") as! ModifiedProdHistoryViewController
            VC.modalPresentationStyle = .fullScreen
        VC.productDataDict = prodModifyArray[sender.tag] as! NSDictionary
//            self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)
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
