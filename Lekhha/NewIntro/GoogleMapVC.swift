//
//  GoogleMapVC.swift
//  RiteBuyECOmmerceAPP
//
//  Created by USM on 25/01/22.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import ObjectMapper

protocol GoogleMapBtnCellDelegate {
    
    func didPressBackButton(str: String,pinCode:String,cityStr:String,stateStr:String, latitude:Double,longitude:Double)
}
class GoogleMapVC: UIViewController,UINavigationControllerDelegate, UITextFieldDelegate,CLLocationManagerDelegate,GMSMapViewDelegate, UIGestureRecognizerDelegate,GMSAutocompleteViewControllerDelegate {
    
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var AddressLabel: UILabel!
    
    @IBOutlet weak var submitBtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addLabelHeight: NSLayoutConstraint!
    
    var location: CLLocation?
    var geocoder = GMSGeocoder()
    var locationgeocoder: CLGeocoder?
    var destiMarker = GMSMarker()
    var locationManager:CLLocationManager!
    var latt = Double()
    var long = Double()
    var addressStr = String()
    var isUpdateLocation = true
    
    var serviceVC = ServiceController()
    var localityStr = ""
    var isValid:Bool = false
    
    var pinCodeStr = ""
    var stateStr = ""
    var cityStr = ""
    
    var statesResultArr = [StatesResultVo]()
    var statesNamesArr = [String]()
    var statesIdsArr = [String]()
    var statesCodesArr = [String]()
    var stateIdValue = String()
    var isManual = ""
    var isGetAdd:Bool = false
    
    var delegate: GoogleMapBtnCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTF.text = cityStr
        self.localityStr = cityStr
        
        searchBgView.layer.borderColor = UIColor.gray.cgColor
        searchBgView.layer.borderWidth = 0.5
        searchBgView.layer.cornerRadius = 3
        searchBgView.clipsToBounds = true
        
        googleMapView.delegate = self
        
        locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()

           if CLLocationManager.locationServicesEnabled(){
               locationManager.startUpdatingLocation()
           }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        getStatesAPI()
    }
    
    func getStatesAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let URLString_loginIndividual = Constants.BaseUrl + satesUrl
        
        serviceVC.requestGETURL(strURL:URLString_loginIndividual, success: {(result) in
            
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
                        
//                        let stateStr = respVo.result![0].stateName
                        self.stateIdValue = respVo.result![0]._id ?? ""
//                        self.stateTF.text = stateStr
                    }
                    for obj in self.statesResultArr {
                        let nameStr = obj.stateName
                        self.statesNamesArr.append(nameStr ?? "")
                        self.statesCodesArr.append(obj.stateCode ?? "")
                        let idStr = obj._id
                        self.statesIdsArr.append(idStr ?? "")
                    }
                    
                }else {
                    
                }
            }
            else {
                
                
            }
            
        }) { (error) in
            
            activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("Something Went To Wrong...PLrease Try Again Later")
        }
        
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
            self.AddressLabel.text = self.addressStr
            
            self.pinCodeStr = placemark?.postalCode ?? ""
            var i = 0
            for obj in self.statesCodesArr {
                var stateCode = obj
                if stateCode == "TS"{
                    stateCode = "TG"
                }
                if stateCode == "\(placemark?.administrativeArea ?? "")" {
                    self.stateStr = self.statesNamesArr[i]
                    self.stateIdValue = self.statesIdsArr[i]
                }
                i += 1
            }
//            self.stateStr = placemark?.subAdministrativeArea ?? ""
            self.cityStr = placemark?.locality ?? ""
           
            self.localityStr = placemark?.locality ?? ""
            self.searchTF.text = placemark?.locality ?? ""
            
            self.latt = place.coordinate.latitude
            self.long = place.coordinate.longitude
            
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
    
    
    func loadMapView(){
        
        let camera = GMSCameraPosition.camera(withLatitude: self.latt, longitude: self.long, zoom: 12)
//        let map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        self.addressMapView.addSubview(map)
        self.googleMapView.camera = camera
        googleMapView.delegate = self
        
        destiMarker = GMSMarker()
        destiMarker.position = CLLocationCoordinate2D(latitude: self.latt, longitude: self.long);
        destiMarker.map = googleMapView;
        
        self.getAddress(_postion: camera.target)
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
                
                                                
                self.AddressLabel.text = self.addressStr
                var i = 0
                for obj in self.statesCodesArr {
                    var stateCode = obj
                    if stateCode == "TS"{
                        stateCode = "TG"
                    }
                    if stateCode == "\(placemark.administrativeArea ?? "")" {
                        self.stateStr = self.statesNamesArr[i]
                        self.stateIdValue = self.statesIdsArr[i]
                    }
                    i += 1
                }
                
                self.pinCodeStr = placemark.postalCode ?? ""
//                self.stateStr = placemark.subAdministrativeArea ?? ""
                self.cityStr = placemark.locality ?? ""
                
//                UserDefaults.standard.set(city, forKey: "pickedCity")
//                UserDefaults.standard.synchronize()
                
                let camera = GMSCameraPosition.camera(withLatitude: self.latt, longitude: self.long, zoom: 12)
                self.googleMapView.camera = camera
//                let map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//                self.addressMapView.addSubview(map)
                self.googleMapView.delegate = self
                self.destiMarker = GMSMarker()
                self.destiMarker.position = CLLocationCoordinate2D(latitude: self.latt, longitude: self.long);
                self.destiMarker.map = self.googleMapView
                
                self.getAddress(_postion: camera.target)

//                self.loadMapView()
            }
        }
    }
}
    
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error \(error)")
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
            self.AddressLabel.text = self.addressStr
        self.latt = Double(_postion.latitude)
        self.long = Double(_postion.longitude)
            
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
                
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
                
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
//        autocompleteController.inputView?.textInputMode = ""
//        present(autocompleteController, animated: true, completion: nil)
        
        present(autocompleteController, animated: true) {
            let views = autocompleteController.view.subviews
            let subviewsOfSubview = views.first!.subviews
            let subOfNavTransitionView = subviewsOfSubview[1].subviews
            let subOfContentView = subOfNavTransitionView[2].subviews
            let searchBar = subOfContentView[0] as! UISearchBar
            searchBar.text = self.searchTF.text ?? ""
            searchBar.delegate?.searchBar?(searchBar, textDidChange: "Kolkata")
        }
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        

        if self.delegate != nil {
            
            self.delegate?.didPressBackButton(str: self.addressStr, pinCode: pinCodeStr, cityStr: self.cityStr, stateStr: stateStr,latitude: latt,longitude: long)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Alert controller
    func showAlertWith(title:String,message:String)
        {
            let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
            //to change font of title and message.
            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)]
            
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
    
    
/*    // MARK: Add Personal Info API Call
    func post_AddAddress_API_Call() {
        
        var urlStr:String = ""
        var params = [String:Any]()
        
        if let userId = UserDefaults.standard.object(forKey: "userId") {
            let userIdStr = userId as! String
            activity.startAnimating()
            self.view.isUserInteractionEnabled = false
            urlStr = baseUrl + "customer/add_customer_address"
            params = ["customerId":userIdStr,
                      "addressType":"default",
                      "address":self.AddressLabel.text ?? ""
            ]
            let postHeaders_IndividualLogin = ["":""]
            
            serviceVC.requestPOSTURL(strURL: urlStr as NSString, postParams: params as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                let respVo:OtpForForgotPassword = Mapper().map(JSON: result as! [String : Any])!
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                DispatchQueue.main.async {
                    let status = respVo.STATUS_CODE
                    let message = respVo.message
                    let statusMsg = respVo.STATUS_MSG
                    if status == 200 {
                        
                        if statusMsg == "SUCCESS" {
                            self.view.makeToast(message)
                            
                        }
                    }
                    else {
                        self.view.makeToast(message)
                    }
                }
                
            }) { (error) in
                activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.view.makeToast("Something went to wrong...please try again later")
            }
        }
    }
    */
    
}
