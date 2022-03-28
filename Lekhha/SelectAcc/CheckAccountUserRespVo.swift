//
//  CheckAccountUserRespVo.swift
//  Lekhha
//
//  Created by USM on 01/02/22.
//

import Foundation
import ObjectMapper

class CheckAccountUserRespVo: Mappable {
    
    var message:String?
    var result:[CheckAccountUserResultVo]?
    var status:String?
    var statusCode:Int?
    var isRejected: Bool?

    init(message:String?,result:[CheckAccountUserResultVo]?,status:String?,statusCode:Int?,isRejected: Bool?) {
        self.message = message
        self.result = result
        self.status = status
        self.statusCode = statusCode
        self.isRejected = isRejected

    }
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
        self.message <- map ["message"]
        self.result <- map ["result"]
        self.status <- map ["STATUS_MSG"]
        self.statusCode <- map["STATUS_CODE"]
        self.isRejected <- map["isRejected"]
    }
}
class CheckAccountUserResultVo: Mappable {
    
    var _id: String?
    var userId: String?
    var accountId: String?
    var primaryUser: String?
    var dateOfCreation: String?
    var status: Bool?
    var modulePermissions: NSDictionary?
    var accountDetails: AccountinfoVo?
    var userDetails: UserinfoVo?
//    ModulePermissionsVo

    init(_id: String?,
          userId: String?,
          accountId: String?,
          primaryUser: String?,
          dateOfCreation: String?,
          status: Bool?,
          modulePermissions: NSDictionary?,
          accountDetails: AccountinfoVo?,
          userDetails: UserinfoVo?) {

    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        _id <- map ["_id"]
        userId <- map ["userId"]
        accountId <- map ["accountId"]
        primaryUser <- map ["primaryUser"]
        dateOfCreation <- map ["dateOfCreation"]
        status <- map ["status"]
        modulePermissions <- map ["modulePermissions"]
        accountDetails <- map ["accountDetails"]
        userDetails <- map ["userDetails"]
        
    }
}
/*
 {
     "STATUS_MSG": "SUCCESS",
     "STATUS_CODE": 200,
     "result": [
         {
             "_id": "61f8b93d0b5fc76fefc64ebf",
             "userId": "61f8b9220b5fc76fefc64eba",
             "accountId": "61f8b93d0b5fc76fefc64ebb",
             "primaryUser": "Yes",
             "dateOfCreation": "2022-02-01T00:00:00.000Z",
             "status": true,
             "modulePermissions": {
                 "currentInventory_management": "Yes",
                 "openOrders_management": "Yes",
                 "shoppingCart_management": "Yes",
                 "orderHistory_management": "Yes",
                 "vendors_management": "Yes"
             },
             "accountDetails": {
                 "_id": "61f8b93d0b5fc76fefc64ebb",
                 "emailAddress": "shailesh.gupta@gmail.com",
                 "primaryMobileNumber": "9827940166",
                 "address01": "SVS PALMS 1, Dodda Nekkundi Extension, Doddanekkundi, Bengaluru, Karnataka 560037, India",
                 "address02": " Dodda Nekkundi Extension",
                 "street": " Doddanekkundi",
                 "city": " Bengaluru",
                 "state": "616fd5365041085a07d69b1b",
                 "landMark": "",
                 "pincode": "502032",
                 "accountUniqueId": "SGupta",
                 "companyName": "SGupta",
                 "companySize": "1-10",
                 "accountStatus": "Registered",
                 "dateOfCreation": "2022-02-01T00:00:00.000Z",
                 "status": true,
                 "vendorName": "SGupta",
                 "setVicinityMax": 10,
                 "setVicinityMin": 0,
                 "loc": {
                     "type": "Point",
                     "coordinates": [
                         12.9726942377187,
                         77.70574796944857
                     ]
                 }
             },
             "userDetails": {
                 "_id": "61f8b9220b5fc76fefc64eba",
                 "userId": "Db7h0ugQ",
                 "firstName": "First Name",
                 "lastName": "Last Name",
                 "mobileNumber": "9827940166",
                 "salt": "610046391eda0ef8aa7d68c79b7cf6392e06b12e033fed9b7c925dd988162aa9",
                 "hash": "7c22ccd80de793d399e14f132ae97c28cda649444fd4e73069fb66b71afbc829875d874049c5feb43e040384473a187500459ed3b29df352fcec534229500582",
                 "status": true,
                 "dateOfCreation": "2022-02-01T00:00:00.000Z",
                 "mobileStatus": "Registered",
                 "gender": "male",
                 "longitude": "NaN",
                 "latitude": "NaN",
                 "countryCode": "IND",
                 "countryName": "India",
                 "loc": [],
                 "mobileOTP": 3942,
                 "fcmToken": null
             }
         }
     ],
     "isRejected": false,
     "message": "success"
 }
 */
