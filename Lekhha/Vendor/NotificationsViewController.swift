//
//  NotificationsViewController.swift
//  Lekhha
//
//  Created by USM on 10/06/21.
//

import UIKit
import ObjectMapper
import DropDown

class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, sentname {
    
    var dropDown=DropDown()
    func sendnamedfields(fieldname: String, idStr: String) {
        
        if(fieldname == "Delete"){
            deleteAPICall()
            
        }else if(fieldname == "Accept"){
            accepetDeclineStatus = true
//            submitBorrowLentInactiveAPI(aaa: "Accepted")
        
        }else{
            accepetDeclineStatus = false
            //submitBorrowLentInactiveAPI(aaa: <#String#>)

        }
        
        self.navigationController?.popViewController(animated: true)

    }
    
    var accountID = String()
    var servCntrl = ServiceController()
    var notificationsDataArray = NSMutableArray()
    var deletIdStr = ""
    var prodIDStr = ""
    var accepetDeclineStatus = Bool()
    
    @IBOutlet weak var notificationTblView: UITableView!
    
    @IBAction func backBtnTapped(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set("Current Inventory", forKey: "sideMenuTitle")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        notificationTblView.delegate = self
        notificationTblView.dataSource = self
        
        notificationTblView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        
        getAllNotificationsAPI()

    }

    @IBAction func notificationsBtnTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "VendorOrdersViewController") as! VendorOrdersViewController
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = notificationTblView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        
        let dataDict = notificationsDataArray.object(at: indexPath.row) as? NSDictionary
        
        cell.titleLbl?.text = dataDict?.value(forKey: "notificationTitle") as? String ?? ""
        cell.descLbl?.text = dataDict?.value(forKey: "notificationDescription") as? String ?? ""
        
        let dateTimeStamp = dataDict?.value(forKey: "createdDate") as? Double ?? 0
        let dateStr = String(dateTimeStamp)

        
//        let date = NSDate(timeIntervalSince1970: dateTimeStamp)
//        let myString = (String(describing: date))
//        let convertedStr = timeInterval(timeAgo: myString)
        
//        cell.timeLbl.text = convertedStr
        
        cell.timeLbl.isHidden = true
        
        cell.threeLineBtn.addTarget(self, action: #selector(onThreeLineBtnTap), for: .touchUpInside)
        cell.threeLineBtn.tag = indexPath.row
        
           return cell
        
    }
    
    func timeInterval(timeAgo:String) -> String
        {
        
//        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let dateFormat = "E-dd-MM yyyy HH:mm:ss.SSSZ"

            let df = DateFormatter()

            df.dateFormat = dateFormat
            let dateWithTime = df.date(from: timeAgo)

            let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateWithTime!, to: Date())

            if let year = interval.year, year > 0 {
                return year == 1 ? "\(year)" + " " + "year ago" : "\(year)" + " " + "years ago"
            } else if let month = interval.month, month > 0 {
                return month == 1 ? "\(month)" + " " + "month ago" : "\(month)" + " " + "months ago"
            } else if let day = interval.day, day > 0 {
                return day == 1 ? "\(day)" + " " + "day ago" : "\(day)" + " " + "days ago"
            }else if let hour = interval.hour, hour > 0 {
                return hour == 1 ? "\(hour)" + " " + "hour ago" : "\(hour)" + " " + "hours ago"
            }else if let minute = interval.minute, minute > 0 {
                return minute == 1 ? "\(minute)" + " " + "minute ago" : "\(minute)" + " " + "minutes ago"
            }else if let second = interval.second, second > 0 {
                return second == 1 ? "\(second)" + " " + "second ago" : "\(second)" + " " + "seconds ago"
            } else {
                return "a moment ago"

            }
        }
    var requestedAccountId=String()
    var quuantity=String()
    var notifitionType=String()
    @objc func onThreeLineBtnTap(sender:UIButton){
        
        let dataDict = notificationsDataArray.object(at: sender.tag) as? NSDictionary
        let notificationType = dataDict?.value(forKey: "notifitionType") as? String ?? ""
        let borrowLentDetails=dataDict?.value(forKey: "borrowLentDetails")as? NSDictionary
        deletIdStr = dataDict?.value(forKey: "_id") as? String ?? ""
        prodIDStr = borrowLentDetails?.value(forKey: "productId") as? String ?? ""
        requestedAccountId = borrowLentDetails?.value(forKey: "requestedAccountId")as? String ?? ""
        quuantity=borrowLentDetails?.value(forKey: "quantity")as? String ?? ""
        notifitionType=dataDict?.value(forKey: "notifitionType")as? String ?? ""
        var categoryDataArray = [String]()
        
        if notificationType.caseInsensitiveCompare("borrow") == .orderedSame || notificationType.caseInsensitiveCompare("lent") == .orderedSame {
            
            if (borrowLentDetails?.value(forKey: "acceptanceStatus")as? String)?.caseInsensitiveCompare("Pending") == .orderedSame
            {
            categoryDataArray = ["Delete","Accept","Reject","View Product"]
            }
            else
            {
                categoryDataArray = ["Delete","View Product"]
            }

        }else{
            categoryDataArray = ["Delete","View Product"]

        }
        
        dropDown.dataSource = categoryDataArray //4
        
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                
                if(item == "Delete"){
                    self?.aalertBtn(result: dataDict ?? NSDictionary())
                    
                }else if(item == "Accept"){
                    self?.accepetDeclineStatus = true
                    self?.submitBorrowLentInactiveAPI(aaa: "Accepted")
                
                }
                else if(item == "Reject"){
                    self?.accepetDeclineStatus = false
                    self?.submitBorrowLentInactiveAPI(aaa: "Rejected")
                
                }
                else if(item == "View Product"){
                    self?.getProductDetails()

                }
                
            }


    }
    func aalertBtn(result:NSDictionary)
    {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this notification?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title:"YES", style: .default, handler: { (_) in
            
            self.deleteAPICall()
        }))
        
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    func submitBorrowLentInactiveAPI(aaa:String) {

        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let URLString_loginIndividual = Constants.BaseUrl + VendorBorrowInactiveUrl
        
        let params_IndividualLogin = ["notificationId":deletIdStr,"accountId":accountID,"acceptanceStatus":aaa,"requestedAccountId":requestedAccountId,"quantity":quuantity,"acceptType":notifitionType,"_id":prodIDStr] as [String : Any]
                
                    print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
        servCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                                    
                        if status == "SUCCESS" {
                            print("Success")
                            
                            self.showAlertWith(title: "Succcess", message: "Details updated successfully")
                            self.getAllNotificationsAPI()
                        }
                        else {
                            self.showAlertWith(title: "Alert", message: messageResp ?? "")
                        }
                        
                    }) { (error) in
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        print("Something Went To Wrong...PLrease Try Again Later")
                    }
                }
    
    func deleteAPICall()  {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true

            let URLString_loginIndividual = Constants.BaseUrl + DeleteNotificationUrl + deletIdStr
        
            servCntrl.requestDeleteURL(strURL:URLString_loginIndividual, success: {(result) in

                            let respVo:CurrentInventoryResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                self.showAlertWith(title: "Suceess", message:"Deleted successfully")
                                self.getAllNotificationsAPI()
                            }
                            else {
                                
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
                        }
    }
    
    func getAllNotificationsAPI() {
        
        notificationsDataArray = NSMutableArray()
        
                activity.startAnimating()
                self.view.isUserInteractionEnabled = false

        let URLString_loginIndividual = Constants.BaseUrl + AllNotificationsUrl + accountID
                                    
        servCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
            
                                let dataDict = result as? NSDictionary
                                            
                                if status == "SUCCESS" {
                                    
                                    if(statusCode == 200 ){
                                        self.notificationsDataArray = dataDict?.value(forKey: "result") as! NSMutableArray
                                        self.notificationTblView.reloadData()
                                  
                                    }else{
                                        self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                   
                                    }
                                }
                                else {
                                    self.showAlertWith(title: "Alert", message: messageResp ?? "")

                                }
                                
                            }) { (error) in
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                print("Something Went To Wrong...PLrease Try Again Later")
                            }
//            }

            //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
//            var json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
//        } catch {
////            print(error.description)
//        }
    }
    var mainProct=NSArray()
    func getProductDetails() {
        
                activity.startAnimating()
                self.view.isUserInteractionEnabled = false

        let URLString_loginIndividual = Constants.BaseUrl + productDetail + prodIDStr
                                    
        servCntrl.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in

                                let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                                        
                                let status = respVo.status
                                let messageResp = respVo.message
                                let statusCode = respVo.statusCode
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
            
                                let dataDict = result as? NSDictionary
                                            
                                if status == "SUCCESS" {
                                    
                                    if(statusCode == 200 ){
                                        let aaArray=dataDict?.value(forKey: "result") as! NSArray
                                        if aaArray.count>0
                                        {
                                       
                                               let bbArray=aaArray.reversed()
                                            self.mainProct = bbArray as NSArray
                                        
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let VC = storyBoard.instantiateViewController(withIdentifier: "ViewProductDetailsViewController") as! ViewProductDetailsViewController
                                        VC.mainHistoryArray=self.mainProct
                                        VC.modalPresentationStyle = .fullScreen
                                        self.navigationController?.pushViewController(VC, animated: true)
                                        }
                                        
                                    }else{
                                        self.showAlertWith(title: "Alert", message: messageResp ?? "")
                                   
                                    }
                                }
                                else {
                                    self.showAlertWith(title: "Alert", message: messageResp ?? "")

                                }
                                
                            }) { (error) in
                                
                                activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                print("Something Went To Wrong...PLrease Try Again Later")
                            }
//            }

            //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
//            var json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
//        } catch {
////            print(error.description)
//        }
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
