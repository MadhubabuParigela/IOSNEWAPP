//
//  ApprovalAccDetails.swift
//  Lekha
//
//  Created by Mallesh Kurva on 23/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class ApprovalAccDetails: Mappable {

    var _id:String?
    var accountStatus:String?
    var address:String?
    var companyName:String?
    var companySize:String?
    var emailAddress:String?
    var primaryMobileNumber:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {

        _id <- map["_id"]
        accountStatus <- map["accountStatus"]
        address <- map["address"]
        companyName <- map["companyName"]
        companySize <- map["companySize"]
        emailAddress <- map["emailAddress"]
        primaryMobileNumber <- map["primaryMobileNumber"]

    }
}
