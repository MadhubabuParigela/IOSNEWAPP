//
//  Login_IndividualResultVO.swift
//  Lekha
//
//  Created by Mallesh Kurva on 14/09/20.
//

import Foundation
import ObjectMapper

//{
//  "message": "customer login success",
//  "result": [
//    {
//      "email_id": "sravan.kasarla19@gmail.com",
//      "email_verified": 1,
//      "mobile_number": 9948954381,
//      "mobile_verified": 1,
//      "session_id": "",
//      "signin_type": "individual",
//      "user_id": 1,
//      "user_name": "sravan",
//      "wallet_id": 1
//    }
//  ],
//  "status": "success"
//}

class Login_IndividualResultVO: Mappable {
    
    var _id:String?
    var dateOfBirth:String?
    var dateOfCreation:String?
    var firstName:String?
    var gender:String?
    var mobileNumber:String?
    var emailId:String?
    var last_name:String?
    var mobileStatus:String?
    var status:Int?
    var privacypolicy_accepted_version:String?
    var privacypolicy_latest_version:String?
    var termsandconditions_accepted_version:String?
    var termsandconditions_latest_version:String?
    
    
    init(id:String?,dateOfBirth:String?,dateOfCreation:String?,firstName:String?,gender:String?, mobileNumber:String?,
     last_name:String?, status:Int?, mobileStatus:String?,emailId:String?, privacypolicy_accepted_version:String?,
     privacypolicy_latest_version:String?,
     termsandconditions_accepted_version:String?,
     termsandconditions_latest_version:String?) {
        
        self._id = id
        self.dateOfBirth = dateOfBirth
        self.dateOfCreation = dateOfCreation
        self.firstName = firstName
        self.gender = gender
        self.mobileNumber = mobileNumber
        self.last_name = last_name
        self.status = status
        self.mobileStatus = mobileStatus
        self.emailId = emailId
        self.privacypolicy_accepted_version = privacypolicy_accepted_version
        self.privacypolicy_latest_version = privacypolicy_latest_version
        self.termsandconditions_accepted_version = termsandconditions_accepted_version
        self.termsandconditions_latest_version = termsandconditions_latest_version
        
    }
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map ["_id"]
        self.dateOfBirth <- map ["dateOfBirth"]
        self.dateOfCreation <- map ["dateOfCreation"]
        self.firstName <- map ["firstName"]
        self.gender <- map ["gender"]
        self.mobileNumber <- map ["mobileNumber"]
        self.last_name <- map ["lastName"]
        self.status <- map ["status"]
        self.mobileStatus <- map ["mobileStatus"]
        self.emailId <- map ["emailId"]
        self.privacypolicy_accepted_version <- map ["privacypolicy_accepted_version"]
        self.privacypolicy_latest_version <- map ["privacypolicy_latest_version"]
        self.termsandconditions_accepted_version <- map ["termsandconditions_accepted_version"]
        self.termsandconditions_latest_version <- map ["termsandconditions_latest_version"]
    }
}

