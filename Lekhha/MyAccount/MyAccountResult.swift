//
//  MyAccountResult.swift
//  Lekha
//
//  Created by Mallesh Kurva on 05/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

//[
//    {
//        "_id": "5f6d80e4950eaf1c4bfea973",
//        "firstName": "madhura",
//        "lastName": "reddy",
//        "mobileNumber": "8019016448",
//        "salt": "0ec8df1225035e0392c673602bd2176f71223a5f8e0fda1abe2c50d13db0af0f",
//        "hash": "c3dd74841ccd8e9b5f70e440cc88e4ff1666ab47d30e9b19a8b831f9a697e582a383c5284343b625067c057c7a649c1dcdc08ce5c644bbb954c7a09c489723aa",
//        "status": true,
//        "dateOfCreation": "2020-09-25T05:32:20.473Z",
//        "dateOfBirth": "2020-09-22T00:00:00.000Z",
//        "mobileStatus": "Registered",
//        "gender": "female",
//        "mobileOTP": null,
//        "resetPasswordOtp": 2301
//    }
//]

class MyAccountResult: Mappable {
    
    var _id:String?
    var firstName:String?
    var lastName:String?
    var mobileNumber:String?
    var locDict:NSDictionary?

    init(_id:String?,firstName:String?,lastName:String?,mobileNumber:String?) {
        
        self._id = _id
        self.firstName = firstName
        self.lastName = lastName
        self.mobileNumber = mobileNumber
        
    }
    
    required init?(map: Map) {
        
    }

    
    func mapping(map: Map) {

        _id <- map["_id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        mobileNumber <- map["mobileNumber"]
        locDict <- map["loc"]
        
    }
}
