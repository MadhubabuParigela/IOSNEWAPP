//
//  Login_IndividualRespVO.swift
//  Lekha
//
//  Created by Mallesh Kurva on 14/09/20.
//

import Foundation
import ObjectMapper

//{
//  "code": 200,
//  "message": "customer login success",
//  "result": [
//    {
//      "contact_number": 9948954381,
//      "email_verified": 1,
//      "mobile_verified": 1,
//      "official_email_id": "sravan.kasarla19@gmail.com",
//      "session_id": "",
//      "signin_type": "corporate",
//      "user_id": 1,
//      "user_name": "sravan",
//      "wallet_id": 1
//    }
//  ],
//  "status": "success"
//}


class Login_IndividualRespVO: Mappable {
    
    var message:String?
    var result:[Login_IndividualResultVO]?
//    var result:[NSArray]?
    var status:String?
    var statusCode:Int?
    var token:String?

    init(message:String?,result:[Login_IndividualResultVO]?,status:String?,statusCode:Int?,token:String?) {
        self.message = message
        self.result = result
        self.status = status
        self.statusCode = statusCode
        self.token = token

    }
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
        self.message <- map ["message"]
        self.result <- map ["user"]
        self.status <- map ["STATUS_MSG"]
        self.statusCode <- map["STATUS_CODE"]
        self.token <- map["token"]
        
    }
}


              //API INdividual API :
       //  http://3.6.120.54:6002/owo/individual_login


       //Params:
//{
//    "user_name": "kumarreddy656@gmail.com",
//    "password": "Kumar@12",
//    "signin_type": "individual",
//    "session_id": ""
//}

      //API Response :

//{
//    "message": "customer login success",
//    "result": [
//    {
//    "email_id": "kumarreddy656@gmail.com",
//    "mobile_number": 9985655873,
//    "session_id": "",
//    "signin_type": "individual",
//    "user_id": 7,
//    "user_name": "Kumar"
//    }
//    ],
//    "status": "success"
//}















