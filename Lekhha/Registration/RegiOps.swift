//
//  RegiOps.swift
//  Lekha
//
//  Created by Mallesh Kurva on 22/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper


class RegiOps: Mappable {
    
    var ops:NSArray?
    var connection:String?
    var result:String?

    init(ops:NSArray?,connection:String?,result:String?) {
        
        self.ops = ops
        self.result = result
        self.connection = connection
        
    }
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
        self.ops <- map ["ops"]
        self.result <- map["result"]
        self.connection <- map["connection"]

    }
}

//{
//    "STATUS_MSG": "SUCCESS",
//    "STATUS_CODE": 200,
//    "message": "Added SuccessFully",
//    "result": {
//        "result": {
//            "n": 1,
//            "ok": 1
//        },
//        "connection": {
//            "id": 3,
//            "host": "35.154.239.192",
//            "port": 6909
//        },
//        "ops": [
//            {
//                "_id": "5f69ea87fb4359434c2d5b76",
//                "firstName": "dummy",
//                "lastName": "test",
//                "mobileNumber": "3543543545",
//                "emailId": "test@gmai.com",
//                "salt": "5fe201700a9279009843a4a205140361b6fb4224184b86baeaceee15ce20b00f",
//                "hash": "a3ee70dbdb018be194b8b9b33bda8bfd97623f6ad9a4ff745076a0041b1ce86137efcc78dc238fa8bb89e541fd49c22fe50b66ff92e0c5cccb8bfa2e9dabddb8",
//                "status": true,
//                "dateOfCreation": "2020-09-22T12:13:59.337Z",
//                "mobileStatus": "Enrolled"
//            }
//        ],
//        "insertedCount": 1,
//        "insertedId": "5f69ea87fb4359434c2d5b76",
//        "n": 1,
//        "ok": 1
//    }
//}
