//
//  EmailNewSignInViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 12/03/22.
//

import UIKit

class EmailNewSignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mailViewDropDown.layer.borderColor = UIColor.gray.cgColor
        mailViewDropDown.layer.borderWidth = 0.5
        mailViewDropDown.layer.cornerRadius = 3
        mailViewDropDown.clipsToBounds = true
        
        mailView.layer.borderColor = UIColor.gray.cgColor
        mailView.layer.borderWidth = 0.5
        mailView.layer.cornerRadius = 3
        mailView.clipsToBounds = true
    }
    @IBOutlet var emailTF: SDCTextField!
    
    
    @IBOutlet var mailViewDropDown: UIView!
    @IBOutlet var mailView: UIView!
    @IBAction func onClickPasswordPrivacyButton(_ sender: Any) {
    }
    @IBOutlet var passwordTF: SDCTextField!
    
    @IBAction func onClickSignInButton(_ sender: Any) {
    }
    @IBAction func onClickForgotPasswordButton(_ sender: Any) {
    }
    
    @IBAction func onClickPhoneButton(_ sender: Any) {
    }
    @IBAction func onClickGoogleButton(_ sender: Any) {
    }
    @IBAction func onClickFacebookButton(_ sender: Any) {
    }
    @IBAction func onClickAppleButton(_ sender: Any) {
    }
    @IBAction func onClickSignUpButton(_ sender: Any) {
    }

}
