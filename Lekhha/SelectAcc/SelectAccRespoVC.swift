//
//  SelectAccRespoVC.swift
//  Lekha
//
//  Created by Mallesh Kurva on 29/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class SelectAccRespoVC: Mappable {
    
    var result1:NSMutableArray?
    var message:String?
    var result:[SelectAccResultVC]?
//    var result:[NSArray]?
    var status:String?
    var statusCode:Int?

    init(message:String?,result:[SelectAccResultVC]?,status:String?,statusCode:Int?,result1:NSMutableArray?) {
        self.message = message
        self.result = result
        self.status = status
        self.statusCode = statusCode
        self.result1 = result1

    }
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
        self.message <- map ["message"]
        self.result <- map ["result"]
        self.status <- map ["STATUS_MSG"]
        statusCode <- map["STATUS_CODE"]
        result1 <- map["result"]
        
    }
}
