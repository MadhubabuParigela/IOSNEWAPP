//
//  VendorMyAccountsViewController.swift
//  LekhaLatest
//
//  Created by USM on 20/05/21.
//

import UIKit
import ObjectMapper
import GoogleMaps
import CoreLocation
import GooglePlaces

class VendorMyAccountsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate,GMSAutocompleteViewControllerDelegate,GMSMapViewDelegate {
    
    @IBOutlet weak var mapBackView: UIView!
    
    var chooseLocationBackView = UIView()
     var locationTF = UITextField()
    var accountID = String()
    var vicinityVal = 0
    var soonToExpire = 0

    @IBOutlet weak var profileImgBtn: UIButton!
    
    @IBAction func editBtnTapped(_ sender: Any) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)

    }
    @IBOutlet weak var editUpdateBtn: UIButton!
    
    @IBAction func editUpdateBtnTapped(_ sender: UIButton) {
        
        if(sender.currentTitle == "EDIT"){
            
            firstNameTF.isUserInteractionEnabled = true
            lastNameTF.isUserInteractionEnabled = true
            emailIDTF.isUserInteractionEnabled = true
            profileImgBtn.isUserInteractionEnabled = true
            setVicinityTF.isUserInteractionEnabled = true
            soonToExpireTF.isUserInteractionEnabled = true

            firstNameTF.backgroundColor = UIColor.clear
            lastNameTF.backgroundColor = UIColor.clear
            emailIDTF.backgroundColor = UIColor.clear
            setVicinityTF.backgroundColor = UIColor.clear
            soonToExpireTF.backgroundColor = UIColor.clear
            
            vendorLocEditBtn.isHidden = false
            vendorLocEditBtn.isUserInteractionEnabled = true
            
//          firstNameTF.becomeFirstResponder()
            sender.setTitle("UPDATE", for: .normal)
            
        }else{
            
            sender.setTitle("EDIT", for: .normal)
            
            if(firstNameTF.text == ""){
                self.showAlertWith(title: "Alert", message: "Enter your first name")
                return
                
            }else if(lastNameTF.text == ""){
                self.showAlertWith(title: "Alert", message: "Enter your last name")
                return
                
            }
//            else if(mobileNumTF.text == ""){
//                self.showAlertWith(title: "Alert", message: "Enter your last phone number")
//                return
//
//            }
            else if(setVicinityTF.text == ""){
                    self.showAlertWith(title: "Alert", message: "Enter vicinity")
                return
                
            }else if(soonToExpireTF.text == ""){
                self.showAlertWith(title: "Alert", message: "Enter soon to expire")
                return
                
            }

            self.updateMyAccDetailsAPI()

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
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneBtnTap(_ sender: Any) {
        
        if(firstNameTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter your first name")
            return
            
        }else if(lastNameTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter your last name")
            return
            
        }else if(mobileNumTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter your last phone number")
            return
            
        }else if(setVicinityTF.text == ""){
                self.showAlertWith(title: "Alert", message: "Enter vicinity")
            return
            
        }else if(soonToExpireTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter soon to expire")
            return
            
        }

        self.updateMyAccDetailsAPI()
        
    }
    
    var hiddenBtn = UIButton()
    var updatePwdView: UIView!
        
        let currentPwdTF = UITextField()
        let newPwdTF = UITextField()
        let confirmPwdTF = UITextField()
    
    var location: CLLocation?
    var geocoder = GMSGeocoder()
    var locationgeocoder: CLGeocoder?
    let destiMarker = GMSMarker()
    var locationManager:CLLocationManager!
    var latt = Double()
    var long = Double()
    var addressStr = String()
    var mapView = GMSMapView()

    @IBAction func profileImgBtnTap(_ sender: Any) {
        
        loadActionSheet()
        
//        let image = UIImagePickerController()
//                image.delegate=self
//                image.sourceType = .photoLibrary
//                image.allowsEditing=false
//                self.present(image, animated: true){
//
//                }
        
    }
    
    func loadActionSheet()  {
        
        let alert = UIAlertController(title: "Image Selection", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.loadCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            self.loadGallery()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
        if Constants.IS_IPAD {
                        let popoverPresentationController = alert.popoverPresentationController
                        popoverPresentationController?.sourceView = self.view
                        popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width/3 , y: self.view.frame.height/3, width: 0, height: 0)
                        popoverPresentationController?.permittedArrowDirections = .down
                    }

    }
    
    func loadGallery() {
        
        let image = UIImagePickerController()
                image.delegate=self
                image.sourceType = .photoLibrary
                image.allowsEditing=false
                self.present(image, animated: true){

                }
    }
    
    func loadCamera() {
        
        let image = UIImagePickerController()
                image.delegate=self
                image.sourceType = .camera
                image.allowsEditing=false
                self.present(image, animated: true){

                }
    }

    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var mobileNumTF: UITextField!
    @IBOutlet weak var emailIDTF: UITextField!
    
    @IBOutlet weak var setVicinityTF: UITextField!
    @IBOutlet weak var soonToExpireTF: UITextField!
    
    @IBAction func changePwdBtnTap(_ sender: Any) {
        changePwdView()
    }
    
    var myAccServerCntrl = ServiceController()
    var firstNameStr = String()
    var lastNameStr = String()
    var mobileNumStr = String()
    var profileBase64Img = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileBase64Img = ""
        
        let defaults = UserDefaults.standard
        accountID = (defaults.string(forKey: "accountId") ?? "")
        
        animatingView()
        getMyAccDetails()


        // Do any additional setup after loading the view.
    }
    
    @IBAction func aboutUsBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
              let VC = storyBoard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsViewController
              VC.modalPresentationStyle = .fullScreen
//              self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)


    }
    
    @IBAction func logoutBtnTap(_ sender: Any) {
        logOutShowAlertWith(title: "Alert", message: "Are you sure to logout ?")

    }
    
    func logout()  {
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(false, forKey: "isLoggedIn")
        userDefaults.synchronize()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
        VC.modalPresentationStyle = .fullScreen
       // self.viewCntrlObj.present(VC, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
//    func showAlertWith(title:String,message:String)
//        {
//            let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
//            //to change font of title and message.
//            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
//            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
//
//            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
//            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
//            alertController.setValue(titleAttrString, forKey: "attributedTitle")
//            alertController.setValue(messageAttrString, forKey: "attributedMessage")
//
//            let alertAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
//                alertController.dismiss(animated: true, completion: nil)
//            })
//
//        let alertAction1 = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
//            self.logout()
//
//        })
//
//    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
//    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
//            alertController.addAction(alertAction)
//           alertController.addAction(alertAction1)
//
//        self.present(alertController, animated: true, completion: nil)
//
//        }
    
    @IBAction func privacyPolicyBtnTap(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
              let VC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyViewController
              VC.modalPresentationStyle = .fullScreen
        VC.headerStr = "Privacy Policy"
        VC.urlStr = "http://35.154.239.192:4500/Misc/Files/pagecontent/privacypolicy"
//              self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: true)

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
    
    func changePwdView()  {
        
//        hiddenBtn = UIButton()
        hiddenBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        hiddenBtn.backgroundColor = UIColor.black
        hiddenBtn.alpha = 0.5
        self.view.addSubview(hiddenBtn)
        
        updatePwdView = UIView()
        updatePwdView.frame = CGRect(x: 20, y: self.view.frame.size.height/2-(225), width: self.view.frame.size.width - (40), height: 450)
        updatePwdView.backgroundColor = UIColor.white
        updatePwdView.layer.cornerRadius = 10
        updatePwdView.layer.masksToBounds = true
        self.view.addSubview(updatePwdView)
        
        //Change Pwd Lbl
        
        let changePwdLbl = UILabel()
        changePwdLbl.frame = CGRect(x: 10, y: 5, width: updatePwdView.frame.size.width - (60), height: 40)
        changePwdLbl.text = "      Change Password"
        changePwdLbl.textAlignment = NSTextAlignment.center
        changePwdLbl.font = UIFont.init(name: kAppFontMedium, size: 14)
        changePwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(changePwdLbl)
        
        //Cancel Btn
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: updatePwdView.frame.size.width - 40, y: 5, width: 40, height: 40)
        cancelBtn.setImage(UIImage.init(named: "cancel"), for: UIControl.State.normal)
        cancelBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        updatePwdView.addSubview(cancelBtn)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnTap), for: .touchUpInside)
        
        //Seperator Line Lbl
        
        let seperatorLine = UILabel()
        seperatorLine.frame = CGRect(x: 0, y: changePwdLbl.frame.origin.y+changePwdLbl.frame.size.height, width: updatePwdView.frame.size.width , height: 1)
        seperatorLine.backgroundColor = hexStringToUIColor(hex: "f2f2f2")
        updatePwdView.addSubview(seperatorLine)
        
        //Current Pwd Lbl

        let currentPwdLbl = UILabel()
        currentPwdLbl.frame = CGRect(x: 10, y: seperatorLine.frame.origin.y+seperatorLine.frame.size.height+15, width: updatePwdView.frame.size.width - (20), height: 20)
        currentPwdLbl.text = "Current Password"
        currentPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        currentPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(currentPwdLbl)

        //Current Pwd TF

        currentPwdTF.frame = CGRect(x: 10, y: currentPwdLbl.frame.origin.y+currentPwdLbl.frame.size.height+5, width: updatePwdView.frame.size.width - (20), height: 45)
        currentPwdTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        currentPwdTF.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(currentPwdTF)

        currentPwdTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        currentPwdTF.layer.cornerRadius = 3
        currentPwdTF.clipsToBounds = true

        let currentPwdPaddingView = UIView()
        currentPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: currentPwdTF.frame.size.height)
        currentPwdTF.leftView = currentPwdPaddingView
        currentPwdTF.leftViewMode = UITextField.ViewMode.always
        
        //New Pwd Lbl

        let newPwdLbl = UILabel()
        newPwdLbl.frame = CGRect(x: 10, y: currentPwdTF.frame.origin.y+currentPwdTF.frame.size.height+15, width: updatePwdView.frame.size.width - (20), height: 20)
        newPwdLbl.text = "New Password"
        newPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        newPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(newPwdLbl)

        //New Pwd TF

        newPwdTF.frame = CGRect(x: 10, y: newPwdLbl.frame.origin.y+newPwdLbl.frame.size.height+5, width: updatePwdView.frame.size.width - (20), height: 45)
        newPwdTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        newPwdTF.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(newPwdTF)

        newPwdTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        newPwdTF.layer.cornerRadius = 3
        newPwdTF.clipsToBounds = true

        let newPwdPaddingView = UIView()
        newPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: newPwdTF.frame.size.height)
        newPwdTF.leftView = newPwdPaddingView
        newPwdTF.leftViewMode = UITextField.ViewMode.always

        //Confirm Pwd Lbl

        let confirmPwdLbl = UILabel()
        confirmPwdLbl.frame = CGRect(x: 10, y: newPwdTF.frame.origin.y+newPwdTF.frame.size.height+15, width: updatePwdView.frame.size.width - (20), height: 20)
        confirmPwdLbl.text = "Confirm Password"
        confirmPwdLbl.font = UIFont.init(name: kAppFontMedium, size: 12)
        confirmPwdLbl.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(confirmPwdLbl)

        //New Pwd TF

        confirmPwdTF.frame = CGRect(x: 10, y: confirmPwdLbl.frame.origin.y+confirmPwdLbl.frame.size.height+5, width: updatePwdView.frame.size.width - (20), height: 45)
        confirmPwdTF.font = UIFont.init(name: kAppFontMedium, size: 13)
        confirmPwdTF.textColor = hexStringToUIColor(hex: "232c51")
        updatePwdView.addSubview(confirmPwdTF)

        confirmPwdTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        confirmPwdTF.layer.cornerRadius = 3
        confirmPwdTF.clipsToBounds = true

        let confirmPwdPaddingView = UIView()
        confirmPwdPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: confirmPwdTF.frame.size.height)
        confirmPwdTF.leftView = confirmPwdPaddingView
        confirmPwdTF.leftViewMode = UITextField.ViewMode.always
        
        let updateBtn = UIButton()
        updateBtn.frame = CGRect(x:updatePwdView.frame.size.width/2 - (85), y: confirmPwdTF.frame.origin.y+confirmPwdTF.frame.size.height+40, width: 170, height: 40)
        updateBtn.setTitle("Update Password", for: UIControl.State.normal)
        updateBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
        updateBtn.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: UIControl.State.normal)
        updateBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
        updateBtn.addTarget(self, action: #selector(updateBtnTap), for: .touchUpInside)

        updatePwdView.addSubview(updateBtn)

        updateBtn.layer.cornerRadius = 3
        updateBtn.layer.masksToBounds = true
        
    }
    
    @objc func updateBtnTap(sender: UIButton!) {
        
        let strLength = newPwdTF.text?.count ?? 0
        
        if(currentPwdTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter current password")

        }
        else if(newPwdTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter new password")

        }
        else if(strLength < 6){
            self.showAlertWith(title: "Alert", message: "Password should not be less than 6 chartacters")
            return

        }
        else if(strLength > 12){
            self.showAlertWith(title: "Alert", message: "Password should not be more than 12 chartacters")
            return

        }
        else if(confirmPwdTF.text == ""){
            self.showAlertWith(title: "Alert", message: "Enter confirm password")

        }
        else if(newPwdTF.text != confirmPwdTF.text)
        {
            self.showAlertWith(title: "Alert", message: "Password and confirm password do not match")
            return
        }

        updatePasswordAPICall()
        
    }
    
    func loadMapView() {
        
        DispatchQueue.main.async {
            
            self.chooseLocationBackView.removeFromSuperview()
            
            self.chooseLocationBackView = UIView()
            self.chooseLocationBackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.chooseLocationBackView)
            
            let camera = GMSCameraPosition.camera(withLatitude: self.latt, longitude: self.long, zoom: 6)
            self.mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.chooseLocationBackView.frame.size.height - 140), camera: camera)
            self.chooseLocationBackView.addSubview(self.mapView)
            
//            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//            gestureRecognizer.delegate = self
//            self.mapView.addGestureRecognizer(gestureRecognizer)
            
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: self.latt, longitude: self.long)
            marker.map = self.mapView
            
            //Location TF
            
            let locationTxtView = UIView()
            locationTxtView.frame = CGRect(x: 0, y: self.chooseLocationBackView.frame.size.height - 140, width: self.chooseLocationBackView.frame.size.width, height: 140)
            locationTxtView.backgroundColor = .white
            self.chooseLocationBackView.addSubview(locationTxtView)

            self.locationTF = UITextField()
            self.locationTF.frame = CGRect(x: 15, y: 15, width: self.view.frame.size.width - (30), height: 45)
            self.locationTF.font = UIFont.init(name: kAppFontMedium, size: 13)
            self.locationTF.textColor = hexStringToUIColor(hex: "000000")
            locationTxtView.addSubview(self.locationTF)
            
            self.locationTF.delegate = self
            self.locationTF.text = self.addressStr

            self.locationTF.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
            self.locationTF.layer.cornerRadius = 3
            self.locationTF.clipsToBounds = true
            
            let productPaddingView = UIView()
            productPaddingView.frame = CGRect(x: 0, y: 0, width: 15, height: self.locationTF.frame.size.height)
            self.locationTF.leftView = productPaddingView
            self.locationTF.leftViewMode = UITextField.ViewMode.always
            
            self.locationTF.text = self.addressStr
            
            let OKBtn = UIButton()
            OKBtn.frame = CGRect(x:self.chooseLocationBackView.frame.size.width/2-(50), y: self.locationTF.frame.size.height+self.locationTF.frame.origin.y+15, width: 100, height: 40)
//            OKBtn.backgroundColor = UIColor.orange
            OKBtn.addTarget(self, action: #selector(self.locationSubmitBtnTap), for: .touchUpInside)
            OKBtn.setTitle("Submit", for: .normal)
            OKBtn.setTitleColor(.white, for: .normal)
            OKBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 12)
            OKBtn.backgroundColor = hexStringToUIColor(hex: "105fef")
            OKBtn.layer.cornerRadius = 5
            locationTxtView.addSubview(OKBtn)

        }
    }
    
    @objc func locationSubmitBtnTap(sender: UIButton!){
        
//        chooseLocationTF.text = addressStr
        
        self.chooseLocationBackView.removeFromSuperview()
        self.locationTF.removeFromSuperview()

    }

    
    func updatePasswordAPICall() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String

//http://35.154.239.192:4500/endusers/changepassword
        
                let URLString_loginIndividual = Constants.BaseUrl + ChangePwdUrl
        
                    let params_IndividualLogin = [
                        "userId" : userID,
                        "currentPassword":currentPwdTF.text ?? "",
                        "password":newPwdTF.text ?? "",
                    ]
                
//          print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
                    myAccServerCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
                        let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        if status == "SUCCESS" {

                            self.showAlertWith(title: "Success", message: "Password updated successfully")

                        }
                        else {
                            self.showAlertWith(title: "Alert", message: messageResp ?? "")

                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true

                        }
                        
                    }) { (error) in
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        print("Something Went To Wrong...PLrease Try Again Later")
                    }
        
                }
    
    @objc func cancelBtnTap(sender: UIButton!){
        
        hiddenBtn.removeFromSuperview()
        updatePwdView.removeFromSuperview()

    }

    func logOutShowAlertWith(title:String,message:String)
        {
            let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
            //to change font of title and message.
            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
            alertController.setValue(titleAttrString, forKey: "attributedTitle")
            alertController.setValue(messageAttrString, forKey: "attributedMessage")
            
            let alertAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
            })
        
        let alertAction1 = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.logout()
           
        })

    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
           alertController.addAction(alertAction1)

        self.present(alertController, animated: true, completion: nil)
        
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
    
    //Delegate Method in UIImage Picker Controller :
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let imagePick = info[UIImagePickerController.InfoKey.originalImage] {
       profileImgView.image = imagePick as? UIImage
       
       let imageData: Data? = (imagePick as! UIImage).jpegData(compressionQuality: 0.4)
       let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""

       profileBase64Img = imageStr as String
       
//                profileImgBtn.setImage(imagePick as? UIImage, for: UIControl.State.normal)
}
    else{

    //Error Message
    }
    self.dismiss(animated: true, completion: nil)
}
    
    func upateMyAccDetails()  {

        let userDefaults = UserDefaults.standard
        let userID = userDefaults.value(forKey: "userID") as! String
        print(userID)
        
//        userDefaults.set(fieldname, forKey: "accountEmail")
        
        let emailStr = userDefaults.value(forKey: "accountEmail") as! String
            
//      let URLString_loginIndividual = MyAccImgUrl  + userID
        
        editBtn.isHidden = true

        let imageStr = VendorMyAccImgUrl + userID

                if !imageStr.isEmpty {

                    let imgUrl:String = imageStr

                    let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")
                    
                    let accountID = (userDefaults.string(forKey: "accountId") ?? "")

                    let imggg = VendorMyAccImgUrl + accountID
                    let url = URL.init(string: imggg)
                    
                    editBtn.isHidden = true

//                    profileImgView.sd_setImage(with: url , placeholderImage: UIImage(named: "add photo"))
                    
                    profileImgView.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)
                    
                    profileImgView.contentMode = UIView.ContentMode.scaleAspectFill

                }
                else {
                    
                    editBtn.isHidden = false
                    profileImgView.image = UIImage(named: "no_image")
                    
                }
        
        print(latt,long)
        
        let camera = GMSCameraPosition.camera(withLatitude: self.latt, longitude: self.long, zoom: 12)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: mapBackView.frame.size.width, height: mapBackView.frame.size.height), camera: camera)
        mapBackView.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.latt, longitude: self.long)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
        marker.map = mapView

        firstNameTF.text = firstNameStr as String
        lastNameTF.text = lastNameStr as String
        mobileNumTF.text = mobileNumStr as String
        emailIDTF.text = emailStr as String
        soonToExpireTF.text = "\(soonToExpire)"
        setVicinityTF.text = "\(vicinityVal)"
        
    }
    
    @IBOutlet weak var vendorLocEditBtn: UIButton!
    
    func getMyAccDetails() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = true
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        
//        userID = "5f6d80e4950eaf1c4bfea973"
            
                    let URLString_loginIndividual = Constants.BaseUrl + VendorMyAccountUrl + accountID
                                
//                                    let postHeaders_IndividualLogin = ["":""]
                                    
                          myAccServerCntrl.requestGETURL(strURL: URLString_loginIndividual, success: {(result) in

                            let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
                                                    
                            let status = respVo.status
                            let messageResp = respVo.message
                            _ = respVo.statusCode
                            
                            activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                                        
                            if status == "SUCCESS" {
                                if respVo.result?.count ?? 0>0
                                {
                                let resultDict = result as? NSDictionary
                                let dataArray = resultDict?.value(forKey: "result") as? NSArray
                                 
                                let dataDict = dataArray?.object(at: 0) as? NSDictionary
                                let userDataDict = dataDict?.value(forKey: "userDetails") as? NSDictionary
                                
                                let userId = respVo.result![0]._id
                                self.firstNameStr = userDataDict?.value(forKey: "firstName") as? String ?? ""
                                self.lastNameStr = userDataDict?.value(forKey: "lastName") as? String ?? ""
                                self.mobileNumStr = userDataDict?.value(forKey: "mobileNumber") as? String ?? ""
                                self.vicinityVal = dataDict?.value(forKey: "setVicinity") as? Int ?? 0
                                self.soonToExpire =  dataDict?.value(forKey: "soonToexpiryLeadTime") as? Int ?? 0
                                
                                let locDict = userDataDict?.value(forKey: "loc") as? NSDictionary
                                let locArray = locDict?.value(forKey: "coordinates") as? NSArray
                                
                                self.latt = locArray?.object(at: 0) as? Double ?? 0
                                self.long = locArray?.object(at: 1) as? Double ?? 0

//                              self.getMyAccProfilePic()
                                print(userId)
                                
                                self.upateMyAccDetails()
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
    
    func updateMyAccDetailsAPI() {
        
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let defaults = UserDefaults.standard
        let userID = (defaults.string(forKey: "userID") ?? "") as String
        let accountId = (defaults.string(forKey: "accountId") ?? "") as String
        
        let URLString_loginIndividual = Constants.BaseUrl + "endusers/endusers/user_update"
        
                    var params_IndividualLogin = [
                        "userId":userID,
                        "accountId":accountId,
                        "firstName":firstNameTF.text ?? "",
                        "lastName":lastNameTF.text ?? "",
                        "profilePhoto": profileBase64Img,
                        "setVicinity":setVicinityTF.text ?? "",
                        "soonToexpiryLeadTime":soonToExpireTF.text ?? "",
                        "lattitude":latt,
                        "longitude":long
                        ] as [String : Any]
        
        if(profileBase64Img == ""){
            
            params_IndividualLogin = [
                "userId":userID,
                "accountId":accountId,
                "firstName":firstNameTF.text ?? "",
                "lastName":lastNameTF.text ?? "",
                "setVicinity":setVicinityTF.text ?? "",
                "soonToexpiryLeadTime":soonToExpireTF.text ?? "",
                "lattitude":latt,
                "longitude":long
                ] as [String : Any]
        }
                
//                    print(params_IndividualLogin)
                
                    let postHeaders_IndividualLogin = ["":""]
                    
                    myAccServerCntrl.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
                        
                        let respVo:MyAccountResp = Mapper().map(JSON: result as! [String : Any])!
                                                
                        let status = respVo.status
                        let messageResp = respVo.message
//                      let statusCode = respVo.statusCode
                        
                        activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        if status == "SUCCESS" {
                            self.showAlertWith(title: "Success", message: "Profile details updated successfully")
                            
                            let userDefaults = UserDefaults.standard
                            
                            let firstName = self.firstNameTF.text ?? ""
                            let lastName = self.lastNameTF.text ?? ""
                            
                            let fullName = firstName + " " + lastName
                            userDefaults.set(fullName, forKey: "fullName")

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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

