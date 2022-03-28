//
//  PeriodVSPeriodViewController.swift
//  LekhaLatest
//
//  Created by USM on 12/02/21.
//

import UIKit

class PeriodVSPeriodViewController: UIViewController {
    
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var headerTitleStr = ""
    
    var reportsArray = NSArray()
    var periodicType = ""
    
    var reportsScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTitleLbl.text = headerTitleStr
        
        loadScrollView()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
//        self.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)

    
    }
    
    func loadScrollView()  {
        
        reportsScrollView.removeFromSuperview()
        
        reportsScrollView = UIScrollView()
        reportsScrollView.frame = CGRect(x: 15, y: headerView.frame.size.height+headerView.frame.origin.y+(15), width: self.view.frame.size.width - (30), height: self.view.frame.size.height - (headerView.frame.size.height+(100)))
        reportsScrollView.backgroundColor = hexStringToUIColor(hex: "ffffff")
        self.view.addSubview(reportsScrollView)
        
        reportsScrollView.bounces = false
        
        var viewWidth = CGFloat()
        
        if(reportsArray.count <= 3){
            viewWidth = reportsScrollView.frame.size.width/CGFloat(reportsArray.count)
            
        }else{
            viewWidth = 100
        }
        
        var xPos = 0
        var yPos = 0
        
        if(reportsArray.count > 0){
            let dataDict = reportsArray[0] as! NSDictionary
            let periodicArray = dataDict.value(forKey: "periodicalList") as! NSArray
            
            for i in 0..<periodicArray.count + 1 {
                
                let view = UIView()
                view.frame = CGRect(x: xPos, y: yPos, width: Int(viewWidth), height: 40)
                reportsScrollView.addSubview(view)
                
                let leftSideLbl = UILabel()
                leftSideLbl.frame = CGRect(x: 0, y: 0, width: 1, height: view.frame.size.height)
                leftSideLbl.backgroundColor = hexStringToUIColor(hex: "999eae")
                view.addSubview(leftSideLbl)
                
                let bottomSideLbl = UILabel()
                bottomSideLbl.frame = CGRect(x: 0, y: view.frame.size.height-1, width: view.frame.size.width, height: 1)
                bottomSideLbl.backgroundColor = hexStringToUIColor(hex: "999eae")
                view.addSubview(bottomSideLbl)

                let rightSideLbl = UILabel()
                rightSideLbl.frame = CGRect(x: view.frame.size.width - 1, y: 0, width: 1, height: view.frame.size.height)
                rightSideLbl.backgroundColor = hexStringToUIColor(hex: "999eae")
                view.addSubview(rightSideLbl)
                
                let contentLbl = UILabel()
                contentLbl.frame = CGRect(x: 5, y: 5, width: view.frame.size.width - 10, height: view.frame.size.height - 10)
                contentLbl.textColor = hexStringToUIColor(hex: "000000")
                contentLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
                contentLbl.textAlignment = NSTextAlignment.center
                view.addSubview(contentLbl)
                
                if(i == 0){
                    view.backgroundColor = hexStringToUIColor(hex: "242d51")
                    contentLbl.textColor = hexStringToUIColor(hex: "ffffff")
                    rightSideLbl.isHidden = true
                    bottomSideLbl.isHidden = true
                    leftSideLbl.isHidden = true
                    
                    contentLbl.text = "Week"

                }else{
                    
                    let dataDict = periodicArray[i-1] as! NSDictionary
                    
//                    ["Weekly","Monthly","Quarterly","Annually"]
                    
                    if(periodicType == "Weekly"){
                        let titleStr = dataDict.value(forKey: "number") as! String
                        contentLbl.text = titleStr

                    }else if(periodicType == "Monthly"){
                        
                        let month: Int = dataDict.value(forKey: "number") as! Int
                        
                        switch month {
                        case 1:
                            contentLbl.text = "Jan"
                        case 2:
                            contentLbl.text = "Feb"
                        case 3:
                            contentLbl.text = "Mar"
                        case 4:
                            contentLbl.text = "Apr"
                        case 5:
                            contentLbl.text = "May"
                        case 6:
                            contentLbl.text = "Jun"
                        case 7:
                            contentLbl.text = "Jul"
                        case 8:
                            contentLbl.text = "Aug"
                        case 9:
                            contentLbl.text = "Sep"
                        case 10:
                            contentLbl.text = "Oct"
                        case 11:
                            contentLbl.text = "Nov"
                        case 12:
                            contentLbl.text = "Dec"
                        default:
                            print("Some other character")
                        }
                        
                    }else if(periodicType == "Quarterly"){
                        
                        let quarter: Int = dataDict.value(forKey: "number") as! Int
                        
                        switch quarter {
                        case 1:
                            contentLbl.text = "Q1"
                        case 2:
                            contentLbl.text = "Q2"
                        case 3:
                            contentLbl.text = "Q3"
                        case 4:
                            contentLbl.text = "Q4"
                        default:
                            print("Some other character")
                        }

                    }else{
                        
                    }
                    
                    view.backgroundColor = hexStringToUIColor(hex: "ffffff")

                }
                
                yPos = yPos + Int(view.frame.size.height)
                
            }
            
            //NEXT X
            
            
            xPos = Int(viewWidth)
            
            for k in 0..<reportsArray.count {
                
                let dataDict = reportsArray[k] as! NSDictionary
                
                let year = dataDict.value(forKey: "Year") as! Int
                
                yPos = 0
                
                let view = UIView()
                view.frame = CGRect(x: xPos, y: yPos, width: Int(viewWidth), height: 40)
                reportsScrollView.addSubview(view)
                
                let contentLbl = UILabel()
                contentLbl.frame = CGRect(x: 5, y: 5, width: view.frame.size.width - 10, height: view.frame.size.height - 10)
                contentLbl.text = String(year)
                contentLbl.textColor = hexStringToUIColor(hex: "000000")
                contentLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
                contentLbl.textAlignment = NSTextAlignment.center
                view.addSubview(contentLbl)
                
                view.backgroundColor = hexStringToUIColor(hex: "242d51")
                contentLbl.textColor = hexStringToUIColor(hex: "ffffff")
                
                yPos = yPos + Int(view.frame.size.height)
                
                let periodicArray = dataDict.value(forKey: "periodicalList") as! NSArray
                
                for j in 0..<periodicArray.count {
                    
                    let dataDict = periodicArray[j] as! NSDictionary
                    
                    let view = UIView()
                    view.frame = CGRect(x: xPos, y: yPos, width: Int(viewWidth), height: 40)
                    reportsScrollView.addSubview(view)
                    
    //                let leftSideLbl = UILabel()
    //                leftSideLbl.frame = CGRect(x: 0, y: 0, width: 1, height: view.frame.size.height)
    //                leftSideLbl.backgroundColor = hexStringToUIColor(hex: "999eae")
    //                view.addSubview(leftSideLbl)
                    
                    let bottomSideLbl = UILabel()
                    bottomSideLbl.frame = CGRect(x: 0, y: view.frame.size.height-1, width: view.frame.size.width, height: 1)
                    bottomSideLbl.backgroundColor = hexStringToUIColor(hex: "999eae")
                    view.addSubview(bottomSideLbl)

                    let rightSideLbl = UILabel()
                    rightSideLbl.frame = CGRect(x: view.frame.size.width - 1, y: 0, width: 1, height: view.frame.size.height)
                    rightSideLbl.backgroundColor = hexStringToUIColor(hex: "999eae")
                    view.addSubview(rightSideLbl)
                    
                    let contentLbl = UILabel()
                    contentLbl.frame = CGRect(x: 5, y: 5, width: view.frame.size.width - 10, height: view.frame.size.height - 10)
                    contentLbl.text = dataDict.value(forKey: "TotalAmount") as? String
                    contentLbl.textColor = hexStringToUIColor(hex: "000000")
                    contentLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
                    contentLbl.textAlignment = NSTextAlignment.center
                    view.addSubview(contentLbl)
                    
    //                if(j == 0){
    //                    view.backgroundColor = hexStringToUIColor(hex: "242d51")
    //                    contentLbl.textColor = hexStringToUIColor(hex: "ffffff")
    //
    //                }else{
                        view.backgroundColor = hexStringToUIColor(hex: "ffffff")

    //                }
                    
                    yPos = yPos + Int(view.frame.size.height)
                    
    //                if(j == 51){
    //                    xPos = xPos + Int(view.frame.size.width)
    //                    yPos = 0
    //                }
                }
                
                xPos = xPos + Int(view.frame.size.width)
            }
            
            reportsScrollView.contentSize = CGSize(width: xPos, height: yPos)

        }
    }
    

    /*
    // MARK: - Navigatioamn

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
