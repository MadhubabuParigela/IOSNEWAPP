//
//  OpenOrdersProducts.swift
//  Lekha
//
//  Created by Mallesh Kurva on 17/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class OpenOrdersProducts: Mappable {
    
    var _id : String?
    var accountId : String?
    var productDetails : OpenOrdersProductDetails?
    var trancationId : String?
    var productId : String?
    var plannedPurchasedate : String?
    var prefferedVendorId : String?
    var vendordetails : NSDictionary?
    var unitPrice: Float?
    var stockUnitDetails:[ShoppingStockUnitDetailsVo]?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {

        _id <- map["message"]
        accountId <- map["result"]
        productDetails <- map["productdetails"]
        productId <- map["productId"]
        trancationId <- map["trancationId"]
        productId <- map["productId"]
        plannedPurchasedate <- map["plannedPurchasedate"]
        prefferedVendorId <- map["prefferedVendorId"]
        vendordetails <- map["vendordetails"]
        unitPrice <- map["unitPrice"]
        stockUnitDetails <- map["stockUnitDetails"]
    }
}
/*
 {
     "productdetails": {
         "_id": "61bc1f144f7c8e34ffaaa7d7",
         "id": 0,
         "accountId": "61bc128d5a3c6915fbb648ce",
         "accountEmailId": "mounika.4560@gmail.com",
         "productUniqueNumber": "773737",
         "productName": "Djjddjdd",
         "description": "Hsjsjs",
         "stockQuantity": 55,
         "stockUnit": "61bc128d5a3c6915fbb648cf",
         "priceUnit": "616fd4205041085a07d69b1a",
         "price": 275,
         "unitPrice": 5,
         "borrowed": false,
         "lent": false,
         "shared": false,
         "status": true,
         "vendorId": "61bc128d5a3c6915fbb648d1",
         "category": "Appliances",
         "subCategory": "Heating & Cooling",
         "uploadType": "Manual",
         "giveAwayStatus": false,
         "otherCategoryName": null,
         "otherSubCategoryName": null,
         "purchaseDate": "2021-12-17T00:00:00.000Z",
         "expiryDate": null,
         "storageLocation1": "61bc1f144f7c8e34ffaaa7d3",
         "storageLocation2": "61bc1f144f7c8e34ffaaa7d4",
         "storageLocation3": "61bc1f144f7c8e34ffaaa7d5",
         "productStatus": "Ordered",
         "productManuallyAddOrAutoMovedDate": "2021-12-17T00:00:00.000Z",
         "addedByUserId": "61bc1f144f7c8e34ffaaa7d6",
         "productImages": [
             {
                 "0": "61bc1f144f7c8e34ffaaa7d7_0",
                 "1": "61bc1f144f7c8e34ffaaa7d7_1",
                 "2": "61bc1f144f7c8e34ffaaa7d7_2"
             }
         ],
         "orderId": "10001"
     },
     "vendordetails": {
         "_id": "61bc128d5a3c6915fbb648d1",
         "accountId": "61bc128d5a3c6915fbb648ce",
         "accountEmailId": "mounika.4560@gmail.com",
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
         "dateOfCreation": "2021-12-17T00:00:00.000Z",
         "canEdit": false
     },
     "stockUnitDetails": [
         {
             "_id": "61bc128d5a3c6915fbb648cf",
             "accountId": "61bc128d5a3c6915fbb648ce",
             "stockUnitDescription": "NA",
             "stockUnitName": "NA",
             "isDefault": true,
             "canEdit": false
         }
     ],
     "storageLocationLevel1Details": [],
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
     "updatingQuantity": 55,
     "vendorApprovalStatus": "NotRequired",
     "productModifingDetails": [
         {
             "changeType": "Add",
             "modifiedDateTime": "2021-12-17 15:18:29",
             "change": "add",
             "addedByUserId": "61bc1f144f7c8e34ffaaa7d6",
             "userinfo": [],
             "accountinfo": [
                 {
                     "_id": "61bc128d5a3c6915fbb648ce",
                     "emailAddress": "mounika.4560@gmail.com",
                     "primaryMobileNumber": "9502264256",
                     "address01": "270/E",
                     "address02": "Kondapur",
                     "street": "Road Number 10",
                     "city": "Hyderabad",
                     "state": "616fd6ae5041085a07d69b32",
                     "landMark": "Leitungswasser",
                     "pincode": "502032",
                     "accountUniqueId": "mouni_",
                     "companyName": "mouni_",
                     "companySize": "100-500",
                     "accountStatus": "Registered",
                     "dateOfCreation": "2021-12-17T00:00:00.000Z",
                     "status": true,
                     "vendorName": "mouni_",
                     "setVicinityMax": 10,
                     "setVicinityMin": 0,
                     "loc": {
                         "type": "Point",
                         "coordinates": [
                             0,
                             0
                         ]
                     },
                     "recordCount": 10001
                 }
             ],
             "availableStockQuantity": 55,
             "changedStockQuantity": 55,
             "updatedProductStatus": "Ordered",
             "currentProductStatus": "Ordered",
             "message": "Product Ordered with quantity 55"
         }
     ]
 }
 */
