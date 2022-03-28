//
//  ReportsVC.swift
//  LekhaApp
//
//  Created by apple on 11/24/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
//import iOSDropDown
import ASValueTrackingSlider
import WARangeSlider
import ObjectMapper

class ReportsVC: UIViewController, sentname , ASValueTrackingSliderDataSource{
    
    @IBOutlet weak var selLocRangeSlider: UISlider!
    @IBOutlet weak var selLocMaxLbl: UILabel!
    @IBOutlet weak var selLocMinLbl: UILabel!
    @IBOutlet weak var selectLocRangeView: UIView!
    @IBOutlet weak var consumerSelectStatusStackView: UIStackView!
    @IBOutlet weak var selectStatusHeightConstraint: NSLayoutConstraint!
    var sideMenuView = SideMenuView()

    @IBAction func menuBtnTap(_ sender: UIButton) {
//        self.dismiss(animated:false, completion: nil)
//        self.navigationController?.popViewController(animated: true)

        toggleSideMenuViewWithAnimation()
    }
    
    func toggleSideMenuViewWithAnimation() {
            
            let allViewsInXibArray = Bundle.main.loadNibNamed("SideMenuView", owner: self, options: nil)
             sideMenuView = allViewsInXibArray?.first as! SideMenuView
             sideMenuView.frame = CGRect(x: -320, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
             self.view.addSubview(sideMenuView)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
                self.sideMenuView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.view.addSubview(self.sideMenuView)
                
                self.sideMenuView.loadSideMenuView(viewCntrl: self, status: "")

             }, completion: { (finished: Bool) -> Void in

             })
        }

    
    func slider(_ slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
        return "Dummy"
        
    }
    @IBOutlet weak var vendorSelectStatusView: UIView!
    
    var periodVsPeriod = ""
    
    var accountID = ""
    var headerTitleStr = "Total Valuation Report"
    
    var selectStatusStr = "Consumed"
    var serviceCntrl = ServiceController()
    var periodicTypeStr = "dates"
    var fromDateStr = ""
    var toDateStr = ""
    var categoryStr = ""
    var subCategoryStr = ""
    
    var pageStatusStr = String()
    
    var span = 2
    var reqFrom = 1
    var reqTo = 52
    
    var locStartRange = 0
    var locEndRange = 10

    var selectedComparisionStr = "Weekly"
    
    @IBOutlet weak var minYearTxtLbl: UILabel!
    @IBOutlet weak var selecctStatusView: UIView!
    
    @IBOutlet weak var maxWeekTxtLbl: UILabel!
    @IBOutlet weak var minWeekTxtLbl: UILabel!
    @IBOutlet weak var maxYearTxtLbl: UILabel!
    @IBOutlet weak var periodYConstant: NSLayoutConstraint!
    var selectedCategoryID : String!
    
    @IBOutlet weak var headerTitleBtn: UIButton!
    
    @IBOutlet weak var periodFromToBtn: UIButton!
    
    let hiddenBtn = UIButton()
    let pickerDateView = UIView()
    var picker : UIDatePicker = UIDatePicker()
    
    var categoryResult = [CategoryResult]()
    var subCategoryResult = [SubCategoryResult]()
    
    var categoryDataArray = NSMutableArray()
    var categoryIDArray = NSMutableArray()
    
    
    var isStartDateStr = ""
    
    var selectedDropDownStr = ""
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var subCategoryBtn: UIButton!
    
    @IBOutlet weak var periodComparisionTypeBtn: UIButton!
    
    @IBAction func periodComparisionBtnTap(_ sender: Any) {
        
        selectedDropDownStr = "selectComparision"
        headerTitleStr = ""
        
        categoryDataArray = ["Weekly","Monthly","Quarterly","Annually"]
        categoryIDArray = ["Weekly","Monthly","Quarterly","Annually"]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select Period Comparision"
        viewTobeLoad.fields = self.categoryDataArray as! [String]
        viewTobeLoad.categoryIDs = self.categoryIDArray as! [String]
        
        viewTobeLoad.modalPresentationStyle = .fullScreen
//        self.present(viewTobeLoad, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

    }
    
    func changePeriodComparisionDataWithSelectedField(selectedData:String) {
        
        selectedComparisionStr = selectedData
        
        minWeekTxtLbl.isHidden = false
        maxWeekTxtLbl.isHidden = false
        
        weeksCountLbl.isHidden = false
        weeksSlider.isHidden = false
        
        if(selectedData == "Weekly"){
            minWeekTxtLbl.text = "Week 1"
            maxWeekTxtLbl.text = "Week 52"
            
            weeksSlider.minimumValue = 1
            weeksSlider.maximumValue = 52
            
            weeksSlider.lowerValue = 1
            weeksSlider.upperValue = 52
            
            reqFrom = 1
            reqTo = 2
            
        }else if(selectedData == "Monthly"){
            minWeekTxtLbl.text = "Jan"
            maxWeekTxtLbl.text = "Dec"
            
            weeksSlider.minimumValue = 1
            weeksSlider.maximumValue = 12
            
            weeksSlider.lowerValue = 1
            weeksSlider.upperValue = 12
            
            reqFrom = 1
            reqTo = 12
            
        }else if(selectedData == "Quarterly"){
            minWeekTxtLbl.text = "Q1"
            maxWeekTxtLbl.text = "Q4"
            
            weeksSlider.minimumValue = 1
            weeksSlider.maximumValue = 4
            
            weeksSlider.lowerValue = 1
            weeksSlider.upperValue = 4
            
            reqFrom = 1
            reqTo = 4
            
        }else{
            minWeekTxtLbl.isHidden = true
            maxWeekTxtLbl.isHidden = true
            weeksSlider.isHidden = true
            weeksCountLbl.isHidden = true
            
        }

        onchangedTheSliderValue()
    }
    
    @IBAction func categoryBtnTap(_ sender: Any) {
        selectedDropDownStr = "cat"
        getCategoriesDataFromServer()
    }
    
    
    @IBAction func subCategoryBtnTap(_ sender: Any) {
        
        if selectedCategoryID == ""{
            self.showAlertWith(title: "Alert", message: "Select Category")
            
        }else{
            selectedDropDownStr = "subcat"
            getSubCategoriesDataFromServer()
            
        }
    }
    
    @IBAction func headerTitleBtnTapped(_ sender: Any) {
        
        selectedDropDownStr = "header"
        
        if(pageStatusStr == "VendorReports"){
            categoryDataArray = ["Total Valuation Report","Demand Forecast","Historical Report","Historical Wastage","Market Share"]
            categoryIDArray = ["Total Valuation Report","Demand Forecast","Historical Report","Historical Wastage","Market Share"]

        }else{
            categoryDataArray = ["Total Valuation Report","Demand Forecast","Historical Report","Historical Wastage"]
            categoryIDArray = ["Total Valuation Report","Demand Forecast","Historical Report","Historical Wastage"]

        }
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select"
        viewTobeLoad.fields = self.categoryDataArray as! [String]
        viewTobeLoad.categoryIDs = self.categoryIDArray as! [String]
        
        viewTobeLoad.modalPresentationStyle = .fullScreen
//        self.present(viewTobeLoad, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

    }
    
    
    func sendnamedfields(fieldname: String, idStr: String) {
        
        if(selectedDropDownStr == "cat"){
            selectedCategoryID = fieldname
            categoryBtn.setTitle(fieldname, for: .normal)
            categoryStr = fieldname
            
            subCategoryBtn.setTitle("Select Subcategory", for: .normal)
            subCategoryStr = ""
            
        }else if(selectedDropDownStr == "subcat"){
            subCategoryBtn.setTitle(fieldname, for: .normal)
            subCategoryStr = fieldname
            
        }else if(selectedDropDownStr == "header"){
            headerTitleBtn.setTitle(fieldname, for: .normal)
            changeViewPositionsWithSelectedData(selectedData: fieldname)
            headerTitleStr = fieldname
            
        }else if(selectedDropDownStr == "fromToPeriod"){
            fromToPeriodDateBtn.setTitle(fieldname, for: .normal)
            periodicTypeStr = fieldname
            
//            if(fieldname == "Weekly"){
//                periodicTypeStr = "Weekly"
//
//            }else{
//                periodicTypeStr = "Monthly"
//
//            }
            
        }else if(selectedDropDownStr == "selectComparision"){
            periodComparisionTypeBtn.setTitle(fieldname, for: .normal)
            changePeriodComparisionDataWithSelectedField(selectedData: fieldname)
            
            periodicTypeStr = fieldname
            
        }
        
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }
    
    
    
    func changeViewPositionsWithSelectedData(selectedData:String)  {
        
        if(selectedData == "Market Share"){
            
            selectLocRangeView.isHidden = false
            selecctStatusView.isHidden = true
            
            periodYConstant.constant = 140
            
            if Constants.IS_IPAD {
                periodYConstant.constant = 170

            }

            
        }else if(selectedData == "Total Valuation Report"){
            
            selectLocRangeView.isHidden = true
            selecctStatusView.isHidden = false
            
            selectStatusStr = "Consumed"
            changeCosumerStatus()
            
            selecctStatusView.isHidden = false
            
            if(pageStatusStr == "VendorReports"){
                periodYConstant.constant = 140
                
                if Constants.IS_IPAD {
                    periodYConstant.constant = 170

                }

            }else{
                periodYConstant.constant = 108
                if Constants.IS_IPAD {
                    periodYConstant.constant = 138

                }

            }
            
        }else{
            
            selectLocRangeView.isHidden = true
            selecctStatusView.isHidden = false
            
            selectStatusStr = ""
            
            selecctStatusView.isHidden = true
            periodYConstant.constant = 20
            
            if Constants.IS_IPAD {
                periodYConstant.constant = 50

            }

            
        }
    }
    
    
    @IBOutlet weak var periodCompBtn: UIButton!
    
    @IBOutlet weak var scrollViewHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var fromToRadioBtn: UIButton!
    @IBOutlet weak var periodCheckBoxBtn: UIButton!
    
    @IBOutlet weak var weeksSlider: RangeSlider!
    
    @IBOutlet weak var yearsSlider: ASValueTrackingSlider!
    
    @IBOutlet weak var weeksCountLbl: UILabel!
    
    @IBOutlet weak var completedOrderBtn: UIButton!
    
    @IBOutlet weak var cancelledOrderBtn: UIButton!
    
    @IBOutlet weak var activeOrderBtn: UIButton!
    
    @IBOutlet weak var exxpiredBtn: UIButton!
    
    @IBAction func vendorExpiredBtnTapped(_ sender: Any) {
        
        selectStatusStr = "Expired"
        
        activeOrderBtn.backgroundColor = UIColor.white
        activeOrderBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        cancelledOrderBtn.backgroundColor = UIColor.white
        cancelledOrderBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        activeOrderBtn.backgroundColor = UIColor.white
        activeOrderBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        exxpiredBtn.backgroundColor = hexStringToUIColor(hex: "005bf8")
        exxpiredBtn.setTitleColor(UIColor.white, for: .normal)

        
    }
    @IBAction func vendorActiveOrderBtnTapped(_ sender: Any) {
        
        selectStatusStr = "Active"
        
        exxpiredBtn.backgroundColor = UIColor.white
        exxpiredBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        cancelledOrderBtn.backgroundColor = UIColor.white
        cancelledOrderBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        completedOrderBtn.backgroundColor = UIColor.white
        completedOrderBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        activeOrderBtn.backgroundColor = hexStringToUIColor(hex: "005bf8")
        activeOrderBtn.setTitleColor(UIColor.white, for: .normal)

        
    }
    @IBAction func vendorCancelledOrderBtnTaapped(_ sender: Any) {
        
        selectStatusStr = "Cancelled"
        
        exxpiredBtn.backgroundColor = UIColor.white
        exxpiredBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        activeOrderBtn.backgroundColor = UIColor.white
        activeOrderBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        completedOrderBtn.backgroundColor = UIColor.white
        completedOrderBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        cancelledOrderBtn.backgroundColor = hexStringToUIColor(hex: "005bf8")
        cancelledOrderBtn.setTitleColor(UIColor.white, for: .normal)

    }
    
    @IBAction func vendorCompletedOrderBtnTapped(_ sender: Any) {
        
        selectStatusStr = "Completed"
        
        exxpiredBtn.backgroundColor = UIColor.white
        exxpiredBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        activeOrderBtn.backgroundColor = UIColor.white
        activeOrderBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        cancelledOrderBtn.backgroundColor = UIColor.white
        cancelledOrderBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        completedOrderBtn.backgroundColor = hexStringToUIColor(hex: "005bf8")
        completedOrderBtn.setTitleColor(UIColor.white, for: .normal)

    }
    
    
    @IBAction func periodComparisionBtnTapped(_ sender: Any) {
        
        periodComparisionView.isHidden = false
        fromToView.isHidden = true
        
        fromToRadioBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
        periodCompBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)
        
        scrollViewHeightConstant.constant = 1000
        periodVsPeriod = "period"
        
        periodicTypeStr = "Weekly"
        periodComparisionTypeBtn.setTitle("Weekly", for: .normal)
        
        changePeriodComparisionDataWithSelectedField(selectedData: "Weekly")

    }
    
    @IBAction func comparisionTypeTapped(_ sender: Any) {
        
    }
    
    @IBAction func periodComparisionRadioBtnTapped(_ sender: Any) {
        
        periodVsPeriod = "period"
        periodicTypeStr = "Weekly"
        periodComparisionTypeBtn.setTitle("Weekly", for: .normal)
        
        fromToRadioBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
        periodCompBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)
        
        scrollViewHeightConstant.constant = 1000
        
        periodComparisionView.isHidden = false
        fromToView.isHidden = true
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10.0
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 3.0
        cardView.layer.shadowOpacity = 0.4
        
        changePeriodComparisionDataWithSelectedField(selectedData: "Weekly")
        
    }
    
    @IBAction func fromToBtnTapped(_ sender: Any) {
        
        periodicTypeStr = "dates"
        periodCheckBoxBtn.setImage(UIImage(named:"checkBoxInactive"), for: .normal)
//        changeCosumerStatus()
        
        periodVsPeriod = ""
        
        periodComparisionView.isHidden = true
        fromToView.isHidden = false
        
        fromToRadioBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)
        periodCompBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
        
        scrollViewHeightConstant.constant = 685
        
    }
    
    @IBAction func fromToRadioBtnTapped(_ sender: Any) {
        
        periodicTypeStr = "dates"
        periodCheckBoxBtn.setImage(UIImage(named:"checkBoxInactive"), for: .normal)
        changeCosumerStatus()
        
        periodVsPeriod = ""
        
        periodComparisionView.isHidden = true
        fromToView.isHidden = false
        
        fromToRadioBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)
        periodCompBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
        
        scrollViewHeightConstant.constant = 685
        
    }
    @IBOutlet weak var fromToStartDateTitleLbl: UILabel!
    
    @IBOutlet weak var fromToEndDateTitleLbl: UILabel!
    
    @IBAction func fromToStartDateBtnTap(_ sender: Any) {
        isStartDateStr = "1"
        datePickerView()
        
    }
    
    @IBAction func fromToEndDateBtnTap(_ sender: Any) {
        isStartDateStr = "0"
        datePickerView()
        
    }
    
    @IBAction func fromToOPeriodicBtnTap(_ sender: Any) {
    }
    @IBOutlet weak var startDateLbl: UILabel!
    
    @IBOutlet weak var endDateLbl: UILabel!
    
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var endDateView: UIView!
    
    @IBOutlet weak var fromToView: UIView!
    
    @IBAction func periodBtnTap(_ sender: Any) {
    }
    
    
    
    
    @IBOutlet weak var consumedBtn: UIButton!
    
    @IBOutlet weak var expiredBtn: UIButton!
    
    @IBOutlet weak var orderedBtn: UIButton!
    
    @IBOutlet weak var lentBtn: UIButton!
    
    @IBOutlet weak var sharedBtn: UIButton!
    
    @IBOutlet weak var giveAwayBtn: UIButton!
    
    @IBOutlet weak var barrowedBtn: UIButton!
    
    @IBOutlet weak var fromToBtn: UIButton!
    
    @IBOutlet weak var startDateTF: UITextField!
    
    @IBOutlet weak var endDateTF: UITextField!
    
    @IBOutlet weak var periodicBtn: UIButton!
    
    @IBOutlet weak var generateReportBtn: UIButton!
    
    @IBOutlet weak var periodComparisionView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        yearsSlider.maximumValue = Float(truncating: 10 as NSNumber)
        yearsSlider.minimumValue = Float(truncating: 2 as NSNumber)
        yearsSlider.popUpViewCornerRadius = 5.0
        yearsSlider.setMaxFractionDigitsDisplayed(0)
        yearsSlider.popUpViewColor = hexStringToUIColor(hex: "005bf8")
        yearsSlider.font = UIFont(name: kAppFontMedium, size: 13)
        self.yearsSlider.textColor = UIColor.white
        self.yearsSlider.popUpViewWidthPaddingFactor = 5.7
        yearsSlider.thumbTintColor = UIColor.lightGray
        
        yearsSlider.addTarget(self, action: #selector(onChangedYearSliderValue), for: .valueChanged)
        
        weeksSlider.trackTintColor = hexStringToUIColor(hex: "005bf8")
        weeksSlider.trackHighlightTintColor = UIColor.lightGray
        weeksSlider.minimumValue = 1
        weeksSlider.maximumValue = 52
        weeksSlider.thumbTintColor = UIColor.white
        weeksSlider.thumbBorderWidth = 1
        weeksSlider.thumbBorderColor = UIColor.lightGray
        
        weeksSlider.addTarget(self, action: #selector(onchangedTheSliderValue), for: .valueChanged)
        
//        selLocRangeSlider.trackTintColor = hexStringToUIColor(hex: "005bf8")
//        selLocRangeSlider.trackHighlightTintColor = UIColor.lightGray
////        selLocRangeSlider.minimumValue = 1
////        selLocRangeSlider.maximumValue = 10
//        selLocRangeSlider.thumbTintColor = UIColor.white
//        selLocRangeSlider.thumbBorderWidth = 1
//        selLocRangeSlider.thumbBorderColor = UIColor.lightGray

//        selLocRangeSlider.addTarget(self, action: #selector(onchangedLocationSlider), for: .valueChanged)
        
        selLocRangeSlider.minimumValue = 1
        selLocRangeSlider.maximumValue = 100
        
        selLocRangeSlider.addTarget(self, action:#selector(sliderValueDidChange(sender:)), for: .valueChanged)

        selectedCategoryID = ""
        
        // UIView Card View in Ios Swift4:
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10.0
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 3.0
        cardView.layer.shadowOpacity = 0.4
        
        scrollViewHeightConstant.constant = 685
        
        // consumed Button:
        consumedBtn.layer.cornerRadius = 20
        consumedBtn.layer.borderWidth = 1
        consumedBtn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        // expired Button:
        expiredBtn.layer.cornerRadius = 20
        expiredBtn.layer.borderWidth = 1
        expiredBtn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        // ordered Button:
        orderedBtn.layer.cornerRadius = 20
        orderedBtn.layer.borderWidth = 1
        orderedBtn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        // Lent Button:
        lentBtn.layer.cornerRadius = 20
        lentBtn.layer.borderWidth = 1
        lentBtn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        startDateView.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        
        endDateView.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        endDateView.layer.borderWidth = 1
        
        fromToView.layer.cornerRadius = 10
        fromToView.layer.borderWidth = 1
        fromToView.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        
        periodComparisionView.layer.cornerRadius = 10
        periodComparisionView.layer.borderWidth = 1
        periodComparisionView.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        
        categoryBtn.layer.borderWidth = 1
        categoryBtn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        categoryBtn.layer.cornerRadius = 5
        
        subCategoryBtn.layer.borderWidth = 1
        subCategoryBtn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        subCategoryBtn.layer.cornerRadius = 5
        
        fromToPeriodDateBtn.layer.borderWidth = 1
        fromToPeriodDateBtn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        fromToPeriodDateBtn.layer.cornerRadius = 5
        
        periodComparisionTypeBtn.layer.borderWidth = 1
        periodComparisionTypeBtn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        periodComparisionTypeBtn.layer.cornerRadius = 5
        
        fromToPeriodDateBtn.setTitle("Weekly", for: .normal)
        headerTitleBtn.setTitle("Total Valuation Report", for: .normal)
        
        periodCheckBoxBtn.setImage(UIImage(named:"checkBoxInactive"), for: .normal)
        
        subCategoryBtn.setTitle("Select Subcategory", for: .normal)
        categoryBtn.setTitle("Select Category", for: .normal)
        
        fromToRadioBtn.setImage(UIImage.init(named: "radio_active"), for: .normal)
        periodCompBtn.setImage(UIImage.init(named: "radioInactive"), for: .normal)
        
        if(pageStatusStr == "VendorReports"){
            
            selectStatusHeightConstraint.constant = 120
            periodYConstant.constant = 140
            vendorSelectStatusView.isHidden = false
            
            consumerSelectStatusStackView.isHidden = true
            
            if Constants.IS_IPAD {
                periodYConstant.constant = 170

            }

            
        }else{
            if Constants.IS_IPAD {
                periodYConstant.constant = 170

            }

        }

        animatingView()
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
    
    
    @IBAction func consumedBtnTap(_ sender: Any) {
        changeCosumerStatus()
        
    }
    
    func changeCosumerStatus()  {
        selectStatusStr = "Consumption"
        
        consumedBtn.backgroundColor = hexStringToUIColor(hex: "005bf8")
        consumedBtn.setTitleColor(UIColor.white, for: .normal)
        
        expiredBtn.backgroundColor = UIColor.white
        expiredBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        orderedBtn.backgroundColor = UIColor.white
        orderedBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        lentBtn.backgroundColor = UIColor.white
        lentBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
    }
    
    
    
    @objc func onChangedYearSliderValue(){
        
        let str = slider(yearsSlider, stringForValue: yearsSlider.maximumValue)
        //        yearsSlider.
        
    }
    
    @objc func sliderValueDidChange(sender: UISlider) {
        
        locEndRange = Int(sender.value)
        selLocMaxLbl.text = "\(Int(sender.value)) Km"

   }
    
    @objc func onchangedLocationSlider(){

//        locStartRange = Int(selLocRangeSlider.lowerValue)
//        locEndRange = Int(selLocRangeSlider.upperValue)
//
//        selLocMinLbl.text! = "\(Int(selLocRangeSlider.lowerValue)) KM"
//        selLocMaxLbl.text! = "\(Int(selLocRangeSlider.upperValue)) KM"

    }
    
    @objc func onchangedTheSliderValue(){
        
        //        ["Weekly","Monthly","Quarterly","Annually"]
        
        print("\(weeksSlider.minimumValue) To \(weeksSlider.maximumValue)")
        _ = "\(weeksSlider.minimumValue) To \(weeksSlider.maximumValue)"
        
        reqFrom = Int(weeksSlider.lowerValue)
        reqTo = Int(weeksSlider.upperValue)
        
        if(selectedComparisionStr == "Weekly"){
            weeksCountLbl.text! = "Week \(Int(weeksSlider.lowerValue)) To Week \(Int(weeksSlider.upperValue))"
            
        }else if(selectedComparisionStr == "Monthly"){
            
            var minMonthChar = String()
            
            let minMonth: Int = Int(weeksSlider.lowerValue)
            switch minMonth {
            case 1:
                minMonthChar = "Jan"
            case 2:
                minMonthChar = "Feb"
            case 3:
                minMonthChar = "Mar"
            case 4:
                minMonthChar = "Apr"
            case 5:
                minMonthChar = "May"
            case 6:
                minMonthChar = "Jun"
            case 7:
                minMonthChar = "Jul"
            case 8:
                minMonthChar = "Aug"
            case 9:
                minMonthChar = "Sep"
            case 10:
                minMonthChar = "Oct"
            case 11:
                minMonthChar = "Nov"
            case 12:
                minMonthChar = "Dec"
            default:
                print("Some other character")
            }
            
            var maxMonthChar = String()
            
            let maxMonth: Int = Int(weeksSlider.upperValue)
            switch maxMonth {
            case 1:
                maxMonthChar = "Jan"
            case 2:
                maxMonthChar = "Feb"
            case 3:
                maxMonthChar = "Mar"
            case 4:
                maxMonthChar = "Apr"
            case 5:
                maxMonthChar = "May"
            case 6:
                maxMonthChar = "Jun"
            case 7:
                maxMonthChar = "Jul"
            case 8:
                maxMonthChar = "Aug"
            case 9:
                maxMonthChar = "Sep"
            case 10:
                maxMonthChar = "Oct"
            case 11:
                maxMonthChar = "Nov"
            case 12:
                maxMonthChar = "Dec"
            default:
                print("Some other character")
            }
            
            weeksCountLbl.text! = minMonthChar + " To " + maxMonthChar
            
        }else if(selectedComparisionStr == "Quarterly"){
            weeksCountLbl.text! = "Q\(Int(weeksSlider.lowerValue)) To Q\(Int(weeksSlider.upperValue))"
            
        }else{
            
        }
        
    }
    
    @IBAction func expiredBtnTap(_ sender: Any) {
        
        selectStatusStr = "Expired"
        
        consumedBtn.backgroundColor = UIColor.white
        consumedBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        expiredBtn.backgroundColor = hexStringToUIColor(hex: "005bf8")
        expiredBtn.setTitleColor(UIColor.white, for: .normal)
        
        orderedBtn.backgroundColor = UIColor.white
        orderedBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        lentBtn.backgroundColor = UIColor.white
        lentBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
    }
    
    @IBAction func orderedBtnTap(_ sender: Any) {
        
        selectStatusStr = "Ordered"
        
        consumedBtn.backgroundColor = UIColor.white
        consumedBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        expiredBtn.backgroundColor = UIColor.white
        expiredBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        orderedBtn.backgroundColor = hexStringToUIColor(hex: "005bf8")
        orderedBtn.setTitleColor(UIColor.white, for: .normal)
        
        lentBtn.backgroundColor = UIColor.white
        lentBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
    }
    
    @IBAction func lentBtnTap(_ sender: Any) {
        
        selectStatusStr = "Returned"
        
        consumedBtn.backgroundColor = UIColor.white
        consumedBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        expiredBtn.backgroundColor = UIColor.white
        expiredBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        orderedBtn.backgroundColor = UIColor.white
        orderedBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        lentBtn.backgroundColor = hexStringToUIColor(hex: "005bf8")
        lentBtn.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    @IBAction func onTapped_GenerateReport_Btn(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "TotalValuationReportVC") as! TotalValuationReportVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func generateReportBtnTapped(_ sender: UIButton) {
        
        if fromToRadioBtn.currentImage!.isEqual(UIImage(named: "radio_active")) {
            
            if(categoryStr == ""){
                self.showAlertWith(title: "Alert", message: "Please select category")

            }else if(subCategoryStr == ""){
                self.showAlertWith(title: "Alert", message: "Please select subcategory")

            }else if(fromDateStr == ""){
                self.showAlertWith(title: "Alert", message: "Please select start date")

            }else if(toDateStr == ""){
                self.showAlertWith(title: "Alert", message: "Please select end date")

            }else{
                
                if periodCheckBoxBtn.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
                  periodicTypeStr = "dates"
                    
                }
                
//                periodCheckBoxBtn.setImage(UIImage(named:"checkBoxInactive"), for: .normal)

                if(pageStatusStr == "VendorReports"){
                    generateFromToMarketShareReportsAPI()
                    
                }else{
                    generateReportAPI()

                }
                
            }

        }else{
            
            if(categoryStr == ""){
                self.showAlertWith(title: "Alert", message: "Please select category")

            }else if(subCategoryStr == ""){
                self.showAlertWith(title: "Alert", message: "Please select subcategory")

            }else{
                
                if(pageStatusStr == "VendorReports"){
                    generatePeriodVsPeriodReportAPI()
            
                }else{
                    generatePeriodVsPeriodReportAPI()

                }
            }
        }
    }
    
    @IBAction func onTapped_BackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onTapped_NotificationsBtn(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "TotalValuationReportVC") as! TotalValuationReportVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    var unchecked = true
    @IBAction func onTapped_FromTo_Btn(_ sender: Any) {
        if unchecked {
            fromToBtn.setImage(UIImage(named:"Checkout"), for: .normal)
            unchecked = false
        }
        else {
            fromToBtn.setImage( UIImage(named:"CheckIn"), for: .normal)
            unchecked = true
        }
    }
    
    @IBOutlet weak var fromToPeriodDateBtn: UIButton!
    
    @IBAction func fromToPeriodDateCheckBoxBtnTap(_ sender: UIButton) {
        
        if sender.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
            sender.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
            periodicTypeStr = fromToPeriodDateBtn.currentTitle ?? ""
            
        }else{
            periodicTypeStr = "dates"
            sender.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func periodDateBtnTap(_ sender: Any) {
        
        if periodCheckBoxBtn.currentImage!.isEqual(UIImage(named: "checkBoxInactive")) {
            periodCheckBoxBtn.setImage(UIImage.init(named: "checkBoxActive"), for: UIControl.State.normal)
            periodicTypeStr = fromToPeriodDateBtn.currentTitle ?? ""
            
        }else{
            periodicTypeStr = "dates"
            periodCheckBoxBtn.setImage(UIImage.init(named: "checkBoxInactive"), for: UIControl.State.normal)
        }
    }
    
    
    @IBAction func fromToPeriodDateBtnTap(_ sender: Any) {
        
        selectedDropDownStr = "fromToPeriod"
        
        categoryDataArray = ["Weekly","Monthly"]
        categoryIDArray = ["Weekly","Monthly"]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select"
        viewTobeLoad.fields = self.categoryDataArray as! [String]
        viewTobeLoad.categoryIDs = self.categoryIDArray as! [String]
        
        viewTobeLoad.modalPresentationStyle = .fullScreen
//        self.present(viewTobeLoad, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewTobeLoad, animated: true)

    }
    
    @IBAction func onTapped_PeriodicBtn(_ sender: Any) {
        if unchecked {
            periodicBtn.setImage(UIImage(named:"Checkout"), for: .normal)
            unchecked = false
        }
        else {
            periodicBtn.setImage( UIImage(named:"CheckIn"), for: .normal)
            unchecked = true
        }
    }
    
    func datePickerView()  {
        
        pickerDateView.removeFromSuperview()
        hiddenBtn.removeFromSuperview()
        picker.removeFromSuperview()
        
        hiddenBtn.frame = CGRect (x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)
        
        pickerDateView.frame = CGRect(x: 0, y: self.view.frame.size.height - 350, width: self.view.frame.size.width, height: 350)
        pickerDateView.backgroundColor = UIColor.white
        self.view.addSubview(pickerDateView)
        
        let doneBtn = UIButton()
        doneBtn.frame = CGRect(x: pickerDateView.frame.size.width - 100, y: 10, width: 80, height: 30)
        doneBtn.setTitle("Done", for: UIControl.State.normal)
        doneBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
        doneBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
        doneBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        doneBtn.addTarget(self, action: #selector(doneBtnTap), for: .touchUpInside)
        pickerDateView.addSubview(doneBtn)
        
        //Seperator Line 1 Lbl
        
        let seperatorLine1 = UILabel()
        seperatorLine1.frame = CGRect(x: 0, y: doneBtn.frame.size.height+doneBtn.frame.origin.y, width: pickerDateView.frame.size.width , height: 1)
        seperatorLine1.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
        pickerDateView.addSubview(seperatorLine1)
        
        picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
        //        let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
        picker.frame = CGRect(x:0.0, y:50, width:self.view.frame.size.width, height:300)
        // you probably don't want to set background color as black
        // picker.backgroundColor = UIColor.blackColor()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }

        pickerDateView.addSubview(picker)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        
        if(isStartDateStr == "1"){
            fromToStartDateTitleLbl.text = result
            fromDateStr = result
            
        }else{
            fromToEndDateTitleLbl.text = result
            toDateStr = result
        }
    }
    
    @objc func dueDateChanged(sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: picker.date)
        
        if(isStartDateStr == "1"){
            
            fromToStartDateTitleLbl.text = selectedDate
            fromDateStr = selectedDate
            
        }else{
            fromToEndDateTitleLbl.text = selectedDate
            toDateStr = selectedDate
            
        }
    }
    
    @objc func doneBtnTap(_ sender: UIButton) {
        
        hiddenBtn.removeFromSuperview()
        pickerDateView.removeFromSuperview()
        
    }
    
    func getCategoriesDataFromServer()  {
        
        categoryDataArray = NSMutableArray()
        categoryIDArray = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        
        let URLString_loginIndividual = Constants.BaseUrl + categoriesUrl
        
        
        serviceCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in
            
            let respVo:CategoryRespo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            _ = respVo.statusCode
            
//            let adminID = respVo.result![0].name! as String
//            print(adminID)
            
            self.categoryResult = respVo.result!
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if status == "SUCCESS" {
                
                for categoryItems in self.categoryResult {
                    
                    self.categoryIDArray.add(categoryItems._id ?? "")
                    self.categoryDataArray.add(categoryItems.name ?? "")
                    
                }
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
                viewTobeLoad.delegate1 = self
                viewTobeLoad.iscountry = false
                viewTobeLoad.headerTitleStr = "Select a Category"
                viewTobeLoad.fields = self.categoryDataArray as! [String]
                viewTobeLoad.categoryIDs = self.categoryIDArray as! [String]
                
                viewTobeLoad.modalPresentationStyle = .fullScreen
//                self.present(viewTobeLoad, animated: true, completion: nil)
                self.navigationController?.pushViewController(viewTobeLoad, animated: true)

                print(self.categoryDataArray)
                print(self.categoryIDArray)
                
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
    
    func getSubCategoriesDataFromServer()  {
        
        categoryDataArray = NSMutableArray()
        categoryIDArray = NSMutableArray()
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + SubCategoriesUrl + selectedCategoryID
        
        serviceCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in
            
            let respVo:SubCategoryRespo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            _ = respVo.statusCode
            
//            let adminID = respVo.result![0].name! as String
//            print(adminID)
            
            self.subCategoryResult = respVo.result!
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if status == "SUCCESS" {
                
                for categoryItems in self.subCategoryResult {
                    
                    self.categoryDataArray.add(categoryItems.name ?? "")
                    self.categoryIDArray.add(categoryItems._id ?? "")
                    
                }
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
                viewTobeLoad.delegate1 = self
                viewTobeLoad.iscountry = false
                viewTobeLoad.headerTitleStr = "Select a Subcategory"
                viewTobeLoad.fields = self.categoryDataArray as! [String]
                viewTobeLoad.categoryIDs = self.categoryIDArray as! [String]
                
                viewTobeLoad.modalPresentationStyle = .fullScreen
//                self.present(viewTobeLoad, animated: true, completion: nil)
                self.navigationController?.pushViewController(viewTobeLoad, animated: true)

                
                print(self.categoryDataArray)
                print(self.categoryIDArray)
                
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
    
    func generateFromToMarketShareReportsAPI(){
        
        var URLString_loginIndividual = ""
        URLString_loginIndividual = Constants.BaseUrl + VendorMarketShareFromToUrl

        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String

//        {"userId":"60a24c791bd54b3831714d14","accountId":"60a24cb22bf4443b65dff77f","category":"All","subCategory":"test","fromDate":"2020-06-14","toDate":"2021-06-14","startRange":0,"endRange":10,"periodicType":"dates"}

        
        let params_IndividualLogin = [
            "userId" : userID,
            "accountId":accountID ,
            "category":categoryStr,
            "subCategory": subCategoryStr,
            "fromDate":fromDateStr,
            "toDate":toDateStr,
            "startRange" : locStartRange,
            "endRange" : locEndRange,
            "periodicType":periodicTypeStr] as [String : Any]
        
        let postHeaders_IndividualLogin = ["":""]
        
        serviceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { [self] (result) in
            
            let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message ?? ""
            //                        let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if status == "SUCCESS" {
                
                let dataDict = result as! NSDictionary
                
                if(messageResp == "Vendor Accounts not found in selected range"){
                    self.showAlertWith(title: "Alert!!", message: messageResp)
                    
                }else{
                    
//                    ["STATUS_CODE": 200, "reportType": market share, "marketShareValue": 1.004811047593887, "TotalValue": 4777139, "STATUS_MSG": SUCCESS]
                    
                    if (self.periodCheckBoxBtn.currentImage!.isEqual(UIImage(named: "checkBoxInactive"))){
                        
                        let totalVal = dataDict.value(forKey: "TotalValue") as? Int
                        let marketShareVal = dataDict.value(forKey: "marketShareValue") as? Double
                        
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyBoard.instantiateViewController(withIdentifier: "MarketShareFromToViewController") as! MarketShareFromToViewController
                                VC.modalPresentationStyle = .fullScreen
                        VC.totalValue = totalVal ?? 0
                        VC.marketShareValue = marketShareVal ?? 0
                        self.navigationController?.pushViewController(VC, animated: true)

                    }else{
                        
                        let dataArr = dataDict.value(forKey: "result") as! NSArray

                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let VC = storyBoard.instantiateViewController(withIdentifier: "MarketSharePeriodToPeriodViewController") as! MarketSharePeriodToPeriodViewController
                                VC.modalPresentationStyle = .fullScreen
                        VC.marketShareResArr = dataArr as! NSMutableArray
                        VC.fromDateStr = fromDateStr
                        VC.toDateStr = toDateStr
                          self.navigationController?.pushViewController(VC, animated: true)
                    }
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
    }
    
    func generatePeriodToPeriodMarketShareAPI(){
        
        var URLString_loginIndividual = ""
        URLString_loginIndividual = Constants.BaseUrl + VendorMarketSharePeriodComparisionUrl

        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        
// {"userId":"60a24c791bd54b3831714d14","accountId":"60a24cb22bf4443b65dff77f","category":"All","subCategory":"test","requiredFrom":1,"requiredTo":52,"span":2,"periodicType":"Weekly","startRange":0,"endRange":10}
        
        let params_IndividualLogin = [
            "userId" : userID,
            "accountId":accountID ,
            "category":categoryStr,
            "subCategory": subCategoryStr,
            "status": selectStatusStr,
            "requiredFrom":reqFrom,
            "requiredTo":reqTo,
            "span":span,
            "startRange" : locStartRange,
            "endRange" : locEndRange,
            "periodicType":periodicTypeStr] as [String : Any]
        
        let postHeaders_IndividualLogin = ["":""]
        
        serviceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { [self] (result) in
            
            let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            //                        let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if status == "SUCCESS" {
                
                let dataDict = result as! NSDictionary
                
                if (self.periodCheckBoxBtn.currentImage!.isEqual(UIImage(named: "checkBoxInactive"))){
                    
                    let valuationDataDict = dataDict.value(forKey: "sumResult") as! NSDictionary
                    let valuationDataArray = dataDict.value(forKey: "result") as! NSArray
                    
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let VC = storyBoard.instantiateViewController(withIdentifier: "TotalValuationReportVC") as! TotalValuationReportVC
                            VC.modalPresentationStyle = .fullScreen
                            VC.valuationReportArray = valuationDataArray
                            VC.valuationDict = valuationDataDict
                    VC.headerTitleStr = self.headerTitleStr
//                            self.present(VC, animated: false, completion: nil)
                            self.navigationController?.pushViewController(VC, animated: true)

                }else{
                    
                    let valuationDict = dataDict.value(forKey: "sumResult") as! NSDictionary
                    let valuationDataArray = dataDict.value(forKey: "result") as! NSArray

                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let VC = storyBoard.instantiateViewController(withIdentifier: "TotalValuationGeneratedReportViewController") as! TotalValuationGeneratedReportViewController
                    VC.headerTitleStr = self.headerTitleStr
                            VC.modalPresentationStyle = .fullScreen
                            VC.reportsArray = valuationDataArray
                            VC.valuationDataDict = valuationDict
                    
                    VC.fromDateStr = self.fromDateStr
                    VC.toDateStr = self.toDateStr
                    
//                            self.present(VC, animated: false, completion: nil)
                                    self.navigationController?.pushViewController(VC, animated: true)
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
    }
    
    func generateReportAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        //        let defaults = UserDefaults.standard
        //        let userID = (defaults.string(forKey: "userID") ?? "") as String
        
        
        var URLString_loginIndividual = ""
        
        if(pageStatusStr == "VendorReports"){
            URLString_loginIndividual = Constants.BaseUrl + getVendorTotalValuationUrl
            
            if(headerTitleStr == "Demand Forecast"){
                URLString_loginIndividual = Constants.BaseUrl + getVendorDemandForcastUrl
                
            }else if(headerTitleStr == "Historical Report"){
                URLString_loginIndividual =  Constants.BaseUrl + getVendorHistoricalConsumptionUrl
                
            }else if(headerTitleStr == "Historical Wastage"){
                URLString_loginIndividual = Constants.BaseUrl + getVendorHistoricalWastageUrl
            }
            
      
        }else{
            URLString_loginIndividual = Constants.BaseUrl + getTotalValuationUrl
            
            if(headerTitleStr == "Demand Forecast"){
                URLString_loginIndividual = Constants.BaseUrl + getDemandForcastUrl
                
            }else if(headerTitleStr == "Historical Report"){
                URLString_loginIndividual =  Constants.BaseUrl + getHistoricalConsumptionUrl
                
            }else if(headerTitleStr == "Historical Wastage"){
                URLString_loginIndividual = Constants.BaseUrl + getHistoricalWastageUrl
            }
        }
        
        
        //        ["Total Valuation Report","Demand Forecast","Historical Report","Historical Wastage"]
        
//        if(headerTitleStr == "Demand Forecast"){
//            URLString_loginIndividual = Constants.BaseUrl + getDemandForcastUrl
//
//        }else if(headerTitleStr == "Historical Report"){
//            URLString_loginIndividual =  Constants.BaseUrl + getHistoricalConsumptionUrl
//
//        }else if(headerTitleStr == "Historical Wastage"){
//            URLString_loginIndividual = Constants.BaseUrl + getHistoricalWastageUrl
//        }
//
        
        let params_IndividualLogin = [
            "accountId":accountID ,
            "category":categoryStr,
            "subCategory": subCategoryStr,
            "status": selectStatusStr,
            "fromDate":fromDateStr,
            "toDate":toDateStr,
            "periodicType":periodicTypeStr] as [String : Any]
        
        let postHeaders_IndividualLogin = ["":""]
        
        serviceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { [self] (result) in
            
            let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            //                        let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if status == "SUCCESS" {
                
                let dataDict = result as! NSDictionary
                
                if (self.periodCheckBoxBtn.currentImage!.isEqual(UIImage(named: "checkBoxInactive"))){
                    
                    let valuationDataDict = dataDict.value(forKey: "sumResult") as! NSDictionary
                    let valuationDataArray = dataDict.value(forKey: "result") as! NSArray
                    
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let VC = storyBoard.instantiateViewController(withIdentifier: "TotalValuationReportVC") as! TotalValuationReportVC
                            VC.modalPresentationStyle = .fullScreen
                            VC.valuationReportArray = valuationDataArray
                            VC.valuationDict = valuationDataDict
                    VC.headerTitleStr = self.headerTitleStr
//                            self.present(VC, animated: false, completion: nil)
                            self.navigationController?.pushViewController(VC, animated: true)

                }else{
                    
                    let valuationDict = dataDict.value(forKey: "sumResult") as! NSDictionary
                    let valuationDataArray = dataDict.value(forKey: "result") as! NSArray

                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let VC = storyBoard.instantiateViewController(withIdentifier: "TotalValuationGeneratedReportViewController") as! TotalValuationGeneratedReportViewController
                    VC.headerTitleStr = self.headerTitleStr
                            VC.modalPresentationStyle = .fullScreen
                            VC.reportsArray = valuationDataArray
                            VC.valuationDataDict = valuationDict
                    
                    VC.fromDateStr = self.fromDateStr
                    VC.toDateStr = self.toDateStr
                    
//                            self.present(VC, animated: false, completion: nil)
                                    self.navigationController?.pushViewController(VC, animated: true)
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
        
    }
    
    
    func generatePeriodVsPeriodReportAPI() {
        
        span = Int(yearsSlider.value)
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        var URLString_loginIndividual = ""

        if(pageStatusStr == "VendorReports"){
            URLString_loginIndividual = Constants.BaseUrl + periodVendorTotalValuationUrl
            
            if(headerTitleStr == "Demand Forecast"){
                URLString_loginIndividual = Constants.BaseUrl + periodVendorDemandForecastUrl
                
            }else if(headerTitleStr == "Historical Report"){
                URLString_loginIndividual =  Constants.BaseUrl + periodVendorHistoricalConsumptionUrl
                
            }else if(headerTitleStr == "Historical Wastage"){
                URLString_loginIndividual = Constants.BaseUrl + periodVendorHistoricalWastageUrl
            }
        }else{
            
            if(headerTitleStr == "Demand Forecast"){
                URLString_loginIndividual = Constants.BaseUrl + periodDemandForecastUrl
                
            }else if(headerTitleStr == "Historical Report"){
                URLString_loginIndividual =  Constants.BaseUrl + periodHistoricalConsumptionUrl
                
            }else if(headerTitleStr == "Historical Wastage"){
                URLString_loginIndividual = Constants.BaseUrl + periodHistoricalWastageUrl
            }
        }
        
        
//        if(headerTitleStr == "Demand Forecast"){
//            URLString_loginIndividual = Constants.BaseUrl + periodDemandForecastUrl
//
//        }else if(headerTitleStr == "Historical Report"){
//            URLString_loginIndividual =  Constants.BaseUrl + periodHistoricalConsumptionUrl
//
//        }else if(headerTitleStr == "Historical Wastage"){
//            URLString_loginIndividual = Constants.BaseUrl + periodHistoricalWastageUrl
//        }
        
        let params_IndividualLogin = [
            "accountId":accountID ,
            "category":categoryStr,
            "subCategory": subCategoryStr,
            "status": selectStatusStr,
            "requiredFrom": reqFrom,
            "requiredTo":reqTo,
            "span":span,
            "periodicType":periodicTypeStr] as [String : Any]
        
        let postHeaders_IndividualLogin = ["":""]
        
        serviceCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { [self] (result) in
            
            let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if status == "SUCCESS" {
                
                let dataDict = result as! NSDictionary
                let reportDataArr = dataDict.value(forKey: "result") as! NSArray
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyBoard.instantiateViewController(withIdentifier: "PeriodVSPeriodViewController") as! PeriodVSPeriodViewController
                VC.modalPresentationStyle = .fullScreen
                VC.reportsArray = reportDataArr
                VC.headerTitleStr = headerTitleStr
                VC.periodicType = self.periodicTypeStr
                
//                self.present(VC, animated: false, completion: nil)
                self.navigationController?.pushViewController(VC,  animated: true)
                
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
    
}
