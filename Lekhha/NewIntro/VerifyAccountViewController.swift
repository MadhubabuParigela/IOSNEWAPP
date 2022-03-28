//
//  VerifyAccountViewController.swift
//  Lekhha
//
//  Created by Swapna Nimma on 12/03/22.
//

import UIKit

class VerifyAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onClickGetStartedButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "UserDetailsPage1ViewController") as! UserDetailsPage1ViewController
        self.navigationController?.pushViewController(VC, animated: true)
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
