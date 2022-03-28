//
//  SelectAccResultVC.swift
//  Lekha
//
//  Created by Mallesh Kurva on 29/09/20.
//  Copyright © 2020 Longdom. All rights reserved.
//


//[
//    {
//        "_id": "5f6d816c950eaf1c4bfea975",
//        "userId": "5f6d80e4950eaf1c4bfea973",
//        "accountId": "5f6d8109950eaf1c4bfea974",
//        "primaryUser": "Yes",
//        "dateOfCreation": "2020-09-25T05:34:36.484Z",
//        "status": true,
//        "accountDetails": [
//            {
//                "_id": "5f6d8109950eaf1c4bfea974",
//                "emailAddress": "madhura2419@gmail.com",
//                "primaryMobileNumber": "8019016448",
//                "address": "sgg,fh,fh,xvb,fh,undefined",
//                "companyName": "gh",
//                "companySize": "10",
//                "accountStatus": "Registered",
//                "dateOfCreation": "2020-09-25T05:32:57.605Z",
//                "status": true,
//                "accountOTP": null
//            }
//        ]
//    }
//]

import Foundation
import ObjectMapper

class SelectAccResultVC: Mappable {
    
    var accDetails:AccountinfoVo?
    var _id:String?
    var userId:String?
    var modulePermissions:NSDictionary?
    var kycVerification:String?
    var gstIn:String?
    var legalName:String?
    var principalPlace:String?
    var constitution:String?
    var dateOfRegistration:String?
    var KYCVV:String?
    var rejectionComment:String?
    var primaryUser:String?
     init(accDetails:AccountinfoVo?,_id:String?,userId:String?,modulePermissions:NSDictionary?,kycVerification:String?,gstIn:String?,legalName:String?,principalPlace:String?,constitution:String?,dateOfRegistration:String?,KYCVV:String?,rejectionComment:String?,primaryUser:String?) {
        
        self.accDetails = accDetails
        self._id = _id
        self.userId = userId
        self.modulePermissions=modulePermissions
        self.kycVerification=kycVerification
        self.gstIn=gstIn
        self.legalName=legalName
        self.principalPlace=principalPlace
        self.constitution=constitution
        self.dateOfRegistration=dateOfRegistration
        self.KYCVV=KYCVV
        self.rejectionComment=rejectionComment
        self.primaryUser=primaryUser
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.accDetails <- map ["accountDetails"]
        self._id <- map["_id"]
        self.userId <- map["userId"]
        self.modulePermissions <- map["modulePermissions"]
        self.kycVerification <- map["kycVerification"]
        self.gstIn <- map["GSTIn"]
        self.legalName <- map["legalName"]
        self.principalPlace <- map["businessPlace"]
        self.constitution <- map["businessConstitution"]
        self.dateOfRegistration <- map["dateOfReg"]
        self.KYCVV <- map["kycVerification"]
        self.rejectionComment <- map["rejectionComment"]
        self.primaryUser <- map["primaryUser"]
    }
}

