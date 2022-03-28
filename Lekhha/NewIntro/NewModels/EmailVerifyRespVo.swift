//
//  EmailVerifyRespVo.swift
//  Lekhha
//
//  Created by USM on 21/03/22.
//

import Foundation
import ObjectMapper

class EmailVerifyRespVo: Mappable {
        
    var message:String?
    var result:[EmailVerifyResultVo]?
    var status:String?
    var statusCode:Int?
    
    init(message:String?,result:[EmailVerifyResultVo]?,status:String?,statusCode:Int?) {
        
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
class EmailVerifyResultVo: Mappable {
    
    
    var _id: String?
    var emailAddress: String?
    var primaryUserId: String?
    var accountStatus: String?
    var dateOfCreation: String?
    var signUpType: String?
    var accountInfoStatus: String?
    
    init( _id: String?,
          emailAddress: String?,
          primaryUserId: String?,
          accountStatus: String?,
          dateOfCreation: String?,
          signUpType: String?,
          accountInfoStatus: String?) {
        
        self._id = _id
        self.emailAddress = emailAddress
        self.primaryUserId = primaryUserId
        self.accountStatus = accountStatus
        self.dateOfCreation = dateOfCreation
        self.signUpType = signUpType
        self.accountInfoStatus = accountInfoStatus
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map["_id"]
        self.emailAddress <- map["emailAddress"]
        self.primaryUserId <- map["primaryUserId"]
        self.accountStatus <- map["accountStatus"]
        self.dateOfCreation <- map["dateOfCreation"]
        self.signUpType <- map["signUpType"]
        self.accountInfoStatus <- map["accountInfoStatus"]
        
    }
}
/*
 {"STATUS_MSG":"SUCCESS","STATUS_CODE":200,"result":[{"_id":"6238610656c6b93def00a023","emailAddress":"038c9a7b338b3d686b5fbafbb0ba60a7ce7d0b4e78a51bef9ef87f226998e13b","primaryUserId":"623860c556c6b93def00a022","accountStatus":"Enrolled","dateOfCreation":"2022-03-21T16:57:02.952Z","signUpType":"Manual","accountInfoStatus":"Pending"}]}
 */
/*
 {"STATUS_MSG":"SUCCESS","STATUS_CODE":200,"result":[{"_id":"6238678892409f3ee7d5d411","emailAddress":"038c9a7b338b3d686b5fbafbb0ba60a7ce7d0b4e78a51bef9ef87f226998e13b","primaryUserId":"6238675892409f3ee7d5d410","accountStatus":"Enrolled","dateOfCreation":"2022-03-21T17:24:48.443Z","signUpType":"Manual","accountInfoStatus":"Completed","accountOTP":89284,"accountUniqueId":"vin","address":"102, Shirdi Sai Colony, Beeramguda, Ramachandrapuram, Telangana 502032, India","city":"Ramachandrapuram","companySize":"I am Consumer","loc":{"type":"Point","coordinates":[17.5110579,78.3024394]},"pincode":"502032","setVicinityMax":10,"setVicinityMin":0,"state":"Telangana"}]}
 */
