//
//  ApprovalList.swift
//  Lekha
//
//  Created by Mallesh Kurva on 23/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class ApprovalResult: Mappable {

    var _id:String?
    var accountDetails:ApprovalAccDetails?
    var approvalStatus:String?
    var emailAddress:String?
    var mobileNumber:String?
    var dateOfCreation:String?
    var userDetails:[ApprovalUserDetails]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {

        _id <- map["message"]
        accountDetails <- map["accountDetails"]
        approvalStatus <- map["approvalStatus"]
        emailAddress <- map["emailAddress"]
        mobileNumber <- map["mobileNumber"]
        userDetails <- map["userDetails"]
        dateOfCreation <- map["dateOfCreation"]

    }
}
