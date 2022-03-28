//
//  GetAccountVendorDetailResp.swift
//  Lekhha
//
//  Created by USM on 30/11/21.
//

import Foundation
import ObjectMapper

class GetAccountVendorDetailResp: Mappable {
        
    var message:String?
    var result:[GetAccountVendorDetailResultVo]?
    var status:String?
    var statusCode:Int?
    
    init(message:String?,result:[GetAccountVendorDetailResultVo]?,status:String?,statusCode:Int?) {
        
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
/*
 {
     "STATUS_MSG": "SUCCESS",
     "STATUS_CODE": 200,
     "result": [
         {
             "_id": "619755e43b879d3b29797c2c",
             "userId": "619752ab3b879d3b29797c1a",
             "accountId": "619755e43b879d3b29797c27",
             "primaryUser": "Yes",
             "setVicinity": 10,
             "soonToexpiryLeadTime": 89,
             "dateOfCreation": "2021-11-19T00:00:00.000Z",
             "status": true,
             "modulePermissions": {
                 "currentInventory_management": "Yes",
                 "openOrders_management": "Yes",
                 "shoppingCart_management": "Yes",
                 "orderHistory_management": "Yes",
                 "vendors_management": "Yes"
             },
             "kycVerification": "Approved",
             "GSTIn": "zbzhxbdghxdhddh",
             "aadharNumber": 0,
             "panNumber": "",
             "businessConstitution": "zhsb",
             "businessPlace": "sggs",
             "dateOfReg": "19/11/2021",
             "legalName": "sgsg",
             "rejectionComment": "null",
             "userDetails": {
                 "_id": "619752ab3b879d3b29797c1a",
                 "userId": "wVciQelw",
                 "firstName": "Vineela",
                 "lastName": "Venkat",
                 "mobileNumber": "9963408545",
                 "salt": "8afda6f4e3ad7cef44075e8d9acaaca34ee1c185068bc01a29461fa79c7c1066",
                 "hash": "e749ab6b42d06e0c0c66f5534838fdebe8b798db570c7f531a419a303b43bee76ef2504eb4f0fffce750022248b6d792ffe5b866e942a41cf50bba5f4e5e0842",
                 "status": true,
                 "dateOfCreation": "2021-11-19T00:00:00.000Z",
                 "dateOfBirth": "2021-11-29",
                 "mobileStatus": "Registered",
                 "gender": "male",
                 "longitude": "NaN",
                 "latitude": "NaN",
                 "countryCode": "IND",
                 "countryName": "India",
                 "loc": [],
                 "mobileOTP": 2764,
                 "fcmToken": "cLFPmAc-TQWZTYWBhvZZfU:APA91bGHr_FYFcxCvoSdF2IGmPKFLELNLA27flfhc05aG9X_g_CGTu0PoVs9IsY0GaZBpmNUWYGEZqgrZePy4iHj7J8kMYG-FAC9GiLKnKqarzR_I4RWBXJoF0GG4gtJH5qeN5WNmWzn",
                 "resetPasswordOtp": 5728
             },
             "accountDetails": {
                 "_id": "619755e43b879d3b29797c27",
                 "emailAddress": "vineela1622@gmail.com",
                 "primaryMobileNumber": "9963408545",
                 "address01": "102, Shirdi Sai Colony, Beeramguda, Ramachandrapuram, Telangana 502032, India",
                 "address02": "",
                 "street": "",
                 "city": "Ramachandrapuram",
                 "state": "616fd5365041085a07d69b1b",
                 "landMark": "near sn",
                 "pincode": "502032",
                 "accountUniqueId": "vineela_",
                 "companyName": "vineela_",
                 "companySize": "50-100",
                 "accountStatus": "Registered",
                 "dateOfCreation": "2021-11-19T00:00:00.000Z",
                 "status": true,
                 "vendorName": "vineela_",
                 "setVicinityMax": 3,
                 "setVicinityMin": 0,
                 "loc": {
                     "type": "Point",
                     "coordinates": [
                         17.5110432,
                         78.3023606
                     ]
                 },
                 "recordCount": 10084
             }
         }
     ]
 }
 */
