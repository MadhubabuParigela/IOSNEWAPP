//
//  SceneDelegate.swift
//  Lekha
//
//  Created by Mallesh Kurva on 14/09/20.
//  Copyright © 2020 Longdom. All rights reserved.

import UIKit
import FacebookCore
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        if #available(iOS 13.0, *) {
            guard let _ = (scene as? UIWindowScene) else { return }
        } else {
            // Fallback on earlier versions
        }

        let userDefaults = UserDefaults.standard
        let isLoggedIn = userDefaults.bool(forKey: "isLoggedIn") as Bool

        if(isLoggedIn){
            moveToCurrentInventory()

        }else{
            moveTosignInVC()
        }

    }
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associatzed with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    var countryCodeStr=String()
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
                        
                        let navigationController = UINavigationController()
                        let rootViewController = storyboard.instantiateViewController(withIdentifier: "VendorOrdersViewController") as! VendorOrdersViewController
                        navigationController.viewControllers = [rootViewController]
                        self.window?.rootViewController = navigationController
                        
                    }else{
                        
                        let userDefaults = UserDefaults.standard
                        userDefaults.set("CheckAccount", forKey: "isCheckAccount")
                        let isconsumerStatus = userDefaults.string(forKey: "consumerStatus")
                       
                        let navigationController = UINavigationController()
//                        let rootViewController = storyboard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
                        let rootViewController = storyboard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryVC
                        navigationController.viewControllers = [rootViewController]
                        self.window?.rootViewController = navigationController
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
        }
        
        func moveTosignInVC() {

//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let loginViewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
//            var navigationController = UINavigationController()
//            navigationController = UINavigationController(rootViewController: loginViewController)
//            window?.rootViewController = navigationController
//            navigationController.isNavigationBarHidden = true
            
            
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let navigationController = UINavigationController()
//            let rootViewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
//            navigationController.viewControllers = [rootViewController]
//            navigationController.navigationBar.isHidden = true
//            self.window?.rootViewController = navigationController
            
            let storyboard = UIStoryboard(name: "Intro", bundle: nil)
            let navigationController = UINavigationController()
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "NewIntroViewController") as! NewIntroViewController
            navigationController.viewControllers = [rootViewController]
            navigationController.navigationBar.isHidden = true
            self.window?.rootViewController = navigationController

        }

}

