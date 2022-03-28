//
//  EmailValidationViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 16/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleMaps
import CoreLocation
import GooglePlaces
import DropDown

class EmailValidationViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate,GMSMapViewDelegate, UIGestureRecognizerDelegate,GMSAutocompleteViewControllerDelegate, UITextViewDelegate, sentname {
    
    var categoryArray = ["1-10","10-50","50-100","100-500","Above 500"]
    var categoryIDArray = ["1-10","10-50","50-100","100-500","Above 500"]

    var companySizeStr = ""
    
    func sendnamedfields(fieldname: String, idStr: String) {
        
        companySizeTF.setTitle(fieldname, for: .normal)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBOutlet weak var backBtn: UIButton!
    //    @IBOutlet weak var chooseLocationTF: UILabel!
    
    var isUpdateLocation = true
    
    var chooseLocationBackView = UIView()
    var isgender = ""
    
    var location: CLLocation?
    var geocoder = GMSGeocoder()
    var locationgeocoder: CLGeocoder?
    var destiMarker = GMSMarker()
    var locationManager:CLLocationManager!
    var latt = Double()
    var long = Double()
    var addressStr = String()
    var localityAdd = String()
    var subLocalityAdd = String()
    var streetAdd = String()
    var AddOneStr = String()
    var AddTwoStr = String()
    var cityStr = String()
    var latiValue = String()
    var longValue = String()
    var locationaAddTF = UITextField()
    var locationaAddLabel = UILabel()
    var locationaSearchTF = UITextField()
    var mapView = GMSMapView()
    var statesResultArr = [StatesResultVo]()
    var statesNamesArr = [String]()
    var statesIdsArr = [String]()
    var statesCodesArr = [String]()
    var stateIdValue = String()
    var isManual = ""
    var isGetAdd:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
        cityTF.delegate = self
        address1TF.delegate = self
        address2TF.delegate = self
        stateTF.delegate = self
        landmarkTF.delegate = self
//        companySizeTF.delegate = self
        companyTF.delegate = self
        streetTF.delegate = self
        
        companySizeTF.setTitle("1-10", for: .normal)
        
        let userDefaults = UserDefaults.standard
        let emailID = userDefaults.value(forKey: "emailId")
        
        emailTF.text = emailID as? String
        animatingView()
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()

           if CLLocationManager.locationServicesEnabled(){
               locationManager.startUpdatingLocation()
           }
        
//        stateTF.optionArray = ["Male","Female","others"]
        //Its Id Values and its optional
//        stateTF.optionIds = [1,2,3]
        //            cell.personTF.optionImageArray = ["down","previous"]
//        stateTF.arrow.arrowColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
//        stateTF.handleKeyboard = false

        // Do any additional setup after loading the view.
    }
    //    view Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        getStatesAPI()
        
//        stateTF.didSelect { (selectedText , index ,id) in
//            print("Selected String: \(selectedText) \n index: \(index)")
//            self.stateTF.text = selectedText
//            self.stateIdValue = id
////            self.genderIndex = id
////            self.isCheckField = true
//        }
       
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let locationgeocoder = CLGeocoder()
        location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        locationgeocoder.reverseGeocodeLocation(location!, completionHandler: { placemarks, error in
            DispatchQueue.main.async {
                let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,longitude: place.coordinate.longitude,zoom: 15)
//                self.locationMapView.camera = camera
            }
            let placemark = placemarks?[0]
            if let aPlacemark = placemark {
                print("placemark: \(aPlacemark)")
            }
//            self.isSearchLocation = true
            print("zipcode: \(placemark?.postalCode ?? "")")
            UserDefaults.standard.set(placemark?.postalCode ?? "", forKey: "pinCode")
            
            let address = String(format : "%@,%@,%@,%@,%@,%@",placemark?.subThoroughfare ?? "",placemark?.thoroughfare ?? "",placemark?.subLocality ?? "",placemark?.locality ?? "" ,placemark?.subAdministrativeArea ?? "",placemark?.country ?? "",placemark?.postalCode ?? "")
            
            self.addressStr = address
            self.locationAddLabel.text = self.addressStr
            self.address1TF.text = "\(placemark?.subThoroughfare ?? "")"
//            self.address2TF.text = "\(placemark?.thoroughfare ?? "")"
            self.cityTF.text = "\(placemark?.locality ?? "")"
            self.streetTF.text = "\(placemark?.subLocality ?? "")"
            self.streetAdd = "\(placemark?.thoroughfare ?? "")"
            self.latiValue = "\(place.coordinate.latitude)"
            self.longValue = "\(place.coordinate.longitude)"
            self.locationTF.placeholder = ""
            self.pinCodeTF.text = "\(placemark?.postalCode ?? "")"
            
            self.latt = place.coordinate.latitude
            self.long = place.coordinate.longitude
            
            self.latiValue = "\(place.coordinate.latitude)"
            self.longValue = "\(place.coordinate.longitude)"
        
            print("address: \(address)")
//            self.locationTF.text = address
//            self.addressLabel.text = place.formattedAddress
                                
           self.destiMarker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    
            let london = GMSMarker(position: self.destiMarker.position)
            //        london.isFlat = true
            london.isDraggable = true
//            london.map = self.locationMapView
            london.title = address
            london.icon = UIImage(named: "ic_location")
//            london.map = self.locationMapView
            
            UserDefaults.standard.set(placemark?.locality ?? "", forKey: "pickedCity")
            UserDefaults.standard.synchronize()
            
            self.loadMapView()
            
//            UserDefaults.standard.set(placemark?.subThoroughfare ?? "", forKey: "houseno")
            self.dismiss(animated: true, completion: nil)
            
        })

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        dismiss(animated: true, completion: nil)

    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)

    }
    
    func textViewDidBeginEditing(_ textView: UITextView)  {
        
//        if(textView == chooseLocationTF){
//            self.loadMapView()
//
//        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == locationaSearchTF){
            
            isUpdateLocation = true
            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)

        }
        
//        if(textField == chooseLocationTF){
//            self.loadMapView()
//
//        }
    }
    
    var loginIndividualServer = ServiceController()

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var address1TF: UITextField!
    @IBOutlet weak var address2TF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    
    @IBOutlet weak var mobileBtn: UIButton!
    @IBOutlet weak var streetTF: UITextField!
    
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var landmarkTF: UITextField!
    
    @IBOutlet weak var companySizeTF: UIButton!
    @IBOutlet weak var pinCodeTF: UITextField!
    
    @IBOutlet weak var companyTF: SDCTextField!
    
    @IBOutlet weak var locationAddLabel: UILabel!
    @IBAction func companySizeBtnTap(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewTobeLoad = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        viewTobeLoad.delegate1 = self
        viewTobeLoad.iscountry = false
        viewTobeLoad.headerTitleStr = "Select Account Size"
        viewTobeLoad.fields = self.categoryArray
        viewTobeLoad.categoryIDs = self.categoryIDArray

        viewTobeLoad.modalPresentationStyle = .fullScreen
//                                        self.present(viewTobeLoad, animated: true, completion: nil)
self.navigationController?.pushViewController(viewTobeLoad, animated: true)


    }
    
    @IBOutlet weak var locationTF: UITextField!
    let dropDown = DropDown() //2
    @IBAction func mobileBtnAction(_ sender: UIButton) {
        dropDown.dataSource = self.statesNamesArr
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
          guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
            self?.stateTF.text = "\(item)"
            let stateStr:String = self?.statesIdsArr[index] ?? ""
            self?.stateIdValue = stateStr
        }
    }
    
    @IBAction func chooseLocationBtnAction(_ sender: Any) {
        
        loadMapView()
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        companySizeStr = companySizeTF.currentTitle ?? ""
        
        if emailTF.text == ""
        {
            self.showAlertWith(title: "Alert", message: "Enter your email")
            return
        }
        else if emailTF.text!.isValidEmail() == false{
                
            self.showAlertWith(title: "Alert", message: "Enter valid email id")
            return
                
        }
        else if address1TF.text == "" {
            
            self.showAlertWith(title: "Alert", message: "Enter address line 1")
            return

        }
//        else if address2TF.text == "" {
//
//            self.showAlertWith(title: "Alert", message: "Enter address line 2")
//            return
//
//        }
        else if streetTF.text == "" {
            
            self.showAlertWith(title: "Alert", message: "Enter street")
            return

        }
        else if stateTF.text == "" {
            
            self.showAlertWith(title: "Alert", message: "Enter state")
            return

        }
        else if cityTF.text == "" {
            
            self.showAlertWith(title: "Alert", message: "Enter city")
            return

        }
//        else if landmarkTF.text == "" {
//
//            self.showAlertWith(title: "Alert", message: "Enter landmark")
//            return
//
//        }
        else if companyTF.text == "" {
            self.showAlertWith(title: "Alert", message: "Enter account name")
            return

        }
        else if companySizeStr == "" {
            self.showAlertWith(title: "Alert", message: "Select account size")
            return

        }
        
//        callEmailValidationAPI()
        
        self.emailAPI()
        
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
    
    @IBAction func alreadyHaveAccBtnTapped(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
//    {
//    "emailAddress":"abc@xyz.com",
//    "primaryMobileNumber"':{{registeredmobilenumber}}
//    "address01":"dfg",
//    "address02":"hij",
//    "street":"dsnr",
//    "city":"hyd",
//    "state":"AP",
//    "landMark":"near",
//    "companyName":"xyz",
//    "companySize":"100"
//    }
    
    func showAlertWithEmail() {
        
        let alert = UIAlertController(title: "Success", message: "Your account created successfully please check your mail", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
            VC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(VC, animated: true)

        }))
                
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert1WithEmail() {
        
        let alert = UIAlertController(title: "Alert", message: "Please check email to verify account details", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
            VC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(VC, animated: true)

        }))
                
        self.present(alert, animated: true, completion: nil)
    }
    
    func getStatesAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + satesUrl
        
        loginIndividualServer.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
            
            let respVo:StatesRespVo = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.STATUS_MSG
            let statusCode = respVo.STATUS_CODE
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if statusCode == 200 {
                
                if status == "SUCCESS" {
                    if respVo.result?.count ?? 0>0
                    {
                    self.statesResultArr = respVo.result!
                    
                    let stateStr = respVo.result![0].stateName
                    self.stateIdValue = respVo.result![0]._id ?? ""
                    self.stateTF.text = stateStr
                    }
                    
                    for obj in self.statesResultArr {
                        let nameStr = obj.stateName
                        self.statesNamesArr.append(nameStr ?? "")
                        self.statesCodesArr.append(obj.stateCode ?? "")
                        let idStr = obj._id
                        self.statesIdsArr.append(idStr ?? "")
                    }
                    
                }else {
                    
                    //                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                }
                
                //                                    self.stateTF.optionArray = self.statesNamesArr
                //                                    self.stateTF.optionIds = self.statesIdsArr
                
            }
            else {
                
                
            }
                        
        }) { (error) in
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
        }
        
    }
    
    func emailAPI()  {
        
        let userDefaults = UserDefaults.standard
        let mobileNum = userDefaults.value(forKey: "mobileNum") as! String
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false

        let URLString_loginIndividual = Constants.BaseUrl + EmailValidationUrl
        
        let isManualStr:String? = isManual
        
        let params = ["latitude":self.latiValue,"longitude":self.longValue,"emailAddress":emailTF.text!,"primaryMobileNumber":mobileNum,"address01":address1TF.text!,"address02":address2TF.text!,"street":streetTF.text!,"city":cityTF.text!,"state":stateIdValue,"pinCode":"502032","landMark":landmarkTF.text!,"companyName":companyTF.text!,"companySize":companySizeStr,"signUpType": isManualStr ?? "Manual"]
        
        
   /*     let params = ["emailAddress":emailTF.text!,
                      "primaryMobileNumber":mobileNum,
                      "address01":address1TF.text!,
                      "address02":address2TF.text!,
                      "street":streetTF.text!,
                      "city":cityTF.text!,
                      "state":stateTF.text!,
                      "landMark":landmarkTF.text!,
                      "companyName":companyTF.text!,
                      "companySize":companySizeStr]
        */
        
        print(params)
        
        let postHeaders_IndividualLogin = ["":""]
        
        loginIndividualServer.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
            
            let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
                                    
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
                        
            if status == "SUCCESS" {
                print("Success")
                
                let opsResult = respVo.result?.ops
                
                let dict = opsResult?[0] as! NSDictionary
                
                if(statusCode == 200 ){
                    if messageResp == "Please check email to verify account details"{
                        self.showAlert1WithEmail()
                    }
                    else {
                        self.showAlertWithEmail()
                    }
                    
                }else if(statusCode == 204){
                    
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
    }
    
//        func callEmailValidationAPI() {
//
//            let userDefaults = UserDefaults.standard
//            let mobileNum = userDefaults.value(forKey: "mobileNum") as! String
//
//            activity.startAnimating()
//            self.view.isUserInteractionEnabled = false
//
//                    let URLString_loginIndividual = Constants.BaseUrl + EmailValidationUrl
//
////                    let params_CorporateREG = ["emailAddress":emailTF.text ?? "",
////                        "address01":address1TF.text ?? "",
////                        "address02":address2TF.text ?? "",
////                        "street":streetTF.text ?? "",
////                        "city":cityTF.text ?? "",
////                        "state":stateTF.text ?? "",
////                        "landMark":landmarkTF.text ?? "",
////                        "companySize":companySizeTF.text ?? "",
////                        "companyName":""]
//
//            let params_IndividualLogin = ["emailAddress":emailTF.text ?? "",
//                                    "primaryMobileNumber":mobileNum ?? "",
//                                    "address01":address1TF.text ?? "",
//                                    "address02":address2TF.text ?? "",
//                                    "street":streetTF.text ?? "",
//                                    "city":cityTF.text ?? "",
//                                    "state":stateTF.text ?? "",
//                                    "landMark":landmarkTF.text ?? "",
//                                    "companySize":companySizeTF.text ?? "",
//                                    "companyName":""]
//
//                        //print(params_CorporateREG)
//
//                        let postHeaders_IndividualLogin = ["":""]
//
//                        loginIndividualServer.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
//
//                            let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
//
//                            let status = respVo.status
//                            let messageResp = respVo.message
//                            let statusCode = respVo.statusCode
//
//                            activity.stopAnimating()
//                            self.view.isUserInteractionEnabled = true
//
//                            if status == "SUCCESS" {
//                                print("Success")
//
//                                let opsResult = respVo.result?.ops
//
//                                let dict = opsResult?[0] as! NSDictionary
//
//
//                                if(statusCode == 200 ){
//
//                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                                    let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
//                                                //      self.navigationController?.pushViewController(VC, animated: true)
//                                    VC.modalPresentationStyle = .fullScreen
//                                    self.present(VC, animated: true, completion: nil)
//
//                                }else if(statusCode == 204){
//
//                                }else{
//
//                                    self.showAlertWith(title: "Alert", message: messageResp ?? "")
//
//                                }
//
//                            }
//                            else {
//                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
//
//                            }
//
//                        }) { (error) in
//
//                            activity.stopAnimating()
//                            self.view.isUserInteractionEnabled = true
//                            print("Something Went To Wrong...PLrease Try Again Later")
//                        }
//
//                    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if textField == cityTF || textField == stateTF {
//
//                    let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
//                    let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
//                    let typedCharacterSet = CharacterSet(charactersIn: string)
//                    let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
//                    return alphabet
//
//          }
        
        let validString = NSCharacterSet(charactersIn: "!#$%^&*()+{}[]|\"<>,~`/:;?=\\¥'£•¢.₹@")
//        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if let sdcTextField = textField as? SDCTextField {
            
            if string.rangeOfCharacter(from: validString as CharacterSet) != nil
            {
//                print(range)
                return false
            }
            else
            {
                guard range.location == 0 else {
                    if textField == self.companyTF {
                        return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string) && string.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
                    }
                    return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
                }
                let newString = (sdcTextField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                                    
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }
//        else if(textField == mobileTF || textField == emailTF || textField == pwdTF || textField == confirmPwdTF) {
//
//            return true
//
//          }
        else{
            return true
          }
      }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func loadMapView() {
        
        DispatchQueue.main.async { [self] in
            
            self.chooseLocationBackView.removeFromSuperview()
            
            self.chooseLocationBackView = UIView()
            self.chooseLocationBackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.chooseLocationBackView)
            
            let camera = GMSCameraPosition.camera(withLatitude: self.latt, longitude: self.long, zoom: 12)
            self.mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.chooseLocationBackView.frame.size.height - 140), camera: camera)
            self.chooseLocationBackView.addSubview(self.mapView)
            
            mapView.delegate = self

//            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//            gestureRecognizer.delegate = self
//            self.mapView.addGestureRecognizer(gestureRecognizer)
            
            // Creates a marker in the center of the map.
//            let marker = GMSMarker()
//            marker.position = CLLocationCoordinate2D(latitude: self.latt, longitude: self.long)
//            marker.map = self.mapView
            
//            destiMarker = nil;
            
            destiMarker = GMSMarker()
            destiMarker.position = CLLocationCoordinate2D(latitude: self.latt, longitude: self.long);
            destiMarker.map = mapView;
            
            self.locationaSearchTF.frame = CGRect(x: 15, y: 25, width: self.view.frame.size.width - (30), height: 45)
            self.locationaSearchTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            self.locationaSearchTF.textColor = hexStringToUIColor(hex: "000000")
            chooseLocationBackView.addSubview(self.locationaSearchTF)
            
            self.locationaSearchTF.delegate = self
//            self.locationaSearchTF.text = self.addressStr
            self.locationaSearchTF.placeholder = "Serach"
            self.locationaSearchTF.backgroundColor = UIColor.lightGray
//                hexStringToUIColor(hex: "EEEEEE")
            self.locationaSearchTF.layer.cornerRadius = 3
            self.locationaSearchTF.clipsToBounds = true
            
            let searchPaddingView = UIView()
            searchPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: self.locationaSearchTF.frame.size.height)
            self.locationaSearchTF.leftView = searchPaddingView
            self.locationaSearchTF.leftViewMode = UITextField.ViewMode.always

            //Location TF
            
            let locationTxtView = UIView()
            locationTxtView.frame = CGRect(x: 0, y: self.chooseLocationBackView.frame.size.height - 140, width: self.chooseLocationBackView.frame.size.width, height: 140)
            locationTxtView.backgroundColor = .white
            self.chooseLocationBackView.addSubview(locationTxtView)

            self.locationaAddLabel.frame = CGRect(x: 15, y: 15, width: self.view.frame.size.width - (30), height: 60)
            self.locationaAddLabel.font = UIFont.init(name: kAppFontMedium, size: 13)
            self.locationaAddLabel.textColor = hexStringToUIColor(hex: "000000")
            locationTxtView.addSubview(self.locationaAddLabel)
            
//            self.locationaAddLabel.delegate = self
            self.locationaAddLabel.lineBreakMode = .byWordWrapping
            self.locationaAddLabel.numberOfLines = 3
            self.locationaAddLabel.text = self.addressStr
            self.locationaAddLabel.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
            self.locationaAddLabel.layer.cornerRadius = 3
            self.locationaAddLabel.clipsToBounds = true
            
            let productPaddingView = UIView()
            productPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: self.locationaAddLabel.frame.size.height)
//            self.locationaAddLabel.leftView = productPaddingView
//            self.locationaAddLabel.leftViewMode = UITextField.ViewMode.always
            self.locationaAddLabel.text = self.addressStr
                        
            let OKBtn = UIButton()
            OKBtn.frame = CGRect(x:self.chooseLocationBackView.frame.size.width - 160, y: self.locationaAddLabel.frame.size.height+self.locationaAddLabel.frame.origin.y+15, width: 100, height: 40)
//            OKBtn.backgroundColor = UIColor.orange
            OKBtn.addTarget(self, action: #selector(self.locationSubmitBtnTap), for: .touchUpInside)
            OKBtn.setTitle("Submit", for: .normal)
            OKBtn.setTitleColor(.white, for: .normal)
            OKBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            OKBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
            OKBtn.layer.cornerRadius = 5
            locationTxtView.addSubview(OKBtn)
            
            let cancelBtn = UIButton()
            cancelBtn.frame = CGRect(x:60, y: self.locationaAddLabel.frame.size.height+self.locationaAddLabel.frame.origin.y+15, width: 100, height: 40)
//            OKBtn.backgroundColor = UIColor.orange
            cancelBtn.addTarget(self, action: #selector(self.locationCancelBtnTap), for: .touchUpInside)
            cancelBtn.setTitle("Cancel", for: .normal)
            cancelBtn.setTitleColor(.white, for: .normal)
            cancelBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            cancelBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
            cancelBtn.layer.cornerRadius = 5
            locationTxtView.addSubview(cancelBtn)
        }
    }
    
    @objc func locationCancelBtnTap(sender: UIButton!){
        
//        locationAddLabel.text = addressStr
//
//        self.address1TF.text = self.AddOneStr
//        self.address2TF.text = self.AddTwoStr
//        self.streetTF.text = self.streetAdd
//        self.cityTF.text = self.cityStr
        locationTF.placeholder = ""
        self.chooseLocationBackView.removeFromSuperview()
//        self.locationTF.removeFromSuperview()
    }
    
    @objc func locationSubmitBtnTap(sender: UIButton!){
        
//        var Qheight = heightForView(text: addressStr, font: UIFont(name: kAppFontMedium, size: 15)!, width: self.view.frame.size.width - 130, xValue: 0, yValue: 0)
//
//        Qheight = Qheight + 30
        
//        if(Qheight <= 45){
//
//        }
        
//        else if(Qheight <= 90){
//            chooseLocheightConstant.constant = Qheight
//            overAllMainViewHeightConstant.constant = 933 + Qheight
            
//        }
        
        locationAddLabel.text = addressStr
        
        self.address1TF.text = self.AddOneStr
        self.address2TF.text = self.AddTwoStr
        self.streetTF.text = self.streetAdd
        self.cityTF.text = self.cityStr
        
        locationTF.placeholder = ""
        
        self.chooseLocationBackView.removeFromSuperview()
//        self.locationTF.removeFromSuperview()

    }
    func heightForView(text:String, font:UIFont, width:CGFloat , xValue:Int,  yValue:Int) -> CGFloat {
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    
    //MARK: - location delegate methods
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation :CLLocation = locations[0] as CLLocation
    
    if(isUpdateLocation){
        
        isUpdateLocation = false
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

    //    self.labelLat.text = "\(userLocation.coordinate.latitude)"
    //    self.labelLongi.text = "\(userLocation.coordinate.longitude)"

        latt = userLocation.coordinate.latitude
        long = userLocation.coordinate.longitude

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)

    //            self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                
                self.addressStr = "\(placemark.subLocality!) ,\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                
                var i = 0
                for obj in self.statesCodesArr {
                    var stateCode = obj
                    if stateCode == "TS"{
                        stateCode = "TG"
                    }
                    if stateCode == "\(placemark.administrativeArea ?? "")" {
                        self.stateTF.text = self.statesNamesArr[i]
                        self.stateIdValue = self.statesIdsArr[i]
                    }
                    i += 1
                }
                                                
                self.locationAddLabel.text = self.addressStr
                let city = placemark.locality ??  "" as String
                
                self.AddOneStr = "\(placemark.subLocality ?? "")"
                self.AddTwoStr = "\(placemark.thoroughfare ?? "")"
                
                self.localityAdd = "\(placemark.locality ?? "")"
                self.subLocalityAdd = "\(placemark.subThoroughfare ?? "")"
                self.streetAdd = "\(placemark.subAdministrativeArea ?? "")"
                
                self.address1TF.text = "\(placemark.subLocality ?? "")"
//                self.address2TF.text = "\(placemark.thoroughfare ?? "")"
                self.cityTF.text = "\(placemark.locality ?? "")"
                self.streetTF.text = "\(placemark.thoroughfare ?? "")"
                self.pinCodeTF.text = "\(placemark.postalCode ?? "")"
                
                self.latiValue = "\(userLocation.coordinate.latitude)"
                self.longValue = "\(userLocation.coordinate.longitude)"
                
                self.locationTF.placeholder = ""
                
                UserDefaults.standard.set(city, forKey: "pickedCity")
                UserDefaults.standard.synchronize()
                
                let camera = GMSCameraPosition.camera(withLatitude: self.latt, longitude: self.long, zoom: 12)
                self.mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.chooseLocationBackView.frame.size.height - 140), camera: camera)
                
                self.mapView.delegate = self
                
                self.getAddress(_postion: camera.target)

//                self.loadMapView()
            }
        }
    }
}
    
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error \(error)")
}
    
    func getCurrentLocation()  {
        
        locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()

           if CLLocationManager.locationServicesEnabled(){
               locationManager.startUpdatingLocation()
           }
    }
    
    // MARK: - MEthod to create mapview and its camera
    func updateLocationCoordinates(coordinates : CLLocationCoordinate2D)
    {
//        mapView.removeFromSuperview()
//        let camera = GMSCameraPosition(latitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 18) as GMSCameraPosition
//
//        mapView = GMSMapView(frame: CGRect(x: 0, y: 72*Constants.APDim_Y, width: self.view.frame.size.width, height: 200*Constants.APDim_Y), camera: camera)
//        mapView.isMyLocationEnabled = true
//        mapView.delegate = self
//        self.view.addSubview(mapView)
        
        loadMapView()
        
    }
    
    // MARK: - GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        addreslbl.text = ""
//        localityLbl.text = ""
        getAddress(_postion: position.target)
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        addreslbl.text = ""
//        localityLbl.text = ""
        
        destiMarker.position = position.target
        getAddress(_postion: position.target)
    }
    
    // MARK: - MEthod to get address
    func getAddress(_postion : CLLocationCoordinate2D)
    {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(_postion) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else {
            return
        }
            self.addressStr = lines.joined(separator: "\n")
//        self.localityLbl.text = address.subLocality
            
            let lastStr = address.lines?.last
            
            print(lastStr)
            
            let fullAdd = self.addressStr
            let fullAddArr = fullAdd.components(separatedBy: ",")
            
            if fullAddArr.count > 0 {
                self.AddOneStr = self.addressStr
                if fullAddArr.count > 2 {
                    self.AddTwoStr = fullAddArr[1]
                }
                if fullAddArr.count > 3 {
                    self.streetAdd = fullAddArr[2]
                }
                if fullAddArr.count > 4 {
                    self.cityStr = fullAddArr[3]
                }
            }
            if self.isGetAdd == false {
                self.isGetAdd = true
                self.locationAddLabel.text = self.addressStr
                self.address1TF.text = self.addressStr
                self.address2TF.text = fullAddArr[1]
                self.streetTF.text = fullAddArr[2]
                self.cityTF.text = fullAddArr[3]
            }
            
            self.locationaAddLabel.text = self.addressStr
            self.locationTF.placeholder = ""
//            self.locationAddLabel.text = self.addressStr
//        self.pinCodeStr = address.postalCode ?? ""
        self.latt = Double(_postion.latitude)
        self.long = Double(_postion.longitude)
        self.latiValue = "\(_postion.latitude)"
        self.longValue = "\(_postion.longitude)"
            
        }
    }

}

