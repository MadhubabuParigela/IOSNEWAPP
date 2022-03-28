//
//  Registration_CorporateRespVO.swift
//  Lekha
//
//  Created by Mallesh Kurva on 14/09/20.

import Foundation
import ObjectMapper

class RegiCorporateRespVO: Mappable {
        
    var message:String?
    var result:RegiOps?
    var status:String?
    var statusCode:Int?
    var mobileresult:NSArray?
    
    init(message:String?,result:RegiOps?,status:String?,statusCode:Int?,mobileresult:NSArray?) {
        
        self.message = message
        self.result = result
        self.status = status
        self.statusCode = statusCode
        self.mobileresult = mobileresult
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        message <- map["message"]
        result <- map["result"]
        status <- map["STATUS_MSG"]
        statusCode <- map["STATUS_CODE"]
        mobileresult <- map["mobileresult"]
        
    }
}

//  REgistration API:

//     http://3.6.120.54:6002/owo/user_corporate_registration


//Params :

//{
//    "first_name":"indhu",
//    "last_name":"priya",
//    "password" :"indhu@28",
//    "confirm_password":"indhu@28",
//    "signin_type" :"corporate",
//    "date_of_join":"28-04-2020",
//    "company_name":"owo",
//    "gst_number":"1238929030900",
//    "official_email_id":"indhirapptrrudu@gmail.com",
//    "contact_number":"7337451002",
//    "legal_name_of_business":"water",
//    "pan_number":"amplf6147d",
//    "state":"telangana",
//    "session_id":""
//
//}


//{
//    "message": "user register sucessfully",
//    "result": [
//    {
//    "company_name": "owo",
//    "confirm_password": "indhu@28",
//    "contact_number": "7337451002",
//    "date_of_join": "28-04-2020",
//    "first_name": "indhu",
//    "gst_number": "1238929030900",
//    "last_name": "priya",
//    "legal_name_of_business": "water",
//    "official_email_id": "indhirapptrrudu@gmail.com",
//    "otp": "rGoiMI",
//    "pan_number": "amplf6147d",
//    "password": "indhu@28",
//    "session_id": "",
//    "signin_type": "corporate",
//    "state": "telangana",
//    "user_id": 5
//    }
//    ],
//    "status": "success"
//}




//["message": Added SuccessFully, "STATUS_MSG": SUCCESS, "result": {
//    connection =     {
//        host = "35.154.239.192";
//        id = 3;
//        port = 6909;
//    };
//    insertedCount = 1;
//    insertedId = 5f6994cbfbfc493df752c307;
//    n = 1;
//    ok = 1;
//    ops =     (
//                {
//            "_id" = 5f6994cbfbfc493df752c307;
//            dateOfCreation = "2020-09-22T06:08:11.645Z";
//            emailId = "gfdgf@fgfdg.com";
//            firstName = fdgfdgfd;
//            hash = 2390f0ac2411d97c99fcc3043ba0da98a143e00bc4b1a6a3655ee5df9abb5578a073bdc2f4d8e6faae1a32dd9020b6d4b09adc1caf22ce51160278752532b2e8;
//            lastName = fgfdgfdgf;
//            mobileNumber = 45543545454;
//            mobileStatus = Enrolled;
//            salt = d53dd3028d79a8fc27d19ba9ae55072bf8612353e2dd26fb0c3f42abcc5a5ce5;
//            status = 1;
//        }
//    );
//    result =     {
//        n = 1;
//        ok = 1;
//    };
//}, "STATUS_CODE": 200]
