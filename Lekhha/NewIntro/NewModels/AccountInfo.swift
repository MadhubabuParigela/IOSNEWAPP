//
//  AccountInfo.swift
//  Lekhha
//
//  Created by Swapna Nimma on 18/03/22.
//

import Foundation
import ObjectMapper

class AccountInfo: Mappable {
        
    var message:String?
    var result:[AccountInfoResultVo]?
    var status:String?
    var statusCode:Int?
    
    init(message:String?,result:[AccountInfoResultVo]?,status:String?,statusCode:Int?) {
        
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
class AccountInfoResultVo: Mappable {

    var _id: String?
    var accountInfoStatus: String?
    var accountStatus: String?
    var accountUniqueId: String?
    var address: String?
    var city: String?
    var companySize: String?
    var dateOfCreation: String?
    var emailAddress: String?
    var loc: [String:AnyObject]?
    var pincode: String?
    var primaryUserId: String?
    var setVicinityMax: Int?
    var setVicinityMin: Int?
    var signUpType: String?
    var state: String?
   
    
    init(_id: String?,accountInfoStatus: String?,accountStatus: String?,accountUniqueId: String?,address: String?,city: String?,companySize: String?,dateOfCreation: String?,emailAddress: String?,loc: [String:AnyObject]?,pincode: String?,primaryUserId: String?,setVicinityMax: Int?,setVicinityMin: Int?,signUpType: String?,state: String?) {
        
        self._id = _id
        self.accountInfoStatus = accountInfoStatus
        self.accountStatus = accountStatus
        self.accountUniqueId = accountUniqueId
        self.address = address
        self.city = city
        self.companySize = companySize
        self.dateOfCreation = dateOfCreation
        self.emailAddress = emailAddress
        self.loc = loc
        self.pincode = pincode
        self.primaryUserId = primaryUserId
        self.setVicinityMax = setVicinityMax
        self.setVicinityMin = setVicinityMin
        self.signUpType = signUpType
        self.state = state
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map["_id"]
        self.accountInfoStatus <- map["accountInfoStatus"]
        self.accountStatus <- map["accountStatus"]
        self.accountUniqueId <- map["accountUniqueId"]
        self.address <- map["address"]
        self.city <- map["city"]
        self.companySize <- map["companySize"]
        self.dateOfCreation <- map["dateOfCreation"]
        self.emailAddress <- map["emailAddress"]
        self.loc <- map["loc"]
        self.pincode <- map["pincode"]
        self.primaryUserId <- map["primaryUserId"]
        self.setVicinityMax <- map["setVicinityMax"]
        self.setVicinityMin <- map["setVicinityMin"]
        self.signUpType <- map["signUpType"]
        self.state <- map["state"]
        
    }
}
