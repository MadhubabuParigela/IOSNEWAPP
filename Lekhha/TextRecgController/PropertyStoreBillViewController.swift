//
//  PropertyStoreBillViewController.swift
//  Lekhha
//
//  Created by USM on 15/08/21.
//

import UIKit

class PropertyStoreBillViewController: UIViewController,MyDataSendingDelegate {

    @IBAction func nextBtnTapped(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "PropertiesShowVC") as! PropertiesShowVC
        let defaults = UserDefaults.standard
        defaults.set(billNumStr, forKey: "BillNumber")
        defaults.set(billDateStr, forKey: "BillDate")
        VC.myProductsArray = myProductsArray
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var billNumCheckBoxBtn: UIButton!
    @IBOutlet weak var billDateCheckBoxBtn: UIButton!
    
    @IBOutlet weak var billDateLbl: UILabel!
    @IBOutlet weak var billNumLbl: UILabel!
    var billNumStr = ""
    var billDateStr = ""
    
    var rowNumber = Int()
    var propertiesArr:[String] = ["","","","","",""]
    var selectedImg = UIImage()

    var myProductsArray =  NSMutableArray()

    @IBOutlet weak var billNumBtn: UIButton!
    
    @IBAction func billNumBtnTap(_ sender: UIButton) {
        
        rowNumber = 0
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "MyCropVC") as! MyCropVC
         
         VC.cropSelectedImage = selectedImg
        
        
        VC.delegate = self
     //   VC.dataToBeSent = selectedData
//        VC.myBtn = cell.checkBtn
       self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBOutlet weak var billDateBtn: UIButton!
    
    @IBAction func billDateBtnTap(_ sender: UIButton) {
        
        rowNumber = 1
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "MyCropVC") as! MyCropVC
         
         VC.cropSelectedImage = selectedImg
        
        VC.delegate = self
     //   VC.dataToBeSent = selectedData
//        VC.myBtn = cell.checkBtn
       self.navigationController?.pushViewController(VC, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
        
    // Delegate Method
     
      func sendDataToFirstViewController(myData: String) {
         
         print("Row Num is \(rowNumber)")
         
         let myDataArry = myData.components(separatedBy: "\n") as NSArray
         print(myDataArry)

        if(rowNumber == 0){
            billNumStr = myDataArry[0] as? String ?? ""
            
            billNumLbl.text = billNumStr
            
            if(billNumStr != ""){
                billNumCheckBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
            }
            
        }else if(rowNumber == 1){
            billDateStr = myDataArry[0] as? String ?? ""
            
            billDateLbl.text = billDateStr
            
            if(billDateStr != ""){
                billDateCheckBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: .normal)
            }

        }
        
//         parseSelectedBillScanData(parseArray: myDataArry)
         
//        propertiesArr[rowNumber] = myData
//         [propertiesArr[rowNumber]].count
//     print("\([propertiesArr[rowNumber]].count)")
//         var countArr = NSMutableArray()
         
//         countArr.add([propertiesArr[rowNumber]])
         
         
     //   print("My Text Array: \(propertiesArr[rowNumber]),Index: \(rowNumber))")
        
//        TV_Prog.reloadData()
        
     }
     
     func parseSelectedBillScanData(parseArray:NSArray)  {
         
//         if(prodCount <= parseArray.count){
//
//             for i in 0..<myProductsArray.count {
//
//                 let parsedStr = parseArray.object(at: i) as! String
//
//                 var dict = NSMutableDictionary()
//                 dict = myProductsArray[i] as! NSMutableDictionary
//
//                 if(rowNumber == 0){
//                     dict.setValue(parsedStr, forKey: "productName")
//
//                 }else if(rowNumber == 1){
//                     dict.setValue(parsedStr, forKey: "price")
//
//                 }else if(rowNumber == 2){
//                     dict.setValue(parsedStr, forKey: "stockQuantity")
//
//                 }
//
//                myProductsArray.replaceObject(at: i, with: dict)
//             }
//
//             print("Parsed My Prod Arr is \(myProductsArray)")
//
//         }
//         else{

//             for i in 0..<parseArray.count {
//
// //                if(i <= myProductArray.count){
//
//                     let parsedStr = parseArray.object(at: i) as! String
//
//                     var dict = NSMutableDictionary()
//                     dict = myProductsArray[i] as! NSMutableDictionary
//
//                     if(rowNumber == 0){
//                         dict.setValue(parsedStr, forKey: "productName")
//
//                     }else if(rowNumber == 1){
//                         dict.setValue(parsedStr, forKey: "price")
//
//                     }else if(rowNumber == 2){
//                         dict.setValue(parsedStr, forKey: "stockQuantity")
//
//                     }
//
//                     myProductsArray.replaceObject(at: i, with: dict)
// //                }
//
//               }
//
//             print("Parsed My Prod Arr is \(myProductsArray)")

//         }
     }
}
