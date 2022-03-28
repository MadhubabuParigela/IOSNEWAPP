//
//  ViewController1.swift
//  TextRecognizProg
//
//  Created by apple on 2/19/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class ViewController1: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.allowsEditing = true
        
        nextBtn.layer.cornerRadius = 10
        nextBtn.layer.borderWidth = 1
        nextBtn.layer.borderColor = #colorLiteral(red: 0.8830919862, green: 0.8905512691, blue: 0.9012110829, alpha: 1)
        
        loadActionSheet()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectImgBtnTap(_ sender: Any) {
      loadActionSheet()
        
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        if(myImageView.image == nil){
            showAlertMessage()
            
        }else{
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
              let VC = storyBoard.instantiateViewController(withIdentifier: "ProperitesStoreVC") as! ProperitesStoreVC
            VC.selectedImg = myImageView.image!
              self.navigationController?.pushViewController(VC, animated: true)

        }
    }
    
    func showAlertMessage(){
        
        let alert = UIAlertController(title: "Alert", message: "Select an image", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func onTapped_NextBtn(_ sender: Any) {
  
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
      let VC = storyBoard.instantiateViewController(withIdentifier: "ProperitesStoreVC") as! ProperitesStoreVC
      self.navigationController?.pushViewController(VC, animated: true)
    
    }
    
    @IBAction func onTap_BackBtn(_ sender: Any) {
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
 
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

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
    
    //Delegate Method in UIImage Picker Controller :
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let imagePick = info[UIImagePickerController.InfoKey.originalImage] {
       myImageView.image = imagePick as? UIImage
        
//        self.myCropView_Prog.image(UIImage(named: "Dmart3"))
       
//       let imageData: Data? = (imagePick as! UIImage).jpegData(compressionQuality: 0.4)
//       let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""

//       profileBase64Img = imageStr as NSString
//       profileImgBtn.setImage(imagePick as? UIImage, for: UIControl.State.normal)
        
}
    else{

    //Error Message
    }
    self.dismiss(animated: true, completion: nil)
}

    
    }



// MARK: UIImagePickerControllerDelegate:
//extension ViewController1: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//           picker.dismiss(animated: true, completion: nil)
//       }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//          if let userPickedimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//
//          UserDefaults.standard.set(userPickedimage.pngData(), forKey: "key")
//
//            self.myImageView.image = userPickedimage
//
//          }
//          imagePicker.dismiss(animated: true, completion: nil)
//
//      }
//
//  }
