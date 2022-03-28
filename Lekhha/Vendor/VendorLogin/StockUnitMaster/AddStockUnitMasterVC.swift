//
//  AddStockUnitMasterVC.swift
//  Lekhha
//
//  Created by USM on 04/11/21.
//

import UIKit
import ObjectMapper
import Toast_Swift

struct StockList {
    let name: String
    let description: String
}

class AddStockUnitMasterVC: UIViewController,UIScrollViewDelegate,AddStockUnitMasterBtnCellDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    var productScrollView = UIScrollView()
    var scrollViewYPos : CGFloat!
    
    @IBOutlet weak var topHeaderBackgroundView: UIView!
    
    var myProductArray = NSMutableArray()
    
   var productNameTF = UITextField()
   var descriptionTF = UITextView()

    @IBOutlet weak var headerTextLabel: UILabel!
    
    @IBOutlet weak var addTableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    
    var tableArr = [Int]()
    
    var serviceVC = ServiceController()
    var stockUnitArray = NSMutableArray()
    
    var accountID = ""
    var row : Int = -1
    
    var customcell:AddStockUnitMasterTVCell!
    
    var stockNamesArr : [String] = [String]()
    var descriptionArr : [String] = [String]()
    
    var models: [StockList] = []
    
    var params = [String:Any]()
    var stockObj: StockList?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableView.dataSource = self
        addTableView.delegate = self
        addTableView.separatorStyle = .none
        let nibName1 = UINib(nibName: "AddStockUnitMasterTVCell", bundle: nil)
        addTableView.register(nibName1, forCellReuseIdentifier: "AddStockUnitMasterTVCell")
        
//        scrollViewYPos = 0

//        AddStockUnitMasterUI()
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
    // MARK: UITextfield Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
//        let validString = NSCharacterSet(charactersIn: "!@#$^&*()_+{}[]|\"<>,~`/:;?-=\\¥'£•¢")
       
//        activeTextField = textField
//        let index = IndexPath(row: 0, section: 0)
//        let cell: AddStockUnitMasterTVCell = self.addTableView.cellForRow(at: index) as! AddStockUnitMasterTVCell

//        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
     
        return true
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    var stockUnitMainArray=NSMutableArray()
    @IBAction func addBtnAction(_ sender: UIButton) {
        
        var params = NSMutableDictionary()
        params = [
            "accountId":accountID,
            "stockUnitDescription":"",
            "stockUnitName":"",
              "warnStock":false,
              "warnDescription":false
            ]
        stockUnitMainArray.add(params)
        
        warningStockArr.append(false)
        warningDesArr.append(false)
        tableArr.append(1)
        addTableView.reloadData()
    }
    var warningStockArr=[Bool]()
    var warningDesArr=[Bool]()
    @IBAction func saveBtnAction(_ sender: Any) {
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.view.endEditing(true)
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        warningDesArr=[Bool]()
        warningStockArr=[Bool]()
        for i in 0..<stockUnitMainArray.count {
            let dict = stockUnitMainArray[i] as! NSMutableDictionary
            let stockName=dict.value(forKey: "stockUnitName") as? String ?? ""
            if stockName == "" {
                dict.setValue(true, forKey: "warnStock")
                warningStockArr.append(true)
                stockNamesArr.removeAll()
                descriptionArr.removeAll()
            }
            else {
                dict.setValue(false, forKey: "warnStock")
                warningStockArr.append(false)
                stockNamesArr.append(stockName)
            }
            let stockDescrp = dict.value(forKey: "stockUnitDescription") as? String ?? ""
            
            if stockDescrp == "" {
                dict.setValue(true, forKey: "warnDescription")
                warningDesArr.append(true)
                stockNamesArr.removeAll()
                descriptionArr.removeAll()
            }
            else {
                dict.setValue(false, forKey: "warnDescription")
                warningDesArr.append(false)
                descriptionArr.append(stockDescrp)
            }
            
        }
        
        print(stockUnitArray)
        if warningStockArr.contains(true) || warningDesArr.contains(true)
                {
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.addTableView.reloadData()
        
                }
        else
                {
                    activity.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.post_StockUnitMaster_API_Call()
                    })
                }
        
     /*   for i in 0..<tableArr.count {
            let indexPath = NSIndexPath(row:i, section:0)
            let cell : AddStockUnitMasterTVCell? = self.addTableView.cellForRow(at: indexPath as IndexPath) as! AddStockUnitMasterTVCell?
            if let item = cell?.stockUnitNameTF.text {
                stockNamesArr.append(item)
            }
            if let item = cell?.descriptionTextView.text {
                descriptionArr.append(item)
            }
        }
        */
    }
    
    // MARK: Add Experience Info API Call
    func post_StockUnitMaster_API_Call() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        for index in 0..<stockNamesArr.count
        {
//            models.append(StockList(name: stockNamesArr[index], description: descriptionArr[index]))
            
            let descrip = descriptionArr[index]
            let nameStr = stockNamesArr[index]
            
            params = [
            "accountId":accountID,
                "stockUnitDescription":descrip,
                "stockUnitName":nameStr
            ]
            stockUnitArray.add(params)
        }
             
        print(stockUnitArray)
        var urlStr = ""

            urlStr = Constants.BaseUrl + vendorAddStockUnitUrl
            
            let postHeaders_IndividualLogin = ["":""]
            
            serviceVC.requestPOSTURLWithArray(strURL: urlStr as NSString, postParams: stockUnitArray as NSArray, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                
                let respVo:AddStockUnitMasterRespVo = Mapper().map(JSON: result as! [String : Any])!
                
                let status = respVo.STATUS_CODE
                let statusMessage = respVo.STATUS_MSG
                let message = respVo.message
                
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                if status == 200 {
                    
                    if statusMessage == "SUCCESS" {
                        
                        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                            self.navigationController?.popViewController(animated: true)
                                                       
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                else {
                    self.view.makeToast(message)
                }
            }) { (error) in
                
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                print("Something Went To Wrong...PLrease Try Again Later")
//                self.view.makeToast("app.SomethingWentToWrongAlert".localize())
            }
    }
    // Alert controller
    func showAlertWith(title:String,message:String)
        {
            let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
            //to change font of title and message.
            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
            alertController.setValue(titleAttrString, forKey: "attributedTitle")
            alertController.setValue(messageAttrString, forKey: "attributedMessage")
            
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            })
    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    @objc func onClickWarnButton()
    {
        self.showAlertWith(title: "Alert", message: "Required")
    }
    var productN:Bool=false
    var productD:Bool=false
    func AddStockUnitMasterUI(){
        
        productScrollView.removeFromSuperview()
        
        productScrollView = UIScrollView()
        productScrollView.frame = CGRect(x: 0, y: 120, width: self.view.frame.size.width, height: self.view.frame.size.height - (topHeaderBackgroundView.frame.size.height)+100)
        productScrollView.backgroundColor = hexStringToUIColor(hex: "e4ecf9")
        self.view.addSubview(productScrollView)
        
        productScrollView.delegate = self
        
        var yValue = CGFloat()
        yValue = 15
        
//        if(myProductArray.count > 0){
//
//            for i in 1...myProductArray.count {
                
                 productNameTF = UITextField()
                 descriptionTF = UITextView()

                let productView = UIView()
                productView.backgroundColor = UIColor.white
                productView.frame = CGRect(x: 15, y: yValue, width: productScrollView.frame.size.width - 30, height: 10)
                productScrollView.addSubview(productView)
                
                productView.layer.cornerRadius = 10
                productView.layer.masksToBounds = true
                
//                let Str : String = String(i)
                
                var addProdXValue = CGFloat()
                addProdXValue = 10
                
                let deleteBtn = UIButton()
                deleteBtn.frame = CGRect(x: productView.frame.size.width - 50, y: productView.frame.origin.y+productView.frame.size.height, width: 40, height: 40)
                deleteBtn.setImage(UIImage.init(named: "deleteBlue"), for: .normal)
                deleteBtn.addTarget(self, action: #selector(deleteProdBtnTap), for: .touchUpInside)
//                deleteBtn.tag = i-1
                deleteBtn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                productView.addSubview(deleteBtn)
                
//                let productMainDict = myProductArray.object(at: i-1) as! NSMutableDictionary
        
        //Product Name Lbl
        
        let productNameLbl = UILabel()
        productNameLbl.frame = CGRect(x: 10, y: deleteBtn.frame.origin.y+deleteBtn.frame.size.height+15, width: productView.frame.size.width - (20), height: 20)
        productNameLbl.text = "Stock unit name :"
        productNameLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        productNameLbl.textColor = hexStringToUIColor(hex: "232c51")
        productView.addSubview(productNameLbl)
                                
                //Product Name TF

                productNameTF.frame = CGRect(x: 10, y: productNameLbl.frame.origin.y+productNameLbl.frame.size.height+5, width: productNameLbl.frame.size.width - (10), height: 40)
    //            productNameTF.text = "fdfdsfdsfd"
                productNameTF.font = UIFont.init(name: kAppFontMedium, size: 13)
                productNameTF.textColor = hexStringToUIColor(hex: "232c51")
        if productN==true
        {
        let productNameAlertButton = UIButton()
        productNameAlertButton.frame = CGRect(x: productNameTF.frame.origin.x+productNameTF.frame.size.width - 40, y: productNameTF.frame.origin.y+5, width: 30, height: 30)
        productNameAlertButton.setImage(UIImage(named: "warn.png"), for: .normal)
        productNameAlertButton.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
            productView.addSubview(productNameAlertButton)
       }
                productView.addSubview(productNameTF)
                
                productNameTF.layer.borderWidth = 1
                productNameTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                productNameTF.layer.cornerRadius = 3
                productNameTF.clipsToBounds = true

                let productNamePaddingView = UIView()
                productNamePaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: productNameTF.frame.size.height)
                productNameTF.leftView = productNamePaddingView
                productNameTF.leftViewMode = UITextField.ViewMode.always

                //Description Lbl
                
                let descriptionLbl = UILabel()
                descriptionLbl.frame = CGRect(x: 10, y: productNameTF.frame.origin.y+productNameTF.frame.size.height+15, width: productView.frame.size.width - (20), height: 20)
                descriptionLbl.text = "Description :"
                descriptionLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
                descriptionLbl.textColor = hexStringToUIColor(hex: "232c51")
                productView.addSubview(descriptionLbl)
                
                //Description Text View

                descriptionTF.frame = CGRect(x: 10, y: descriptionLbl.frame.origin.y+descriptionLbl.frame.size.height+5, width: productView.frame.size.width - (20), height: 80)
    //            descriptionTF.text = "fdfdsfdsfd"
                descriptionTF.font = UIFont.init(name: kAppFontMedium, size: 13)
                descriptionTF.textColor = hexStringToUIColor(hex: "232c51")
        if productD==true
        {
                let descriptionAlertButton = UIButton()
        descriptionAlertButton.frame = CGRect(x: descriptionTF.frame.origin.x+descriptionTF.frame.size.width - 40, y: descriptionTF.frame.origin.y+5, width: 30, height: 30)
        descriptionAlertButton.setImage(UIImage(named: "warn.png"), for: .normal)
        descriptionAlertButton.addTarget(self, action: #selector(onClickWarnButton), for: .touchUpInside)
                    productView.addSubview(descriptionAlertButton)
                }
                    
                productView.addSubview(descriptionTF)
                
                descriptionTF.layer.borderWidth = 1
                descriptionTF.layer.borderColor = hexStringToUIColor(hex: "dfe0e5").cgColor
                descriptionTF.layer.cornerRadius = 3
                descriptionTF.clipsToBounds = true
        
        productView.frame = CGRect(x: 15, y: yValue, width: productScrollView.frame.size.width - 30, height: descriptionTF.frame.origin.y+descriptionTF.frame.size.height+15)

        yValue = productView.frame.size.height + yValue + 10
        
//                      }
//                  }
        
        //Add Product

        let addProductBtn = UIButton()
        addProductBtn.frame = CGRect(x:10, y: yValue, width: 120, height: 40)
        addProductBtn.setTitle("Add Product", for: UIControl.State.normal)
        addProductBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        addProductBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        addProductBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
        addProductBtn.layer.cornerRadius = 5
        addProductBtn.layer.masksToBounds = true
        productScrollView.addSubview(addProductBtn)
        
        addProductBtn.addTarget(self, action: #selector(addProductBtnTap), for: .touchUpInside)
        addProductBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
   
        productScrollView.contentSize = CGSize(width: productScrollView.frame.size.width, height: yValue)
        productScrollView.contentOffset = CGPoint(x: 0, y: scrollViewYPos)

    }
    
    @IBAction func deleteProdBtnTap(_ sender: UIButton){
        
//        if(myProductArray.count <= 1){
//            self.showAlertWith(title: "Alert..!!", message: "Minimum one product required")
//
//        }else{
            
            myProductArray.removeObject(at: sender.tag)
//            self.showAlertWith(title: "Success", message: "Product deleted")

            AddStockUnitMasterUI()
//        }
    }
    
    @objc func addProductBtnTap(sender: UIButton!){
        
        if(myProductArray.count > 19){
            
//            self.showAlertWith(title: "Alert !!", message: "Cannot add more than 20 products at a time")
//            return
        }
//        self.addAnEmptyProduct()
        self.AddStockUnitMasterUI()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewYPos = scrollView.contentOffset.y
    }



    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if stockUnitMainArray.count > 0 {
            return stockUnitMainArray.count
        }
        else {
            warningDesArr.append(false)
            warningStockArr.append(false)
            tableArr.append(1)
            var params = NSMutableDictionary()
            params = [
              "accountId":accountID,
              "stockUnitDescription":"",
              "stockUnitName":"",
                "warnStock":false,
                "warnDescription":false
              ]
              stockUnitMainArray.add(params)
            return 1
        }
    }
    //    cell For Row At indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = addTableView.dequeueReusableCell(withIdentifier: "AddStockUnitMasterTVCell", for: indexPath) as! AddStockUnitMasterTVCell
        let dict = stockUnitMainArray[indexPath.row] as? NSMutableDictionary
        cell.cellDelegate = self
        cell.deleteBtn.tag = indexPath.row
        if dict?.value(forKey: "warnStock") as? Bool==true
        {
        cell.stockWarnButton.isHidden=false
        }else
        {
            cell.stockWarnButton.isHidden=true
            
        }
        cell.stockWarnButton.addTarget(self, action: #selector(self.onClickWarnButton), for: .touchUpInside)
        cell.descriptionWarnButton.addTarget(self, action: #selector(self.onClickWarnButton), for: .touchUpInside)
        cell.stockUnitNameTF.tag=Int("1000" + String(indexPath.row)) ?? 0
        cell.descriptionTextView.tag=Int("1001" + String(indexPath.row)) ?? 0
        cell.stockUnitNameTF.delegate = self
        cell.descriptionTextView.delegate = self
        if dict?.value(forKey: "warnDescription") as? Bool==true
        {
            cell.descriptionWarnButton.isHidden=false
        }else
        {
            cell.descriptionWarnButton.isHidden=true
        }
        
        cell.stockUnitNameTF.text=dict?.value(forKey: "stockUnitName") as? String
        cell.descriptionTextView.text=dict?.value(forKey: "stockUnitDescription") as? String
        customcell = cell
        return cell
    }
    //    did Press Button
    func didPressButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
        let index = NSIndexPath(row: tag, section: 0)
        if tableArr.count > 0 {
            warningDesArr.remove(at: index.row)
            warningStockArr.remove(at: index.row)
            tableArr.remove(at: index.row)
            stockUnitMainArray.removeObject(at: index.row)
            addTableView.reloadData()
        }
    }
    //    height For Row At indexPath
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 220
    }
    //    did Select Row At indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if UIDevice.current.userInterfaceIdiom == .phone {
           print("running on iPhone")

        }
    }
    
//    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
//        <#code#>
//    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    print("TextField did end editing method called")
        var productTagValue = Int()
        
        var productArrayPosition = Int()
        let sstag:String = String(textField.tag)
        if sstag.count>5
        {
       productArrayPosition = textField.tag%100
        productTagValue = textField.tag / 100;
          
        }
        else
        {
        productArrayPosition = textField.tag%10
        productTagValue = textField.tag / 10;
        
        }
        var dict = NSMutableDictionary()
        dict = stockUnitMainArray[productArrayPosition] as! NSMutableDictionary

        print(productArrayPosition)
        print(productTagValue)
        
        if productTagValue == 1000{
            dict.setValue(textField.text, forKey: "stockUnitName")
            if textField.text==""
            {
            }
            else
            {
                if dict.value(forKey: "warnStock") as? Bool==true
                {
                    dict.setValue(false, forKey: "warnStock")
                }
              
            }
            stockUnitMainArray.replaceObject(at: productArrayPosition, with: dict)
        }
        self.addTableView.reloadData()
     
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {

    textField.resignFirstResponder();
    return true;
    }
   
    func textViewDidEndEditing(_ textView: UITextView) {
        var productTagValue = Int()
        
        var productArrayPosition = Int()
        let sstag:String = String(textView.tag)
        if sstag.count>5
        {
       productArrayPosition = textView.tag%100
        productTagValue = textView.tag / 100;
          
        }
        else
        {
        productArrayPosition = textView.tag%10
        productTagValue = textView.tag / 10;
        
        }
        var dict = NSMutableDictionary()
        dict = stockUnitMainArray[productArrayPosition] as! NSMutableDictionary

        print(productArrayPosition)
        print(productTagValue)
        if productTagValue == 1001{
            dict.setValue(textView.text, forKey: "stockUnitDescription")
            if textView.text==""
            {
            }
            else
            {
                if dict.value(forKey: "warnDescription") as? Bool==true
                {
                    dict.setValue(false, forKey: "warnDescription")
                }
              
            }
            stockUnitMainArray.replaceObject(at: productArrayPosition, with: dict)
            
        }
        self.addTableView.reloadData()
    }
}
