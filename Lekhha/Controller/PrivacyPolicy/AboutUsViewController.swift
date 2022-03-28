//
//  AboutUsViewController.swift
//  Lekha
//
//  Created by Mallesh Kurva on 05/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var aboutUsWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url: URL! = URL(string: "http://35.154.239.192:4500/Misc/Files/pagecontent/aboutus")
        aboutUsWebView.load(URLRequest(url: url))
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
