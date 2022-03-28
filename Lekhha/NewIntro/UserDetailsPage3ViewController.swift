//
//  UserDetailsPage3ViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 12/03/22.
//

import UIKit
import ObjectMapper
import DropDown
import CoreLocation
import GoogleMaps
import GooglePlaces

class UserDetailsPage3ViewController: UIViewController,GoogleMapBtnCellDelegate,CLLocationManagerDelegate {
    
    let dropDown = DropDown()
    func didPressBackButton(str: String, pinCode: String, cityStr: String,stateStr:String,latitude:Double,longitude:Double) {
        userLocationLabel.text = str
        self.userLocationTF.placeholder=""
        pincodeTF.text = pinCode
        cityTF.text = cityStr
        stateTF.text = stateStr
        addressTextView.text = str
        self.latitude=latitude
        self.longitude=longitude
        print("str\(str)")
        print("pinCode\(pinCode)")
        print("cityStr\(cityStr)")
    }

    var location: CLLocation?
    var geocoder = GMSGeocoder()
    var locationgeocoder: CLGeocoder?
    var destiMarker = GMSMarker()
    var locationManager:CLLocationManager!
    var latt = Double()
    var long = Double()
    var addressStr = String()
    var isUpdateLocation = true
    
    var cityStr = ""
    var stateStr = ""
    var pincodeStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()

           if CLLocationManager.locationServicesEnabled(){
               locationManager.startUpdatingLocation()
           }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getStatesAPI()
        self.addressTextView.layer.borderWidth=1
        self.addressTextView.layer.borderColor=UIColor.lightGray.cgColor
        if accountExists==true
        {
            let accountObject=signUpUserAccountDetailArray[0]
            self.userLocationLabel.text=accountObject.address
            self.addressTextView.text=accountObject.address
            self.stateTF.text=accountObject.state
            self.cityTF.text=accountObject.city
            self.pincodeTF.text=accountObject.pincode
            self.userLocationBtn.isUserInteractionEnabled=false
            self.userLocationTF.isUserInteractionEnabled=false
            self.stateTF.isUserInteractionEnabled=false
            self.addressTextView.isUserInteractionEnabled=false
            self.stareBtn.isUserInteractionEnabled=false
            self.cityTF.isUserInteractionEnabled=false
            self.pincodeTF.isUserInteractionEnabled=false
            self.cityTF.textColor=UIColor.lightGray
            self.userLocationLabel.textColor=UIColor.lightGray
            self.addressTextView.textColor=UIColor.lightGray
            self.stateTF.textColor=UIColor.lightGray
            self.cityTF.textColor=UIColor.lightGray
            self.pincodeTF.textColor=UIColor.lightGray
            self.userLocationTF.placeholder=""
            
        }
        else
        {
            self.userLocationBtn.isUserInteractionEnabled=true
            self.addressTextView.isUserInteractionEnabled=true
            self.userLocationTF.isUserInteractionEnabled=false
            self.stateTF.isUserInteractionEnabled=false
            self.stareBtn.isUserInteractionEnabled=true
            self.cityTF.isUserInteractionEnabled=true
            self.pincodeTF.isUserInteractionEnabled=true
            self.cityTF.textColor=UIColor.black
            self.userLocationLabel.textColor=UIColor.black
            self.addressTextView.textColor=UIColor.black
            self.stateTF.textColor=UIColor.black
            self.cityTF.textColor=UIColor.black
            self.pincodeTF.textColor=UIColor.black
        }
    }
    @IBOutlet var userLocationTF: UITextField!
    
    @IBOutlet var userLocationBtn: UIButton!
    @IBOutlet var userLocationLabel: UILabel!
    @IBAction func onClickUserLocationas(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "GoogleMapVC") as! GoogleMapVC
        VC.delegate = self
        VC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBOutlet var addressTF: UITextField!

    @IBOutlet var addressTextView: UITextView!
    var statesResultArr = [StatesResultVo]()
    var statesNamesArr = [String]()
    var statesIdsArr = [String]()
    var statesCodesArr = [String]()
    var stateIdValue = String()
    @IBOutlet var stareBtn: UIButton!
    @IBOutlet var stateTF: UITextField!
    @IBAction func onClickStateDropDown(_ sender: Any) {
        dropDown.dataSource = self.statesNamesArr
        dropDown.anchorView = sender as! AnchorView //5
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
          guard let _ = self else { return }
//              sender.setTitle(item, for: .normal) //9
            self?.stateTF.text = "\(item)"
            let stateStr:String = self?.statesIdsArr[index] ?? ""
            self?.stateIdValue = stateStr
        }
    }
    @IBOutlet var cityTF: UITextField!
    @IBOutlet var pincodeTF: UITextField!
   
    @IBAction func onClickBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    var companyName=String()
    var companySize=String()
    var latitude=Double()
    var longitude=Double()
    @IBAction func onClickFinishButton(_ sender: Any) {
        if accountExists==false
        {
        if userLocationLabel.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please enter user location")
            return
        }
        else if addressTextView.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please enter user location")
            return
        }
        else if stateTF.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please enter user state")
            return
        }
        else if cityTF.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please enter user city")
            return
        }
        else if pincodeTF.text==""
        {
            self.showAlertWith(title: "Alert", message: "Please enter user pincode")
            return
        }
        else
        {
            
        self.getConsumerAccountDetails()
            }
        }
            else
            {
                let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                let VC = storyBoard.instantiateViewController(withIdentifier: "PhoneSignInViewController") as! PhoneSignInViewController
                    
                self.navigationController?.pushViewController(VC, animated: true)
            }
        
    }
    var introService=ServiceController()
    
    func getConsumerAccountDetails()
    {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + consumerAccountDetails_add
        let params = ["emailId":userEmailID,
                      "address":self.addressTextView.text!,
                      "city":self.cityTF.text!,
                      "state":self.stateTF.text!,
                      "companyName":companyName,
                      "companySize":companySize,
                      "signUpType":signUpTypeGlobal,
                      "latitude":latitude,
                      "longitude":longitude,"pinCode":pincodeTF.text!] as [String : Any]
        let postHeaders_IndividualLogin = ["":""]
        
        introService.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in

                            let respVo:ShoppingCartRespo = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
                                let VC = storyBoard.instantiateViewController(withIdentifier: "PhoneSignInViewController") as! PhoneSignInViewController
                                    
                                self.navigationController?.pushViewController(VC, animated: true)
                            }else {
                                self.showAlertWith(title: "Alert", message: messageResp ?? "")
                            }
                            
                        }) { (error) in
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("Something Went To Wrong...PLrease Try Again Later")
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
    
    func getStatesAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + satesUrl
        
        introService.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
            
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
    //MARK: - location delegate methods
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation :CLLocation = locations[0] as CLLocation
    
    if(isUpdateLocation){
        
        isUpdateLocation = false
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

    //    self.labelLat.text = "\(userLocation.coordinate.latitude)"
    //    self.labelLongi.text = "\(userLocation.coordinate.longitude)"

        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude

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
                
                self.addressStr = "\(placemark.subLocality!),\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                
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
                                                
                self.userLocationLabel.text = self.addressStr
                self.addressTextView.text = self.addressStr
                
//                if addressStr != "" {
//                    self.addressTextView.text = "\(addressStr)"
//                }
                
//                let city = placemark.locality ??  "" as String
                
//                self.AddOneStr = "\(placemark.subLocality ?? "")"
//                self.AddTwoStr = "\(placemark.thoroughfare ?? "")"
//
//                self.localityAdd = "\(placemark.locality ?? "")"
//                self.subLocalityAdd = "\(placemark.subThoroughfare ?? "")"
//                self.streetAdd = "\(placemark.subAdministrativeArea ?? "")"
                
                //self.address1TF.text = "\(placemark.subLocality ?? "")"
//                self.address2TF.text = "\(placemark.thoroughfare ?? "")"
                self.cityTF.text = "\(placemark.locality ?? "")"
                //self.streetTF.text = "\(placemark.thoroughfare ?? "")"
                self.pincodeTF.text = "\(placemark.postalCode ?? "")"
                
                self.latitude = userLocation.coordinate.latitude
                self.longitude = userLocation.coordinate.longitude
                self.userLocationTF.placeholder = ""
        }
    }
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
        
//        loadMapView()
        
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
//            self.AddressLabel.text = self.addressStr
        self.latt = Double(_postion.latitude)
        self.long = Double(_postion.longitude)
            
        }
    }
    
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error \(error)")
}
}
