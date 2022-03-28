//
//  GetAccountConsumerDetailsRespVo.swift
//  Lekhha
//
//  Created by USM on 27/11/21.
//

import Foundation
import ObjectMapper

class GetAccountConsumerDetailsRespVo: Mappable {
        
    var message:String?
    var result:[GetAccountConsumerResultVo]?
    var status:String?
    var statusCode:Int?
    
    init(message:String?,result:[GetAccountConsumerResultVo]?,status:String?,statusCode:Int?) {
        
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
             "_id": "619755e43b879d3b29797c2b",
             "userId": "619752ab3b879d3b29797c1a",
             "accountId": "619755e43b879d3b29797c27",
             "primaryUser": "Yes",
             "dateOfCreation": "2021-11-19T00:00:00.000Z",
             "status": true,
             "modulePermissions": {
                 "currentInventory_management": "Yes",
                 "openOrders_management": "Yes",
                 "shoppingCart_management": "Yes",
                 "orderHistory_management": "Yes",
                 "vendors_management": "Yes"
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
                 "landMark": "",
                 "pincode": "502032",
                 "accountUniqueId": "vineela_",
                 "companyName": "vineela_",
                 "companySize": "10-50",
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
                 "recordCount": 10026
             },
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
                 "dateOfBirth": "1996-11-19T00:00:00.000Z",
                 "mobileStatus": "Registered",
                 "gender": "male",
                 "longitude": "NaN",
                 "latitude": "NaN",
                 "countryCode": "IND",
                 "countryName": "India",
                 "loc": [],
                 "mobileOTP": 2764,
                 "fcmToken": null,
                 "resetPasswordOtp": 5728
             }
         }
     ]
 }
 */
/*[
    {
        "vendorId": "619755e43b879d3b29797c2a",
        "accountId": "619755e43b879d3b29797c27",
        "addproductList": [
            {
                "accountId": "619755e43b879d3b29797c27",
                "category": "NA",
                "description": "gssv",
                "expiryDate": "",
                "orderId": "",
                "price": 459522.0,
                "priceUnit": "616fd4205041085a07d69b1a",
                "productImages": [
                    {},
                    {},
                    {}
                ],
                "productName": "11111",
                "productUniqueNumber": "",
                "purchaseDate": "29/11/2021",
                "stockQuantity": 4689.0,
                "stockUnit": "619755e43b879d3b29797c28",
                "storageLocation": "619755e43b879d3b29797c29",
                "storageLocation1": "619755e43b879d3b29797c29",
                "subCategory": "NA",
                "unitPrice": 98.0,
                "uploadType": "manual",
                "userId": "619752ab3b879d3b29797c1a",
                "vendorId": "619755e43b879d3b29797c2a",
                "vendorName": "NA"
            },
            {
                "accountId": "619755e43b879d3b29797c27",
                "category": "NA",
                "description": "sys",
                "expiryDate": "",
                "orderId": "",
                "price": 64980370.0,
                "priceUnit": "616fd4205041085a07d69b1a",
                "productImages": [
                    {},
                    {},
                    {}
                ],
                "productName": "2222",
                "productUniqueNumber": "",
                "purchaseDate": "29/11/2021",
                "stockQuantity": 6565.0,
                "stockUnit": "619755e43b879d3b29797c28",
                "storageLocation": "619755e43b879d3b29797c29",
                "storageLocation1": "619755e43b879d3b29797c29",
                "subCategory": "NA",
                "unitPrice": 9898.0,
                "uploadType": "manual",
                "userId": "619752ab3b879d3b29797c1a",
                "vendorId": "619755e43b879d3b29797c2a",
                "vendorName": "NA"
            }
        ]
    },
    {
        "vendorId": "619755e43b879d3b29797c2a",
        "accountId": "619755e43b879d3b29797c27",
        "addproductList": [
            {
                "accountId": "619755e43b879d3b29797c27",
                "category": "NA",
                "description": "st fd",
                "expiryDate": "",
                "orderId": "",
                "price": 32041240.0,
                "priceUnit": "616fd4205041085a07d69b1a",
                "productImages": [
                    {},
                    {},
                    {}
                ],
                "productName": "33333",
                "productUniqueNumber": "",
                "purchaseDate": "30/11/2021",
                "stockQuantity": 5665.0,
                "stockUnit": "619755e43b879d3b29797c28",
                "storageLocation": "619755e43b879d3b29797c29",
                "storageLocation1": "619755e43b879d3b29797c29",
                "subCategory": "NA",
                "unitPrice": 5656.0,
                "uploadType": "manual",
                "userId": "619752ab3b879d3b29797c1a",
                "vendorId": "619755e43b879d3b29797c2a",
                "vendorName": "NA"
            }
        ]
    },
    {
        "vendorId": "61a47f96a5813e2ce9863d95",
        "accountId": "619755e43b879d3b29797c27",
        "addproductList": [
            {
                "accountId": "619755e43b879d3b29797c27",
                "category": "NA",
                "description": "egdg",
                "expiryDate": "",
                "orderId": "",
                "price": 96971.0,
                "priceUnit": "616fd4205041085a07d69b1a",
                "productImages": [
                    {},
                    {},
                    {}
                ],
                "productName": "4454",
                "productUniqueNumber": "",
                "purchaseDate": "29/11/2021",
                "stockQuantity": 49.0,
                "stockUnit": "619755e43b879d3b29797c28",
                "storageLocation": "619755e43b879d3b29797c29",
                "storageLocation1": "619755e43b879d3b29797c29",
                "subCategory": "NA",
                "unitPrice": 1979.0,
                "uploadType": "manual",
                "userId": "619752ab3b879d3b29797c1a",
                "vendorId": "61a47f96a5813e2ce9863d95",
                "vendorName": "yeye"
            },
            {
                "accountId": "619755e43b879d3b29797c27",
                "category": "NA",
                "description": "gsv",
                "expiryDate": "",
                "orderId": "",
                "price": 8036.0,
                "priceUnit": "616fd4205041085a07d69b1a",
                "productImages": [
                    {},
                    {},
                    {}
                ],
                "productName": "6666",
                "productUniqueNumber": "",
                "purchaseDate": "29/11/2021",
                "stockQuantity": 49.0,
                "stockUnit": "619755e43b879d3b29797c28",
                "storageLocation": "619755e43b879d3b29797c29",
                "storageLocation1": "619755e43b879d3b29797c29",
                "subCategory": "NA",
                "unitPrice": 164.0,
                "uploadType": "manual",
                "userId": "619752ab3b879d3b29797c1a",
                "vendorId": "61a47f96a5813e2ce9863d95",
                "vendorName": "yeye"
            }
        ]
    },
    {
        "vendorId": "61a47f96a5813e2ce9863d95",
        "accountId": "619755e43b879d3b29797c27",
        "addproductList": [
            {
                "accountId": "619755e43b879d3b29797c27",
                "category": "NA",
                "description": "gs",
                "expiryDate": "",
                "orderId": "dhdhvd",
                "price": 2576.0,
                "priceUnit": "616fd4205041085a07d69b1a",
                "productImages": [
                    {},
                    {},
                    {}
                ],
                "productName": "5555",
                "productUniqueNumber": "",
                "purchaseDate": "29/11/2021",
                "stockQuantity": 46.0,
                "stockUnit": "619755e43b879d3b29797c28",
                "storageLocation": "619755e43b879d3b29797c29",
                "storageLocation1": "619755e43b879d3b29797c29",
                "subCategory": "NA",
                "unitPrice": 56.0,
                "uploadType": "manual",
                "userId": "619752ab3b879d3b29797c1a",
                "vendorId": "61a47f96a5813e2ce9863d95",
                "vendorName": "yeye"
            }
        ]
    }
]
*/

