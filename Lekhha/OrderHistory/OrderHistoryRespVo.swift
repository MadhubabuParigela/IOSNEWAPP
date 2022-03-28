//
//  OrderHistoryRespVo.swift
//  Lekhha
//
//  Created by USM on 23/11/21.
//

import Foundation
import ObjectMapper

class OrderHistoryRespVo: Mappable {
        
    var message:String?
    var result:[OrderHistoryResultVo]?
    var resultHistory:[ProductChangesList]?
    var status:String?
    var statusCode:Int?
    
    init(message:String?,result:[OrderHistoryResultVo]?,status:String?,statusCode:Int?, resultHistory:[ProductChangesList]?) {
        
        self.message = message
        self.result = result
        self.status = status
        self.statusCode = statusCode
        self.resultHistory = resultHistory
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        message <- map["message"]
        result <- map["result"]
        status <- map["STATUS_MSG"]
        statusCode <- map["STATUS_CODE"]
        resultHistory <- map["result"]
    }
}
/*
{
    "STATUS_MSG": "SUCCESS",
    "STATUS_CODE": 200,
    "result": [
        {
            "_id": "619d0218db9e1464aaeabf22",
            "vendorId": "619755e43b879d3b29797c2a",
            "vendorName": "NA",
            "accountId": "619755e43b879d3b29797c27",
            "accountEmailId": "vineela1622@gmail.com",
            "orderId": "5667",
            "status": true,
            "createdDate": "2021-11-23T00:00:00.000Z",
            "ordersList": [
                {
                    "productdetails": {
                        "_id": "619d0218db9e1464aaeabf18",
                        "id": null,
                        "accountId": "619755e43b879d3b29797c27",
                        "accountEmailId": "vineela1622@gmail.com",
                        "productUniqueNumber": "3456",
                        "productName": "tesddd",
                        "description": "ggfxccg",
                        "stockQuantity": 20,
                        "stockUnit": "619755e43b879d3b29797c28",
                        "expiryDate": "2021-11-23T00:00:00.000Z",
                        "purchaseDate": "2021-11-23T00:00:00.000Z",
                        "storageLocation1": "619755e43b879d3b29797c29",
                        "storageLocation2": "619d0218db9e1464aaeabf16",
                        "storageLocation3": "619d0218db9e1464aaeabf17",
                        "borrowed": null,
                        "lent": false,
                        "category": "NA",
                        "subCategory": "NA",
                        "otherCategoryName": null,
                        "otherSubCategoryName": null,
                        "priceUnit": "616fd4205041085a07d69b1a",
                        "price": 6000,
                        "unitPrice": 300,
                        "uploadType": "manual",
                        "status": true,
                        "orderId": "5667",
                        "vendorId": "619755e43b879d3b29797c2a",
                        "giveAwayStatus": false,
                        "shared": false,
                        "productStatus": "Available",
                        "productManuallyAddOrAutoMovedDate": "2021-11-23T00:00:00.000Z",
                        "addedByUserId": "619752ab3b879d3b29797c1a",
                        "productImages": [
                            {
                                "0": "619d0218db9e1464aaeabf18_0",
                                "1": "619d0218db9e1464aaeabf18_1",
                                "2": "619d0218db9e1464aaeabf18_2"
                            }
                        ]
                    },
                    "vendordetails": {
                        "_id": "619755e43b879d3b29797c2a",
                        "accountId": "619755e43b879d3b29797c27",
                        "accountEmailId": "vineela1622@gmail.com",
                        "vendorName": "NA",
                        "vendorDescription": "NA",
                        "category": "NA",
                        "subCategory": "NA",
                        "otherCategoryName": null,
                        "otherSubCategoryName": null,
                        "vendorCompany": "NA",
                        "vendorGSTIN": null,
                        "vendorLocation": null,
                        "vendorAddress": null,
                        "status": true,
                        "dateOfCreation": "2021-11-19T00:00:00.000Z",
                        "canEdit": false
                    },
                    "stockUnitDetails": [
                        {
                            "_id": "619755e43b879d3b29797c28",
                            "accountId": "619755e43b879d3b29797c27",
                            "stockUnitDescription": "NA",
                            "stockUnitName": "NA",
                            "isDefault": true,
                            "canEdit": false
                        }
                    ],
                    "storageLocationLevel1Details": [
                        {
                            "_id": "619755e43b879d3b29797c29",
                            "accountId": "619755e43b879d3b29797c27",
                            "slocName": "NA",
                            "slocDescription": "NA",
                            "hierachyLevel": 1,
                            "parentLocation": null,
                            "isDefault": true,
                            "canEdit": false
                        }
                    ],
                    "storageLocationLevel2Details": [],
                    "storageLocationLevel3Details": [],
                    "priceUnitDetails": [
                        {
                            "_id": "616fd4205041085a07d69b1a",
                            "priceUnitDescription": "Indian Rupees",
                            "priceUnit": "₹",
                            "status": true,
                            "isDefault": false,
                            "countryName": "IND"
                        }
                    ],
                    "updatingQuantity": 20,
                    "vendorApprovalStatus": "Pending",
                    "productModifingDetails": [
                        {
                            "changeType": "Add",
                            "modifiedDateTime": "2021-11-23 5:30:0",
                            "change": "add-currentinventory",
                            "addedByUserId": "619d0218db9e1464aaeabf21",
                            "userinfo": [
                                {
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
                                    "fcmToken": "fKjwTnxIQUa9qPsoe9zdR5:APA91bExBeAfuTwN7m-52hCmRA9yay2ALQ4JykLrmVY4ZXx9GE5S7CWcC8EHTtb1yuY6ymMkJquUwo0YLlKSVordFb14ajQZvmkC0_xiwiSO932LXZO4TEreuBQ2ugP4CBD6VhdblME3"
                                }
                            ],
                            "accountinfo": [
                                {
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
                                    }
                                }
                            ],
                            "message": "Product Ordered with quantity 20"
                        }
                    ]
                }
            ]
        }
    ]
}
 */
