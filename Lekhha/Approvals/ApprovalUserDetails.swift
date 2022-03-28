//
//  ApprovalUserDetails.swift
//  Lekha
//
//  Created by Mallesh Kurva on 23/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class ApprovalUserDetails: Mappable {
    
    var _id:String?
    var firstName:String?
    var lastName:String?
    var mobileNumber:String?
    var mobileStatus:String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {

        _id <- map["_id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        mobileNumber <- map["mobileNumber"]
        mobileStatus <- map["mobileStatus"]

    }
}
