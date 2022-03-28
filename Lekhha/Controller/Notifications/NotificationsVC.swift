//
//  NotificationsVC.swift
//  LekhaApp
//
//  Created by apple on 11/23/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController {
    
    @IBOutlet weak var notificationsTV: UITableView!
    
    var imagesArr = ["Image 105","Image 105","Image 105","Image 105","Image 105","Image 105","Image 105","Image 105","Image 105"]
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                    notificationsTV.delegate = self
                    notificationsTV.dataSource = self
        
                  //  notificationsTV.rowHeight = UITableView.automaticDimension
                   // notificationsTV.estimatedRowHeight = UITableView.automaticDimension
                    
             let nibName2 = UINib(nibName: "NotificationsTV_Cell", bundle: nil)
             notificationsTV.register(nibName2, forCellReuseIdentifier: "NotificationsTV_Cell")
        
              let headerNib = UINib.init(nibName: "BottomView", bundle: Bundle.main)
              notificationsTV.register(headerNib, forHeaderFooterViewReuseIdentifier: "BottomView")

                    notificationsTV.reloadData()
        
                   }
    
            }


    extension NotificationsVC:UITableViewDelegate,UITableViewDataSource {
    
   
      func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
        
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return imagesArr.count
            }
        
//        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//               let headerView = notificationsTV.dequeueReusableHeaderFooterView(withIdentifier: "BottomView") as! BottomView
//
//                    return  headerView
//                  }
//
//        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//                    return 220
//                }

      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          var cell:NotificationsTV_Cell = notificationsTV.dequeueReusableCell(withIdentifier: "NotificationsTV_Cell", for: indexPath) as! NotificationsTV_Cell
          cell.myImgView.image = UIImage(named: imagesArr[indexPath.row])
          return cell
      }
        
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        }
    
    
   }
