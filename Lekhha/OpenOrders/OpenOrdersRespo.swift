//
//  OpenOrdersRespo.swift
//  Lekha
//
//  Created by Mallesh Kurva on 17/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class OpenOrdersRespo: Mappable {
        
    var message:String?
    var result:[OpenOrdersResult]?
    var status:String?
    var statusCode:Int?
    
    init(message:String?,result:[OpenOrdersResult]?,status:String?,statusCode:Int?) {
        
        self.message = message
        self.result = result
        self.status = status
        self.statusCode = statusCode
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        message <- map["message"]
        result <- map["result"]
        status <- map["STATUS_MSG"]
        statusCode <- map["STATUS_CODE"]
        
    }
}
/*
 {
     "STATUS_MSG": "SUCCESS",
     "STATUS_CODE": 200,
     "result": [
         {
             "_id": "61bc5ced4b2e893c66fd1fc9",
             "vendorId": "61bc128d5a3c6915fbb648d1",
             "vendorName": "NA",
             "accountId": "61bc128d5a3c6915fbb648ce",
             "accountEmailId": "mounika.4560@gmail.com",
             "orderId": "10001",
             "status": true,
             "createdDate": "2021-12-17T00:00:00.000Z",
             "purchaseDate": "2021-12-17T00:00:00.000Z",
             "ordersList": [
                 
             ]
         }
     ]
 }
 */
