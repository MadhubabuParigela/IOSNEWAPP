//
//  NewIntroViewController.swift
//  Lekhha
//
//  Created by apple on 17/03/22.
//

import UIKit

class NewIntroViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var paginationControl: UIPageControl!
    var imgArr = [  UIImage(named:"intro3"),
                    UIImage(named:"intro1") ,
                    UIImage(named:"intro2") ]
    var timer = Timer()
    var counter = 0
    @IBAction func onClickSignUpButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignUpNewViewController") as! SignUpNewViewController
        VC.modalPresentationStyle = .fullScreen
self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func onClickSignInButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Intro", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "PhoneSignInViewController") as! PhoneSignInViewController
            
        self.navigationController?.pushViewController(VC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        paginationControl.numberOfPages = imgArr.count
        paginationControl.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    @objc func changeImage() {
     
     if counter < imgArr.count {
         let index = IndexPath.init(item: counter, section: 0)
         self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
         paginationControl.currentPage = counter
         counter += 1
     } else {
         counter = 0
         let index = IndexPath.init(item: counter, section: 0)
         self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        paginationControl.currentPage = counter
         counter = 1
     }
     }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = imgArr[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: -40, bottom: 0, right: -40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width-40, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
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
