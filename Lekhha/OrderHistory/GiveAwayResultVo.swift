//
//  GiveAwayResultVo.swift
//  Lekhha
//
//  Created by USM on 18/01/22.
//

import Foundation
import ObjectMapper

class GiveAwayResultVo: Mappable {
    
    var _id: String?
    var productId: String?
    var dateOfCreation: String?
    var accountId: String?
    var status: Bool?
    var offeredPrice: Double?
    var offeredQuantity: Double?
    var accountDetails:AccountinfoVo?
    var productDetails:ProductdetailsVo?
    var stockUnitDetails:[StockUnitDetailsVo]?
    var storageLocationLevel1Details:[StorageLocationLevel1DetailsVo]?
    var storageLocationLevel2Details:[StorageLocationLevel2DetailsVo]?
    var storageLocationLevel3Details:[StorageLocationLevel3DetailsVo]?
    var priceUnitDetails:[PriceUnitDetailsVo]?
    
    
    init(_id: String?,
          productId: String?,
          dateOfCreation: String?,
          accountId: String?,
          status: Bool?,
          offeredPrice: Double?,
          offeredQuantity: Double?,
          accountDetails:AccountinfoVo?,
          productDetails:ProductdetailsVo?,
          stockUnitDetails:[StockUnitDetailsVo]?,
          storageLocationLevel1Details:[StorageLocationLevel1DetailsVo]?,
          storageLocationLevel2Details:[StorageLocationLevel2DetailsVo]?,
          storageLocationLevel3Details:[StorageLocationLevel3DetailsVo]?,
          priceUnitDetails:[PriceUnitDetailsVo]?) {
        
        self._id = _id
        self.productId = productId
        self.dateOfCreation = dateOfCreation
        self.accountId = accountId
        self.status = status
        self.offeredPrice = offeredPrice
        self.offeredQuantity = offeredQuantity
        self.accountDetails = accountDetails
        self.productDetails = productDetails
        self.stockUnitDetails = stockUnitDetails
        self.storageLocationLevel1Details = storageLocationLevel1Details
        self.storageLocationLevel2Details = storageLocationLevel2Details
        self.storageLocationLevel3Details = storageLocationLevel3Details
        self.priceUnitDetails = priceUnitDetails
    }
    
    required init?(map: Map) {
                
    }
    
    func mapping(map: Map) {
        
        self._id  <- map ["_id"]
        self.productId <- map ["productId"]
        self.dateOfCreation <- map ["dateOfCreation"]
        self.accountId <- map ["accountId"]
        self.status <- map ["status"]
        self.offeredPrice <- map ["offeredPrice"]
        self.offeredQuantity <- map ["offeredQuantity"]
        self.accountDetails <- map ["accountDetails"]
        self.productDetails <- map ["productDetails"]
        self.stockUnitDetails <- map ["stockUnitDetails"]
        self.storageLocationLevel1Details <- map ["storageLocationLevel1Details"]
        self.storageLocationLevel2Details <- map ["storageLocationLevel2Details"]
        self.storageLocationLevel3Details <- map ["storageLocationLevel3Details"]
        self.priceUnitDetails <- map ["priceUnitDetails"]

    }
}
/*
 {
     "_id": "61e53d478ec5257d7aa0424e",
     "productId": "61e539888ec5257d7aa0423d",
     "dateOfCreation": "2022-01-17T00:00:00.000Z",
     "accountId": "61e147b574794a579696a0ce",
     "status": true,
     "offeredPrice": 812.25,
     "offeredQuantity": 28.5,
     "accountDetails": {
         "_id": "61e147b574794a579696a0ce",
         "emailAddress": "sgupta.scm@gmail.com",
         "primaryMobileNumber": "9900025784",
         "address01": "Suncity Apartment ",
         "address02": "2nd Cross Road",
         "street": "Chinnappanahalli",
         "city": "Bengaluru",
         "state": "616fd5dd5041085a07d69b25",
         "landMark": "nearby",
         "pincode": "502032",
         "accountUniqueId": "ShaileshGupta",
         "companyName": "ShaileshGupta",
         "companySize": "1-10",
         "accountStatus": "Registered",
         "dateOfCreation": "2022-01-14T00:00:00.000Z",
         "status": true,
         "vendorName": "ShaileshGupta",
         "setVicinityMax": 10,
         "setVicinityMin": 0,
         "loc": {
             "type": "Point",
             "coordinates": [
                 12.925505346179099,
                 77.6654326915741
             ]
         },
         "accountOTP": null,
         "recordCount": 10024
     },
     "productDetails": {
         "_id": "61e539888ec5257d7aa0423d",
         "id": null,
         "accountId": "61e147b574794a579696a0ce",
         "accountEmailId": "sgupta.scm@gmail.com",
         "productUniqueNumber": "8906036670885",
         "productName": "KMF Products",
         "description": "Nandini Pure Ghee / Tuppa, 1 L Pouch",
         "stockQuantity": 28.5,
         "stockUnit": "61e16c4a38daba5b4f1c5da1",
         "expiryDate": null,
         "purchaseDate": "2022-01-18T00:00:00.000Z",
         "storageLocation1": "61e16cbf38daba5b4f1c5da3",
         "storageLocation2": "61e539888ec5257d7aa0423b",
         "storageLocation3": "61e539888ec5257d7aa0423c",
         "borrowed": null,
         "lent": false,
         "category": "NA",
         "subCategory": "NA",
         "otherCategoryName": null,
         "otherSubCategoryName": null,
         "priceUnit": "616fd4205041085a07d69b1a",
         "price": 812.25,
         "unitPrice": 28.5,
         "uploadType": "manual",
         "status": true,
         "orderId": "L10022",
         "vendorId": "61e147b574794a579696a0d1",
         "giveAwayStatus": true,
         "shared": false,
         "productStatus": "Available",
         "productManuallyAddOrAutoMovedDate": "2022-01-17T00:00:00.000Z",
         "addedByUserId": "61e1442a74794a579696a0c6",
         "productImages": [
             {
                 "0": "61e539888ec5257d7aa0423d_0",
                 "1": "61e539888ec5257d7aa0423d_1",
                 "2": "61e539888ec5257d7aa0423d_2"
             }
         ]
     },
     "stockUnitDetails": [
         {
             "_id": "61e16c4a38daba5b4f1c5da1",
             "accountId": "61e147b574794a579696a0ce",
             "stockUnitDescription": "Piece",
             "stockUnitName": "PC",
             "isDefault": true,
             "canEdit": true
         }
     ],
     "storageLocationLevel1Details": [
         {
             "_id": "61e16cbf38daba5b4f1c5da3",
             "accountId": "61e147b574794a579696a0ce",
             "slocName": "Kitchen ",
             "slocDescription": "Kitchen ",
             "hierachyLevel": 1,
             "parentLocation": "",
             "isDefault": true,
             "canEdit": true
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
     ]
 }
 */
