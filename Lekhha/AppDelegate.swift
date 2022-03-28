//
//  AppDelegate.swift
//  Lekha
//  Created by Mallesh Kurva on 14/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift
import GooglePlaces
import Firebase
import FacebookCore
import GoogleSignIn
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    var countryCodeStr = ""
    var viewCntrlObj = UIViewController()
    var window: UIWindow?
    var mNavCtrl: UINavigationController?
    
    var myProductsArray = NSMutableArray()
    var serviceVC = ServiceController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyB_Pbx9Ulz_FqFrOwaIV6ecCqe9PuQss_M")
        GMSPlacesClient.provideAPIKey("AIzaSyB_Pbx9Ulz_FqFrOwaIV6ecCqe9PuQss_M")
//        let signInConfig = GIDConfiguration.init(clientID: "976753428495-vq0j414cqq63dv33jjk8dfe5rsn2mvqj.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
           if error != nil || user == nil {
             // Show the app's signed-out state.
           } else {
             // Show the app's signed-in state.
           }
         }
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
             appDelegate.window = self.window
        
            window = UIWindow(frame: UIScreen.main.bounds)

             GMSServices.provideAPIKey("AIzaSyD7gl7LrxtbTjlplCXphN2EJi7HRi9s_8Y")
        
              FirebaseApp.configure()

        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
        } else {

            let userDefaults = UserDefaults.standard
            let isLoggedIn = userDefaults.bool(forKey: "isLoggedIn") as Bool

            if(isLoggedIn){
                moveToCurrentInventory()

            }else{
                moveTosignInVC()
            }
        }
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide

        return true
    }
//    func application(
//      _ app: UIApplication,
//      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//    ) -> Bool {
//      var handled: Bool
//
//      handled = GIDSignIn.sharedInstance.handle(url)
//      if handled {
//        return true
//      }
//
//      // Handle other custom URL types.
//
//      // If not handled by this app, return false.
//      return false
//    }
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        
        let appId: String = Settings.appID!
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        else {
            
            return GIDSignIn.sharedInstance.handle(url)
//             return false
        }
        }
    
    func moveToCurrentInventory()   {
        
        let userDefaults = UserDefaults.standard
        let countryStr = userDefaults.value(forKey: "countryCode") ?? ""
        
        if let countryCode = CountryUtility.getLocalCountryCode() {
            
            let codestr = IsoCountryCodes.find(key: countryCode)?.alpha3
            
            self.countryCodeStr = codestr ?? ""
            
            if countryStr as! String == countryCodeStr {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let isconsumerStatus = userDefaults.string(forKey: "consumerStatus")
                
                if(isconsumerStatus == "0"){
                    
//                    deviceInfo_updateAPI()
                    
                    let navigationController = UINavigationController()
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "VendorOrdersViewController") as! VendorOrdersViewController
                    navigationController.viewControllers = [rootViewController]
                    self.window?.rootViewController = navigationController
                    
                }else{
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.set("CheckAccount", forKey: "isCheckAccount")
                    let isconsumerStatus = userDefaults.string(forKey: "consumerStatus")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let navigationController = UINavigationController()
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "AlertMainViewController") as! AlertMainViewController
                    navigationController.viewControllers = [rootViewController]
                    navigationController.navigationBar.isHidden = true
                    self.window?.rootViewController = navigationController
                                       
                    
//                    let navigationController = UINavigationController()
//                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
//                    navigationController.viewControllers = [rootViewController]
//                    self.window?.rootViewController = navigationController
                }
            }
            else {
                
                let userDefaults = UserDefaults.standard
                userDefaults.set("CheckAcc", forKey: "isCheckAccount")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = UINavigationController()
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "AlertMainViewController") as! AlertMainViewController
                navigationController.viewControllers = [rootViewController]
                navigationController.navigationBar.isHidden = true
                self.window?.rootViewController = navigationController
            }

        }
        else {
            moveTosignInVC()
        }
//        return true
    }
        
    func deviceInfo_updateAPI() {
        
        activity.startAnimating()
//        self.view.isUserInteractionEnabled = false
        
        let defaults = UserDefaults.standard
        var userID = String()
        userID = (defaults.string(forKey: "userID") ?? "")
        
        let URLString_loginIndividual = Constants.BaseUrl + "endusers/deviceInfo_update/\(userID)"
                
        let modelName = UIDevice.modelName
        print("modelName:\(modelName)")
        let deviceVersion = UIDevice.current.systemVersion
        print("deviceVersion:\(deviceVersion)")
        let typeVendor = UIDevice.current.identifierForVendor
        print("typeVendor:\(typeVendor)")
        let type = UIDevice.current.type
        print("type:\(type)")
        let name = UIDevice.current.name
        print("name:\(name)")
        let model = UIDevice.current.model
        print("model:\(model)")
        
        let deviceInfoDict = ["appVersion":"3.5","basebandVersion":deviceVersion,"buildNo":"25","deviceName":name,"kernelVersion":deviceVersion,"lattitude":"NA","longitude":"NA","manufacture":"APPLE","model":modelName,"osVersion":deviceVersion,"serial":"unknown"] as [String : Any]
        
        print("deviceInfoDict:\(deviceInfoDict)")
        
        let params_IndividualLogin = ["loginDeviceInfo":deviceInfoDict]
        
        
        print(params_IndividualLogin)
        let postHeaders_IndividualLogin = ["":""]
        
        serviceVC.requestPOSTURL(strURL: URLString_loginIndividual as NSString, postParams: params_IndividualLogin as NSDictionary, postHeaders: postHeaders_IndividualLogin as NSDictionary, successHandler: { (result) in
            
            let respVo:RegiCorporateRespVO = Mapper().map(JSON: result as! [String : Any])!
            
            let status = respVo.status
            let messageResp = respVo.message
            let statusCode = respVo.statusCode
            
            activity.stopAnimating()
//            self.view.isUserInteractionEnabled = true
            
            if statusCode == 200 {
                if status == "SUCCESS" {
//                    self.view.makeToast(messageResp)
                }
                else {
//                    self.view.makeToast(messageResp)
                }
            }
            else {
//                self.view.makeToast(messageResp)
            }
                        
        }) { (error) in
            
            activity.stopAnimating()
//            self.view.isUserInteractionEnabled = true
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
            
            let alertAction = UIAlertAction(title: "Logout", style: .default, handler: { (action) in
                self.moveTosignInVC()
            })
        
        let alertAction1 = UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        })

    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
           alertController.addAction(alertAction1)

        viewCntrlObj.present(alertController, animated: true, completion: nil)
        
        }
    
    func moveTosignInVC() {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                 let loginViewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
//                 var navigationController = UINavigationController()
//                 navigationController = UINavigationController(rootViewController: loginViewController)
//                 window?.rootViewController = navigationController
//                 navigationController.isNavigationBarHidden = true
        
        
        let storyboard = UIStoryboard(name: "Intro", bundle: nil)
        let navigationController = UINavigationController()
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "NewIntroViewController") as! NewIntroViewController
        navigationController.viewControllers = [rootViewController]
        navigationController.navigationBar.isHidden = true
        self.window?.rootViewController = navigationController
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let navigationController = UINavigationController()
//        let rootViewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
//        navigationController.viewControllers = [rootViewController]
//        navigationController.navigationBar.isHidden = true
//        self.window?.rootViewController = navigationController

    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }

//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//
//    }
    
  /*  func getCountryPhonceCode (country : String) -> String
    {

        if count(country) == 2
        {
            let x : [String] = ["972", "IL",
                "93" , "AF",
                "355", "AL",
                "213", "DZ",
                "1"  , "AS",
                "376", "AD",
                "244", "AO",
                "1"  , "AI",
                "1"  , "AG",
                "54" , "AR",
                "374", "AM",
                "297", "AW",
                "61" , "AU",
                "43" , "AT",
                "994", "AZ",
                "1"  , "BS",
                "973", "BH",
                "880", "BD",
                "1"  , "BB",
                "375", "BY",
                "32" , "BE",
                "501", "BZ",
                "229", "BJ",
                "1"  , "BM",
                "975", "BT",
                "387", "BA",
                "267", "BW",
                "55" , "BR",
                "246", "IO",
                "359", "BG",
                "226", "BF",
                "257", "BI",
                "855", "KH",
                "237", "CM",
                "1"  , "CA",
                "238", "CV",
                "345", "KY",
                "236", "CF",
                "235", "TD",
                "56", "CL",
                "86", "CN",
                "61", "CX",
                "57", "CO",
                "269", "KM",
                "242", "CG",
                "682", "CK",
                "506", "CR",
                "385", "HR",
                "53" , "CU" ,
                "537", "CY",
                "420", "CZ",
                "45" , "DK" ,
                "253", "DJ",
                "1"  , "DM",
                "1"  , "DO",
                "593", "EC",
                "20" , "EG" ,
                "503", "SV",
                "240", "GQ",
                "291", "ER",
                "372", "EE",
                "251", "ET",
                "298", "FO",
                "679", "FJ",
                "358", "FI",
                "33" , "FR",
                "594", "GF",
                "689", "PF",
                "241", "GA",
                "220", "GM",
                "995", "GE",
                "49" , "DE",
                "233", "GH",
                "350", "GI",
                "30" , "GR",
                "299", "GL",
                "1"  , "GD",
                "590", "GP",
                "1"  , "GU",
                "502", "GT",
                "224", "GN",
                "245", "GW",
                "595", "GY",
                "509", "HT",
                "504", "HN",
                "36" , "HU",
                "354", "IS",
                "91" , "IN",
                "62" , "ID",
                "964", "IQ",
                "353", "IE",
                "972", "IL",
                "39" , "IT",
                "1"  , "JM",
                "81", "JP", "962", "JO", "77", "KZ",
                "254", "KE", "686", "KI", "965", "KW", "996", "KG",
                "371", "LV", "961", "LB", "266", "LS", "231", "LR",
                "423", "LI", "370", "LT", "352", "LU", "261", "MG",
                "265", "MW", "60", "MY", "960", "MV", "223", "ML",
                "356", "MT", "692", "MH", "596", "MQ", "222", "MR",
                "230", "MU", "262", "YT", "52","MX", "377", "MC",
                "976", "MN", "382", "ME", "1", "MS", "212", "MA",
                "95", "MM", "264", "NA", "674", "NR", "977", "NP",
                "31", "NL", "599", "AN", "687", "NC", "64", "NZ",
                "505", "NI", "227", "NE", "234", "NG", "683", "NU",
                "672", "NF", "1", "MP", "47", "NO", "968", "OM",
                "92", "PK", "680", "PW", "507", "PA", "675", "PG",
                "595", "PY", "51", "PE", "63", "PH", "48", "PL",
                "351", "PT", "1", "PR", "974", "QA", "40", "RO",
                "250", "RW", "685", "WS", "378", "SM", "966", "SA",
                "221", "SN", "381", "RS", "248", "SC", "232", "SL",
                "65", "SG", "421", "SK", "386", "SI", "677", "SB",
                "27", "ZA", "500", "GS", "34", "ES", "94", "LK",
                "249", "SD", "597", "SR", "268", "SZ", "46", "SE",
                "41", "CH", "992", "TJ", "66", "TH", "228", "TG",
                "690", "TK", "676", "TO", "1", "TT", "216", "TN",
                "90", "TR", "993", "TM", "1", "TC", "688", "TV",
                "256", "UG", "380", "UA", "971", "AE", "44", "GB",
                "1", "US", "598", "UY", "998", "UZ", "678", "VU",
                "681", "WF", "967", "YE", "260", "ZM", "263", "ZW",
                "591", "BO", "673", "BN", "61", "CC", "243", "CD",
                "225", "CI", "500", "FK", "44", "GG", "379", "VA",
                "852", "HK", "98", "IR", "44", "IM", "44", "JE",
                "850", "KP", "82", "KR", "856", "LA", "218", "LY",
                "853", "MO", "389", "MK", "691", "FM", "373", "MD",
                "258", "MZ", "970", "PS", "872", "PN", "262", "RE",
                "7", "RU", "590", "BL", "290", "SH", "1", "KN",
                "1", "LC", "590", "MF", "508", "PM", "1", "VC",
                "239", "ST", "252", "SO", "47", "SJ",
                "963","SY",
                "886",
                "TW", "255",
                "TZ", "670",
                "TL","58",
                "VE","84",
                "VN",
                "284", "VG",
                "340", "VI",
                "678","VU",
                "681","WF",
                "685","WS",
                "967","YE",
                "262","YT",
                "27","ZA",
                "260","ZM",
                "263","ZW"]
            var keys = [String]()
            var values = [String]()
            let whitespace = NSCharacterSet.decimalDigits

            //let range = phrase.rangeOfCharacterFromSet(whitespace)
            for i in x {
                // range will be nil if no whitespace is found
                if  (i.rangeOfCharacterFromSet(whitespace) != nil) {
                    values.append(i)
                }
                else {
                    keys.append(i)
                }
            }
            var countryCodeListDict = NSDictionary(objects: values as [String], forKeys: keys as [String])
    if let t: AnyObject = countryCodeListDict[country] {
            return countryCodeListDict[country] as! String
            } else
            {
                return ""
            }
            }
        else
        {
            return ""
        }
    }
    */

}



