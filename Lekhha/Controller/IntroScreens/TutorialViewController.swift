//
//  TutorialViewController.swift
//  UIPageViewController Post
//
//  Created by Jeffrey Burt on 2/3/16.
//  Copyright © 2016 Seven Even. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var doneImg: UIImageView!
    
    @IBOutlet weak var nextBtn: UIButton!
    var count = 0
    
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.addTarget(self, action: Selector("didChangePageControlValue"), for: .valueChanged)
        
       NotificationCenter.default.addObserver(self,
        selector: #selector(reloadData),
        name: Notification.Name("pageCount"),
        object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }
    
    @objc func reloadData(notification: NSNotification){
        
       let info0 = notification.userInfo?["key"]
        
        if info0 != nil {
            
             pageControl.currentPage = info0 as! Int
        }
        
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
                
        if count == 4 {

            print(count)
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let VC = storyBoard.instantiateViewController(withIdentifier: "LoginIndividualVC") as! LoginIndividualVC
//
//            UserDefaults.standard.set("1", forKey: "isLoggedin")
//
//            UserDefaults.standard.set("IntroSlide", forKey: "WithoutLogin")
//            NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
//
//            self.navigationController?.pushViewController(VC, animated: true)
                        
        }
        else {
            
            tutorialPageViewController?.scrollToNextViewController()
        }
        
    }
    
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
}

extension TutorialViewController: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
        didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
        didUpdatePageIndex index: Int) {
        
        pageControl.currentPage = index
        
        if index == 3 {
            
            count = 4
            
            doneImg.image = UIImage(named: "doneImg")
        }
        
    }
    
}
