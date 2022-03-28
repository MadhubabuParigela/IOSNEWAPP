//
//  MyCropVC.swift
//  TextRecognizProg
//
//  Created by apple on 2/19/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit
import CropPickerView
import FirebaseMLVision
//import SVProgressHUD

protocol MyDataSendingDelegate {
    func sendDataToFirstViewController(myData: String)
}

class MyCropVC: UIViewController,UIActionSheetDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var cropSelectedImage = UIImage()
    
    @IBOutlet weak var cropBtn: UIButton!
    
    @IBOutlet weak var myCropView_Prog: CropPickerView!
    
       let imagePicker = UIImagePickerController()
       
         var textRecognizer: VisionTextRecognizer!
       
         var delegate: MyDataSendingDelegate!
       
          var PassImage = UIImage()
    
         var myBtn = UIButton()
      
         var myLblStr = String()
      
         var mytextString = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
              myCropView_Prog.scrollMaximumZoomScale = 500
              myCropView_Prog.scrollMinimumZoomScale = 0
        
              cropBtn.layer.cornerRadius = 10
              cropBtn.layer.borderWidth = 1
              cropBtn.layer.borderColor = #colorLiteral(red: 0.8830919862, green: 0.8905512691, blue: 0.9012110829, alpha: 1)
        
              let vision = Vision.vision()
              textRecognizer = vision.onDeviceTextRecognizer()

        DispatchQueue.main.async { [self] in
                    
                    let imageData = UserDefaults.standard.object(forKey: "key") as? Data
                                  var image: UIImage? = nil
                                  if let imageData = imageData {
                                      image = UIImage(data: imageData)
                            }
                      
//                     self.myCropView_Prog.image(UIImage(named: "Dmart3"))
                    
                       self.myCropView_Prog.image = self.cropSelectedImage
                    
              //      self.myCropView_Prog.image(image)
                      
          }

        // Do any additional setup after loading the view.
       }
    
    
    
    @IBAction func onTaped_CropBtn(_ sender: Any) {
 
        self.myCropView_Prog.delegate = self
           
           self.myCropView_Prog.crop { (crop) in
                             if let error = (crop.error as NSError?) {
                                 let alertController = UIAlertController(title: "Error", message: error.domain, preferredStyle: .alert)
                                 alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                                 self.present(alertController, animated: true, completion: nil)
                                 return
                             }
               
                 self.runTextRecognition(with: crop.image!)
             }
           
            self.navigationController?.popViewController(animated: true)
    
        }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "CurrentInventoryVC") as! CurrentInventoryViewController
            self.navigationController?.pushViewController(VC, animated: true)

        }
    
    @IBAction func onTap_BackBtn(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    
    }
    
    
    //Text Recognize Functionality:
              func runTextRecognition(with image:UIImage){
                
                  let visionImage = VisionImage(image: image)
                
                
                  textRecognizer.process(visionImage) { (features,error) in
                    
                    if(features == nil){
                        print("NO DATA")
                        return
                    }
                    
                      guard let text = features else {
                        fatalError("try Again")}
                      
                      self.mytextString = text.text
                      
                      print("mytextString:...... \(self.mytextString)")
                      
                 if self.delegate != nil {
                                     
                  self.delegate?.sendDataToFirstViewController(myData: self.mytextString)
                  
                  var isChecked = true
                       if self.mytextString.isEmpty {
                          self.dispatch_UnCheckedFunctionality()

                          isChecked = false
                                    }
                          else if self.mytextString != nil {
                          self.dispatch_CheckedFunctionality()

                          isChecked = true

                          }
                        
                     }
                  
                }
                  
           }

    
      func dispatch_CheckedFunctionality() {
      
//        SVProgressHUD.show()

          Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.myBtn_updateChecked), userInfo: nil, repeats: true)

                     //With Dispatch Queue
                       DispatchQueue.global(qos: .userInitiated).async {
//                           SVProgressHUD.show()
                           // Bounce back to the main thread to update the UI
                           DispatchQueue.main.async {
                               Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.myBtn_updateChecked), userInfo: nil, repeats: true)
                           }
      
                      }
          
                }
      
      
      func dispatch_UnCheckedFunctionality() {
         
//           SVProgressHUD.show()

             Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.myBtn_updateUncheecked), userInfo: nil, repeats: true)

                        //With Dispatch Queue
                          DispatchQueue.global(qos: .userInitiated).async {
//                              SVProgressHUD.show()
                              // Bounce back to the main thread to update the UI
                              DispatchQueue.main.async {
                                  Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.myBtn_updateUncheecked), userInfo: nil, repeats: true)
                              }
         
                         }
                   }
    
    @objc func myBtn_updateChecked() {
//              SVProgressHUD.dismiss()
          self.myBtn.setImage(UIImage(named: "checkBoxActive"), for: .normal)

          }
      
      @objc func myBtn_updateUncheecked() {
//                SVProgressHUD.dismiss()
          self.myBtn.setImage(UIImage(named: "checkBoxInactive"), for: .normal)

            }
      
     }

   
// MARK: CropPickerViewDelegate

extension MyCropVC: CropPickerViewDelegate {
    
    func cropPickerView(_ cropPickerView: CropPickerView, result: CropResult) {
        
       }
  }
